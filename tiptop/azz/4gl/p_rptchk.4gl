# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_rptchk.4gl
# Descriptions...: 報表rpt檢核工具
# Date & Author..: No.FUN-840215 2009/01/14 By joyce 新增報表rpt檢核工具p_rptchk
# Modify.........: No.MOD-920318 09/02/25 Dido 客制路徑調整
 
IMPORT os
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE  g_argv1                STRING
DEFINE  g_toppath              STRING
DEFINE  g_chkfile              STRING
DEFINE  g_chkfilelist          STRING
DEFINE  g_chkrptlist           STRING
DEFINE  g_show_msg             DYNAMIC ARRAY OF RECORD
                               zz011         LIKE zz_file.zz011,         # 模組名稱
                               zaw01         LIKE zaw_file.zaw01,        # 程式代號
                               gaz03         LIKE gaz_file.gaz03,        # 程式名稱
                               zaw02         LIKE zaw_file.zaw02,        # 樣板代號
                               zaw03         LIKE zaw_file.zaw03,        # 客製否
                               zaw06         LIKE zaw_file.zaw06,        # 語言別
                               zaw08         LIKE zaw_file.zaw08,        # cr樣板名稱(.rpt)
                               ze01          LIKE ze_file.ze01,          # 錯誤訊息代號
                               ze03          LIKE ze_file.ze03           # 錯誤訊息內容
                               END RECORD
DEFINE  g_show_title           STRING
DEFINE  g_show_field           STRING
DEFINE  g_show_cnt             INTEGER
DEFINE  g_show_err             SMALLINT
DEFINE  g_show_fieldname       STRING           
 
MAIN
   DEFINE   p_row,p_col        LIKE type_file.num5      #No.FUN-680135  SMALLINT 
 
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
 
   LET g_argv1 = ARG_VAL(1)              #
   LET g_toppath = FGL_GETENV("TOP")
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW p_rptchk_w AT p_row,p_col WITH FORM "azz/42f/p_rptchk"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   WHILE TRUE
      CALL p_rptchk_chkstart()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p_rptchk_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_rptchk_chkstart()
   DEFINE   g_rpt_clientpath            STRING
   DEFINE   g_rpt_clientpath_std        STRING
   DEFINE   g_rpt_clientpath_cust       STRING
   DEFINE   ls_rpt_serverpath           STRING
   DEFINE   ls_exec                     STRING
   DEFINE   ls_code_check               SMALLINT
   DEFINE   ls_txtpath                  STRING
   DEFINE   ls_file                     STRING
   DEFINE   ls_code_upload              SMALLINT
   DEFINE   ls_ch_std                   base.Channel
   DEFINE   ls_ch_cust                  base.Channel
   DEFINE   ls_buf                      base.StringBuffer
   DEFINE   ls_code_std                 STRING
   DEFINE   ls_code_cust                STRING
   DEFINE   ls_cnt                      LIKE type_file.num5
 
   INPUT g_rpt_clientpath WITHOUT DEFAULTS FROM FORMONLY.path
 
      AFTER FIELD path
         IF cl_null(g_rpt_clientpath) THEN
            CALL cl_err("The path is empty,please check it again","!",1)
            NEXT FIELD path
         ELSE
            IF g_rpt_clientpath.subString(g_rpt_clientpath.getLength(),g_rpt_clientpath.getLength()) = "/" THEN
               LET g_rpt_clientpath = g_rpt_clientpath.subString(1,g_rpt_clientpath.getLength()-1)
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(FORMONLY.path)
               CALL cl_browse_dir() RETURNING g_rpt_clientpath
               DISPLAY g_rpt_clientpath TO FORMONLY.path
               NEXT FIELD FORMONLY.path
         END CASE
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#        EXIT INPUT
 
      ON ACTION exit
         EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      RETURN
   END IF
 
   LET g_show_err = FALSE
 
   # 報表rpt存放路徑有分為標準安裝及客製區域
   LET g_rpt_clientpath_std = g_rpt_clientpath,"/tiptop"
   LET g_rpt_clientpath_cust = g_rpt_clientpath,"/topcust"
 
   # 檢核檔案存在否所使用的工具
#  LET g_chkfile = "d:\\\\rptchk.bat"
 
   LET ls_cnt = 0
   WHILE TRUE
      IF g_rpt_clientpath.getIndexOf("/",ls_cnt+1) > 1 THEN
         LET ls_cnt = g_rpt_clientpath.getIndexOf("/",ls_cnt+1)
      ELSE
         IF ls_cnt > 1 THEN
            LET g_chkfile = g_rpt_clientpath.subString(1,ls_cnt-1)
         ELSE
            LET g_chkfile = g_rpt_clientpath
         END IF
         EXIT WHILE
      END IF
   END WHILE
 
   LET g_chkfile = g_chkfile,"/rptchk.bat"
 
   LET ls_buf = base.StringBuffer.create()
   CALL ls_buf.append(g_chkfile)
   CALL ls_buf.replace("/","\\\\",1)
   LET g_chkfile = ls_buf.toString()
   CALL ls_buf.replace("/","\\",0)
   LET g_chkfile = ls_buf.toString()
 
   LET g_chkfilelist = g_chkfile.subString(1,g_chkfile.getIndexOf(".bat",1)-1),".txt"
   LET g_chkrptlist = g_chkfile.subString(1,g_chkfile.getIndexOf(".bat",1)-1),"_list.txt"
 
   # 將檢核使用者輸入的路徑是否存在，並將結果導入一文字檔中
   LET ls_exec = 'Cmd.exe /c \"',g_chkfile,' ',g_rpt_clientpath_std,' > ',g_chkfilelist,'"'
   DISPLAY ls_exec
 
   # 執行指令
   CALL ui.Interface.frontCall("standard","shellexec",[ls_exec],[ls_code_check])
 
   IF ls_code_check THEN
      LET ls_file = g_chkfilelist.subString(g_chkfilelist.getIndexOf("rptchk",1),g_chkfilelist.getLength())
      LET ls_txtpath = g_toppath CLIPPED,"/tmp/",ls_file CLIPPED
 
      # 將檢核使用者輸入的路徑是否存在的檔案上傳
      CALL cl_upload_file(g_chkfilelist,ls_txtpath) RETURNING ls_code_upload
 
      IF ls_code_upload THEN
         LET ls_ch_std = base.Channel.create()
 
         # 讀取上傳的檔案
         CALL ls_ch_std.openFile(ls_txtpath CLIPPED, "r")
         WHILE ls_ch_std.read(ls_code_std)
            DISPLAY ls_code_std
 
            # 檢核結果若目錄存在才繼續往下進行
            IF ls_code_std MATCHES "*TRUE*" THEN
               # 檢核CR主機rpt是否存在
               CALL p_rptchk_zaw(g_rpt_clientpath_std,"N")
            ELSE
               CALL cl_err("所輸入的路徑不正確，請重新確認","!",1)
            END IF
         END WHILE
         CALL ls_ch_std.close()
 
 
 
         # 將檢核客製目錄的路徑是否存在，並將結果導入一文字檔中
         LET ls_exec = 'Cmd.exe /c \"',g_chkfile,' ',g_rpt_clientpath_cust,' > ',g_chkfilelist,'"'
         DISPLAY ls_exec
    
         # 執行指令
         CALL ui.Interface.frontCall("standard","shellexec",[ls_exec],[ls_code_check])
    
         IF ls_code_check THEN
            LET ls_file = g_chkfilelist.subString(g_chkfilelist.getIndexOf("rptchk",1),g_chkfilelist.getLength())
            LET ls_txtpath = g_toppath CLIPPED,"/tmp/",ls_file CLIPPED
    
            # 將檢核客製目錄的路徑是否存在的檔案上傳
            CALL cl_upload_file(g_chkfilelist,ls_txtpath) RETURNING ls_code_upload
    
            IF ls_code_upload THEN
               LET ls_ch_cust = base.Channel.create()
    
               # 讀取上傳的檔案
               CALL ls_ch_cust.openFile(ls_txtpath CLIPPED, "r")
               WHILE ls_ch_cust.read(ls_code_cust)
                  DISPLAY ls_code_cust
 
                  # 檢核結果若目錄存在才繼續往下進行
                  IF ls_code_cust MATCHES "*TRUE*" THEN
                     # 檢核CR主機客製rpt是否存在
                     CALL p_rptchk_zaw(g_rpt_clientpath_cust,"Y")
                  ELSE
                     CALL cl_err("客製目錄路徑不正確，無法檢核客製rpt是否存在","!",1)
                  END IF
               END WHILE
               CALL ls_ch_cust.close()
            END IF
         END IF
         CALL p_rptchk_show_err()
      END IF
   END IF
END FUNCTION
 
FUNCTION p_rptchk_zaw(li_zawrpt_clientpath,li_zawrpt_cust)
   DEFINE li_zaw    RECORD
                    zz011    LIKE zz_file.zz011,    # 模組名稱
                    zaw01    LIKE zaw_file.zaw01,   # 程式代碼
                    zaw02    LIKE zaw_file.zaw02,   # 樣板代號
                    zaw03    LIKE zaw_file.zaw03,   # 客製否
                    zaw06    LIKE zaw_file.zaw06,   # 語言別
                    zaw08    LIKE zaw_file.zaw08    # rpt樣板名稱
                    END RECORD
   DEFINE g_rpt_filepath          STRING
   DEFINE li_zz011_old            STRING
   DEFINE li_zz011_new            STRING
   DEFINE li_zawrpt_clientpath    STRING                         # rpt存放目錄路徑
   DEFINE li_zawrpt_cust          LIKE type_file.chr1            # 判斷是否為客製資料
   DEFINE li_sql                  STRING
   DEFINE li_zawexec              STRING
   DEFINE li_zawcode_chk          SMALLINT
   DEFINE li_zawfile              STRING
   DEFINE li_zawpath              STRING
   DEFINE li_zawcode_upload       STRING
   DEFINE li_zawch                base.Channel
   DEFINE li_zawcode              STRING
 
 
   LET li_sql = "SELECT zz011,zaw01,zaw02,zaw03,zaw06,zaw08",
                 " FROM zz_file,zaw_file",
                " WHERE zz01 = zaw01"
 
   # 判斷是否取客製資料
   IF li_zawrpt_cust = "Y" THEN
      LET li_sql = li_sql CLIPPED," AND zaw03 = 'Y'"
   ELSE
      LET li_sql = li_sql CLIPPED," AND zaw03 = 'N'"
   END IF
 
   INITIALIZE li_zaw.* TO NULL
   PREPARE p_rptchk_zaw_pre FROM li_sql
   DECLARE p_rptchk_zaw_cur CURSOR FOR p_rptchk_zaw_pre
 
   FOREACH p_rptchk_zaw_cur INTO li_zaw.*
 
      # 若為客製資料，需將模組名稱替換成客製模組名稱
      LET li_zz011_old = li_zaw.zz011 CLIPPED
      IF li_zaw.zaw03 = "Y" THEN
         IF li_zz011_old.subString(1,1) = "A" THEN
            LET li_zz011_new = "C",li_zz011_old.subString(2,li_zz011_old.getLength())
         ELSE
           #LET li_zz011_new = "C",li_zaw.zz011 CLIPPED  #MOD-920318 mark
            LET li_zz011_new = li_zaw.zz011 CLIPPED      #MOD-920318
         END IF
      ELSE
         LET li_zz011_new = li_zaw.zz011 CLIPPED
      END IF
 
      # 組rpt路徑
      LET g_rpt_filepath = li_zawrpt_clientpath,"/",DOWNSHIFT(li_zz011_new),"/",
                                 li_zaw.zaw01,"/",li_zaw.zaw06,"/",li_zaw.zaw08,".rpt"
      DISPLAY g_rpt_filepath
 
      # 將檢核rpt是否存在並將結果導入一文字檔中
      LET li_zawexec = 'Cmd.exe /c \"',g_chkfile,' ',g_rpt_filepath,' > ',g_chkrptlist,'"'
      DISPLAY li_zawexec
 
      CALL ui.Interface.frontCall("standard","shellexec",[li_zawexec],[li_zawcode_chk])
      IF li_zawcode_chk THEN
         LET li_zawfile = g_chkrptlist.subString(g_chkrptlist.getIndexOf("rptchk_list",1),g_chkrptlist.getLength())
         LET li_zawpath = g_toppath CLIPPED,"/tmp/",li_zawfile CLIPPED
 
         # 將檢核rpt是否存在的檔案上傳
         CALL cl_upload_file(g_chkrptlist,li_zawpath) RETURNING li_zawcode_upload
 
         IF li_zawcode_upload THEN
            LET li_zawch = base.Channel.create()
 
            # 讀取上傳的檔案
            CALL li_zawch.openFile(li_zawpath CLIPPED, "r")
            WHILE li_zawch.read(li_zawcode)
               DISPLAY li_zawcode
               # 若檢核結果為不存在，則製成列表
               IF li_zawcode NOT MATCHES "*TRUE*" THEN
                  LET g_show_cnt = g_show_msg.getLength() + 1
                  LET g_show_msg[g_show_cnt].zz011 = li_zz011_new CLIPPED
                  LET g_show_msg[g_show_cnt].zaw01 = li_zaw.zaw01 CLIPPED
                  LET g_show_msg[g_show_cnt].gaz03 = cl_get_progdesc(li_zaw.zaw01 CLIPPED,g_lang)
                  LET g_show_msg[g_show_cnt].zaw02 = li_zaw.zaw02 CLIPPED
                  LET g_show_msg[g_show_cnt].zaw03 = li_zaw.zaw03 CLIPPED
                  LET g_show_msg[g_show_cnt].zaw06 = li_zaw.zaw06 CLIPPED
                  LET g_show_msg[g_show_cnt].zaw08 = li_zaw.zaw08 CLIPPED
                  LET g_show_msg[g_show_cnt].ze01 = ""
                  LET g_show_msg[g_show_cnt].ze03 = "zaw_file中記錄的rpt在CR主機上找不到"
                  LET g_show_cnt = g_show_cnt + 1
                  LET g_show_err = TRUE
               END IF
            END WHILE
            CALL li_zawch.close()
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p_rptchk_show_err()
 
   IF g_show_err THEN
      CALL cl_get_feldname("zz011",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("zaw01",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("gaz03",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("zaw02",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("zaw03",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("zaw06",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("zaw08",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("ze01",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      CALL cl_get_feldname("ze03",g_lang) RETURNING g_show_fieldname
      LET g_show_field = g_show_field.trim(),"|",g_show_fieldname CLIPPED
 
      LET g_show_title = "報表rpt異常列表"
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_show_title,g_show_field)
   END IF
END FUNCTION
# No.FUN-840215
