# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_help_htm.4gl
# Descriptions...: 產生 ON-Line HELP HTML格式檔案
# Date & Author..: 2004/05/06 by alex
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.MOD-520083 05/02/17 By alex 調整抓取欄位長度及型態方式
# Modify.........: No.FUN-520023 05/02/25 By alex 將 za 資料移至 ze_file
# Modify.........: No.MOD-540140 05/04/20 By alex 刪除 HELP FILE
# Modify.........: No.MOD-540163 05/04/29 By alex 修改 order by 錯誤
# Modify.........: No.FUN-550065 05/05/15 By alex 大翻修本程式所有程式碼改寫
# Modify.........: No.FUN-550076 05/05/18 By alex 連結更新,取消產出單為顯示
# Modify.........: No.MOD-580218 05/08/25 By alex chk trans
# Modify.........: No.MOD-580228 05/08/25 By alex mod width
# Modify.........: No.MOD-580324 05/08/29 By alex upd ifx fld type
# Modify.........: No.FUN-550006 05/09/27 By alex 調整共用程式產生機制
# Modify.........: No.TQC-590032 05/10/17 By alex ag保持,C預抓C,若空則尋p資料(效能改善)
# Modify.........: No.TQC-630006 06/03/02 By alex 移除 cat /dev/null 寫法
# Modify.........: No.TQC-630185 06/03/30 By Echo 將echo '' 改為 echo -n ''
# Modify.........: No.TQC-640158 06/04/18 By saki 搜尋column type時,加入table_name條件
# Modify.........: No.MOD-650098 06/05/25 By Echo 恢復 cat /dev/null 寫法
# Modify.........: No.TQC-660144 06/07/04 By saki html編碼依照
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-740123 07/04/17 By Brendan 調整 HTML 編碼(針對語言別 0/1/2)
# Modify.........: No.TQC-750046 07/05/11 By alex 調整無資料時程式離開模式
# Modify.........: No.FUN-750068 07/07/04 By saki 行業別程式分開產生htm
# Modify.........: No.FUN-7B0081 08/01/10 By alex 將gae06移入gbs07
# Modify.........: No.TQC-880042 08/08/26 By alex 補上離開程式前的cl_used()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No.FUN-AC0036 10/12/29 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-B20021 11/02/14 By jrg542 把產生htm 及讀取 htm 要foreach行業都行業都取消掉 
# Modify.........: No:TQC-B40187 11/04/22 By lilingyu 還原FUN-B20021的mark部分
# Modify.........: No:TQC-B60011 11/06/02 By alex 調整作業,刪除產出檔名

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS                                   #MOD-580218
DEFINE ms_locale         STRING,
       ms_codeset        STRING,
       ms_b5_gb          STRING
END GLOBALS
 
   DEFINE g_gaz        RECORD LIKE gaz_file.*
   DEFINE g_sql        STRING
   DEFINE g_tmpstr     STRING
   DEFINE g_argv1      LIKE gaz_file.gaz01
   DEFINE g_argv2      LIKE gaz_file.gaz02
   DEFINE g_gaz03      LIKE gaz_file.gaz03
   DEFINE g_x_1        DYNAMIC ARRAY OF LIKE ze_file.ze03  
   DEFINE g_channel    base.Channel
   DEFINE g_gap02_comp STRING
   DEFINE g_filename   STRING                  #MOD-580218
   DEFINE g_module     LIKE type_file.chr1     #FUN-680135   #TQC-590032
   DEFINE g_industry   LIKE gae_file.gae12     #No.FUN-750068
 
MAIN
   DEFINE lc_zz011     LIKE zz_file.zz011      #No.FUN-750068
   DEFINE lc_gae11     LIKE gae_file.gae11     #No.FUN-750068
   DEFINE lc_gae12     LIKE gae_file.gae12     #No.FUN-750068
   DEFINE ls_prog      STRING
   DEFINE li_dash_inx  LIKE type_file.num5
   DEFINE li_cnt       LIKE type_file.num5
 
   LET g_bgjob = "Y"
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
#  純背景作業時不紀錄
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-880042
 
   # 清空並讀取基本資料
   INITIALIZE g_gaz.* TO NULL
 
   SELECT * INTO g_gaz.* FROM gaz_file 
     WHERE gaz01=g_argv1 AND gaz02=g_argv2 AND gaz05 = 'Y'
   IF SQLCA.SQLCODE THEN 
      SELECT * INTO g_gaz.* FROM gaz_file
       WHERE gaz01=g_argv1 AND gaz02=g_argv2 AND gaz05 = 'N'
      IF SQLCA.SQLCODE THEN 
         DISPLAY "Error: Program ",g_argv1 CLIPPED," has no data exists in LangID:",g_argv2 CLIPPED
#       #純背景作業時不紀錄
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #TQC-880042
         EXIT PROGRAM
      ELSE
         DISPLAY "Generate: Standard Program ",g_gaz.gaz01 CLIPPED #,':',g_gaz.gaz03 CLIPPED #TQC-B60011
      END IF
   ELSE
      DISPLAY "Generate: Customized Program ",g_gaz.gaz01 CLIPPED #,':',g_gaz.gaz03 CLIPPED  #TQC-B60011
   END IF
 
   LET g_sql=" SELECT gae04 FROM gae_file ",
              " WHERE gae01=? AND gae11=? AND gae02=? AND gae03=? AND gae12=? "  #No.FUN-750068
   PREPARE p_help_htm_gae04_pre FROM g_sql
 
   # 設定相關全域變數
   SELECT UNIQUE gay01 FROM gay_file WHERE gay01=g_argv2
   IF NOT SQLCA.SQLCODE THEN
      LET g_lang = g_argv2 CLIPPED
   END IF
 
   #No.FUN-750068 --start-- 多行業別說明檔輸出
   #拿傳入的主程式找是否有客製的行業別, 如果只客製單一行業別, 其他就連至標準行業別
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_argv1
   IF lc_zz011[1,1] = "C" THEN
      LET lc_gae11 = "Y"
   ELSE
      LET lc_gae11 = "N"
   END IF

   CALL cl_query_prt_temptable()     #FUN-AC0036 create temp table儲存欄位資訊

#  # gae01:畫面代碼 gae03:語言別 gae11:客製碼 

   LET ls_prog = g_argv2 CLIPPED

   IF ls_prog.getIndexOf("_",1) THEN
      WHILE ls_prog.getIndexOf("_",li_dash_inx+1)
         LET li_dash_inx = ls_prog.getIndexOf("_",li_dash_inx+1)
      END WHILE
      LET g_industry = ls_prog.subString(li_dash_inx+1,ls_prog.getLength())

      SELECT COUNT(*) INTO li_cnt FROM smb_file WHERE smb01 = g_industry           #尋找有無此行業
      IF li_cnt > 0 THEN
      ELSE
         LET g_industry = 'std'
      END IF
   ELSE
      LET g_industry = 'std'
   END IF
 
   # 啟始檔案 輸出指定位置 輸出檔頭
   CALL p_help_htm_init()  
      
   # 組目的 特點 功能 欄位
   CALL p_help_htm_compose()  
   
   # 關閉檔案
   CALL p_help_htm_final()  
 
#  純背景作業時不紀錄
#  CALL cl_used(g_prog,g_time,2) RETURNING g_time    #TQC-880042
 
END MAIN
 
# 2004/05/06 啟始檔案
FUNCTION p_help_htm_init()  
 
   DEFINE ls_top      STRING
   DEFINE lc_module   LIKE zz_file.zz011   #模組定義檔模組名稱標準長度
   DEFINE lc_gaz03    LIKE gaz_file.gaz03
   DEFINE ls_cmd      STRING
   DEFINE l_za05      LIKE za_file.za05
   DEFINE l_i         LIKE type_file.num5          #No.FUN-680135 SMALLINT
   DEFINE l_show_feature LIKE type_file.chr1       #FUN-680135 
   DEFINE l_codeset   STRING   #TQC-740123
   DEFINE ls_filename  STRING                 
 
   SELECT zz011 INTO lc_module FROM zz_file WHERE zz01 = g_gaz.gaz01
   IF cl_null(g_gaz.gaz01) THEN
      LET lc_module = "azz"
   ELSE
      LET lc_module = DOWNSHIFT(lc_module)
   END IF   
 
   # 2004/07/09 重修位置
   IF lc_module[1]="c" THEN
      CALL FGL_GETENV("CUST") RETURNING ls_top     #新增客製 help 產生目錄
   ELSE
      CALL FGL_GETENV("TOP") RETURNING ls_top
   END IF
 
   LET ls_filename = ls_top.trim(),os.Path.separator(),"doc",os.Path.separator(),"help",
                                   os.Path.separator(),g_gaz.gaz02 CLIPPED,os.Path.separator(),lc_module CLIPPED,
                                   os.Path.separator(),"HELP_",g_gaz.gaz01 CLIPPED
   IF g_industry = "std" THEN
      LET ls_filename = ls_filename.trim(),".htm"
   ELSE
      LET ls_filename = ls_filename.trim(),"_",g_industry CLIPPED,".htm"
   END IF

 
   LET g_filename = ls_filename #MOD-580218
   DISPLAY "INFO: OUTPUT filename = ",ls_filename

#  LET ls_cmd = "cat /dev/null > ", ls_filename CLIPPED   #TQC-630006 #MOD-650098
#  RUN ls_cmd
   CALL cl_null_cat_to_file(ls_filename CLIPPED)          #FUN-9B0113
 
   # 讀取 za_file 存入 g_x_1
   LET g_x_1[07] = cl_getmsg("azz-098",g_lang)
   LET g_x_1[08] = cl_getmsg("azz-099",g_lang)
   LET g_x_1[09] = cl_getmsg("azz-104",g_lang)
 
#  # 取得程式及模組在對應語言別下的名稱
   CALL cl_get_progname(g_gaz.gaz01,g_gaz.gaz02) RETURNING g_gaz03
   CALL cl_get_progname(lc_module,g_gaz.gaz02) RETURNING lc_gaz03 
 
   # 輸出檔頭
   LET g_channel = base.Channel.create()
   CALL g_channel.openFile( ls_filename CLIPPED, "a" )
   CALL g_channel.setDelimiter("")
 
   LET g_x_1[10]=cl_getmsg("azz-201",g_lang)
   CALL FGL_GETENV("PRODUCERIP") RETURNING g_x_1[11]    #FUN-550076
 
   #-- TQC-740123 BEGIN -------------------------------------------------------#
   # 非 UTF-8 環境時, 產生語言別 0 說明檔時, 應一律設定編碼為 BIG5             #
   #                  產生語言別 2 說明檔時, 應一律設定編碼為 GB2312           #
   #                  產生其餘語言別說明檔時, 則依照系統目前語言編碼           #
   #---------------------------------------------------------------------------#
   LET l_codeset = ms_codeset
   IF l_codeset != "UTF-8" THEN
      CASE g_gaz.gaz02 CLIPPED
           WHEN '0'
                LET l_codeset = "BIG5"
           WHEN '2'
                LET l_codeset = "GB2312"
      END CASE
   END IF
   #-- TQC-740123 END ---------------------------------------------------------#
 
   LET g_tmpstr = "<HTML>"                                                                                        CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '<META http-equiv="Content-Type" content="text/html; charset=',l_codeset,'">'                  CALL g_channel.write(g_tmpstr)  #No.TQC-660144, TQC-740123
   LET g_tmpstr = "<HEAD><TITLE>",g_gaz03 CLIPPED,"(",g_gaz.gaz01 CLIPPED,")</TITLE></HEAD>"                      CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = "<BODY bgColor=#ccccff>"                                                                        CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '<A name="gao"></A>'                                                                            CALL g_channel.write(g_tmpstr) 
   LET g_tmpstr = '<P align="center"><SPAN style="text-decoration: none; font-weight: 700">'                      CALL g_channel.write(g_tmpstr)
   #FUN-550076
   LET g_tmpstr = '<A HREF="',g_x_1[11] CLIPPED,'"><FONT color="#cc0000">',g_x_1[10] CLIPPED,'</FONT></A>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '</SPAN></P>'                                                                                   CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '<P align="center"><SPAN style="text-decoration: none; font-weight: 700">'                      CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '<FONT color="#000000">',lc_module CLIPPED," ",lc_gaz03 CLIPPED,'</FONT>'                       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '<FONT color="#CC0000">',g_gaz.gaz01 CLIPPED," ", g_gaz03 CLIPPED,"</FONT>"                     CALL g_channel.write(g_tmpstr)
   LET g_x_1[10]=cl_getmsg("azz-202",g_lang)
   LET g_tmpstr = '<FONT color="#000000">',g_x_1[10] CLIPPED,'</FONT></SPAN></P>'                                   CALL g_channel.write(g_tmpstr)
 
   LET g_x_1[03] = cl_getmsg("azz-094",g_lang)
   LET g_x_1[04] = cl_getmsg("azz-095",g_lang)
   LET g_x_1[01] = cl_getmsg("azz-203",g_lang)
   LET g_x_1[05] = cl_getmsg("azz-096",g_lang)
   LET g_x_1[06] = cl_getmsg("azz-097",g_lang)
   LET g_x_1[02] = cl_getmsg("azz-205",g_lang)
   LET g_tmpstr = "<TABLE height=29 cellSpacing=1 cellPadding=5 width=679 align=center bgColor=#ddddf4 border=0>" CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = "<TBODY><TR>"                                                                                   CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gaz\">'|| g_x_1[03] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gbf\">'|| g_x_1[04] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gax\">'|| g_x_1[01] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gbd\">'|| g_x_1[05] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gae\">'|| g_x_1[06] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '  <TD align="center"><SPAN style="text-decoration: none; font-weight: 700"><FONT size="2"><A href=\"#gbe\">'|| g_x_1[02] CLIPPED ||'</A></FONT></SPAN></TD>'  CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = "</TR></TBODY>"                                                                                 CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = "</TABLE>"                                                                                      CALL g_channel.write(g_tmpstr) 
 
   RETURN
END FUNCTION
 
 
FUNCTION p_help_htm_compose()
 
   DEFINE l_i            LIKE type_file.num5          #No.FUN-680135 SMALLINT
   DEFINE l_gaz01        LIKE gaz_file.gaz01
   DEFINE l_gaz03        LIKE gaz_file.gaz03
   DEFINE l_gaz04        LIKE gaz_file.gaz04 
   DEFINE ls_tmpstring   STRING
   DEFINE l_show_feature LIKE type_file.chr1     #FUN-680135 
 
   #作業目的
   LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gaz>',g_x_1[03] CLIPPED,'</A></FONT></B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL p_help_htm_get_purpose() 
   CALL g_channel.write(" ")
   LET g_x_1[02]=cl_getmsg("azz-204",g_lang)
   LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL g_channel.write(" ")
 
   #作業特點
   CALL p_help_htm_get_feature('N') RETURNING l_show_feature
   IF l_show_feature = 'Y' THEN
       LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gbf>',g_x_1[04] CLIPPED,'</A></FONT></B></P>'
       CALL g_channel.write(g_tmpstr)
       CALL p_help_htm_get_feature('Y') RETURNING l_show_feature
       CALL g_channel.write(" ")
       LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
       CALL g_channel.write(g_tmpstr)
       CALL g_channel.write(" ")
   END IF
 
   #程式組成
   LET g_x_1[01] = cl_getmsg("azz-203",g_lang)
   LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gax>',g_x_1[01] CLIPPED,'</A></FONT></B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL p_help_htm_get_comp() 
   CALL g_channel.write(" ")
   LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL g_channel.write(" ")
 
   #操作功能
   LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gbd>',g_x_1[05] CLIPPED,'</A></FONT></B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL p_help_htm_get_action_memo() 
   CALL g_channel.write(" ")
   LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL g_channel.write(" ")
 
   #欄位說明
   LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gae>',g_x_1[06] CLIPPED,'</A></FONT></B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL p_help_htm_get_field_memo() 
   CALL g_channel.write(" ")
   LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
   CALL g_channel.write(g_tmpstr)
 
   #文件資訊
   LET g_x_1[01]=cl_getmsg("azz-205",g_lang)
   LET g_tmpstr = '<P><B><FONT color="#006600" size="3"><A name=gbe>',g_x_1[01] CLIPPED,'</A></FONT></B></P>'
   CALL g_channel.write(g_tmpstr)
   CALL p_help_htm_get_memo() 
   CALL g_channel.write(" ")
   LET g_tmpstr = '<P><B> [ <FONT size="2" color="#FF0000"><SPAN style="text-decoration: none"><A href=\"#gao\">',g_x_1[02] CLIPPED,'</A></SPAN></FONT> ] </B></P>'
   CALL g_channel.write(g_tmpstr)
 
END FUNCTION
 
# 取得作業目的
FUNCTION p_help_htm_get_purpose()
 
   DEFINE l_gaz04    LIKE gaz_file.gaz04 
   DEFINE l_i        LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE ls_tmp     STRING
   DEFINE li_purpose LIKE type_file.num10    #FUN-680135 INTEGER
 
   LET l_i=0
   LET l_gaz04=""
   SELECT count(*) INTO l_i FROM gaz_file 
    WHERE gaz01 = g_gaz.gaz01 AND gaz02 = g_gaz.gaz02 AND gaz05 = "Y"
   IF l_i > 0 THEN
      SELECT gaz04 INTO l_gaz04 FROM gaz_file
       WHERE gaz01 = g_gaz.gaz01 AND gaz02 = g_gaz.gaz02 AND gaz05 = "Y"
   ELSE
      SELECT gaz04 INTO l_gaz04 FROM gaz_file
       WHERE gaz01 = g_gaz.gaz01 AND gaz02 = g_gaz.gaz02 AND gaz05 = "N"
   END IF
 
   LET ls_tmp=l_gaz04 CLIPPED
   WHILE TRUE
      LET li_purpose = ls_tmp.getIndexOf( ASCII 10,1 )
      IF li_purpose = 0 THEN
         EXIT WHILE
      ELSE
         LET ls_tmp =ls_tmp.subString(1,li_purpose-1),'</P><P>',ls_tmp.subString(li_purpose+1,ls_tmp.getLength())
      END IF
   END WHILE
   LET ls_tmp ='<P>',ls_tmp.trim(),'</P>'
 
   CALL g_channel.write('<FONT size="2">')
   CALL g_channel.write(ls_tmp.trim())
   CALL g_channel.write('</FONT>')
   CALL g_channel.write(' ')
   RETURN 
 
END FUNCTION
 
# 取得作業特點 分階層組合後輸出
FUNCTION p_help_htm_get_feature(p_write)
 
   DEFINE ls_sql         STRING
   DEFINE lc_char2       LIKE type_file.chr2     #FUN-680135 
   DEFINE l_gbf          RECORD
            gbf03        LIKE gbf_file.gbf03,
            gbf04        LIKE gbf_file.gbf04,
            gbf05        LIKE gbf_file.gbf05
                         END RECORD
   DEFINE l_have_data    LIKE type_file.chr1     #FUN-680135  若有資料,則l_have_data = 'Y'
   DEFINE p_write        LIKE type_file.chr1     #FUN-680135  
   DEFINE li_purpose     LIKE type_file.num5     #FUN-680135  SMALLINT
   DEFINE ls_tmp         STRING
 
   LET l_have_data = 'N'
   CALL g_channel.write("<PRE>")
 
   LET ls_sql = " SELECT gbf03,gbf04,gbf05 FROM gbf_file ",
                 " WHERE gbf01 = '",g_gaz.gaz01 CLIPPED,"' ",
                   " AND gbf02 = '",g_gaz.gaz02 CLIPPED,"' ",
                 " ORDER BY gbf03,gbf04 "
 
   PREPARE p_help_htm_feature_pre FROM ls_sql
   DECLARE p_help_htm_feature_curs CURSOR FOR p_help_htm_feature_pre

   FOREACH p_help_htm_feature_curs INTO l_gbf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET lc_char2 = l_gbf.gbf03 CLIPPED
      IF l_gbf.gbf04 = 0 THEN
         LET g_tmpstr=  5 SPACES,lc_char2,".",l_gbf.gbf05
      ELSE
         LET g_tmpstr= 10 SPACES,"-> ",l_gbf.gbf05
      END IF
 
      # 遇到 feature 有切行時要對齊
      LET ls_tmp = g_tmpstr
      WHILE TRUE
         LET li_purpose = ls_tmp.getIndexOf( ASCII 10,1 )
         IF li_purpose = 0 THEN
            EXIT WHILE
         ELSE
            LET g_tmpstr = g_tmpstr.subString(1,li_purpose),13 SPACES,g_tmpstr.subString(li_purpose+1,g_tmpstr.getLength())
            LET ls_tmp = ls_tmp.subString(1,li_purpose-1),14 SPACES,ls_tmp.subString(li_purpose+1,ls_tmp.getLength())
         END IF
      END WHILE
 
      IF p_write = 'Y' THEN
         CALL g_channel.write(g_tmpstr)
      END IF
      LET l_have_data = 'Y'
   END FOREACH
 
   CALL g_channel.write("</PRE>")
   CALL g_channel.write("")

   CLOSE p_help_htm_feature_curs 
   FREE p_help_htm_feature_curs 

   RETURN l_have_data
END FUNCTION
 
# 取得 Action memo 說明 分階層組合後輸出
FUNCTION p_help_htm_get_action_memo()
 
   DEFINE lt_gap02        base.StringTokenizer
   DEFINE ls_gap02        STRING
   DEFINE ls_gbd01        STRING
   DEFINE li_index        LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE la_gbd      DYNAMIC ARRAY OF RECORD
            gbd01           LIKE gbd_file.gbd01,
            gbd04           LIKE gbd_file.gbd04,
            gbd05           LIKE gbd_file.gbd05
                      END RECORD
 
   CALL la_gbd.clear()
   LET li_index = 1
 
   CALL p_help_htm_get_gap02_comp()
 
   # 分析各項 4ad 並從檔案中抓出細項資料
   LET lt_gap02 = base.StringTokenizer.create(g_gap02_comp CLIPPED, ",")
   WHILE lt_gap02.hasMoreTokens()
 
      LET ls_gbd01 = lt_gap02.nextToken()
      LET la_gbd[li_index].gbd01 = ls_gbd01.trim()
 
      SELECT gbd04,gbd05 INTO la_gbd[li_index].gbd04, la_gbd[li_index].gbd05 FROM gbd_file
       WHERE gbd01=la_gbd[li_index].gbd01 
         AND gbd02=g_gaz.gaz01
         AND gbd03=g_gaz.gaz02
         AND gbd06="N"
 
      IF SQLCA.SQLCODE=100 THEN
         SELECT gbd04,gbd05
           INTO la_gbd[li_index].gbd04, la_gbd[li_index].gbd05
           FROM gbd_file
          WHERE gbd01=la_gbd[li_index].gbd01 
            AND gbd02='standard'
            AND gbd03=g_gaz.gaz02
            AND gbd06="N"
      END IF
 
      LET li_index = li_index + 1
   END WHILE
   LET li_index = li_index - 1
   LET g_x_1[11]=cl_getmsg("azz-214",g_lang)
   LET g_x_1[12]=cl_getmsg("azz-215",g_lang)
   LET g_tmpstr = '<CENTER>'                                                                                                    CALL g_channel.write(g_tmpstr) 
   LET g_tmpstr = '<TABLE width="80%" bgColor=#ccccff border=0><TBODY>'                                                         CALL g_channel.write(g_tmpstr)    
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                      CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD width="20%" align="left" bgcolor="#CCCCFF"><B><FONT size="2">',g_x_1[11] CLIPPED,'</FONT></B></TD>'   CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="80%" align="left" bgcolor="#CCCCFF"><B><FONT size="2">',g_x_1[12] CLIPPED,'</FONT></B></TD>'   CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  </TR>'                                                                                                     CALL g_channel.write(g_tmpstr)  
 
   # 直接輸出至 html file
   FOR li_i=1 TO li_index
      IF NOT cl_null(la_gbd[li_i].gbd04) THEN
         LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
         LET g_tmpstr = '    <TD width="20%" align="left" bgcolor="#CCCCFF"><FONT size="2">',la_gbd[li_i].gbd04 CLIPPED,'</FONT></TD>'   CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '    <TD width="80%" align="left" bgcolor="#CCCCFF"><FONT size="2">',la_gbd[li_i].gbd05 CLIPPED,'</FONT></TD>'   CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)  
      END IF
   END FOR
   LET g_tmpstr = '</TBODY></TABLE></CENTER>'                                                                                       CALL g_channel.write(g_tmpstr) 
 
   RETURN 
END FUNCTION
 
#程式組成
FUNCTION p_help_htm_get_comp() 
 
   DEFINE lc_gal01    LIKE gal_file.gal01   #FUN-550006
   DEFINE lc_gal02    LIKE gal_file.gal02
   DEFINE lc_gal03    LIKE gal_file.gal03
   DEFINE lc_path     STRING
   DEFINE l_ch1       base.Channel
   DEFINE l_buff1     STRING
   DEFINE l_ind       LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE lc_gax02    LIKE gax_file.gax02
 
   LET g_x_1[11] = cl_getmsg("azz-092",g_lang)
   LET g_x_1[12] = cl_getmsg("azz-209",g_lang)
   LET g_x_1[13] = cl_getmsg("azz-210",g_lang)
   LET g_x_1[14] = cl_getmsg("azz-211",g_lang)
   LET g_x_1[15] = cl_getmsg("azz-212",g_lang)
   LET g_tmpstr = '<CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
   LET g_tmpstr = '<TABLE width="80%" bgColor=#ffcc99 border=1><TBODY>'                                                             CALL g_channel.write(g_tmpstr)    
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD colspan="4" bgcolor="#99CCFF"><B><FONT size="2">',g_x_1[15] CLIPPED,'</FONT></B></TD></TR>'                CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[11] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="40%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[12] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[13] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[14] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
 
   #FUN-550006
   LET lc_gal01 = g_gaz.gaz01 CLIPPED
   SELECT count(*) INTO l_ind FROM gal_file WHERE gal01=lc_gal01 AND gal04="Y"
   IF SQLCA.SQLCODE OR l_ind <= 0 THEN
      CALL p_help_htm_transname(g_gaz.gaz01) RETURNING lc_gal01
   END IF
 
   DECLARE p_help_htm_4gl_list CURSOR FOR
     SELECT gal02,gal03 FROM gal_file WHERE gal01=lc_gal01 AND gal04="Y" ORDER BY gal02,gal03
 
   FOREACH p_help_htm_4gl_list INTO lc_gal02,lc_gal03
      IF UPSHIFT(lc_gal02[1])="C" THEN
         LET g_x_1[11] = cl_getmsg("lib-051",g_lang)
         LET lc_path = os.Path.join( FGL_GETENV("CUST") CLIPPED,DOWNSHIFT(lc_gal02) CLIPPED)
      ELSE
         LET g_x_1[11] = cl_getmsg("lib-053",g_lang)
         LET lc_path = os.Path.join( FGL_GETENV("TOP") CLIPPED,DOWNSHIFT(lc_gal02) CLIPPED)
      END IF
      LET lc_path = lc_path.trim(),os.Path.separator(),'4gl',os.Path.separator(),lc_gal03 CLIPPED,'.4gl'
      LET l_ch1 = base.Channel.create()

      CALL l_ch1.openFile(lc_path,"r")
      WHILE l_ch1.read([l_buff1])
         LET l_buff1=l_buff1.trim()
         IF l_buff1.getIndexOf("Prog. Version",1) > 0 THEN
            LET l_ind=l_buff1.getIndexOf("'",1)
            LET g_x_1[13] = l_buff1.subString(l_ind+1,l_buff1.getIndexOf("'",l_ind+1)-1)
            EXIT WHILE
         END IF
      END WHILE
      LET g_tmpstr = '  <TR bgColor=#ffffff>'                                                                                          CALL g_channel.write(g_tmpstr)  
      LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFFFFF"><FONT size="2">',lc_gal02 CLIPPED,'</FONT></TD>'      CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="40%" align="center" bgcolor="#FFFFFF"><FONT size="2">',lc_gal03 CLIPPED,'</FONT></TD>'      CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFFFFF"><FONT size="2">',g_x_1[11] CLIPPED,'</FONT></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="20%" align="center" bgcolor="#FFFFFF"><FONT size="2">',g_x_1[13] CLIPPED,'</FONT></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
   END FOREACH
 
   CLOSE p_help_htm_4gl_list
   FREE p_help_htm_4gl_list

   LET g_tmpstr = '</TBODY></TABLE></CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
   CALL g_channel.write("  ") 
   LET g_tmpstr = '<CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
   LET g_tmpstr = '<TABLE width="80%" bgColor=#ffcc99 border=1><TBODY>'                                                             CALL g_channel.write(g_tmpstr)    
   LET g_x_1[15]=cl_getmsg("azz-213",g_lang)
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD colspan="4" bgcolor="#99CCFF"><B><FONT size="2">',g_x_1[15] CLIPPED,'</FONT></B></TD></TR>'                CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD width="100%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[12] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
 
   DECLARE p_help_htm_per_list CURSOR FOR
     SELECT gax02 FROM gax_file WHERE gax01=g_gaz.gaz01 AND gax04="Y"
 
   FOREACH p_help_htm_per_list INTO lc_gax02
      LET g_tmpstr = '  <TR bgColor=#ffffff>'                                                                                          CALL g_channel.write(g_tmpstr)  
      LET g_tmpstr = '    <TD width="100%" align="center" bgcolor="#FFFFFF"><FONT size="2">',lc_gax02 CLIPPED,'</FONT></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
   END FOREACH
   LET g_tmpstr = '</TBODY></TABLE></CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
 
   CLOSE p_help_htm_per_list
   FREE p_help_htm_per_list

END FUNCTION
 
 
# 取得欄位說明 分階層組合後輸出
FUNCTION p_help_htm_get_field_memo()
 
   DEFINE lc_gae02      LIKE gae_file.gae02
   DEFINE lc_gae04      LIKE gae_file.gae04
   DEFINE lc_gbs07      LIKE gbs_file.gbs07    #FUN-7B0081
   DEFINE ls_gbs07      STRING
   DEFINE li_gbs07_br   LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE lc_gax02      LIKE gax_file.gax02
   DEFINE ls_gae01      STRING
   DEFINE lc_ztb01      LIKE ztb_file.ztb01    #No.TQC-640158
   DEFINE lc_ztb04      LIKE ztb_file.ztb04
   DEFINE lc_ztb08      LIKE ztb_file.ztb08
   DEFINE la_gax    DYNAMIC ARRAY OF RECORD
            gax02       LIKE gax_file.gax02
                    END RECORD
   DEFINE li_index,li_i LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE lc_db_type    LIKE type_file.chr3    #FUN-680135 
   DEFINE li_j          LIKE type_file.num5    #FUN-680135 SMALLINT   #TQC-590032
   DEFINE ls_sql        STRING                 #No.TQC-640158
 
   # 2004/05/03 輸出各個畫面檔名稱, 05/06 改為抓取 gax_file
   DECLARE p_help_htm_per_memo CURSOR FOR
     SELECT gax02 FROM gax_file
      WHERE gax01 = g_gaz.gaz01 AND gax04 = "Y"
 
   LET li_index = 1
   FOREACH p_help_htm_per_memo INTO lc_gax02
      LET la_gax[li_index].gax02 = lc_gax02
      LET li_index = li_index + 1
   END FOREACH
   LET li_index = li_index - 1
   IF li_index <= 0 THEN RETURN END IF
 
   FOR li_i = 1 TO la_gax.getLength()
 
      #不管何種語言別,只要同語言下有一筆客製資料整個畫面檔就算客製
      SELECT count(*) INTO li_j FROM gae_file
       WHERE gae01=la_gax[li_i].gax02 AND gae11="Y" AND gae03=g_gaz.gaz02
      IF li_j >= 1 THEN
         LET g_module="C"
      ELSE
         LET g_module="P"
      END IF                    #TQC-590032
 
      # 分畫面檔顯示, 並輔以 wintitle, 使 user 能依現在畫面位置尋出要的說明
      IF la_gax[li_i].gax02 = g_gaz.gaz01 THEN
         LET g_tmpstr = 5 SPACES, g_gaz03 CLIPPED
      ELSE
         LET lc_gae04=""
 
         IF g_module="C" THEN
            EXECUTE p_help_htm_gae04_pre
              USING la_gax[li_i].gax02,"Y","wintitle",g_gaz.gaz02,g_industry   #No.FUN-750068
               INTO lc_gae04
         END IF
         IF g_module<>"C" OR cl_null(lc_gae04) THEN
            EXECUTE p_help_htm_gae04_pre
              USING la_gax[li_i].gax02,"N","wintitle",g_gaz.gaz02,g_industry   #No.FUN-750068
               INTO lc_gae04
         END IF
 
         LET g_tmpstr = 5 SPACES, lc_gae04 CLIPPED
      END IF
 
      LET g_tmpstr = '<P><B><FONT size="2">',g_tmpstr.trimRight(),' (',la_gax[li_i].gax02 CLIPPED,')</FONT></B></P>'                   CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '<CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
      LET g_tmpstr = '<TABLE width="80%" bgColor=#ffcc99 border=1><TBODY>'                                                             CALL g_channel.write(g_tmpstr)    
      LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
      LET g_tmpstr = '    <TD width="10%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[09] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="10%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[07] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="10%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[08] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '    <TD width="55%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[06] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
      LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
 
      # 抓取每個畫面元件的值
      DECLARE p_help_htm_field_memo CURSOR FOR        
        SELECT gae02,gae04,gbs07 FROM gae_file,gbs_file     #FUN-7B0081
         WHERE gae01=la_gax[li_i].gax02 AND gae03=g_gaz.gaz02
           AND gbs01=gae01 AND gbs02=gae02 AND gbs03=gae03
           AND gbs04=gae11 AND gbs05=gae12
           AND gbs07 IS NOT NULL AND gbs07 <> " " AND gae07="Y"
           AND gae12=g_industry  #No.FUN-750068
         ORDER BY gae02
 
      FOREACH p_help_htm_field_memo INTO lc_gae02,lc_gae04,lc_gbs07
 
         # 2004/08/19 選取欄位說明寫入 lc_ztb04,lc_ztb08
 
         LET lc_ztb04=""   LET lc_ztb08=""

         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         CALL cl_query_prt_getlength(lc_gae02, 'N', 's', 0)
         SELECT sch01, xabc06, xabc04 INTO lc_ztb01, lc_ztb04, lc_ztb08 
           FROM xabc, sch_file WHERE sch02 = xabc02 AND xabc02 = lc_gae02
 
         IF SQLCA.SQLCODE THEN   #FUN-580228
            LET lc_ztb04=""
            LET lc_ztb08=""
         END IF
 
         IF cl_null(lc_ztb08) THEN
            LET g_x_1[16]=lc_ztb04 CLIPPED
         ELSE
            LET g_x_1[16]=lc_ztb04 CLIPPED || "("||lc_ztb08 CLIPPED ||")" 
         END IF
 
         LET ls_gbs07=lc_gbs07 CLIPPED   #FUN-7B0081
 
         # 欄位說明
         # 2004/08/23 修改說明顯示,將原先 PRE 改成去分析 ASCII 10 -> <BR>
         WHILE TRUE
            LET li_gbs07_br = ls_gbs07.getIndexOf( ASCII 10,1)
            IF li_gbs07_br = 0 THEN
               EXIT WHILE
            ELSE
               LET ls_gbs07=ls_gbs07.subString(1,li_gbs07_br-1)," <BR> ",ls_gbs07.subString(li_gbs07_br+1,ls_gbs07.getLength())
            END IF
         END WHILE
 
         LET g_tmpstr = '  <TR bgColor=#fffff0>'                                              CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '    <TD width="20%" align="left"><FONT size="2">',lc_gae04 CLIPPED,'</FONT></TD>' CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '    <TD width="10%" align="center"><FONT size="2">',lc_gae02 CLIPPED,'</FONT></TD>' CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '    <TD width="20%" align="center"><FONT size="2">',g_x_1[16] CLIPPED,'</FONT></TD>'  CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '    <TD width="50%" align="left"><FONT size="2">',ls_gbs07.trim(),'</FONT></TD>'  CALL g_channel.write(g_tmpstr)
         LET g_tmpstr = '  </TR>'                                                             CALL g_channel.write(g_tmpstr)
 
      END FOREACH
 
      LET g_tmpstr = '</TBODY></TABLE></CENTER>'                                              CALL g_channel.write(g_tmpstr) 
 
   END FOR

   CLOSE p_help_htm_field_memo
   FREE p_help_htm_field_memo
 
   RETURN 
END FUNCTION
 
#文件資訊
FUNCTION p_help_htm_get_memo() 
 
   #FUN-550076
   DEFINE ld_today DATETIME YEAR TO MINUTE
 
   LET ld_today = CURRENT YEAR TO MINUTE 
 
   LET g_x_1[12] = cl_getmsg("azz-207",g_lang)
   LET g_x_1[13] = cl_getmsg("azz-208",g_lang)
   LET g_tmpstr = '<CENTER>'                                                                                                        CALL g_channel.write(g_tmpstr) 
   LET g_tmpstr = '<TABLE width="80%" bgColor=#ffcc99 border=1><TBODY>'                                                             CALL g_channel.write(g_tmpstr)    
   LET g_tmpstr = '  <TR bgColor=#fffff0>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD width="60%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[12] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="40%" align="center" bgcolor="#FFCC99"><B><FONT size="2">',g_x_1[13] CLIPPED,'</FONT></B></TD>'       CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
   SELECT zx02 INTO g_x_1[12] FROM zx_file  WHERE zx01=g_user
   LET g_tmpstr = '  <TR bgColor=#ffffff>'                                                                                          CALL g_channel.write(g_tmpstr)  
   LET g_tmpstr = '    <TD width="60%" align="center" bgcolor="#FFFFFF"><B><FONT size="2">',g_user CLIPPED,' ',g_x_1[12] CLIPPED,'</FONT></B></TD>'        CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '    <TD width="40%" align="center" bgcolor="#FFFFFF"><B><FONT size="2">',ld_today CLIPPED,'</FONT></B></TD>'         CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '  </TR>'                                                                                                         CALL g_channel.write(g_tmpstr)
   LET g_tmpstr = '</TBODY></TABLE></CENTER>'                                                                                       CALL g_channel.write(g_tmpstr) 
 
END FUNCTION
 
 
# 抓取 g_gap02_comp
FUNCTION p_help_htm_get_gap02_comp()
 
   DEFINE ls_sql    STRING
   DEFINE lc_gap02  LIKE gap_file.gap02
 
   LET g_gap02_comp = ""
 
   LET ls_sql = " SELECT gap02 FROM gap_file ",
                " WHERE gap01 = '",g_gaz.gaz01 CLIPPED,"' "
 
   PREPARE p_help_htm_gap02_prepare FROM ls_sql           #預備一下
   DECLARE p_help_htm_gap02_curs CURSOR FOR p_help_htm_gap02_prepare
 
   FOREACH p_help_htm_gap02_curs INTO lc_gap02
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(lc_gap02) THEN
         IF cl_null(g_gap02_comp) THEN
            LET g_gap02_comp = lc_gap02 CLIPPED
         ELSE
            LET g_gap02_comp = g_gap02_comp.trim(),", ", lc_gap02 CLIPPED
         END IF
      END IF
   END FOREACH
 
   LET g_gap02_comp = g_gap02_comp.trim()

   CLOSE p_help_htm_gap02_curs 
   FREE p_help_htm_gap02_curs 
 
END FUNCTION
 
 
FUNCTION p_help_htm_final()  
 
   CALL g_channel.write("</PRE>")
   CALL g_channel.write("</BODY></HTML>")
   CALL g_channel.close()
 
END FUNCTION
 
 
FUNCTION p_help_htm_transname(lc_zz01)
 
   DEFINE lc_zz01   LIKE zz_file.zz01
   DEFINE lc_zz08   LIKE zz_file.zz08
   DEFINE ls_zz08   STRING
   DEFINE li_s      LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_e      LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE lc_trans  LIKE zz_file.zz01
 
   LET lc_zz01 = lc_zz01 CLIPPED
   SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=lc_zz01
   IF SQLCA.SQLCODE THEN
      RETURN ""
   END IF
   LET ls_zz08 = lc_zz08 CLIPPED
   LET li_s = ls_zz08.getIndexOf("i/",1)
   LET li_e = ls_zz08.getIndexOf(" ",li_s+1)
   IF li_e = 0 THEN
      LET li_e = ls_zz08.getLength()
      LET lc_trans = ls_zz08.subString(li_s+2,li_e)
   ELSE
      LET lc_trans = ls_zz08.subString(li_s+2,li_e-1)
   END IF
   RETURN lc_trans
END FUNCTION

 
