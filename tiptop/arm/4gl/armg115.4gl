# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: armg115.4gl
# Descriptions...: RMA進口Invoice&Packing列印
# Date & Author..: 98/05/04 by Danny
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550064 05/05/27 By Trisy 單據編號加大
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/16 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-730023 07/03/13 By wujie 使用水晶報表打印
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30139 10/04/08 By Summer 公司名稱與地址等資訊改為抓取p_zo實際資料 
# Modify.........: No:MOD-A30169 10/04/08 By Summer 修正MOD-A30139,p_zo應抓目前語系之資料
# Modify.........: No.FUN-B40092 11/05/31 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN--BB0047追單 
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C40036 12/04/11 By xujing   GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/14 By wangrr GR程式優化

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)                # Input more condition
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_table         STRING                      #FUN-730023 add
DEFINE   g_sql           STRING                      #FUN-730023 add
DEFINE   g_str           STRING                      #FUN-730023 add
 
###GENGRE###START
TYPE sr1_t RECORD
    rma01 LIKE rma_file.rma01,
    rma03 LIKE rma_file.rma03,
    occ18 LIKE occ_file.occ18,
    rmb02 LIKE rmb_file.rmb02,
    rmb03 LIKE rmb_file.rmb03,
    rmb04 LIKE rmb_file.rmb04,
    rmb05 LIKE rmb_file.rmb05,
    rmb06 LIKE rmb_file.rmb06,
    rmb11 LIKE rmb_file.rmb11,
    rmb13 LIKE rmb_file.rmb13,
    rmb14 LIKE rmb_file.rmb14,
    rmb15 LIKE rmb_file.rmb15,
    rmb16 LIKE rmb_file.rmb16,
    rmb17 LIKE rmb_file.rmb17,
    l_item LIKE type_file.num5,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    l_today LIKE type_file.dat,
    l_plt LIKE type_file.num5,
    #FUN-C40036---add---str
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000
    #FUN-C40036---add---end
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
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc= ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  # CALL  cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036 MARK  
#No.FUN-730023--begin
   LET g_sql = "rma01.rma_file.rma01,",
               "rma03.rma_file.rma03,",
               "occ18.occ_file.occ18,",
               "rmb02.rmb_file.rmb02,",
               "rmb03.rmb_file.rmb03,",
               "rmb04.rmb_file.rmb04,",
               "rmb05.rmb_file.rmb05,",
               "rmb06.rmb_file.rmb06,",
               "rmb11.rmb_file.rmb11,",
               "rmb13.rmb_file.rmb13,",
               "rmb14.rmb_file.rmb14,",
               "rmb15.rmb_file.rmb15,",
               "rmb16.rmb_file.rmb16,",
               "rmb17.rmb_file.rmb17,",
               "l_item.type_file.num5,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "l_today.type_file.dat,",
               "l_plt.type_file.num5"
               #FUN-C40036---add---str
              ,",sign_type.type_file.chr1,",
               "sign_img.type_file.blob,",
               "sign_show.type_file.chr1,",
               "sign_str.type_file.chr1000"
               #FUN-C40036---add---end 

   LET l_table = cl_prt_temptable('armg115',g_sql) CLIPPED  
   IF l_table = -1 THEN 
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 mark
     #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM 
   END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   #FUN-C40036 add 4 ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 mark
     #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM
   END IF
#No.FUN-730023--end
#FUN-B40092------mod------str
  #No.FUN-690010-BEGIN
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036 ADD
#  CREATE TEMP TABLE armg115_temp(
#  rma03   LIKE rma_file.rma03,
#  rmb15   LIKE aba_file.aba18,
#  total   LIKE type_file.num5);
# #No.FUN-690010-END
#  create unique index armg115_01 on armr115_temp (rma03,rmb15);
#FUN-B40092------mod------end
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      CALL armg115_tm(0,0)             # Input print condition
   ELSE
      CALL armg115()                   # Read data and create out-file
   END IF
  CALL  cl_used(g_prog,g_time,2) RETURNING g_time
  CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION armg115_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 16
   END IF
   OPEN WINDOW armg115_w AT p_row,p_col
        WITH FORM "arm/42f/armg115"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                        #Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rma01,rma07,rma03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
               IF INFIELD(rma03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rma03
                  NEXT FIELD rma03
               END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW armg115_w 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW armg115_w 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg115'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg115','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armg115',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg115_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg115()
   ERROR ""
END WHILE
   CLOSE WINDOW armg115_w
END FUNCTION
 
FUNCTION armg115()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          l_zo12    LIKE zo_file.zo12,         #MOD-A30139 add
          sr        RECORD
                    rma01       LIKE rma_file.rma01,      #RMA單號
                    rma03       LIKE rma_file.rma03,      #退貨客戶編號
                   #rma04       LIKE rma_file.rma04,      #退貨客戶簡稱
                    occ18       LIKE occ_file.occ18,      #退貨客戶全名
                    rmb02       LIKE rmb_file.rmb02,      #RMA項次
                    rmb03       LIKE rmb_file.rmb03,      #產品編號
                    rmb04       LIKE rmb_file.rmb04,      #單位
                    rmb05       LIKE rmb_file.rmb05,      #規格
                    rmb06       LIKE rmb_file.rmb06,      #品名
                    rmb11       LIKE rmb_file.rmb11,      #數量
                    rmb13       LIKE rmb_file.rmb13,      #單價
                    rmb14       LIKE rmb_file.rmb14,      #金額
                    rmb15       LIKE rmb_file.rmb15,      #P/NO
                    rmb16       LIKE rmb_file.rmb16,      #C/NO
                    rmb17       LIKE rmb_file.rmb17       #Invoice#
                    END RECORD
#No.FUN-730023--begin
    DEFINE l_item,l_cno,l_plt   LIKE type_file.num5
    DEFINE l_rma03_t            LIKE rma_file.rma03
    DEFINE l_img_blob           LIKE type_file.blob   #FUN-C40036 add
  
     LOCATE l_img_blob    IN MEMORY                   #FUN-C40036 add
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'armg115'
#No.FUN-730023--end
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    #No.CHI-6A0004
          FROM azi_file WHERE azi01 = 'USD'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT rma01,rma03,occ18,rmb02,rmb03,rmb04,rmb05,rmb06,",
               "       rmb11,rmb13,rmb14,rmb15,rmb16,rmb17 ",
              #"  FROM rma_file,rmb_file,oay_file,OUTER occ_file ",       #FUN-C50008 mark--
              #" WHERE rma01 = rmb01 AND rma_file.rma03=occ_file.occ01 ", #FUN-C50008 mark--
               "  FROM rma_file LEFT OUTER JOIN occ_file ON rma03=occ01,rmb_file,oay_file ", #FUN-C50008 add LEFT OUTER
               " WHERE rma01 = rmb01 ",   #FUN-C50008 add
#              "   AND rma01[1,3]=oayslip",
               "   AND rma01 LIKE ltrim(rtrim(oayslip)) || '-%'",  #No.FUN-550064
               "   AND oaytype='70' ",
               "   AND rma09 !='6' AND rmavoid='Y' ",
               "   AND rmb11 <> 0 ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY rma03,rma01,rmb02 "
 
     PREPARE armg115_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE armg115_curs1 CURSOR FOR armg115_prepare1
#No.FUN-730023--begin
#     CALL cl_outnam('armg115') RETURNING l_name
 
#     START REPORT armg115_rep TO l_name
 
#     LET g_pageno = 0
#No.FUN-730023--end
     LET l_rma03_t = null
     FOREACH armg115_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF NOT cl_null(sr.rmb15) THEN
          LET g_cnt = 0
          SELECT count(*) INTO g_cnt FROM armg115_temp
              WHERE rma03=sr.rma03 AND rmb15 = sr.rmb15
          IF g_cnt=0 OR STATUS THEN
             INSERT INTO armg115_temp
             VALUES(sr.rma03,sr.rmb15,1)
          END IF
       END IF
#No.FUN-730023--begin
      IF cl_null(l_rma03_t) OR sr.rma03 <> l_rma03_t THEN
         LET  l_item=0 LET  l_plt=0 LET  l_cno=0
      END IF
#       OUTPUT TO REPORT armg115_rep(sr.*)
      EXECUTE insert_prep USING  sr.*,'',t_azi03,t_azi04,t_azi05,g_today,''
                                 ,"",l_img_blob,"N",""                   #FUN-C40036 add
#No.FUN-730023--end
     END FOREACH
#No.FUN-730023--begin
     LET g_sql = "UPDATE ds_report.",l_table," SET l_plt = ? WHERE rma01 =?"
     PREPARE upd_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('upd_prep:',status,1) 
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     LET l_rma03_t = null 
     FOREACH armg115_curs1 INTO sr.*
      IF cl_null(l_rma03_t) OR sr.rma03 <> l_rma03_t THEN
        SELECT SUM(total) INTO l_plt
          FROM armg115_temp WHERE rma03 = sr.rma03     
        EXECUTE upd_prep USING l_plt,sr.rma01
      END IF
     END FOREACH
#    FINISH REPORT armg115_rep

###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    #str MOD-A30139 mod
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rma01,rma07,rma03')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
    #end MOD-A30139 mod
     SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01=g_rlang   #MOD-A30139 add  #MOD-A30169 mod
###GENGRE###     LET g_str = tm.wc,";",l_zo12   #MOD-A30139 add zo12

###GENGRE###     CALL cl_prt_cs3('armg115','armr115',l_sql,g_str)   #FUN-710080 modify

    LET g_cr_table = l_table                   #主報表的temp table名稱     #FUN-C40036 add
    LET g_cr_apr_key_f = "rma01"       #報表主鍵欄位名稱，用"|"隔開        #FUN-C40036 add

    CALL armg115_grdata()    ###GENGRE###
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-730023--end
 
#       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085 #FUN-B40092 mark
END FUNCTION
 
#No.FUN-730023--begin
#REPORT armg115_rep(sr)
#  DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
#  DEFINE l_item,l_cno,l_plt  LIKE type_file.num5,    #No.FUN-690010 smallint,
#         l_rma03     LIKE rma_file.rma03,
#         sr          RECORD
#                     rma01   LIKE rma_file.rma01,      #RMA單號
#                     rma03   LIKE rma_file.rma03,      #退貨客戶編號
#                    #rma04   LIKE rma_file.rma04,      #退貨客戶簡稱
#                     occ18   LIKE occ_file.occ18,      #退貨客戶全名
#                     rmb02   LIKE rmb_file.rmb02,      #RMA項次
#                     rmb03   LIKE rmb_file.rmb03,      #產品編號
#                     rmb04   LIKE rmb_file.rmb04,      #單位
#                     rmb05   LIKE rmb_file.rmb05,      #規格
#                     rmb06   LIKE rmb_file.rmb06,      #品名
#                     rmb11   LIKE rmb_file.rmb11,      #數量
#                     rmb13   LIKE rmb_file.rmb13,      #單價
#                     rmb14   LIKE rmb_file.rmb14,      #金額
#                     rmb15   LIKE rmb_file.rmb15,      #P/NO
#                     rmb16   LIKE rmb_file.rmb16,      #C/NO
#                     rmb17   LIKE rmb_file.rmb17       #Invoice#
#                     END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# 
#  ORDER BY sr.rma03,sr.rma01,sr.rmb15
#
#  FORMAT
#   PAGE HEADER
#     SKIP 2 LINE
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[13]))/2)+1 ,g_x[13]
#     PRINT ' '
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[14] CLIPPED)-10),g_x[14] CLIPPED,' ',g_today
#     PRINT COLUMN 01,g_x[15] CLIPPED,' ',sr.occ18 CLIPPED
#     PRINT COLUMN 01,g_x[16] CLIPPED
#     PRINT g_dash
##No.FUN-580013 --start--
##    PRINT g_x[17],
##          COLUMN 47,g_x[18],      #No.FUN-550064
##          COLUMN 98,g_x[19] CLIPPED         #No.FUN-550064
##    PRINT g_dash1[1,g_len]
#     PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                      g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#     PRINTX name = H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#     PRINT g_dash1
##No.FUN-580013 --end--
#     LET l_last_sw = 'n'      #FUN-550122
#
#  {AFTER  GROUP OF sr.rmb15   #PLT/NO
#     IF sr.rmb15 IS NOT NULL THEN
#        LET l_plt=l_plt+1
#     END IF }
#
#   BEFORE GROUP OF sr.rma03   #退貨客戶
#      SKIP TO TOP OF PAGE
#      LET  l_item=0 LET  l_plt=0 LET  l_cno=0
#
#   AFTER GROUP OF sr.rma03   #退貨客戶
#      PRINT ' '
#      PRINT g_dash[1,g_len]
#      SELECT SUM(total) INTO l_plt
#             FROM armg115_temp WHERE rma03=sr.rma03
##No.FUN-580013 --start--
##     PRINT 'TOTAL',
##           COLUMN 19,l_item USING '##&',       #No.FUN-550064
##           COLUMN 24,l_plt USING '###',      #No.FUN-550064
##           COLUMN 60,GROUP SUM(sr.rmb11) USING '###,##&','  PCS',      #No.FUN-550064
##           COLUMN 81,'USD ',      #No.FUN-550064
##           COLUMN 91,cl_numfor(GROUP SUM(sr.rmb14),18,g_azi05)       #No.FUN-550064
##     PRINT ' '
##     PRINT ' '
##     PRINT g_x[21],COLUMN 47,g_x[22] CLIPPED      #No.FUN-550064
##     PRINT g_x[23],COLUMN 47,g_x[24] CLIPPED      #No.FUN-550064
##    #PRINT COLUMN 01,"NO COMMERCIAL VALUE FOR CUSTOM PURPOSE ONLY."
##    #PRINT COLUMN 01,"FREE OF CHARGE FOR REPAIRING RETURNED GOOODS ONLY."
#      PRINT COLUMN g_c[31],g_x[17] CLIPPED,
#            COLUMN g_c[32],l_item USING '###&',
#            COLUMN g_c[33],l_plt USING '###',
#            COLUMN g_c[37],GROUP SUM(sr.rmb11) USING '###,##&',
#            COLUMN g_c[38],'PCS',
#            COLUMN g_c[39],'USD',
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.rmb14),18,t_azi05)   #No.CHI-6A0004
#      PRINT ' '
#      PRINT ' '
#      PRINT COLUMN g_c[31],g_x[21] CLIPPED,g_x[22] CLIPPED
#      PRINT COLUMN g_c[31],g_x[23] CLIPPED,g_x[24] CLIPPED
##No.FUN-580013 --end--
#      LET l_rma03=sr.rma03
#
#   ON EVERY ROW
##No.FUN-580013 --start--
##     PRINT sr.rma01,
##           COLUMN 19,sr.rmb02 USING '##&',      #No.FUN-550064
##           COLUMN 24,sr.rmb15,      #No.FUN-550064
##           COLUMN 30,sr.rmb16,      #No.FUN-550064
##           COLUMN 39,sr.rmb03,      #No.FUN-550064
##           COLUMN 60,sr.rmb11 USING '###,##&',      #No.FUN-550064
##           COLUMN 69,sr.rmb04,      #No.FUN-550064
##           COLUMN 74,cl_numfor(sr.rmb13,15,g_azi03),      #No.FUN-550064
##           COLUMN 91,cl_numfor(sr.rmb14,18,g_azi04),      #No.FUN-550064
##           COLUMN 111,sr.rmb17      #No.FUN-550064
##     PRINT COLUMN 39,sr.rmb05 CLIPPED,' ',sr.rmb06 CLIPPED      #No.FUN-550064
#      PRINTX name = D1
#	    COLUMN g_c[31],sr.rma01,
#            COLUMN g_c[32],sr.rmb02 USING '###&',
#            COLUMN g_c[33],sr.rmb15,
#            COLUMN g_c[34],sr.rmb16,
#            COLUMN g_c[35],sr.rmb03,
#            COLUMN g_c[36],sr.rmb05 CLIPPED,
#            COLUMN g_c[37],sr.rmb11 USING '###,##&',
#            COLUMN g_c[38],sr.rmb04,
#            COLUMN g_c[39],cl_numfor(sr.rmb13,15,t_azi03),   #No.CHI-6A0004
#            COLUMN g_c[40],cl_numfor(sr.rmb14,18,t_azi04),   #No.CHI-6A0004
#            COLUMN g_c[41],sr.rmb17
#      PRINTX name = D2
#            COLUMN g_c[47],sr.rmb06 CLIPPED
##No.FUN-580013 --end--
#      LET l_item=l_item+1
### FUN-550122
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[25]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[25]
#             PRINT g_memo
#      END IF
### END FUN-550122
#
#
#END REPORT
##Patch....NO.TQC-610037 <> #  
#No.FUN-730023--end

###GENGRE###START
FUNCTION armg115_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY    #FUN-C40036 add
    CALL cl_gre_init_apr()           #FUN-C40036 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("armg115")
        IF handler IS NOT NULL THEN
            START REPORT armg115_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE armg115_datacur1 CURSOR FROM l_sql
            FOREACH armg115_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg115_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg115_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg115_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno    LIKE type_file.num5
    DEFINE l_p2        LIKE zo_file.zo12      #FUN-B40092  add
    DEFINE l_zo12      LIKE zo_file.zo12      #FUN-B40092  add
    DEFINE l_rmb14_sum LIKE rmb_file.rmb14    #FUN-B40092  add
    DEFINE l_rmb11_sum LIKE rmb_file.rmb11    #FUN-B40092  add
    DEFINE l_rmb02_sum LIKE rmb_file.rmb02    #FUN-B40092  add
    DEFINE l_rmb14_sum_fmt STRING             #FUN-B40092  add
    DEFINE l_rmb13_fmt     STRING             #FUN-B40092  add
    DEFINE l_rmb14_fmt     STRING             #FUN-B40092  add
    DEFINE l_total     LIKE type_file.num5    #FUN-B40092  add
    
    ORDER EXTERNAL BY sr1.rma03,sr1.rma01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rma03
            SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01=g_rlang  #FUN-B40092  add
            LET l_p2 = l_zo12        #FUN-B40092  add
            PRINTX l_p2              #FUN-B40092  add
            LET g_sql = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        "  WHERE rma03 = '",sr1.rma03 CLIPPED,"'"
            DECLARE armg115_cur1 CURSOR FROM g_sql
            FOREACH armg115_cur1 INTO l_total
            END FOREACH
            PRINTX l_total
            LET l_lineno = 0
        BEFORE GROUP OF sr1.rma01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rma03
            #FUN-B40092------add------str
            LET l_rmb14_sum_fmt = cl_gr_numfmt('rmb_file','rmb14',sr1.azi05)
            PRINTX l_rmb14_sum_fmt
            LET l_rmb14_fmt = cl_gr_numfmt('rmb_file','rmb14',sr1.azi04)
            PRINTX l_rmb14_fmt
            LET l_rmb13_fmt = cl_gr_numfmt('rmb_file','rmb13',sr1.azi03)
            PRINTX l_rmb13_fmt
            LET l_rmb11_sum = GROUP SUM(sr1.rmb11)
            LET l_rmb14_sum = GROUP SUM(sr1.rmb14)
            PRINTX l_rmb11_sum
            PRINTX l_rmb14_sum
            #FUN-B40092------add------end
        AFTER GROUP OF sr1.rma01

        
        ON LAST ROW

END REPORT
###GENGRE###END
