# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afap100.4gl
# Descriptions...: 資產底稿產生作業
# Date & Author..: 96/06/11 by nick
# Modify.........: 01/04/18 BY ANN CHEN No.B401
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: 03/11/12 By Kitty No:8705 組alk 少ale06,apa加判斷apa75!='Y'
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.FUN-590129 05/09/30 By Sarah 程式裡多抓apb081,apb101,在寫入fak時,將原先fak13寫入apb08改抓apb081,fak14寫入apb10改抓apb101,fak16用fak14除以匯率來計算
# Modify.........: No.MOD-590462 05/10/03 By Sarah 寫法會造成回傳可能多筆,造成資料異常,加入DECLARE CURSOR,只抓第一筆
# Modify.........: No.FUN-570144 06/03/02 By yiting 批次背景執行功能
# Modify.........: No.TQC-630016 06/03/31 By Smapmin 本支作業只要以apa_file,apb_file為基準即可,無需以外購檔案.
# Modify.........: No.MOD-650066 06/05/11 By Dido LIKE type_file.num10  宣告改為 DECIMAL       #No.FUN-680070 INTEGER
# Modify.........: NO.FUN-660005 06/06/05 By Smapmin 新增開窗功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6B0137 06/12/05 By Smapmin 抓不到外購資料
# Modify.........: No.MOD-690087 06/12/05 By Smapmin 若序號包含文字,則秀出錯誤訊
# Modify.........: No.FUN-710028 07/01/15 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-710201 07/01/31 By Smapmin 發票編號改抓apa08
# Modify.........: No.MOD-720109 07/03/01 By Smapmin 增加判斷參數設定為財產編號預設與序號一致的狀況
# Modify.........: No.TQC-770096 07/07/18 By wujie   生成的底稿資料(afai101中)沒有最近更改日
# Modify.........: No.TQC-770087 07/07/18 By chenl   借方科目開窗增加傳入條件"帳套"
# Modify.........: No.MOD-780174 07/08/20 By Smapmin 預留殘值取位
# Modify.........: No.MOD-780222 07/08/21 By jamie 放大apb27欄位 
# Modify.........: No.MOD-780226 07/08/27 By jamie 未產生【稅簽未折減額】(fak68)
# Modify.........: No.MOD-780217 07/08/27 By jamie 產生之「資產底稿資料維護作業(afai101)」，
#                                                 【保管部門】應優先取用前端應付單身之部門代號，
#                                                  身部門代號若為空白再取用單頭部門代號較為合理
# Modify.........: No.MOD-7C0134 07/12/19 By Smapmin 於unicode環境無法拋轉成功
# Modify.........: No.MOD-7C0177 07/12/25 By Smapmin 增加稅簽未月年限與預留殘值的預設值
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-840660 08/04/25 By chenl 增加入賬日期等于關賬日期的錯誤提示。
# Modify.........: No.MOD-830245 08/07/04 By Pengu 未確認之AP不能拋轉至資產底稿
# Modify.........: No.MOD-880147 08/08/22 By Sarah 異動faa191前,先比對MAX(fak01)與MIN(fak01)長度,若不相同則提示訊息不異動
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-940086 09/04/08 By Sarah 當g_wc裡有輸入apa51或apa511時,需多組一g_wc1,將原先g_wc裡的apa51,apa511轉換成apb25,apb251
# Modify.........: No.FUN-930054 09/05/05 By Sabrina 若g_aaz.aaz90='Y'(要使用利潤中心功能)時，則fak24=成本中心，若無，fak24=保管部門
# Modify.........: No.TQC-950131 09/05/21 By xiaofeizhu 修改SQL語句的錯誤
# Modify.........: No.TQC-950137 09/05/22 By wujie 生成筆數在使用前沒有清空
# Modify.........: No.TQC-950146 09/05/25 By xiaofeizhu 已經成功產生資產底稿的賬款資料錄入，控管處加上報錯信息
# Modify.........: No.MOD-980124 09/08/17 By Sarah 品名一律都先寫入fak06中文名稱,判斷非本國幣時再多寫入fak07英文名稱 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/07 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.TQC-990151 09/09/30 By wujie 去除sql中pmk的join  
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.MOD-9A0047 09/10/15 By sabrina 產生批號時(tm.lot)，應以afas010上的faa07，faa08做為年�月的依據
# Modify.........: No.FUN-9A0093 09/11/04 By lutingting營運中心欄位拿掉,fak22和fak44給defaultapb37
# Modify.........: No:MOD-9B0049 09/11/09 By Smapmin 修正TQC-950146
# Modify.........: No:MOD-9C0381 09/12/24 By Dido 抓取科目邏輯調整 
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No:MOD-A20015 10/02/03 By Sarah 計算完fak16後應該重新取位
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.MOD-A40114 10/04/20 By sabrina 第一次執行成功後，按繼續作業時，產生批號會帶原第一次的批號，應更新為下一號
# Modify.........: No.FUN-A60056 10/07/06 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056 問題
# Modify.........: No:MOD-A10193 10/09/29 By sabrina afap100拋至afai101時，fak34會取fab08預設，fak71應比照處理
# Modify.........: No.TQC-AB0327 10/11/30 By suncx 錄入已拋轉的單據應拋轉失敗
# Modify.........: No.FUN-B30041 11/03/11 By zhangweib 取fab_file資料INTO l_fab.*時，只取第一筆
# Modify.........: No.FUN-B30211 11/04/06 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.MOD-B50008 11/05/03 By wujie   帐款编号增加开窗功能
# Modify.........: No.MOD-B50015 11/05/03 By Dido 抓取資產科目條件調整;抓取fab_file語法有誤
# Modify.........: No.MOD-B50064 11/05/09 By Dido fak143應為aaa03,fak144應以fak143取得匯率並計算fak142
# Modify.........: No.TQC-B50042 11/05/11 By Dido 由於aza63與faa31可能不會同時'Y',因此科目二的資料AAP給予AFA時,兩個參數需皆為'Y'才可給予 
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:MOD-BC0064 11/12/07 By Carrier UNAP转过固资后,正常AP再转一次,或是正常AP转过后,UNAP再转一次,导致重复转
# Modify.........: No:MOD-C20050 12/02/08 By Polly 變數的調整
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-C70267 12/07/27 By Polly 拋轉筆數為0需顯示拋轉失敗aap-129
# Modify.........: No.MOD-CB0047 12/11/09 By Polly 增加呼叫s_yp(fak26)方式傳遞回來實際的年度期別
# Modify.........: No.MOD-CC0256 12/21/27 By Polly 應付憑單單頭會科設為STOCK，應取單身的會科再對應到資產主類別
# Modify.........: No.MOD-D10052 13/01/08 By Polly 當有做接軌及財簽二，則調整所抓的科目
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc          STRING,                        #No.FUN-580092 HCN
       g_sql,l_sql   STRING,                        #No.FUN-580092 HCN
       l_ac,i,j      LIKE type_file.num5,           #No.FUN-680070 SMALLINT
       g_start_no    LIKE fak_file.fak01,
       g_end_no      LIKE fak_file.fak01,
       tm            RECORD
                      lot  LIKE type_file.chr8      #No.FUN-680070 VARCHAR(8)
                     END RECORD,
       g_pab         RECORD
                      apa00  LIKE apa_file.apa00,   #No.MOD-BC0064
                      apa05  LIKE apa_file.apa05,   #送貨廠商編號(alk05)
                      apa13  LIKE apa_file.apa13,   #幣別(alk11)
                      apa22  LIKE apa_file.apa22,   #請款部門(alk04)
                      apa02  LIKE apa_file.apa02,   #帳款日期(alk02)
                      apa09  LIKE apa_file.apa09,   #發票日期(alk49)
                      apa44  LIKE apa_file.apa44,   #傳票編號(alk72)
                      apa51  LIKE apa_file.apa51,   #科目(alk44)
                      apb25  LIKE apb_file.apb25,   #科目(alk44)
                      apa08  LIKE apa_file.apa08,   #發票號碼(alk08)   #MOD-710201
                      alk01  LIKE alk_file.alk01,   #進口編號(alk01)
                      apb07  LIKE apb_file.apb07,   #採購項次(ale15)
                      apb06  LIKE apb_file.apb06,   #採購單  (ale14)
                      apb22  LIKE apb_file.apb22,   #入庫項次(ale17)
                      apb21  LIKE apb_file.apb21,   #入庫單號(ale16)
                      apb02  LIKE apb_file.apb02,   #帳款項次(ale02)
                      apb01  LIKE apb_file.apb01,   #帳款單號(ale01)
                      apb09  LIKE apb_file.apb09,   #數量(ale06)
                      apb24  LIKE apb_file.apb24,   #原幣金額(ale07)
                      apb10  LIKE apb_file.apb10,   #本幣金額(ale09)
                      apb08  LIKE apb_file.apb08,   #本幣單價(ale08)
                      apb101 LIKE apb_file.apb101,  #成本分攤本幣金額  #FUN-590129
                      apb081 LIKE apb_file.apb081,  #成本分攤本幣單價  #FUN-590129
                      apb28  LIKE apb_file.apb28,   #單位             
                      apb27  LIKE apb_file.apb27,   #品名
                      apb23  LIKE apb_file.apb23,   #原幣單價(ale05)
                      apa16  LIKE apa_file.apa16,   #稅率
                      azi04  LIKE azi_file.azi04,
                      apa511 LIKE apa_file.apa511,  #No.FUN-680028
                      apb251 LIKE apb_file.apb251,  #No.FUN-680028
                      apb26  LIKE apb_file.apb26,   #MOD-780217  add
                      apa21  LIKE apa_file.apa21,   #MOD-780217  add
                      apb37  LIKE apb_file.apb37    #FUN-9A0093  add
                     END RECORD 
DEFINE g_fak         RECORD LIKE fak_file.*
DEFINE g_fak01       LIKE fak_file.fak01            #MOD-A20015 add
DEFINE l_azp03       LIKE azp_file.azp03
DEFINE p_row,p_col   LIKE type_file.num5            #No.FUN-680070 SMALLINT
DEFINE g_cnt         LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE g_change_lang LIKE type_file.chr1            #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
DEFINE g_wc1,g_wc2   STRING                         #MOD-940086 add
 
MAIN
   DEFINE      ls_date       STRING,                  #->No.FUN-570144
               l_flag        LIKE type_file.chr1      #No.FUN-680070 VARCHAR(1)
 
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc         = ARG_VAL(1)      #QBE條件
   LET tm.lot       = ARG_VAL(2)      #QBE條件
   LET g_bgjob      = ARG_VAL(3)      #背景作業
   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p100()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p100_process()
            CALL s_showmsg()   #No.FUN-710028
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
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p100_process()
         CALL s_showmsg()   #No.FUN-710028
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p100()
   DEFINE   l_str    LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)
   DEFINE   l_str4   LIKE type_file.chr4            #No.FUN-680070 VARCHAR(4)
   DEFINE   lc_cmd   LIKE type_file.chr1000              #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "afa/42f/afap100"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
#  IF g_aza.aza63 != 'Y' THEN 
   IF g_faa.faa31 != 'Y' THEN   #No:FUN-AB0088
      CALL cl_set_comp_visible("apa511",FALSE)  
   END IF
 
   CLEAR FORM
   CALL cl_opmsg('w')
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON apb01,apa02,apa36,apa51,apa511  #No.FUN-680028 
 
        ON ACTION CONTROLP
           CASE
#No.MOD-B50008 --begin
              WHEN INFIELD(apb01) # Class
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apa9"
                 LET g_qryparam.where =" apa42='N'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apb01
#No.MOD-B50008 --end
              WHEN INFIELD(apa36) # Class
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apr"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apa36
              WHEN INFIELD(apa51) # Account number
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.arg1 ="00"       #No.TQC-770087
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apa51
              WHEN INFIELD(apa511) # Account number
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.arg1 ="00"       #No.TQC-770087
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apa511
           END CASE
 
       ON ACTION locale
           LET g_change_lang = TRUE       #->No.FUN-570144
            EXIT CONSTRUCT                #NO.FUN-570144
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT 
 
END CONSTRUCT
LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p100_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
 

   LET g_bgjob = "N"         #NO.FUN-570144 
   DISPLAY BY NAME g_bgjob   #NO.FUN-570144
   INPUT BY NAME tm.lot,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570144
 
      BEFORE FIELD lot   # default value for lot by yymmxxxx
        #IF cl_null(tm.lot) THEN        #MOD-A40114 mark 
            LET l_str=g_faa.faa07 USING '&&&&',g_faa.faa08 USING '&&'    #MOD-9A0047 add
            LET l_str4=l_str[3,6]
            SELECT MAX(fak00) INTO tm.lot FROM fak_file WHERE fak00[1,4]=l_str4
            LET tm.lot=tm.lot+1 USING '&&&&&&&&'
            IF cl_null(tm.lot) THEN 
               LET tm.lot=l_str4,'0001'
            END IF
            DISPLAY BY NAME tm.lot
        #END IF          #MOD-A40114 mark
      AFTER FIELD lot
         IF cl_null(tm.lot) THEN
            NEXT FIELD lot
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG
         call cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale                  #NO.FUN-570144
         LET g_change_lang = TRUE       
         EXIT INPUT
   
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT     
 
   END INPUT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap100"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap100','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.lot   CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('afap100',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
   
FUNCTION p100_ins()
   DEFINE l_yy,l_mm,l_tt   LIKE type_file.num5      #No.FUN-680070 SMALLINT
   DEFINE l_max1,l_max2    LIKE type_file.chr10     #MOD-650066       #No.FUN-680070 DECIMAL(10,0)   #MOD-690087
   DEFINE l_fbi02          LIKE fbi_file.fbi02
   DEFINE l_fbi021         LIKE fbi_file.fbi021     #No.FUN-680028
   DEFINE l_fab            RECORD LIKE fab_file.*
   DEFINE l_rvv04          LIKE rvv_file.rvv04
   DEFINE l_n              LIKE type_file.num5                              #No.FUN-680070 SMALLINT
   DEFINE l_rva04          LIKE rva_file.rva04  
   DEFINE l_apa14          LIKE apa_file.apa14      #FUN-590129
   DEFINE l_str            STRING,                  #MOD-690087
          l_len,i          LIKE type_file.num5      #MOD-690087
   DEFINE l_azi04          LIKE azi_file.azi04      #MOD-B50064
   DEFINE l_year          LIKE type_file.chr4  #MOD-CB0047 add
   DEFINE l_month         LIKE type_file.chr2  #MOD-CB0047 add
   DEFINE l_day           LIKE type_file.chr2  #MOD-CB0047 add
   DEFINE l_date          LIKE faj_file.faj26  #MOD-CB0047 add
   DEFINE l_date2         LIKE type_file.chr8  #MOD-CB0047 add
   DEFINE l_apa54         LIKE apa_file.apa54  #zhouxm170220 add 
 
    #若此張帳款編號已拋轉，則不可再拋(modi in 98/10/13)   
    SELECT COUNT(*) INTO l_n FROM fak_file WHERE fak45 = g_pab.apb01
                                             AND fak451= g_pab.apb02
    IF l_n > 0 THEN
       CALL cl_err('','afa-388',1)           #TQC-950146 
       LET g_success = 'N'     #TQC-AB0327 add
       RETURN 
    END IF 
    INITIALIZE g_fak.* TO NULL
    LET g_fak.fak00 =tm.lot  # 產生批號 
    #若系統參數「序號採自動編號faa19」時, 自動賦予已用編號
    IF g_faa.faa19 = 'Y' THEN 
       IF cl_null(g_fak01) THEN   #MOD-A20015 add
          SELECT MAX(fak01) INTO l_max1 FROM fak_file
      #str MOD-A20015 add
       #以MAX(fak01)會抓不到這次批次執行裡產生的最大號,
       #所以當g_fak01有值時,以此值為最大號
       ELSE
          LET l_max1 = g_fak01
       END IF
      #end MOD-A20015 add
       IF NOT cl_null(l_max1) THEN
          LET l_str = l_max1
          LET l_len = l_str.getlength()
          FOR i = 1 TO l_len
              IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
                 #CALL s_errmsg('','',l_str,'apy-020',1)   #No.FUN-710028  #CHI-B40058 mark
                 CALL s_errmsg('','',l_str,'afa-205',1)    #CHI-B40058
                 LET g_success = 'N'
                 RETURN
              END IF
          END FOR
       END IF
       IF l_max1 IS NULL THEN LET l_max1=0 END IF
       LET g_fak.fak01 =l_max1+1 USING '&&&&&&&&&&'  # 序號 
    ELSE 
       LET g_fak.fak01 = ' '
    END IF
    LET g_fak01 = g_fak.fak01   #MOD-A20015 add
    IF g_faa.faa06 = 'Y' THEN
       LET g_fak.fak02 = g_fak.fak01
    ELSE
       LET g_fak.fak02 = ' ' 
    END IF 
    LET g_fak.fak021='1'             #型態  
    LET g_fak.fak022=' '             #附號 
    LET g_fak.fak03 ='1'             #取得方式 
    LET g_fak.fak08 =' '             #規格型號 
    LET g_fak.fak09 ='1'             #資產性質  
    LET g_fak.fak12 =' '             #原產地   
    LET g_fak.fak30 =0               #未耐用年限   
    LET g_fak.fak65 =0               #稅簽未耐用年限
    LET g_fak.fak31 =0               #預留殘值 
    LET g_fak.fak32 =0               #累積折舊 
    LET g_fak.fak33 =0               #未折減額額
    LET g_fak.fak141 =0              LET g_fak.fak63  =0              
    LET g_fak.fak57  =0              LET g_fak.fak571 =0
    LET g_fak.fak58  =0              LET g_fak.fak59  =0
    LET g_fak.fak60  =0              LET g_fak.fak66  =0  
    LET g_fak.fak67  =0             #LET g_fak.fak68  =0   #MOD-780226 mark 
    LET g_fak.fak69  =0              LET g_fak.fak70  =0
    LET g_fak.fak72  =0              LET g_fak.fak73  =0
    LET g_fak.fak90  =''             #群組號碼  
    LET g_fak.fak901 =''             #群組附號   
    LET g_fak.fak91  ='N'            #更新碼      
    LET g_fak.fak92  ='N'            #利息資本化否
    LET g_fak.fakuser=g_user         #資料所有者  
    LET g_fak.fakgrup=g_grup         #資料所有部門 
    LET g_fak.fakdate=g_today        #資料更改日      #No.TQC-770096   

    LET g_fak.fak282='1'   #No:FUN-AB0088
    LET g_fak.fak232='1'   #No:FUN-AB0088
    LET g_fak.fak342='N'   #No:FUN-AB0088
    LET g_fak.fak352=0     #No:FUN-AB0088
    LET g_fak.fak362=0     #No:FUN-AB0088
 
    LET g_fak.fak43 ='0'             #資產狀態  
    LET g_fak.fak13 =g_pab.apb081    #成本分攤本幣單價
    LET g_fak.fak14 =g_pab.apb101    #成本分攤本幣成本
    LET g_fak.fak62 =g_fak.fak14     #稅簽成本    
    LET g_fak.fak15 =g_pab.apa13     #原幣幣別  
   #抓aapt110單頭匯率
    SELECT apa14 INTO l_apa14 FROM apa_file WHERE apa01=g_pab.apb01
    IF SQLCA.sqlcode THEN LET l_apa14=1 END IF
    LET g_fak.fak16 =g_pab.apb101/l_apa14
    LET g_fak.fak17 =g_pab.apb09     #數量    
    LET g_fak.fak171=0               #在外數量 
    LET g_fak.fak21 =' '             #存放位置 
    IF cl_null(g_fak.fak13)  THEN LET g_fak.fak13=0  END IF
    IF cl_null(g_fak.fak14)  THEN LET g_fak.fak14=0  END IF
    IF cl_null(g_fak.fak62)  THEN LET g_fak.fak62=0  END IF
    IF cl_null(g_fak.fak16)  THEN LET g_fak.fak16=0  END IF
    IF cl_null(g_fak.fak17)  THEN LET g_fak.fak17=0  END IF
    IF cl_null(g_fak.fak171) THEN LET g_fak.fak171=0 END IF
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01= g_fak.fak15   #MOD-A20015 add
    LET g_fak.fak16 = cl_digcut(g_fak.fak16,t_azi04)                   #MOD-A20015 add
    LET g_fak.fak25 =g_pab.apa09                     #取得日期(發票日期)
    LET g_fak.fak26 =g_pab.apa02                     #入帳日期(帳款日期)
    LET g_fak.fak68  =g_fak.fak62-g_fak.fak67        #MOD-780226 mod 

    IF g_fak.fak26 <= g_faa.faa09 THEN
       CALL s_errmsg('','',g_fak.fak01,'afa-517',1)
    END IF 
   #-----------------------------MOD-CB0047-------------------(S)
   #CALL s_faj27(g_fak.fak26,g_faa.faa15) RETURNING g_fak.fak27     #MOD-CB0047 mark
    LET l_day = DAY(g_fak.fak26)
    CALL s_yp(g_fak.fak26)
         RETURNING l_year,l_month
    LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
    LET l_date  = l_date2
    CALL s_faj27(l_date,g_faa.faa15) RETURNING g_fak.fak27  
    #str------ add by dengsy170302
    CALL s_yp(g_fak.fak26)
         RETURNING l_year,l_month
    LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
              IF g_fak.fak09='2' THEN 
                 LET g_fak.fak27=l_year USING '&&&&',l_month USING '&&'
              ELSE
                 CALL s_faj27(l_date,g_faa.faa15) RETURNING g_fak.fak27 
              END IF 
              #end------ add by dengsy170302
   #-----------------------------MOD-CB0047-------------------(E)
    LET g_fak.fak51  =g_pab.apa08           #發票號碼     #MOD-710201
    LET g_fak.fak511 =g_pab.apa09           #發票日期  
    LET g_fak.fak52  =g_pab.apa44           #傳票號碼 
   #IF g_pab.apa51 <> 'MISC' AND cl_null(g_pab.apa51)  THEN   #No.FUN-680028 #MOD-B50015 mark
   #IF cl_null(g_pab.apa51) THEN                              #MOD-B50015 #MOD-CC0256 mark
    IF cl_null(g_pab.apa51) OR g_pab.apa51 = 'STOCK' THEN     #MOD-CC0256 add
       LET g_fak.fak53  =g_pab.apb25           #資產科目      #MOD-9C0381
    ELSE
       LET g_fak.fak53  =g_pab.apa51           #資產科目      #MOD-9C0381
    END IF
    IF cl_null(g_fak.fak53) THEN LET g_fak.fak53 = g_pab.apa51 END IF
#   IF g_aza.aza63 = 'Y' THEN
   #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088        #TQC-B50042 mark
    IF g_faa.faa31 = 'Y' AND g_aza.aza63 = 'Y' THEN   #TQC-B50042
      #IF g_pab.apa511 <> 'MISC' AND cl_null(g_pab.apa511)  THEN   #No.FUN-680028 #MOD-B50015 mark
       IF cl_null(g_pab.apa511) THEN                               #MOD-B50015  
         #LET g_fak.fak531 =g_pab.apa511                           #MOD-B50015 mark 
          LET g_fak.fak531 =g_pab.apb251                           #MOD-B50015
       ELSE
         #LET g_fak.fak531 =g_pab.apb251                           #MOD-B50015 mark
          LET g_fak.fak531 =g_pab.apa511                           #MOD-B50015
       END IF
       IF cl_null(g_fak.fak531) THEN LET g_fak.fak531 = g_pab.apa511 END IF
    END IF
 
    LET g_fak.fak45 =g_pab.apb01            #帳款編號   
    LET g_fak.fak451=g_pab.apb02            #帳款編號項次
        IF g_fak.fak451 IS NULL THEN LET g_fak.fak451=0 END IF
    LET g_fak.fak46 =g_pab.apb21            #收料單號    = apb21(入庫單號)
    LET g_fak.fak461=g_pab.apb22            #收料單項次  = apb22(入庫單項次)
        IF g_fak.fak461 IS NULL THEN LET g_fak.fak461=0 END IF
    IF g_pab.apa13=g_aza.aza17 THEN

      LET g_fak.fak06=g_pab.apb27   #MOD-7C0134
    ELSE
       LET g_fak.fak06=g_pab.apb27         #MOD-980124 add
       LET g_fak.fak07=g_pab.apb27         #英文名稱  = apb27(品名)
    END IF
#   IF g_aza.aza63 = 'Y' THEN
    INITIALIZE l_fab.* TO NULL                        #TQC-B50042 
   #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088        #TQC-B50042 mark
    IF g_faa.faa31 = 'Y' AND g_aza.aza63 = 'Y' THEN   #TQC-B50042
      #DECLARE p100_fab_1 CURSOR FOR           #MOD-B50015 mark
       IF g_faa.faa02c <> g_aza.aza81 THEN               #MOD-D10052 add
          DECLARE p100_fab_1 SCROLL CURSOR FOR    #MOD-B50015
                  SELECT fab_file.* FROM fab_file WHERE fab11=g_fak.fak53  #NO:7543
                                                    AND fab111=g_fak.fak531
                                                    ORDER BY fab01         #No.FUN-B30041  add
          OPEN  p100_fab_1
#         FETCH p100_fab_1 INTO l_fab.*        #No.FUN-B30041  Mark
          FETCH FIRST p100_fab_1 INTO l_fab.*  #No.FUN-B30041  add
         #-TQC-B50042-add-
          IF SQLCA.sqlcode = 100 THEN  
             LET g_showmsg = g_fak.fak53,g_fak.fak531
             CALL s_errmsg('fak53/fak531',g_showmsg,'afai010','afa-045',1) 
             LET g_success='N'                                            
          END IF
         #-TQC-B50042-end-
          CLOSE p100_fab_1
      #-----------------------MOD-D10052----------------(S)
       ELSE
          DECLARE p100_fab_2 SCROLL CURSOR FOR
           SELECT fab_file.* FROM fab_file
            WHERE fab111 = g_fak.fak53
            ORDER BY fab01
          OPEN  p100_fab_2
          FETCH FIRST p100_fab_2 INTO l_fab.*
          IF SQLCA.sqlcode = 100 THEN
             LET g_showmsg = g_fak.fak53,g_fak.fak531
             CALL s_errmsg('fak531',g_showmsg,'afai010','afa-045',1)
             LET g_success='N'
          END IF
          CLOSE p100_fab_2
       END IF
      #-----------------------MOD-D10052----------------(E)
    ELSE
      #DECLARE p100_fab CURSOR FOR          #MOD-B50015 mark
       IF g_faa.faa02c <> g_aza.aza81 OR cl_null(g_faa.faa02c) THEN               #MOD-D10052 add
          DECLARE p100_fab SCROLL CURSOR FOR   #MOD-B50015
                  SELECT fab_file.* FROM fab_file WHERE fab11=g_fak.fak53  
                                                  ORDER BY fab01         #No.FUN-B30041  add
          OPEN  p100_fab
#         FETCH p100_fab INTO l_fab.*        #No.FUN-B30041  Mark
          FETCH FIRST p100_fab INTO l_fab.*  #No.FUN-B30041  add
         #-TQC-B50042-add-
          IF SQLCA.sqlcode = 100 THEN  
             LET g_showmsg = g_fak.fak53
             CALL s_errmsg('fak53',g_showmsg,'afai010','afa-045',1) 
             LET g_success='N'                                            
          END IF
         #-TQC-B50042-end-
          CLOSE p100_fab
      #-----------------------MOD-D10052----------------(S)
       ELSE
          DECLARE p100_fab_3 SCROLL CURSOR FOR
           SELECT fab_file.* FROM fab_file
            WHERE fab111 = g_fak.fak53
            ORDER BY fab01
          OPEN  p100_fab_3
          FETCH FIRST p100_fab_3 INTO l_fab.*
          IF SQLCA.sqlcode = 100 THEN
             LET g_showmsg = g_fak.fak53
             CALL s_errmsg('fak53',g_showmsg,'afai010','afa-045',1)
             LET g_success='N'
          END IF
          CLOSE p100_fab_3
       END IF
      #-----------------------MOD-D10052----------------(E)
    END IF
    IF SQLCA.sqlcode THEN  INITIALIZE l_fab.* TO NULL END IF
 
    LET g_fak.fak04 = l_fab.fab01  #主類別
    LET g_fak.fak28 = l_fab.fab04  #折舊方法  
        IF cl_null(g_fak.fak28) THEN LET g_fak.fak28 ='1'  END IF
    LET g_fak.fak29 = l_fab.fab05  #耐用年限
        IF cl_null(g_fak.fak29) THEN LET g_fak.fak29 =0    END IF

    #-----No:FUN-AB0088-----
    IF g_faa.faa31 = 'Y' THEN
       LET g_fak.fak282 = l_fab.fab042  #折舊方法
      #IF cl_null(g_fak.fak28) THEN LET g_fak.fak28 ='1'  END IF      #MOD-C20050 mark
       IF cl_null(g_fak.fak282) THEN LET g_fak.fak282 ='1' END IF     #MOD-C20050 add
       LET g_fak.fak292 = l_fab.fab052  #耐用年限
      #IF cl_null(g_fak.fak29) THEN LET g_fak.fak29 =0    END IF      #MOD-C20050 mark
       IF cl_null(g_fak.fak292) THEN LET g_fak.fak292 =0 END IF       #MOD-C20050 add
       LET g_fak.fak531 = l_fab.fab111                    #TQC-B50042
    END IF
    #-----No:FUN-AB0088 END-----

    LET g_fak.fak30 = g_fak.fak29  #未用年限
    LET g_fak.fak33 = g_fak.fak14  #未折減額

    #-----No:FUN-AB0088-----
    LET g_fak.fak302 =0               #未耐用年限
    LET g_fak.fak312 =0               #預留殘值
    LET g_fak.fak322 =0               #累積折舊
    LET g_fak.fak332 =0               #未折減額額
    LET g_fak.fak1412 =0
    LET g_fak.fak572  =0
    LET g_fak.fak5712 =0
   #LET g_fak.fak142 = g_fak.fak14    #成本分攤本幣成本 #MOD-B50064 mark
   #LET g_fak.fak143 = g_fak.fak15    #本幣幣別         #MOD-B50064 mark
   #LET g_fak.fak144 = g_fak.fak16    #匯率             #MOD-B50064 mark
   #-MOD-B50064-add-
    SELECT aaa03,azi04 INTO g_fak.fak143,l_azi04
      FROM aaa_file,azi_file
     WHERE aaa01 = g_faa.faa02c
       AND aaa03 = azi01
    CALL s_newrate(g_aza.aza81,g_faa.faa02c,g_fak.fak15,l_apa14,g_fak.fak26) RETURNING g_fak.fak144
    LET g_fak.fak144 = cl_digcut(g_fak.fak144,l_azi04)  #CHI-C60010 add
    LET g_fak.fak142 = g_fak.fak16 * g_fak.fak144 
    LET g_fak.fak142 = cl_digcut(g_fak.fak142,l_azi04) 
   #-MOD-B50064-end-
    LET g_fak.fak262 = g_fak.fak26                     #入帳日期(帳款日期)
    #LET g_fak.fak272 = g_fak.fak27                     #入帳日期(帳款日期)
   #-----------------------------MOD-CB0047-------------------(S)
   #CALL s_faj27(g_fak.fak26,g_faa.faa152) RETURNING g_fak.fak272  #No:FUN-B60140 #MOD-CB0047 mark
    LET l_day = DAY(g_fak.fak26)
    CALL s_yp(g_fak.fak26)
         RETURNING l_year,l_month
    LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
    LET l_date  = l_date2
    CALL s_faj27(l_date,g_faa.faa152) RETURNING g_fak.fak272
   #-----------------------------MOD-CB0047-------------------(E)
    LET g_fak.fak302 = g_fak.fak292  #未用年限
    LET g_fak.fak332 = g_fak.fak142  #未折減.
    #-----No:FUN-AB0088 END-----

    IF g_aza.aza26 = '2' THEN                                                   
       IF g_fak.fak28 MATCHES '[05]' THEN                                       
          LET g_fak.fak31 = 0         
         #LET g_fak.fak312= 0   #No:FUN-AB0088 #MOD-B50064 mark 
       ELSE                                                                     
#          LET g_fak.fak31 = (g_fak.fak14-g_fak.fak32)*l_fab.fab23/100            #MOD-A40033 mark 
           LET g_fak.fak31 = g_fak.fak14*l_fab.fab23/100            #MOD-A40033 
           #-----No:FUN-AB0088-----
          #-MOD-B50064-mark-
          #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
          #   LET g_fak.fak312 = g_fak.fak142*l_fab.fab232/100        #MOD-A40033
          #END IF
          #-MOD-B50064-end-
           #-----No:FUN-AB0088 END-----
       END IF  
      #-MOD-B50064-add-  
       IF g_faa.faa31 = 'Y' THEN                                                               
          IF g_fak.fak282 MATCHES '[05]' THEN                                       
             LET g_fak.fak312= 0 
          ELSE                                                                     
             LET g_fak.fak312 = g_fak.fak142*l_fab.fab232/100    
          END IF  
       END IF  
      #-MOD-B50064-end-                                                                 
    ELSE  
       CASE g_fak.fak28
         WHEN '0'   LET g_fak.fak31 = 0
         WHEN '1'   LET g_fak.fak31 =
                       (g_fak.fak14-g_fak.fak32)/(g_fak.fak29 + 12)*12
         WHEN '2'   LET g_fak.fak31 = 0
         WHEN '3'   LET g_fak.fak31 = (g_fak.fak14-g_fak.fak32)/10
         WHEN '4'   LET g_fak.fak31 = 0
         WHEN '5'   LET g_fak.fak31 = 0
         OTHERWISE EXIT CASE
       END CASE
      #-MOD-B50064-add-  
       IF g_faa.faa31 = 'Y' THEN                                                               
          CASE g_fak.fak282
            WHEN '0'   LET g_fak.fak312 = 0
            WHEN '1'   LET g_fak.fak312 = (g_fak.fak142-g_fak.fak322)/(g_fak.fak292 + 12)*12
            WHEN '2'   LET g_fak.fak312 = 0
            WHEN '3'   LET g_fak.fak312 = (g_fak.fak142-g_fak.fak322)/10
            WHEN '4'   LET g_fak.fak312 = 0
            WHEN '5'   LET g_fak.fak312 = 0
            OTHERWISE EXIT CASE
          END CASE
       END IF  
      #-MOD-B50064-end-                                                                 
       #-----No:FUN-AB0088-----
      #-MOD-B50064-mark-
      #IF g_faa.faa31 = 'Y' THEN
      #   LET g_fak.fak312 = g_fak.fak31
      #END IF
      #-MOD-B50064-end-
       #-----No:FUN-AB0088 END-----
    END IF
    LET g_fak.fak31 = cl_digcut(g_fak.fak31,g_azi04)   #MOD-780174 
    LET g_fak.fak312= cl_digcut(g_fak.fak312,l_azi04)   #No:FUN-AB0088 #MOD-B50064 mod g -> l
    LET g_fak.fak33 = g_fak.fak14 - g_fak.fak32
    LET g_fak.fak34 = l_fab.fab08  #折畢再提否
        IF cl_null(g_fak.fak34) THEN LET g_fak.fak34 ='N'  END IF
    LET g_fak.fak71 = g_fak.fak34  #稅簽折畢再提否        #MOD-A10193 add
    LET g_fak.fak36 = l_fab.fab10  #折畢再提年限
        IF cl_null(g_fak.fak36) THEN LET g_fak.fak36 = 0   END IF
    LET g_fak.fak37 = l_fab.fab14  #直接資本化
        IF cl_null(g_fak.fak37) THEN LET g_fak.fak37 = 'Y' END IF
    LET g_fak.fak38 = l_fab.fab15  #保稅否  
        IF cl_null(g_fak.fak38) THEN LET g_fak.fak38 = '0' END IF
    LET g_fak.fak39 = l_fab.fab16  #保險否 
        IF cl_null(g_fak.fak39) THEN LET g_fak.fak39 = '0' END IF
    LET g_fak.fak40 = l_fab.fab17  #免稅否 
        IF cl_null(g_fak.fak40) THEN LET g_fak.fak40 = '0' END IF
    LET g_fak.fak41 = l_fab.fab18  #抵押否 
        IF cl_null(g_fak.fak41) THEN LET g_fak.fak41 = '0' END IF
    LET g_fak.fak42 = l_fab.fab19  #投資抵減否
        IF cl_null(g_fak.fak42) THEN LET g_fak.fak42 = '0' END IF
    LET g_fak.fak421= l_fab.fab20  #本幣投資抵減比率=0
        IF cl_null(g_fak.fak421) THEN LET g_fak.fak421 = 0 END IF
    LET g_fak.fak422=l_fab.fab21  #外幣投資抵減比率
        IF cl_null(g_fak.fak422) THEN LET g_fak.fak422 = 0 END IF
    LET g_fak.fak423=l_fab.fab22  #投資抵減補稅年限
        IF cl_null(g_fak.fak423) THEN LET g_fak.fak423 = 0 END IF
    LET g_fak.fak61 =l_fab.fab06  #稅簽折舊方法
        IF cl_null(g_fak.fak61) THEN LET g_fak.fak61 = '1' END IF
    LET g_fak.fak64 =l_fab.fab07  #稅簽耐用年限
        IF cl_null(g_fak.fak64) THEN LET g_fak.fak64 =0    END IF
    LET g_fak.fak65 = g_fak.fak64   
    IF g_aza.aza26 = '2' THEN                                                   
       IF g_fak.fak61 MATCHES '[05]' THEN                                       
          LET g_fak.fak66 = 0                                                   
       ELSE                                                                     
#          LET g_fak.fak66 = (g_fak.fak62-g_fak.fak67)*l_fab.fab23/100    #MOD-A40033 mark         
           LET g_fak.fak66 = g_fak.fak62*l_fab.fab23/100    #MOD-A40033 
       END IF                                                                   
    ELSE  
       CASE g_fak.fak61
         WHEN '0'   LET g_fak.fak66 = 0
         WHEN '1'   LET g_fak.fak66 =
                       (g_fak.fak62-g_fak.fak67)/(g_fak.fak64 + 12)*12
         WHEN '2'   LET g_fak.fak66 = 0
         WHEN '3'   LET g_fak.fak66 = (g_fak.fak62-g_fak.fak67)/10
         WHEN '4'   LET g_fak.fak66 = 0
         WHEN '5'   LET g_fak.fak66 = 0
         OTHERWISE EXIT CASE
       END CASE
    END IF
    LET g_fak.fak66 = cl_digcut(g_fak.fak66,g_azi04)    
    #--->廠商檔擷取
    LET g_fak.fak10 =g_pab.apa05         #供應商  
    LET g_fak.fak11 =g_pab.apa05         #製造廠商  
    LET g_fak.fak47 =g_pab.apb06         #採購單    
    LET g_fak.fak471=g_pab.apb07         #採購單項次 
    LET g_fak.fak49 =g_pab.alk01         #進口編號 
    #--->請購/採購檔擷取(預算編號/請購員/部門)
    IF cl_null(g_fak.fak47) THEN   #NO:4220 
        LET g_fak.fak47=' '
    END IF
    IF cl_null(g_fak.fak471) THEN  
        LET g_fak.fak471= 0
    END IF                        

   #fak20原本抓取請購部門改用請款部門(apa22 OR apb26), fak19原本抓取請購人員改抓應付單頭「人員」
    LET l_sql ="SELECT pmn07 ", #No.FUN-840006 去掉pmn07字段
              #"  FROM pmn_file ",    #FUN-9A0093    #FUN-A60056
               "  FROM ",cl_get_target_table(g_pab.apb37,'pmn_file'),   #FUN-A60056
               " WHERE pmn01='",g_fak.fak47,"' AND pmn02='", g_fak.fak471,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  ##FUN-980092 GP5.2 add  #FUN-A70139
         CALL cl_parse_qry_sql(l_sql,g_pab.apb37) RETURNING l_sql  ##FUN-A70139
    PREPARE p100_prepare2 FROM l_sql
    DECLARE p100_cs2 CURSOR WITH HOLD FOR p100_prepare2
    FOREACH p100_cs2 INTO g_fak.fak18              #No.FUN-840006 去掉g_fak.fak50字段
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)  #add
       END IF
    END FOREACH
    IF NOT cl_null(g_pab.apb26) THEN
       LET g_fak.fak20=g_pab.apb26
       IF g_pab.apa22= g_pab.apb26  THEN 
          LET g_fak.fak19= g_pab.apa21
       ELSE
          LET g_fak.fak19= null
       END IF
    ELSE
       LET g_fak.fak20=g_pab.apa22
       LET g_fak.fak19=g_pab.apa21
    END IF
    #--->工廠基本檔擷取
    LET g_fak.fak22 = g_pab.apb37
    LET g_fak.fak44 = g_pab.apb37
    #--->入庫檔收料日期  
    LET l_sql="SELECT rvv04,rvv09,rvv35 ",
             #"  FROM rvv_file", #FUN-9A0093   #FUN-A60056
              "  FROM ",cl_get_target_table(g_pab.apb37,'rvv_file'),   #FUN-A60056
              " WHERE rvv01='",g_fak.fak46,"' AND rvv02='",g_fak.fak461,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  ##FUN-980092 GP5.2 add  #FUN-A70139
         CALL cl_parse_qry_sql(l_sql,g_pab.apb37) RETURNING l_sql  ##FUN-A70139
    PREPARE p100_prepare3 FROM l_sql
    DECLARE p100_cs3 CURSOR WITH HOLD FOR p100_prepare3
    FOREACH p100_cs3 INTO l_rvv04,g_fak.fak462,g_fak.fak18
           IF SQLCA.sqlcode THEN 
              LET g_fak.fak462 = ' ' LET g_fak.fak18 = ' '
           END IF 
    END FOREACH
    IF cl_null(g_fak.fak18) THEN LET g_fak.fak18 = g_pab.apb28 END IF
    #--->I/P NO(進口報單)
    LET l_sql="SELECT rva08,rva04 ", 
             #"  FROM rva_file", #FUN-9A0093   #FUN-A60056
              "  FROM ",cl_get_target_table(g_pab.apb37,'rva_file'),   #FUN-A6005.
              " WHERE rva01 = '",l_rvv04,"' AND rvaconf <> 'X'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  ##FUN-980092 GP5.2 add   #FUN-A70139
         CALL cl_parse_qry_sql(l_sql,g_pab.apb37) RETURNING l_sql  ##FUN-A70139
    PREPARE p100_prepare4 FROM l_sql
    DECLARE p100_cs4 CURSOR WITH HOLD FOR p100_prepare4
    FOREACH p100_cs4 INTO g_fak.fak48,l_rva04
           IF SQLCA.sqlcode THEN LET g_fak.fak48 = ' ' END IF 
    END FOREACH
    IF l_rva04 ='Y' THEN    #L/C收料='Y' 
       LET g_fak.fak51 = g_fak.fak46 
    END IF 
    #--->依參數擷取科目 (2.依部門  1.依資產)
    IF g_faa.faa20 = '2' THEN  
        DECLARE p100_fbi CURSOR FOR SELECT fbi02 FROM fbi_file 
                                       WHERE fbi01= g_fak.fak20
                                         AND fbi03= g_fak.fak04
           FOREACH p100_fbi INTO l_fbi02
              IF SQLCA.sqlcode THEN LET l_fbi02 = ' ' END IF
              IF not cl_null(l_fbi02) THEN EXIT FOREACH  END IF
           END FOREACH 
           LET g_fak.fak54 = l_fab.fab12   #累折科目   
           LET g_fak.fak55 = l_fbi02       #折舊科目
        #  IF g_aza.aza63='Y' THEN
           IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
              DECLARE p100_fbi_1 CURSOR FOR SELECT fbi021 FROM fbi_file 
                                          WHERE fbi01= g_fak.fak20
                                            AND fbi03= g_fak.fak04
              FOREACH p100_fbi_1 INTO l_fbi021
                 IF SQLCA.sqlcode THEN LET l_fbi021 = ' ' END IF
                 IF not cl_null(l_fbi021) THEN EXIT FOREACH  END IF
              END FOREACH 
              LET g_fak.fak541 = l_fab.fab121
              LET g_fak.fak551 = l_fbi021
           END IF
     ELSE                          
           LET g_fak.fak54 = l_fab.fab12 
           LET g_fak.fak55 = l_fab.fab13
        #  IF g_aza.aza63='Y' THEN
           IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
              LET g_fak.fak541 = l_fab.fab121 
              LET g_fak.fak551 = l_fab.fab131
           END IF
     END IF

    LET g_fak.fak23 = '1'
 
 #FUN-930054---add---start--- #若要使用利潤中心功能，則fak24=gem10
    IF g_aaz.aaz90 = 'Y' THEN
       SELECT gem10 INTO g_fak.fak24 FROM gem_file WHERE gem01 = g_fak.fak20
    ELSE                      #若不使用利潤中心功能，則fak24=fak20(保管部門)
       LET g_fak.fak24 = g_fak.fak20
    END IF
 
    LET g_fak.fakoriu = g_user      #No.FUN-980030 10/01/04
    LET g_fak.fakorig = g_grup      #No.FUN-980030 10/01/04

    #-----No:FUN-AB0088-----
    IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
      #LET g_fak.fak332 = g_fak.fak33   #MOD-B50064 mark
       LET g_fak.fak342 = l_fab.fab082  #折畢再提否
       IF cl_null(g_fak.fak342) THEN LET g_fak.fak342 ='N'  END IF
       LET g_fak.fak362 = l_fab.fab102  #折畢再提年限
       IF cl_null(g_fak.fak362) THEN LET g_fak.fak362 = 0   END IF
       LET g_fak.fak232 = '1'
       LET g_fak.fak242 = g_fak.fak24
    END IF
    #-----No:FUN-AB0088 END-----
#zhouxm170220 add start
    IF g_fak.fak53='170101' THEN 
       LET g_fak.fak09 ='2' 
    END IF    
#zhouxm170220 add end 
    #str------ add by dengsy170302
    CALL s_yp(g_fak.fak26)
         RETURNING l_year,l_month
    LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
              IF g_fak.fak09='2' THEN 
                 LET g_fak.fak27=l_year USING '&&&&',l_month USING '&&'
                 LET g_fak.fak272= g_fak.fak27
              ELSE
                 CALL s_faj27(l_date,g_faa.faa15) RETURNING g_fak.fak27 
                 CALL s_faj27(l_date,g_faa.faa152) RETURNING g_fak.fak272
              END IF 
              #end------ add by dengsy170302
    INSERT INTO fak_file VALUES(g_fak.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg = g_fak.fak01,"/",g_fak.fak02                       #No.FUN-710028
       CALL s_errmsg('fak01,fak02',g_showmsg,'insert err','afa-502',1)   #No.FUN-710028
       LET g_success='N'
    END IF
    LET g_cnt = g_cnt + 1
    IF g_cnt = 1 THEN LET g_start_no = g_fak.fak01 END IF
END FUNCTION

FUNCTION p100_process()
   DEFINE l_fak01_max     LIKE fak_file.fak01   #MOD-880147 add
   DEFINE l_fak01_min     LIKE fak_file.fak01   #MOD-880147 add
   DEFINE l_i,l_j         LIKE type_file.num5   #MOD-940086 add
   DEFINE l_cnt           LIKE type_file.num10  #No.MOD-BC0064
   DEFINE l_apa00         LIKE apa_file.apa00   #No.MOD-BC0064
 
   LET g_wc1 = g_wc
   LET l_j=g_wc1.getLength()
   FOR l_i=1 TO l_j-5
      IF g_wc1.subString(l_i,l_i+4) ="apa51" THEN
         LET g_wc2=g_wc1.subString(1,l_i-1) CLIPPED," apb25",
                   g_wc1.subString(l_i+5,l_j) CLIPPED
         LET g_wc1=g_wc2 CLIPPED
      END IF
   END FOR
   FOR l_i=1 TO l_j-5
      IF g_wc.subString(l_i,l_i+5)="apa511" THEN
         LET g_wc1=g_wc1 CLIPPED," AND apa511 IS NULL"
      ELSE
         IF g_wc.subString(l_i,l_i+4)="apa51" THEN
            LET g_wc1=g_wc1 CLIPPED," AND apa51 IS NULL"
         END IF
      END IF
   END FOR
   IF g_wc1 = g_wc THEN
      LET g_wc1 = " 1=1"
   END IF
 
   CALL s_showmsg_init()   #No.FUN-710028

      IF g_wc1 = " 1=1" THEN
         LET g_sql="SELECT apa00,apa05,apa13,apa22,apa02,apa09,apa44,apa51,apb25,",  #No.MOD-BC0064
                    " apa08,'',apb07,apb06,apb22,apb21,apb02,apb01,",      
                    " apb09,apb24,apb10,apb08,apb101,apb081,apb28,apb27,apb23,apa16,azi04,apa511,apb251,",    
                    " apb26,apa21 ",                                      
                    "  FROM apa_file LEFT OUTER JOIN azi_file ON azi_file.azi01 = apa13,apb_file ",  #FUN-9A0093
                    " WHERE ",g_wc CLIPPED ,                             
                    "   AND apb01=apa01 ",
                    "   AND apa42='N' ",
                    "   AND apa41='Y' ",             
                    " ORDER BY apb01,apb02"      
      ELSE                    
      LET g_sql="SELECT apa00,apa05,apa13,apa22,apa02,apa09,apa44,apa51,apb25,",  #No.MOD-BC0064
                    " apa08,'',apb07,apb06,apb22,apb21,apb02,apb01,",      #MOD-710201
                    " apb09,apb24,apb10,apb08,apb101,apb081,apb28,apb27,apb23,apa16,azi04,apa511,apb251,",   #FUN-590129  #No.FUN-680028  
                    " apb26,apa21,apb37 ",                         #MOD-780217 add apb26,apa21   #FUN-9A0093 add apb37
                    "  FROM apa_file LEFT OUTER JOIN azi_file ON azi_file.azi01 = apa13,apb_file ",   #FUN-9A0093 
                    " WHERE ((",g_wc CLIPPED ,") OR (",g_wc1 CLIPPED ,"))",  #MOD-940086
                    "   AND apb01=apa01 ",
                    "   AND apa42='N' ",
                    "   AND apa41='Y' ",              #No.MOD-830245 add
                    " ORDER BY apb01,apb02"
      END IF                                          #TQC-950131--Add                    
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 
      PREPARE p100_prepare1 FROM g_sql
      DECLARE p100_cs1 CURSOR WITH HOLD FOR p100_prepare1
      LET g_cnt =0                 #No.TQC-950137
      FOREACH p100_cs1 INTO g_pab.*
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','p100_cs1:',STATUS,0) #No.FUN-710028
            LET g_success = 'N'                       #No.FUN-8A0086
            EXIT FOREACH 
         END IF
         IF g_bgjob = 'N' THEN            #FUN-570144   050919
             message g_pab.apb01,' ',g_pab.apb02
             CALL ui.Interface.refresh()
         END IF
 
            #因為大陸之固定資產稅額不可扣抵營業稅, 故以含稅金額列帳
            IF g_aza.aza26 = '2' THEN
               LET g_pab.apb08 = g_pab.apb08 * (1+g_pab.apa16/100)   #本幣單價
               LET g_pab.apb08 = cl_digcut(g_pab.apb08,g_azi03)
               LET g_pab.apb10 = g_pab.apb08 * g_pab.apb09           #本幣金額
               LET g_pab.apb10 = cl_digcut(g_pab.apb10,g_azi04)
               LET g_pab.apb23 = g_pab.apb23 * (1+g_pab.apa16/100)   #原幣單價
               LET g_pab.apb24 = g_pab.apb23 * g_pab.apb09           #原幣金額
               LET g_pab.apb24 = cl_digcut(g_pab.apb24,g_pab.azi04)
            END IF
            #No.MOD-BC0064  --Begin
            #冲暂估的AP已经转过固资,UNAP不能再转
            IF g_pab.apa00 = '16' OR g_pab.apa00 = '26' THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM fak_file
                WHERE fak46 = g_pab.apb01
                  AND fak461= g_pab.apb02
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  LET g_showmsg = g_pab.apb01,'/',g_pab.apb02
                  CALL s_errmsg('apb01,apb02',g_showmsg,'unap carry:','afa-388',1)
                  CONTINUE FOREACH
               END IF
            ELSE
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM fak_file
                WHERE fak45 = g_pab.apb21
                  AND fak451= g_pab.apb22
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               LET l_apa00 = NULL
               SELECT apa00 INTO l_apa00 FROM apa_file,apb_file
                WHERE apa01 = apb01
                  AND apb01 = g_pab.apb21
                  AND apb02 = g_pab.apb22
               IF l_cnt > 0 AND (l_apa00 = '16' OR l_apa00 = '26') THEN
                  LET g_showmsg = g_pab.apb21,'/',g_pab.apb22
                  CALL s_errmsg('apb01,apb02',g_showmsg,'duplicate carry:','afa-388',1)
                  CONTINUE FOREACH
               END IF
            END IF
            #No.MOD-BC0064  --End  
         CALL p100_ins()
         IF g_success = 'N' THEN
            EXIT FOREACH     
         END IF
      END FOREACH
  #----------------MOD-C70267-------------------(S)
   IF g_cnt = 0 THEN
      LET g_success = "N"
      CALL cl_err('','aap-129',1)
      RETURN
   END IF
  #----------------MOD-C70267-------------------(E)
 
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   IF g_success = 'Y' AND g_cnt > 0 THEN 
      IF g_faa.faa19 = 'Y' THEN
         SELECT MAX(fak01),MIN(fak01) INTO l_fak01_max,l_fak01_min
           FROM fak_file
         #抓取LENGTH(MAX(fak01))與LENGTH(MIN(fak01))比對,
         #若不相同提示警訊不可異動
         #例:若MAX(fak01)為0000000002,MIN(fak01)為01,表示長度不同,不可異動
         IF LENGTH(l_fak01_max) != LENGTH(l_fak01_min) THEN
            #系統中已用最大序號與最小序號之長度不同,不可異動!
            CALL cl_err('','afa-190',1)
            LET g_success="N"
            RETURN
         END IF
         UPDATE faa_file SET faa191 = g_fak.fak01 WHERE faa00 = '0'
      END IF
      CALL cl_cmmsg(1) COMMIT WORK 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 10 LET p_col = 30
      ELSE
         LET p_row = 10 LET p_col = 14
      END IF
      OPEN WINDOW p100_w2 AT p_row,p_col WITH FORM "afa/42f/afap100_1"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afap100_1")
 
   CALL cl_ui_locale("afap100_1")
# END genero shell script ADD
################################################################################
      LET g_end_no = g_fak.fak01
      DISPLAY BY NAME g_cnt,g_start_no,g_end_no
      CALL cl_end(20,20)
      CLOSE WINDOW p100_w2
   ELSE  
      CALL cl_rbmsg(1) ROLLBACK WORK CALL cl_end(20,20) RETURN
   END IF
END FUNCTION 
#No.FUN-9C0077 程式精簡
