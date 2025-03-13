# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name	: cl_dom_dump.4gl
# Program ver.	: 7.0
# Description	: Dump Dom-Tree of runtime system.
# Date & Author	: 2004/05/27 by Brendan
# Memo        	:
# Sample	: CALL cl_dom_dump()
# Modify   	:
#}

DATABASE ds

GLOBALS "../../config/top.global"

#[
# Description  	: Dump Dom-Tree of runtime system.
# Date & Author	: 2004/05/27 by Brendan
# Parameter   	: none
# Return   	: void
# Memo        	: 
# Modify   	:
#]
FUNCTION cl_dom_dump()
  DEFINE ln_root   om.DomNode
  DEFINE ls_file   STRING,
         ls_msg    STRING,
         ls_cmd    STRING


  WHENEVER ERROR CALL cl_err_msg_log

  IF NOT cl_confirm("Ready to dump Dom-Tree of current runtime ?") THEN
     RETURN
  END IF
  LET ln_root = ui.Interface.getRootNode()
  LET ls_file = g_prog CLIPPED, "_", FGL_GETPID() USING "<<<<<<<<<<", ".xml"
  CALL ln_root.writeXml(ls_file)
  IF STATUS THEN
     CALL cl_err("Create file failed.", "!", 1)
     RETURN
  END IF
  LET ls_msg = "'", FGL_GETENV("TEMPDIR"), "/", ls_file, "' has been generated.\n",
               "Do you want to view it for now ?"
  IF cl_confirm(ls_msg) THEN
     IF FGL_GETENV('FGLRUN') IS NULL THEN
        LET ls_cmd = "fglrun"
     ELSE
        LET ls_cmd = FGL_GETENV('FGLRUN')
     END IF
     LET ls_cmd = ls_cmd CLIPPED, " $TOP/azz/42r/p_view.42r ", ls_file, " 660 1"
     RUN ls_cmd
  END IF
END FUNCTION
