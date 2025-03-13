# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Library name...: cl_about.4gl
# Descriptions...: About...
# Memo...........:
# Usage..........: CALL cl_about()
# Date & Author..: 04/12/03 By alex
# Modify.........: No.FUN-4C0068 04/12/10 By alex 可串接網站功能
# Modify.........: No.FUN-4C0075 04/12/15 By alex 版本欄位放大成 STRING 以容納小版號
# Modify.........: No.MOD-510103 05/01/17 By alex 利用 1p 版新功能抓取一些資訊
# Modify.........: No.TQC-630109 06/03/10 By Array最大筆數控制
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.MOD-770006 07/08/08 By claire 雙檔使用指定筆action對確定取消的action控制
# Modify.........: No.FUN-7B0028 07/11/12 By alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-810085 08/02/22 By joyce 新增檢視Patch資訊的功能
# Modify.........: No.FUN-830021 08/03/05 By alex 新增cp -R功能(Genero only)
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段, 這支不加about action
# Modify.........: No.FUN-850099 08/12/16 By alex 對tiptop新增顯示STACK
# Modify.........: No.FUN-AA0017 10/10/07 By alex 加入Sybase ASE設定
# Modify.........: No.FUN-B60158 11/07/05 By alex Genero2.32取消fpi功能
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串,判斷是否要顯示訊息
# Modify.........: No:FUN-BB0104 11/11/21 By Hiko 將echo指令改為writeLine,以解決單引號問題.
# Modify.........: No:FUN-BB0152 11/11/30 By Hiko 檢核簡繁字串時,要先剔除特殊符號.
 
IMPORT os     #FUN-830021
DATABASE ds
 
GLOBALS "../../config/top.global"
 
##########################################################################
# Descriptions...: 顯示程式資訊視窗，包含程式模組及系統環境變數等訊息
# Date & Author..: 2004/12/03 by Alex
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_about()能
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##########################################################################
 
FUNCTION cl_about()
 
  DEFINE l_about    DYNAMIC ARRAY of RECORD
         gal02      LIKE gal_file.gal02,
         gal03      LIKE gal_file.gal03,
         cus        LIKE ze_file.ze03,
         ver        STRING
                    END RECORD
  DEFINE l_sql      STRING
  DEFINE l_cnt      LIKE type_file.num5          #No.FUN-690005   SMALLINT
  DEFINE l_ze051    LIKE ze_file.ze03
  DEFINE l_ze053    LIKE ze_file.ze03
  DEFINE l_path     STRING
  DEFINE l_ch1      base.Channel
  DEFINE l_buff1    STRING
  DEFINE l_ind      LIKE type_file.num5          #No.FUN-690005   SMALLINT
  DEFINE l_dbtype   LIKE type_file.chr3          #No.FUN-690005   VARCHAR(3)
  DEFINE lch_cmd    base.Channel
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  OPEN WINDOW about_w WITH FORM "lib/42f/cl_about" ATTRIBUTE(STYLE="viewer")
 
  CALL cl_ui_locale("cl_about")
 
  # No.FUN-810085 ---start---
  #若user不是tiptop，則隱藏patch資訊按鈕  #FUN-850099 增加 STACK
  IF g_user CLIPPED <> 'tiptop' THEN
     CALL cl_set_comp_visible("patch_info,check_stack",FALSE)
  ELSE
     CALL cl_set_comp_visible("patch_info,check_stack",TRUE)
  END IF
  # No.FUN-810085 --- end ---
 
 
  LET l_sql = FGL_GETENV("FGLASIP") || "/tiptop/pic/dscmark.JPG"
  DISPLAY l_sql TO tiptop_pic
 
  LET l_dbtype = cl_db_get_database_type()
  CASE l_dbtype
     WHEN "ORA" LET l_sql = FGL_GETENV("ORACLE_SID") 
     WHEN "IFX" LET l_sql = FGL_GETENV("INFORMIXSERVER") 
     WHEN "MSV" LET l_sql = FGL_GETENV("MSSQLAREA") 
     WHEN "ASE" LET l_sql = FGL_GETENV("DSQUERY")           #FUN-AA0017
     OTHERWISE  LET l_sql = " "
  END CASE
  DISPLAY l_sql,g_plant,l_dbtype TO label01,label02,label04
 
   # MOD-510103
  LET l_sql = ""
  LET lch_cmd = base.Channel.create()
  CALL lch_cmd.openPipe("uname -s", "r")
  WHILE lch_cmd.read(l_sql)
  END WHILE
  LET l_sql = l_sql.toUpperCase()
  DISPLAY l_sql TO label03
  LET l_sql = ""
  CALL lch_cmd.openPipe("uname -n", "r")
  WHILE lch_cmd.read(l_sql)
  END WHILE
  LET l_sql = l_sql.toUpperCase()
  DISPLAY l_sql TO label08
  LET l_sql = ""

# #FUN-B60158
# CALL lch_cmd.openPipe("fpi", "r")
# WHILE lch_cmd.read(l_sql)
#    LET l_ind=l_sql.getIndexOf("ersion",1)
#    IF l_ind THEN
#       EXIT WHILE
#    END IF
# END WHILE

  CALL lch_cmd.openPipe("fglrun -V", "r")
  WHILE lch_cmd.read(l_sql)
     LET l_ind=l_sql.getIndexOf("build",1)
     IF l_ind THEN
        EXIT WHILE
     END IF
  END WHILE

  LET l_sql = l_sql.subString(l_ind+7,l_sql.getLength())
  DISPLAY l_sql TO label10
 
  LET l_sql = ""
  LET l_sql = FGL_GETENV("FGLSERVER") 
  DISPLAY l_sql TO label05
 
  LET l_sql = ""
  CALL ui.Interface.frontCall("standard","feinfo","ostype",l_sql)
  DISPLAY l_sql TO label06
 
  LET l_sql = ""
  LET l_sql=ui.Interface.getFrontEndVersion()
  DISPLAY l_sql TO label09
 
  CASE cl_chk_lang() 
     WHEN "1"  LET l_sql="BIG-5"
     WHEN "2"  LET l_sql="UTF-8 (unicode)"
     OTHERWISE LET l_sql="......"
  END CASE
  DISPLAY l_sql TO label07
 
  LET l_sql= "SELECT gal02,gal03 FROM gal_file ",
             " WHERE gal01='",g_prog CLIPPED,"' ",
             " ORDER BY gal02"
 
  SELECT ze03 INTO l_ze051 FROM ze_file
   WHERE ze01="lib-051" AND ze02=g_lang
  SELECT ze03 INTO l_ze053 FROM ze_file
   WHERE ze01="lib-053" AND ze02=g_lang
 
  PREPARE cl_about_pre FROM l_sql
  DECLARE cl_about_cs CURSOR FOR cl_about_pre
  LET l_cnt=1
  FOREACH cl_about_cs INTO l_about[l_cnt].gal02,l_about[l_cnt].gal03
     IF SQLCA.sqlcode THEN
        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF UPSHIFT(l_about[l_cnt].gal02[1,1])="C" THEN
        LET l_about[l_cnt].cus=l_ze051   #FUN-830021
        LET l_path = os.Path.join(FGL_GETENV("CUST") CLIPPED,DOWNSHIFT(l_about[l_cnt].gal02) CLIPPED)
     ELSE
        LET l_about[l_cnt].cus=l_ze053
        LET l_path = os.Path.join(FGL_GETENV("TOP") CLIPPED,DOWNSHIFT(l_about[l_cnt].gal02) CLIPPED)
     END IF
 
     LET l_path = os.Path.join(os.Path.join(l_path.trim(),"4gl"),l_about[l_cnt].gal03 CLIPPED||".4gl")
     LET l_ch1 = base.Channel.create()
     CALL l_ch1.openFile(l_path,"r")
     WHILE l_ch1.read([l_buff1])
        LET l_buff1=l_buff1.trim()
        IF l_buff1.getIndexOf("Prog. Version",1) > 0 THEN
           LET l_ind=l_buff1.getIndexOf("'",1)
           LET l_about[l_cnt].ver = l_buff1.subString(l_ind+1,l_buff1.getIndexOf("'",l_ind+1)-1)
           EXIT WHILE
        END IF
     END WHILE
 
     LET l_cnt = l_cnt + 1
     #No.TQC-630109 --start--
     IF l_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
     #No.TQC-630109 ---end---
  END FOREACH
  CALL l_about.deleteElement(l_cnt)
 
 #CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-770006 mark
  DISPLAY ARRAY l_about TO s_about.* ATTRIBUTE(COUNT=l_cnt-1,UNBUFFERED)
 
     # No.FUN-810085 ---start---
     ON ACTION patch_info
        CALL cl_about_patch_info()
     # No.FUN-810085 --- end ---
 
     ON ACTION check_stack         #FUN-850099
        CALL cl_about_stack()
 
     ON ACTION ie_to_dsc
        LET l_sql=FGL_GETENV("PRODUCERIP")
        IF NOT cl_open_url(l_sql) THEN
           CALL cl_err(l_sql,"lib-054", 1)
        END IF
 
     ON ACTION yes_i_see
        EXIT DISPLAY
 
     #No.TQC-860016 --start--
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION help
        CALL cl_show_help()
     #No.TQC-860016 ---end---
 
  END DISPLAY
 
 #CALL cl_set_act_visible("accept,cancel", TRUE)  #MOD-770006 mark
  CLOSE WINDOW about_w

  CALL lch_cmd.close()
END FUNCTION
 
 
##########################################################################
# Descriptions...: 檢查系統LANG環境變數設定值
# Date & Author..: 05/01/17 by Alex
# Input parameter: none
# Return code....: 0 (FALSE) Check Fail
#                  1         Big5
#                  2         Utf8
# Usage..........: LET l_lang = cl_chk_lang()
##########################################################################
FUNCTION cl_chk_lang()
 
   DEFINE l_dbtype   LIKE type_file.chr3          #No.FUN-690005  VARCHAR(3)
   DEFINE l_langtype STRING
   DEFINE l_ret      LIKE type_file.num5          #No.FUN-690005  SMALLINT
 
   LET l_dbtype=cl_db_get_database_type()
 
   CASE l_dbtype
      WHEN "ORA" 
         LET l_langtype=DOWNSHIFT(FGL_GETENV("LANG"))
         CASE
            WHEN l_langtype.getIndexOf("big5",1) 
               LET l_ret=1
            WHEN l_langtype.getIndexOf("utf8",1) 
               LET l_ret=2
            OTHERWISE
               LET l_ret=0
         END CASE
      WHEN "IFX" 
         LET l_ret=1
      OTHERWISE
         LET l_ret=0
   END CASE
   RETURN l_ret
 
END FUNCTION
 
 
# No.FUN-810085 ---start---
##################################################
# Private Func...: TRUE
# Descriptions...: 檢視patch資料用
# Date & Author..: 08/02/25 By yscheng
##################################################
 
FUNCTION cl_about_patch_info()
DEFINE g_pth_1           DYNAMIC ARRAY OF RECORD
         pth03           LIKE pth_file.pth03,      # patch日期
         pth05           LIKE pth_file.pth05,      # patch時間
         pth04           LIKE pth_file.pth04,      # patch人員
         pth04_name      LIKE gen_file.gen02,      # patch人員姓名
         pth06           LIKE pth_file.pth06,      # patch單號
         pth07           LIKE pth_file.pth07       # patch檔名
                         END RECORD
DEFINE g_pth_2           DYNAMIC ARRAY OF RECORD
         no              LIKE type_file.num5,      # 項次
         pth02           LIKE pth_file.pth02,      # zl版本
         pth01           LIKE pth_file.pth01       # zl單號
                         END RECORD
DEFINE   li_cnt          LIKE type_file.num5
DEFINE   li_cnt_2        LIKE type_file.num5
DEFINE   li_result       LIKE type_file.num5
DEFINE   ls_remain_sec   LIKE type_file.num5
DEFINE   ls_msg_cnt      LIKE type_file.num5
DEFINE   l_ac            LIKE type_file.num5
DEFINE   g_rec_b         LIKE type_file.num5
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW patch_w WITH FORM "lib/42f/cl_patch" ATTRIBUTE(STYLE="viewer")
 
   CALL cl_ui_locale("cl_patch")
 
   CALL cl_set_act_visible("patch_data",FALSE)
   CALL cl_set_act_visible("zl_data",TRUE)
   CALL cl_set_act_visible("accept",TRUE)
   LET li_cnt = 1
   DECLARE pth_curs_1 CURSOR FOR
      SELECT UNIQUE pth03,pth05,pth04,'',pth06,pth07 FROM pth_file
 
   CALL g_pth_1.clear()
 
   FOREACH pth_curs_1 INTO g_pth_1[li_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
  
      SELECT gen02 INTO g_pth_1[li_cnt].pth04_name FROM gen_file
       WHERE gen01 = g_pth_1[li_cnt].pth04
 
      LET li_cnt = li_cnt + 1
      IF li_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pth_1.deleteElement(li_cnt)
   LET g_rec_b = li_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.patch_count
   LET li_cnt = 0
 
   DISPLAY ARRAY g_pth_1 TO s_pth_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN
               LET li_cnt_2 = 1
               DECLARE pth_curs_2 CURSOR FOR
                  SELECT '',pth02,pth01 FROM pth_file
                   WHERE pth03 = g_pth_1[l_ac].pth03
                     AND pth04 = g_pth_1[l_ac].pth04
                     AND pth05 = g_pth_1[l_ac].pth05
 
               CALL g_pth_2.clear()
 
               FOREACH pth_curs_2 INTO g_pth_2[li_cnt_2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                     EXIT FOREACH
                  END IF
 
                  LET g_pth_2[li_cnt_2].no = li_cnt_2
 
                  LET li_cnt_2 = li_cnt_2 + 1
                  IF li_cnt_2 > g_max_rec THEN
                     CALL cl_err( '', 9035, 0 )
                     EXIT FOREACH
                  END IF
               END FOREACH
               CALL g_pth_2.deleteElement(li_cnt_2)
               LET li_cnt_2 = li_cnt_2 - 1
               DISPLAY li_cnt_2 TO FORMONLY.zl_count
    
               DISPLAY ARRAY g_pth_2 TO s_pth_2.* ATTRIBUTE(COUNT=li_cnt_2,UNBUFFERED)
                  BEFORE ROW
                     EXIT DISPLAY
               END DISPLAY
            END IF
 
         ON ACTION close
            EXIT DISPLAY
 
         ON ACTION zl_data
            CALL cl_about_zl_data(g_pth_1[l_ac].pth03,g_pth_1[l_ac].pth04,g_pth_1[l_ac].pth05)
            EXIT DISPLAY
 
         ON ACTION accept
            CALL cl_about_zl_data(g_pth_1[l_ac].pth03,g_pth_1[l_ac].pth04,g_pth_1[l_ac].pth05)
            EXIT DISPLAY
 
         #No.TQC-860016 --start--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION help
            CALL cl_show_help()
         #No.TQC-860016 ---end---
 
   END DISPLAY
#  CALL cl_about_set_act_visible("accept",TRUE)
   CLOSE WINDOW patch_w
END FUNCTION
 
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 檢視zl資料用
# Date & Author..: 08/02/25 By yscheng
##################################################
 
FUNCTION cl_about_zl_data(lr_pth)
DEFINE lr_pth                 RECORD
          pth03               LIKE pth_file.pth03,
          pth04               LIKE pth_file.pth04,
          pth05               LIKE pth_file.pth05
                              END RECORD
DEFINE g_pth_2                DYNAMIC ARRAY OF RECORD
         no                   LIKE type_file.num5,      # 項次
         pth02                LIKE pth_file.pth02,      # zl版本
         pth01                LIKE pth_file.pth01       # zl單號
                              END RECORD
DEFINE li_cnt                 LIKE type_file.num5
DEFINE li_cnt_2               LIKE type_file.num5
DEFINE li_result              LIKE type_file.num5
DEFINE ls_remain_sec          LIKE type_file.num5
DEFINE ls_msg_cnt             LIKE type_file.num5
 
 
      CALL cl_set_act_visible("zl_data",FALSE)
      CALL cl_set_act_visible("accept",FALSE)
      CALL cl_set_act_visible("patch_data",TRUE)
      LET li_cnt_2 = 1
      DECLARE pth_curs_zl_data CURSOR FOR
         SELECT '',pth02,pth01 FROM pth_file
          WHERE pth03 = lr_pth.pth03
            AND pth04 = lr_pth.pth04
            AND pth05 = lr_pth.pth05
 
      CALL g_pth_2.clear()
 
      FOREACH pth_curs_zl_data INTO g_pth_2[li_cnt_2].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET g_pth_2[li_cnt_2].no = li_cnt_2
 
         LET li_cnt_2 = li_cnt_2 + 1
         IF li_cnt_2 > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_pth_2.deleteElement(li_cnt_2)
      LET li_cnt_2 = li_cnt_2 - 1
      DISPLAY li_cnt_2 TO FORMONLY.zl_count
 
      DISPLAY ARRAY g_pth_2 TO s_pth_2.* ATTRIBUTE(COUNT=li_cnt_2,UNBUFFERED)
 
         ON ACTION close
            EXIT DISPLAY
 
         ON ACTION accept
 
         ON ACTION patch_data
            CALL cl_about_patch_info()
            EXIT DISPLAY
 
         #No.TQC-860016 --start--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION help
            CALL cl_show_help()
         #No.TQC-860016 ---end---
 
      END DISPLAY
END FUNCTION
# No.FUN-810085 --- end ---
 
##################################################
# Descriptions...: cp -R (source,target)
# Date & Author..: 08/03/05 By alex
# Input parameter: ls_source  STRING 資料來源
#                  ls_target  STRING 資料目的
# Return code....: TRUE/FALSE , error_path
##################################################
 
FUNCTION cl_cp_r(ls_spath,ls_tpath)    #FUN-830021
 
   DEFINE ls_spath   STRING
   DEFINE ls_tpath   STRING
   DEFINE ls_child   STRING
   DEFINE li_h       LIKE type_file.num5
   DEFINE li_err     LIKE type_file.num5
   DEFINE ls_err     STRING
 
   IF NOT os.Path.exists(ls_spath) THEN
      RETURN FALSE,ls_spath
   END IF
   IF NOT os.Path.isdirectory(ls_spath) THEN
      IF os.Path.copy(ls_spath,ls_tpath) THEN
         RETURN TRUE,""
      ELSE
         RETURN FALSE,ls_spath
      END IF
   END IF
   CALL os.Path.dirsort("name", 1)
   IF NOT os.Path.mkdir(ls_tpath) THEN
      RETURN FALSE,ls_tpath
   END IF
   LET li_h = os.Path.diropen(ls_spath)
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
      CALL cl_cp_r(os.Path.join(ls_spath,ls_child),
                   os.Path.join(ls_tpath,ls_child)) RETURNING li_err,ls_err
      IF NOT li_err THEN RETURN FALSE,ls_err END IF
   END WHILE
   CALL os.Path.dirclose(li_h)
   RETURN TRUE,""
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示目前stack狀態
# Date & Author..: 08/12/16 By alex    #FUN-850099
##################################################
FUNCTION cl_about_stack()
 
   DEFINE ls_stack_msg  STRING
 
   OPEN WINDOW about_stack_w WITH FORM "lib/42f/cl_about_s"
      ATTRIBUTE(STYLE="viewer")
   CALL cl_ui_locale("cl_about_s")
 
   LET ls_stack_msg = base.Application.getStackTrace()
   DISPLAY ls_stack_msg TO FORMONLY.stackmsg
 
   MENU ""
      ON ACTION yes_i_see
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
   END MENU
 
   CLOSE WINDOW about_stack_w
END FUNCTION


###FUN-B90139 START ###
##################################################
# Descriptions...: 檢查輸入的資料在unicode下是否屬於繁體或簡體字的範圍
# Date & Author..: 10/08/31 By alex
# Input parameter: lc_gay01 0或2 (表示待查的是繁體字或簡體字)
#                  ls_str   待檢查的字串
#                  pi_idle_sec      SMALLINT   錯誤訊息IDLE秒數
# Return code....: TRUE/FALSE 合格或不合格
# Usage..........: CALL cl_unicode_check02("0","這裡面不含有簡體字")
##################################################
FUNCTION cl_unicode_check02(lc_gay01,ls_str,pi_idle_sec)

   DEFINE lc_gay01     LIKE gay_file.gay01
   DEFINE ls_str       STRING
   DEFINE pi_idle_sec  LIKE type_file.num5  #訊息IDLE秒數   #FUN-B90139
   DEFINE ls_cmd       STRING
   DEFINE ls_result    STRING
   DEFINE ls_temp      STRING    #TEMPDIR路徑
   DEFINE ls_msg       STRING               #訊息        #FUN-B90139
   DEFINE l_gay03      LIKE gay_file.gay03  #語言別名稱   #FUN-B90139
   DEFINE l_sql        STRING               #FUN-B90139
   DEFINE l_str_ch     base.Channel #FUN-BB0104

   IF ls_str IS NULL THEN
      RETURN TRUE   #傳入值為空的時候,不查
   END IF 

   ###FUN-B90139 START ###
   LET ls_msg = NULL
   LET l_sql = 'SELECT gay03 FROM gay_file',
                ' WHERE gay01 = ? AND gayacti = "Y"'
   PREPARE cl_unicode_check02_pre FROM l_sql
   EXECUTE cl_unicode_check02_pre USING lc_gay01 INTO l_gay03
   
   LET ls_msg = ls_str CLIPPED,"|",l_gay03 CLIPPED   
   ###FUN-B90139 END ###

   LET ls_temp = os.Path.join(FGL_GETENV("TEMPDIR"),FGL_GETPID())
     
   LET ls_cmd = "\\rm -rf ",ls_temp.trim(),"qc.src ",ls_temp.trim(),"qc.tran ",ls_temp.trim(),"qc.u8 ",ls_temp.trim(),"qc.dif"
   RUN ls_cmd
   #Begin:FUN-BB0104
   #LET ls_cmd = "echo '",ls_str.trim(),"' > ",ls_temp.trim(),"qc.src"
   #RUN ls_cmd
   LET l_str_ch = base.Channel.create()
   CALL l_str_ch.openFile(ls_temp.trim()||"qc.src", "w")
   LET ls_str = cl_get_check_string(ls_str) #FUN-BB0152
   CALL l_str_ch.writeLine(ls_str.trim())
   CALL l_str_ch.close()
   #End:FUN-BB0104
   CASE 
      WHEN lc_gay01 = "0"
         LET ls_cmd = "iconv -f UTF-8 -t BIG5 "
      WHEN lc_gay01 = "2"
         LET ls_cmd = "iconv -f UTF-8 -t GB2312 "
      OTHERWISE
         RETURN TRUE   #傳入值不為簡體或繁體,不查
   END CASE
   LET ls_cmd = ls_cmd,ls_temp.trim(),"qc.src > ",ls_temp.trim(),"qc.tran "
   RUN ls_cmd
   IF os.Path.size(ls_temp.trim()||"qc.tran") = 0 THEN
      CALL cl_err_msg("","lib-622",ls_msg,pi_idle_sec)   #FUN-B90139
      RETURN FALSE
   END IF
   CASE 
      WHEN lc_gay01 = "0"
         LET ls_cmd = "iconv -f BIG5 -t UTF-8 "
      WHEN lc_gay01 = "2"
         LET ls_cmd = "iconv -f GB2312 -t UTF-8 "
   END CASE
   LET ls_cmd = ls_cmd,ls_temp.trim(),"qc.tran > ",ls_temp.trim(),"qc.u8 "
   RUN ls_cmd
   LET ls_cmd = "diff ",ls_temp.trim(),"qc.src ",ls_temp.trim(),"qc.u8 > ",ls_temp.trim(),"qc.dif"
   RUN ls_cmd
   IF os.Path.size(ls_temp.trim()||"qc.dif") > 0 THEN
      CALL cl_err_msg("","lib-622",ls_msg,pi_idle_sec)   #FUN-B90139
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION
###FUN-B90139 END ###


##################################################
# Descriptions...: 在桌面上產生捷徑檔
# Date & Author..: 11/09/23 By alex
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_generate_shortcut()
##################################################
FUNCTION cl_generate_shortcut()
    DEFINE ls_temp_dir    STRING
    DEFINE ls_temp_file   STRING
    DEFINE ls_bat_file   STRING
    DEFINE ls_str        STRING
    DEFINE ls_str2       STRING 
    DEFINE lc_channel    base.Channel
    DEFINE ls_file STRING
    DEFINE ls_window_path STRING                 
           
    LET ls_temp_file = g_prog,".txt"         #p_zz.txt
    LET ls_bat_file = "DSC_",g_prog,".bat"   #DSC_p_zz.bat
    LET ls_temp_dir = FGL_GETENV("TEMPDIR")
    LET ls_temp_dir = os.Path.join(ls_temp_dir,ls_temp_file)
              
    LET ls_window_path = cl_browse_dir()
    LET ls_window_path = os.Path.join(ls_window_path,ls_bat_file)
                 
    LET lc_channel = base.Channel.create()
    CALL lc_channel.openFile(ls_temp_dir CLIPPED, "w" ) #a : For Append mode
    CALL lc_channel.setDelimiter("")
           
    LET ls_str = "@echo off\n"   
    LET ls_str = ls_str,"CD \"C:\\Program Files\\DSC\\TIPTOPSSO\\\"\n" #目前根據TIPTOPSSO安裝路徑>
    LET ls_str = ls_str,"START TIPTOPSSO.exe ",g_user CLIPPED," " ,g_plant CLIPPED," ",g_prog CLIPPED ,"\n"
    LET ls_str = ls_str, "EXIT\n"
    CALL lc_channel.write(ls_str)
    CALL lc_channel.close()
                                  #先產生tmp之後下載到目的
    LET status = cl_download_file(ls_temp_dir,ls_window_path)  #cl_download_file("/tmp/a.doc", "C:
    #DISPLAY "status:",status
    IF status THEN
       CALL cl_err(ls_window_path,"azz1087",1)
    ELSE
       CALL cl_err(ls_window_path,"azz1088",1)
    END IF

END FUNCTION

#Begin:FUN-BB0152:若是有修改,請同步修改cl_user.4gl內的FUNCTION cl_trans_utf8_twzh.
##################################################
# Descriptions...: 檢核簡繁體字串時,先剔除特殊符號(gaq02)
# Date & Author..: 11/11/30 by Hiko
# Input parameter: ps_str   待檢查的原始字串
# Return code....: l_chk_str 真正需要檢查的字串
# Usage..........: CALL cl_get_check_string(l_str)
##################################################
FUNCTION cl_get_check_string(p_src)
   DEFINE p_src STRING #來源字串
   DEFINE l_sbuf      base.StringBuffer, #最後要透過StringBuffer來合併l_sym_arr的資料
          l_char_idx  SMALLINT, #來源字串的字元索引
          l_char      STRING,   #依據l_char_idx取得的字元
          l_more      SMALLINT, #為了避免特殊字元取替代時會有過多的空白,所以要記錄特殊字元還有多少長度
          l_char_trim STRING,   #為了檢查方便,所以將字元trim空白
          l_chk_sql   STRING,   #判斷l_char是否為特殊字元的SQL
          l_sp_cnt    SMALLINT  #執行l_chk_sql的回傳值

   LET p_src = p_src.trim()
   LET l_sbuf = base.StringBuffer.create()

   FOR l_char_idx=1 TO p_src.getLength()
      IF l_more>0 THEN #這裡是參考cl_set_data_mask的做法.
         LET l_more = l_more - 1
      ELSE
         LET l_char = p_src.getCharAt(l_char_idx)
         IF l_char IS NOT NULL THEN
            IF l_char.getLength()>1 THEN
               LET l_more = l_char.getLength() - 1 #這裡很重要,決定了之後替代字串時是否正確.
               LET l_char_trim = l_char.trim()
               #因為包含特殊符號的資料畢竟少數,因此先以SQL檢查速度會比較快.
               LET l_chk_sql = "SELECT COUNT(*) FROM gfq_file WHERE gfq02='",l_char_trim,"'"
               PREPARE chk_sp_pre FROM l_chk_sql
               EXECUTE chk_sp_pre INTO l_sp_cnt
               FREE chk_sp_pre
               IF l_sp_cnt == 0 THEN #表示要檢查的字串不包含特殊符號.
                  CALL l_sbuf.append(l_char_trim) #這裡是暫存中文字.
               END IF
            ELSE
               CALL l_sbuf.append(l_char) #這裡是暫存非中文字,且非特殊符號.
            END IF
         END IF
      END IF
   END FOR

   RETURN l_sbuf.toString()
END FUNCTION
#End:FUN-BB0152
