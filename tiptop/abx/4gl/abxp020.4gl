# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abxp020.4gl
# Descriptions...: 內銷報單產生作業
# Return code....:
# Date & Author..: 96/07/30 BY Star
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據號碼加大
# Modify.........: No.FUN-570115 06/02/24 By saki 增加背景作業功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)  
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
         tm RECORD
                wc     LIKE type_file.chr1000,   #No.FUN-680062 VARCHAR(1000) 
                byea   LIKE type_file.num5,      #No.FUN-680062 smallint
                mo     LIKE type_file.num5,      #No.FUN-680062 smallint
                a      LIKE bxr_file.bxr01,      #No.FUN-680062 VARCHAR(2)
                head   LIKE type_file.chr5,      #FUN-550033  #No.FUN-680062 VARCHAR(5)
                number LIKE type_file.chr20      #No.FUN-680062 VARCHAR(16)
            END RECORD,
         g_number      LIKE type_file.chr20,     #No.FUN-680062 VARCHAR(16)
         g_n           LIKE type_file.num5,      #No.FUN-680062 smallint
         g_back        LIKE type_file.chr8,      #No.FUN-680062 VARCHAR(10)
         l_flag        LIKE type_file.chr1,      #No.FUN-680062 VARCHAR(1)
         g_change_lang LIKE type_file.chr1       #No.FUN-680062 VARCHAR(1)  
#       l_time         LIKE type_file.chr8       #No.FUN-6A0062
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #No.FUN-570115 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc     = ARG_VAL(1)
   LET tm.byea   = ARG_VAL(2)
   LET tm.mo     = ARG_VAL(3)
   LET tm.a      = ARG_VAL(4)
   LET tm.head   = ARG_VAL(5)
   LET tm.number = ARG_VAL(6)
   LET g_bgjob   = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob="N"
   END IF
   #No.FUN-570115 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570115 --start--
   IF s_shut(0) THEN EXIT PROGRAM END IF
#  LET g_back = ' '
#  LET g_back = ARG_VAL(1)
#  IF cl_null(g_back)
#     THEN CALL p020_tm()
#     ELSE LET tm.wc = ' 1=1'
#          CALL abxp020()    #找出欲處理之工單資料
#  END IF
 
   #CALL cl_used('abxp020',g_time,1) RETURNING g_time  #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   WHILE TRUE
     IF g_bgjob="N" THEN
        CALL p020_tm()
        IF cl_sure(0,0) THEN
           CALL cl_wait()
           LET g_success="Y"
           BEGIN WORK
           CALL abxp020()
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
              CLOSE WINDOW p020_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p020_w
     ELSE
        LET g_success="Y"
        BEGIN WORK
        CALL abxp020()
        IF g_success="Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
   #CALL cl_used('abxp020',g_time,2) RETURNING g_time  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   #No.FUN-570115 --end--
END MAIN
 
FUNCTION p020_tm()  #輸入基本條件
 
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680062 smallint
            l_direct     LIKE type_file.chr1            #No.FUN-680062 VARCHAR(1)   
   DEFINE   lc_cmd       LIKE  type_file.chr1000        #No.FUN-680062 VARCHAR(500) 
 
   LET p_row = 6 LET p_col = 25
 
   OPEN WINDOW p020_w AT p_row,p_col WITH FORM "abx/42f/abxp020"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM
      INITIALIZE tm.* TO NULL			# Default condition
      LET g_bgjob="N"                          # No.FUN-570115
      CONSTRUCT BY NAME tm.wc ON bxi01
 
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
 
        ON ACTION locale
#          CALL cl_dynamic_locale()               #No.FUN-570115
#          CALL cl_show_fld_cont()                #No.FUN-550037 hmf  No.FUN-570115
#          EXIT INPUT
           LET g_change_lang = TRUE               #No.FUN-570115
           EXIT CONSTRUCT                         #No.FUN-570115
        ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #No.FUN-570115 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570115 --end--
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm.byea,tm.mo,tm.a,tm.head,tm.number,g_bgjob
        WITHOUT DEFAULTS                          #No.FUN-570115
 
         AFTER FIELD byea
            IF cl_null(tm.byea) OR tm.byea < 0 THEN
               NEXT FIELD byea
            END IF
 
         AFTER FIELD mo
            IF cl_null(tm.mo) OR tm.mo < 0 OR tm.mo > 12 THEN
               NEXT FIELD mo
            END IF
 
         AFTER FIELD a
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
            SELECT * FROM bxr_file WHERE bxr01 = tm.a
            IF STATUS THEN
#              CALL cl_err('err bxr01  ' ,STATUS,0)    #No.FUN-660052
               CALL cl_err3("sel","bxr_file",tm.a,"",STATUS,"","err bxr01  ",0) 
               NEXT FIELD a
            END IF
 
         AFTER FIELD head
            IF cl_null(tm.head) THEN
               NEXT FIELD head
            END IF
 
         AFTER FIELD number
            IF cl_null(tm.number) THEN
               NEXT FIELD number
            END IF
 
         ON ACTION CONTROLR
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
 
 
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(a)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bxr"
                    LET g_qryparam.default1 = tm.a
                    CALL cl_create_qry() RETURNING tm.a
                    NEXT FIELD a
               OTHERWISE EXIT CASE
             END CASE
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      #No.FUN-570115 --start
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01="abxp020"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp020','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",tm.wc CLIPPED,"'",
                       " '",tm.byea CLIPPED,"'",
                       " '",tm.mo CLIPPED,"'",
                       " '",tm.a CLIPPED,"'",
                       " '",tm.head CLIPPED,"'",
                       " '",tm.number CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp020',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p020_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
#     IF cl_sure(0,0) THEN
#        CALL abxp020()    #找出欲處理之保稅資料
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
            EXIT WHILE
#        END IF
#     END IF
#     ERROR ""
   END WHILE
#  CLOSE WINDOW p020_w
  # NO.FUN-570115 --end--
END FUNCTION
 
FUNCTION abxp020()
    DEFINE l_bxi01  LIKE bxi_file.bxi01
    DEFINE l_bxi02  LIKE bxi_file.bxi02
    DEFINE l_bxi03,m_bxi03  LIKE bxi_file.bxi03
    DEFINE l_number  LIKE type_file.chr20     #No.FUN-680062 VARCHAR(20)
    DEFINE l_sql  LIKE type_file.chr1000      #No.FUN-680062 VARCHAR(1000)
 
    LET g_number = tm.number CLIPPED
    LET g_n = 16 - LENGTH(g_number)
    IF cl_null(g_n) THEN LET g_n = 0 END IF
 
    LET l_sql= "SELECT bxi01,bxi02,bxi03 FROM bxi_file  ",
               " WHERE YEAR(bxi02) = ",tm.byea ,
               "   AND MONTH(bxi02) = ", tm.mo ,
               "   AND bxi08 = '", tm.a,"'",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY bxi03,bxi01 "
 
    PREPARE abxp020_prepare1 FROM l_sql
    DECLARE p020_curs CURSOR FOR abxp020_prepare1
    LET g_success = 'Y'
    LET m_bxi03 = ' '
#   BEGIN WORK                                     #No.FUN-570115
    FOREACH p020_curs INTO l_bxi01,l_bxi02,l_bxi03
        IF SQLCA.sqlcode OR g_success = 'N' THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        IF m_bxi03 != l_bxi03
           AND NOT cl_null(m_bxi03)  THEN CALL p020_autono() END IF
        LET m_bxi03 = l_bxi03
        LET l_number = tm.head CLIPPED ,g_number CLIPPED
        UPDATE bxj_file SET bxj11 = l_number ,bxj17 = l_bxi02
         WHERE bxj01 = l_bxi01
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
#          CALL cl_err('(bxj update)',SQLCA.sqlcode,1)   #No.FUN-660052
           CALL cl_err3("upd","bxj_file",l_bxi01,"",SQLCA.sqlcode,"","(bxj update)",1) 
           EXIT FOREACH
        END IF
    END FOREACH
    # No.FUN-570115 --start--
    IF g_bgjob="N" THEN
       MESSAGE " "
    END IF
    # No.FUN-570115 --end--
END FUNCTION
 
FUNCTION p020_autono()
   CASE
      WHEN g_n = 16
        LET g_number = tm.number+1 USING ''
      WHEN g_n = 15
        LET g_number = tm.number+1 USING '&'
      WHEN g_n = 14
        LET g_number = tm.number+1 USING '&&'
      WHEN g_n = 13
        LET g_number = tm.number+1 USING '&&&'
      WHEN g_n = 12
        LET g_number = tm.number+1 USING '&&&&'
      WHEN g_n = 11
        LET g_number = tm.number+1 USING '&&&&&'
      WHEN g_n = 10
        LET g_number = tm.number+1 USING '&&&&&&'
      WHEN g_n =  9
        LET g_number = tm.number+1 USING '&&&&&&&'
      WHEN g_n =  8
        LET g_number = tm.number+1 USING '&&&&&&&&'
      WHEN g_n =  7
        LET g_number = tm.number+1 USING '&&&&&&&&&'
      WHEN g_n =  6
        LET g_number = tm.number+1 USING '&&&&&&&&&&'
      WHEN g_n =  5
        LET g_number = tm.number+1 USING '&&&&&&&&&&&'
      WHEN g_n =  4
        LET g_number = tm.number+1 USING '&&&&&&&&&&&&'
      WHEN g_n =  3
        LET g_number = tm.number+1 USING '&&&&&&&&&&&&&'
      WHEN g_n =  2
        LET g_number = tm.number+1 USING '&&&&&&&&&&&&&&'
      WHEN g_n =  1
        LET g_number = tm.number+1 USING '&&&&&&&&&&&&&&&'
      WHEN g_n =  0
        LET g_number = tm.number+1 USING '&&&&&&&&&&&&&&&&'
   END CASE
   LET tm.number = g_number
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
