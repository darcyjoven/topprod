# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_sel_serip.4gl
# Descriptions...: 內部IP使用者/外部IP使用者切換的功能
# Date & Author..: 2006/06/29 by alexstar
# Usage..........: CALL cl_sel_serip()
# Modify.........: No.TQC-670049 06/07/13 by saki VARCHAR->CHAR
# Modify.........: No.FUN-670010 06/07/31 by alexstar 當user為內部使用者時，只可切換為外部使用者，反之亦然
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
DEFINE g_sel_in  LIKE ze_file.ze03     #No.FUN-690005  VARCHAR(30)   #No.TQC-670049
DEFINE g_sel_out LIKE ze_file.ze03     #No.FUN-690005  VARCHAR(30)   #No.TQC-670049
DEFINE gi_cnt    LIKE type_file.num10  #No.FUN-690005  INTEGER
DEFINE g_ip_location  LIKE type_file.chr1    #No.FUN-690005  VARCHAR(1)
DEFINE gw_win   ui.Window
DEFINE gn_win   om.DomNode
 
CONSTANT TIMEOUT INTEGER = 300
 
FUNCTION cl_sel_serip()
   DEFINE ls_notify    STRING      
   DEFINE ls_udm7      STRING     
   DEFINE lch_file     base.Channel
   DEFINE li_i         LIKE type_file.num10   #No.FUN-690005  INTEGER
   DEFINE l_cmd        STRING
   DEFINE l_test       STRING
   DEFINE l_channel    base.Channel
   DEFINE l_fname      STRING
   DEFINE l_buf        STRING
   DEFINE l_serverip   STRING
   DEFINE l_ipsel      STRING     #FUN-670010
   DEFINE l_ipflag     LIKE type_file.chr1    #No.FUN-690005  VARCHAR(1)    #FUN-670010
   DEFINE ls_hide      LIKE type_file.chr20   #No.FUN-690005  VARCHAR(20)   #FUN-670010
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET gw_win = ui.Window.getCurrent()
   LET gn_win = gw_win.getNode()
   LET l_channel = base.Channel.create()
   LET l_fname = FGL_GETENV("TEMPDIR")
   LET g_user = FGL_GETENV("WEBUSER")   #FUN-670010
   LET l_fname = l_fname,"//",g_user CLIPPED,".userip.tmp"
   #FUN-670010---start---
   CALL l_channel.openFile(l_fname,"r")
   IF STATUS THEN
      LET l_ipflag=1
      CALL l_channel.close()
   ELSE
      WHILE l_channel.read(l_ipflag)
      END WHILE
      CALL l_channel.close()
   END IF
 
   IF l_ipflag = '1' THEN
      LET ls_hide = "sel_ip_inner"
   ELSE
      LET ls_hide = "sel_ip_OUTER"
   END IF
   #FUN-670010---end---
 
   MENU "serverip" ATTRIBUTE(STYLE="popup")
         BEFORE MENU
     
            HIDE OPTION ls_hide  #FUN-670010
       
            CALL cl_setIpOption()
 
         ON ACTION sel_ip_inner
             LET g_ip_location = '0'
             CALL l_channel.openFile(l_fname,"w")
             CALL l_channel.setDelimiter(NULL)
             CALL l_channel.write(g_aza.aza58 || "\n1")    #FUN-670010 modify
             CALL l_channel.close()
             EXIT MENU
 
         ON ACTION sel_ip_OUTER
             IF NOT cl_null(g_aza.aza59) THEN
                LET g_ip_location = '1'
                CALL l_channel.openFile(l_fname,"w")
                CALL l_channel.setDelimiter(NULL)
                CALL l_channel.write(g_aza.aza59 || "\n2")  #FUN-670010 modify
                CALL l_channel.close()
                EXIT MENU
             ELSE
                CALL cl_err_msg("",'udm-ip',NULL,g_aza.aza37)
                RETURN 
             END IF
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE MENU
   END MENU
 
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      IF g_prog CLIPPED = "udm_tree" THEN
         LET ls_udm7 = FGL_GETENV("UDM7")   #Set by udm7 shell
         IF ls_udm7 IS NULL OR ls_udm7 != 'Y' THEN
            LET ls_notify = FGL_GETPID()
            RUN "rm -f " || ls_notify
            CALL cl_cmdrun("udm_tree '' " || ls_notify)
                
            LET lch_file = base.Channel.create()
            FOR li_i = 1 TO TIMEOUT
              CALL lch_file.openFile(ls_notify, "r")
              IF NOT STATUS THEN
                 RUN "rm -rf " || ls_notify
                 EXIT FOR
              END IF
              SLEEP 1
            END FOR
            CALL lch_file.close()
         END IF
            IF ls_udm7 = "Y" THEN
               EXIT PROGRAM (g_ip_location + 20 )
            ELSE
               EXIT PROGRAM
            END IF
      END IF
   END IF
 
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION cl_setIpOption()
   DEFINE ln_menu         om.DomNode,
          ln_menuAction   om.DomNode
   DEFINE ll_menu         om.NodeList,
          ll_menuAction   om.NodeList
   DEFINE li_i            LIKE type_file.num10,  #No.FUN-690005 INTEGER,
          li_j            LIKE type_file.num10   #No.FUN-690005 INTEGER
 
 
   LET ll_menu = gn_win.selectByPath("//Menu[@text=\"serverip\"]")
   LET ln_menu = ll_menu.item(1)
   IF ln_menu IS NULL THEN
      RETURN
   END IF
   LET ll_menuAction = ln_menu.selectByTagName("MenuAction")
   FOR li_i = 1 TO ll_menuAction.getLength()
       LET ln_menuAction = ll_menuAction.item(li_i)
           IF ln_menuAction.getAttribute("name") = "sel_ip_inner" CLIPPED THEN
              SELECT ze03 INTO g_sel_in FROM ze_file WHERE ze01='sel-iip' AND ze02=g_lang
              CALL ln_menuAction.setAttribute("text", g_sel_in CLIPPED)
           ELSE
              SELECT ze03 INTO g_sel_out FROM ze_file WHERE ze01='sel-oip' AND ze02=g_lang
              CALL ln_menuAction.setAttribute("text", g_sel_out CLIPPED)
           END IF
   END FOR
 END FUNCTION
