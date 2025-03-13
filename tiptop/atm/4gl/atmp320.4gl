# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Descriptions...: 庫存調撥代送商作業
# Date & Author..: 06/03/29 by Sarah
# Modify.........: No.FUN-630027 06/03/29 By Sarah 新增"庫存調撥代送商作業"
# Modify.........: No.TQC-660050 06/06/13 By Sarah 寫入TempTable的SQL有誤
# Modify.........: No.FUN-660029 06/06/13 By Kim 寫入imm_file時,預設確認碼為N
# Modify.........: No.FUN-660104 06/06/19 By cl  Error Message 調整
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710033 07/01/19 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740039 07/04/10 By Ray 語言轉換錯誤
# Modify.........: No.TQC-740135 07/04/26 By arman   報表中頁次不對
# Modify.........: No.MOD-790139 07/09/27 By claire 庫存足夠沒有產調撥單也產生提示訊息
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                      不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫權限使用控管修改
# Modify.........: No.TQC-AC0033 10/12/03 By yinhy 倉庫開窗修改
# Modify.........: No.TQC-AB0363 10/12/16 By huangtao 還原過單 
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No.FUN-B70074 11/07/22 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-BB0084 11/12/06 By lixh1 增加數量欄位小數取位
# Modify.........: No.TQC-C20414 12/02/22 By yangxf 若於QBE 有指定日期時,需取日期範圍內的需求數
# Modify.........: No:MOD-C30477 12/03/12 By xumeimei atmp320產生的調撥單,(檢驗碼)imn29默认为N
# Modify.........: No:MOD-C30476 12/03/12 By xumeimei atmp320產生的調撥單,部門調整为抓員工基本資料檔的資料
# Modify.........: No:FUN-CB0087 12/12/21 By qiull 庫存單據理由碼改善
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-DB0053 13/11/21 By wangrr '儲位'欄位增加開窗

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                       # Print condition RECORD
                   wc        STRING,
                   from_w    LIKE imn_file.imn04,
                   from_l    LIKE imn_file.imn05,
                   trn       LIKE imm_file.imm01,
                   tr_date   LIKE type_file.dat,              #No.FUN-680120 DATE
                   more      LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)          # Input more condition(Y/N)
                  END RECORD
DEFINE g_t1	  LIKE oay_file.oayslip        #No.FUN-680120 VARCHAR(5)
DEFINE g_cnt      LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE l_ac       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_ima906   LIKE ima_file.ima906
DEFINE g_ima907   LIKE ima_file.ima907
DEFINE g_cnt1     LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_factor   LIKE img_file.img21
DEFINE g_img09    LIKE img_file.img09
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate    = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.from_w  = ARG_VAL(8)
   LET tm.from_l  = ARG_VAL(9)
   LET tm.trn     = ARG_VAL(10)
   LET tm.tr_date = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL p320_tm()                   # If background job sw is off
   ELSE
      CALL p320()                      # Read data and create out-file
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION p320_tm()
   DEFINE li_result     LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_sql,l_where STRING
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_imd02       LIKE imd_file.imd02
   DEFINE l_cmd         LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p320_w AT p_row,p_col WITH FORM "atm/42f/atmp320"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.tr_date= TODAY
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON oea1015,oea02,tuo03,tuo031
 
        #No.FUN-580031 --start--
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #No.FUN-580031 ---end---
 
        ON ACTION locale
           #CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT CONSTRUCT
 
        ON ACTION controlp  
           CASE 
              WHEN INFIELD(oea1015)   #代送商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc8'
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea1015
                 NEXT FIELD oea1015
              WHEN INFIELD(tuo03)     #代送商倉庫範圍
#No.FUN-AA0062  --Begin
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd1"
#                 LET g_qryparam.state  = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret #TQC-AC0033 add
#No.FUN-AA0062  --End
                 DISPLAY g_qryparam.multiret TO tuo03
                 NEXT FIELD tuo03
              #TQC-DB0053--add--str--
              WHEN INFIELD(tuo031)
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tuo031
                 NEXT FIELD tuo031
              #TQC-DB0053--add--end
           END CASE
           
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
     #No.TQC-740039 --begin
     IF g_action_choice = 'locale' THEN                                                                                            
        LET g_action_choice = ' '
        CALL cl_dynamic_locale()                                                                                                   
        CONTINUE WHILE                                                                                                             
     END IF
     #No.TQC-740039 --end
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p320_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
 
     LET tm.trn=''
   
     INPUT BY NAME tm.from_w,tm.from_l,tm.trn,tm.tr_date,tm.more WITHOUT DEFAULTS
        AFTER FIELD from_w
           IF tm.from_w IS NOT NULL THEN
              SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = tm.from_w
              IF STATUS THEN
              #  CALL cl_err('sel imd',STATUS,0) NEXT FIELD from_w   #No.FUN-660104
                 CALL cl_err3("sel","imd_file",tm.from_w,"",STATUS,"","",0)    #No.FUN-660104
              END IF
              #No.FUN-AA0062  --Begin
              IF NOT s_chk_ware(tm.from_w) THEN
                 NEXT FIELD from_w
              END IF 

              #No.FUN-AA0062  --End
              #FUN-D40103 -----Begin------
              IF NOT s_imechk(tm.from_w,tm.from_l) THEN
                 NEXT FIELD from_l
              END IF
           #FUN-D40103 -----End--------
           END IF

 
        AFTER FIELD from_l
           IF cl_null(tm.from_l) THEN 
              LET tm.from_l = ' ' 
           ELSE
              #FUN-D40103 -----Begin-------
            # LET g_cnt=0
            # SELECT COUNT(*) INTO g_cnt FROM ime_file 
            #  WHERE ime01 = tm.from_w AND ime02 = tm.from_l
            # IF g_cnt=0 THEN
            #    CALL cl_err('','mfg0095',1)
            #    NEXT FIELD from_l
            # END IF   
        #FUN-D40103 -----End---------
           END IF
           #FUN-D40103 -----Begin------
           IF NOT s_imechk(tm.from_w,tm.from_l) THEN
              NEXT FIELD from_l
           END IF
           #FUN-D40103 -----End--------
 
        AFTER FIELD trn
           IF tm.trn IS NOT NULL THEN
              CALL s_get_doc_no(tm.trn) RETURNING g_t1
              CALL s_check_no("aim",tm.trn,"","4","","","") RETURNING li_result,tm.trn
              IF (NOT li_result) THEN
                 CALL cl_err(g_t1,g_errno,0)
                 NEXT FIELD trn
              END IF
           END IF
        
        AFTER FIELD more
           IF tm.more NOT MATCHES '[YN]' THEN
              NEXT FIELD more
           END IF
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
           
        ON ACTION controlp  
           CASE 
              WHEN INFIELD(from_w)   #撥出倉庫
#No.FUN-AA0062  --Begin
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_imd"
#                 LET g_qryparam.arg1 = 'SW'        #倉庫類別
#                 CALL cl_create_qry() RETURNING tm.from_w
                 CALL q_imd_1(FALSE,TRUE,tm.from_w,"","","","") RETURNING tm.from_w
#No.FUN-AA0062  --End
                 DISPLAY tm.from_w TO from_w
                 NEXT FIELD from_w 
              #TQC-DB0053--add--str--
              WHEN INFIELD(from_l)
                 CALL q_ime_1(FALSE,TRUE,tm.from_l,tm.from_w,"",g_plant,"","","") RETURNING tm.from_l
                 DISPLAY tm.from_l TO from_l
                 NEXT FIELD from_l
              #TQC-DB0053--add--end
              WHEN INFIELD(trn)    #調撥單別
                 LET g_t1 = s_get_doc_no(tm.trn)
                #CALL q_smy(FALSE,FALSE,g_t1,'aim','4') RETURNING g_t1
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1
                 LET tm.trn = g_t1       
                 DISPLAY tm.trn TO trn
                 NEXT FIELD trn
           END CASE
           
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
           
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
        #No.TQC-740039 --begin
        ON ACTION locale
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
        #No.TQC-740039 --end
     END INPUT
     #No.TQC-740039 --begin
     IF g_action_choice = 'locale' THEN                                                                                            
        LET g_action_choice = ' '
        CALL cl_dynamic_locale()                                                                                                   
        CONTINUE WHILE                                                                                                             
     END IF
     #No.TQC-740039 --end
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW p320_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
           
     END IF
    
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='atmp320'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('atmp320','9031',1)
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_lang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",tm.from_w CLIPPED,",",
                       " '",tm.from_l CLIPPED,",",
                       " '",tm.trn CLIPPED,",",
                       " '",tm.tr_date CLIPPED,",",
                       " '",g_rep_user CLIPPED,"'",       #No.FUN-57026
                       " '",g_rep_clas CLIPPED,"'",       #No.FUN-57026
                       " '",g_template CLIPPED,"'"        #No.FUN-57026
           CALL cl_cmdat('atmp320',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW p320_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL p320()
     ERROR ""
   END WHILE
   CLOSE WINDOW p320_w
END FUNCTION
 
FUNCTION p320()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680120 VARCHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     STRING,          # RDSQL STATEMENT
          li_result LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cnt     LIKE type_file.num10,         #No.FUN-680120 INTEGER
          l_flag    LIKE type_file.num5,          #No.FUN-680120 SMALLINT       #printed or not? 
          sr        RECORD 
                     oea02     LIKE oea_file.oea02,   #TQC-C20414 ADD
                     oea03     LIKE oea_file.oea03,
                     oea04     LIKE oea_file.oea04, 
                     oea1015   LIKE oea_file.oea1015,
                     tuo03     LIKE tuo_file.tuo03,
                     tuo031    LIKE tuo_file.tuo031,
                     oeb04     LIKE oeb_file.oeb04, 
                     ima23     LIKE ima_file.ima23,
                     gen02     LIKE gen_file.gen02,
                     ima02     LIKE ima_file.ima02,
                     ima021    LIKE ima_file.ima021,
                     need_qty  LIKE shd_file.shd15,  #No.FUN-680120 DEC(15,3)
                     img_qty   LIKE shd_file.shd15,  #No.FUN-680120 DEC(15,3) 
                     trn_qty   LIKE shd_file.shd15   #No.FUN-680120 DEC(15,3) 
                    END RECORD
   DEFINE l_imni   RECORD LIKE imni_file.*    #FUN-B70074
   DEFINE l_imn01  LIKE imn_file.imn01        #FUN-B70074
   DEFINE l_imn02  LIKE imn_file.imn02        #FUN-B70074
   DEFINE l_imnplant LIKE imn_file.imnplant   #FUN-B70074
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CALL s_auto_assign_no("aim",tm.trn,tm.tr_date,"","","","","","")
        RETURNING li_result,tm.trn
   IF (NOT li_result) THEN
      CALL cl_err('','aoo-131',1)
      RETURN
   END IF
 
   CALL cl_outnam('atmp320') RETURNING l_name
 
   DROP TABLE atmp320_tmp
  #start TQC-660050 add
  #No.FUN-680120-BEGIN
   CREATE TEMP TABLE atmp320_tmp(
      oea02     LIKE oea_file.oea02,    #TQC-C20414 ADD
      oea03     LIKE oea_file.oea03,
      oea04     LIKE oea_file.oea04,
      oea1015   LIKE oea_file.oea1015,
      tuo03     LIKE tuo_file.tuo03,
      tuo031    LIKE tuo_file.tuo031,
      oeb04     LIKE ima_file.ima01,
      ima23     LIKE ima_file.ima23,
      gen02     LIKE nma_file.nma04,
      ima02     LIKE ima_file.ima02,
      ima021    LIKE ima_file.ima02,
      need_qty  LIKE aao_file.aao05,
      img_qty   LIKE aao_file.aao05,
      trn_qty   LIKE aao_file.aao05);
  #No.FUN-680120-END   
  #end TQC-660050 add # TQC-6A0079
 
   #抓訂單資料
  #start TQC-660050 modify
  #LET l_sql = "SELECT oea03,oea04,oea1015,tuo03,tuo031,oeb04,",
  #            "       '','','','',SUM((oeb12-oeb24)*oeb05_fac),0,0 ",
   LET l_sql = "SELECT DISTINCT oea02,oea03,oea04,oea1015,tuo03,tuo031,oeb04,",   #TQC-C20414 ADD oea02
               "       '','','','',0,0,0 ",
  #end TQC-660050 modify
               "  FROM oea_file,oeb_file,tuo_file ",
               " WHERE oea01=oeb01 ",
               "   AND oeaconf='Y' ",
               "   AND oeb12-oeb24 > 0 ",
               "   AND oea03=tuo01 ",
               "   AND oea04=tuo02 ",
               "   AND ",tm.wc,
               "   AND oeb04 NOT MATCHES 'MISC*' ",
  #            " GROUP BY oea03,oea04,oea1015,tuo03,tuo031,oeb04 ",   #TQC-660050 mark
               " ORDER BY oea02,oea03,oea04,oea1015,tuo03,tuo031,oeb04 "   #TQC-C20414 ADD oea02
   PREPARE p320_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE p320_c1 CURSOR FOR p320_p1
   LET g_success = 'Y'        #No.FUN-8A0086
   CALL s_showmsg_init()      #NO. FUN-710033
   FOREACH p320_c1 INTO sr.*
      #倉管員、品名、規格
     #NO. FUN-710033--BEGIN          
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
     #NO. FUN-710033--END
 
      SELECT ima23,ima02,ima021 INTO sr.ima23,sr.ima02,sr.ima021
        FROM ima_file WHERE ima01=sr.oeb04
      IF cl_null(sr.ima23) THEN  LET sr.ima23  = ' ' END IF
      IF cl_null(sr.ima02) THEN  LET sr.ima02  = ' ' END IF
      IF cl_null(sr.ima021) THEN LET sr.ima021 = ' ' END IF
 
      #倉管員所屬部門
      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.ima23
      IF SQLCA.sqlcode OR cl_null(sr.gen02) THEN LET sr.gen02=' ' END IF
      LET sr.gen02 = ' ',sr.gen02
 
     #start TQC-660050 add
      #計算發料數量
      SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO sr.need_qty
        FROM oea_file,oeb_file
       WHERE oea01=oeb01
         AND oeaconf='Y'
         AND oeb12-oeb24 > 0
         AND oea03=sr.oea03
         AND oea04=sr.oea04
         AND oea1015=sr.oea1015
         AND oeb04=sr.oeb04
         AND oea02 = sr.oea02                              #TQC-C20414 ADD
      IF (SQLCA.sqlcode) OR (sr.need_qty IS NULL) THEN
         LET sr.need_qty = 0
      END IF
     #end TQC-660050 add
 
      #計算代送商倉庫裡現有庫存量
      SELECT SUM(img10*img21) INTO sr.img_qty 
        FROM img_file
       WHERE img01=sr.oeb04
         AND img02=sr.tuo03
         AND img03=sr.tuo031
         AND img04=' '
      IF (SQLCA.sqlcode) OR (sr.img_qty IS NULL) THEN 
         LET sr.img_qty = 0 
      END IF
      #需調撥數量
      LET sr.trn_qty = sr.need_qty - sr.img_qty
      IF sr.trn_qty > 0 THEN
         INSERT INTO atmp320_tmp (oea02,oea03,oea04,oea1015,tuo03,tuo031,          #TQC-C20414 ADD oea02
                                  oeb04,ima23,gen02,ima02,ima021,
                                  need_qty,img_qty,trn_qty)
                          VALUES (sr.oea02,sr.oea03,sr.oea04,sr.oea1015,sr.tuo03,sr.tuo031,    #TQC-C20414 ADD sr.oea02
                                  sr.oeb04,sr.ima23,sr.gen02,sr.ima02,sr.ima021,
                                  sr.need_qty,sr.img_qty,sr.trn_qty)
         IF SQLCA.sqlcode THEN
         #  CALL cl_err(sr.oea03,SQLCA.sqlcode,0)   #No.FUN-660104
#           CALL cl_err3("ins","atmp320_tmp",sr.oea03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660104   # No.FUN-710033 
            CALL s_errmsg('','','',SQLCA.sqlcode,0)    # No.FUN-710033      
         END IF
      #MOD-790139-begin-add
      ELSE
           LET g_msg = sr.oeb04,"/",sr.need_qty,"/",sr.img_qty
           CALL s_errmsg('oeb04,oeb12,img10',g_msg,'',"asf-364",2)
      #MOD-790139-end-add
      END IF
   END FOREACH
    #NO. FUN-710033--BEGIN
      IF g_totsuccess="N" THEN
        LET g_success="N"
      END IF
    #NO. FUN-710033--END 
 
   LET l_sql="SELECT * FROM atmp320_tmp"
   PREPARE p320_p2 FROM l_sql
   DECLARE p320_c2 CURSOR FOR p320_p2
 
   #建立庫存調撥單TempTable
   DROP TABLE p320_imm_tmp
   DROP TABLE p320_imn_tmp
   SELECT * FROM imm_file WHERE 1=2 INTO TEMP p320_imm_tmp
   SELECT * FROM imn_file WHERE 1=2 INTO TEMP p320_imn_tmp
   LET g_success='Y'
   LET g_pageno=0
   START REPORT p320_rep TO l_name
 
   LET l_flag=FALSE
   INITIALIZE sr.* TO NULL
   FOREACH p320_c2 INTO sr.*
#NO. FUN-710033--BEGIN          
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
#NO. FUN-710033--END
 
      IF SQLCA.sqlcode THEN
#         CALL cl_err('p320_c2:',SQLCA.sqlcode,1)  #NO. FUN-710033
          CALL s_errmsg('','','',SQLCA.sqlcode,1)  #NO. FUN-710033 
          EXIT FOREACH
      END IF
      LET l_flag=TRUE
      OUTPUT TO REPORT p320_rep(sr.*)
   END FOREACH
 
    CALL s_showmsg()        #MOD-790139 
 
#NO. FUN-710033--BEGIN
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
    #NO. FUN-710033--END 
 
   FINISH REPORT p320_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
   IF (g_success='Y') AND (l_flag) THEN
      IF cl_confirm('asr-005') THEN    #是否產生"調撥單"?
         BEGIN WORK
 
         #將資料寫入調撥單Table
         INSERT INTO imm_file SELECT * FROM p320_imm_tmp
         IF SQLCA.sqlcode THEN
         #  CALL cl_err('ins imm',SQLCA.sqlcode,1)   #No.FUN-660104
            CALL cl_err3("ins","imm_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            LET g_success='N'
         END IF
         INSERT INTO imn_file SELECT * FROM p320_imn_tmp
         IF SQLCA.sqlcode THEN
         #  CALL cl_err('ins imn',SQLCA.sqlcode,1)   #No.FUN-660104
            CALL cl_err3("ins","imn_file","","",SQLCA.sqlcode,"","ins imn",1)   #No.FUN-660104    #NO. FUN-710033  #MOD-790139 cancel mark
         #  CALL s_errmsg('','','',SQLCA.sqlcode,1)  #NO. FUN-710033  #MOD-790139 mark      
            LET g_success='N'
         #FUN-B70074-add-str--
         ELSE
            IF NOT s_industry('std') THEN 
               LET l_sql ="SELECT imn01,imn02,imnplant FROM p320_imn_tmp"
               PREPARE p320_imn_tem_pre FROM l_sql
               DECLARE p320_imn_tem_cus CURSOR FOR p320_imn_tem_pre
               FOREACH p320_imn_tem_cus INTO l_imn01,l_imn02,l_imnplant               
                  INITIALIZE l_imni.* TO NULL
                  LET l_imni.imni01 = l_imn01
                  LET l_imni.imni02 = l_imn02
                  IF NOT s_ins_imni(l_imni.*,l_imnplant) THEN 
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF  
               END FOREACH
            END IF
         #FUN-B70074-add-end-- 
         END IF
         #CALL s_showmsg()        #No.FUN-710033  #MOD-790139 mark
         IF g_success='Y' THEN
            COMMIT WORK
            DISPLAY tm.trn TO trn
         ELSE
            ROLLBACK WORK
         END IF
 
         IF tm.trn IS NOT NULL AND g_success='Y' THEN
            LET g_msg="aimt324 '",tm.trn,"'"
            CALL cl_cmdrun(g_msg)
         END IF
      END IF
   END IF
END FUNCTION
 
REPORT p320_rep(sr)
   DEFINE li_result       LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_last_sw       LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
          l_cnt           LIKE type_file.num10,        #No.FUN-680120 INTEGER
          l_imm	          RECORD LIKE imm_file.*,
          l_imn	          RECORD LIKE imn_file.*,
          sr              RECORD 
                           oea02     LIKE oea_file.oea02,       #TQC-C20414 ADD
                           oea03     LIKE oea_file.oea03,
                           oea04     LIKE oea_file.oea04, 
                           oea1015   LIKE oea_file.oea1015,
                           tuo03     LIKE tuo_file.tuo03,
                           tuo031    LIKE tuo_file.tuo031,
                           oeb04     LIKE oeb_file.oeb04, 
                           ima23     LIKE ima_file.ima23,
                           gen02     LIKE gen_file.gen02,
                           ima02     LIKE ima_file.ima02,
                           ima021    LIKE ima_file.ima021,
                           need_qty  LIKE shd_file.shd15,       #No.FUN-680120 DEC(15,3) 
                           img_qty   LIKE shd_file.shd15,       #No.FUN-680120 DEC(15,3)  
                           trn_qty   LIKE shd_file.shd15        #No.FUN-680120 DEC(15,3)
                          END RECORD,
          l_gen03         LIKE gen_file.gen03,   #MOD-C30476 add  
          l_imn9301       LIKE imn_file.imn9301  #FUN-680006
   DEFINE l_store         STRING                                #FUN-CB0087
 
  OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
  ORDER BY sr.ima23,sr.oeb04
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<'  #,'/pageno'
      LET pageno_total=PAGENO USING '<<<','/pageno'   #NO.TQC-740135
      
      IF NOT cl_null(tm.trn) AND g_pageno=1 THEN
         INITIALIZE l_imm.* TO NULL
         DISPLAY BY NAME tm.trn
         LET l_imm.imm01=tm.trn         #調撥單號 
         LET l_imm.imm02=tm.tr_date     #調撥日期 
         LET l_imm.imm03='N'            #過帳否 
         LET l_imm.imm04='N'            #撥出確認否 
         LET l_imm.imm07=0              #已列印次數 
         LET l_imm.imm10='1'            #資料來源(1.一階段倉庫調撥) 
         LET l_imm.immconf='N'  #FUN-660029
         LET l_imm.immacti='Y'          #資料有效碼 
         LET l_imm.immuser=g_user       #資料所有者 
         LET l_imm.immgrup=g_grup       #資料所有部門 
         #LET l_imm.imm14=g_grup  #FUN-680006     #MOD-C30476 mark
         #MOD-C30476---add---str--
         SELECT gen03 INTO l_gen03 
           FROM gen_file
          WHERE gen01 = g_user 
         LET l_imm.imm14=l_gen03        #部門編號 
         #MOD-C30476---add---end--
         INITIALIZE l_imn.* TO NULL
         LET l_imn.imn02=0              #項次
         LET l_imm.immplant = g_plant   #FUN-980009
         LET l_imm.immlegal = g_legal   #FUN-980009
         #FUN-A60034--add---str---
         #FUN-A70104--add---str---
         LET l_imm.immmksg = g_smy.smyapr #是否簽核
         LET l_imm.imm15 = '0'            #簽核狀況
         LET l_imm.imm16 = g_user         #申請人
         #FUN-A70104--add---end---
         #FUN-A60034--add---end---
         INSERT INTO p320_imm_tmp VALUES(l_imm.*)
         IF STATUS THEN
         #  CALL cl_err('ins p320_imm_tmp:',STATUS,1)   #No.FUN-660104
            CALL cl_err3("ins","p320_imm_tmp","","",STATUS,"","",1)   #No.FUN-660104
            LET g_success='N'
         END IF
         LET l_imn9301=s_costcenter(l_imm.imm14) #FUN-680006
      END IF
      PRINT
 
   BEFORE GROUP OF sr.ima23
      SKIP TO TOP OF PAGE
      PRINT g_x[13] CLIPPED,tm.trn CLIPPED,
            COLUMN 29,g_x[14] CLIPPED,tm.from_w CLIPPED,
            COLUMN 55,g_x[15] CLIPPED,sr.tuo03
      PRINT COLUMN 29,g_x[18] CLIPPED,tm.from_l CLIPPED,
            COLUMN 55,g_x[19] CLIPPED,sr.tuo031
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'  
      
   ON EVERY ROW
      IF tm.trn IS NOT NULL THEN
         LET l_imn.imn01=tm.trn                    #調撥單號
         LET l_imn.imn02=l_imn.imn02+1             #項次
         LET l_imn.imn03=sr.oeb04                  #料號
         LET l_imn.imn04=tm.from_w                 #撥出倉庫別
         LET l_imn.imn05=tm.from_l                 #撥出儲位
         LET l_imn.imn06=' '                       #撥出批號
         LET l_imn.imn09=NULL                      #庫存單位
         SELECT ima25 INTO l_imn.imn09 FROM ima_file WHERE ima01=sr.oeb04
         LET l_imn.imn10=sr.trn_qty                #撥出數量(預計)
         LET l_imn.imn10=s_digqty(l_imn.imn10,l_imn.imn09)     #FUN-BB0084
         LET l_imn.imn15=sr.tuo03                  #撥入倉庫別
         LET l_imn.imn16=sr.tuo031                 #撥入儲位
         LET l_imn.imn17=' '                       #撥入批號
         LET l_imn.imn20=l_imn.imn09               #庫存單位
         LET l_imn.imn21=1                         #單位轉換率
         LET l_imn.imn22=l_imn.imn10*l_imn.imn21   #轉換後數量
         LET l_imn.imn22=s_digqty(l_imn.imn22,l_imn.imn20)     #FUN-BB0084
         LET l_imn.imn9301=l_imn9301               #FUN-680006
         LET l_imn.imn9302=l_imn9301               #FUN-680006
         LET l_imn.imn29='N'                       #檢驗碼 #MOD-C30477 add
         IF g_sma.sma115 = 'Y' THEN   #使用雙單位
            #抓單位使用方式,第二單位(母單位/參考單位)
            SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
             WHERE ima01=l_imn.imn03
            IF SQLCA.sqlcode =100 THEN                                                  
               IF l_imn.imn03 MATCHES 'MISC*' THEN
                  SELECT ima906,ima907 INTO g_ima906,g_ima907                               
                    FROM ima_file WHERE ima01='MISC'                                    
               END IF                                                                   
            END IF                                                                      
            #---------------------來源---------------------
            LET g_img09 = NULL
            SELECT img09 INTO g_img09 FROM img_file
             WHERE img01=l_imn.imn03  AND img02=l_imn.imn04
               AND img03=l_imn.imn05  AND img04=l_imn.imn06
            IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
            LET l_imn.imn30 = l_imn.imn09          #單位一 (來源)
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn30,g_img09)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn31 = g_factor             #單位一換算率(與庫存單位)(來源)
            LET l_imn.imn32 = l_imn.imn10          #單位一數量(來源)
            LET l_imn.imn33 = g_ima907             #單位二(來源)
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn33,g_img09)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn34 = g_factor             #單位二換算率(與庫存單位)(來源)
            LET l_imn.imn35 = 0                    #單位二數量(來源)
            IF g_ima906 = '3' THEN   #參考單位
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn33)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
               LET l_imn.imn35=l_imn.imn32*g_factor
               LET l_imn.imn35=s_digqty(l_imn.imn35,l_imn.imn33)    #FUN-BB0084
            END IF
            #---------------------目的---------------------
            LET g_img09 = NULL
            SELECT img09 INTO g_img09 FROM img_file
             WHERE img01=l_imn.imn03  AND img02=l_imn.imn15
               AND img03=l_imn.imn16  AND img04=l_imn.imn17
            IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
            LET l_imn.imn40 = l_imn.imn09          #單位一(目的)
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn40,g_img09)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn41 = g_factor             #單位一換算率(與庫存單位)(目的)
            LET l_imn.imn42 = l_imn.imn22          #單位一數量(目的)
            LET l_imn.imn43 = g_ima907             #單位二(目的)
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn43,g_img09)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn44 = g_factor             #單位二換算率(與庫存單位)(目的)
            LET l_imn.imn45 = 0                    #單位二數量(目的)
            IF g_ima906 = '3' THEN   #參考單位
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn40,l_imn.imn43)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
               LET l_imn.imn45=l_imn.imn42*g_factor
               LET l_imn.imn45=s_digqty(l_imn.imn45,l_imn.imn43)     #FUN-BB0084
            END IF
            #--------------轉換率-------------------
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn51=g_factor               #來源單位一與目的單位一的轉換率
            LET g_factor = 1
            CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
                 RETURNING g_cnt1,g_factor
            IF g_cnt1 = 1 THEN LET g_factor = 1 END IF
            LET l_imn.imn52=g_factor               #來源單位二與目的單位二的轉換率
         END IF
         LET l_imn.imnplant = g_plant  #FUN-980009
         LET l_imn.imnlegal = g_legal  #FUN-980009
         #FUN-CB0087---qiull---add---str---
         IF g_aza.aza115 = 'Y' THEN
            LET l_store = ''
            IF NOT cl_null(l_imn.imn04) THEN
               LET l_store = l_store,l_imn.imn04
            END IF
            IF NOT cl_null(l_imn.imn15) THEN
               IF NOT cl_null(l_store) THEN
                  LET l_store = l_store,"','",l_imn.imn15
               ELSE
                  LET l_store = l_store,l_imn.imn15
               END IF
            END IF
            CALL s_reason_code(l_imn.imn01,'','',l_imn.imn03,l_store,l_imm.imm16,l_imm.imm14) RETURNING l_imn.imn28
            IF cl_null(l_imn.imn28) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
            END IF
         END IF
         #FUN-CB0087---qiull---add---end---
         INSERT INTO p320_imn_tmp VALUES(l_imn.*)
         IF STATUS THEN 
         #  CALL cl_err('ins p320_imn_tmp:',STATUS,1)    #No.FUN-660104
            CALL cl_err3("ins","p320_inm_tmp","","",STATUS,"","",1)   #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
 
      PRINTX name=D1 COLUMN g_c[31],sr.ima23,sr.gen02,
                     COLUMN g_c[32],sr.oeb04,
                     COLUMN g_c[33],sr.ima02,
                     COLUMN g_c[34],sr.ima021,
                     COLUMN g_c[35],cl_numfor(sr.need_qty,35,3),
                     COLUMN g_c[36],cl_numfor(sr.img_qty,36,3)
         
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
 
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[9]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
          PRINT g_x[9]
          PRINT g_memo
      END IF
END REPORT

#TQC-AB0363
