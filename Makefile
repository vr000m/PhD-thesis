# ================================================================================================
# Generic Makefile for a LaTeX paper -- this requires GNU make.
# Colin Perkins <csp@csperkins.org>

# This is the basename for the LaTeX source.  The files $(TEX_BASE).tex and
# $(TEX_BASE).bib should exist, and contain the paper text and bibliography.
# The $(TEX_STATIC) and $(TEX_GENERATED) variables should include all .tex 
# files included (\input) into $(TEX_BASE).tex (full filenames, including
# the .tex extension). The $(TEX_GENERATED) files are produced by running
# this Makefile, and will be removed by "make clean"; the $(TEX_STATIC)
# files are static and are not removed.
TEX_BASE      = dissertation
TEX_STATIC    = chapters/_0lists.tex \
				chapters/_0symbols.tex \
                chapters/_1intro.tex \
                chapters/_3rtp.tex \
                chapters/_4fw.tex \
                chapters/_5rtc.tex \
                chapters/_6ercc.tex \
                chapters/_7mprtp.tex \
                chapters/_8nwc.tex \
                chapters/_9conc.tex

TEX_BIB = bib/diss.bib \
          bib/rfc.bib

TEX_GENERATED = 

# A list of any graphics file included in the LaTeX document. These must be
# in PDF format, and the filenames must include the .pdf extension. Those
# files listed in $(GRAPHICS_GENERATED) should be built by this Makefile;
# they will be removed by "make clean". The files in $(GRAPHICS_STATIC) are 
# static figures which are not removed by "make clean".
GRAPHICS_GENERATED = 

GRAPHICS_STATIC    =    graphs/chap8_graph_3g_tmmbr_b.pdf \
                        graphs/chap8_graph_3g_tmmbr_a.pdf \
                        graphs/chap8-graph_route_thin_throughput.pdf \
                        graphs/chap8-graph-sim7-3.pdf \
                        graphs/chap8-fig-tmmbr.pdf \
                        graphs/chap8-fig-ota-tr-net-02.pdf \
                        graphs/chap8-fig-glass-oper-05.pdf \
                        graphs/chap8-fig-ecv.pdf \
                        graphs/chap7_graph_bb_3g_s17075-2p3-2.pdf \
                        graphs/chap7-graph_variable_bw_13073-2p5-2.pdf \
                        graphs/chap7-fig_mprtp-1.pdf \
                        graphs/chap7-fig-mprtp-stack.pdf \
                        graphs/chap6-graph-ssa_adapt.pdf \
                        graphs/chap6-graph-slicesize_mot.pdf \
                        graphs/chap6-graph-rpsi-5.pdf \
                        graphs/chap6-graph-rpsi-3.pdf \
                        graphs/chap6-graph-rpsi-1.pdf \
                        graphs/chap6-fig-fecrc-concept.pdf \
                        graphs/chap6-fig-fecrc-state.pdf \
                        graphs/chap6-graph-fecrc-dummynet-50ms-2.pdf \
                        graphs/chap6-graph-fecrc-dummynet-100ms-2.pdf \
                        graphs/chap6-graph-fecrc-var-50ms-2.pdf \
                        graphs/chap6-graph-fecrc-var-100ms-2.pdf \
                        graphs/chap6-graph-fecrc-var-240ms-2.pdf \
                        graphs/chap6-fig-apply-err.pdf \
                        graphs/chap5_graph_sl_tmmbr.pdf \
                        graphs/chap5_graph_sl_tfrc.pdf \
                        graphs/chap5_graph_sl_cnadu.pdf \
                        graphs/chap5_graph_3g_tmmbr_u.pdf \
                        graphs/chap5_graph_3g_tfrc_1.pdf \
                        graphs/chap5_graph_3g_cnadu.pdf \
                        graphs/chap5-graph-rrtcc-three-calls-sync.pdf \
                        graphs/chap5-graph-rrtcc-three-calls-async.pdf \
                        graphs/chap5-graph-rrtcc-plr.pdf \
                        graphs/chap5-graph-rrtcc-latency.pdf \
                        graphs/chap5-graph-5rtp_uc1_15.pdf \
                        graphs/chap5-graph-5rtp_uc1_14.pdf \
                        graphs/chap5-graph-5rtp_uc1_13.pdf \
                        graphs/chap5-graph-5rtp_uc1_12.pdf \
                        graphs/chap5-fig-cc-scheme-s.pdf \
                        graphs/chap5-fig-cc-scheme-r.pdf \
                        graphs/chap5-fig-cc-scheme-c.pdf \
                        graphs/chap4_graph_cb_loss_trr.pdf \
                        graphs/chap4_graph_cb_cmp_trr_2s.pdf \
                        graphs/chap4_graph_cb_bursty.pdf \
                        graphs/chap4_graph_cb_20090707-1515-barcode.pdf \
                        graphs/chap4_graph_20091011-2012-barcode.pdf \
                        graphs/chap4_fig_sim_topology.pdf \
                        graphs/chap4-fig-knee-cliff.pdf \
                        graphs/chap4-fig-fw-outline.pdf \
                        graphs/chap3_fig_hdr_rtp.pdf \
                        graphs/chap3_fig_hdr_rtcp.pdf \
                        graphs/chap3_fig_hdr_pt_fmt.pdf \
                        graphs/chap3-fig-sig-med.pdf \
                        graphs/chap3-fig-rtp-stack.pdf \
                        graphs/chap3-fig-rtp-rtcp.pdf \
                        graphs/chap3-fig-avpf-rtcp.pdf


all: $(TEX_BASE).pdf $(TEX_BASE).fonts $(TEX_BASE).info 


# ================================================================================================
# No user-servicable parts below

REGEX_CITE = "LaTeX Warning: Citation.*undefined"
REGEX_LABL = "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right."
BLANK_LINE = "================================================================================"

# The pdffonts tool is part of Xpdf (http://www.foolabs.com/xpdf/). You can
# build Xpdf without installing freetype, and this will build pdffonts (and
# some other command line tools), but not the Xpdf graphical viewer (tested 
# on MacOS X 10.7.2 with xpdf-3.03).
$(TEX_BASE).fonts: $(TEX_BASE).pdf
	@pdffonts $(TEX_BASE).pdf > $(TEX_BASE).fonts
	@nmf=`cat $(TEX_BASE).fonts | tail -n +3 | awk '{if ($$4 != "yes") print $0}' | wc -l`; \
   if [ $$nmf -gt 0 ]; then \
     echo "*** WARNING: some fonts are not embedded"; \
     cat $(TEX_BASE).fonts; \
     echo ""; \
     echo "Try running \"updmap --edit\" and setting \"pdftexDownloadBase14 true\""; \
     echo "$(BLANK_LINE)"; \
   fi

# The pdfinfo tool is also part of Xpdf (http://www.foolabs.com/xpdf/).
$(TEX_BASE).info: $(TEX_BASE).pdf
	@pdfinfo $(TEX_BASE).pdf > $(TEX_BASE).info
	@cat $(TEX_BASE).info
	@echo "$(BLANK_LINE)"

# Ghostscript (gs) is used to post-process the output to embed all fonts.
# The pdfopt tool also is part of Ghostscript, and linearises the output 
# in order to speed up rendering.
$(TEX_BASE).pdf: $(TEX_BASE).tex $(TEX_BIB) $(TEX_STATIC) $(TEX_GENERATED) $(GRAPHICS_STATIC) $(GRAPHICS_GENERATED) 
	@done_bib=0; \
	 do_bib=0; \
	 do_tex=1; \
	 while [ $$do_tex = 1 ]; do \
	 echo $(BLANK_LINE); \
	   pdflatex -halt-on-error $(TEX_BASE).tex; \
	   if [ $$? = 1 ]; then \
	     exit; \
	   fi; \
	   undef_cite=`grep -c $(REGEX_CITE) $(TEX_BASE).log`; \
	   if [ $$undef_cite != 0 ]; then \
	     do_bib=1;\
	   fi; \
	   \
	   for f in `grep '\\\bibdata{' ${TEX_BASE}.aux | sed 's/\\\bibdata{//' | sed 's/}//'`; \
	   do \
	     if [ $$f.bib -nt ${TEX_BASE}.bbl ]; then \
	       do_bib=1; \
	     fi; \
	   done; \
	   \
	   do_tex=`grep -c $(REGEX_LABL) $(TEX_BASE).log`; \
	   \
	   if [ $$do_bib = 1 ]; then \
		   if [ $$done_bib = 0 ]; then \
	       echo $(BLANK_LINE); \
	       bibtex ${TEX_BASE}; \
	       if [ $$? = 1 ]; then \
	         exit; \
	       fi; \
	       do_tex=1; \
	       do_bib=0; \
				 done_bib=1; \
	     fi; \
	   fi; \
	 done; \
	 gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$(TEX_BASE).pdftmp -dCompatibilityLevel=1.5 -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dSubsetFonts=true $(TEX_BASE).pdf; \
	 pdfopt $(TEX_BASE).pdftmp $(TEX_BASE).pdf; \
	 rm $(TEX_BASE).pdftmp; \
	 echo $(BLANK_LINE)

clean: 
	-rm -f $(TEX_BASE).pdf $(TEX_BASE).aux $(TEX_BASE).log $(TEX_BASE).blg $(TEX_BASE).bbl $(TEX_BASE).out $(TEX_BASE).fonts $(TEX_BASE).info 

# vim: set ts=2 sw=2 tw=0 ai:
