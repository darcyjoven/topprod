# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmp650.4gl
# Descriptions...: BOM 重排作業
# Date & Author..: 97/08/06 by Lynn
# Date & Author..: 02/03/13 by Mandy #程式重新改寫,以符合orale版的需求
# Modify.........: No.FUN-4B0001 04/11/01 By Smapmin 主件編號開窗
# Modify.........: No.MOD-520014 05/02/16 By Melody bmt_file/bmc_file架構修改(利用temp_file)
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-570114 06/02/21 By saki 批次背景執行
# Modify.........: No.MOD-650015 06/06/13 By douzh cl_err----->cl_err3
# Modify.........: No.MOD-670119 06/07/26 By Pengu 控管重排間隔數必須大於0
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-710028 07/01/23 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-810053 08/03/05 By Pengu 若重排起始項次的欄位位輸入則default為1
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting    1、將cl_used()改成標準格式，用g_prog
#                                                            2、離開前未加cl_used(2)

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm   RECORD
                seq      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                a        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                b        LIKE type_file.num5     #No.FUN-680096 SMALLINT
               END RECORD
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0060
   DEFINE g_wc          string                   #No.FUN-580092 HCN
   DEFINE g_sql         string                   #No.FUN-580092 HCN
   DEFINE g_bma01       LIKE bma_file.bma01
   DEFINE g_bma06       LIKE bma_file.bma06      #FUN-550093
   DEFINE g_bmb         RECORD LIKE bmb_file.*
   DEFINE g_a           LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE g_b           LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE g_bmb_tmp     DYNAMIC ARRAY OF RECORD LIKE bmb_file.*
   DEFINE g_bmt_tmp     DYNAMIC ARRAY OF RECORD LIKE bmt_file.*
   DEFINE g_bmc_tmp     DYNAMIC ARRAY OF RECORD LIKE bmc_file.*
   DEFINE g_bmb_cnt     LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE g_bmt_cnt     LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE g_bmc_cnt     LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          g_change_lang LIKE type_file.chr1,     #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
          l_flag        LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
 
 
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680096 INTEGER
MAIN
   OPTIONS 
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.FUN-570114 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET tm.seq  = ARG_VAL(2)
   LET tm.a    = ARG_VAL(3)
   LET tm.b    = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570114 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570114 --start--
   #CALL cl_used('abmp650',g_time,1) RETURNING g_time    #No.FUN-6A0060    #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060    #FUN-B30211
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        CALL p650()      
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           BEGIN WORK
           LET g_success = 'Y'
           CALL p650_1()
           CALL s_showmsg()          #No.FUN-710028
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag          #作業成功是否繼續執行
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag          #作業失敗是否繼續執行
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p650_w
     ELSE
        BEGIN WORK
        LET g_success = 'Y'
        CALL p650_1()
        CALL s_showmsg()          #No.FUN-710028
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
   #CALL cl_used('abmp650',g_time,2) RETURNING g_time     #No.FUN-6A0060   #FUN-B30211
    CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0060   #FUN-B30211
#  CALL p650()
   #No.FUN-570114 ---end---
END MAIN
 
FUNCTION p650()
DEFINE lc_cmd    LIKE type_file.chr1000#No.FUN-570114 #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW p650_w AT p_row,p_col WITH FORM "abm/42f/abmp650" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('f')
   LET tm.seq ='1'
   WHILE TRUE
      CLEAR FORM
      CALL g_bmb_tmp.clear()
      CALL g_bmt_tmp.clear()
      CALL g_bmc_tmp.clear()
      LET g_bmb_cnt = 0
      LET g_bmt_cnt = 0
      LET g_bmc_cnt = 0
      LET g_change_lang = FALSE
      LET g_bgjob = 'N'                    #No.FUN-570114
      LET tm.b = 1                         #MOD-670119 add
      LET tm.a = 1                         #No.MOD-810053 add
      CONSTRUCT BY NAME g_wc ON bma01,bma06 #FUN-550093 
      
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP     #FUN-4B0001
            IF INFIELD(bma01) THEN     
               CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_bma3"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bma01
                  NEXT FIELD bma01
            END IF
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
#           CALL cl_dynamic_locale()                  #No.FUN-570114
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG=0 
         CLOSE WINDOW p650_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM 
      END IF
      IF g_change_lang = TRUE THEN 
         LET g_change_lang = FALSE                 #No.FUN-570114
         CALL cl_dynamic_locale()                  #No.FUN-570114
         CALL cl_show_fld_cont()                   #No.FUN-570114 No.FUN-550037 hmf
          CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.seq,tm.a,tm.b,g_bgjob WITHOUT DEFAULTS  #No.FUN-570114 
 
         AFTER FIELD seq
            IF cl_null(tm.seq) OR tm.seq NOT MATCHES '[12]' THEN 
               NEXT FIELD seq 
            END IF
 
         AFTER FIELD a
            IF cl_null(tm.a) THEN
               LET tm.a=1
            END IF
 
         AFTER FIELD b
           #--------No.MOD-670119 modify
            IF NOT cl_null(tm.b) THEN
               IF tm.b <= 0 THEN
                  CALL cl_err('','abm-119',1)
                  NEXT FIELD b
               END IF
            ELSE
               LET tm.b=1
            END IF
           #--------No.MOD-670119 end
 
         #No.FUN-570114 --start--
         ON ACTION locale
             CALL cl_dynamic_locale()               
             LET g_change_lang = TRUE
             EXIT INPUT
         ON ACTION exit                           
             LET INT_FLAG = 1
             EXIT INPUT
         #No.FUN-570114 ---end---
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
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
      END INPUT
 
      #No.FUN-570114 --start--
      IF g_change_lang = TRUE THEN
         LET g_change_lang = FALSE            
         CALL cl_dynamic_locale()          
         CONTINUE WHILE
      END IF
      #No.FUN-570114 ---end--
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         CLOSE WINDOW p650_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM 
      END IF
 
      #No.FUN-570114 --start--
#     BEGIN WORK
#     LET g_success = 'Y'
 
#     IF cl_sure(0,0) THEN
#        CALL p650_1() 
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CLEAR FORM
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END IF
 
     #IF g_success = 'Y' THEN
     #   CALL cl_cmmsg(1)
     #   COMMIT WORK
     #ELSE 
     #   CALL cl_rbmsg(1)
     #   ROLLBACK WORK
     #END IF
 
     #CALL cl_end(0,0) 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = 'abmp650'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abmp650','9031',1)
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",tm.seq CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abmp650',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p650_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
 
#  CLOSE WINDOW p650_w
   #No.FUN-570114 ---end---
END FUNCTION
 
 
FUNCTION p650_1()
   DEFINE l_bmb02_t	LIKE bmb_file.bmb02,
          l_i           LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
   IF g_bgjob = "N" THEN    #No.FUN-570114
      CALL cl_wait()
   END IF
    CALL p650_create_tmp()  #No.MOD-520014
   LET g_sql="SELECT bma01,bma06 FROM bma_file WHERE ",g_wc CLIPPED #FUN-550093
   PREPARE p650_p1 FROM g_sql
   DECLARE p650_c1 CURSOR WITH HOLD FOR p650_p1
   CALL s_showmsg_init()                          #No.FUN-710028
   FOREACH p650_c1 INTO g_bma01,g_bma06
       IF STATUS THEN EXIT FOREACH END IF
      
       #====>SELECT * FROM bmb_file 放到g_bmb_tmp[300].*
       CALL p650_fill_bmb()
      
       DELETE FROM bmb_file WHERE bmb01 = g_bma01 AND bmb29 = g_bma06 #FUN-550093
       IF SQLCA.SQLCODE OR STATUS THEN
#          CALL cl_err('del bmb: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#           CALL cl_err3("del","bmb_file",g_bma01,g_bma06,SQLCA.SQLCODE,"","del bmb: ",1)  # TQC-660046
            LET g_showmsg=g_bma01,"/",g_bma06
           CALL s_errmsg('bmb01,bmb29',g_showmsg,'del bmb: ',SQLCA.SQLCODE,1)
           LET g_success='N' 
#           RETURN
           CONTINUE FOREACH
#No.FUN-710028--end
       END IF
 
       #====>
       LET g_a=tm.a #重排起始項次
       LET g_b=tm.b #重排間隔數
       FOR l_i = 1 TO g_bmb_cnt
           CALL p650_bmt(l_i)
           CALL p650_bmc(l_i)
 
           LET g_bmb_tmp[l_i].bmb02 = g_a
 
           IF cl_null(g_bmb_tmp[l_i].bmb28) THEN
               LET g_bmb_tmp[l_i].bmb28 = 0 
           END IF
 
           #MOD-790002.................begin
           IF cl_null(g_bmb_tmp[l_i].bmb02)  THEN
              LET g_bmb_tmp[l_i].bmb02=' '
           END IF
           #MOD-790002.................end
 
            LET g_bmb_tmp[l_i].bmb33 = 0 #No.FUN-830116
           INSERT INTO bmb_file VALUES (g_bmb_tmp[l_i].*)
           IF SQLCA.SQLCODE THEN
#              CALL cl_err('ins bmb: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#               CALL cl_err3("ins","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.SQLCODE,"","ins bmb: ",1)  # TQC-660046
               LET g_showmsg=g_bmb_tmp[l_i].bmb01,"/",g_bmb_tmp[l_i].bmb02,"/",g_bmb_tmp[l_i].bmb03,"/",g_bmb_tmp[l_i].bmb04,"/",g_bmb_tmp[l_i].bmb29
               CALL s_errmsg('bmb01,bmb02,bmb03,bmb04,bmb29',g_showmsg,'ins bmb: ',SQLCA.SQLCODE,1) 
               LET g_success='N'
#               RETURN
               EXIT FOR
#No.FUN-710028--end
           END IF
           LET g_a = g_a + g_b
       END FOR
        #No.MOD-520014 
       #bmt_file
       DELETE FROM bmt_file WHERE bmt01 = g_bma01 AND bmt08 = g_bma06 #FUN-550093
       IF SQLCA.SQLCODE OR STATUS THEN
#          CALL cl_err('del bmt: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#           CALL cl_err3("del","bmt_file",g_bma01,g_bma06,SQLCA.SQLCODE,"","del bmt: ",1)  # TQC-660046 
           LET g_showmsg=g_bma01,"/",g_bma06
           CALL s_errmsg('bmt01,bmt08',g_showmsg,'del bmt: ',SQLCA.SQLCODE,1)
           LET g_success='N'
#           EXIT FOREACH
            CONTINUE FOREACH
#No.FUN-710028--end
       END IF
       IF NOT SQLCA.SQLERRD[3]=0 THEN
          INSERT INTO bmt_file SELECT * FROM bmt_temp WHERE bmt01 = g_bma01 
                                                        AND bmt08 = g_bma06 #FUN-550093
          IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('ins bmt: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#             CALL cl_err3("ins","bmt_file",g_bma01,g_bma06,SQLCA.SQLCODE,"","ins bmt: ",1)  # TQC-660046
             LET g_showmsg=g_bma01,"/",g_bma06
             CALL s_errmsg('bmt01,bmt08',g_showmsg,'ins bmt: ',SQLCA.SQLCODE,1)    
             LET g_success='N' 
#             RETURN
             CONTINUE FOREACH   
#No.FUN-710028--end
          END IF
       END IF
       DELETE FROM bmt_temp;
 
       #bmc_file
       DELETE FROM bmc_file WHERE bmc01 = g_bma01 AND bmc06 = g_bma06 #FUN-550093
       IF SQLCA.SQLCODE OR STATUS THEN
#          CALL cl_err('del bmc: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#           CALL cl_err3("del","bmc_file",g_bma01, g_bma06,SQLCA.SQLCODE,"","del bmc:",1)  # TQC-660046
           LET g_showmsg=g_bma01,"/",g_bma06
           CALL s_errmsg('bmc01,bmc08',g_showmsg,'del bmc: ',SQLCA.SQLCODE,1)    
           LET g_success='N' 
#           EXIT FOREACH
           CONTINUE FOREACH   
#No.FUN-710028--end
       END IF
       IF NOT SQLCA.SQLERRD[3]=0 THEN
          INSERT INTO bmc_file SELECT * FROM bmc_temp WHERE bmc01 = g_bma01 
                                                        AND bmc06 = g_bma06 #FUN-550093
          IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('ins bmc: ',SQLCA.SQLCODE,1) #No.TQC-660046
#No.FUN-710028--begin
#             CALL cl_err3("ins","bmc_file",g_bma01,g_bma06,SQLCA.SQLCODE,"","ins bmc: ",1)  # TQC-660046
             LET g_showmsg=g_bma01,"/",g_bma06
             CALL s_errmsg('bmc01,bmc08',g_showmsg,'ins bmc: ',SQLCA.SQLCODE,1)    
             LET g_success='N' 
#             RETURN
             CONTINUE FOREACH   
#No.FUN-710028--end
          END IF
       END IF
       DELETE FROM bmc_temp;
        #No.MOD-520014 
   END FOREACH
END FUNCTION
 
FUNCTION p650_bmt(p_i)
DEFINE p_i LIKE type_file.num5,         #No.FUN-680096 SMALLINT
       l_i LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    DECLARE p650_cur_bmt CURSOR FOR 
        SELECT * FROM bmt_file
         WHERE bmt01= g_bmb_tmp[p_i].bmb01 
           AND bmt02= g_bmb_tmp[p_i].bmb02
           AND bmt03= g_bmb_tmp[p_i].bmb03 
           AND bmt04= g_bmb_tmp[p_i].bmb04
           AND bmt08= g_bmb_tmp[p_i].bmb29 #FUN-550093
 
    CALL g_bmt_tmp.clear()
 
#   FOR g_cnt = 1 TO g_bmt.getLength()           #ARRAY 乾洗
#       INITIALIZE g_bmt_tmp[g_cnt].* TO NULL
#   END FOR
 
    LET g_cnt = 1
    FOREACH p650_cur_bmt INTO g_bmt_tmp[g_cnt].*
        LET g_bmt_tmp[g_cnt].bmt02 = g_a
         #No.MOD-520014   
        #CHI-790004..................begin
        IF cl_null(g_bmt_tmp[g_cnt].bmt02) THEN
           LET g_bmt_tmp[g_cnt].bmt02=0
        END IF
        #CHI-790004..................end 
        INSERT INTO bmt_temp VALUES(g_bmt_tmp[g_cnt].*) 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('','ins bmt_temp',1) #No.TQC-660046
#No.FUN-710028--begin
#            CALL cl_err3("ins","bmt_temp","","","ins bmt_temp","","",1)  # TQC-660046
            CALL s_errmsg('bmt_temp','','','ins bmt_temp',1)
#No.FUN-710028--end
            LET g_success = 'N'
        END IF
         #No.MOD-520014   
        LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_bmt_cnt = g_cnt - 1
 
 #NO.MOD-520014
#   DELETE FROM bmt_file 
#       WHERE bmt01= g_bmb_tmp[p_i].bmb01 
#         AND bmt02= g_bmb_tmp[p_i].bmb02
#         AND bmt03= g_bmb_tmp[p_i].bmb03 
#         AND bmt04= g_bmb_tmp[p_i].bmb04
#
#   IF SQLCA.SQLCODE OR STATUS THEN
#       CALL cl_err('del bmt: ',SQLCA.SQLCODE,1)
#       LET g_success='N' 
#       RETURN
#   END IF
#
#   FOR l_i = 1 TO g_bmt_cnt 
#       INSERT INTO bmt_file VALUES (g_bmt_tmp[l_i].*)
#       IF SQLCA.SQLCODE OR STATUS THEN
#           CALL cl_err('ins bmt: ',SQLCA.SQLCODE,1)
#           LET g_success='N'
#       END IF
#   END FOR
 #NO.MOD-520014
END FUNCTION
 
FUNCTION p650_bmc(p_i)
DEFINE p_i LIKE type_file.num5,         #No.FUN-680096 SMALLINT
       l_i LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    DECLARE p650_cur_bmc CURSOR FOR 
        SELECT * FROM bmc_file
         WHERE bmc01 = g_bmb_tmp[p_i].bmb01 
           AND bmc02 = g_bmb_tmp[p_i].bmb02
           AND bmc021= g_bmb_tmp[p_i].bmb03 
           AND bmc03 = g_bmb_tmp[p_i].bmb04
           AND bmc06 = g_bmb_tmp[p_i].bmb29 #FUN-550093
 
    CALL g_bmc_tmp.clear()
 
#   FOR g_cnt = 1 TO g_bmc.getLength()           #ARRAY 乾洗
#       INITIALIZE g_bmc_tmp[g_cnt].* TO NULL
#   END FOR
 
    LET g_cnt = 1
    FOREACH p650_cur_bmc INTO g_bmc_tmp[g_cnt].*
        LET g_bmc_tmp[g_cnt].bmc02 = g_a
         #No.MOD-520014   
        INSERT INTO bmc_temp VALUES(g_bmc_tmp[g_cnt].*) 
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('','ins bmc_temp',1) #No.TQC-660046
#No.FUN-710028--begin
#             CALL cl_err3("ins","bmc_temp","","","ins bmc_temp","","",1)  # TQC-660046               
             CALL s_errmsg('bmc_tmp','','','ins bmc_temp',1)
#No.FUN-710028--end
            LET g_success = 'N'
        END IF
         #No.MOD-520014   
        LET g_cnt = g_cnt + 1
 
    END FOREACH
    LET g_bmc_cnt = g_cnt - 1
 
 #No.MOD-520014
#   DELETE FROM bmc_file 
#        WHERE bmc01 = g_bmb_tmp[p_i].bmb01 
#          AND bmc02 = g_bmb_tmp[p_i].bmb02
#          AND bmc021= g_bmb_tmp[p_i].bmb03 
#          AND bmc03 = g_bmb_tmp[p_i].bmb04
#   IF SQLCA.SQLCODE OR STATUS THEN
#       CALL cl_err('del bmt: ',SQLCA.SQLCODE,1)
#       LET g_success='N' 
#       RETURN
#   END IF
#
#   FOR l_i = 1 TO g_bmc_cnt 
#       INSERT INTO bmc_file VALUES (g_bmc_tmp[l_i].*)
#       IF SQLCA.SQLCODE OR STATUS THEN
#           CALL cl_err('ins bmc: ',SQLCA.SQLCODE,1)
#           LET g_success='N'
#       END IF
#   END FOR
 #No.MOD-520014
END FUNCTION
 
#====>BODY FILL UP====>bmb_file
FUNCTION p650_fill_bmb()
    IF tm.seq = '1' THEN
        LET g_sql =" SELECT * FROM bmb_file ",
                   "  WHERE bmb01 ='",g_bma01,"'",
                   " AND bmb29 ='",g_bma06,"'", #FUN-550093
                   " ORDER BY bmb02 "
    ELSE
        LET g_sql =" SELECT * FROM bmb_file ",
                   "  WHERE bmb01 ='",g_bma01,"'",
                   " AND bmb29 ='",g_bma06,"'", #FUN-550093
                   " ORDER BY bmb03 "
    END IF
    PREPARE p650_bmb_p FROM g_sql
    DECLARE p650_bmb_tmp CURSOR FOR p650_bmb_p
 
    CALL g_bmb_tmp.clear()
 
#   FOR g_cnt = 1 TO g_bmb.getLength()           #單身 ARRAY 乾洗
#       INITIALIZE g_bmb_tmp[g_cnt].* TO NULL
#   END FOR
 
    LET g_cnt = 1
    FOREACH p650_bmb_tmp INTO g_bmb_tmp[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
#No.FUN-710028--begin
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
#No.FUN-710028--end
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_bmb_cnt = g_cnt - 1
END FUNCTION
 
 #No.MOD-520014
FUNCTION p650_create_tmp()
  DROP TABLE bmt_temp;
  SELECT bmt_file.* FROM bmt_file
   WHERE bmt01 = '@@@@@@@@@@@@@@@@@@@@' INTO TEMP bmt_temp
  IF STATUS THEN
     LET g_success = 'N'
#     CALL cl_err('create bmt_temp:',STATUS,1)       # TQC-660046  
      CALL cl_err3("ins","bmt_temp","","",STATUS,"","create bmt_temp:",1)  # TQC-660046               
  END IF
  DELETE FROM bmt_temp WHERE 1=1
 
  DROP TABLE bmc_temp;
  SELECT bmc_file.* FROM bmc_file
   WHERE bmc01 = '@@@@@@@@@@@@@@@@@@@@' INTO TEMP bmc_temp
  IF STATUS THEN
     LET g_success = 'N'
#     CALL cl_err('create bmc_temp:',STATUS,1)    # TQC-660046 
      CALL cl_err3("ins","bmc_temp","","",STATUS,"","create bmc_temp:",1)  # TQC-660046               
  END IF
  DELETE FROM bmc_temp WHERE 1=1
END FUNCTION
 #No.MOD-520014
 
