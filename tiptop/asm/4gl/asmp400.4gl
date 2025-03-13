# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asmp400.4gl
# Descriptions...: 工作行事曆產生作業
# Date & Author..: 91/08/13 By Nora
# Release 4.0....: 92/07/25 By Jones
# Modify.........: 99/09/08 By Kammy (加隔周休二日)
# Modify.........: No.MOD-560168 05/06/22 By pengu  設定日期區間後資料已存在時,按放棄的action,程式會當出
# Modify.........: No.FUN-570152 06/03/13 By 背景作業 批次背景執行
 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:TQC-B10008 11/01/04 By yinhy 將導致程序編譯不過的代碼mark
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
#No.TQC-B10008  --Begin
#DATABASE ds
# 
#GLOBALS "../../config/top.global"
# 
#DEFINE tm RECORD
#           sme01_b LIKE sme_file.sme01,
#          sme01_e LIKE sme_file.sme01,
#          c       LIKE sme_file.sme02,
#          d       LIKE sme_file.sme02,
#          e       LIKE sme_file.sme02,
#          f       LIKE sme_file.sme02,
#          g       LIKE sme_file.sme02,
#          h       LIKE sme_file.sme02,
#          i       LIKE sme_file.sme02,
#          j       LIKE sme_file.sme02
#          END RECORD,
#       g_buf      LIKE ze_file.ze03,  #No.FUN-690010 VARCHAR(45)
#       g_n        LIKE type_file.num5,  #No.FUN-690010   SMALLINT,
#       l_year_t   LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
#       l_month_t  LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
#No.TQC-B10008  --End

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
           sme01_b LIKE sme_file.sme01,
          sme01_e LIKE sme_file.sme01,
          c       LIKE sme_file.sme02,
          d       LIKE sme_file.sme02,
          e       LIKE sme_file.sme02,
          f       LIKE sme_file.sme02,
          g       LIKE sme_file.sme02,
          h       LIKE sme_file.sme02,
          i       LIKE sme_file.sme02,
          j       LIKE sme_file.sme02
          END RECORD,
       g_buf      LIKE ze_file.ze03,  #No.FUN-690010 VARCHAR(45)
       g_n        LIKE type_file.num5,  #No.FUN-690010   SMALLINT,
       l_year_t   LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
       l_month_t  LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
       l_sat1     LIKE type_file.dat,   #No.FUN-690010 DATE,    
       l_sat2     LIKE type_file.dat   #No.FUN-690010 DATE
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE ls_date     STRING,   #No.FUN-570152
#       l_time       LIKE type_file.chr8          #No.FUN-6A0089
       l_flag      LIKE type_file.chr1,    #No.FUN-570152  #No.FUN-690010 VARCHAR(1)
       g_change_lang  LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01) #是否有做語言切
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #-->No.FUN-570152 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date    = ARG_VAL(1)
   LET tm.sme01_b = cl_batch_bg_date_convert(ls_date)
   LET ls_date    = ARG_VAL(2)
   LET tm.sme01_e = cl_batch_bg_date_convert(ls_date)
   LET tm.c       = ARG_VAL(3)
   LET tm.d       = ARG_VAL(4)
   LET tm.e       = ARG_VAL(5)
   LET tm.f       = ARG_VAL(6)
   LET tm.g       = ARG_VAL(7)
   LET tm.h       = ARG_VAL(8)
   LET tm.i       = ARG_VAL(9)
   LET tm.j       = ARG_VAL(10)
   LET g_bgjob    = ARG_VAL(11)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
  #-- No.FUN-570152 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570152 start--
# Prog. Version..: '5.30.06-13.03.12(0,0)				# 
#   CALL cl_used('asmp400',g_time,1) RETURNING g_time      #No.FUN-6A0089
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p400_tm(0,0)
         LET g_success='Y'
         BEGIN WORK
         IF cl_sure(21,21) THEN
            CALL p400()
            IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING l_flag   #批次作業正確結束
            ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING l_flag   #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p400_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p400()
         IF g_success = "Y" THEN
              COMMIT WORK
           ELSE
              ROLLBACK WORK
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
        END IF
   END WHILE
 # CALL cl_used('asmp400',g_time,2) RETURNING g_time         #No.FUN-6A0089
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
  #-- No.FUN-570152 --end----
END MAIN
 
FUNCTION p400_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_chr         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_flag        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            lc_cmd        LIKE type_file.chr1000  #No.FUN-690010   VARCHAR(500)   #No.FUN-570152
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW p400_w AT p_row,p_col WITH FORM "asm/42f/asmp400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'Y'
   LET tm.f = 'Y'
   LET tm.g = 'Y'
   LET tm.h = 'Y'
   LET tm.i = 'N'
   LET tm.j = 'N'
   LET g_bgjob = 'N'  #No.FUN-570152
 
   IF s_shut(0) THEN
      CLOSE WINDOW p400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
 
   WHILE TRUE
 
      #INPUT BY NAME tm.sme01_b,tm.sme01_e,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.j
      INPUT BY NAME tm.sme01_b,tm.sme01_e,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.j,
                    g_bgjob  #NO.FUN-570152
                    WITHOUT DEFAULTS 
        
         AFTER FIELD sme01_b
            IF tm.sme01_b IS NULL 
               THEN NEXT FIELD sme01_b
            END IF
     
         AFTER FIELD sme01_e
            IF tm.sme01_e IS NULL 
               THEN NEXT FIELD sme01_e
            END IF
            IF tm.sme01_b > tm.sme01_e THEN 
               CALL cl_getmsg('9011',g_lang) RETURNING g_buf
               ERROR g_buf
               NEXT FIELD sme01_b
            END IF
            SELECT COUNT(*) INTO g_n FROM sme_file  #檢查日期區間是否重覆
             WHERE sme01 BETWEEN tm.sme01_b AND tm.sme01_e
            IF g_n > 0  THEN
#              IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#                 LET p_row = 15 LET p_col = 30
#              ELSE
#                 LET p_row = 15 LET p_col = 15
#              END IF
      
#              OPEN WINDOW p400_w2 AT p_row,p_col 
#                   WITH 2 ROWS,50 COLUMNS
                    
               CALL p400_sme01() RETURNING l_chr
#              CLOSE WINDOW p400_w2
               IF l_chr MATCHES"[Yy]" THEN
                  NEXT FIELD sme01_b
               END IF
            END IF
                   
         AFTER FIELD c
            IF tm.c NOT MATCHES"[YN]" OR tm.c IS NULL THEN
               NEXT FIELD c
            END IF
      
         AFTER FIELD d
            IF tm.d NOT MATCHES"[YN]" OR tm.d IS NULL THEN
               NEXT FIELD d
            END IF
      
         AFTER FIELD e
            IF tm.e NOT MATCHES"[YN]" OR tm.e IS NULL THEN
               NEXT FIELD e
            END IF
      
         AFTER FIELD f
            IF tm.f NOT MATCHES"[YN]" OR tm.f IS NULL THEN
               NEXT FIELD f
            END IF
      
         AFTER FIELD g
            IF tm.g NOT MATCHES"[YN]" OR tm.g IS NULL THEN
               NEXT FIELD g
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES"[YN]" OR tm.h IS NULL THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD i
            IF tm.i NOT MATCHES"[YN]" OR tm.i IS NULL THEN
               NEXT FIELD i
            END IF
      
         AFTER FIELD j
            IF tm.j NOT MATCHES"[YN]" OR tm.j IS NULL THEN
               NEXT FIELD j
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         ON ACTION exit    #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale  #genero
#NO.FUN-570152 mark--
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570152 mark--
            LET g_change_lang = TRUE                 #NO.FUN-570152
            EXIT INPUT
        
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      
      #IF g_action_choice = "locale" THEN  #genero   #NO.FUN-570152 
      IF g_change_lang = TRUE THEN
         LET g_change_lang = FALSE
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                     #NO.FUN-570152
         CONTINUE WHILE
      END IF
     
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
     
#NO.FUN-570152 mark---
#      #---genero
#      IF cl_sure(21,21) THEN
#         CALL cl_wait()
#
#         CALL p400()
#         ERROR ""
#         IF g_success='Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#NO.FUN-570152 mark--
 
#NO.FUN-570152 start--
IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "asmp400"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
             CALL cl_err('asmp400','9031',1)                 
         ELSE
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",tm.sme01_b CLIPPED,"'",
                          " '",tm.sme01_e CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.d CLIPPED,"'",
                          " '",tm.e CLIPPED,"'",
                          " '",tm.f CLIPPED,"'",
                          " '",tm.g CLIPPED,"'",
                          " '",tm.h CLIPPED,"'",
                          " '",tm.i CLIPPED,"'",
                          " '",tm.j CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('asmp400',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p400_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    EXIT WHILE
   #-- No.FUN-570152 --end----
   END WHILE
#   CLOSE WINDOW p400_w
 
END FUNCTION
 
FUNCTION p400_sme01()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   CALL cl_getmsg('mfg0004',g_lang) RETURNING g_buf
   WHILE true
      LET INT_FLAG = 0  ######add for prompt bug
 
      PROMPT g_buf CLIPPED,l_chr FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END PROMPT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
          #-No.MOD-560168
         LET    l_chr ='Y'
         RETURN l_chr
        #-end
         EXIT WHILE
      END IF
 
      IF l_chr IS NULL OR l_chr NOT MATCHES"[YyNn]" THEN
         CONTINUE WHILE
      ELSE
         RETURN l_chr
         EXIT WHILE
      END IF
   END WHILE 
 
END FUNCTION
 
FUNCTION p400()                      #產生工作行事曆
   DEFINE  l_day         LIKE type_file.num10, #No.FUN-690010 INTEGER,
           l_week        LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
           p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
           l_date        LIKE type_file.dat,    #No.FUN-690010 DATE,
           l_sme02       LIKE sme_file.sme02
 
   DELETE FROM sme_file
    WHERE sme01 BETWEEN tm.sme01_b AND tm.sme01_e
#  IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#       LET p_row = 10 LET p_col = 30
#  ELSE LET p_row = 10 LET p_col = 20
#  END IF
#  OPEN WINDOW asm_w2 AT p_row,p_col WITH 3 ROWS, 40 COLUMNS
                         
   CALL cl_getmsg('mfg0005',g_lang) RETURNING g_buf
   IF g_bgjob = 'N' THEN   #No.FUN-570152
       MESSAGE g_buf
       CALL ui.Interface.refresh()
   END IF
   LET g_success="Y"
   FOR l_day = tm.sme01_b TO tm.sme01_e
      LET l_date = l_day
      LET l_week = l_date MOD 7 USING '&'
      CASE
         WHEN l_week = 1 
            LET l_sme02 = tm.c  
         WHEN l_week = 2
            LET l_sme02 = tm.d
         WHEN l_week = 3
            LET l_sme02 = tm.e
         WHEN l_week = 4 
            LET l_sme02 = tm.f
         WHEN l_week = 5 
            LET l_sme02 = tm.g
         WHEN l_week = 6
            IF tm.j='Y' THEN
               CALL p400_Saturday(l_date) RETURNING l_sme02
            ELSE 
               LET l_sme02=tm.h
            END IF
         WHEN l_week = 0
            LET l_sme02 = tm.i
         OTHERWISE 
            LET l_sme02 = ' '
      END CASE

     #CHI-A70049---mark---start---
     #DISPLAY l_date,' [',l_week,']' AT 2,10
     #DISPLAY l_sme02 AT 2,25
     #CHI-A70049---mark---end---
 
      IF NOT cl_null(l_sme02) THEN
         INSERT INTO sme_file (sme01,sme02) VALUES (l_date,l_sme02)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("ins","sme_file",l_date,l_sme02,SQLCA.sqlcode,"","",0) #No.FUN-660138
            LET g_success="N"
         END IF
      END IF
   END FOR
 
   CALL cl_getmsg('mfg0006',g_lang) RETURNING g_buf
   LET INT_FLAG = 0  ######add for prompt bug
 
#  PROMPT g_buf CLIPPED FOR CHAR g_chr
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#         CONTINUE PROMPT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
# 
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
# 
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
# 
#  
#  END PROMPT
#  CLOSE WINDOW asm_w2
 
END FUNCTION
 
#------NO:0469----
FUNCTION p400_Saturday(l_date)
 DEFINE l_date  LIKE type_file.dat    #No.FUN-690010    DATE
   
   IF (l_year_t=0 AND l_month_t=0) OR
      (YEAR(l_date) = l_year_t AND MONTH(l_date) != l_month_t) OR
      (YEAR(l_date) !=l_year_t ) THEN
      LET l_year_t = YEAR(l_date)
      LET l_month_t= MONTH(l_date)
      LET l_sat1 = l_date + 7
      LET l_sat2 = l_date + 21
   END IF
   IF l_date = l_sat1 OR l_date = l_sat2 THEN
      RETURN 'N'
   ELSE
      RETURN 'Y'
   END IF
 
END FUNCTION
