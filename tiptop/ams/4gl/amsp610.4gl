# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: amsp610.4gl
# Descriptions...: 每日資源產生作業
# Input parameter: 
# Return code....: 
# Date & Author..: 00/05/23 By Carol 
# Modify ........: 00/08/04 By Carol:修正產生時距方式
# Modify.........: No.FUN-570126 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)  
# Modify.........: No.MOD-C50155 12/06/07 By Elise x接收值只有宣告為chr1，造成錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE       tm                    RECORD
             wc                    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(300) 
            rqa02                  LIKE rqa_file.rqa02,   #需求資料選擇
            bdate                  LIKE type_file.dat,    #NO.FUN-680101 DATE      #需求資料選擇
            edate                  LIKE type_file.dat,    #NO.FUN-680101 DATE      #需求資料選擇
            c                      LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)  #1:依時距代號 2.天 3.週 4.旬 5.月
            b                      LIKE rpg_file.rpg01,   # Prog. Version..: '5.30.06-13.03.12(04)  #時距代號 
            a                      LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)  #需求資料選擇
                                END RECORD,
          g_dd                  LIKE type_file.num5,      #NO.FUN-680101 SMALLINT
          p_row,p_col           LIKE type_file.num5,      #NO.FUN-680101 SMALLINT 
           g_sql                 string,   #No.FUN-580092 HCN
          g_rpg                 RECORD LIKE rpg_file.*,
          g_rqa                 RECORD LIKE rqa_file.*,
          g_hours               LIKE rqa_file.rqa05,      #NO.FUN-680101 DEC(12,3)  #當期有效工時 (小時)
          g_rqa05               LIKE rqa_file.rqa05,
          sr                    RECORD LIKE rpf_file.* 
DEFINE    g_before_input_done   LIKE type_file.num5       #NO.FUN-680101 SMALLINT
DEFINE    g_flag                LIKE type_file.chr1       #NO.FUN-680101  VARCHAR(01)
DEFINE    g_change_lang         LIKE type_file.chr1       #是否有做語言切換 No.FUN-57012  #NO.FUN-680101 VARCHAR(01)
MAIN
  DEFINE   ls_date   STRING        #No.FUN-570126
  DEFINE   ls_cmd    STRING        #No.FUN-570126
  DEFINE   li_result LIKE type_file.num5      #No.FUN-570126  #NO.FUN-680101 SMALLINT
#     DEFINE  l_time   LIKE type_file.chr8        #No.FUN-6A0081
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
  #No.FUN-570126 --start--
   INITIALIZE  g_bgjob_msgfile TO NULL
   LET tm.wc = ARG_VAL(1)
   LET tm.rqa02 = ARG_VAL(2)
   LET ls_date = ARG_VAL(3)
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(4)
   LET tm.edate = cl_batch_bg_date_convert(ls_date)
   LET tm.c = ARG_VAL(5)
   LET tm.b = ARG_VAL(6)
   LET tm.a = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570126 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570126 mark---
#   LET p_row = 5 LET p_col = 17
 
#   OPEN WINDOW p610_w AT p_row,p_col WITH FORM "ams/42f/amsp610" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
#   CALL cl_opmsg('z')
   IF s_shut(0) THEN EXIT PROGRAM END IF
#   WHILE TRUE
#      CLEAR FORM 
#      INITIALIZE tm.* TO NULL       			# Default condition
#      LET tm.a      = 'N'   
#      LET tm.bdate  = TODAY  
#      LET tm.edate  = TODAY  
#      LET tm.c      = '1'   
#      LET g_flag = 'Y'
#      CALL p610_tm() 
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN EXIT WHILE  END IF 
#      IF cl_sure(0,0) THEN 
#         LET g_success = 'Y'
#         BEGIN WORK 
#         CALL p610_process()
#         IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success='N' END IF
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#            ERROR ''
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE 
#   CLOSE WINDOW p610_w
#NO.FUN-570126 mark--------
 
#NO.FUN-570126 start--------
   #CALL cl_used('amsp610',g_time,1) RETURNING g_time           #No.FUN-6A0081   #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #No.FUN-6A0081   #FUN-B30211
   WHILE TRUE
     #No.FUN-570126 --start--
     IF g_bgjob = "N" THEN
        CALL p610_tm()
        IF cl_sure(18,20) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL p610_process()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
              CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p610_w
               EXIT WHILE
            END IF
        ELSE
            CONTINUE WHILE
        END IF
    ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p610_process()
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
    END IF
 END WHILE
#No.FUN-570126-end
  #CALL cl_used('amsp610',g_time,2) RETURNING g_time     #No.FUN-6A0081  #FUN-B30211
  CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-6A0081   #FUN-B30211
END MAIN
   
FUNCTION p610_tm()
   DEFINE   l_n           LIKE type_file.num5     #NO.FUN-680101 SMALLINT  
   DEFINE   lc_cmd        LIKE type_file.chr1000  #No.FUN-570126  #NO.FUN-680101 VARCHAR(500)
#No.FUN-550067--end
  #->No.FUN-570126 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p610_w AT p_row,p_col WITH FORM "ams/42f/amsp610"
    ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CLEAR FORM 
      INITIALIZE tm.* TO NULL       			# Default condition
      LET tm.a      = 'N'   
      LET tm.bdate  = TODAY  
      LET tm.edate  = TODAY  
      LET tm.c      = '1'   
      LET g_flag = 'Y'
      LET g_bgjob ='N' 
#->No.FUN-570126 ---end---
 
      CONSTRUCT BY NAME tm.wc ON rpf01  
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale                    #genero
          #LET g_action_choice = "locale"
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE                  #NO.FUN-570126
            EXIT CONSTRUCT
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rpfuser', 'rpfgrup') #FUN-980030
 
#NO.FUN-570126 start-------
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         LET g_flag = 'N'
#         RETURN
#      END IF
 
#      IF INT_FLAG THEN 
#         RETURN
#      END IF
#NO.FUN-570126 end-------------------
      
      #INPUT BY NAME tm.rqa02,tm.bdate,tm.edate,tm.c,tm.b,tm.a WITHOUT DEFAULTS 
      INPUT BY NAME tm.rqa02,tm.bdate,tm.edate,tm.c,tm.b,tm.a,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570126 
 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p610_set_entry()
            CALL p610_set_no_entry()
            LET g_before_input_done = TRUE
 
         AFTER FIELD rqa02
            IF cl_null(tm.rqa02) THEN
               LET tm.rqa02=' '
            END IF
 
         AFTER FIELD edate   
            IF NOT (cl_null(tm.edate) AND cl_null(tm.bdate)) THEN
               IF tm.bdate > tm.edate THEN 
                  CALL cl_err('','aap-100',0) NEXT FIELD edate
               END IF 
            END IF
 
         BEFORE FIELD c
            CALL p610_set_entry()
 
         AFTER FIELD c     
            CALL p610_set_no_entry()
            IF tm.c != 1 THEN
               LET tm.b = ' '
               DISPLAY BY NAME tm.b
            END IF
 
         AFTER FIELD b 
            IF NOT cl_null(tm.b) THEN
               SELECT * INTO g_rpg.* FROM rpg_file WHERE rpg01=tm.b
               IF STATUS THEN 
          #       CALL cl_err('sel_rpg',STATUS,0)  #No.FUN-660108
                  CALL cl_err3("sel","rpg_file",tm.b,"",STATUS,"","sel_rpg:",0)       #No.FUN-660108
                  NEXT FIELD b
               END IF 
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN 
               LET INT_FLAG=0 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            IF INFIELD(b) THEN
#              CALL q_rpg(0,0,tm.b) RETURNING tm.b  
#              CALL FGL_DIALOG_SETBUFFER( tm.b )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rpg"
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
#               CALL FGL_DIALOG_SETBUFFER( tm.b )
               DISPLAY BY NAME tm.b 
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
         #->No.FUN-570126 --start--
          LET g_change_lang = TRUE
          EXIT INPUT
         #->No.FUN-570126 ---end---
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570126 start-----
#      IF INT_FLAG THEN
#         RETURN
#      END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "amsp610"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('amsp610','9031',1)
       ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED ,"'",
                      " '",tm.rqa02 CLIPPED ,"'",
                      " '",tm.bdate CLIPPED,"'",
                      " '",tm.edate CLIPPED,"'",
                      " '",tm.c CLIPPED ,"'",
                      " '",tm.b CLIPPED ,"'",
                      " '",tm.a CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('amsp610',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p610_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
  EXIT WHILE
  #->No.FUN-570126 ---end---
END WHILE
END FUNCTION 
 
FUNCTION p610_set_entry()
 
   IF INFIELD(c) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF
END FUNCTION
 
FUNCTION p610_set_no_entry()
 
   IF INFIELD(c) OR (NOT g_before_input_done) THEN
      IF tm.c != 1 THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION p610_process()
 DEFINE  l_n,l_i,l_day,l_add     LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
         l_msg                   LIKE type_file.chr50,    #NO.FUN-680101 VARCHAR(30)
         l_date1                 LIKE type_file.dat,      #NO.FUN-680101 DATE
         l_date2                 LIKE type_file.dat       #NO.FUN-680101 DATE
 
 #讀取資源資料
  LET g_sql = "SELECT rpf_file.* FROM rpf_file WHERE ",tm.wc CLIPPED 
  PREPARE p610_pre_1  FROM g_sql
  IF STATUS THEN 
     LET g_success='N'
     CALL cl_err('pre_1',STATUS,1) 
     RETURN 
  END IF 
  DECLARE p610_dec_1  CURSOR WITH HOLD FOR p610_pre_1   
  IF STATUS THEN 
     LET g_success='N'
     CALL cl_err('dec_1',STATUS,1) 
     RETURN 
  END IF 
 
  FOREACH p610_dec_1 INTO sr.* 
     IF STATUS THEN 
        LET g_success='N'
        CALL cl_err('for_1',STATUS,1) 
        RETURN 
     END IF 
     LET l_n = 0 
     SELECT COUNT(*) INTO l_n FROM rqa_file WHERE rqa01=sr.rpf01 
     IF cl_null(l_n) THEN LET l_n = 0  END IF 
 
     IF tm.a='Y' THEN
        IF l_n > 0 THEN     #清除舊資料重新產生 
           DELETE FROM rqa_file WHERE rqa01=sr.rpf01    
                                  AND rqa02=tm.rqa02
           IF STATUS THEN 
      #       CALL cl_err('del_rqa',STATUS,1)  #No.FUN-660108
              CALL cl_err3("del","rqa_file",sr.rpf01,tm.rqa02,STATUS,"","del rqa:",1)       #No.FUN-660108
              LET g_success='N'
              RETURN 
           END IF 
        END IF 
     ELSE 
        IF l_n > 0 THEN CONTINUE FOREACH END IF 
     END IF 
     LET l_date1=tm.bdate 
     LET l_i=1
     WHILE TRUE
         IF tm.c='1' THEN   #產生時距方式:1.依時距代號
            CALL p610_chk_rpg(l_i,l_date1) RETURNING l_add
            LET l_date2=l_date1+l_add - 1
            IF l_date2 >= tm.edate THEN
               LET l_date2=tm.edate 
            END IF 
         ELSE               # 2.天 3.週 4.旬 5.月
            CALL p610_chk_dd(tm.c,l_date1) RETURNING l_add
            LET l_date2=l_date1+l_add - 1
            IF l_date2 >= tm.edate THEN 
               LET l_date2=tm.edate 
            END IF 
         END IF   
         LET g_rqa.rqa01=sr.rpf01               #資源代號
         LET g_rqa.rqa02=tm.rqa02               #版本
         LET g_rqa.rqa03=l_date1                #起始日期
         LET g_rqa.rqa04=l_date2                #截止日期
         LET g_rqa.rqa05=g_rqa05                #當日產能
         LET g_rqa.rqa06=0                      #已秏產能
         LET g_rqa.rqa07=''     
         LET g_rqa.rqa08=''     
         IF tm.a='Y' OR (tm.a='N' AND l_n=0) THEN  
            INSERT INTO rqa_file VALUES(g_rqa.*)
            IF STATUS THEN 
               LET l_msg='ins_1:',sr.rpf01 
               CALL cl_err(l_msg CLIPPED,STATUS,1) #No.FUN-660108
               CALL cl_err3("ins","rqa_file",l_msg,"",STATUS,"","",1)       #No.FUN-660108 
               LET g_success='N'
               RETURN 
            END IF 
         ELSE 
            UPDATE rqa_file SET *=g_rqa.*
            IF STATUS THEN 
               LET l_msg='upd_1:',sr.rpf01 
           #   CALL cl_err(l_msg CLIPPED,STATUS,1) #No.FUN-660108
               CALL cl_err3("upd","rqa_file",l_msg,"",STATUS,"","",1)       #No.FUN-660108 
               LET g_success='N'
               RETURN 
            END IF 
        END IF 
        LET l_i=l_i + 1 
        LET l_date1=l_date2+1 
        IF l_date1 > tm.edate THEN EXIT WHILE END IF 
        CONTINUE WHILE 
     END WHILE 
  END FOREACH 
END FUNCTION 
 
FUNCTION p610_chk_dd(p_code,p_date)
  DEFINE p_code     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(01)
         p_date     LIKE type_file.dat,     #NO.FUN-680101 DATE  
         l_date     LIKE type_file.dat,     #NO.FUN-680101 DATE 
         c          LIKE type_file.dat,     #NO.FUN-680101 DATE 
         d          LIKE type_file.num10,   #NO.FUN-680101 INTEGER
        # Prog. Version..: '5.30.06-13.03.12(01)  #MOD-C50155 mark
         x          LIKE type_file.chr8,    #MOD-C50155
         i,j,m      LIKE type_file.num5     #NO.FUN-680101 SMALLINT
    
    LET g_hours = 0       #當期有效工時 (小時)
    LET g_rqa05 = 0
 
    CASE p_code 
         # 天
         WHEN '2' CALL p610_chk_ecn(p_date) RETURNING i
                  LET m = 1
         # 週
         WHEN '3'  
             LET m = 7
             LET l_date = p_date
             FOR i = 1 TO 7
                 IF p610_chk_ecn(l_date) #工作天
                    THEN 
                    IF l_date >= tm.edate THEN RETURN i END IF
                 END IF
                 LET l_date = l_date + 1
             END FOR
         # 旬
         WHEN '4'        
             LET m = 10
             LET l_date = p_date
             FOR i = 1 TO 10
                 IF p610_chk_ecn(l_date) #工作天
                    THEN 
                    IF l_date >= tm.edate THEN RETURN i END IF
                 END IF
                 LET l_date = l_date + 1
             END FOR
         WHEN '5'        
             LET x = p_date USING 'yyyymmdd'
             IF x[5,6]='12'  THEN 
                LET c = MDY(1,1,x[1,4]+1)
             ELSE 
                LET c = MDY(x[5,6]+1,1,x[1,4])
             END IF 
             LET j = c - p_date 
 
             LET m = j
             LET l_date = p_date
             FOR i = 1 TO j
                 IF p610_chk_ecn(l_date) #工作天
                    THEN 
                    IF l_date >= tm.edate THEN RETURN i END IF
                 END IF
                 LET l_date = l_date + 1
             END FOR
   END CASE 
   RETURN m
          
END FUNCTION 
 
FUNCTION p610_chk_rpg(p_code,p_date)
  DEFINE  p_code     LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
          p_date     LIKE type_file.dat,      #NO.FUN-680101 DATE  
          l_date     LIKE type_file.dat,      #NO.FUN-680101 DATE  
          l_day,i,j  LIKE type_file.num5      #NO.FUN-680101 SMALLINT 
 
    LET l_day = 0
    LET g_hours = 0       #當期有效工時 (小時)
    LET g_rqa05 = 0
 
    CASE p_code  
         WHEN 1     LET l_day = g_rpg.rpg101
         WHEN 2     LET l_day = g_rpg.rpg102
         WHEN 3     LET l_day = g_rpg.rpg103
         WHEN 4     LET l_day = g_rpg.rpg104
         WHEN 5     LET l_day = g_rpg.rpg105
         WHEN 6     LET l_day = g_rpg.rpg106
         WHEN 7     LET l_day = g_rpg.rpg107
         WHEN 8     LET l_day = g_rpg.rpg108
         WHEN 9     LET l_day = g_rpg.rpg109
         WHEN 10    LET l_day = g_rpg.rpg110
         WHEN 11    LET l_day = g_rpg.rpg111
         WHEN 12    LET l_day = g_rpg.rpg112
         WHEN 13    LET l_day = g_rpg.rpg113
         WHEN 14    LET l_day = g_rpg.rpg114
         WHEN 15    LET l_day = g_rpg.rpg115
         WHEN 16    LET l_day = g_rpg.rpg116
         WHEN 17    LET l_day = g_rpg.rpg117
         WHEN 18    LET l_day = g_rpg.rpg118
         WHEN 19    LET l_day = g_rpg.rpg119
         WHEN 20    LET l_day = g_rpg.rpg120
         WHEN 21    LET l_day = g_rpg.rpg121
         WHEN 22    LET l_day = g_rpg.rpg122
         WHEN 23    LET l_day = g_rpg.rpg123
         WHEN 24    LET l_day = g_rpg.rpg124
         WHEN 25    LET l_day = g_rpg.rpg125
         WHEN 26    LET l_day = g_rpg.rpg126
         WHEN 27    LET l_day = g_rpg.rpg127
         WHEN 28    LET l_day = g_rpg.rpg128
         WHEN 29    LET l_day = g_rpg.rpg129
         WHEN 30    LET l_day = g_rpg.rpg130
         WHEN 31    LET l_day = g_rpg.rpg131
         WHEN 32    LET l_day = g_rpg.rpg132
         WHEN 33    LET l_day = g_rpg.rpg133
         WHEN 34    LET l_day = g_rpg.rpg134
         WHEN 35    LET l_day = g_rpg.rpg135
         WHEN 36    LET l_day = g_rpg.rpg136
         WHEN 37    LET l_day = g_rpg.rpg137
    END CASE 
 
    LET l_date = p_date
    LET j = l_day
 
    FOR i = 1 TO j
        IF p610_chk_ecn(l_date) #工作天
           THEN 
           IF l_date >= tm.edate THEN RETURN i END IF
        END IF
        LET l_date = l_date + 1
    END FOR
    RETURN j 
END FUNCTION 
 
#check工作站工作曆檔
FUNCTION p610_chk_ecn(p_date)
DEFINE
    p_date       LIKE type_file.dat,     #NO.FUN-680101 DATE
    l_hours      LIKE rqa_file.rqa05,    #NO.FUN-680101 DEC(12,3)
    l_rqa05      LIKE rqa_file.rqa05
 
    MESSAGE sr.rpf06,p_date
    CALL ui.Interface.refresh()
 
    LET l_hours = 0
    LET l_rqa05 = 0
    SELECT (ecn04*ecn05/100) INTO l_hours     #工作小時*產能效率調整(%)
      FROM eca_file,ecn_file   
     WHERE eca01  =  sr.rpf06
       AND ecn01  =  eca55
       AND ecn02  =  p_date
       AND ecn03  =  tm.rqa02    # 版本
    IF SQLCA.sqlcode THEN
       LET g_sql = sr.rpf06 CLIPPED,'找不到該資源項目所屬工作中心的工作曆(版本)'
  #     CALL cl_err(g_sql,'!',1) #No.FUN-660108
        CALL cl_err3("sel","eca_file,ecn_file",sr.rpf06,"",SQLCA.sqlcode," ","",1)       #No.FUN-660108
        RETURN 0
    END IF
    LET g_hours = g_hours + l_hours              #當期有效工時 (小時)
    LET l_rqa05 = sr.rpf04 * l_hours             #當日產能=有效工時*資源數量
{
    IF l_rqa05 > sr.rpf05    #當日產能>每日最大產能
       THEN
       LET l_rqa05=sr.rpf05
    END IF
}
    LET g_rqa05 = g_rqa05 + l_rqa05
    RETURN 1
END FUNCTION
