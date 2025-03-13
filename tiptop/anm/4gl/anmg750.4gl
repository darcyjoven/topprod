# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: anmg750.4gl
# Descriptions...: 還本付款憑證
# Date & Author..: 97/09/12 By Lynn
# Modify by Joan : 020509 add列印欄位"利率"
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No.FUN-580010 05/08/09 By will 報表轉XML格式
# Modify.........: No.MOD-590492 05/10/03 By Dido 報表調整
# Modify.........: No.FUN-5A0180 05/10/25 By Clarei 報表調整可印Font 10
# Modify.........: No.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/02/02 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-870306 08/08/01 By Sarah CR Temptable增加azi07_t
# Modify.........: No.MOD-930156 09/03/13 By lilingyu 還本付款憑証的支付銀行簡稱錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30049 10/03/09 By sabrina 應加上CALL cl_del_data(l_table)，否則執行報表時資料會重複
# Modify.........: No.FUN-B40092 11/05/16 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/04 By minpp GR程序優化 
# Modify.........: No.CHI-C80041 12/12/27 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) # Where condition
              n       LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)   # 列印單價
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
#  DEFINE g_dash1     VARCHAR(200)                  #No.FUN-580010
 
   DEFINE g_i         LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash      VARCHAR(400)  #Dash line
#DEFINE   g_len       SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno    SMALLINT   #Report page no
#DEFINE   g_zz05      VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE l_table       STRING                   #FUN-710085 add                                                                       
DEFINE g_sql         STRING                   #FUN-710085 add                                                                       
DEFINE g_str         STRING                   #FUN-710085 add 
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-C50007
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-C50007
DEFINE g_flag        LIKE type_file.chr1     #FUN-C50007 
###GENGRE###START
TYPE sr1_t RECORD
    nnk01 LIKE nnk_file.nnk01,
    nnk02 LIKE nnk_file.nnk02,
    nnk04 LIKE nnk_file.nnk04,
    nnk05 LIKE nnk_file.nnk05,
    nnk06 LIKE nnk_file.nnk06,
    nnk07 LIKE nnk_file.nnk07,
    nnk08 LIKE nnk_file.nnk08,
    nnk09 LIKE nnk_file.nnk09,
    nnk10 LIKE nnk_file.nnk10,
    nnk17 LIKE nnk_file.nnk17,
    nnk18 LIKE nnk_file.nnk18,
    nnk19 LIKE nnk_file.nnk19,
    nnk21 LIKE nnk_file.nnk21,
    nnk22 LIKE nnk_file.nnk22,
    nnk23 LIKE nnk_file.nnk23,
    nnkglno LIKE nnk_file.nnkglno,
    nnl02 LIKE nnl_file.nnl02,
    nnl03 LIKE nnl_file.nnl03,
    nnl04 LIKE nnl_file.nnl04,
    nnl11 LIKE nnl_file.nnl11,
    nnl12 LIKE nnl_file.nnl12,
    nnl13 LIKE nnl_file.nnl13,
    nnl14 LIKE nnl_file.nnl14,
    nnl15 LIKE nnl_file.nnl15,
    nnl16 LIKE nnl_file.nnl16,
    nnl17 LIKE nnl_file.nnl17,
    nnl15_nnl12 LIKE nnl_file.nnl15,   #FUN-B40092   add
    nnl17_nnl14 LIKE nnl_file.nnl17,   #FUN-B40092   add
    nma02 LIKE nma_file.nma02,
    nma02_2 LIKE nma_file.nma02,
    alg02 LIKE alg_file.alg02,
    nml02 LIKE nml_file.nml02,
    nmd02 LIKE nmd_file.nmd02,
    aag02 LIKE aag_file.aag02,        #FUN-C50007 add
    Date1 LIKE type_file.dat,
    Date2 LIKE type_file.dat,
    rate LIKE nne_file.nne13,
    azi03_t LIKE azi_file.azi03,
    azi04_t LIKE azi_file.azi04,
    azi05_t LIKE azi_file.azi05,
    azi07_t LIKE azi_file.azi07,
    azi04_g LIKE azi_file.azi04,
    azi05_g LIKE azi_file.azi05,
    azi07_g LIKE azi_file.azi07,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-710085--begin  
   LET g_sql = "nnk01.nnk_file.nnk01,nnk02.nnk_file.nnk02,",
               "nnk04.nnk_file.nnk04,nnk05.nnk_file.nnk05,",
               "nnk06.nnk_file.nnk06,nnk07.nnk_file.nnk07,",
               "nnk08.nnk_file.nnk08,nnk09.nnk_file.nnk09,",
               "nnk10.nnk_file.nnk10,nnk17.nnk_file.nnk17,",
               "nnk18.nnk_file.nnk18,nnk19.nnk_file.nnk19,",
               "nnk21.nnk_file.nnk21,nnk22.nnk_file.nnk22,",
               "nnk23.nnk_file.nnk23,nnkglno.nnk_file.nnkglno,",
               "nnl02.nnl_file.nnl02,nnl03.nnl_file.nnl03,",
               "nnl04.nnl_file.nnl04,nnl11.nnl_file.nnl11,",
               "nnl12.nnl_file.nnl12,nnl13.nnl_file.nnl13,",
               "nnl14.nnl_file.nnl14,nnl15.nnl_file.nnl15,",
               "nnl16.nnl_file.nnl16,nnl17.nnl_file.nnl17,",
               "nnl15_nnl12.nnl_file.nnl15,",                   #FUN-B40092 
               "nnl17_nnl14.nnl_file.nnl17,",                   #FUN-B40092
               "nma02.nma_file.nma02,nma02_2.nma_file.nma02,",
               "alg02.alg_file.alg02,nml02.nml_file.nml02,",
               "nmd02.nmd_file.nmd02,aag02.aag_file.aag02,Date1.type_file.dat,", #FUN-C50007 add aag02
               "Date2.type_file.dat, rate.nne_file.nne13,",
               "azi03_t.azi_file.azi03,azi04_t.azi_file.azi04,",
               "azi05_t.azi_file.azi05,azi07_t.azi_file.azi07,",   #MOD-870306 add
               "azi04_g.azi_file.azi04,azi05_g.azi_file.azi05,",
               "azi07_g.azi_file.azi07,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
 
   LET l_table = cl_prt_temptable('anmg750',g_sql) CLIPPED 
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF        
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,   ?,?,?,?)"   #MOD-870306 add ?   #FUN-B40092 add ?,?#FUN-C40020 ADD 4? 3FUN-C50007 ADD ?
   PREPARE insert_prep FROM g_sql            
   IF STATUS THEN                    
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM  
   END IF     
#No.FUN-710085--end  
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL anmg750_tm(0,0)             # Input print condition
      ELSE
           CALL anmg750()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg750_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,  #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000#No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW anmg750_w AT p_row,p_col
        WITH FORM "anm/42f/anmg750"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nnk01,nnk02,nnk04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmg750_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmg750_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmg750'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmg750','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmg750',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmg750_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmg750()
   ERROR ""
END WHILE
   CLOSE WINDOW anmg750_w
END FUNCTION
 
FUNCTION anmg750()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
    #     sr        RECORD LIKE nnk_file.*,       #FUN-B40092 mark
          #FUN-B40092-----add----str-
          sr        RECORD    
                    nnk01  LIKE nnk_file.nnk01,
                    nnk02  LIKE nnk_file.nnk02,
                    nnk04  LIKE nnk_file.nnk04,
                    nnk05  LIKE nnk_file.nnk05,
                    nnk06  LIKE nnk_file.nnk06,
                    nnk07  LIKE nnk_file.nnk07,
                    nnk08  LIKE nnk_file.nnk08,
                    nnk09  LIKE nnk_file.nnk09,
                    nnk10  LIKE nnk_file.nnk10,
                    nnk17  LIKE nnk_file.nnk17,
                    nnk18  LIKE nnk_file.nnk18,
                    nnk19  LIKE nnk_file.nnk19,
                    nnk21  LIKE nnk_file.nnk21,
                    nnk22  LIKE nnk_file.nnk22,
                    nnk23  LIKE nnk_file.nnk23,
                    nnkglno  LIKE nnk_file.nnkglno
                    END RECORD,
          #FUN-B40092 ----add----end--------- 
    #     sr1       RECORD LIKE nnl_file.*     #FUN-B40092-----mark
        #FUN-B40092-----add-str-----
          sr1       RECORD 
                    nnl02  LIKE nnl_file.nnl02, 
                    nnl03  LIKE nnl_file.nnl03, 
                    nnl04  LIKE nnl_file.nnl04, 
                    nnl11  LIKE nnl_file.nnl11, 
                    nnl12  LIKE nnl_file.nnl12, 
                    nnl13  LIKE nnl_file.nnl13, 
                    nnl14  LIKE nnl_file.nnl14, 
                    nnl15  LIKE nnl_file.nnl15, 
                    nnl16  LIKE nnl_file.nnl16, 
                    nnl17  LIKE nnl_file.nnl17,
                    nnl15_nnl12 LIKE nnl_file.nnl15,
                    nnl17_nnl14 LIKE nnl_file.nnl17
                    END RECORD 
          #FUN-B40092--add--end---
#No.FUN-710085--begin
  DEFINE l_alg02   LIKE alg_file.alg02
  DEFINE l_nma02,l_nma02_2  LIKE nma_file.nma02
  DEFINE l_nmd02   LIKE nmd_file.nmd02
  DEFINE l_nml02   LIKE nml_file.nml02
  DEFINE l_aag02   LIKE aag_file.aag02 #FUN-C50007 add
  DEFINE l_date1,l_date2  LIKE type_file.dat
  DEFINE l_rate    LIKE nne_file.nne13
  DEFINE t_azi03   LIKE azi_file.azi03
  DEFINE t_azi04   LIKE azi_file.azi04
  DEFINE t_azi05   LIKE azi_file.azi05    
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
  
    #清除暫存檔的資料
     CALL cl_del_data(l_table)        #MOD-A30049  add

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmg750'
#No.FUN-710085--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg750'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 112 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#No.FUN-580010  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nnkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnkuser', 'nnkgrup')
     #End:FUN-980030
 
    #LET l_sql="SELECT * FROM nnk_file,nnl_file",   #FUN-B40092 mark
     LET l_sql="SELECT nnk01,nnk02,nnk04,nnk05,nnk06,nnk07,nnk08,nnk09,nnk10,nnk17,nnk18,",
               "       nnk19,nnk21,nnk22,nnk23,nnkglno,nnl02,nnl03,nnl04,nnl11, ",
               #FUN-C50007--MOD--STR
             # "       nnl12,nnl13,nnl14,nnl15,nnl16,nnl17,'' ",
             # " FROM nnk_file ,nnl_file",
               "      nnl12,nnl13,nnl14,nnl15,nnl16,nnl17,'','',alg02,a.nma02,b.nma02,nml02,nmd02,azi03,azi04,azi05,azi07 ",  
               " FROM nnk_file LEFT OUTER JOIN alg_file ON nnk05=alg01 LEFT OUTER JOIN nma_file a ON nnk06=a.nma01 ",
               " LEFT OUTER JOIN nma_file b ON nnk18=b.nma01 LEFT OUTER JOIN nml_file ON nnk19=nml01 ",
               " LEFT OUTER JOIN nmd_file ON nnk21=nmd01 LEFT OUTER JOIN azi_file ON azi01=nnk04,nnl_file ",
               #FUN-C50007--MOD--END
               " WHERE nnk01=nnl01 ",
               "   AND nnkconf <> 'X' ",  #CHI-C80041
               "   AND ",tm.wc CLIPPED
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nnkconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nnkconf='N' "
     END IF
     PREPARE anmg750_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM 
     END IF
     DECLARE anmg750_curs1 CURSOR FOR anmg750_prepare1
 
#No.FUN-710085--begin
#    CALL cl_outnam('anmg750') RETURNING l_name
#    START REPORT anmg750_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-710085--end
   #  FOREACH anmg750_curs1 INTO sr.*,sr1.*     #FUN-C50007 MARK
      FOREACH anmg750_curs1 INTO sr.*,sr1.*,
                                 l_alg02,l_nma02,l_nma02_2,l_nml02,l_nmd02,t_azi03,t_azi04,t_azi05,t_azi07  #FUN-C50007
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-710085--begin
      #FUN-C50007 mark--str
      #SELECT azi03,azi04,azi05,azi07           #MOD-870306 add azi07
      #  INTO t_azi03,t_azi04,t_azi05,t_azi07   #MOD-870306 add t_azi07
      #  FROM azi_file
      # WHERE azi01=sr.nnk04
      #SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nnk05  
      #IF SQLCA.sqlcode THEN LET l_alg02 = ' ' END IF
      #SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nnk06
      #IF SQLCA.sqlcode THEN LET l_nma02 = ' ' END IF
      #SELECT nma02 INTO l_nma02_2 FROM nma_file WHERE nma01=sr.nnk18
      #IF SQLCA.sqlcode THEN LET l_nma02_2 = ' ' END IF
      # SELECT nmd02 INTO l_nmd02 FROM nmd_file WHERE nmd01=sr.nnk21
      #IF SQLCA.sqlcode THEN LET l_nma02 = ' ' END IF    #MOD-930156
      #IF SQLCA.sqlcode THEN LET l_nmd02 = ' ' END IF    #MOD-930156
       
      # SELECT nml02 INTO l_nml02 FROM nml_file WHERE nml01=sr.nnk19  
      # IF SQLCA.sqlcode THEN LET l_nml02 = ' ' END IF                
      #FUN-C50007 mark--end
      CALL s_get_bookno(YEAR(sr.nnk02))  RETURNING g_flag,g_bookno1,g_bookno2           #FUN-C50007  add
       SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.nnk10 AND aag00=g_bookno1 #FUN-C50007  add
       IF STATUS=100 THEN LET l_aag02=' ' END IF                                        #FUN-C50007  add
        IF sr1.nnl03 = '1' THEN    #融資
           SELECT nne111,nne112,nne13 INTO l_date1,l_date2,l_rate FROM nne_file
              WHERE nne01=sr1.nnl04
           IF SQLCA.sqlcode THEN
              LET l_date1 = null
              LET l_date2 = null
              LET l_rate  = null
           END IF
       ELSE                       #中長貸
           SELECT nng101,nng102,nng09 INTO l_date1,l_date2,l_rate FROM nng_file
              WHERE nng01=sr1.nnl04
           IF SQLCA.sqlcode THEN
              LET l_date1 = null
              LET l_date2 = null
              LET l_rate  = null
           END IF
       END IF
       LET sr1.nnl15_nnl12 = sr1.nnl15 + sr1.nnl12    #FUN-B40092 
       LET sr1.nnl17_nnl14 = sr1.nnl17 + sr1.nnl14    #FUN-B40092
       EXECUTE insert_prep USING
          sr.nnk01,  sr.nnk02, sr.nnk04, sr.nnk05, sr.nnk06,
          sr.nnk07,  sr.nnk08, sr.nnk09, sr.nnk10, sr.nnk17,
          sr.nnk18,  sr.nnk19, sr.nnk21, sr.nnk22, sr.nnk23,
          sr.nnkglno,sr1.nnl02,sr1.nnl03,sr1.nnl04,sr1.nnl11,
          sr1.nnl12, sr1.nnl13,sr1.nnl14,sr1.nnl15,sr1.nnl16,
          sr1.nnl17, sr1.nnl15_nnl12,  sr1.nnl17_nnl14,  l_nma02,l_nma02_2,l_alg02,l_nml02,  #FUN-B40092 add sr1.nnl15_nnl12  sr1.nnl17_nnl14 
          l_nmd02,   l_aag02,l_Date1,  l_Date2,  l_rate,   t_azi03,    #FUN-C50007 add--aag02
          t_azi04,   t_azi05,  t_azi07,  g_azi04,  g_azi05,   #MOD-870306 add t_azi07
          g_azi07,"",  l_img_blob,"N",""  # No.FUN-C40020 add
 
#      OUTPUT TO REPORT anmg750_rep(sr.*,sr1.*)
#No.FUN-710085--end
     END FOREACH
 
#No.FUN-710085--begin                                                                                                               
#    FINISH REPORT anmg750_rep                                                                                                      
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                    
     CALL cl_wcchp(tm.wc,'nnk01,nnk02,nnk04')
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED #TQC-730088
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
###GENGRE###     LET g_str = tm.wc                       
   # CALL cl_prt_cs3('anmg750',g_sql,g_str)   #TQC-73088
###GENGRE###     CALL cl_prt_cs3('anmg750','anmg750',g_sql,g_str) 
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "nnk01"                    # No.FUN-C40020 add
    CALL anmg750_grdata()    ###GENGRE###
#No.FUN-710085--end 
END FUNCTION
 
#No.FUN-710085--begin
#REPORT anmg750_rep(sr,sr1)
#  DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#         sr        RECORD LIKE nnk_file.*,
#         sr1       RECORD LIKE nnl_file.*,
#         l_flag    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#         t_azi03   LIKE azi_file.azi03,     #NO.CHI-6A0004
#         t_azi05   LIKE azi_file.azi05      #NO.CHI-6A0004
#  DEFINE l_alg02   LIKE alg_file.alg02
#  DEFINE l_nma02,l_nma02_2  LIKE nma_file.nma02
#  DEFINE l_nmd02   LIKE nmd_file.nmd02
#  DEFINE l_nml02   LIKE nml_file.nml02
#  DEFINE l_date1,l_date2  LIKE type_file.dat     #No.FUN-680107 DATE
## Joan 020509---- add列印欄位"利率"-------------------------
#  DEFINE t_azi04   LIKE azi_file.azi04
#  DEFINE l_rate    LIKE nne_file.nne13
## Joan 020509 end-------------------------------------------
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#  ORDER BY sr.nnk01,sr1.nnl02
#  FORMAT
#   PAGE HEADER
##No.FUN-580010  --begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<'
##MOD-590492
##     PRINT ' '
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
##MOD-590492 End
#      PRINT g_dash
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT ' '
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1];
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT ' '
##     LET g_pageno= g_pageno+1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##     PRINT g_dash[1,g_len]
##No.FUN-580010  --end
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.nnk01
#      SKIP TO TOP OF PAGE
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.nnk04
#
#        LET l_flag = 'N'
#        SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nnk05
#        IF SQLCA.sqlcode THEN LET l_alg02 = ' ' END IF
#        SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nnk06
#        IF SQLCA.sqlcode THEN LET l_nma02 = ' ' END IF
#        SELECT nma02 INTO l_nma02_2 FROM nma_file WHERE nma01=sr.nnk18
#        IF SQLCA.sqlcode THEN LET l_nma02_2 = ' ' END IF
#        SELECT nmd02 INTO l_nmd02 FROM nmd_file WHERE nmd01=sr.nnk21
#        IF SQLCA.sqlcode THEN LET l_nma02 = ' ' END IF
#        SELECT nml02 INTO l_nml02 FROM nml_file WHERE nml01=sr.nnk19
#        IF SQLCA.sqlcode THEN LET l_nml02 = ' ' END IF
#
#        PRINT g_x[11] CLIPPED,sr.nnk01,COLUMN 30,g_x[12] CLIPPED,
#              sr.nnk06,'  ',l_nma02,5 SPACES;
#    #   2001/03/15 Joan
#    #   CASE sr.nnk07
#    #        WHEN '0' PRINT g_x[28] CLIPPED
#    #        WHEN '1' PRINT g_x[29] CLIPPED
#    #        WHEN '2' PRINT g_x[30] CLIPPED
#    #   END CASE
#
#        CASE sr.nnk07
#             WHEN '1' PRINT g_x[28] CLIPPED
#             WHEN '2' PRINT g_x[29] CLIPPED
#             WHEN '3' PRINT g_x[30] CLIPPED
#        END CASE
#    #   2001/03/15 end
#
#        PRINT g_x[13] CLIPPED,sr.nnk02,COLUMN 30,g_x[14] CLIPPED,
#              sr.nnk08,' ',g_x[18] CLIPPED,sr.nnk22,
#              COLUMN 77,g_x[15] CLIPPED,COLUMN 64,cl_numfor(sr.nnk09,10,g_azi07)
#
#        PRINT g_x[16] CLIPPED,sr.nnk04,COLUMN 30,g_x[17] CLIPPED,
#              sr.nnk10[1,14],
#              COLUMN 77,g_x[31] CLIPPED,COLUMN 64,cl_numfor(sr.nnk23,10,g_azi07)
#
#        PRINT g_x[19] CLIPPED,sr.nnk05,' ',l_alg02 CLIPPED,
#              COLUMN 30, g_x[20] CLIPPED,
#              sr.nnk21 CLIPPED,
#              COLUMN 77, g_x[21] CLIPPED,l_nmd02
#{---modi by kitty
#        PRINT g_x[19] CLIPPED,sr.nnk05,' ',l_alg02,COLUMN 30,g_x[20] CLIPPED,
#              sr.nnk21,6 SPACES,g_x[21] CLIPPED,l_nmd02
#---}
#
#        PRINT g_x[22] CLIPPED,sr.nnkglno,
#              COLUMN 30,g_x[32] CLIPPED,
#              COLUMN 39,cl_numfor(sr.nnk17,18,g_azi04),
#                        sr.nnk18 clipped,'  ',l_nma02_2 clipped
#
#        PRINT COLUMN 30,g_x[33] CLIPPED,sr.nnk19,' ',l_nml02
##No.FUN-580010  --begin
#        PRINT g_dash
#        #FUN-5A0180-begin
#        #PRINTX name=H1 g_x[36],g_x[37],g_x[38],g_x[39],
#        #               g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#        #PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],
#        #               g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
#        PRINTX name=H1 g_x[36],g_x[37],g_x[38],g_x[39],
#                       g_x[40],g_x[42],g_x[44]
#        PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],
#                       g_x[49],g_x[43],g_x[53]
#        PRINTX name=H3 g_x[54],g_x[41],g_x[51]
#        PRINTX name=H4 g_x[55],g_x[50],g_x[52]
#        #FUN-5A0180-end
#        PRINT g_dash1
##        PRINT g_dash[1,g_len]
##        PRINT COLUMN 2,g_x[23] ,
##              COLUMN 62,g_x[24] ,
##              COLUMN 104,g_x[35]
##       #PRINT g_x[23] ,g_x[24] CLIPPED   #modi by kitty
##        PRINT COLUMN 5,g_x[25] ,
##              COLUMN 62,g_x[26] ,
##              COLUMN 104,g_x[34]
##       #PRINT g_x[25] ,g_x[26] CLIPPED   #modi by kitty
##       #PRINT ' --   -   ----------    --------  ---------------  ',
##       #      '---------------  ---------'
##       PRINT COLUMN 1,'---',   #No.FUN-570177
##             COLUMN 5,'-----',
###No.FUN-550057 --start--
##             COLUMN 11,'----------------',
##             COLUMN 28,'--------',
##             COLUMN 38,'-------------------',
##             COLUMN 59,'-------------------',
##             COLUMN 80,'-------------------',
##             COLUMN 101,'-------------------',
##             COLUMN 122,'-------------------'
###No.FUN-550057 ---end--
##No.FUN-580010  -end
#   ON EVERY ROW
## Joan 020509----add列印欄位"利率"------------------------------------
#{
#      IF sr1.nnl03 = '1' THEN    #融資
#          SELECT nne111,nne112 INTO l_date1,l_date2 FROM nne_file
#             WHERE nne01=sr1.nnl04
#          IF SQLCA.sqlcode THEN
#             LET l_date1 = null LET l_date2 = null
#          END IF
#      ELSE                       #中長貸
#          SELECT nng101,nng102 INTO l_date1,l_date2 FROM nng_file
#             WHERE nng01=sr1.nnl04
#          IF SQLCA.sqlcode THEN
#             LET l_date1 = null LET l_date2 = null
#          END IF
#      END IF
#}
#      IF sr1.nnl03 = '1' THEN    #融資
#          SELECT nne111,nne112,nne13 INTO l_date1,l_date2,l_rate FROM nne_file
#             WHERE nne01=sr1.nnl04
#          IF SQLCA.sqlcode THEN
#             LET l_date1 = null
#             LET l_date2 = null
#             LET l_rate  = null
#          END IF
#      ELSE                       #中長貸
#          SELECT nng101,nng102,nng09 INTO l_date1,l_date2,l_rate FROM nng_file
#             WHERE nng01=sr1.nnl04
#          IF SQLCA.sqlcode THEN
#             LET l_date1 = null
#             LET l_date2 = null
#             LET l_rate  = null
#          END IF
#      END IF
#      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nnk04
## Joan 020509 end----------------------------------------------------
##No.FUN-580010  -begin
##     PRINT COLUMN 01,sr1.nnl02 USING '##&',   #No.FUN-570177
##           COLUMN 7,sr1.nnl03,
##           COLUMN 11,sr1.nnl04,
##No.FUN-550057 --start--
##           COLUMN 28,l_date1,
##           COLUMN 38,cl_numfor(sr1.nnl11,18,t_azi04),
##           COLUMN 59,cl_numfor(sr1.nnl13,18,g_azi04),
##           COLUMN 80,cl_numfor(sr1.nnl15,18,t_azi04),
## Joan 020509---add列印欄位"利率"------------------------------------
##           cl_numfor(sr1.nnl15+sr1.nnl12,15,t_azi04)
##           COLUMN 101,cl_numfor(sr1.nnl15+sr1.nnl12,18,t_azi04),
##           COLUMN 126,l_rate,'%'
## Joan 020509--------------------------------------------------------
##     PRINT COLUMN 28,l_date2,' ',
##           COLUMN 38,cl_numfor(sr1.nnl12,18,t_azi04),
##           COLUMN 59,cl_numfor(sr1.nnl14,18,g_azi04),
##           COLUMN 80,cl_numfor(sr1.nnl17,18,g_azi04),
##           COLUMN 101,cl_numfor(sr1.nnl17+sr1.nnl14,18,g_azi04),
##           COLUMN 118,cl_numfor(sr1.nnl16,18,g_azi04)
##FUN-5A0180-begin
##     PRINTX name=D1
##            COLUMN g_c[36],sr1.nnl02 USING '##&',   #No.FUN-570177
##            COLUMN g_c[37],sr1.nnl03,
##            COLUMN g_c[38],sr1.nnl04,
##            COLUMN g_c[39],l_date1,
##            COLUMN g_c[40],cl_numfor(sr1.nnl11,40,t_azi04),
##            COLUMN g_c[41],cl_numfor(sr1.nnl13,41,g_azi04),
##            COLUMN g_c[42],cl_numfor(sr1.nnl15,42,t_azi04),
##            COLUMN g_c[43],cl_numfor(sr1.nnl15+sr1.nnl12,43,t_azi04),
##            COLUMN g_c[44],l_rate,'%'
##     PRINTX name=D2
##            COLUMN g_c[48],l_date2,' ',
##            COLUMN g_c[49],cl_numfor(sr1.nnl12,49,t_azi04),
##            COLUMN g_c[50],cl_numfor(sr1.nnl14,50,g_azi04),
##            COLUMN g_c[51],cl_numfor(sr1.nnl17,51,g_azi04),
##            COLUMN g_c[52],cl_numfor(sr1.nnl17+sr1.nnl14,52,g_azi04),
##            COLUMN g_c[53],cl_numfor(sr1.nnl16,53,g_azi04)
#     PRINTX name=D1
#            COLUMN g_c[36],sr1.nnl02 USING '###&',#FUN-590118
#            COLUMN g_c[37],sr1.nnl03,
#            COLUMN g_c[38],sr1.nnl04,
#            COLUMN g_c[39],l_date1,
#            COLUMN g_c[40],cl_numfor(sr1.nnl11,40,t_azi04),
#            COLUMN g_c[42],cl_numfor(sr1.nnl15,42,t_azi04),
#            COLUMN g_c[44],l_rate,'%'
#     PRINTX name=D2
#            COLUMN g_c[48],l_date2,' ',
#            COLUMN g_c[49],cl_numfor(sr1.nnl12,49,t_azi04),
#            COLUMN g_c[43],cl_numfor(sr1.nnl15+sr1.nnl12,43,t_azi04),
#            COLUMN g_c[53],cl_numfor(sr1.nnl16,53,g_azi04)
#     PRINTX name=D3
#            COLUMN g_c[41],cl_numfor(sr1.nnl13,41,g_azi04),
#            COLUMN g_c[51],cl_numfor(sr1.nnl17,51,g_azi04)
#     PRINTX name=D4
#            COLUMN g_c[50],cl_numfor(sr1.nnl14,50,g_azi04),
#            COLUMN g_c[52],cl_numfor(sr1.nnl17+sr1.nnl14,52,g_azi04)
##FUN-5A0180-end
##No.FUN-580010  -end
##No.FUN-550057 ---end--
# 
#   AFTER GROUP OF sr.nnk01
#{---modi by kitty
#      PRINT ''
#      PRINT COLUMN 32,g_x[27] CLIPPED,
#            cl_numfor(GROUP SUM(sr1.nnl11),15,t_azi05),' ', #NO.CHI-6A0004
#            cl_numfor(GROUP SUM(sr1.nnl13),15,g_azi05)
#
#      PRINT COLUMN 38,cl_numfor(GROUP SUM(sr1.nnl12),15,t_azi05),' ',   #NO.CHI-6A0004
#                      cl_numfor(GROUP SUM(sr1.nnl14),15,g_azi05),' ',
#                      cl_numfor(GROUP SUM(sr1.nnl16),9,g_azi05)
#      PRINT g_dash[1,g_len]
#      LET g_pageno=0
#      LET l_flag='Y'
#-----}
#      PRINT ''
##No.FUN-580010  --begin
##     PRINT COLUMN 28,g_x[27] CLIPPED,
##           COLUMN 38,cl_numfor(GROUP SUM(sr1.nnl11),18,t_azi04),
##           COLUMN 59,cl_numfor(GROUP SUM(sr1.nnl13),18,g_azi04),
##           COLUMN 80,cl_numfor(GROUP SUM(sr1.nnl15),18,t_azi04),
##           COLUMN 101,cl_numfor(GROUP SUM(sr1.nnl15+sr1.nnl12),18,t_azi04)
##     PRINT COLUMN 38,cl_numfor(GROUP SUM(sr1.nnl12),18,t_azi04),
##           COLUMN 59,cl_numfor(GROUP SUM(sr1.nnl14),18,g_azi04),
##           COLUMN 80,cl_numfor(GROUP SUM(sr1.nnl17),18,g_azi04),
##           COLUMN 101,cl_numfor(GROUP SUM(sr1.nnl17+sr1.nnl14),18,g_azi04),
##           COLUMN 118,cl_numfor(GROUP SUM(sr1.nnl16),18,g_azi04)
##     PRINT g_dash[1,g_len]
##FUN-5A0180-begin
##      PRINTX name=D3
##            COLUMN g_c[39],g_x[27] CLIPPED,
##            COLUMN g_c[40],cl_numfor(GROUP SUM(sr1.nnl11),40,t_azi04),
##            COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.nnl13),41,g_azi04),
##            COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.nnl15),42,t_azi04),
##            COLUMN g_c[43],cl_numfor(GROUP SUM(sr1.nnl15+sr1.nnl12),43,t_azi04)
##      PRINTX name=D4
##            COLUMN g_c[49],cl_numfor(GROUP SUM(sr1.nnl12),49,t_azi04),
##            COLUMN g_c[50],cl_numfor(GROUP SUM(sr1.nnl14),50,g_azi04),
##            COLUMN g_c[51],cl_numfor(GROUP SUM(sr1.nnl17),51,g_azi04),
##            COLUMN g_c[52],cl_numfor(GROUP SUM(sr1.nnl17+sr1.nnl14),52,g_azi04),
##            COLUMN g_c[53],cl_numfor(GROUP SUM(sr1.nnl16),53,g_azi04)
#      PRINTX name=D1
#            COLUMN g_c[39],g_x[27] CLIPPED,
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr1.nnl11),40,t_azi04),
#            COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.nnl15),42,t_azi04)
#      PRINTX name=D2
#            COLUMN g_c[49],cl_numfor(GROUP SUM(sr1.nnl12),49,t_azi04),
#            COLUMN g_c[43],cl_numfor(GROUP SUM(sr1.nnl15+sr1.nnl12),43,t_azi04),
#            COLUMN g_c[53],cl_numfor(GROUP SUM(sr1.nnl16),53,g_azi04)
#      PRINTX name=D3
#            COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.nnl13),41,g_azi04),
#            COLUMN g_c[51],cl_numfor(GROUP SUM(sr1.nnl17),51,g_azi04)
#      PRINTX name=D4
#            COLUMN g_c[50],cl_numfor(GROUP SUM(sr1.nnl14),50,g_azi04),
#            COLUMN g_c[52],cl_numfor(GROUP SUM(sr1.nnl17+sr1.nnl14),52,g_azi04)
##FUN-5A0180-end
#      PRINT g_dash
##No.FUN-580010  --end
#      LET g_pageno=0
#      LET l_flag='Y'
#         PRINT ''
### FUN-550114
#ON LAST ROW
#     LET l_last_sw = 'y'
#
#PAGE TRAILER
#     #IF l_flag ='Y' THEN
#     #   PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
#     #ELSE
#     #   PRINT g_dash[1,g_len]
#     #END IF
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
### END FUN-550114
# 
#END REPORT
##Patch....NO.TQC-610036 <> #
#No.FUN-710085--end

###GENGRE###START
FUNCTION anmg750_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg750")
        IF handler IS NOT NULL THEN
            START REPORT anmg750_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY nnk01,nnl02"   
            DECLARE anmg750_datacur1 CURSOR FROM l_sql
            FOREACH anmg750_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg750_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg750_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg750_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str------
    DEFINE l_nnk05_alg02 STRING
    DEFINE l_nnk07 STRING 
    DEFINE l_nnk06_nnk07 STRING
    DEFINE l_nnk18_nma02_2 STRING
    DEFINE l_nnk19_nml02 STRING
    DEFINE l_option      STRING
    DEFINE l_option1     STRING
    DEFINE l_nnl03       STRING
    DEFINE l_nnl15_nnl12       LIKE nnl_file.nnl15
    DEFINE l_nnl17_nnl14       LIKE nnl_file.nnl17
    DEFINE l_nnl11_sum         LIKE nnl_file.nnl11
    DEFINE l_nnl12_sum         LIKE nnl_file.nnl12
    DEFINE l_nnl13_sum         LIKE nnl_file.nnl13
    DEFINE l_nnl14_sum         LIKE nnl_file.nnl14
    DEFINE l_nnl15_sum         LIKE nnl_file.nnl15
    DEFINE l_nnl17_sum         LIKE nnl_file.nnl17
    DEFINE l_nnl15_nnl12_sum   LIKE nnl_file.nnl15
    DEFINE l_nnl17_nnl14_sum   LIKE nnl_file.nnl17
    DEFINE l_nnk09_fmt         STRING
    DEFINE l_nnk23_fmt         STRING
    DEFINE l_nnk17_fmt         STRING
    DEFINE l_nnl11_fmt         STRING
    DEFINE l_nnl12_fmt         STRING
    DEFINE l_nnl13_fmt         STRING
    DEFINE l_nnl14_fmt         STRING
    DEFINE l_nnl15_fmt         STRING
    DEFINE l_nnl16_fmt         STRING
    DEFINE l_nnl17_fmt         STRING
    DEFINE l_nnl11_sum_fmt     STRING
    DEFINE l_nnl12_sum_fmt     STRING
    DEFINE l_nnl13_sum_fmt     STRING
    DEFINE l_nnl14_sum_fmt     STRING
    DEFINE l_nnl15_sum_fmt     STRING
    DEFINE l_nnl16_sum_fmt     STRING
    DEFINE l_nnl17_sum_fmt     STRING
    DEFINE l_nnl15_nnl12_sum_fmt STRING
    DEFINE l_nnl17_nnl14_sum_fmt STRING
    DEFINE l_nnk10_aag02       STRING    #FUN-C50007 add
    #FUN-B40092------add------end------

    ORDER EXTERNAL BY sr1.nnk01,sr1.nnl02

    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.nnk01
            LET l_lineno = 0
            #FUN-B40092------add------str
            LET l_nnk09_fmt = cl_gr_numfmt('nnk_file','nnk09',sr1.azi07_t)
            PRINTX l_nnk09_fmt
            LET l_nnk23_fmt = cl_gr_numfmt('nnk_file','nnk23',g_azi07)
            PRINTX l_nnk23_fmt        
            LET l_nnk17_fmt = cl_gr_numfmt('nnk_file','nnk17',g_azi04)
            PRINTX l_nnk17_fmt
            LET l_nnl11_fmt = cl_gr_numfmt('nnl_file','nnl11',sr1.azi04_t)
            PRINTX l_nnl11_fmt
            LET l_nnl12_fmt = cl_gr_numfmt('nnl_file','nnl12',sr1.azi04_t)
            PRINTX l_nnl12_fmt
            LET l_nnl15_fmt = cl_gr_numfmt('nnl_file','nnl15',sr1.azi04_t)
            PRINTX l_nnl15_fmt
            LET l_nnl13_fmt = cl_gr_numfmt('nnl_file','nnl13',g_azi04)
            PRINTX l_nnl13_fmt
            LET l_nnl14_fmt = cl_gr_numfmt('nnl_file','nnl14',g_azi04)
            PRINTX l_nnl14_fmt
            LET l_nnl16_fmt = cl_gr_numfmt('nnl_file','nnl16',g_azi04)
            PRINTX l_nnl16_fmt
            LET l_nnl17_fmt = cl_gr_numfmt('nnl_file','nnl17',g_azi04)
            PRINTX l_nnl17_fmt
            LET l_nnl11_sum_fmt = cl_gr_numfmt('nnl_file','nnl11',sr1.azi04_t)
            PRINTX l_nnl11_sum_fmt
            LET l_nnl12_sum_fmt = cl_gr_numfmt('nnl_file','nnl12',sr1.azi04_t)
            PRINTX l_nnl12_sum_fmt
            LET l_nnl15_sum_fmt = cl_gr_numfmt('nnl_file','nnl15',sr1.azi04_t)
            PRINTX l_nnl15_sum_fmt
            LET l_nnl13_sum_fmt = cl_gr_numfmt('nnl_file','nnl13',g_azi04)
            PRINTX l_nnl13_sum_fmt
            LET l_nnl14_sum_fmt = cl_gr_numfmt('nnl_file','nnl14',g_azi04)
            PRINTX l_nnl14_sum_fmt
            LET l_nnl16_sum_fmt = cl_gr_numfmt('nnl_file','nnl16',g_azi04)
            PRINTX l_nnl16_sum_fmt
            LET l_nnl17_sum_fmt = cl_gr_numfmt('nnl_file','nnl17',g_azi04)
            PRINTX l_nnl17_sum_fmt
            LET l_nnl15_nnl12_sum_fmt = cl_gr_numfmt('nnl_file','nnl15',sr1.azi04_t)
            PRINTX l_nnl15_nnl12_sum_fmt
            LET l_nnl17_nnl14_sum_fmt = cl_gr_numfmt('nnl_file','nnl17',g_azi04)
            PRINTX l_nnl17_nnl14_sum_fmt
            

            LET l_nnk05_alg02 = sr1.nnk05,' ',sr1.alg02
            LET l_nnk07 = cl_gr_getmsg("gre-019",g_lang,sr1.nnk07)
            LET l_nnk06_nnk07 = sr1.nnk06,' ',sr1.nma02,' ',l_nnk07
            LET l_nnk18_nma02_2 = sr1.nnk18,' ',sr1.nma02_2
            LET l_nnk19_nml02 = sr1.nnk19,' ',sr1.nml02
            LET l_nnk10_aag02=sr1.nnk10,' ',sr1.aag02  #FUN-C50007 
           
            PRINTX l_nnk18_nma02_2
            PRINTX l_nnk06_nnk07
            PRINTX l_nnk05_alg02
            PRINTX l_nnk19_nml02
            PRINTX l_nnk10_aag02
            #FUN-B40092------add------end
        BEFORE GROUP OF sr1.nnl02

        
        ON EVERY ROW
            #FUN-B40092------add------str
            LET l_option = cl_gr_getmsg("gre-020",g_lang,0)
            LET l_option1=cl_gr_getmsg("gre-020",g_lang,1)
            IF NOT cl_null(sr1.nnl03) THEN
               IF sr1.nnl03 = '1' THEN
                  LET l_nnl03 = sr1.nnl03,'.',l_option
               ELSE 
                  LET l_nnl03 = sr1.nnl03,'.',l_option1
               END IF
            ELSE
               LET l_nnl03 = ' '
            END IF 
            LET l_nnl15_nnl12 = sr1.nnl15+sr1.nnl12
            LET l_nnl17_nnl14 = sr1.nnl17+sr1.nnl14
            LET l_lineno = l_lineno + 1
            PRINTX l_nnl15_nnl12
            PRINTX l_nnl17_nnl14
            PRINTX l_nnl03
            #FUN-B40092------add------end
            PRINTX l_lineno

            PRINTX sr1.*
        AFTER GROUP OF sr1.nnk01
            #FUN-B40092------add------str
            LET l_nnl11_sum = GROUP SUM(sr1.nnl11)
            LET l_nnl12_sum = GROUP SUM(sr1.nnl12)
            LET l_nnl13_sum = GROUP SUM(sr1.nnl13)
            LET l_nnl14_sum = GROUP SUM(sr1.nnl14)
            LET l_nnl15_sum = GROUP SUM(sr1.nnl15)
            LET l_nnl17_sum = GROUP SUM(sr1.nnl17)
            LET l_nnl15_nnl12 = sr1.nnl15+sr1.nnl12
            LET l_nnl17_nnl14 = sr1.nnl17+sr1.nnl14
            LET l_nnl15_nnl12_sum = GROUP SUM(sr1.nnl15_nnl12)
            LET l_nnl17_nnl14_sum = GROUP SUM(sr1.nnl17_nnl14)
            PRINTX l_nnl11_sum
            PRINTX l_nnl12_sum
            PRINTX l_nnl13_sum
            PRINTX l_nnl14_sum
            PRINTX l_nnl15_sum
            PRINTX l_nnl17_sum
            PRINTX l_nnl15_nnl12_sum
            PRINTX l_nnl17_nnl14_sum
            #FUN-B40092------add------end
        AFTER GROUP OF sr1.nnl02

        
        ON LAST ROW

END REPORT
###GENGRE###END
