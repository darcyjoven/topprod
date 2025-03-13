# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_g_ogb1.4gl
# Descriptions...: 出貨通知單轉出貨單作業(倉儲批-選擇) FOR 雙單位
# Date & Author..: 05/05/09 By Elva 
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-590122 05/09/09 By Carrier set_origin_field修改
# Modify.........: No.MOD-590204 05/09/15 By Rosayu 1.根據sma122是1或2來顯示雙單位名稱
#                  2.AFTER FIELD shipqty中的判斷修改成兩筆都不為0或都為0才顯示axm-040
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-640280 06/04/11 By Sarah 未轉數量(g_a_ogb912)計算錯誤
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-710046 07/01/22 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-870148 08/08/01 By xiaofeizhu "轉出貨單"：如出通單需做批/序號管理(oaz81="Y")且料件需做批/序號管理，則一并拋轉單身批/序號資料
# Modify.........: No.MOD-890019 08/09/05 By Smapmin 單身庫存資料錯誤
# Modify.........: No.MOD-890066 08/09/05 By Smapmin 延續MOD-890019
# Modify.........: No.TQC-960033 09/06/05 By lilingyu 彈出對話框,維護"出貨數量"的欄位,沒有對輸入負數控管,同時輸入負數拋轉不成功,之后顯示運行成功
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No:MOD-A60007 10/06/08 By Smapmin 出貨合計數未清空
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga55,ogb50欄位預設值修正
# Modify.........: No.TQC-AC0396 10/12/30 By houlia sma115選擇參考單位時，拋轉出貨單會分裂成兩筆資料，導致審核不通過
# Modify.........: No.TQC-B30164 11/03/22 By lixia sma115選擇參考單位時，拋轉出貨單無單身資料轉出報錯
# Modify.........: No.TQC-B90236 11/10/28 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   s_lotout程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1 
# Modify.........: No:FUN-BB0086 12/01/14 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No.MOD-CA0060 12/10/09 By SunLM 采用多单位时候,出通單拋轉出貨單，生成多個項次的出貨單，問題修正
# Modify.........: No:FUN-C30086 12/11/19 By Sakura 出貨通知單開窗需可篩選出多角貿易出貨通知單單號
# Modify.........: No:MOD-D20054 13/02/07 By bart tlf13='axmt820'的程式段Mark

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chr  	  LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_oga      RECORD LIKE oga_file.*
DEFINE g_ogb      RECORD LIKE ogb_file.*
DEFINE g_imgg	  DYNAMIC ARRAY OF RECORD
                    status      LIKE type_file.chr14,   #MOD-890066 
                    imgg02	LIKE imgg_file.imgg02,
                    imgg03	LIKE imgg_file.imgg03,
                    imgg04	LIKE imgg_file.imgg04,
                    imgg09      LIKE imgg_file.imgg09,
                    imgg10	LIKE imgg_file.imgg10,
                    alocat	LIKE imgg_file.imgg10,
                    atp   	LIKE imgg_file.imgg10,
                    shipqty     LIKE imgg_file.imgg10 
                  END RECORD,
       g_imgg_s   DYNAMIC ARRAY OF RECORD
                    status      LIKE type_file.num5,   #No.FUN-680137 SMALLINT #1.parent 2.child
                    imgg02	LIKE imgg_file.imgg02,
                    imgg03	LIKE imgg_file.imgg03,
                    imgg04	LIKE imgg_file.imgg04,
                    imgg09      LIKE imgg_file.imgg09,
                    imgg10	LIKE imgg_file.imgg10,
                    alocat	LIKE imgg_file.imgg10,
                    atp   	LIKE imgg_file.imgg10,
                    shipqty     LIKE imgg_file.imgg10 
                  END RECORD,
       b_ogb	    RECORD LIKE ogb_file.*,
       g_ima906     LIKE ima_file.ima906,
       l_1,l_2     LIKE type_file.num5,        # No.FUN-680137 SMALLINT
       l_ac,l_sl   LIKE type_file.num5,        # No.FUN-680137 SMALLINT
       g_rec_b      LIKE type_file.num5,       #No.FUN-680137 SMALLINT
       g_cnt       LIKE type_file.num5,        # No.FUN-680137 SMALLINT
       g_buf        LIKE type_file.chr20,      #No.FUN-680137 VARCHAR(20)
       g_no        LIKE oea_file.oea01,      # No.FUN-680137  VARCHAR(16)            #No.FUN-550070
       g_ship_no   LIKE oea_file.oea01,      # No.FUN-680137 VARCHAR(16)            #No.FUN-550070
       g_ogb913     LIKE ogb_file.ogb913,
       g_ogb915     LIKE ogb_file.ogb915,
       g_a_ogb915   LIKE ogb_file.ogb915,#單位二已轉數量
       g_n_ogb915   LIKE ogb_file.ogb915,#單位二未轉數量
       g_ogb910     LIKE ogb_file.ogb910,
       g_ogb912     LIKE ogb_file.ogb912,
       g_a_ogb912   LIKE ogb_file.ogb912,#單位一已轉數量
       g_n_ogb912   LIKE ogb_file.ogb912 #單位一未轉數量
DEFINE imgg10_t_2,alocat_t_2,atp_t_2,shipqty_t_2 LIKE img_file.img10
DEFINE imgg10_t_1,alocat_t_1,atp_t_1,shipqty_t_1 LIKE img_file.img10
DEFINE i,j,k	LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_r         LIKE type_file.chr1     #No.FUN-870148
DEFINE g_qty       LIKE ogb_file.ogb12     #No.FUN-870148
 
FUNCTION s_g_ogb1(p_no,p_ship_no)
   DEFINE p_no		LIKE oea_file.oea01      # No.FUN-680137 VARCHAR(16)         #No.FUN-550070
   DEFINE p_ship_no	LIKE oea_file.oea01     # No.FUN-680137 VARCHAR(16)         #No.FUN-550070
   DEFINE g_msg         LIKE type_file.chr1000        #MOD-590204 add        #No.FUN-680137
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF p_no IS NULL THEN RETURN END IF
   LET g_no      = p_no 
   LET g_ship_no = p_ship_no 
 
   LET p_row = 7 LET p_col = 2 
   OPEN WINDOW s_g_ogb1_w AT p_row,p_col WITH FORM "sub/42f/s_g_ogb1"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("s_g_ogb1")
 
   #-----FUN-610006---------
   CALL s_g_ogb1_def_form()
   
#  #MOD-590204 add
#  IF g_sma.sma122 ='1' THEN
#     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
#     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
#     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
#     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
#  END IF
#  IF g_sma.sma122 ='2' THEN
#     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
#     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
#     CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
#     CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
#  END IF
#  #MOD-590204 end
   #-----END FUN-610006-----
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_ship_no
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01=g_oga.oga23    #No.CHI-6A0004   
   DISPLAY g_ship_no TO ship_no
   DECLARE s_g_ogb1_c CURSOR FOR
       SELECT * FROM ogb_file WHERE ogb01=g_no ORDER BY ogb03
 
 
   FOREACH s_g_ogb1_c INTO g_ogb.*
      DISPLAY BY NAME g_ogb.ogb01,g_ogb.ogb03,
                      g_ogb.ogb31,g_ogb.ogb32,
                      g_ogb.ogb04,
                      g_ogb.ogb09,
                      g_ogb.ogb913,g_ogb.ogb915,g_ogb.ogb910,g_ogb.ogb912
      #BugNo:5235
      SELECT SUM(ogb912),SUM(ogb915) 
        INTO g_a_ogb912,g_a_ogb915          #已轉數量
        FROM oga_file, ogb_file
       WHERE oga01    = ogb01
         AND oga011   = p_no        #出貨通知單
        #AND oga09    IN ('2','8')   #No.FUN-610079         #FUN-C30086 mark
         AND oga09    IN ('2','4','6','8')   #No.FUN-610079 #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
         AND ogb31    = g_ogb.ogb31 #No:7099
         AND ogb32    = g_ogb.ogb32 #No:7099
         AND ogb04    = g_ogb.ogb04 #產品編號
         AND ogaconf != 'X'         #No:5445
         AND ogb09    = g_ogb.ogb09    #MOD-640280 add
         AND ogb091   = g_ogb.ogb091   #MOD-640280 add
         AND ogb092   = g_ogb.ogb092   #MOD-640280 add
      IF cl_null(g_a_ogb912) THEN LET g_a_ogb912 = 0 END IF
      IF cl_null(g_a_ogb915) THEN LET g_a_ogb915 = 0 END IF
      IF cl_null(g_ogb.ogb912) THEN LET g_ogb.ogb912 = 0 END IF
      IF cl_null(g_ogb.ogb915) THEN LET g_ogb.ogb915 = 0 END IF
      #未轉數量
      LET g_n_ogb912 = g_ogb.ogb912 - g_a_ogb912
      LET g_n_ogb915 = g_ogb.ogb915 - g_a_ogb915
      IF g_n_ogb912 = 0 AND g_n_ogb915 = 0 THEN 
          #此出貨通知單的所有料件早已轉成出貨單,異動更新不成功!
          CONTINUE FOREACH 
      END IF
      DISPLAY g_a_ogb912,g_n_ogb912 TO FORMONLY.a_ogb912,FORMONLY.n_ogb912
      DISPLAY g_a_ogb915,g_n_ogb915 TO FORMONLY.a_ogb915,FORMONLY.n_ogb915
 
 
      LET g_success='Y' #代表此出貨通知單尚有料件未轉成出貨單! 
      LET g_errno=''
 
      CALL s_g_ogb1_1()
      IF g_success='N' THEN EXIT FOREACH END IF
 
   END FOREACH
   CLOSE WINDOW s_g_ogb1_w
   IF NOT cl_null(g_errno) THEN 
#No.FUN-710046--------------------------begin------------------
       IF g_bgerr THEN
          CALL s_errmsg('','',p_no,g_errno,1)
       ELSE
          CALL cl_err(p_no,g_errno,1)
       END IF
#No.FUN-710046--------------------------end--------------------------
   END IF
END FUNCTION
 
FUNCTION s_g_ogb1_1()
   DEFINE l_sql		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(600)
   DEFINE l_unit        LIKE img_file.img09
   DEFINE l_i           LIKE type_file.num5          #No.FUN-680137 SMALLINT
   MESSAGE "Wait..." 
 
   LET imgg10_t_2=0 
   LET alocat_t_2=0
   LET atp_t_2=0
   LET imgg10_t_1=0 
   LET alocat_t_1=0
   LET atp_t_1=0
   LET shipqty_t_2=0
   LET shipqty_t_1=0
   CALL g_imgg.clear()
   CALL g_imgg_s.clear()
   LET l_1=0
   LET l_2=0
   LET i = 1
   FOR l_i = 1 TO 2
      SELECT ima906 INTO g_ima906 FROM ima_file   #MOD-890019
       WHERE ima01=g_ogb.ogb04   #MOD-890019
      CALL cl_set_comp_visible("status",g_ima906='3')   #MOD-890066
      IF l_i = 1 THEN 
         LET l_unit = g_ogb.ogb913
         IF g_ogb.ogb915 IS NULL OR g_ogb.ogb915 =0 THEN
            CONTINUE FOR
         END IF
      END IF
      IF l_i = 2 THEN 
         IF g_ima906 = '3' THEN CONTINUE FOR END IF   #MOD-890019
         LET l_unit = g_ogb.ogb910 
         IF g_ogb.ogb912 IS NULL OR g_ogb.ogb912 =0 THEN
            CONTINUE FOR
         END IF
      END IF
      IF cl_null(l_unit) THEN CONTINUE FOR END IF
      #SELECT ima906 INTO g_ima906 FROM ima_file   #MOD-890019
      # WHERE ima01=g_ogb.ogb04   #MOD-890019
      IF g_ima906 = '1' THEN
         LET l_sql = 
         #"SELECT img02,img03,img04,img09,img10,0,0,0",   #MOD-890066
         "SELECT '',img02,img03,img04,img09,img10,0,0,0",   #MOD-890066
         "  FROM img_file",
         " WHERE img01='",g_ogb.ogb04,"' AND img10>=0"#,
         #"   AND img09='",l_unit,"'"
      ELSE
         LET l_sql = 
         #"SELECT imgg02,imgg03,imgg04,imgg09,imgg10,0,0,0",   #MOD-890066
         "SELECT '',imgg02,imgg03,imgg04,imgg09,imgg10,0,0,0",   #MOD-890066
         "  FROM imgg_file",
         " WHERE imgg01='",g_ogb.ogb04,"' AND imgg10>=0",
         "   AND imgg09='",l_unit,"'"
      END IF
 
      IF g_ogb.ogb09 IS NOT NULL AND g_ogb.ogb09 <>' ' THEN   # 若有指定倉庫
          IF g_ima906 = '1' THEN
             LET l_sql=l_sql CLIPPED," AND img02='",g_ogb.ogb09,"'"
          ELSE
             LET l_sql=l_sql CLIPPED," AND imgg02='",g_ogb.ogb09,"'"
          END IF
      END IF
 
      PREPARE s_g_ogb1_p1 FROM l_sql
      DECLARE s_g_ogb1_c1 CURSOR FOR s_g_ogb1_p1
 
      FOREACH s_g_ogb1_c1 INTO g_imgg[i].*
          IF l_i = 1 THEN
             #-----MOD-890066---------
             IF g_ima906 = '3' THEN 
                LET g_imgg[i].status=cl_getmsg('asm-304',g_lang)  
             END IF
             #-----END MOD-890066-----
             SELECT SUM(ogb915) INTO g_imgg[i].alocat FROM ogb_file,oga_file
              WHERE ogb04 =g_ogb.ogb04
                AND ogb09 =g_imgg[i].imgg02
                AND ogb091=g_imgg[i].imgg03
                AND ogb092=g_imgg[i].imgg04
                AND ogb913=g_imgg[i].imgg09
                AND ogb01=oga01
               #AND ((oga09='1' AND oga011 IS NULL) OR		# 出貨通知未轉出貨                  #FUN-C30086 mark
               #    (oga09 IN ('2','8') AND ogapost = 'N' ))	# 出貨單未扣帳  #No.FUN-610079      #FUN-C30086 mark
                AND ((oga09 IN ('1','5') AND oga011 IS NULL) OR  # 出貨通知未轉出貨                 #FUN-C30086 add 5.多角貿易出貨通知單
                    (oga09 IN ('2','4','6','8') AND ogapost = 'N' )) # 出貨單未扣帳  #No.FUN-610079 #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
          ELSE
             SELECT SUM(ogb912) INTO g_imgg[i].alocat FROM ogb_file,oga_file
              WHERE ogb04 =g_ogb.ogb04
                AND ogb09 =g_imgg[i].imgg02
                AND ogb091=g_imgg[i].imgg03
                AND ogb092=g_imgg[i].imgg04
                AND ogb910=g_imgg[i].imgg09
                AND ogb01=oga01
               #AND ((oga09='1' AND oga011 IS NULL) OR		# 出貨通知未轉出貨                      #FUN-C30086 mark
               #    (oga09 IN ('2','8') AND ogapost = 'N' ))	# 出貨單未扣帳  #No.FUN-610079          #FUN-C30086 mark
                AND ((oga09 IN ('1','5') AND oga011 IS NULL) OR         # 出貨通知未轉出貨              #FUN-C30086 add 5.多角貿易出貨通知單
                    (oga09 IN ('2','4','6','8') AND ogapost = 'N' ))    # 出貨單未扣帳  #No.FUN-610079  #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
          END IF
 
          IF cl_null(g_imgg[i].alocat) THEN 
             LET g_imgg[i].alocat=0
          END IF
 
          LET g_imgg[i].atp=g_imgg[i].imgg10-g_imgg[i].alocat
          IF l_i=1 THEN
             LET g_imgg_s[i].status = 1
             LET imgg10_t_2=imgg10_t_2+g_imgg[i].imgg10
             LET alocat_t_2=alocat_t_2+g_imgg[i].alocat
             LET atp_t_2   =atp_t_2   +g_imgg[i].atp
          ELSE
             LET g_imgg_s[i].status = 2
             LET imgg10_t_1=imgg10_t_1+g_imgg[i].imgg10
             LET alocat_t_1=alocat_t_1+g_imgg[i].alocat
             LET atp_t_1   =atp_t_1   +g_imgg[i].atp
          END IF
          LET g_imgg_s[i].imgg02 = g_imgg[i].imgg02
          LET g_imgg_s[i].imgg03 = g_imgg[i].imgg03
          LET g_imgg_s[i].imgg04 = g_imgg[i].imgg04
          LET g_imgg_s[i].imgg09 = g_imgg[i].imgg09
          LET g_imgg_s[i].imgg10 = g_imgg[i].imgg10
          LET g_imgg_s[i].alocat = g_imgg[i].alocat
          LET g_imgg_s[i].atp    = g_imgg[i].atp   
          LET g_imgg_s[i].shipqty= g_imgg[i].shipqty
          LET i = i + 1
 
          IF i > g_max_rec THEN
#No.FUN-710046--------------------------begin------------------                                                                     
       IF g_bgerr THEN                                                                                                              
          CALL s_errmsg('','','',"9035",0)                                                                                       
       ELSE                                                                                                                         
          CALL cl_err( '', 9035, 0 )
       END IF                                                                                                                       
#No.FUN-710046--------------------------end--------------------------
	     EXIT FOREACH
          END IF
 
      END FOREACH
   END FOR
   CALL g_imgg.deleteElement(i)
   CALL g_imgg_s.deleteElement(i)
   IF g_ima906 = '3' THEN
      LET l_1=i - 1
      #FOR l_i = 1 TO g_imgg.getLength()   #MOD-890019
      FOR l_i = 1 TO l_1   #MOD-890019
          LET g_imgg[i].*=g_imgg[l_i].*
          LET g_imgg[i].status=cl_getmsg('asm-326',g_lang)   #MOD-890066
          LET g_imgg[i].imgg09=g_ogb.ogb910
          SELECT img10 INTO g_imgg[i].imgg10 FROM img_file
           WHERE img01=g_ogb.ogb04
             AND img02=g_imgg[i].imgg02
             AND img03=g_imgg[i].imgg03
             AND img04=g_imgg[i].imgg04
          SELECT SUM(ogb912) INTO g_imgg[i].alocat FROM ogb_file,oga_file
           WHERE ogb04 =g_ogb.ogb04
             AND ogb09 =g_imgg[i].imgg02
             AND ogb091=g_imgg[i].imgg03
             AND ogb092=g_imgg[i].imgg04
             AND ogb910=g_imgg[i].imgg09
             AND ogb01=oga01
            #AND ((oga09='1' AND oga011 IS NULL) OR		# 出貨通知未轉出貨                     #FUN-C30086 mark 
            #    (oga09 IN ('2','8') AND ogapost = 'N' ))	# 出貨單未扣帳  #No.FUN-610079         #FUN-C30086 mark
             AND ((oga09 IN ('1','5') AND oga011 IS NULL) OR    # 出貨通知未轉出貨                     #FUN-C30086 add 5.多角貿易出貨通知單
                 (oga09 IN ('2','4','6','8') AND ogapost = 'N' ))       # 出貨單未扣帳  #No.FUN-610079 #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
          IF cl_null(g_imgg[i].alocat) THEN 
             LET g_imgg[i].alocat=0
          END IF
 
          LET g_imgg[i].atp=g_imgg[i].imgg10-g_imgg[i].alocat
          LET imgg10_t_1=imgg10_t_1+g_imgg[i].imgg10
          LET alocat_t_1=alocat_t_1+g_imgg[i].alocat
          LET atp_t_1   =atp_t_1   +g_imgg[i].atp
 
          LET g_imgg_s[i].status=2
          LET g_imgg_s[i].imgg02 = g_imgg[i].imgg02
          LET g_imgg_s[i].imgg03 = g_imgg[i].imgg03
          LET g_imgg_s[i].imgg04 = g_imgg[i].imgg04
          LET g_imgg_s[i].imgg09 = g_imgg[i].imgg09
          LET g_imgg_s[i].imgg10 = g_imgg[i].imgg10
          LET g_imgg_s[i].alocat = g_imgg[i].alocat
          LET g_imgg_s[i].atp    = g_imgg[i].atp   
          LET g_imgg_s[i].shipqty= g_imgg[i].shipqty
 
          LET i = i + 1   #MOD-890019
      END FOR
      CALL g_imgg.deleteElement(i)   #MOD-890019
      CALL g_imgg_s.deleteElement(i)   #MOD-890019
 
   END IF
   DISPLAY BY NAME imgg10_t_2,alocat_t_2,atp_t_2,shipqty_t_2
   DISPLAY BY NAME imgg10_t_1,alocat_t_1,atp_t_1,shipqty_t_1
   LET g_rec_b =(i-1) DISPLAY i TO cn2
 
   MESSAGE ""
   CALL s_g_ogb1_b()
 
END FUNCTION
 
FUNCTION s_g_ogb1_b()
 DEFINE l_i LIKE type_file.num5   #MOD-890066

 #-----MOD-A60007---------
 LET shipqty_t_2=0
 LET shipqty_t_1=0
 DISPLAY BY NAME shipqty_t_2,shipqty_t_1
 #-----END MOD-A60007-----
 
 
 WHILE TRUE
   INPUT ARRAY g_imgg WITHOUT DEFAULTS FROM s_imgg.* 
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
     BEFORE ROW
       LET i = ARR_CURR() 
       LET j = SCR_LINE()
       LET l_ac = ARR_CURR()       #FUN-870148 
       CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER FIELD shipqty
       #-----MOD-890066--------- 
       #IF g_ima906 = '3' THEN
       #   IF i > l_1 THEN
       #      IF cl_null(g_imgg[i].shipqty) OR g_imgg[i].shipqty =0 THEN
       #         #IF NOT cl_null(g_imgg[i-l_1].shipqty) AND #MOD-590204 mark
       #            #g_imgg[i-l_1].shipqty<>0 THEN  #MOD-590204 mark
       #         IF cl_null(g_imgg[i-l_1].shipqty) OR  #MOD-590204 add
       #            g_imgg[i-l_1].shipqty=0 THEN       #MOD-590204 add
       #            #No.FUN-710046--------------------------begin------------------                                                                     
       #            IF g_bgerr THEN                                                                                                              
       #               CALL s_errmsg('','','',"axm-040",0)                                                                                     
       #            ELSE                                                                                                                         
       #               CALL cl_err('','axm-040',0)
       #            END IF                                                                                                                       
       #            #No.FUN-710046--------------------------end--------------------------
       #            NEXT FIELD shipqty
       #         END IF
       #      END IF
       #      IF NOT cl_null(g_imgg[i].shipqty) AND g_imgg[i].shipqty <>0 THEN
       #         #IF cl_null(g_imgg[i-l_1].shipqty) OR  #MOD-590204 mark
       #         #   g_imgg[i-l_1].shipqty=0 THEN       #MOD-590203 mark
       #         IF NOT cl_null(g_imgg[i-l_1].shipqty) AND   #MOD-590204 add
       #            g_imgg[i-l_1].shipqty<>0 THEN            #MOD-590204 add
       #            #No.FUN-710046--------------------------begin------------------                                                                     
       #            IF g_bgerr THEN                                                                                                              
       #               CALL s_errmsg('','','',"axm-040",0)                                                                                     
       #            ELSE                                                                                                                         
       #               CALL cl_err('','axm-040',0)
       #            END IF                                                                                                                       
       #            #No.FUN-710046--------------------------end--------------------------
       #            NEXT FIELD shipqty
       #         END IF
       #      END IF
       #   END IF
       #END IF
       #-----END MOD-890066-----
#TQC-960033 --begin--
        IF g_imgg[i].shipqty < 0 THEN 
           CALL cl_err('','asf-209',0)
           NEXT FIELD shipqty
        END IF 
#TQC-960033  --end--        
       IF NOT cl_null(g_imgg[i].shipqty) OR g_imgg[i].shipqty <> 0 THEN      #FUN-870148 
          CALL p620_ins_rvbs1()                                              #FUN-870148
       END IF                                                                #FUN-870148
 
     AFTER ROW
       CALL s_g_ogb1_imgg_s()
       CALL s_g_ogb1_b_tot()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #-----MOD-890066---------
      AFTER INPUT 
        IF INT_FLAG THEN 
           LET INT_FLAG=0
           LET g_success='N'
           EXIT WHILE
        END IF
        IF g_ima906 = '3' THEN
           FOR l_i = l_1+1 TO g_imgg.getLength()   
             IF cl_null(g_imgg[l_i].shipqty) OR g_imgg[l_i].shipqty =0 THEN
                IF NOT cl_null(g_imgg[l_i-l_1].shipqty) AND    
                   g_imgg[l_i-l_1].shipqty<>0 THEN     
                   IF g_bgerr THEN                                                                                                              
                      CALL s_errmsg('','','',"axm-040",0)                                                                                     
                   ELSE                                                                                                                         
                      CALL cl_err('','axm-040',0)
                   END IF                                                                                                                       
                   NEXT FIELD shipqty
                END IF
             END IF
             IF NOT cl_null(g_imgg[l_i].shipqty) AND g_imgg[l_i].shipqty <>0 THEN
                IF cl_null(g_imgg[l_i-l_1].shipqty) OR     
                   g_imgg[l_i-l_1].shipqty=0 THEN        
                   IF g_bgerr THEN                                                                                                              
                      CALL s_errmsg('','','',"axm-040",0)                                                                                     
                   ELSE                                                                                                                         
                      CALL cl_err('','axm-040',0)
                   END IF                                                                                                                       
                   NEXT FIELD shipqty
                END IF
             END IF
           END FOR
        END IF
        #-----END MOD-890066-----
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG=0
      LET g_success='N'
      EXIT WHILE
   END IF
 
   #BugNo:5235
   #出貨數量大於未轉數量!
   IF shipqty_t_2>g_n_ogb915 THEN # 
#No.FUN-710046--------------------------begin------------------                                                                     
       IF g_bgerr THEN                                                                                                              
          CALL s_errmsg('','','',"axm-127",0)                                                                                       
       ELSE                                                                                                                         
          CALL cl_err('','axm-127',0)
       END IF                                                                                                                       
#No.FUN-710046--------------------------end--------------------------
      CONTINUE WHILE
   END IF
 
   IF shipqty_t_1>g_n_ogb912 THEN # 
#No.FUN-710046--------------------------begin------------------                                                                     
       IF g_bgerr THEN                                                                                                              
          CALL s_errmsg('','','',"axm-127",0)                                                                                       
       ELSE                                                                                                                         
          CALL cl_err('','axm-127',0)
       END IF                                                                                                                       
#No.FUN-710046--------------------------end--------------------------
      CONTINUE WHILE
   END IF
   #MESSAGE "This Line OK (Y/N):"
   IF cl_confirm('axm-265') THEN #本項次是否確認
      CALL s_g_ogb1_b_ins()
      CALL s_g_ogb1_ins()
      EXIT WHILE
   END IF
 END WHILE
END FUNCTION
 
FUNCTION s_g_ogb1_b_tot()
DEFINE l_i  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   LET shipqty_t_2=0
   LET shipqty_t_1=0
   FOR l_i=1 TO g_imgg_s.getLength()
     IF g_imgg_s[l_i].shipqty IS NOT NULL THEN
        IF g_imgg_s[l_i].status=1 THEN
           LET shipqty_t_2=shipqty_t_2+g_imgg[l_i].shipqty
        ELSE
           LET shipqty_t_1=shipqty_t_1+g_imgg[l_i].shipqty
        END IF
     END IF
   END FOR
   DISPLAY BY NAME shipqty_t_2,shipqty_t_1
END FUNCTION   
 
FUNCTION s_g_ogb1_imgg_s()
DEFINE l_i   LIKE type_file.num5          #No.FUN-680137 SMALLINT
   FOR l_i = 1 TO g_imgg.getLength()
     LET g_imgg_s[l_i].shipqty=g_imgg[l_i].shipqty  #MOD-CA0060   i--->l_i
   END FOR
END FUNCTION
 
FUNCTION s_g_ogb1_b_ins()
DEFINE l_i,l_j  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
  DROP TABLE tmpz_file;
# No.FUN-680137 --start--
  CREATE TEMP TABLE tmpz_file(
     imgg01   LIKE imgg_file.imgg01,
     imgg02   LIKE imgg_file.imgg02,
     imgg03   LIKE imgg_file.imgg03,
     imgg04   LIKE imgg_file.imgg04,    
     unit2     LIKE imgg_file.imgg07,
     qty2     LIKE imgg_file.imgg10,
     unit1     LIKE imgg_file.imgg07, 
     qty1     LIKE imgg_file.imgg10) 
  
# No.FUN-680137 ---end---
  FOR l_i = 1 TO g_imgg_s.getLength()
      IF cl_null(g_imgg_s[l_i].imgg02) THEN 
         LET g_imgg_s[l_i].imgg02=' '
      END IF
      IF cl_null(g_imgg_s[l_i].imgg03) THEN 
         LET g_imgg_s[l_i].imgg03=' '
      END IF
      IF cl_null(g_imgg_s[l_i].imgg04) THEN    #MOD-640280 modify
         LET g_imgg_s[l_i].imgg04=' '
      END IF
     #start MOD-640280
     #SELECT COUNT(*) INTO l_j FROM tmpz_file
     # WHERE imgg01 = g_ogb.ogb04
     #   AND imgg02 = g_imgg_s[l_i].imgg02
     #   AND imgg03 = g_imgg_s[l_i].imgg03
     #   AND imgg04 = g_imgg_s[l_i].imgg04
     #IF l_j = 0 THEN
     #   INSERT INTO tmpz_file(imgg01,imgg02,imgg03,imgg04,
     #                         unit2,qty2,unit1,qty1) 
     #    VALUES(g_ogb.ogb04,g_imgg_s[l_i].imgg02,g_imgg_s[l_i].imgg03,
     #          g_imgg_s[l_i].imgg04,NULL,0,NULL,0)
     #   IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
     #END IF
      IF g_imgg_s[l_i].shipqty > 0 THEN   #有輸入出貨數量
         IF g_imgg_s[l_i].status = '1' THEN
            INSERT INTO tmpz_file(imgg01,imgg02,imgg03,imgg04,
                                  unit2,qty2,unit1,qty1) 
            VALUES(g_ogb.ogb04,g_imgg_s[l_i].imgg02,g_imgg_s[l_i].imgg03,
                   g_imgg_s[l_i].imgg04,
                   g_imgg_s[l_i].imgg09,g_imgg_s[l_i].shipqty,NULL,0)
         ELSE
            INSERT INTO tmpz_file(imgg01,imgg02,imgg03,imgg04,
                                  unit2,qty2,unit1,qty1) 
            VALUES(g_ogb.ogb04,g_imgg_s[l_i].imgg02,g_imgg_s[l_i].imgg03,
                   g_imgg_s[l_i].imgg04,NULL,0,
                   g_imgg_s[l_i].imgg09,g_imgg_s[l_i].shipqty)
         END IF
         IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
      END IF
     #IF g_imgg_s[l_i].status = '1' THEN
     #   UPDATE tmpz_file SET unit2 = g_imgg_s[l_i].imgg09,
     #                        qty2  = qty2+g_imgg_s[l_i].shipqty
     #    WHERE imgg01=g_ogb.ogb04
     #      AND imgg02=g_imgg_s[l_i].imgg02
     #      AND imgg03=g_imgg_s[l_i].imgg03
     #      AND imgg04=g_imgg_s[l_i].imgg04
     #   IF SQLCA.sqlcode THEN LET g_success='N' RETURN END IF
     #ELSE
     #   UPDATE tmpz_file SET unit1 = g_imgg_s[l_i].imgg09,
     #                        qty1  = qty1+g_imgg_s[l_i].shipqty
     #    WHERE imgg01=g_ogb.ogb04
     #      AND imgg02=g_imgg_s[l_i].imgg02
     #      AND imgg03=g_imgg_s[l_i].imgg03
     #      AND imgg04=g_imgg_s[l_i].imgg04
     #   IF SQLCA.sqlcode THEN LET g_success='N' RETURN END IF
     #END IF
     #end MOD-640280
  END FOR
 
END FUNCTION
 
FUNCTION s_g_ogb1_ins()
   DEFINE l_ima31       LIKE ima_file.ima31
   DEFINE l_cnt         LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_factor      LIKE img_file.img21
   DEFINE sr            RECORD
                        imgg01  LIKE imgg_file.imgg01,
                        imgg02  LIKE imgg_file.imgg02,
                        imgg03  LIKE Imgg_file.imgg03,
                        imgg04  LIKE imgg_file.imgg04,
                        unit2   LIKE imgg_file.imgg09,
                        qty2    LIKE imgg_file.imgg10,
                        unit1   LIKE imgg_file.imgg09,
                        qty1    LIKE imgg_file.imgg10
                        END RECORD
   DEFINE l_ogbi        RECORD LIKE ogbi_file.*       #No.FUN-7B0018
   DEFINE l_sql         STRING                        #TQC-B30164
   DEFINE l_i           LIKE type_file.num5           #TQC-B30164
   DEFINE l_tlf13       LIKE tlf_file.tlf13           #FUN-C30086
                        
   INITIALIZE b_ogb.* TO NULL
   LET b_ogb.*=g_ogb.*
   LET b_ogb.ogb01=g_ship_no
   #TQC-B30164--mark--str--
   #DECLARE s_g_ogb1_ins_cur CURSOR FOR
   ##TQC-AC0396
   #SELECT imgg01,imgg02,imgg03,imgg04,unit2,qty2 FROM tmpz_file 
   # WHERE unit2 IS NOT NULL AND qty2 !=0 
   #FOREACH s_g_ogb1_ins_cur INTO sr.imgg01,sr.imgg02,sr.imgg03,sr.imgg04,sr.unit2,sr.qty2
   #TQC-B30164--mark--end--

   #TQC-B30164--add--str--
   FOR l_i= 1 TO g_imgg_s.getLength()
      LET l_sql="SELECT * FROM tmpz_file "
      IF g_imgg_s[l_i].status='1' then 
         LET l_sql=l_sql," WHERE unit2 IS NOT NULL AND qty2 !=0"     
      ELSE 
         LET l_sql=l_sql," WHERE unit1 IS NOT NULL AND qty1 !=0"
      END IF
      PREPARE s_g_ogb1_tmpz FROM l_sql
      DECLARE s_g_ogb1_ins_cur CURSOR FOR s_g_ogb1_tmpz
      FOREACH s_g_ogb1_ins_cur INTO sr.*
   #TQC-B30164--add--end-
#----------MOD-CA0060 add begin 如果存在出貨單身,則繼續foreach
         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01 = g_ship_no
            AND ogb04 = g_ogb.ogb04
            AND ogb31 = g_ogb.ogb31
            AND ogb32 = g_ogb.ogb32
         IF l_cnt > 0 THEN 
         	  CONTINUE FOREACH 
         END IF 	     
#----------MOD-CA0060 add end 
  # SELECT * FROM tmpz_file
  # FOREACH s_g_ogb1_ins_cur INTO sr.*
  #TQC-AC0396
       IF STATUS THEN CALL cl_err('foreach',STATUS,1)    #No.FUN-660167
        LET g_success='N' RETURN
     END IF
   #TQC-AC0396
     SELECT DISTINCT unit1,qty1 
      INTO sr.unit1,sr.qty1
      FROM tmpz_file
     WHERE unit2 IS  NULL 
       AND qty2 = 0 
       AND imgg01 = sr.imgg01
       AND imgg02 = sr.imgg02
       AND imgg03 = sr.imgg03
       AND imgg04 = sr.imgg04
   #TQC-AC0396
     IF sr.qty2>0 OR sr.qty1>0 THEN
        SELECT MAX(ogb03) INTO b_ogb.ogb03 FROM ogb_file WHERE ogb01=g_ship_no
       IF b_ogb.ogb03 IS NULL THEN LET b_ogb.ogb03 = 0 END IF
       LET b_ogb.ogb03 = b_ogb.ogb03 + 1
    
        
        DISPLAY b_ogb.ogb03 TO ship_seq
        LET b_ogb.ogb09 = sr.imgg02
        LET b_ogb.ogb091= sr.imgg03
        LET b_ogb.ogb092= sr.imgg04
        IF NOT cl_null(sr.unit1) THEN
           LET b_ogb.ogb910= sr.unit1
        END IF
        IF NOT cl_null(sr.unit2) THEN
           LET b_ogb.ogb913= sr.unit2
        END IF
        LET b_ogb.ogb912= sr.qty1 
        LET b_ogb.ogb912 = s_digqty(b_ogb.ogb912,b_ogb.ogb910)   #No.FUN-BB0086
        LET b_ogb.ogb915= sr.qty2 
        LET b_ogb.ogb915 = s_digqty(b_ogb.ogb915,b_ogb.ogb913)   #No.FUN-BB0086
        SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_ogb.ogb04
        SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=b_ogb.ogb04
        LET l_factor = 1
        CALL s_umfchk(b_ogb.ogb04,sr.unit1,l_ima31)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        #LET b_ogb.ogb911=l_factor
        LET l_factor = 1
        CALL s_umfchk(b_ogb.ogb04,sr.unit2,l_ima31)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        #LET b_ogb.ogb914=l_factor
        #IF g_ima906 = '1' THEN
        #   SELECT img21 INTO b_ogb.ogb911 FROM img_file
        #    WHERE img01=g_ogb.ogb04
        #      AND img02=sr.imgg02
        #      AND img03=sr.imgg03
        #      AND img04=sr.imgg04
        #ELSE
        #   SELECT imgg21 INTO b_ogb.ogb914 FROM imgg_file
        #    WHERE imgg01=g_ogb.ogb04
        #      AND imgg02=sr.imgg02
        #      AND imgg03=sr.imgg03
        #      AND imgg04=sr.imgg04
        #      AND imgg09=sr.unit2
        #   SELECT imgg21 INTO b_ogb.ogb911 FROM imgg_file
        #    WHERE imgg01=g_ogb.ogb04
        #      AND imgg02=sr.imgg02
        #      AND imgg03=sr.imgg03
        #      AND imgg04=sr.imgg04
        #      AND imgg09=sr.unit1
        #END IF
        CALL s_g_ogb1_set_origin_field(sr.unit2,b_ogb.ogb914,sr.qty2,sr.unit1,b_ogb.ogb911,sr.qty1)
        IF g_oga.oga213 = 'N'
             #No.FUN-540049  --begin
             #THEN LET b_ogb.ogb14 =b_ogb.ogb12*b_ogb.ogb13
             #     CALL cl_digcut(b_ogb.ogb14,g_azi04) RETURNING b_ogb.ogb14
             #     LET b_ogb.ogb14t=b_ogb.ogb14*(1+g_oga.oga211/100)
             #     CALL cl_digcut(b_ogb.ogb14t,g_azi04)RETURNING b_ogb.ogb14t
             #ELSE LET b_ogb.ogb14t=b_ogb.ogb12*b_ogb.ogb13
             #     CALL cl_digcut(b_ogb.ogb14t,g_azi04)RETURNING b_ogb.ogb14t
             #     LET b_ogb.ogb14 =b_ogb.ogb14t/(1+g_oga.oga211/100)
             #     CALL cl_digcut(b_ogb.ogb14,g_azi04) RETURNING b_ogb.ogb14
             THEN LET b_ogb.ogb14 =b_ogb.ogb917*b_ogb.ogb13
                  CALL cl_digcut(b_ogb.ogb14,t_azi04) RETURNING b_ogb.ogb14
                  LET b_ogb.ogb14t=b_ogb.ogb14*(1+g_oga.oga211/100)
                  CALL cl_digcut(b_ogb.ogb14t,t_azi04)RETURNING b_ogb.ogb14t    #No.CHI-6A0004
             ELSE LET b_ogb.ogb14t=b_ogb.ogb917*b_ogb.ogb13
                  CALL cl_digcut(b_ogb.ogb14t,t_azi04)RETURNING b_ogb.ogb14t    #No.CHI-6A0004
                  LET b_ogb.ogb14 =b_ogb.ogb14t/(1+g_oga.oga211/100)
                  CALL cl_digcut(b_ogb.ogb14,t_azi04) RETURNING b_ogb.ogb14     #No.CHI-6A0004 
             #No.FUN-540049  --end   
        END IF
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
##FUN-AB0096 ------------add start----------------
#        IF cl_null(b_ogb.ogb50) THEN
#            LET b_ogb.ogb50 = '1'
#        END IF
##FUN-AB0096 ------------add end-------------------  
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
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins ogb:',SQLCA.SQLCODE,1)   #No.FUN-660167
#No.FUN-710046--------------------------begin------------------                                                                     
           IF g_bgerr THEN                                                                                                              
              LET g_showmsg=g_ogb.ogb01,"/",g_ogb.ogb03 
              CALL s_errmsg("ogb01,ogb03",g_showmsg,"INS ogb_file",SQLCA.sqlcode,1)                                                                                       
           ELSE                                                                                                                         
              CALL cl_err3("ins","ogb_file",b_ogb.ogb01,g_ogb.ogb03,SQLCA.SQLCODE,"","ins ogb",1)   #No.FUN-660167
           END IF                                                                                                                       
#No.FUN-710046--------------------------end--------------------------
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
          #IF NOT s_lotout_del('axmt620',g_oga.oga01,l_ac,0,g_ogb.ogb04,'DEL') THEN           #TQC-B90236
          #IF NOT s_lot_del('axmt620',g_oga.oga01,l_ac,0,g_ogb.ogb04,'DEL') THEN         #TQC-B90236 #FUN-C30086 mark
           IF NOT s_lot_del(l_tlf13,g_oga.oga01,l_ac,0,g_ogb.ogb04,'DEL') THEN           #TQC-B90236 #FUN-C30086 add
              CALL cl_err3("del","rvbs_file",g_oga.oga01,l_ac,                                                       
                           SQLCA.sqlcode,"","",1)                                                                            
           END IF
#NO.FUN-870148--------------------------End-------------------------- 
           LET g_success='N' EXIT FOREACH
        #No.FUN-7B0018 080305 add --begin
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_ogbi.* TO NULL
              LET l_ogbi.ogbi01 = b_ogb.ogb01
              LET l_ogbi.ogbi03 = b_ogb.ogb03
              IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        #No.FUN-7B0018 080305 add --end    
        END IF
     END IF
   END FOREACH
   END FOR     #TQC-B30164
   DISPLAY BY NAME shipqty_t_2,shipqty_t_1
END FUNCTION
 
FUNCTION s_g_ogb1_set_origin_field(p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1)
  DEFINE p_unit2   LIKE imgg_file.imgg09
  DEFINE p_fac2    LIKE imgg_file.imgg21
  DEFINE p_qty2    LIKE imgg_file.imgg10
  DEFINE p_unit1   LIKE imgg_file.imgg09
  DEFINE p_fac1    LIKE imgg_file.imgg21
  DEFINE p_qty1    LIKE imgg_file.imgg10
  DEFINE l_tot     LIKE imgg_file.imgg10
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima908  LIKE ima_file.ima908
  DEFINE l_ima25   LIKE ima_file.ima25
  DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_factor  LIKE img_file.img21
  DEFINE l_img09   LIKE img_file.img09
  
    #No.MOD-590122  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590122  --end   
    SELECT ima906,ima25,ima908 INTO l_ima906,l_ima25,l_ima908
      FROM ima_file WHERE ima01=b_ogb.ogb04
    SELECT img09  INTO l_img09  FROM img_file 
     WHERE img01=b_ogb.ogb04
       AND img02=b_ogb.ogb09
       AND img03=b_ogb.ogb091
       AND img04=b_ogb.ogb092
 
   IF cl_null(p_fac1) THEN LET p_fac1=1 END IF
   IF cl_null(p_qty1) THEN LET p_qty1=0 END IF
   IF cl_null(p_fac2) THEN LET p_fac2=1 END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
   
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' #LET b_ogb.ogb05=p_unit1
                  #LET l_factor = 1
                  #CALL s_umfchk(b_ogb.ogb04,p_unit1,l_ima25) RETURNING l_cnt,l_factor
                  #IF l_cnt = 1 THEN
                  #   LET l_factor = 1
                  #END IF
                  #LET b_ogb.ogb05_fac = l_factor
                  LET b_ogb.ogb12=p_qty1
         WHEN '2' LET l_tot=p_fac1*p_qty1+p_fac2*p_qty2
                  #LET b_ogb.ogb05=l_img09
                  #LET l_factor = 1
                  #LET b_ogb.ogb05_fac = l_factor
                  LET b_ogb.ogb12=l_tot
                  LET b_ogb.ogb12 = s_digqty(b_ogb.ogb12,b_ogb.ogb05)   #No.FUN-BB0086
         WHEN '3' #LET b_ogb.ogb05=p_unit1
                  #LET l_factor = 1
                  #CALL s_umfchk(b_ogb.ogb04,p_unit1,l_ima25) RETURNING l_cnt,l_factor
                  #IF l_cnt = 1 THEN
                  #   LET l_factor = 1
                  #END IF
                  #LET b_ogb.ogb05_fac = l_factor
                  LET b_ogb.ogb12=p_qty1
      END CASE
   #No.MOD-590122  --begin
   #ELSE  #不使用雙單位
   #   #LET b_ogb.ogb05=p_unit1
   #   #LET l_factor = 1
   #   #CALL s_umfchk(b_ogb.ogb04,p_unit1,l_ima25) RETURNING l_cnt,l_factor
   #   #IF l_cnt = 1 THEN
   #   #   LET l_factor = 1
   #   #END IF
   #   #LET b_ogb.ogb05_fac = l_factor
   #   LET b_ogb.ogb12=p_qty1
   #No.MOD-590122  --end  
   END IF
   IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
      #LET b_ogb.ogb916 = l_ima908
      LET l_factor = 1
      CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb916,b_ogb.ogb05) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET b_ogb.ogb917=b_ogb.ogb12/l_factor
   ELSE
      LET b_ogb.ogb916=b_ogb.ogb05
      LET b_ogb.ogb917=b_ogb.ogb12
   END IF
 
   LET b_ogb.ogb16 = b_ogb.ogb12 * b_ogb.ogb15_fac
   LET b_ogb.ogb16 = s_digqty(b_ogb.ogb16,b_ogb.ogb15)   #No.FUN-BB0086
 
END FUNCTION
#-----FUN-610006---------
FUNCTION s_g_ogb1_def_form()
  DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
  IF g_sma.sma122 ='1' THEN
     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-601',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("a_ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-602',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("n_ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-603',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("a_ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-604',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("n_ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-605',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("imgg10_t_2",g_msg CLIPPED)
     CALL cl_getmsg('asm-606',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("imgg10_t_1",g_msg CLIPPED)
  END IF
  IF g_sma.sma122 ='2' THEN
     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
     CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-611',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("a_ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-612',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("n_ogb915",g_msg CLIPPED)
     CALL cl_getmsg('asm-613',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("a_ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-614',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("n_ogb912",g_msg CLIPPED)
     CALL cl_getmsg('asm-615',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("imgg10_t_2",g_msg CLIPPED)
     CALL cl_getmsg('asm-616',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("imgg10_t_1",g_msg CLIPPED)
  END IF
END FUNCTION
#-----END FUN-610006-----
 
#No.FUN-870148--Add--Begin--#
FUNCTION p620_ins_rvbs1()
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
#CHI-9A0022 --Begin
        IF cl_null(g_ogb.ogb41) THEN
           LET l_bno = g_ogb.ogb31
        ELSE
           LET l_bno = g_ogb.ogb41
        END IF
#CHI-9A0022 --End
#FUN-C30086---add---START
        #CASE  #MOD-D20054
        #  WHEN g_oga.oga09 = '2' #一般出貨單  #MOD-D20054
            LET l_tlf13 = 'axmt620'
        #MOD-D20054---begin    
          #WHEN g_oga.oga09 = '4' #多角貿易出貨單  
          #  LET l_tlf13 = 'axmt820'  
          #WHEN g_oga.oga09 = '6' #多角貿易代採出貨單
          #  LET l_tlf13 = 'axmt821'
        #END CASE 
        #MOD-D20054---end
#FUN-C30086---add-----END
          #CALL s_lotout('axmt620',g_oga.oga01,l_ac,0,                               #TQC-B90236
          #              g_ogb.ogb04,g_imgg[l_ac].imgg02,
          #              g_imgg[l_ac].imgg03,g_imgg[l_ac].imgg04,
          #              g_ogb.ogb05,g_ogb.ogb15,g_ogb.ogb15_fac,
          #              g_imgg[l_ac].shipqty,l_bno,'MOD')#CHI-9A0022 add l_bno
          #CALL s_mod_lot('axmt620',g_oga.oga01,l_ac,0,                             #TQC-B90236 #FUN-C30086 mark
           CALL s_mod_lot(l_tlf13,g_oga.oga01,l_ac,0,                               #TQC-B90236 #FUN-C30086 add
                         g_ogb.ogb04,g_imgg[l_ac].imgg02,
                         g_imgg[l_ac].imgg03,g_imgg[l_ac].imgg04,
                         g_ogb.ogb05,g_ogb.ogb15,g_ogb.ogb15_fac,
                         g_imgg[l_ac].shipqty,l_bno,'MOD',-1)#CHI-9A0022 add l_bno    #TQC-B90236 add -1
               RETURNING l_r,g_qty
           IF l_r = "Y" THEN
              LET g_ogb.ogb12 = g_qty
              LET b_ogb.ogb12 = s_digqty(b_ogb.ogb12,b_ogb.ogb05)   #No.FUN-BB0086
           END IF                                                               
     END IF
 
END FUNCTION                                                                                                                        
#No.FUN-870148--Add--End--#
