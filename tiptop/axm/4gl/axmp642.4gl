# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp642.4gl
# Descriptions...: 應付佣金產生作業
# Date & Author..: 06/04/04 By Sarah
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-680029 06/09/29 By Rayven 新增多帳套功能
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710046 07/01/22 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-730057 07/03/28 By hongmei 會計科目加帳套
# Modify.........: No.TQC-740036 07/04/09 By Ray '語言'轉換功能錯誤
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier apb34給default值'N'
# Modify.........: No.CHI-810016 08/02/19 By Judy 寫入多帳期資料(apc_file)
# Modify.........: No.MOD-830039 08/03/06 By claire apz取值調整
# Modify.........: No.MOD-970077 09/07/16 By Smapmin 修改幣別位數取位
# Modify.........: No.MOD-970172 09/07/23 By Sabrina INSERT INTO apb_file時，要預設apb29='1'，
#                                                    否則在aapt120修改單身時，會造成單身金額(apa57)異常
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting t110_stock_act加傳參數
# Modify.........: No.FUN-9C0001 09/12/25 By lutingting t110_g_gl加傳參數 
# Modify.........: No:FUN-A60024 10/06/12 By wujie   新增apa79，预设值为0
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.TQC-AC0346 10/12/23 By chenmoyan 修改差異金額apa33/apa33f
# Modify.........: No.TQC-B10015 11/01/05 By lilingyu 賬款確認時檢測到多帳期資料和賬款金額不符的情況
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BB0086 11/12/28 By tanxc 增加數量欄位小數取位 
# Modify.........: No:TQC-D50057 13/07/18 By yangtt 增加出貨單號開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE bdate           LIKE type_file.dat,     #日期範圍(起)  #No.FUN-680137 DATE
       edate           LIKE type_file.dat,     #日期範圍(迄)  #No.FUN-680137 DATE
       oft17           LIKE oft_file.oft17,    #產生對象(1.代理商 2.代送商)
       trtype          LIKE aba_file.aba00,    #No.FUN-550030  #No.FUN-680137 VARCHAR(5)
       g_buf           LIKE type_file.chr8,          #No.FUN-680137 VARCHAR(8)
       l_flag          LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
       begin_no,end_no LIKE oea_file.oea01,   #No.FUN-560002  #No.FUN-680137 VARCHAR(16)
       g_apa01         LIKE apa_file.apa01,   #NO.MOD-5B0178
       g_apa02         LIKE apa_file.apa02,
       g_apa21         LIKE apa_file.apa21,
       g_apa22         LIKE apa_file.apa22,
       g_apa36         LIKE apa_file.apa36,
       g_oft           RECORD LIKE oft_file.*,
       g_oft_t         RECORD LIKE oft_file.*,
       g_apa           RECORD LIKE apa_file.*,
       g_apb           RECORD LIKE apb_file.*,
       #g_azi           RECORD LIKE azi_file.*,   #MOD-970077
       p_apz           RECORD LIKE apz_file.*, #MOD-830039
       g_wc,g_sql      STRING,  #No.FUN-580092 HCN 
       g_change_lang   LIKE type_file.chr1     #是否有做語言切換 No.FUN-570112  #No.FUN-680137 VARCHAR(1)
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_bookno1       LIKE aza_file.aza81          #No.FUN-730057
DEFINE g_bookno2       LIKE aza_file.aza82          #No.FUN-730057
DEFINE g_flag          LIKE type_file.chr1          #No.FUN-730057
 
 
MAIN
   DEFINE ls_date       STRING  #->No.FUN-570112 
 
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc           = ARG_VAL(1)       #QBE條件
   LET bdate          = ARG_VAL(2)       #日期範圍(起)
   LET edate          = ARG_VAL(3)       #日期範圍(迄)
   LET oft17          = ARG_VAL(4)       #產生對象(1.代理商 2.代送商)
   LET trtype         = ARG_VAL(5)       #帳款單別
   LET ls_date        = ARG_VAL(6)
   LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
   LET g_apa.apa21    = ARG_VAL(7)       #帳款人員
   LET g_apa.apa22    = ARG_VAL(8)       #帳款部門
   LET g_apa.apa36    = ARG_VAL(9)       #帳款類別
   LET g_bgjob        = ARG_VAL(10)      #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p642()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p642_process()
            CALL s_showmsg()                  #No.FUN-710046 
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
               CLOSE WINDOW p642_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p642_process()
         CALL s_showmsg()                  #No.FUN-710046 
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
 
FUNCTION p642()
   DEFINE li_result LIKE type_file.num5         #No.FUN-560002     #No.FUN-680137 SMALLINT
   DEFINE lc_cmd    LIKE type_file.chr1000     #No.FUN-570112      #No.FUN-680137 VARCHAR(500)
 
   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p642_w WITH FORM "axm/42f/axmp642"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_init()
      
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON oft01,oft04,oft03,oft18,oft19
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      
         ON ACTION locale
           #LET g_action_choice='locale'    #->No.FUN-570112
            LET g_change_lang = TRUE        #->No.FUN-570112
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(oft03)   #對象編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF oft17 = "2" THEN
                     LET g_qryparam.form = "q_pmc8"   #代送商
                  ELSE
                     LET g_qryparam.form = "q_pmc4"   #代理商
                     LET g_qryparam.arg1 = '4'
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft03
                  NEXT FIELD oft03
               WHEN INFIELD(oft04)   #業務員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft04
                  NEXT FIELD oft04
   #TQC-D50057--add--start
               WHEN INFIELD(oft01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oft01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft01
                  NEXT FIELD oft01
   #TQC-D50057--add--end
            END CASE
     
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
#        EXIT WHILE      #No.TQC-740036
         CONTINUE WHILE      #No.TQC-740036
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p642_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      INITIALIZE g_oft.* TO NULL
      INITIALIZE g_apa.* TO NULL
      INITIALIZE g_apb.* TO NULL
 
      #預設日期範圍為本月第一天~本月最後一天
      LET bdate = MDY(MONTH(g_today),1,YEAR(g_today))
      IF MONTH(bdate)=12 THEN
         LET edate = MDY(1,1,YEAR(bdate)+1)-1
      ELSE
         LET edate = MDY(MONTH(bdate)+1,1,YEAR(bdate))-1
      END IF
      DISPLAY BY NAME bdate,edate
 
      LET g_apa.apa02 = g_today
      LET g_apa.apa21 = g_user
      LET g_apa.apa22 = g_grup
      LET begin_no = NULL
      LET end_no   = NULL
      LET g_apa01  = NULL
      #No.FUN-730057  --Begin                                                                                                         
      CALL s_get_bookno(YEAR(g_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
        IF g_flag =  '1' THEN  #抓不到帳別                                                                                              
           CALL cl_err(g_apa.apa02,'aoo-081',1)                                                                         
        END IF                                                                                                                          
      #No.FUN-730057  --End
      INPUT BY NAME bdate,edate,oft17,
                    trtype,g_apa.apa02,g_apa.apa21,g_apa.apa22,g_apa.apa36,
                    g_bgjob   #NO.FUN-570112
                    WITHOUT DEFAULTS 
    
         ON CHANGE bdate
            IF MONTH(bdate)=12 THEN
               LET edate = MDY(1,1,YEAR(bdate)+1)-1
            ELSE
               LET edate = MDY(MONTH(bdate)+1,1,YEAR(bdate))-1
            END IF
            DISPLAY BY NAME edate
 
         AFTER FIELD trtype
            IF NOT cl_null(trtype) THEN
               CALL s_check_no("AAP",trtype,"","12","","","")
                    RETURNING li_result,trtype
               IF (NOT li_result) THEN
         	  NEXT FIELD trtype
               END IF
               LET g_apa.apamksg = g_apy.apyapr   #是否簽核
            END IF
      
         AFTER FIELD apa21         #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa21) THEN 
               CALL p642_apa21('')
               IF NOT cl_null(g_errno) THEN            #抱歉, 有問題
                  CALL cl_err(g_apa.apa21,g_errno,0)
                  NEXT FIELD apa21
               END IF
            END IF
            IF cl_null(g_apa.apa21) THEN 
               LET g_apa.apa21 = ' ' 
            END IF 
      
         AFTER FIELD apa22      #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa22) THEN
               CALL p642_apa22('')
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa22,g_errno,0)
                  NEXT FIELD apa22
               END IF
            END IF
            IF cl_null(g_apa.apa22) THEN 
               LET g_apa.apa22 = ' '
            END IF
      
         AFTER FIELD apa36
            IF NOT cl_null(g_apa.apa36) THEN
               CALL p642_apa36('')
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa36,g_errno,0)
                  NEXT FIELD apa36
               END IF
            END IF
            IF cl_null(g_apa.apa36) THEN
               LET g_apa.apa36 = ' '
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG 
            CALL cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(trtype)   #帳款單別
                  CALL q_apy(FALSE,FALSE,trtype,'12','AAP') RETURNING trtype
                  DISPLAY BY NAME trtype
               WHEN INFIELD(apa21)    #帳款人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_apa.apa21
                  CALL cl_create_qry() RETURNING g_apa.apa21
                  DISPLAY BY NAME g_apa.apa21
               WHEN INFIELD(apa22)    #帳款部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_apa.apa22
                  CALL cl_create_qry() RETURNING g_apa.apa22
                  DISPLAY BY NAME g_apa.apa22
               WHEN INFIELD(apa36)    #帳款類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_apr"
                  LET g_qryparam.default1 = g_apa.apa36
                  CALL cl_create_qry() RETURNING g_apa.apa36
                  DISPLAY BY NAME g_apa.apa36
            END CASE
      
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
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
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p642_w
         IF g_aza.aza53='Y' THEN
            DATABASE g_dbs 
 #           CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
             CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
         END IF
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp642'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axmp642','9031',1)   
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",bdate CLIPPED,"'",
                         " '",edate CLIPPED,"'",
                         " '",oft17 CLIPPED,"'",
                         " '",trtype CLIPPED,"'",
                         " '",g_apa.apa02 CLIPPED,"'",
                         " '",g_apa.apa21 CLIPPED,"'",
                         " '",g_apa.apa22 CLIPPED,"'",
                         " '",g_apa.apa36 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axmp642',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p642_w
         IF g_aza.aza53='Y' THEN
            DATABASE g_dbs 
#            CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
            CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
         END IF
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
   EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p642_process()
 
#   SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_aza.aza17   #本國幣別   #No.CHI-6A0004
 
   LET g_apa02 = g_apa.apa02
   LET g_apa21 = g_apa.apa21
   LET g_apa22 = g_apa.apa22
   LET g_apa36 = g_apa.apa36
    
   #No.B368 010423 by plum add check帳款日和佣金年度/月份不可有不同年月的情形發生
   IF NOT cl_null(g_apa02) THEN
      LET l_flag='N'
      CALL p642_chkdate()
      IF l_flag ='X' THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      IF l_flag='Y' THEN
         LET g_success = 'N'
         CALL cl_err('','axr-065',1)
         RETURN
      END IF
   END IF
   #No.B368...end
 
   #MOD-830039-begin-add
   #讀取應付帳款系統參數檔
   LET g_sql = "SELECT * ",
               " FROM apz_file ",
               " WHERE apz00= '0' "
   PREPARE apz_p1 FROM g_sql 
   IF STATUS THEN CALL cl_err('apz_p1',STATUS,1) END IF
   DECLARE apz_c1 CURSOR FOR apz_p1
   OPEN apz_c1
   FETCH apz_c1 INTO p_apz.* 
   CLOSE apz_c1
   #MOD-830039-end-add
 
   LET g_sql = "SELECT * FROM oft_file ",
               " WHERE oft02 BETWEEN '",bdate,"' AND '",edate,"' ",
               "   AND ",g_wc CLIPPED
  #DISPLAY 'g_sql:',g_sql                #CHI-A70049 mark
 
   PREPARE p642_prepare FROM g_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   DECLARE p642_cs CURSOR WITH HOLD FOR p642_prepare
 
   LET g_apa.apa01 = NULL
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOREACH p642_cs INTO g_oft.*
      IF STATUS THEN
#        CALL cl_err('p642_cs FOREACH:',SQLCA.sqlcode,1)    #No.FUN-710046                                                                
         CALL s_errmsg('','',"p642_cs FOREACH:",SQLCA.sqlcode,1)    #No.FUN-710046
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#No.FUN-710046 ---------Begin-----------------------                                                                                
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
#No.FUN-710046 ----------End-----------------------
      IF cl_null(g_oft.oft21) THEN
         #應付帳款單頭檔
         LET g_apa.apa05 = g_oft.oft03    #送貨廠商編號
         LET g_apa.apa06 = g_oft.oft03    #付款廠商編號
         LET g_apa.apa13 = g_oft.oft14    #幣別
         LET g_apa.apa14 = 1              #匯率
         #取得該幣別(apa13)在該日期(apa02)的銀行賣出匯率
         CALL s_curr3(g_apa.apa13,g_apa.apa02,g_sma.sma904) RETURNING g_apa.apa14
         IF cl_null(g_apa.apa14) THEN
            LET g_apa.apa14 = 1
         END IF
         #稅別
         SELECT pmc47 INTO g_apa.apa15 FROM pmc_file WHERE pmc01=g_oft.oft03
         IF SQLCA.sqlcode THEN
            LET g_apa.apa15 = ''
         ELSE
            #稅率
            SELECT gec04 INTO g_apa.apa16 FROM gec_file WHERE gec01=g_apa.apa15
            IF SQLCA.sqlcode THEN
               LET g_apa.apa16 = 0
            END IF
         END IF 
 
         #應付帳款單身檔
         LET g_apb.apb12 = g_oft.oft07                  #料號
         LET g_apb.apb27 = g_oft.oft05,' ',g_oft.oft02,' ',g_oft.oft01   #品名
         SELECT ogb05 INTO g_apb.apb28 FROM ogb_file    #單位
          WHERE ogb01 = g_oft.oft01 AND ogb03 = g_oft.oft06
         IF SQLCA.sqlcode THEN 
            LET g_apb.apb28 = ''
         END IF
         LET g_apb.apb09 = g_oft.oft08                  #數量
         LET g_apb.apb09 = s_digqty(g_apb.apb09,g_apb.apb28)   #No.FUN-BB0086
         LET g_apb.apb24 = g_oft.oft16                  #原幣金額
         LET g_apb.apb23 = g_apb.apb24 / g_apb.apb09    #原幣單價
         LET g_apb.apb10 = g_apb.apb24 * g_apa.apa14    #本幣金額
         LET g_apb.apb08 = g_apb.apb10 / g_apb.apb09    #本幣單價
 
         LET g_chr = ' '
         SELECT apa41 INTO g_chr FROM apa_file   #確認碼
          WHERE apa00 = '12'
            AND apa05 = g_oft.oft03 AND apa06 = g_oft.oft03
            AND apa21 = g_apa.apa21 
            AND  YEAR(apa02) = g_oft.oft18 
            AND MONTH(apa02) = g_oft.oft19
            AND apa13 = g_oft.oft14
         IF g_chr = 'Y' THEN 
            CONTINUE FOREACH 
         END IF
 
        #DISPLAY g_apb.apb21,' ',g_apb.apb22 AT 1,1        #CHI-A70049 mark
 
         LET g_apa.apa08 = ''
         LET g_apa.apa09 = ''
 
         SELECT pmc17 INTO g_apa.apa11 FROM pmc_file WHERE pmc01=g_apa.apa06 
         IF g_apa.apa11 IS NULL THEN      #付款方式
            LET g_apa.apa11 = ''
         END IF
 
         #-----MOD-970077---------
         #IF g_azi.azi03 IS NULL THEN
         #   LET g_azi.azi03 = 0 
         #END IF
         #
         #IF g_azi.azi04 IS NULL THEN 
         #   LET g_azi.azi04 = 0 
         #END IF
         #-----END MOD-970077-----
 
         IF g_oft.oft03 != g_oft_t.oft03 OR      #代理商/代送商
            g_oft.oft04 != g_oft_t.oft04 OR      #業務員編號
            g_oft.oft18 != g_oft_t.oft18 OR      #佣金年度
            g_oft.oft19 != g_oft_t.oft19 OR      #佣金月份
            g_oft.oft14 != g_oft_t.oft14 THEN    #佣金幣別
 
            IF g_apa.apa01 IS NOT NULL THEN
               CALL p642_upd_apa57()
            END IF
 
            LET g_apa.apa72 = g_apa.apa14        #重估匯率
            LET g_apa.apa73 = g_apa.apa34 - g_apa.apa35    #本幣未沖金額
 
            CALL p642_ins_apa()                  # Insert Head
 
            IF g_success = 'N' THEN 
               EXIT FOREACH
            END IF
         END IF
 
         LET g_oft_t.* = g_oft.*   #備份舊值
 
         CALL p642_ins_apb()
 
         #將應付單號回寫到佣金維護作業
         UPDATE oft_file SET oft21 = g_apa.apa01
                       WHERE oft01 = g_oft.oft01 AND oft02 = g_oft.oft02
                         AND oft03 = g_oft.oft03 AND oft04 = g_oft.oft04 
         IF STATUS THEN
#           CALL cl_err('upd_oft:',SQLCA.sqlcode,1)    #No.FUN-660167
#           CALL cl_err3("upd","oft_file","","",SQLCA.sqlcode,"","upd_oft",1)   #No.FUN-660167  #No.FUN-710046
            LET g_showmsg=g_oft.oft01,"/",g_oft.oft02,"/",g_oft.oft03,"/",g_oft.oft04            #No.FUN-710046
            CALL s_errmsg("oft01,oft02,oft03,oft04",g_showmsg,"UPD oft_file",SQLCA.sqlcode,1)    #No.FUN-710046   
            LET g_success = 'N'
         END IF
 
         IF g_success = 'N' THEN 
#           EXIT FOREACH        #No.FUN-710046
            CONTINUE FOREACH    #No.FUN-710046
         END IF
      END IF
 
   END FOREACH
#No.FUN-710046  ----------------------Begin-----------------                                                                        
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
#No.FUN-710046  ----------------------End-------------------
   CALL p642_upd_apa57()
 
   IF begin_no IS NOT NULL THEN
      DISPLAY begin_no TO start_no
      DISPLAY end_no TO end_no
   ELSE
#     CALL cl_err('','aap-129',1)   #無合乎條件資料!    #No.FUN-710046
      CALL s_errmsg('','','',"aap-129",1)               #No.FUN-710046
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION p642_upd_apa31()
   DEFINE amt1,amt2,amt3,amt4    LIKE type_file.num20_6  #FUN-4B0079  #No.FUN-680137 DECIMAL(20,6)
 
   SELECT SUM(apk08),SUM(apk07) INTO amt1,amt2
     FROM apk_file
    WHERE apk01 = g_apa.apa01
      AND apk171 = '23'
 
   IF amt1 IS NULL THEN
      LET amt1 = 0
      LET amt2 = 0
   END IF
 
   SELECT SUM(apk08),SUM(apk07) INTO amt3,amt4
     FROM apk_file
    WHERE apk01 = g_apa.apa01
      AND apk171 <> '23'
 
   IF amt3 IS NULL THEN 
      LET amt3 = 0
      LET amt4 = 0
   END IF
 
   LET g_apa.apa31f = amt3 - amt1
   LET g_apa.apa31  = amt3 - amt1
   LET g_apa.apa32f = amt4 - amt2
   LET g_apa.apa32  = amt4 - amt2
 
   SELECT SUM(apk08f),SUM(apk07f) INTO g_apa.apa31f,g_apa.apa32f
     FROM apk_file
    WHERE apk01 = g_apa.apa01 
   IF cl_null(g_apa.apa31f) THEN
      LET g_apa.apa31f = 0
   END IF
   IF cl_null(g_apa.apa32f) THEN
      LET g_apa.apa32f = 0
   END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_apa.apa13
 
   LET g_apa.apa31f= cl_digcut(g_apa.apa31f,t_azi04)
   LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi04)
 
   LET g_apa.apa34f=g_apa.apa31f+g_apa.apa32f
   LET g_apa.apa34 =g_apa.apa31 +g_apa.apa32
   LET g_apa.apa73 =g_apa.apa34
 
   UPDATE apa_file SET apa31f = g_apa.apa31f,
                       apa31  = g_apa.apa31,
                       apa32f = g_apa.apa32f,
                       apa32  = g_apa.apa32,
                       apa34f = g_apa.apa34f,
                       apa34  = g_apa.apa34,
                       apa73  = g_apa.apa73                         #A059
    WHERE apa01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err('update apa_file',STATUS,0)
   END IF

#TQC-B10015 --begin--
   UPDATE apc_file SET apc06 = g_apa.apa14,
                       apc07 = g_apa.apa72,
                       apc08 = g_apa.apa34f,
                       apc09 = g_apa.apa34,
                       apc10 = g_apa.apa35f,
                       apc11 = g_apa.apa35,
                       apc12 = g_apa.apa08,
                       apc13 = g_apa.apa73,
                       apc14 = g_apa.apa65f,
                       apc15 = g_apa.apa65,
                       apc16 = g_apa.apa20
   WHERE apc01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err('update apc_file',STATUS,0)
   END IF                          
#TQC-B10015 --end-- 
END FUNCTION
 
FUNCTION p642_upd_apa57()
   DEFINE l_trtype  LIKE aba_file.aba00           #No.FUN-680137 VARCHAR(5)
   DEFINE l_apydmy3 LIKE apy_file.apydmy3
 
   #原幣單身合計金額、本幣單身合計金額
   SELECT SUM(apb24),SUM(apb10) INTO g_apa.apa57f,g_apa.apa57
     FROM apb_file
    WHERE apb01 = g_apa.apa01
   IF g_apa.apa57f IS NULL THEN
      LET g_apa.apa57f = 0
   END IF
   IF g_apa.apa57 IS NULL THEN
      LET g_apa.apa57 = 0
   END IF
 
  #LET g_apa.apa33f = g_apa.apa57f   #原幣差異 #TQC-AC0346 mark 
  #LET g_apa.apa33  = g_apa.apa57    #本幣差異 #TQC-AC0346 mark
   LET g_apa.apa33f = g_apa.apa31f - g_apa.apa57f #TQC-AC0346
   LET g_apa.apa33  = g_apa.apa31  - g_apa.apa57  #TQC-AC0346
 
   IF g_apa.apa31f <> g_apa.apa57f + g_apa.apa60f OR
      g_apa.apa31  <> g_apa.apa57 + g_apa.apa60   OR g_apa.apa31 = 0 THEN
      LET g_apa.apa56 = '1'                           #差異處理
      LET g_apa.apa19 = p_apz.apz12                   #留置原因   #MOD-830039 modify g_apz->p_apz
      LET g_apa.apa20 = g_apa.apa31f + g_apa.apa32f   #原幣留置金額
   END IF
 
   UPDATE apa_file SET apa57f = g_apa.apa57f,
                       apa57  = g_apa.apa57,
                       apa33f = g_apa.apa33f,
                       apa33  = g_apa.apa33,
                       apa56  = g_apa.apa56,
                       apa19  = g_apa.apa19,
                       apa20  = g_apa.apa20
    WHERE apa01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('update apa_file',STATUS,0)          #No.FUN-710046
      CALL s_errmsg("apa01",g_apa.apa01,"UPD apa_file",SQLCA.sqlcode,0)     #No.FUN-710046
   END IF
 
 #TQC-B10015 --begin--
   UPDATE apc_file SET apc06 = g_apa.apa14,
                       apc07 = g_apa.apa72,
                       apc08 = g_apa.apa34f,
                       apc09 = g_apa.apa34,
                       apc10 = g_apa.apa35f,
                       apc11 = g_apa.apa35,
                       apc12 = g_apa.apa08,
                       apc13 = g_apa.apa73,
                       apc14 = g_apa.apa65f,
                       apc15 = g_apa.apa65,
                       apc16 = g_apa.apa20
   WHERE apc01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("apc01",g_apa.apa01,"UPD apc_file",SQLCA.sqlcode,0)
   END IF                          
#TQC-B10015 --end-- 

   LET l_trtype = trtype[1,g_doc_len]
   SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel apy:',STATUS,0)   #No.FUN-660167
#     CALL cl_err3("sel","apy_file",l_trtype,"",STATUS,"","sel apy",0)   #No.FUN-660167  #No.FUN-710046
      CALL s_errmsg("apyslip",l_trtype,"SEL apy_file",SQLCA.sqlcode,1)   #No.FUN-710046
      LET g_success = 'N'
   END IF
   IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
#     CALL t110_g_gl(g_apa.apa00,g_apa.apa01)  #No.FUN-680029 mark
      #No.FUN-680029 --start--
      CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0','')   #FUN-9C0001 
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1','')  #FUN-9C0001
      END IF
      #No.FUN-680029 --end--
   END IF
END FUNCTION
 
FUNCTION p642_ins_apa()
   DEFINE li_result LIKE type_file.num5              #No.FUN-560002        #No.FUN-680137 SMALLINT
   DEFINE l_trtype  LIKE aba_file.aba00              #MOD-5C0107           #No.FUN-680137 VARCHAR(5) 
   DEFINE l_apc     RECORD LIKE apc_file.*           #CHI-810016
 
   SELECT * INTO g_apa.* FROM apa_file
    WHERE apa02=g_apa02 AND apa05=g_apa.apa05 AND apa00='12'
      AND apa08 IS NULL AND apa66 IS NULL
      AND apa13=g_apa.apa13 AND apa11=g_apa.apa11
      AND apa41='N' AND apa42='N' AND apa63='0'
 
   LET g_apa.apa02 = g_apa02           #帳款日期
 
   IF g_apa.apa22 IS NULL THEN         #請款部門
      LET g_apa.apa22 = g_apa22
   END IF
 
   LET g_apa.apa36 = g_apa36           #帳款類別
 
   IF g_apa.apa19 = p_apz.apz12 THEN   #MOD-830039 modify g_apz->p_apz
      LET g_apa.apa56 = '0'            #差異處理
      LET g_apa.apa19 = NULL           #留置原因
      LET g_apa.apa20 = 0              #原幣留置金額
   END IF
 
   IF g_apa01 IS NULL OR (g_apa01 IS NOT NULL AND SQLCA.SQLCODE != 0) THEN
      LET g_apa.apa00 = '12'           #帳款性質=12.雜項發票
 
      LET g_apa.apa05 = g_oft.oft03    #送貨廠商編號
 
      LET g_apa.apa06 = g_oft.oft03    #付款廠商編號
 
      SELECT pmc03,pmc17 INTO g_apa.apa07,g_apa.apa11 
        FROM pmc_file WHERE pmc01=g_apa.apa06
      IF g_apa.apa07 IS NULL THEN      #付款廠商簡稱
         LET g_apa.apa07 = 0
      END IF
      IF g_apa.apa11 IS NULL THEN      #付款方式
         LET g_apa.apa11 = ''
      END IF
 
      #應付款日、票據到期日、允許票期
      CALL s_paydate('a','','',g_apa.apa02,g_apa.apa11,g_apa.apa06)
           RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
 
      IF cl_null(g_apa.apa14) THEN     #匯率
         LET g_apa.apa14 = 1
         #取得該幣別(apa13)在該日期(apa02)的銀行賣出匯率
         CALL s_curr3(g_apa.apa13,g_apa.apa02,g_sma.sma904) RETURNING g_apa.apa14
      END IF
 
      LET g_apa.apa17 = '1'            #扣抵區分
 
      SELECT gec06,gec08 INTO g_apa.apa172,g_apa.apa171
        FROM gec_file
       WHERE gec01 = g_apa.apa15
      IF cl_null(g_apa.apa171) THEN    #格式
         LET g_apa.apa171 = '21'
      END IF
      IF cl_null(g_apa.apa172) THEN    #課稅別
         CASE 
            WHEN g_apa.apa16 = 0       #稅率=0
               LET g_apa.apa172 = '2'  
            WHEN g_apa.apa16 = 100     #稅率=100
               LET g_apa.apa172 = '3' 
            OTHERWISE
               LET g_apa.apa172 = '1' 
         END CASE
      END IF
 
      LET g_apa.apa20 = 0              #原幣留置金額
      LET g_apa.apa31f = 0             #原幣未稅
      LET g_apa.apa31 = 0              #本幣未稅
      LET g_apa.apa32f = 0             #原幣稅額
      LET g_apa.apa32 = 0              #本幣稅額
      LET g_apa.apa33f = 0             #原幣差異
      LET g_apa.apa33 = 0              #本幣差異
      LET g_apa.apa34f = 0             #原幣合計
      LET g_apa.apa34 = 0              #本幣合計
      LET g_apa.apa73=0                #本幣未沖金額
      LET g_apa.apa35f = 0             #原幣已付
      LET g_apa.apa35 = 0              #本幣已付
      LET g_apa.apa65f = 0             #原幣直接沖帳金額
      LET g_apa.apa65 = 0              #本幣直接沖帳金額
      LET g_apa.apa41 = 'N'            #確認碼
      LET g_apa.apa42 = 'N'            #作廢碼
      LET g_apa.apa55 = '1'            #付款處理
      LET g_apa.apa56 = '0'            #差異處理
      LET g_apa.apa57f = 0             #原幣單身合計金額
      LET g_apa.apa57 = 0              #本幣單身合計金額
      LET g_apa.apa60f = 0             #原幣折讓扣款金額
      LET g_apa.apa60 = 0              #本幣折讓扣款金額
      LET g_apa.apa61f = 0             #原幣折讓扣款稅額
      LET g_apa.apa61 = 0              #本幣折讓扣款稅額
      LET g_apa.apa63 = '0'            #簽核狀態
      LET g_apa.apa74 = 'N'            #外購付款否
      LET g_apa.apa75 = 'N'            #外購資料
      LET g_apa.apaacti = 'Y'          #資料有效碼
      LET g_apa.apainpd = g_today      #輸入日期
      LET g_apa.apauser = g_user       #資料所有者
      LET g_apa.apagrup = g_grup       #資料所有群
      LET g_apa.apadate = g_today      #最近修改日
      LET g_apa.apa930=s_costcenter(g_apa.apa22)  #FUN-670064
 
      LET l_trtype = trtype[1,g_doc_len]   #帳款單別
      SELECT apyapr INTO g_apa.apamksg FROM apy_file WHERE apyslip = l_trtype   #是否簽核
 
      CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")
           RETURNING li_result,g_apa.apa01
#CHI-A70049---mark---start---
     #DISPLAY "insert apa:",g_apa.apa01,' ',g_apa.apa02,' ',g_apa.apa06 AT 2,1
     #DISPLAY "insert apa: apa22=",g_apa.apa22
#CHI-A70049---mark---end--- 
      #FUN-980010 add plant & legal 
      LET g_apa.apalegal = g_legal 
      #FUN-980010 add plant & legal 
 
      LET g_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
      LET g_apa.apa79   = 0           #No.FUN-A60024             
      INSERT INTO apa_file VALUES(g_apa.*)
      IF STATUS THEN
#        CALL cl_err('p642_ins_apa(ckp#1):',SQLCA.sqlcode,1)    #No.FUN-660167
#        CALL cl_err3("ins","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","p642_ins_apa(ckp#1)",1)   #No.FUN-660167  #No.FUN-710046
         CALL s_errmsg("apa01",g_apa.apa01,"INS apa_file",SQLCA.sqlcode,1)          #No.FUN-710046
         LET g_success = 'N'
     #CHI-810016.....begin
      ELSE
         INITIALIZE l_apc.* TO NULL
         LET l_apc.apc01 = g_apa.apa01
         LET l_apc.apc02 = 1
         LET l_apc.apc03 = g_apa.apa11
         LET l_apc.apc04 = g_apa.apa12
         LET l_apc.apc05 = g_apa.apa64
         LET l_apc.apc06 = g_apa.apa14
         LET l_apc.apc07 = g_apa.apa72
         LET l_apc.apc08 = g_apa.apa34f
         LET l_apc.apc09 = g_apa.apa34
         LET l_apc.apc10 = g_apa.apa35f
         LET l_apc.apc11 = g_apa.apa35
         LET l_apc.apc12 = g_apa.apa08
         LET l_apc.apc13 = g_apa.apa73
         LET l_apc.apc14 = g_apa.apa65f
         LET l_apc.apc15 = g_apa.apa65
         LET l_apc.apc16 = g_apa.apa20
         #FUN-980010 add plant & legal 
         LET l_apc.apclegal = g_legal 
         #FUN-980010 add plant & legal 
 
         INSERT INTO apc_file VALUES(l_apc.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","apc_file",g_apa.apa01,"1",SQLCA.sqlcode,"","ins apc_file",1)
            LET g_success = 'N'
         END IF
     #CHI-810016.....end
      END IF
      IF begin_no IS NULL THEN 
         LET begin_no = g_apa.apa01
      END IF
 
      LET end_no=g_apa.apa01
   END IF
   LET g_apa01 = g_apa.apa01
   LET g_apb.apb01 = g_apa.apa01   #帳款單號
   LET g_apb.apb02 = 0             #項次
   LET g_apb.apb13f = 0            #原幣折讓單價
   LET g_apb.apb13 = 0             #本幣折讓單價
   LET g_apb.apb14f = 0            #原幣折讓金額
   LET g_apb.apb14 = 0             #本幣折讓金額
   LET g_apb.apb15 = 0             #折讓數量
   LET g_apb.apb930 = g_apa.apa930  #FUN-670064
 
END FUNCTION
 
FUNCTION p642_ins_apb()
   DEFINE l_aag05     LIKE aag_file.aag05   #No.TQC-5B0115
 
   SELECT MAX(apb02)+1 INTO g_apb.apb02                   #項次
     FROM apb_file
    WHERE apb01=g_apb.apb01
   IF g_apb.apb02 IS NULL THEN
      LET g_apb.apb02 = 1
   END IF
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file    #MOD-970077
      where azi01 = g_apa.apa13   #MOD-970077
   LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi03)   #原幣單價   #MOD-970077 g_azi.azi03-->t_azi03
   IF g_apb.apb09 IS NULL THEN LET g_apb.apb09 = 0 END IF  #數量 
   LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi04)   #原幣金額   #MOD-970077 g_azi.azi04-->t_azi04
   LET g_apb.apb08 = cl_digcut(g_apb.apb08,g_azi03)   #本幣單價    #No.CHI-6A0004   #MOD-970077 g_azi.azi03-->g_azi03
   LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)   #本幣金額    #No.CHI-6A0004   #MOD-970077 g_azi.azi04-->g_azi04
   LET g_apb.apb081 = g_apb.apb08                         #成本分攤本幣單價
   LET g_apb.apb101 = g_apb.apb10                         #成本分攤本幣金額
 
   IF g_apa.apa51 = 'STOCK' THEN                          #未稅科目
#     CALL t110_stock_act(g_apb.apb12,"","")      #No.FUN-680029 mark
      CALL t110_stock_act(g_apb.apb12,"","",'0',"")  #No.FUN-680029    #FUN-9C0041 add ""
           RETURNING g_apb.apb25                          #會計科目
   END IF
   #No.FUN-680029 --start--
   IF g_apa.apa511 = 'STOCK' AND g_aza.aza63 = 'Y' THEN
      CALL t110_stock_act(g_apb.apb12,"","",'1',"")    #FUN-9C0041 add "'
           RETURNING g_apb.apb251
   END IF
   #No.FUN-680029 --end--
 
   SELECT aag05 INTO l_aag05 FROM aag_file                #本科目是否作部門明細管理
    WHERE aag01 = g_apb.apb25
      AND aag00 = g_bookno1                               #No.FUN-730057
   IF l_aag05 = "Y" AND cl_null(g_apb.apb26) THEN
      LET g_apb.apb26 = g_apa.apa22                       #部門
   END IF
 
   IF cl_null(g_apb.apb30) THEN
      LET g_apb.apb30 = ''                                #預算編號
   END IF
#CHI-A70049---mark---start---
   #DISPLAY "insert apb:",g_apb.apb01,' ',g_apb.apb02,' ',g_apb.apb21,' ',
           #g_apb.apb22,' ',g_apb.apb10 AT 3,1
#CHI-A70049---mark---end--- 
   LET g_apb.apb34 = 'N'       #No.TQC-7B0083
   LET g_apb.apb29 = '1'            #MOD-970172 add
 
   #FUN-980010 add plant & legal 
   LET g_apb.apblegal = g_legal 
   #FUN-980010 add plant & legal 
   INSERT INTO apb_file VALUES(g_apb.*)
   IF STATUS THEN
#     CALL cl_err('p642_ins_apb(ckp#1):',SQLCA.sqlcode,1)   #No.FUN-660167
#     CALL cl_err3("ins","apb_file",g_apb.apb01,g_apb.apb02,SQLCA.sqlcode,"","p642_ins_apb(ckp#1)",1)   #No.FUN-660167  #No.FUN-710046
      LET g_showmsg=g_apb.apb01,"/",g_apb.apb02                              #No.FUN-710046
      CALL s_errmsg("apb01,apb02",g_showmsg,"INS apb_file",SQLCA.sqlcode,1)  #No.FUN-710046
      LET g_success = 'N'
   END IF
 
   LET g_apa.apa31f= g_apa.apa31f+ g_apb.apb24
   LET g_apa.apa31 = g_apa.apa31 + g_apb.apb10
   LET g_apa.apa32f= g_apa.apa31f* g_apa.apa16 / 100      # 四捨五入
   LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi04)   #MOD-970077 g_azi.azi04-->t_azi04
   LET g_apa.apa32 = g_apa.apa31 * g_apa.apa16 / 100      # 四捨五入
   LET g_apa.apa32 = cl_digcut(g_apa.apa32,g_azi04)   #No.CHI-6A0004   #MOD-970077 g_azi.azi04-->g_azi04
   LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
   LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
   LET g_apa.apa73=g_apa.apa34                            #本幣未沖金額
 
   UPDATE apa_file SET apa31f = g_apa.apa31f,
                       apa32f = g_apa.apa32f,
                       apa34f = g_apa.apa34f,
                       apa60f = g_apa.apa60f,
                       apa61f = g_apa.apa61f,
                       apa31 = g_apa.apa31,
                       apa32 = g_apa.apa32,
                       apa34 = g_apa.apa34,
                       apa60 = g_apa.apa60,
                       apa61 = g_apa.apa61,
                       apa56 = g_apa.apa56,
                       apa73 = g_apa.apa73             #A059
    WHERE apa01 = g_apa.apa01
 
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
#     CALL cl_err('upd apa:',STATUS,0)     #No.FUN-710046
      CALL s_errmsg("apa01",g_apa.apa01,"UPD apa_file",SQLCA.sqlcode,1)   #No.FUN-710046
      LET g_success = 'N'
   END IF
 
 #TQC-B10015 --begin--
   UPDATE apc_file SET apc06 = g_apa.apa14,
                       apc07 = g_apa.apa72,
                       apc08 = g_apa.apa34f,
                       apc09 = g_apa.apa34,
                       apc10 = g_apa.apa35f,
                       apc11 = g_apa.apa35,
                       apc12 = g_apa.apa08,
                       apc13 = g_apa.apa73,
                       apc14 = g_apa.apa65f,
                       apc15 = g_apa.apa65,
                       apc16 = g_apa.apa20
   WHERE apc01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("apc01",g_apa.apa01,"UPD apc_file",SQLCA.sqlcode,0)
      LET g_success = 'N'
   END IF                          
#TQC-B10015 --end-- 
 
END FUNCTION
 
FUNCTION p642_apa21(p_cmd)   #請款人員
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03   
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen03,genacti INTO l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_apa.apa21
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN 
   END IF
 
   LET g_apa.apa22 = l_gen03
   DISPLAY BY NAME g_apa.apa22
 
END FUNCTION
   
FUNCTION p642_apa22(p_cmd)   #請款部門
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gemacti INTO l_gemacti
     FROM gem_file
    WHERE gem01 = g_apa.apa22
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN 
   END IF
 
END FUNCTION
 
FUNCTION p642_apa36(p_cmd)   #帳款類別
   DEFINE p_cmd       LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_apr02     LIKE apr_file.apr02
   DEFINE l_aps       RECORD LIKE aps_file.*
   DEFINE l_depno     LIKE aab_file.aab02          #No.FUN-680137 VARCHAR(6)
   DEFINE l_d_actno   LIKE aab_file.aab01          #No.FUN-680137 VARCHAR(24)
   DEFINE l_c_actno   LIKE aab_file.aab01          #No.FUN-680137 VARCHAR(24)
   DEFINE l_e_actno   LIKE aab_file.aab01          #No.FUN-680029
   DEFINE l_f_actno   LIKE aab_file.aab01          #No.FUN-680029
 
   LET g_errno = ' '
 
   SELECT apr02 INTO l_apr02 FROM apr_file   #帳款類別名稱
    WHERE apr01 = g_apa.apa36
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aap-044'
      WHEN SQLCA.SQLCODE != 0 
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      LET l_apr02 = ''
   END IF
 
   DISPLAY l_apr02 TO apr02
 
   IF p_cmd = 'd' THEN RETURN END IF
 
   IF p_apz.apz13 = 'Y' THEN   #是否依部門區分預設會計科目  #MOD-830039 modify g_apz->p_apz
      LET l_depno = g_apa.apa22
   ELSE
      LET l_depno = ' '
   END IF
 
   #AAP-部門預設會計科目檔
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_depno
   IF SQLCA.sqlcode THEN
#     CALL cl_err(l_depno,'aap-053',1)   #No.FUN-660167
      CALL cl_err3("sel","aps_file",l_depno,"","aap-053","","",1)   #No.FUN-660167
      RETURN
   END IF
 
   #借方科目編號、貸方科目編號
   SELECT apt03,apt04 INTO l_d_actno,l_c_actno FROM apt_file
    WHERE apt01 = g_apa.apa36
      AND apt02 = l_depno
   IF SQLCA.sqlcode THEN
      LET l_d_actno = l_aps.aps21   #未開發票應付帳款科目
      LET l_c_actno = l_aps.aps22   #應付帳款科目
   END IF
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      SELECT apt031,apt041 INTO l_e_actno,l_f_actno FROM apt_file 
       WHERE apt01 = g_apa.apa36
         AND apt02 = l_depno
      IF SQLCA.sqlcode THEN
         LET l_e_actno = l_aps.aps211
         LET l_f_actno = l_aps.aps221
      END IF
   END IF
   #No.FUN-680029 --end--
 
   IF g_apy.apydmy5 = 'Y' THEN   #是否做預算控管
      LET g_apa.apa51 = '    '  #--有作預算控管則以單身科目為分錄科目,單頭須空白
   ELSE
      LET g_apa.apa51 = l_d_actno   #未稅科目
      #No.FUN-680029 --start--
      IF g_aza.aza63 = 'Y' THEN
         LET g_apa.apa511 = l_e_actno
      END IF
      #No.FUN-680029 --end--
   END IF
 
   LET g_apa.apa54 = l_c_actno      #合計金額科目
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      LET g_apa.apa541 = l_f_actno
   END IF
   #No.FUN-680029 --end--
 
END FUNCTION
 
FUNCTION p642_chkdate()
   DEFINE l_sql          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1500)
   DEFINE l_yy,l_mm      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   LET l_sql = "SELECT UNIQUE oft18,oft19 FROM oft_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND ( oft18 != YEAR('",g_apa02,"') ",
               "    OR  (oft18  = YEAR('",g_apa02,"') ",
               "   AND   oft19 !=MONTH('",g_apa02,"'))) "
 
   PREPARE p642_prechk FROM l_sql
   IF STATUS THEN
      CALL cl_err('Prepare chkdate: ',STATUS,1) 
      LET l_flag='X' 
      RETURN 
   END IF
 
   DECLARE p642_chkdate CURSOR WITH HOLD FOR p642_prechk
 
   FOREACH p642_chkdate INTO l_yy,l_mm
      IF STATUS THEN 
         CALL cl_err('foreach chkdate: ',STATUS,1) 
         LET l_flag = 'X'
         EXIT FOREACH
      END IF
      LET l_flag = 'Y'
      EXIT FOREACH
   END FOREACH
 
END FUNCTION
