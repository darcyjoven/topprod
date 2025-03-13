# Prog. Version..: '5.30.06-13.03.15(00010)'     #
#
# Pattern name...: abxp802.4gl
# Descriptions...: 保稅出庫單據擷取作業 (for bxi06='2')
# Date & Author..: 95/07/02 By Roger
# Modify.........: No.MOD-530860 05/03/31 By kim 若g_bnz.bnz03 is null則不加入where 條件
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據編號加大
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5A0105 05/10/13 By ice 料號欄位放大
# Modify.........: No.FUN-570115 06/03/01 By saki 加入背景作業功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-650049 06/09/11 By kim 可選擇"是否帶入前端報單號碼,報單日期"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/01 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-720102 07/03/16 By pengu 避免使用錯誤操作及防呆出庫擷取增加tlf907=-1 之判斷
# Modify.........: No.MOD-840231 07/04/21 By Carol SQL調整避免入庫資料也會select的到
# Modify.........: No.MOD-840469 08/08/23 By hongmei 控制打印顯示
# Modify.........: No.MOD-8A0223 08/11/15 By Pengu 保稅出庫單據擷取，未擷取發票號碼
# Modify.........: No.TQC-920053 09/02/20 By mike MSV BUG
# Modify.........: No.MOD-930257 09/03/27 By Smapmin 多倉儲出貨時,產生至abxt800的總金額有誤
# Modify.........: No.MOD-950145 09/05/27 By Smapmin 改由cl_null()判斷是否為null
# Modify.........: No.MOD-960007 09/06/01 By mike 修改當bxz09NOT NULL時才判斷當異動日期小于等于結賬日期時，不允許做刪除的動作 
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0194 09/10/30 By Smapmin 無訂單出貨,多倉儲出貨時無法新增單身資料
# Modify.........: No:MOD-9C0119 09/12/14 By Smapmin bxi09應要帶點
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No:FUN-A30059 10/03/18 By rainy bxy_file 改為bna_file
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)  
# Modify.........: No.FUN-910088 11/12/31 By chengjing 增加數量欄位小數取位
# Modify.........: No:CHI-C10005 12/01/09 By ck2yuan 倉庫間直接調撥不需擷取,過濾aimt324的tlf不擷取
# Modify.........: No:MOD-C30554 12/03/12 By xujing 擷取失敗，程式tlf05<>aimt324 錯誤，改成tlf13
# Modify.........: No:MOD-BA0199 12/06/15 By ck2yuan 輸入錯變數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bxi                    RECORD LIKE bxi_file.*
DEFINE b_bxj                    RECORD LIKE bxj_file.*
DEFINE g_t1             LIKE bnz_file.bnz03       #No.FUN-550033 #No.FUN-680062 VARCHAR(5)
DEFINE g_wc,g_wc2,g_sql STRING                    #No.FUN-580092 HCN   
DEFINE yclose,mclose    LIKE type_file.num5       #No.FUN-680062 SMALINT
DEFINE p_oga38 LIKE oga_file.oga38,
       p_oga39 LIKE oga_file.oga39,
       p_oga021 LIKE oga_file.oga021
DEFINE s_date  LIKE type_file.dat                  #No.FUN-680062  DATE
DEFINE g_bnz   RECORD LIKE bnz_file.*
DEFINE g_i     LIKE type_file.num5     #count/index for any purpose #No.FUN-680062 LIKE type_file.num5
DEFINE g_change_lang LIKE type_file.chr1        #No.FUN-570115 #No.FUN-680062 VARCHAR(1)
DEFINE l_flag        LIKE type_file.chr1        #No.FUN-570115 #No.FUN-680062 VARCHAR(1)
DEFINE g_a     LIKE type_file.chr1 #FUN-6A0007
DEFINE tm RECORD  #FUN-650049
            a  LIKE type_file.chr1   #No.FUN-680062 VARCHAR(1) 
          END RECORD
DEFINE g_connstr LIKE type_file.chr1 #FUN-6A0007 
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_wc    = ARG_VAL(1)
    LET g_bgjob = ARG_VAL(2)

    IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
    END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('abxp802',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
    SELECT * INTO g_bnz.* FROM bnz_file
     WHERE bnz00 = '0'
 
   WHILE TRUE
     IF g_bgjob="N" THEN                 
        CALL p802_p1()
        IF cl_sure(21,21) THEN
           CALL cl_wait()                         
           LET g_success="Y"                            
           BEGIN WORK                                   
           CALL p802_s1()
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
              CLOSE WINDOW p802_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p802_w
     ELSE
        LET g_success="Y"                            
        BEGIN WORK                                   
        CALL p802_s1()
        IF g_success="Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION p802_p1()
   DEFINE   l_tlf06       LIKE type_file.chr1000   #No.FUN-680062CHAR(80)  
   DEFINE   d_tlf06       LIKE type_file.chr50     #No.FUN-680062CHAR(24)  
   DEFINE   bdate,edate   LIKE type_file.chr8,     #No.FUN-680062CHAR(10)  
            l_date        LIKE type_file.dat       #No.FUN-680062DATE  
   DEFINE   l_str         STRING  #No.MOD-580323
   DEFINE   lc_cmd        LIKE type_file.chr1000   # No.FUN-570115  #No.FUN-680062 VARCHAR(500) 
 
   OPEN WINDOW p802_w WITH FORM "abx/42f/abxp802"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CLEAR FORM
 
   LET l_date=MDY(MONTH(g_today),1,YEAR(g_today))-1
   LET edate=g_today
   LET bdate=MDY(MONTH(g_today),1,YEAR(g_today))
   LET d_tlf06=bdate CLIPPED,':',edate CLIPPED
   LET yclose=YEAR(l_date)
   LET mclose=MONTH(l_date)
   LET g_bgjob="N"                               #No.FUN-570115
   WHILE TRUE

      DISPLAY BY NAME g_plant_new
      CONSTRUCT BY NAME g_wc ON tlf026,tlf06,tlf021
       ON ACTION locale
          LET g_change_lang = TRUE                 #No.FUN-570115
          EXIT CONSTRUCT                           #No.FUN-570115
 
         BEFORE CONSTRUCT
            DISPLAY d_tlf06 TO tlf06
 
         BEFORE FIELD tlf06
            LET l_tlf06=GET_FLDBUF(tlf06)
            IF cl_null(l_tlf06) THEN
               DISPLAY d_tlf06 TO tlf06
            END IF
 
         AFTER FIELD tlf06
            LET l_tlf06=GET_FLDBUF(tlf06)
            IF cl_null(l_tlf06) THEN
               CALL cl_getmsg('abx-801',g_lang) RETURNING l_str
               ERROR l_str
               DISPLAY d_tlf06 TO tlf06
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
 
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p802_w                        #No.FUN-570115
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM                               #No.FUN-570115
      END IF

    IF cl_null(tm.a) THEN
       LET tm.a='Y'
       DISPLAY BY NAME tm.a
    END IF
    LET g_a = 'N' #FUN-6A0007
 
    INPUT BY NAME tm.a,g_a,g_bgjob WITHOUT DEFAULTS #FUN-650049 #FUN-6A0007
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION locale
          LET g_change_lang = TRUE
          EXIT INPUT
    END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p802_w                         #No.FUN-570115
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM                                #No.FUN-570115
      END IF
  #當已產生異動單據重新產生的選項打勾(Y)時,
  # 要依QBE的條件將保稅單據維護作業(abtt800)內的資料先行刪除
    LET g_success='Y'
    BEGIN WORK
 
      IF cl_sure(0,0) THEN
         IF g_a = 'Y' THEN
            CALL p802_r()  #先刪除bxi,bxj
         END IF
         IF g_success = 'Y' THEN
            CALL p802_s1() 
         END IF
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p802_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
      ELSE
         ROLLBACK WORK
         CONTINUE WHILE
      END IF				   

      IF cl_null(yclose) THEN
         RETURN
      END IF
      IF cl_null(mclose) THEN
         RETURN
      END IF
 
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01="abxp802"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp802','9031',1)
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_wc CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp802',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
     EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p802_s1()
  DEFINE l_tlf        RECORD LIKE tlf_file.*
  DEFINE no           LIKE tlf_file.tlf026   #NO.FUN-550033  #No.FUN-680062  VARCHAR(16)
  DEFINE g_t1         LIKE type_file.chr5    #NO.FUN-550033  #No.FUN-680062  VARCHAR(5)
  DEFINE seq          LIKE tlf_file.tlf027   #No.FUN-680062  LIKE type_file.num5
  DEFINE l_tlf_rowid  LIKE type_file.row_id  #chr18  FUN-A70120
  DEFINE l_ima08      LIKE ima_file.ima08    #No.FUN-680062  VARCHAR(1)  
  DEFINE l_y,l_m      LIKE type_file.num5    #No.FUN-680062  LIKE type_file.num5
  DEFINE l_name       LIKE type_file.chr20   #External(Disk) file name  #No.FUN-680062  VARCHAR(20)
  DEFINE l_bnz03      STRING  #MOD-530860
  DEFINE l_str1       STRING
  DEFINE l_date       LIKE type_file.dat     #FUN-570115   #No.FUN-680062  DATE
  DEFINE l_slip       LIKE type_file.chr5,   #FUN-6A0007
         l_n          LIKE type_file.num5      #FUN-6A0007
   DEFINE l_err DYNAMIC ARRAY OF RECORD #FUN-6A0007
                   tlf036 LIKE tlf_file.tlf036, 
                   tlf037 LIKE tlf_file.tlf037  
                END RECORD 
   DEFINE l_msg,l_msg2 STRING
 
  LET l_date=MDY(MONTH(g_today),1,YEAR(g_today))-1
  LET yclose=YEAR(l_date)
  LET mclose=MONTH(l_date)
 
  IF g_bgjob="N" THEN
     CALL cl_getmsg('mfg8021',g_lang) RETURNING l_str1
     MESSAGE l_str1
  END IF
 
  LET l_y=yclose
  LET l_m=mclose
  LET l_m=l_m+1
  IF l_m > 12 THEN
     LET l_m=1
     LET l_y=l_y+1
  END IF
  LET s_date=MDY(l_m,1,l_y)-1

  LET l_bnz03=''
  IF NOT cl_null(g_bnz.bnz03) THEN   #MOD-950145
     LET l_bnz03=" OR tlf036 LIKE '",g_bnz.bnz03 CLIPPED,"%' "
  END IF
  CALL l_err.clear() #FUN-6A0007
  SELECT * INTO g_bxz.* FROM bxz_file WHERE bxz00='0'

  LET g_sql=
    "SELECT rowid,tlf_file.*",
   #"  FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file", #TQC-920053  #FUN-A50102
    "  FROM tlf_file ",  #FUN-A50102
    " WHERE tlf909 IS NULL AND ",
    "( tlf02=50 AND tlf907 = -1 ) AND (( ",g_wc CLIPPED,") ",l_bnz03 CLIPPED," )",
#   " AND tlf05<>aimt324 "                        #CHI-C10005 add   #MOD-C30554 mark
    " AND tlf13<>aimt324 "                        #MOD-C30554 add

  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032  #FUN-A50102
  PREPARE p802_p1 FROM g_sql
  DECLARE p802_s1_c CURSOR FOR p802_p1

  CALL cl_outnam('abxp802') RETURNING l_name
  START REPORT p802_rep TO l_name

  FOREACH p802_s1_c INTO l_tlf_rowid,l_tlf.*
    IF STATUS THEN LET g_success='N' RETURN END IF
    CALL s_get_doc_no(l_tlf.tlf036) RETURNING g_t1
    IF g_t1 MATCHES g_bnz.bnz03 THEN
       LET no=l_tlf.tlf036 LET seq=l_tlf.tlf037
    ELSE
       LET no=l_tlf.tlf026 LET seq=l_tlf.tlf027
    END IF

    #單別不存在保稅單據檔裡,則不產生保稅單據維護檔資料
    LET l_slip = s_get_doc_no(no)
    SELECT COUNT(*) INTO l_n 
       #FROM bxy_file WHERE bxy01=l_slip
       FROM bna_file WHERE bna01=l_slip    #FUN-A30059
    IF l_n = 0  THEN
       LET l_n=l_err.getlength()+1
       LET l_err[l_n].tlf036=l_tlf.tlf036
       LET l_err[l_n].tlf037=l_tlf.tlf037
       CONTINUE FOREACH
    END IF
    OUTPUT TO REPORT p802_rep(no,seq,l_tlf_rowid,l_tlf.*)
  END FOREACH

  FINISH REPORT p802_rep

  IF g_bgjob = "N" THEN
     MESSAGE ' '
  END IF

  IF l_err.getlength()>0 THEN
     LET l_msg2= cl_get_feldname('tlf036',g_lang) CLIPPED,"|",
                 cl_get_feldname('tlf037',g_lang) CLIPPED
     LET l_msg = cl_getmsg("abx-086",g_lang)
     CALL cl_show_array(base.TypeInfo.create(l_err),l_msg,l_msg2)
  END IF
  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT p802_rep(no,seq,l_tlf_rowid,l_tlf)
  DEFINE no               LIKE tlf_file.tlf026     #NO.FUN-550033  #No.FUN-680062  VARCHAR(16)
  DEFINE seq              LIKE tlf_file.tlf027     #No.FUN-680062 LIKE type_file.num5 
  DEFINE l_tlf_rowid      LIKE type_file.row_id    #chr18  FUN-A70120
  DEFINE l_tlf            RECORD LIKE tlf_file.*
  DEFINE l_za05           LIKE za_file.za05
  DEFINE l_bxi            RECORD LIKE bxi_file.*
  DEFINE l_bxj            RECORD LIKE bxj_file.*
 #FUN-A30059 begin
  #DEFINE l_bxy04 LIKE bxy_file.bxy04,
  #       l_bxy05 LIKE bxy_file.bxy05,
  DEFINE l_bna05 LIKE bna_file.bna05,
         l_bna08 LIKE bna_file.bna08,
 #FUN-A30059 end
         l_oga08 LIKE oga_file.oga08,
         l_oga10 LIKE oga_file.oga10,
         l_sfb02 LIKE sfb_file.sfb02,
         #l_slip  LIKE bxy_file.bxy01   #No.FUN-550033   #No.FUN-680062  VARCHAR(5) 
         l_slip  LIKE bna_file.bna01   #No.FUN-550033    #FUN-A30059
  DEFINE l_no           LIKE type_file.chr5,                 #單別
         l_sfb82        LIKE sfb_file.sfb82,
         l_sys          LIKE smy_file.smysys,     #系統別(製)
         l_kind         LIKE smy_file.smykind,    #單據性質(製)
         l_desc         LIKE smy_file.smydesc,    #No.MOD-840469  
         l_type         LIKE oay_file.oaytype,    #單據性質(銷)
         l_bxj11        LIKE bxj_file.bxj11,      #報單號碼
         l_bxj17        LIKE bxj_file.bxj17,      #報單日期
         l_bxj15        LIKE bxj_file.bxj15,      #總金額
         l_bxj020       LIKE bxj_file.bxj20,  #台幣單價
         l_bxj021       LIKE bxj_file.bxj21,  #折合原因代碼
         l_bxj22    LIKE bxj_file.bxj22,  #訂單單號 #FUN-6A0007
         l_bxj23    LIKE bxj_file.bxj23,  #訂單項次 #FUN-6A0007
         l_inb13        LIKE inb_file.inb13,      #單價
#FUN-AB0089--add--begin
          l_inb132 LIKE inb_file.inb132,
          l_inb133 LIKE inb_file.inb133,
          l_inb134 LIKE inb_file.inb134,
          l_inb135 LIKE inb_file.inb135,
          l_inb136 LIKE inb_file.inb136,
          l_inb137 LIKE inb_file.inb137,
          l_inb138 LIKE inb_file.inb138,
#FUN-AB0089--add--end
         l_inb14        LIKE inb_file.inb14,      #金額
         l_pmm22        LIKE pmm_file.pmm22,      #幣別
         l_rvv39        LIKE rvv_file.rvv39,      #金額
         l_rvv17        LIKE rvv_file.rvv17,      #數量
         l_rvu03        LIKE rvu_file.rvu03,      #異動入期(入庫)
         l_rate         LIKE oga_file.oga24,      #匯率
         l_ogb14        LIKE ogb_file.ogb14,      #原幣未稅金額 
         l_oga24        LIKE oga_file.oga24,      #匯率
         l_oga09        LIKE oga_file.oga09,      #銷退處理方式
         l_ogb13        LIKe ogb_file.ogb13,      #原幣單價
         l_ogb12        LIKE ogb_file.ogb12,      #數量
         l_ima106       LIKE ima_file.ima106,     #保稅料件型態 
         l_oga38        LIKE oga_file.oga38,      #出口報單類別
         l_oga39        LIKE oga_file.oga39,      #出口報單類別
         l_axm          LIKE type_file.chr1                   #判斷單據是否為銷售單據
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY no,seq
  FORMAT
   BEFORE GROUP OF no
      INITIALIZE l_bxi.* TO NULL
      LET l_bxi.bxi01 =no
      LET p_oga38=' '
      LET p_oga39=' '
      LET p_oga021=NULL
 
         LET l_bxi.bxi02=l_tlf.tlf06
      LET l_bxi.bxi03 =l_tlf.tlf19
      LET l_bxi.bxi04 =' '
      LET l_bxi.bxi05 =l_tlf.tlf13
      LET l_bxi.bxi06 ='2'
      LET l_bxi.bxi08 ='XX'
      LET l_slip = s_get_doc_no(l_bxi.bxi01)
     #FUN-A30059 begin
      #SELECT bxy04,bxy05 INTO l_bxy04,l_bxy05 FROM bxy_file
      # WHERE bxy01=l_slip
      SELECT bna05,bna08 INTO l_bna05,l_bna08 FROM bna_file
       WHERE bna01=l_slip
     #FUN-A30059 end
      IF STATUS = 0 THEN
        #FUN-A30059 begin
         #IF NOT cl_null(l_bxy05) THEN
         #   LET l_bxi.bxi08 =l_bxy05
         #END IF
         IF NOT cl_null(l_bna08) THEN
            LET l_bxi.bxi08 =l_bna08
         END IF
        #FUN-A30059 end
      END IF
 
      #LET l_bxi.bxi09 =s_dbstring(g_dbs[1,10]) CLIPPED   #MOD-9C0119
      LET l_bxi.bxi09 = g_plant  #FUN-A50102
 
      LET l_bxi.bxiconf ='Y'
 
   ## 保稅異動原因代碼(bxi08)的取值方式修改
   #  依出貨單(oga912)、雜發單(ina100)、倉退單(rvu100)
   #  帶出所屬的欄位值為default值,若為空白時,再取保稅單別維護作業(abxi860)
   #  所設定的對應保稅原因代碼,若原因代碼空白則放'XX'
      LET l_no = s_get_doc_no(l_bxi.bxi01)
      LET l_sys = NULL   LET l_kind = NULL   
      LET l_type = NULL  LET l_axm  = 'N'
      SELECT smysys,smykind,smydesc INTO l_sys,l_kind,l_desc
         FROm smy_file WHERE smyslip = l_no   
      IF NOT cl_null(l_sys) THEN
         CASE
            WHEN l_sys = 'aim' AND l_kind = '1'    #雜發單
                 SELECT ina100 INTO l_bxi.bxi08
                    FROM ina_file WHERE ina01 = no
                 IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
 
            WHEN l_sys = 'apm' AND l_kind = '4'    #倉退單
                 SELECT rvu100 INTo l_bxi.bxi08
                    FROM rvu_file WHERE rvu01 = no
                 IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
 
                 IF cl_null(l_bxi.bxi08) THEN
                    SELECT pmc1913 INTO l_bxi.bxi08 FROM pmc_file
                     WHERE pmc01 = l_bxi.bxi03
                    IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
                 END IF
 
                 #如為倉退單則抓bxi13 = pmc04 
                 SELECT pmc04 INTO l_bxi.bxi13 FROM pmc_file
                  WHERE pmc01 = l_bxi.bxi03
                 IF STATUS THEN LET l_bxi.bxi13 = NULL END IF
 
            WHEN l_sys = 'aim' AND l_kind = '8'   #其他異動單
                 LET l_axm = 'Y'
         END CASE
         #IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bxy05 END IF   #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bna08 END IF    #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = 'XX' END IF
      END IF
      IF l_axm = 'Y' OR cl_null(l_sys) THEN
         SELECT oma10 INTO l_bxi.bxi04 FROM oma_file 
                     WHERE oma16 = l_bxi.bxi01 
         IF cl_null(l_bxi.bxi04) THEN LET l_bxi.bxi04 = ' ' END IF 
         SELECT oaytype INTO l_type FROM oay_file WHERE oayslip = l_no
         IF l_type[1,1] = '5' THEN    #銷貨單
 
           #如為出貨單則抓bxi13 = oga03 
            SELECT oga912,oga03 INTO l_bxi.bxi08,l_bxi.bxi13
               FROM oga_file WHERE oga01 = no
            IF STATUS THEN 
               LET l_bxi.bxi08 = NULL
               LET l_bxi.bxi13 = NULL
            END IF
         END IF
         IF cl_null(l_bxi.bxi08) THEN
            SELECT occ1706 INTO l_bxi.bxi08 FROM occ_file
             WHERE occ01 = l_bxi.bxi03
            IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
         END IF
         #IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bxy05 END IF    #FUN-A30059
        #IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bna05 END IF     #FUN-A30059   #MOD-BA0199 mark
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bna08 END IF                   #MOD-BA0199 add
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = 'XX' END IF
      END IF
      LET l_bxi.bxi11 =  YEAR(l_bxi.bxi02) USING '&&&&'  #申報年度
      LET l_bxi.bxi12 =  MONTH(l_bxi.bxi02)#申報月份
 
     #異動命令作業別(bxi15)取值:(依異動命令來取值)
      CASE 
           WHEN l_bxi.bxi05 = 'aimt301' OR l_bxi.bxi05 = 'aimt311'
                LET l_bxi.bxi15 = '2'   #雜發
           WHEN l_bxi.bxi05 = 'aimt303' OR l_bxi.bxi05 = 'aimt313'
                LET l_bxi.bxi15 = '3'   #報廢
           WHEN l_bxi.bxi05 = 'asfi511' OR l_bxi.bxi05 = 'asfi512' OR
                l_bxi.bxi05 = 'asfi513' OR l_bxi.bxi05 = 'asfi514'
                LET l_bxi.bxi15 = '4'   #工單發料
           WHEN l_bxi.bxi05 = 'apmt1072'
                LET l_bxi.bxi15 = '8'   #採購倉退
           WHEN l_bxi.bxi05 = 'axmt620' OR l_bxi.bxi05 = 'axmt650'
                LET l_bxi.bxi15 = '9'   #銷貨
           OTHERWISE
                LET l_bxi.bxi15 = 'B'
      END CASE
 
      LET l_bxi.bxiplant = g_plant  ##FUN-980001 add  
      LET l_bxi.bxilegal = g_legal  ##FUN-980001 add
 
      INSERT INTO bxi_file VALUES(l_bxi.*)
      PRINT
      PRINT g_x[11] CLIPPED,l_bxi.bxi01,
            g_x[12] CLIPPED,l_desc
   
 
   ON EVERY ROW
      INITIALIZE l_bxj.* TO NULL
      LET l_bxj22 = NULL    #FUN-6A0007
      LET l_bxj23 = NULL    #FUN-6A0007
        LET l_sys   = NULL    LET l_kind  = NULL
        LET l_bxj11 = NULL    LET l_bxj17 = NULL
        LET l_bxj020= 0       LET l_bxj021= l_bxi.bxi08
        LET l_inb13 = 0       LET l_inb14 = 0
        LET l_pmm22 = NULL    LET l_rvv39 = 0
        LET l_rvv17 = 0       LET l_rvu03 = NULL
        LET l_type  = NULL    LET l_ogb14 = 0
        LET l_oga24 = 0       LET l_oga09 = NULL
        LET l_ogb13 = 0       LET l_ogb12 = 0
        LET l_ima106= NULL    LET l_axm   = 'N'
 
        LET l_no = s_get_doc_no(l_bxi.bxi01)
        SELECT smysys,smykind INTO l_sys,l_kind
             FROm smy_file WHERE smyslip = l_no
          IF NOT cl_null(l_sys) THEN
             CASE
                WHEN l_sys = 'aim' AND l_kind = '1'   #雜發料

                    SELECT ina101,ina102,inb13,inb132,inb133,inb134,inb135,inb136,inb137,inb138,inb14,inb911,inb912  #FUN-AB0089 
                      INTO l_bxj11,l_bxj17,l_inb13,l_inb132,l_inb133,l_inb134,l_inb135,l_inb136,l_inb137,l_inb138,l_inb14, #FUN-AB0089
                           l_bxj22,l_bxj23
                      FROM ina_file,inb_file
                     WHERE ina01 = inb01 AND ina01 = no
                       AND inb03 = seq
                    IF cl_null(l_inb13) THEN LET l_inb13 = 0 END IF
#FUN-AB0089--add--begin
                    IF cl_null(l_inb132) THEN LET l_inb132 = 0 END IF
                    IF cl_null(l_inb133) THEN LET l_inb133 = 0 END IF
                    IF cl_null(l_inb134) THEN LET l_inb134 = 0 END IF
                    IF cl_null(l_inb135) THEN LET l_inb135 = 0 END IF
                    IF cl_null(l_inb136) THEN LET l_inb136 = 0 END IF
                    IF cl_null(l_inb137) THEN LET l_inb137 = 0 END IF
                    IF cl_null(l_inb138) THEN LET l_inb138 = 0 END IF
#FUN-AB0089--add--end
                    IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
                    LET l_bxj15 = cl_digcut(l_inb14,g_azi04)
                    LET l_bxj020= cl_digcut(l_inb13+l_inb132+l_inb133+l_inb134+l_inb13+l_inb136+l_inb137+l_inb138,g_azi03)
 
                WHEN l_sys = 'aim' AND l_kind = '3'   #報廢單
                     SELECT inb911,inb912
                       INTO l_bxj22,l_bxj23
                       FROM ina_file,inb_file
                      WHERE ina01 = inb01 AND ina01 = no
                        AND inb03 = seq
 
                WHEN l_sys = 'apm' AND l_kind = '4'   #倉退
                     #有一種情形是無收貨單的倉退
                     SELECT rvu101,rvu102,pmm22,rvv39,rvv17,rvu03
                        INTO l_bxj11,l_bxj17,l_pmm22,l_rvv39,l_rvv17,l_rvu03
                        FROM rvu_file,rvv_file,rva_file,rvb_file,pmm_file
                        WHERE rvu01 = rvv01 AND rva01 = rvu02 AND
                              rva01 = rvb01 AND rvv05 = rvb02 AND 
                              rvb04 = pmm01 AND
                              rvu01 = no AND rvv02 = seq
                     IF STATUS THEN  #倉退單無驗收單號
                        SELECT rvu101,rvu102,rvv39,rvv17,rvu03
                          INTO l_bxj11,l_bxj17,l_rvv39,l_rvv17,l_rvu03
                          FROM rvu_file,rvv_file
                         WHERE rvu01 = rvv01 
                           AND rvu01 = no AND rvv02 = seq
                        LET l_pmm22= g_aza.aza17  #本幣
                     END IF
                     
                     CALL s_curr3(l_pmm22,l_rvu03,'D') RETURNING l_rate
                     IF cl_null(l_rate)  THEN LET l_rate = 0 END IF
                     IF cl_null(l_rvv39) THEN LET l_rvv39 = 0 END IF
                     IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
 
                 # bxj15 =rvv39*入庫日期所取的海關賣出匯率,再取本幣金額的位數值
                 # bxj20=bxj15/rvv17,再取本幣單價的位數值
                     LET l_bxj15 = cl_digcut(l_rvv39 * l_rate,g_azi04)
                     LET l_bxj020= cl_digcut(l_bxj15/l_rvv17,g_azi03)
                WHEN l_sys = 'aim' AND l_kind = '8'    #其他異動單據
                     LET l_axm = 'Y'
            
                WHEN l_sys = 'asf' AND l_kind = '3'   #託外發料單
                    SELECT ima53  INTO l_bxj020       #最近採購單價
                      FROM ima_file
                     WHERE ima01 = l_tlf.tlf01
                    IF l_bxj020 IS NULL THEN LET l_bxj020=0 END IF
                    LET l_bxj15 = cl_digcut(l_bxj020*l_tlf.tlf10*l_tlf.tlf60,
                                            g_azi04)
                    LET l_bxj020= cl_digcut(l_bxj020, g_azi03)
                    IF l_bxi.bxi05 = 'asfi511' OR l_bxi.bxi05 = 'asfi512' OR
                       l_bxi.bxi05 = 'asfi513' OR l_bxi.bxi05 = 'asfi514' THEN
                       SELECT sfb22,sfb221 INTO l_bxj22,l_bxj23
                         FROM sfe_file,sfb_file
                        WHERE sfe02 = no
                          AND sfe28 = seq
                          AND sfe01 = sfb01
                    END IF
             END CASE
          END IF
          IF l_axm = 'Y' OR cl_null(l_sys) THEN  
             SELECT oaytype INTO l_type FROM oay_file WHERE oayslip = l_no
             IF l_type[1,1] = '5' THEN    # 出貨單
 
                SELECT oga38,oga39,oga913,ogb14,oga24,ogb12,ogb31,ogb32
                  INTO l_oga38,l_oga39,l_bxj17,l_ogb14,l_oga24,l_ogb12,
                       l_bxj22,l_bxj23
                  FROM oga_file,ogb_file
                 WHERE oga01 = ogb01 AND oga01 = no AND ogb03 = seq
 
                IF cl_null(l_ogb14) THEN LET l_ogb14 = 0 END IF
                IF cl_null(l_oga24) THEN LET l_oga24 = 0 END IF
                IF cl_null(l_ogb13) THEN LET l_ogb13 = 0 END IF
                IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
 
                LET l_bxj11 = l_oga38 CLIPPED,l_oga39 CLIPPED
                
              # bxj15 =ogb14*oga24,再取本幣的位數值
              # bxj20=bxj15/ogb12, 再取本幣單價的位數值
                LET l_bxj15 = cl_digcut(l_ogb14*l_oga24,g_azi04)
                LET l_bxj020 = cl_digcut(l_bxj15/l_ogb12,g_azi03)
                LET l_bxj15 = cl_digcut(l_bxj020*l_tlf.tlf10*l_tlf.tlf60,   #MOD-930257
                                        g_azi04)   #MOD-930257
              END IF
              # bxj21( 折合原因代碼)的處理方式如下:
              # 若遇到銷貨單時,且料號為保稅原料者(ima106='1')時,
              # 要視為參數所設定外運的原因代碼bxz103 ( 外運原因代號 ),
              # 其餘要以單頭的原因代碼值存放 bxj21 = bxi08
              SELECT ima106 INTO l_ima106
                 FROM ima_file WHERE ima01 = l_tlf.tlf01
              IF l_ima106 = '1' THEN
                 LET l_bxj021 = g_bxz.bxz103
              ELSE
                 LET l_bxj021 = l_bxi.bxi08
              END IF
          END IF
      LET l_bxj.bxj01 =no
      LET l_bxj.bxj03 =seq
      LET l_bxj.bxj04 =l_tlf.tlf01
      SELECT ima25 INTO l_bxj.bxj05 FROM ima_file WHERE ima01=l_tlf.tlf01
      LET l_bxj.bxj06 =l_tlf.tlf10*l_tlf.tlf60
      LET l_bxj.bxj06 = s_digqty(l_bxj.bxj06,l_bxj.bxj05)     #FUN-910088--add--
      LET l_bxj.bxj18 =l_tlf.tlf11
      LET l_bxj.bxj19 =l_tlf.tlf10
      LET l_bxj.bxj07 =l_tlf.tlf021
      LET l_bxj.bxj10 =l_tlf.tlf17
      IF tm.a='Y' THEN #FUN-650049
         LET l_bxj.bxj11 =p_oga38,p_oga39
         IF NOT cl_null(l_bxj.bxj11) THEN
            LET l_bxj.bxj17 =p_oga021
         END IF
         LET l_bxj.bxj12=l_tlf.tlf036
      END IF
      LET l_bxj.bxj11 = l_bxj11        #報單號碼
      LET l_bxj.bxj17 = l_bxj17        #報單日期
      LET l_bxj.bxj15 = l_bxj15        #總金額
      LET l_bxj.bxj20 = l_bxj020   #台幣單價
      LET l_bxj.bxj21 = l_bxj021   #折合原因代碼
      LET l_bxj.bxj22 = l_bxj22  #FUN-6A0007
      LET l_bxj.bxj23 = l_bxj23  #FUN-6A0007
 
      LET l_bxj.bxjplant = g_plant  ##FUN-980001 add
      LET l_bxj.bxjlegal = g_legal  ##FUN-980001 add
 
      INSERT INTO bxj_file VALUES(l_bxj.*)
      IF cl_sql_dup_value(SQLCA.SQLCODE) AND (l_tlf.tlf13='axmt620' OR l_tlf.tlf13='axmt650') THEN     ### 多倉出貨 #TQC-790102   #MOD-9A0194
         WHILE TRUE
            LET l_bxj.bxj03=l_bxj.bxj03+1
            INSERT INTO bxj_file VALUES(l_bxj.*)
            IF NOT STATUS THEN EXIT WHILE END IF
         END WHILE
      END IF
 
      IF STATUS=0 THEN
         #LET g_sql="UPDATE ",s_dbstring(g_dbs CLIPPED), #TQC-920053 
         #          "tlf_file SET tlf909='Y' WHERE rowid=?" #TQC-920053
         LET g_sql="UPDATE tlf_file ", #FUN-A50102
                   "   SET tlf909='Y' WHERE rowid=?" #TQC-920053  
 	 #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032   #FUN-A50102
         PREPARE p802_up_tlf FROM g_sql
         EXECUTE p802_up_tlf USING l_tlf_rowid
      END IF
END REPORT
 
 
#--刪除bxi_file,bxj_file
FUNCTION p802_r()
   DEFINE  l_n          LIKE type_file.num5, 
           l_bxi09      LIKE bxi_file.bxi09
 
 # 判斷是否有已產生的異動單據,沒有則不用做刪除的動作
   LET g_sql= "SELECT COUNT(*)",
             #FUN-A50102--mod--str--
             #"  FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file,bxi_file", #TQC-920053  
              "  FROM tlf_file,bxi_file ",
             #FUN-A50102--mod--end
              " WHERE tlf909 = 'Y' AND tlf026 = bxi01 AND",
              "       bxi06 = '2' AND ", g_wc CLIPPED
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032   #FUN-A50102
   PREPARE del_pre1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("del_pre1", STATUS, 1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE del_cur1 CURSOR FOR del_pre1
   IF STATUS THEN
      CALL cl_err("del_cur1",STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   OPEN del_cur1 
   IF STATUS THEN
      CALL cl_err("open del_cur1",STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   FETCH del_cur1 INTO l_n
   IF STATUS THEN
      CALL cl_err("fetch del_cur1",STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_n = 0 OR cl_null(l_n) THEN
      RETURN
   END IF
 
 # 判斷當異動日期小於等於結帳日期時,不允許做刪除的動作 
   IF NOT cl_null(g_bxz.bxz09) THEN
      LET g_sql= "SELECT COUNT(*)",
                #FUN-A50102--mod--str--
                #"  FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file,bxi_file", #TQC-920053
                 "  FROM tlf_file,bxi_file ",
                #FUN-A50102--mod--end
                 " WHERE tlf909 = 'Y' AND tlf026 = bxi01 AND",
                 "       bxi06 = '2' AND  bxi02 <= '",g_bxz.bxz09,"' AND ",
                 g_wc CLIPPED
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032  #FUN-A50102
      PREPARE del_pre2 FROM g_sql
      IF STATUS THEN
         CALL cl_err("del_pre2", STATUS, 1)
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE del_cur2 CURSOR FOR del_pre2 
      IF STATUS THEN
         CALL cl_err("del_cur2",STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      OPEN del_cur2
      IF STATUS THEN
         CALL cl_err("open del_cur2",STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_n = 0 
      FETCH del_cur2 INTO l_n
      IF STATUS THEN
         CALL cl_err("fetch del_cur2",STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_n > 0 THEN
         CALL cl_err('','mfg9999',1) 
         LET g_success = 'N' 
         RETURN
      END IF
   END IF #MOD-960007
 
   DROP TABLE x
   LET g_sql= "SELECT tlf026",
             #"  FROM ",g_dbs CLIPPED,g_connstr,"tlf_file", #TQC-920053
             #"  FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file", #TQC-920053  #FUN-A50102
              "  FROM tlf_file ",   #FUN-A50102
              " WHERE tlf909 = 'Y' AND tlf907 = '-1' AND ",g_wc CLIPPED,
              " INTO TEMP x"
 
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032   #FUN-A50102
   PREPARE del_pre3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("del_pre3", STATUS, 1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE del_pre3
   IF SQLCA.SQLCODE THEN 
      CALL cl_err("exec del_pre3", STATUS, 1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DELETE FROM bxi_file 
      WHERE bxi01 IN (SELECT tlf026 FROM x)
   IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
      CALL cl_err('del bxi error:',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM bxj_file WHERE bxj01 IN (SELECT tlf026 FROM x)
   IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
      CALL cl_err('del bxj error',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #LET g_sql="UPDATE ",s_dbstring(g_dbs[1,10] CLIPPED),"tlf_file", #TQC-920053  #FUN-A50102 
   LET g_sql="UPDATE tlf_file ",    #FUN-A50102
             " SET tlf909=NULL WHERE tlf026 IN (SELECT tlf026 FROM x)"
 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032   #FUN-A50102
   PREPARE upd_tlf909 FROM g_sql
   EXECUTE upd_tlf909 
   IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
      CALL cl_err('upd tlf909 error',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#No.FUN-9C0077 程式精簡
