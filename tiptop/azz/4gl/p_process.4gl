# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_process.4gl 
# Descriptions...: 線上使用情況
# Date & Author..: 04/04/06 by Brendan
# Modify.........: No.FUN-5A0222 05/11/22 By saki 更改process的資訊，使用gbq_file對應ps -ef的指令
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-660158 06/06/29 By saki 報表列印功能
# Modify.........: No.FUN-660135 06/07/12 By saki 增加使用資料庫
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.FUN-740179 07/06/14 By saki 調整accept,cancel鍵
# Modify.........: No.FUN-780050 07/08/16 By Brendan 本作業應不受查詢筆數參數設定限制(取消 TQC-630107 修改)
# Modify.........: No.MOD-820022 08/02/13 By alexstar 設定環境變數指令改成Sun OS可以使用的方式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-950082 10/05/06 By alex 增加查看AP Server
# Modify.........: No.FUN-A80037 10/08/05 By alex 跨AP顯示完整的gbq_file內容，並予以適當標示非本機process
# Modify.........: No.MOD-B70145 11/07/14 By Vampire 多了 COLUMN g_c[40],sr.p09 欄位。導致列印失敗。
# Modify.........: No.TQC-B90122 11/12/29 By ka0132 增加gi_count的增量 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE la_license      DYNAMIC ARRAY OF RECORD
           ip             LIKE type_file.chr50,
           ap             LIKE type_file.chr50
                          END RECORD
END GLOBALS

DEFINE ga_process   DYNAMIC ARRAY OF RECORD
                       p01       STRING,   #Login User
                       user_name STRING,   #User Name
                       p02       STRING,   #Login IP
                       p03       STRING,   #PID
                       p04       STRING,   #Department
                       p05       STRING,   #Start Time
                       p06       STRING,   #GUI Mode
                       p07       STRING,   #Execution Command
                       p08       STRING,   #Database No.FUN-660135
                       p09       STRING    #Multi-AP No.FUN-950082
                    END RECORD
DEFINE ga_color     DYNAMIC ARRAY OF RECORD
                       c01   STRING,
                       c02   STRING,
                       c03   STRING,
                       c04   STRING,
                       c05   STRING,
                       c06   STRING
                    END RECORD
DEFINE gi_count     LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE gi_arr       LIKE type_file.num10   #No.FUN-680135 INTEGER
 
MAIN
   OPTIONS 
       INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog, g_time, 1) RETURNING g_time 
 
   OPEN WINDOW p_process_w WITH FORM "azz/42f/p_process" 
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      LET g_action_choice = NULL
      CALL p_generateProcessList()
      CALL p_showProcessList()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p_process_w                  # 結束畫面

   CALL cl_used(g_prog, g_time, 2) RETURNING g_time 
END MAIN
 
FUNCTION p_generateProcessList()
   DEFINE lch_cmd     base.Channel
   DEFINE ls_cmd      STRING,
          ls_result   STRING,
          ls_token    STRING
   DEFINE lst_token   base.StringTokenizer
   DEFINE li_i        LIKE type_file.num10,   #No.FUN-680135 INTEGER
          li_minute   LIKE type_file.num10    #No.FUN-680135 INTEGER
   #No.FUN-5A0222 --start--
   DEFINE ls_sql      STRING
   DEFINE lr_gbq      DYNAMIC ARRAY OF RECORD LIKE gbq_file.*
   DEFINE li_j        LIKE type_file.num10    #No.FUN-680135 INTEGER
   #No.FUN-5A0222 ---end---
   DEFINE lc_zx01     LIKE zx_file.zx01   #No.FUN-A80037
   DEFINE lc_zx02     LIKE zx_file.zx02   #No.FUN-660158
 
   #No.FUN-5A0222 --start-- 拿出gbq_file裡面的資料準備對照
   CALL cl_process_check()  #先將gbq_file內的資料refresh
   LET ls_sql = "SELECT * FROM gbq_file ORDER BY gbq03,gbq02,gbq01"
   PREPARE gbq_pre FROM ls_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre
 
   LET gi_count = 1
   FOREACH gbq_curs INTO lr_gbq[gi_count].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      LET gi_count = gi_count + 1
   END FOREACH
   CALL lr_gbq.deleteElement(gi_count)
   #No.FUN-5A0222 ---end---
 
   CALL ga_process.clear()
   CALL ga_color.clear()
   LET gi_count = 1
 
   CALL fgl_setenv("COLUMNS","132")
   LET ls_cmd = "ps -ef | grep fglrun | grep -v 'grep'"
 
   LET lch_cmd = base.Channel.create()
   CALL lch_cmd.openPipe(ls_cmd, "r")
   WHILE lch_cmd.read(ls_result)
       LET lst_token = base.StringTokenizer.create(ls_result, ' ')
       LET li_i = 1
       WHILE lst_token.hasMoreTokens()
           LET ls_token = lst_token.nextToken()
           #No.FUN-5A0222 --start--
           CASE
                WHEN li_i = 1   #Login User
                     LET ga_process[gi_count].p01 = ls_token
                WHEN li_i = 2   #PID
                     LET ga_process[gi_count].p03 = ls_token
                WHEN li_i = 5   #Start Time
                     LET ga_process[gi_count].p05 = ls_token
#               WHEN li_i = 6
#                    LET ga_process[gi_count].p04 = ls_token
#               WHEN li_i = 7
#                    LET ga_process[gi_count].p05 = ls_token
#                    LET li_minute = ls_token.subString(1, ls_token.getIndexOf(':', 1) - 1)
#                    IF li_minute >= 5 THEN
#                       LET ga_color[gi_count].c01 = "red" 
#                       LET ga_color[gi_count].c02 = "red" 
#                       LET ga_color[gi_count].c03 = "red" 
#                       LET ga_color[gi_count].c04 = "red" 
#                       LET ga_color[gi_count].c05 = "red" 
#                       LET ga_color[gi_count].c06 = "red" 
#                    ELSE
#                       LET ga_color[gi_count].c01 = "black" 
#                       LET ga_color[gi_count].c02 = "black" 
#                       LET ga_color[gi_count].c03 = "black" 
#                       LET ga_color[gi_count].c04 = "black" 
#                       LET ga_color[gi_count].c05 = "black" 
#                       LET ga_color[gi_count].c06 = "black" 
#                    END IF
                WHEN li_i >= 9    #Execution Command
                     LET ga_process[gi_count].p07 = ga_process[gi_count].p07, " ", ls_token
           END CASE
           #No.FUN-660158 --start--

#         #FUN-A80037
#          LET ls_sql = "SELECT zx02 FROM zx_file WHERE zx01 = '",ga_process[gi_count].p01,"'"
           LET ls_sql = "SELECT zx02 FROM zx_file WHERE zx01 = ? "
           PREPARE zx02_pre FROM ls_sql

           LET lc_zx01 = ga_process[gi_count].p01
           EXECUTE zx02_pre USING lc_zx01 INTO lc_zx02
#         #EXECUTE zx02_pre INTO lc_zx02
           IF NOT STATUS THEN
              LET ga_process[gi_count].user_name = lc_zx02
           END IF
           IF g_lang = '0' OR g_lang = '2' THEN
              LET ga_process[gi_count].p02 = '非本區域作業'         #都先填入非本區,本區的再由gbq更正 FUN-A80037
           ELSE
              LET ga_process[gi_count].p02 = 'Not this Area'
           END IF
           LET ga_process[gi_count].p09 = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱  FUN-A80037
           #No.FUN-660158 ---end---

          #CALL cl_itemname_by_lang("zx_file","zx02",ga_process[gi_count].p01,g_lang,ga_process[gi_count].user_name) RETURNING ga_process[gi_count].user_name  #TQC-6C0060 mark
           FOR li_j = 1 TO lr_gbq.getLength()
               IF ga_process[gi_count].p03 = lr_gbq[li_j].gbq01 AND
                  ga_process[gi_count].p09 = lr_gbq[li_j].gbq11 THEN             #FUN-A80037
                  LET ga_process[gi_count].p01 = lr_gbq[li_j].gbq03 #User
                  LET ga_process[gi_count].p02 = lr_gbq[li_j].gbq02 #IP
                  LET ga_process[gi_count].p04 = lr_gbq[li_j].gbq05 #Department
                  LET ga_process[gi_count].p05 = lr_gbq[li_j].gbq07 #Start Time
                  LET ga_process[gi_count].p06 = lr_gbq[li_j].gbq06 #GUI Mode
                  CASE ga_process[gi_count].p06
                     WHEN "1"
                        LET ga_process[gi_count].p06 = "GUI"
                     WHEN "3"
                        LET ga_process[gi_count].p06 = "WEB"
                  END CASE
                  LET ga_process[gi_count].p08 = lr_gbq[li_j].gbq10 #Database No.FUN-660135
               #  LET ga_process[gi_count].p09 = lr_gbq[li_j].gbq11 #Multi-AP   #Mark by FUN-A80037
               END IF
               #此處不應受最大筆數控管 #FUN-780050
           END FOR
           #No.FUN-5A0222 ---end---
           LET li_i = li_i + 1
       END WHILE
       LET gi_count = gi_count + 1   #TQC-B90122
   END WHILE

#  FUN-A80037 新增 顯示非本機(AP Server)所有的gbq資料
#  DISPLAY gi_count TO FORMONLY.cnt           #No.FUN-5A0222

   LET li_i = 1
   WHILE TRUE
      IF li_i > lr_gbq.getLength() THEN
         EXIT WHILE
      END IF
      FOR li_j = 1 TO ga_process.getLength()
         IF ga_process[li_j].p03 = lr_gbq[li_i].gbq01 AND ga_process[li_j].p09 = lr_gbq[li_i].gbq11 THEN
            LET li_i = li_i + 1
            CONTINUE WHILE
         END IF
      END FOR
      LET li_minute = ga_process.getLength() + 1
      LET ga_process[li_minute].p01 = lr_gbq[li_i].gbq03 #User
      LET ga_process[li_minute].p02 = lr_gbq[li_i].gbq02 #IP
      LET ga_process[li_minute].p03 = lr_gbq[li_i].gbq01 #ProcessID
      LET ga_process[li_minute].p04 = lr_gbq[li_i].gbq05 #Department
      LET ga_process[li_minute].p05 = lr_gbq[li_i].gbq07 #Start Time
      LET ga_process[li_minute].p06 = lr_gbq[li_i].gbq06 #GUI Mode
      LET ga_process[li_minute].p08 = lr_gbq[li_i].gbq10 #Database No.FUN-660135
      IF g_lang = '0' OR g_lang = '2' THEN
         LET ga_process[li_minute].p07 = '非本機(AP Server)作業'
      ELSE
         LET ga_process[li_minute].p07 = 'Job is on Another AP Server.'
      END IF
      LET ga_process[li_minute].p09 = lr_gbq[li_i].gbq11 #Multi-AP No.FUN-950082
      CASE ga_process[li_minute].p06
         WHEN "1"
            LET ga_process[li_minute].p06 = "GUI"
         WHEN "3"
            LET ga_process[li_minute].p06 = "WEB"
      END CASE
      LET lc_zx01 = ga_process[li_minute].p01
      EXECUTE zx02_pre USING lc_zx01 INTO lc_zx02
      IF NOT STATUS THEN
         LET ga_process[li_minute].user_name = lc_zx02
      END IF
      LET li_i = li_i + 1
   END WHILE

   LET gi_count = gi_count + 1
   DISPLAY gi_count TO FORMONLY.cnt           #FUN-A80037 End
   CALL lch_cmd.close()
END FUNCTION
 
FUNCTION p_showProcessList()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY ga_process TO s_process.*
       ATTRIBUTE (COUNT = gi_count - 1, UNBUFFERED)
 
       BEFORE DISPLAY
           CALL DIALOG.setCellAttributes(ga_color)
           LET gi_arr = 1
           CALL FGL_SET_ARR_CURR(gi_arr) 
 
       BEFORE ROW
           LET gi_arr = ARR_CURR()
           CALL cl_show_fld_cont()
 
       ON ACTION accept
           CONTINUE DISPLAY
 
       ON ACTION cancel
           LET INT_FLAG = FALSE
           LET g_action_choice = "exit"
           EXIT DISPLAY
 
       #No.FUN-660158 --start--
       ON ACTION output
          LET g_action_choice="output"
          IF cl_chk_act_auth() THEN
             CALL cl_set_act_visible("accept,cancel",TRUE)   #No.FUN-740179
             CALL process_out()
             CALL cl_set_act_visible("accept,cancel",FALSE)  #No.FUN-740179
          END IF
       #No.FUN-660158 ---end---
 
       #No.FUN-5A0222 --start--
       ON ACTION about
          CALL cl_about()
 
       ON ACTION license_detail                #FUN-A80037
          CALL p_process_license_detail()

       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       #No.FUN-5A0222 ---end---
 
       ON ACTION exit
           LET g_action_choice = "exit"
           EXIT DISPLAY
 
       ON ACTION refresh
           EXIT DISPLAY 
 
       #No.FUN-5A0222 --start--   
      ON ACTION kill
          CALL p_killProcess()
          EXIT DISPLAY
       #No.FUN-5A0222 ---end---
 
       ON IDLE 10
           EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

FUNCTION p_process_license_detail()

   DEFINE lw_window    ui.Window
   DEFINE ls_result    STRING
   DEFINE li_i         LIKE type_file.num10

   OPEN WINDOW p_process_license WITH 50 ROWS, 30 COLUMNS

   LET lw_window = ui.Window.getCurrent()
   CALL lw_window.setText("TIPTOP GP Licensed List")
   CALL cl_licensed_list()

   LET ls_result = "Client IP:Port / AP Server \n"
   FOR li_i = 1 TO la_license.getLength()
      LET ls_result = ls_result,la_license[li_i].ip CLIPPED," / ",la_license[li_i].ap CLIPPED,"\n"
   END FOR
   LET ls_result = ls_result,"\nTotal Licensed: ",la_license.getLength() USING "<<<<&"," User(s)."
   LET ls_result = ls_result,"\nCount Time: ",current year to second CLIPPED
   DISPLAY ls_result at 5,5

   MENU
      COMMAND "Ok!"
         EXIT MENU
      COMMAND KEY(INTERRUPT)
         EXIT MENU
   END MENU

   CLOSE WINDOW p_process_license

END FUNCTION


FUNCTION p_killProcess()
   DEFINE li_ret     LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
   IF g_user CLIPPED != ga_process[gi_arr].p01 THEN
      IF g_user CLIPPED != "tiptop" 
             
       OR  g_user CLIPPED != "37107"
   THEN
         CALL cl_err("You're not TIPTOP administrator.", "!", 1)
      ELSE
         RUN "killproc " || ga_process[gi_arr].p03 RETURNING li_ret
         SLEEP 1
      END IF
   ELSE
      RUN "kill -9 " || ga_process[gi_arr].p03 RETURNING li_ret
      SLEEP 1
   END IF
 
   IF li_ret THEN
      CALL cl_err("Fail to kill this process.", "!", 1)
   END IF
END FUNCTION
 
#No.FUN-660158 --start--
FUNCTION process_out()
   DEFINE   sr              RECORD
               p01          STRING,   #Login User
               user_name    STRING,   #User Name
               p02          STRING,   #Login IP
               p03          STRING,   #PID
               p04          STRING,   #Department
               p05          STRING,   #Start Time
               p06          STRING,   #GUI Mode
               p07          STRING,   #Execution Command
               p08          STRING,   #Database No.FUN-660135
               p09          STRING    #Multi-AP No.FUN-950082
                            END RECORD
   DEFINE   li_i         LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            l_name       LIKE type_file.chr20,  # External(Disk) file name    #No.FUN-680135 VARCHAR(20)
            l_za05       LIKE type_file.chr1000 #        #No.FUN-680135 VARCHAR(40)
  
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('p_process') RETURNING l_name
   START REPORT process_rep TO l_name
 
   FOR li_i = 1 TO ga_process.getLength()
       LET sr.* = ga_process[li_i].*
       OUTPUT TO REPORT process_rep(sr.*)
   END FOR
 
   FINISH REPORT process_rep
 
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT process_rep(sr)
   DEFINE   l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
            sr              RECORD
               p01          LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #Login User
               user_name    LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #User Name
               p02          LIKE gbq_file.gbq02,    #No.FUN-680135 VARCHAR(30) #Login IP
               p03          LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #PID
               p04          LIKE gbq_file.gbq05,    # Prog. Version..: '5.30.06-13.03.12(06) #Department
               p05          LIKE gbq_file.gbq07,    #No.FUN-680135 VARCHAR(20) #Start Time
               p06          LIKE gbq_file.gbq06,    #No.FUN-680135 SMALLINT #GUI Mode
               p07          LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(100)#Execution Command
               p08          LIKE gbq_file.gbq10,    #No.FUN-680135 VARCHAR(20) #Database No.FUN-660135
               p09          LIKE gbq_file.gbq11                                #Multi-AP No.FUN-950082
                            END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.p01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
                  g_x[39] CLIPPED,g_x[40] CLIPPED                                    #MOD-B70145 add ,g_x[40] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           PRINT COLUMN g_c[31],sr.p01,
                 COLUMN g_c[32],sr.user_name,
                 COLUMN g_c[33],sr.p02,
                 COLUMN g_c[34],sr.p03,
                 COLUMN g_c[35],sr.p04,
                 COLUMN g_c[36],sr.p05,
                 COLUMN g_c[37],sr.p06,
                 COLUMN g_c[38],sr.p07,
                 COLUMN g_c[39],sr.p08,
                 COLUMN g_c[40],sr.p09
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#No.FUN-660158 ---end---
