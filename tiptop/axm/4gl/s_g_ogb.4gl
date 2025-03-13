# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: s_g_ogb.4gl
# Descriptions...: 出貨通知單轉出貨單作業(倉儲批-選擇)
# Date & Author..: 96/04/01 By Roger
# Remark ........: 本 function 請加入 axmp620 call s_g_ogb(g_no1,g_no2)
# Modify.........: No:7099 03/08/19 By Mandy 若通知單有兩個一樣料號時第二個計算已轉數量會有問題
# Modify.........: No.FUN-540049 05/05/20 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-640280 06/04/11 By Sarah 未轉數量(g_a_ogb12)計算錯誤
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-710046 07/01/22 By cheunl 錯誤訊息匯整
# Modify.........: No.MOD-720003 07/02/01 By jamie 使用計價單位,但不使用雙單位時,出通單轉出貨單,數量正確，計價數量錯誤. 
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-870148 08/08/01 By xiaofeizhu "轉出貨單"：如出通單需做批/序號管理(oaz81="Y")且料件需做批/序號管理，則一并拋轉單身批/序號資料
# Modify.........: No.TQC-960033 09/06/05 By lilingyu 彈出對話框,維護"出貨數量"的欄位,沒有對輸入負數控管,同時輸入負數拋轉不成功,之后顯示運行成功
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No:MOD-A60007 10/06/08 By Smapmin 出貨合計數未清空
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga55,ogb50欄位預設值修正
# Modify.........: No:MOD-B70109 11/07/19 By JoHung 產生底稿時，在單身最後加上一筆倉儲批為空白的資料
# Modify.........: No:TQC-B90236 11/10/28 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   s_lotout程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1 
# Modify.........: No:FUN-BB0086 12/01/14 By tanxc 增加數量欄位小數取位  
# Modify.........: No:MOD-C10225 12/02/09 By jt_chen axmp620轉出貨單時,ogb03項次直接給出通單項次
# Modify.........: No:MOD-C60001 12/06/08 By Elise CALL s_lotout的第三個參數l_ac是指選到的批序號為第三個項次
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:MOD-CA0053 12/10/08 By jt_chen 原MOD-C10225,原MOD-C10225的問題於QC單對應到的是用出貨單號項次,非出通單號項次
# Modify.........: No:MOD-CB0001 12/11/09 By jt_chen 增加判斷是否有指定儲位與批號
# Modify.........: No:FUN-C30086 12/11/19 By Sakura 出貨通知單開窗需可篩選出多角貿易出貨通知單單號
# Modify.........: No:MOD-D20054 13/02/07 By bart tlf13='axmt820'的程式段Mark

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chr  	  LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_oga      RECORD LIKE oga_file.*
DEFINE g_ogb      RECORD LIKE ogb_file.*
DEFINE g_img	  DYNAMIC ARRAY OF RECORD
                    img02	LIKE img_file.img02,
                    img03	LIKE img_file.img03,
                    img04	LIKE img_file.img04,
                    img10	LIKE img_file.img10,  #No:8722
                    alocat	LIKE img_file.img10,  #No:8722
                    atp   	LIKE img_file.img10,  #No:8722
                    shipqty     LIKE img_file.img10  #No:8722
                  END RECORD,
       l_ac,l_sl    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_cnt        LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_buf        LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(20)
       g_no         LIKE oea_file.oea01,    #No.FUN-680137  VARCHAR(16),           #No.FUN-550070           
       g_ship_no    LIKE oea_file.oea01,  #No.FUN-680137  VARCHAR(16),           #No.FUN-550070
       g_a_ogb12    LIKE ogb_file.ogb12,#已轉數量
       g_n_ogb12    LIKE ogb_file.ogb12 #未轉數量
#      g_errno      LIKE faj_file.faj02        #No.FUN-680137  VARCHAR(10)
DEFINE img10_t,alocat_t,atp_t,shipqty_t LIKE img_file.img10  #No:8722
DEFINE i,j,k	LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_r         LIKE type_file.chr1     #No.FUN-870148
DEFINE g_qty       LIKE ogb_file.ogb12     #No.FUN-870148
 
FUNCTION s_g_ogb(p_no,p_ship_no)
   DEFINE p_no		LIKE oea_file.oea01    #No.FUN-680137  VARCHAR(16)        #No.FUN-550070
   DEFINE p_ship_no	LIKE oea_file.oea01    #No.FUN-680137  VARCHAR(16)        #No.FUN-550070
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF p_no IS NULL THEN RETURN END IF
   LET g_no      = p_no 
   LET g_ship_no = p_ship_no 
 
   LET p_row = 7 LET p_col = 2 
   OPEN WINDOW s_g_ogb_w AT p_row,p_col WITH FORM "sub/42f/s_g_ogb"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("s_g_ogb")
   
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_ship_no
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01=g_oga.oga23        #No.CHI-6A0004
   DISPLAY g_ship_no TO ship_no
   DECLARE s_g_ogb_c CURSOR FOR
       SELECT * FROM ogb_file WHERE ogb01=g_no ORDER BY ogb03
#  BEGIN WORK LET g_success='Y'
 
 
   FOREACH s_g_ogb_c INTO g_ogb.*
      DISPLAY BY NAME g_ogb.ogb01,g_ogb.ogb03,
                      g_ogb.ogb31,g_ogb.ogb32,
                      g_ogb.ogb04,g_ogb.ogb05,
                      g_ogb.ogb09,
                      g_ogb.ogb12
 
#      LET g_success='N'
 
      #BugNo:5235
      SELECT SUM(ogb12) 
        INTO g_a_ogb12              #已轉數量
        FROM oga_file, ogb_file
       WHERE oga01    = ogb01
         AND oga011   = p_no        #出貨通知單
        #AND oga09 IN ('2','8')     #No.FUN-610020 #FUN-C30086 mark
         AND oga09 IN ('2','4','6','8') #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
         AND ogb31    = g_ogb.ogb31 #No:7099
         AND ogb32    = g_ogb.ogb32 #No:7099
         AND ogb04    = g_ogb.ogb04 #產品編號
         AND ogaconf != 'X'         #No:5445
         AND ogb09    = g_ogb.ogb09    #MOD-640280 add
         AND ogb091   = g_ogb.ogb091   #MOD-640280 add
         AND ogb092   = g_ogb.ogb092   #MOD-640280 add
 
      IF cl_null(g_a_ogb12) THEN 
          LET g_a_ogb12 = 0
      END IF
      IF cl_null(g_ogb.ogb12) THEN 
          LET g_ogb.ogb12 = 0
      END IF
 
      #未轉數量
      LET g_n_ogb12 = g_ogb.ogb12 - g_a_ogb12
      IF g_n_ogb12 = 0 THEN 
          #此出貨通知單的所有料件早已轉成出貨單,異動更新不成功!
         #LET g_errno='axm-123' mandy
          CONTINUE FOREACH 
      END IF
      DISPLAY g_a_ogb12,g_n_ogb12 TO FORMONLY.a_ogb12,FORMONLY.n_ogb12
 
      LET g_success='Y' #代表此出貨通知單尚有料件未轉成出貨單! 
      LET g_errno=''
 
      CALL s_g_ogb_1()
      IF g_success='N' THEN EXIT FOREACH END IF
 
   END FOREACH
   CLOSE WINDOW s_g_ogb_w
   IF NOT cl_null(g_errno) THEN 
#No.FUN-710046--------------------------begin---------------------------
      IF g_bgerr THEN
         CALL s_errmsg('','',g_no,g_errno,0)
      ELSE
         CALL cl_err(p_no,g_errno,1)
      END IF
#No.FUN-710046--------------------------End----------------------------
 
   END IF
END FUNCTION
 
FUNCTION s_g_ogb_1()
   DEFINE l_sql		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(600)
   MESSAGE "Wait..." 
   LET l_sql=
      "SELECT img02,img03,img04,img10,0,0,0",
      "  FROM img_file",
      " WHERE img01='",g_ogb.ogb04,"' AND img10>=0"
 
   IF g_ogb.ogb09 IS NOT NULL AND g_ogb.ogb09 <>' ' THEN   # 若有指定倉庫
      LET l_sql=l_sql CLIPPED," AND img02='",g_ogb.ogb09,"'"
   END IF
 
   #MOD-CB0001 -- add start --
   IF g_ogb.ogb091 IS NOT NULL AND g_ogb.ogb091 <>' ' THEN   # 若有指定儲位
      LET l_sql=l_sql CLIPPED," AND img03='",g_ogb.ogb091,"'"
   END IF
   IF g_ogb.ogb092 IS NOT NULL AND g_ogb.ogb092 <>' ' THEN   # 若有指定批號
      LET l_sql=l_sql CLIPPED," AND img04='",g_ogb.ogb092,"'"
   END IF
   #MOD-CB0001 -- add end --

   PREPARE s_g_ogb_p1 FROM l_sql
   DECLARE s_g_ogb_c1 CURSOR FOR s_g_ogb_p1
 
   LET img10_t=0 
   LET alocat_t=0
   LET atp_t=0
   CALL g_img.clear()
   LET i = 1
 
   FOREACH s_g_ogb_c1 INTO g_img[i].*
      SELECT SUM(ogb12) INTO g_img[i].alocat FROM ogb_file,oga_file
       WHERE ogb04 =g_ogb.ogb04
         AND ogb09 =g_img[i].img02
         AND ogb091=g_img[i].img03
         AND ogb092=g_img[i].img04
         AND ogb01=oga01
        #AND ((oga09='1' AND oga011 IS NULL) OR		# 出貨通知未轉出貨  #FUN-C30086 mark
         AND ((oga09 IN ('1','5') AND oga011 IS NULL) OR # 出貨通知未轉出貨 #FUN-C30086 add 5.多角出貨通知單
             #(oga09 IN ('2','8')  AND ogapost = 'N' ))	# 出貨單未扣帳  #No.FUN-610020 #FUN-C30086 mark
              (oga09 IN ('2','4','6','8')  AND ogapost = 'N' ))     # 出貨單未扣帳  #No.FUN-610020 #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
 
      IF cl_null(g_img[i].alocat) THEN 
         LET g_img[i].alocat=0
      END IF
 
      LET g_img[i].atp=g_img[i].img10-g_img[i].alocat
      LET img10_t=img10_t+g_img[i].img10
      LET alocat_t=alocat_t+g_img[i].alocat
      LET atp_t   =atp_t   +g_img[i].atp
 
      LET i = i + 1
 
      IF i > g_max_rec THEN
#No.FUN-710046--------------------------begin---------------------------                                                            
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','',"9035",0)                                                                                        
      ELSE                                                                                                                          
         CALL cl_err( '', 9035, 0 )
      END IF                                                                                                                        
#No.FUN-710046--------------------------End----------------------------
	 EXIT FOREACH
      END IF
 
   END FOREACH
   #MOD-B70109 add --start--
   IF g_ogb.ogb04[1,4]='MISC' THEN
      LET g_img[i].img02=''
      LET g_img[i].img03=''
      LET g_img[i].img04=''
      LET g_img[i].img10=0
      LET g_img[i].alocat=0
      LET g_img[i].atp=0
      LET g_img[i].shipqty=0
      LET i = i + 1
   END IF
   #MOD-B70109 add --end--
   CALL g_img.deleteElement(i)
   DISPLAY BY NAME img10_t,alocat_t,atp_t
   LET g_rec_b =(i-1) DISPLAY i TO cn2
 
   MESSAGE ""
   CALL s_g_ogb_b()
 
END FUNCTION
 
FUNCTION s_g_ogb_b()
 #-----MOD-A60007---------
 LET shipqty_t=0
 DISPLAY BY NAME shipqty_t
 #-----END MOD-A60007-----

 WHILE TRUE
   INPUT ARRAY g_img WITHOUT DEFAULTS FROM s_img.* 
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
     BEFORE ROW
       LET i = ARR_CURR() 
       LET j = SCR_LINE()
       LET l_ac = ARR_CURR()                                   #FUN-870148
       
     AFTER FIELD shipqty                                                   #FUN-870148
#TQC-960033 --begin--
        IF g_img[i].shipqty < 0 THEN 
           CALL cl_err('','asf-209',0)
           NEXT FIELD shipqty
        END IF 
#TQC-960033  --end--      
       IF NOT cl_null(g_img[i].shipqty) OR g_img[i].shipqty <> 0 THEN      #FUN-870148     
          CALL p620_ins_rvbs()                                             #FUN-870148
       END IF                                                              #FUN-870148
 
     AFTER ROW      
       CALL s_g_ogb_b_tot()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG=0
      LET g_success='N'
      EXIT WHILE
   END IF
 
   #BugNo:5235
   #出貨數量大於未轉數量!
   IF shipqty_t>g_n_ogb12 THEN # 
#No.FUN-710046--------------------------begin---------------------------                                                            
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','',"axm-127",0)                                                                                        
      ELSE                                                                                                                          
         CALL cl_err('','axm-127',0) CONTINUE WHILE
      END IF                                                                                                                        
#No.FUN-710046--------------------------End----------------------------
   END IF
 
   #MESSAGE "This Line OK (Y/N):"
   IF cl_confirm('axm-265') THEN #本項次是否確認
      CALL s_g_ogb_ins()
      EXIT WHILE
   END IF
 END WHILE
END FUNCTION
 
FUNCTION s_g_ogb_b_tot()
   LET shipqty_t=0
   FOR k=1 TO 100
     IF g_img[k].shipqty IS NOT NULL THEN
        LET shipqty_t=shipqty_t+g_img[k].shipqty
     END IF
   END FOR
   DISPLAY BY NAME shipqty_t
END FUNCTION
 
FUNCTION s_g_ogb_ins()
   DEFINE b_ogb		RECORD LIKE ogb_file.*
   DEFINE l_factor      LIKE ogb_file.ogb05_fac       #MOD-720003 add
   DEFINE l_ogbi        RECORD LIKE ogbi_file.*       #No.FUN-7B0018
   DEFINE l_tlf13       LIKE tlf_file.tlf13           #FUN-C30086
 
   LET b_ogb.*=g_ogb.*
   LET b_ogb.ogb01=g_ship_no
   FOR k=1 TO g_img.getLength()
     IF g_img[k].shipqty > 0 THEN
        SELECT MAX(ogb03) INTO b_ogb.ogb03 FROM ogb_file WHERE ogb01=g_ship_no     #MOD-C10225 mark   #MOD-CA0053 remark
        IF b_ogb.ogb03 IS NULL THEN LET b_ogb.ogb03 = 0 END IF                     #MOD-C10225 mark   #MOD-CA0053 remark
        LET b_ogb.ogb03 = b_ogb.ogb03 + 1                                          #MOD-C10225 mark   #MOD-CA0053 remark
        DISPLAY b_ogb.ogb03 TO ship_seq
        LET b_ogb.ogb09 = g_img[k].img02
        LET b_ogb.ogb091= g_img[k].img03
        LET b_ogb.ogb092= g_img[k].img04
        LET b_ogb.ogb12 = g_img[k].shipqty
        LET b_ogb.ogb12 = s_digqty(b_ogb.ogb12,b_ogb.ogb05)   #No.FUN-BB0086
        #BugNo:6208{
        IF cl_null(b_ogb.ogb15_fac) THEN
            LET b_ogb.ogb15_fac = 1
        END IF
        LET b_ogb.ogb16 = g_img[k].shipqty * b_ogb.ogb15_fac
        LET b_ogb.ogb16 = s_digqty(b_ogb.ogb16,b_ogb.ogb15)   #No.FUN-BB0086
        #BugNo:6208}
        #No.FUN-540049  --begin
        IF cl_null(b_ogb.ogb916) OR g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
           LET b_ogb.ogb916=b_ogb.ogb05
           LET b_ogb.ogb917=b_ogb.ogb12
        END IF
 
       #MOD-720003---add---str---
        IF g_sma.sma115 = 'N' AND g_sma.sma116 MATCHES '[23]' THEN
        CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb916)
              RETURNING g_cnt,l_factor
           IF g_cnt = 1 THEN
              LET l_factor = 1
           END IF
        LET b_ogb.ogb917 = b_ogb.ogb12 * l_factor
        END IF 
       #MOD-720003---add---end---
        LET b_ogb.ogb917 = s_digqty(b_ogb.ogb917,b_ogb.ogb916)   #No.FUN-BB0086
 
          IF g_oga.oga213 = 'N'
             #THEN LET b_ogb.ogb14 =b_ogb.ogb12*b_ogb.ogb13
             #     CALL cl_digcut(b_ogb.ogb14,g_azi04) RETURNING b_ogb.ogb14    #No.CHI-6A0004
             #     LET b_ogb.ogb14t=b_ogb.ogb14*(1+g_oga.oga211/100)
             #     CALL cl_digcut(b_ogb.ogb14t,g_azi04)RETURNING b_ogb.ogb14t   #No.CHI-6A0004
             #ELSE LET b_ogb.ogb14t=b_ogb.ogb12*b_ogb.ogb13
             #     CALL cl_digcut(b_ogb.ogb14t,g_azi04)RETURNING b_ogb.ogb14t   #No.CHI-6A0004
             #     LET b_ogb.ogb14 =b_ogb.ogb14t/(1+g_oga.oga211/100)
             #     CALL cl_digcut(b_ogb.ogb14,g_azi04) RETURNING b_ogb.ogb14    #No.CHI-6A0004
             THEN LET b_ogb.ogb14 =b_ogb.ogb917*b_ogb.ogb13
                  CALL cl_digcut(b_ogb.ogb14,t_azi04) RETURNING b_ogb.ogb14     #No.CHI-6A0004
                  LET b_ogb.ogb14t=b_ogb.ogb14*(1+g_oga.oga211/100)
                  CALL cl_digcut(b_ogb.ogb14t,t_azi04)RETURNING b_ogb.ogb14t    #No.CHI-6A0004
             ELSE LET b_ogb.ogb14t=b_ogb.ogb917*b_ogb.ogb13
                  CALL cl_digcut(b_ogb.ogb14t,t_azi04)RETURNING b_ogb.ogb14t    #No.CHI-6A0004
                  LET b_ogb.ogb14 =b_ogb.ogb14t/(1+g_oga.oga211/100)
                  CALL cl_digcut(b_ogb.ogb14,t_azi04) RETURNING b_ogb.ogb14     #No.CHI-6A0004
          END IF
        #No.FUN-540049  --end
        LET b_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
        
        LET b_ogb.ogb44='1' #No.FUN-870007
        LET b_ogb.ogb47=0   #No.FUN-870007
#FUN-AB0061 -----------add start----------------                             
        IF cl_null(b_ogb.ogb37) OR b_ogb.ogb37=0 THEN           
           LET b_ogb.ogb37=b_ogb.ogb13                         
        END IF                                                                             
#FUN-AB0061 -----------add end----------------   
        #FUN-980010 add plant & legal 
        LET b_ogb.ogbplant = g_plant 
        LET b_ogb.ogblegal = g_legal 
        #FUN-980010 end plant & legal 
 
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start------------
#        IF cl_null(b_ogb.ogb50) THEN
#           LET b_ogb.ogb50 = '1'
#        END IF
##FUN-AB0096 -----------add end-----------------    
#FUN-AC0055 mark ----------------------end------------------------
        #FUN-C50097 ADD BEGIN-----
        IF cl_null(b_ogb.ogb50) THEN 
           LET b_ogb.ogb50 = 0
        END IF 
        IF cl_null(b_ogb.ogb51) THEN 
           LET b_ogb.ogb51 = 0
        END IF 
        IF cl_null(b_ogb.ogb52) THEN 
           LET b_ogb.ogb52 = 0
        END IF 
        IF cl_null(b_ogb.ogb53) THEN
           LET b_ogb.ogb53 = 0
        END IF  
        IF cl_null(b_ogb.ogb54) THEN
           LET b_ogb.ogb54 = 0
        END IF  
        IF cl_null(b_ogb.ogb55) THEN
           LET b_ogb.ogb55 = 0
        END IF                                             
        #FUN-C50097 ADD END-------
        INSERT INTO ogb_file VALUES(b_ogb.*)
       #IF STATUS THEN
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins ogb:',SQLCA.SQLCODE,1)   #No.FUN-660167
#No.FUN-710046--------------------------begin---------------------------                                                            
           IF g_bgerr THEN                                                                                                               
              LET g_showmsg=g_ogb.ogb01,"/",g_ogb.ogb03
              CALL s_errmsg("ogb01,ogb03",g_showmsg,"INS ogb_file",SQLCA.sqlcode,1)
           ELSE                                                                                                                          
              CALL cl_err3("ins","ogb_file",b_ogb.ogb01,b_ogb.ogb03,SQLCA.SQLCODE,"","ins ogb",1)   #No.FUN-660167
           END IF                                                                                                                        
#No.FUN-710046--------------------------End----------------------------
#FUN-C30086---add---START
           #CASE  #MOD-D20054
             #WHEN g_oga.oga09 = '2' #一般出貨單  #MOD-D20054
               LET l_tlf13 = 'axmt620'
           #MOD-D20054---begin mark
             #WHEN g_oga.oga09 = '4' #多角貿易出貨單  
             #  LET l_tlf13 = 'axmt820' 
             #WHEN g_oga.oga09 = '6' #多角貿易代採出貨單
             #  LET l_tlf13 = 'axmt821'
           #END CASE
           #MOD-D20054---end
#FUN-C30086---add-----END
#NO.FUN-870148--------------------------Begin--------------------------
          #IF NOT s_lotout_del('axmt620',g_oga.oga01,l_ac,0,g_ogb.ogb04,'DEL') THEN       #TQC-B90236
          #IF NOT s_lot_del('axmt620',g_oga.oga01,l_ac,0,g_ogb.ogb04,'DEL') THEN          #TQC-B90236    #MOD-C60001 mark
          #IF NOT s_lot_del('axmt620',g_oga.oga01,g_ogb.ogb03,0,g_ogb.ogb04,'DEL') THEN   #MOD-C60001    #FUN-C30086 mark
           IF NOT s_lot_del(l_tlf13,g_oga.oga01,g_ogb.ogb03,0,g_ogb.ogb04,'DEL') THEN     #FUN-C30086 add  
              CALL cl_err3("del","rvbs_file",g_oga.oga01,l_ac,                                                       
                           SQLCA.sqlcode,"","",1)                                                                            
           END IF
#NO.FUN-870148--------------------------End--------------------------      
 
           LET g_success='N' EXIT FOR
        #No.FUN-7B0018 080305 add --begin
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_ogbi.* TO NULL
              LET l_ogbi.ogbi01 = b_ogb.ogb01
              LET l_ogbi.ogbi03 = b_ogb.ogb03
              IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                 LET g_success = 'N'
                 EXIT FOR
              END IF
           END IF
        #No.FUN-7B0018 080305 add --end
        END IF       
     END IF
   END FOR
   DISPLAY BY NAME shipqty_t
END FUNCTION
 
#No.FUN-870148--Add--Begin--#
FUNCTION p620_ins_rvbs()
    DEFINE l_rvbs          RECORD LIKE rvbs_file.*
    DEFINE g_ima918        LIKE ima_file.ima918
    DEFINE g_ima921        LIKE ima_file.ima921
    DEFINE l_rvbs02        LIKE rvbs_file.rvbs02
    DEFINE l_sql           STRING
    DEFINE p_ogb15         LIKE ogb_file.ogb15
    DEFINE p_ogb15_fac     LIKE ogb_file.ogb15_fac   
    DEFINE l_bno           LIKE rvbs_file.rvbs08 #CHI-9A0022 
    DEFINE l_tlf13         LIKE tlf_file.tlf13   #FUN-C30086 add
 
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = g_ogb.ogb04
         AND imaacti = "Y"
 
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#No.CHI-9A0022 --Begin
        IF cl_null(g_ogb.ogb41) THEN
           LET l_bno = g_ogb.ogb31
        ELSE
           LET l_bno = g_ogb.ogb41
        END IF
#No.CHI-9A0022 --End
#FUN-C30086---add---START
        #CASE #MOD-D20054
        #  WHEN g_oga.oga09 = '2' #一般出貨單  #MOD-D20054
            LET l_tlf13 = 'axmt620'
        #MOD-D20054---begin mark    
          #WHEN g_oga.oga09 = '4' #多角貿易出貨單  
          #  LET l_tlf13 = 'axmt820' 
          #WHEN g_oga.oga09 = '6' #多角貿易代採出貨單
          #  LET l_tlf13 = 'axmt821'
        #END CASE
        #MOD-D20054---end
#FUN-C30086---add-----END
          #CALL s_lotout('axmt620',g_oga.oga01,l_ac,0,           #TQC-B90236
          #              g_ogb.ogb04,g_img[l_ac].img02,
          #              g_img[l_ac].img03,g_img[l_ac].img04,
          #              g_ogb.ogb05,g_ogb.ogb15,g_ogb.ogb15_fac,
          #              g_img[l_ac].shipqty,l_bno,'MOD')#CHI-9A0022 add l_bno
          #CALL s_mod_lot('axmt620',g_oga.oga01,l_ac,0,           #TQC-B90236   #MOD-C60001 mark
          #CALL s_mod_lot('axmt620',g_oga.oga01,g_ogb.ogb03,0,    #MOD-C60001 #FUN-C30086 mrak
           CALL s_mod_lot(l_tlf13,g_oga.oga01,g_ogb.ogb03,0,      #MOD-C60001 #FUN-C30086 add 
                         g_ogb.ogb04,g_img[l_ac].img02,
                         g_img[l_ac].img03,g_img[l_ac].img04,
                         g_ogb.ogb05,g_ogb.ogb15,g_ogb.ogb15_fac,
                         g_img[l_ac].shipqty,l_bno,'MOD',-1)#CHI-9A0022 add l_bno
               RETURNING l_r,g_qty
           IF l_r = "Y" THEN
              LET g_ogb.ogb12 = g_qty
              LET g_ogb.ogb12 = s_digqty(g_ogb.ogb12,g_ogb.ogb05)   #No.FUN-BB0086
           END IF                                                               
     END IF
 
END FUNCTION
#No.FUN-870148--Add--End--#
