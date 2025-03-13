# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdp201.4gl
# Descriptions...: 集團間銷售系統成本更新作業
# Date & Author..: 04/03/08 By Carrier
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-570154 06/03/15 By yiting 批次作業背景執行功能
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_adg          RECORD LIKE adg_file.*,
         g_adf          RECORD LIKE adf_file.*,
         tm             RECORD
                        wc         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(300)
                        yy         LIKE type_file.num5,   #No.FUN-680108 SMALLINT
                        mm         LIKE type_file.num5    #No.FUN-680108 SMALLINT
                        END RECORD,
         g_wc           string,  #No:FUN-580092 HCN
         g_bdate        LIKE type_file.dat,               #No.FUN-680108 DATE
         g_edate        LIKE type_file.dat,               #No.FUN-680108 DATE
         g_sql          string,  #No:FUN-580092 HCN
         p_dbs          LIKE azp_file.azp03,
         g_flag         LIKE type_file.chr1               #No.FUN-680108 VARCHAR(01)
DEFINE   g_argv1        LIKE type_file.chr1000,           #No.FUN-680108 VARCHAR(04)
         g_argv2        LIKE type_file.chr1000,           #No.FUN-680108 VARCHAR(02)
         g_argv3        LIKE type_file.chr1000            #No.FUN-680108 VARCHAR(400)
DEFINE   l_flag         LIKE type_file.chr1,              #No.FUN-680108 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1,   #是否有做語言切換 No:FUN-570154   #No.FUN-680108 VARCHAR(01)
         ls_date        STRING                  #->No:FUN-570154
MAIN
#     DEFINEl_time   LIKE type_file.chr8             #No.FUN-6A0091

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP

   DEFER INTERRUPT
#->No:FUN-570154 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1 = ARG_VAL(1)         #參數-1 年度指標
   LET g_argv2 = ARG_VAL(2)         #參數-2 月份
   LET g_argv3 = ARG_VAL(3)         #參數-3 條件
   LET tm.wc   = ARG_VAL(4)
   LET tm.yy   = ARG_VAL(5)                      
   LET tm.mm   = ARG_VAL(6)                      
   LET g_bgjob = ARG_VAL(7)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No:FUN-570154 ---end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
#NO.FUN-570154 mark-- 
#   LET g_argv1 = ARG_VAL(1)         #參數-1 年度指標
#   LET g_argv2 = ARG_VAL(2)         #參數-2 月份
#  LET g_argv3 = ARG_VAL(3)         #參數-2 條件
 
#   IF cl_null(g_argv1) THEN
#      CALL p201_tm()
#   ELSE
#      LET tm.wc    =g_argv1
#      LET tm.yy    =g_argv2
#      LET tm.mm    =g_argv3
#      CALL p201_p()
#   END IF
#NO.FUN-570154 mark--

#NO.FUN-570154 start-
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' AND cl_null(g_argv1) THEN
         CALL p201_tm()
         IF cl_sure(21,21) THEN
            BEGIN WORK
            CALL p201_p()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p201_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p201_p()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No:FUN-570154 ---end---

     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

FUNCTION p201_tm()
   DEFINE lc_cmd         LIKE type_file.chr1000 #FUN-570154   #No.FUN-680108 VARCHAR(500)
   DEFINE p_row,p_col    LIKE type_file.num5                  #No.FUN-680108 SMALLINT

    LET p_row = 5 LET p_col = 26

   OPEN WINDOW p201_w AT p_row,p_col
        WITH FORM "axd/42f/axdp201" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adg05
         #No:FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No:FUN-580031 ---end---

     ON ACTION locale
#NO.FUN-570154 start--
#        LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        LET g_change_lang = TRUE          #FUN-570154
#NO.FUN-570154 end---
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

  END CONSTRUCT
#NO.FUN-570154 start--
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG=0 CLOSE WINDOW p201_w RETURN
#   END IF

   IF g_change_lang THEN      
      LET g_change_lang = FALSE
      LET g_action_choice = ""                                                  
      CALL cl_dynamic_locale()                                                  
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      CONTINUE WHILE                                                            
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p201_w     
      EXIT PROGRAM           
   END IF
#->No:FUN-570154 ---end-
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.yy,tm.mm

   LET g_bgjob = 'N'  #NO.FUN-570154 
   INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS      #FUN-570154
   #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS

         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
               NEXT FIELD mm
            END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()  

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION exit
           LET INT_FLAG = 1

        ON ACTION locale        #FUN-570154
           LET g_change_lang = TRUE
           EXIT INPUT

         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---
            EXIT INPUT

   END INPUT
#NO.FUN-570154 mark--
#   IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
#   IF cl_sure(18,20) THEN
#      CALL p201_p()
#   END IF
# END WHILE
# CLOSE WINDOW p201_w
#NO.FUN-570154 mark--

#FUN-570154 --start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p201_w              #FUN-570154
      EXIT PROGRAM                     #FUN-570154
   END IF

     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axdp201'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axdp201','9031',1)
        ELSE
           LET tm.wc = cl_replace_str(tm.wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " ''",
                        " ''",
                        " '",tm.wc CLIPPED, "'",
                        " '",tm.yy CLIPPED, "'",
                        " '",tm.mm CLIPPED, "'",
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('axdp201',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p201_w
        EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
#FUN-570154 --end--
END FUNCTION

FUNCTION p201_p()
 DEFINE  l_i      LIKE type_file.num5          #No.FUN-680108 SMALLINT

#  BEGIN WORK              #NO.FUN-570154 
#  LET g_success = 'Y'     #NO.FUN-570154  MARK
  CALL p201_p1()
#NO.FUN-570154 mark---
#  IF g_success='Y' THEN
#     CALL cl_cmmsg(1) COMMIT WORK
#  ELSE
#     CALL cl_rbmsg(1) ROLLBACK WORK
#  END IF
#NO.FUN-570154 mark-

END FUNCTION

FUNCTION p201_p1()
 DEFINE  l_cnt    LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_i,l_n  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_y,l_m  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_adg01  LIKE adg_file.adg01,
         l_adg02  LIKE adg_file.adg02,
         l_adg03  LIKE adg_file.adg03

  CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
  IF g_flag = '1' THEN
     CALL cl_err('s_azm:error','agl-038',1)
     LET g_success = 'N'
     RETURN
  END IF
  LET g_sql = "SELECT adf_file.*,adg_file.*",
              "  FROM adg_file,adf_file,add_file,ade_file ",
              " WHERE adf09 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
              "   AND adg01 = adf01 AND adfpost = 'Y' ",
              "   AND adfconf='Y'   AND adfacti = 'Y' ",
              "   AND adg03 = ade01 AND adg04 = ade02 ",
              "   AND add01 = ade01 AND addacti = 'Y' ",
              "   AND addconf = 'Y' AND add07 = 'N'   ",   #未過帳
              "   AND ade13 = 'N'  ",                      #未過帳
              "   AND ",tm.wc CLIPPED,
              " ORDER BY adf01,adg02,adg05"
  PREPARE p201_s2_pre1 FROM g_sql
  IF STATUS THEN CALL cl_err('pre_s2',STATUS,0) RETURN END IF
  DECLARE p201_s2_c CURSOR FOR p201_s2_pre1
  IF STATUS THEN CALL cl_err('dec_s2',STATUS,0) RETURN END IF

  LET p_dbs=g_dbs
  FOREACH p201_s2_c INTO g_adf.*,g_adg.*
    IF STATUS THEN
       CALL cl_err('for_s2',STATUS,0) LET g_success='N' EXIT FOREACH
    END IF
    CALL p201(g_adf.*,g_adg.*,tm.yy,tm.mm,'1')
  END FOREACH
END FUNCTION
#Patch....NO:TQC-610037 <001> #
