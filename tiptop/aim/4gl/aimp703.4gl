# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimp703.4gl
# Descriptions...: 工廠間調撥單清除作業
# Input parameter: 
# Return code....: 
# Date & Author..: 92/07/22 By Apple
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
#
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B70074 11/07/21 By xianghui 添加行業別表的新增於刪除
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD                                   #CONDITION RECORD
         wc               LIKE type_file.chr1000, #Where Condiction       #No.FUN-690026 VARCHAR(300)
         download         LIKE type_file.chr1,    #DownLoad Data?         #No.FUN-690026 VARCHAR(1)
         file_name        LIKE type_file.chr3,    #DownLoad File Name     #No.FUN-690026 VARCHAR(3)
         file_extension   LIKE type_file.dat,     #DownLoad File Extension#No.FUN-690026 DATE
         backup           LIKE type_file.chr1,    #Backup Data?           #No.FUN-690026 VARCHAR(1)
         backup_device    LIKE type_file.chr1,    #Backup Device (1.Tape 2.Floppy)  #No.FUN-690026 VARCHAR(1)
         cleanup          LIKE type_file.chr1,    #CleanUp Date?          #No.FUN-690026 VARCHAR(1)
         more             LIKE type_file.chr1     #是否輸入其它特殊列印條件  #No.FUN-690026 VARCHAR(1)
         END RECORD,
         g_file_extension LIKE type_file.chr6     #No.FUN-690026 VARCHAR(06)
DEFINE   g_chr            LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
MAIN
    #set up options
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
    #initialize program
    LET g_pdate=ARG_VAL(1)        # Get arguments from command line
    LET g_towhom=ARG_VAL(2)
    LET g_rlang=ARG_VAL(3)
    LET g_bgjob=ARG_VAL(4)
    LET g_prtway=ARG_VAL(5)
    LET g_copies=ARG_VAL(6)
    LET tm.wc=ARG_VAL(7)
    LET tm.download=ARG_VAL(8)
    LET tm.file_name=ARG_VAL(9)
    LET tm.file_extension=ARG_VAL(10)
 #  LET tm.backup=ARG_VAL(11)         #No:8537
 #  LET tm.backup_device=ARG_VAL(12)         #No:8537
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
        CALL p703_tm()                        # Input condition
    ELSE
        CALL aimp703()                        # Read data and process it
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION p703_tm()
DEFINE
    p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_cmd          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
    l_warn         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_direction    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_dat          LIKE type_file.chr8,    #No.FUN-690026 VARCHAR(08)
    l_jmp_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_flag         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   #set up screen
   LET p_row=52
   LET p_col=40-(p_row/2)
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p703_w AT p_row,p_col
       WITH FORM "aim/42f/aimp703"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   #initialize program variables
   INITIALIZE tm.* TO NULL
   LET tm.download='N'
   LET tm.file_name='imm'
   LET tm.file_extension=g_today USING 'yymmdd'
   LET tm.backup='N'
   LET tm.cleanup='N'
   LET tm.more='Y'
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
   LET l_jmp_flag='N'
 
   #get user options
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON imm01,imm02,imm09
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
 
      DISPLAY BY NAME tm.download,tm.file_name,tm.file_extension,
                      tm.backup,tm.backup_device,tm.cleanup,tm.more
          
      LET l_warn=1
      INPUT BY NAME tm.download,tm.file_name,tm.file_extension,tm.backup,
                    tm.backup_device,tm.cleanup,tm.more
          WITHOUT DEFAULTS 
 
          BEFORE FIELD file_name
             IF tm.download='N' THEN
                NEXT FIELD cleanup
             END IF
 
          BEFORE FIELD file_extension
             IF tm.download='N' THEN
                NEXT FIELD download
             END IF
 
          AFTER FIELD file_extension
             LET g_file_extension=tm.file_extension USING 'YYMMDD'
             DISPLAY g_file_extension TO file_extension 
 
          AFTER FIELD backup
             LET l_direction='D'
 
          BEFORE FIELD backup_device
             IF tm.download='N' THEN
                NEXT FIELD download
             END IF
             IF tm.backup='N' THEN
                IF l_direction='D' THEN
                   NEXT FIELD cleanup
                ELSE
                   NEXT FIELD backup
                END IF
             END IF
 
          AFTER FIELD cleanup
             LET l_direction='U'
 
          AFTER FIELD more 
             IF tm.more NOT MATCHES "[YN]" THEN
                NEXT FIELD more
             END IF
             IF tm.more = 'N' THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,
                               g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
             END IF
  
          AFTER INPUT
             IF tm.download='N' AND tm.backup='N' AND tm.cleanup='N' THEN
                IF l_warn THEN
                   CALL cl_err('','aim-356',0)
                   LET l_warn=0
                   NEXT FIELD download
                END IF
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
 
        
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
       IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
           WHERE zz01='aimp703'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('aimp703','9031',1)
          ELSE
             LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.download CLIPPED,"'",
                         " '",tm.file_name CLIPPED,"'",
                         " '",tm.file_extension CLIPPED,"'",
                         " '",tm.backup CLIPPED,"'",
                         " '",tm.backup_device CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
             CALL cl_cmdat('aimp703',g_time,l_cmd)
          END IF
          CLOSE WINDOW p703_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
          EXIT PROGRAM
       END IF
       IF cl_sure(0,0) THEN 
          CALL aimp703()
          ERROR ""
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
       END IF
    END WHILE
    CLOSE WINDOW p703_w
END FUNCTION
 
FUNCTION aimp703()
DEFINE
    l_status     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_imm01      LIKE imm_file.imm01,
    l_file_name1 LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(15)
    l_file_name2 LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(15)
    l_file_name3 LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(15)
    l_sql        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(500)
 
    IF tm.download='N'
        AND tm.backup='N'
        AND tm.cleanup='N' THEN
        RETURN
    END IF
 
    IF g_bgjob='N' THEN
        IF NOT cl_sure(16,19) THEN RETURN END IF
    END IF
 
    LET l_file_name1=tm.file_name CLIPPED,'_',g_file_extension CLIPPED
    LET l_file_name2=l_file_name1 CLIPPED,'_b'
 
    LET g_success="Y"
 
    IF tm.download='Y' THEN
        #單頭
        LET l_sql=
            "unload '",l_file_name1,
            " select * from imm_file",
            " where imm10 = '3' and ",tm.wc CLIPPED
        RUN l_sql RETURNING l_status
        IF l_status THEN
           LET g_success="N"
           RETURN
        END IF
 
        #單身
        LET l_sql=
            "unload '",l_file_name2,
            " select imn_file.* from imm_file,imn_file",
            " where imn01=imm01 and imm10 ='3' and imn27='Y'",
            " and ",tm.wc CLIPPED
        RUN l_sql RETURNING l_status
        IF l_status THEN
           LET g_success="N"
           RETURN
        END IF
 
    END IF
 
    IF tm.backup='Y' THEN
        LET l_sql="back_data ",tm.backup_device,        #1.Device
            " ",g_bgjob,                                #2.bgjob
            " ",l_file_name1," ",l_file_name2           #3.file name
        RUN l_sql RETURNING l_status
        IF l_status THEN
           LET g_success="N"
           RETURN
        END IF
    END IF
 
    IF tm.cleanup='Y' THEN
        MESSAGE "delete data ..."
        CALL ui.Interface.refresh()
        LET l_sql="SELECT imm01",
                  " FROM imm_file ",
                  " WHERE imm10 ='3' AND ", tm.wc CLIPPED
        PREPARE p703_p000 FROM l_sql
        IF SQLCA.sqlcode THEN RETURN END IF
        DECLARE p703_curh CURSOR WITH HOLD FOR p703_p000
        IF SQLCA.sqlcode THEN RETURN END IF
 
        LET l_sql= "DELETE FROM imn_file WHERE imn01=?"
        PREPARE p703_dimn FROM l_sql
        IF SQLCA.sqlcode THEN RETURN END IF
 
        LET l_sql= "DELETE FROM imm_file WHERE imm01=?"
        PREPARE p703_dimm FROM l_sql
        IF SQLCA.sqlcode THEN RETURN END IF
 
        LET l_status =0
        FOREACH p703_curh INTO l_imm01
            IF g_bgjob='N' THEN
                MESSAGE 'Delete ...',l_imm01
                CALL ui.Interface.refresh()
            END IF
            LET l_status=l_status + 1
 
            EXECUTE p703_dimn USING l_imm01
            IF SQLCA.sqlcode THEN
               CONTINUE FOREACH 
            #FUN-B70074-add-str--
            ELSE
               IF NOT s_industry('std') THEN 
                  IF NOT s_del_imni(l_imm01,'','')  THEN 
                     CONTINUE FOREACH
                  END IF
               END IF
            #FUN-B70074-add-end--
            END IF
 
            EXECUTE p703_dimm USING l_imm01
        END FOREACH
            LET INT_FLAG = 0  ######add for prompt bug
        PROMPT l_status ," ROW(S) DELETED ..." FOR g_chr
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
#              CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        
        END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
            END IF  
    END IF
    ERROR ""
END FUNCTION
