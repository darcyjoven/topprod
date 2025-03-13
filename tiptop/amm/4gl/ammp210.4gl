# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: ammp210.4gl
# Descriptions...: 加工通知單作廢作業
# Date & Author..: 01/01/30 By Chien
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.FUN-570124 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660094 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990133 09/10/13 By lilingyu 已作廢的通知單再次運行作廢,同樣顯示成功;未作廢的通知單還原,顯示運行成功
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                          # Print condition RECORD
                wc   LIKE type_file.chr1000,   #No.FUN-680100 VARCHAR(400)
                a    LIKE type_file.chr1       #No.FUN-680100 VARCHAR(1)
              END RECORD
    DEFINE      g_change_lang   LIKE type_file.chr1      #No.FUN-680100 VARCHAR(1)#No.FUN-570124
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1          #No.FUN-570124        #No.FUN-680100 VARCHAR(1)
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0076
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   #No.FUN-570124--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc = ARG_VAL(1)
   LET tm.a  = ARG_VAL(2)
   LET g_bgjob= ARG_VAL(3)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
   #No.FUN-570124--end--
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
#NO.FUN-570124 start-------
  #CALL cl_used('ammp210',g_time,1) RETURNING g_time     #No.FUN-6A0076  #FUN-B30211
  CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0076    #FUN-B30211
  WHILE TRUE
   IF g_bgjob="N" THEN
       CALL p210_tm(0,0)
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success='Y'
          BEGIN WORK
          CALL p210_stk()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p210_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
    ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p210_stk()
      IF g_success="Y" THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
END WHILE
   #CALL cl_used('ammp210',g_time,2) RETURNING g_time    #No.FUN-6A0076   #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0076    #FUN-B30211
# No.FUN-570124--end--
# Prog. Version..: '5.30.06-13.03.12(0,0)                              # Input print condition
END MAIN
 
FUNCTION p210_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(500)#No.FUN-570124
 
   LET p_row = 7 LET p_col = 17
   OPEN WINDOW p210_w AT p_row,p_col WITH FORM "amm/42f/ammp210" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
 
 WHILE TRUE                              #NO.FUN-570124
   CONSTRUCT BY NAME tm.wc ON mmf01,mmf02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION locale
         #CALL cl_dynamic_locale()
         # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang=TRUE   #No.FUN-570124
          EXIT CONSTRUCT           #No.FUN-570124
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    #NO.590002 START----------
    LET tm.a = '1'
    #NO.590002 END------------
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmfuser', 'mmfgrup') #FUN-980030
     #No.FUN-570124--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p210_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      END IF
    #No.FUN-570124--end--
 
     #NO.590002 START----------
     LET tm.a = '1'
     #NO.590002 END------------
   LET g_bgjob = 'N' #NO.FUN-570124  
   #INPUT BY NAME tm.a WITHOUT DEFAULTS
   INPUT BY NAME tm.a,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570124
      AFTER FIELD a
         IF tm.a NOT MATCHES "[12]" THEN
            NEXT FIELD a
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        #->No.FUN-570124 --start--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
        #->No.FUN-570124 ---end---
 
 
   END INPUT
#NO.FUN-570124 start------------  
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW p210_w EXIT PROGRAM
#   END IF
 
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p210_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      END IF
 
#   IF NOT cl_sure(0,0) THEN
#      CLOSE WINDOW p210_w RETURN
#   END IF
#   CALL cl_wait()
#   CALL p210_stk()
#   ERROR ""
#   CALL cl_end(19,20)
#   CLOSE WINDOW p210_w
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "ammp210"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('ammp210','9031',1)
        ELSE
         LET tm.wc = cl_replace_str(tm.wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.wc CLIPPED,"'",
                   " '",tm.a CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('ammp210',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p210_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
     END IF
   EXIT WHILE
  END WHILE
  #No.FUN-570124--end---
END FUNCTION
 
FUNCTION p210_stk()
DEFINE l_sql      STRING,        #No.FUN-680100
       l_mmf      RECORD  LIKE mmf_file.*
DEFINE l_chr              LIKE type_file.chr1    #TQC-990133
 
    IF tm.a='1' THEN
        LET l_sql=" SELECT * FROM mmf_file ",    # 作廢
                  "  WHERE ",tm.wc CLIPPED,
                  "    AND mmfacti = 'Y' "
    ELSE
        LET l_sql="SELECT * FROM mmf_file ",     # 作廢還原
                  "         WHERE ",tm.wc CLIPPED,
                  "         AND mmfacti = 'X' "
    END IF
    PREPARE p210_prepare1 FROM l_sql
    DECLARE p210_cs1 CURSOR FOR p210_prepare1
   # BEGIN WORK    #NO.FUN-570124  MARK
   # LET g_success='Y'  #NO.FUN-570124 MARK
 
    LET l_chr = 'N'       #TQC-990133
    FOREACH p210_cs1 INTO l_mmf.*
       IF g_bgjob = 'N' THEN #NO.FUN-570124 
           MESSAGE l_mmf.mmf01,' ',l_mmf.mmf02
           CALL ui.Interface.refresh()
       END IF
       LET l_chr = 'Y' #TQC-990133
              
       IF tm.a='1' THEN 
           UPDATE mmf_file SET mmfacti = 'X',
                               mmfmodu = g_user,
                               mmfdate = g_today
                           WHERE mmf01 = l_mmf.mmf01
                           AND mmf02 = l_mmf.mmf02
           IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
               LET g_success='N'
#               CALL cl_err('upd mmf',STATUS,1) #No.FUN-660094
                CALL cl_err3("upd","mmf_file",l_mmf.mmf01,l_mmf.mmf02,STATUS,"","upd mmf",1)        #NO.FUN-660094
               EXIT FOREACH
           END IF
           UPDATE mmb_file SET mmb13 = '1',
                               mmb131 = '',
                               mmb132 = ''
                           WHERE mmb01 = l_mmf.mmf11
                           AND mmb02 = l_mmf.mmf111
           IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
               LET g_success='N'
#               CALL cl_err('upd mmb',STATUS,1) #No.FUN-660094
                CALL cl_err3("upd","mmb_file",l_mmf.mmf11,l_mmf.mmf111,STATUS,"","upd mmb",1)        #NO.FUN-660094
               EXIT FOREACH
           END IF
       ELSE
           UPDATE mmf_file SET mmfacti = 'Y',
                               mmfmodu = g_user,
                               mmfdate = g_today
                           WHERE mmf01 = l_mmf.mmf01
                           AND mmf02 = l_mmf.mmf02
           IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
               LET g_success='N'
#               CALL cl_err('upd mmf',STATUS,1) #No.FUN-660094
                CALL cl_err3("upd","mmf_file",l_mmf.mmf01,l_mmf.mmf02,STATUS,"","upd mmf",1)        #NO.FUN-660094
               EXIT FOREACH
           END IF
           UPDATE mmb_file SET mmb13 = '2',
                               mmb131 = l_mmf.mmf01,
                               mmb132 = l_mmf.mmf02
                           WHERE mmb01 = l_mmf.mmf11
                           AND mmb02 = l_mmf.mmf111
           IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
               LET g_success='N'
#               CALL cl_err('upd mmb',STATUS,1) #No.FUN-660094
                CALL cl_err3("upd","mmb_file",l_mmf.mmf11,l_mmf.mmf111,STATUS,"","upd mmb",1)        #NO.FUN-660094
               EXIT FOREACH
           END IF
       END IF
    END FOREACH
 
#TQC-990133 --begin--
    IF l_chr = 'N' THEN
       CALL cl_err('','amm-051',0)
       LET g_success = 'N'
    END IF 
#TQC-990133 --end--
    
#NO.FUN-570124 mark-----------
#    IF g_success = 'Y'
#       THEN
#       COMMIT WORK
#       CALL cl_cmmsg(4)
#    ELSE
#       ROLLBACK WORK
#       CALL cl_rbmsg(4)
#    END IF
#NO.FUN-570124 end-----------
END FUNCTION
 
