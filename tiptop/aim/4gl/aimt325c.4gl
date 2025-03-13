# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt325c.4gl
# Descriptions...: 兩階段倉庫調撥作業copy功能
#                  將出至境外倉出貨單可轉成調撥單
# Date & Author..: 01/04/17 By Mandy
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660008 06/06/15 BY Claire smy51在途倉取消使用 
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-870100 09/08/04 By Cockroach 零售超市移植
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0049 10/10/21 by destiny  增加倉庫的權限控管 
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No.FUN-B70074 11/07/20 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-BB0084 11/12/09 By lixh1 增加數量欄位小數取位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    l_imm                RECORD LIKE imm_file.*,
    l_img                RECORD
                         t_img02 LIKE img_file.img02,
                         t_img03 LIKE img_file.img03,
                         t_img04 LIKE img_file.img04
                         END RECORD,
    l_imm_t              RECORD LIKE imm_file.*,
    l_imm_o              RECORD LIKE imm_file.*,
    g_yy,g_mm            LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    t_imn15              LIKE imn_file.imn15,
    t_imn16              LIKE imn_file.imn16,
    g_wc,g_wc2,g_sql     string,                 #No.FUN-580092 HCN
    h_qty                LIKE ima_file.ima271,
    g_t1                 LIKE smy_file.smyslip,  #No.FUN-550029 #No.FUN-690026 VARCHAR(5)
    sn1,sn2              LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_code               LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_rec_b              LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    l_ac                 LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_sl                 LIKE type_file.num5,    #目前處理的SCREEN LINE  #No.FUN-690026 SMALLINT
    g_debit,g_credit     LIKE img_file.img26,
    g_ima25,g_ima25_2    LIKE ima_file.ima25,
   #g_ima86,g_ima86_2    LIKE ima_file.ima86,    #FUN-560183
    l_img10,l_img10_2    LIKE img_file.img10,
    g_argv1              LIKE imn_file.imn01     #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
FUNCTION aimt325c()
  DEFINE li_result   LIKE type_file.num5                        #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    INITIALIZE l_imm.* TO NULL
    INITIALIZE l_imm_t.* TO NULL
    INITIALIZE l_imm_o.* TO NULL
    OPEN WINDOW t325c_w AT 4,2              #顯示畫面
        WITH FORM "aim/42f/aimt325c"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE l_imm.* TO NULL
    LET l_imm_o.* = l_imm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET l_imm.imm02  =g_today
        LET l_imm.imm04  = 'N'
        LET l_imm.imm03  = 'N'
        LET l_imm.imm10  = '2'
        LET l_imm.immconf  = 'N'
        LET l_imm.immuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET l_imm.immgrup=g_grup
        LET l_imm.immdate=g_today
        LET l_imm.imm14=g_grup  #FUN-680006
        LET l_imm.immplant=g_plant  #No.FUN-870100
        LET l_imm.immlegal=g_legal  #No.FUN-980004 add
 
        BEGIN WORK
        CALL t325c_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE l_imm.* TO NULL
           INITIALIZE l_img.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK RETURN
        END IF
        IF l_imm.imm01 IS NULL THEN CONTINUE WHILE END IF
        #No.FUN-550029 --start--
        CALL s_auto_assign_no("aim",l_imm.imm01,l_imm.imm02,"","imm_file","imm01",
                  "","","")
             RETURNING li_result,l_imm.imm01
        IF (NOT li_result) THEN
             CONTINUE WHILE
        END IF
        DISPLAY BY NAME l_imm.imm01
#        IF g_smy.smyauno='Y' THEN
#	    CALL s_smyauno(l_imm.imm01,l_imm.imm02) RETURNING g_i,l_imm.imm01
#            IF g_i THEN CONTINUE WHILE END IF	#有問題
#	    DISPLAY BY NAME l_imm.imm01
#        END IF
        #No.FUN-550029 --end--
        COMMIT WORK
        SELECT imm01 INTO l_imm.imm01 FROM imm_file WHERE imm01 = l_imm.imm01
        LET l_imm_t.* = l_imm.*
        CALL t325c_b()   #給調撥作業單身值
        LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
        LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
        #FUN-A60034--add---str---
        LET l_imm.immmksg = 'N' #是否簽核
        LET l_imm.imm15 = '0'   #簽核狀況
        #FUN-A60034--add---end---
        INSERT INTO imm_file VALUES (l_imm.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins imm: ',SQLCA.SQLCODE,1)
           CALL cl_err3("ins","imm_file",l_imm.imm01,"",SQLCA.sqlcode,"",
                        "ins imm",1)   #NO.FUN-640266 #No.FUN-660156
           CONTINUE WHILE
        END IF
        COMMIT WORK
        EXIT WHILE
    END WHILE
    CALL cl_err(l_imm.imm09,'aim-325',1)
    CLOSE WINDOW t325c_w
    RETURN l_imm.imm01
END FUNCTION
 
FUNCTION t325c_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1      #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1      #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5      #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    INPUT BY NAME
	l_imm.imm01,l_imm.imm02,l_imm.imm08,l_imm.imm09,
        l_img.t_img02,l_img.t_img03,l_img.t_img04
           WITHOUT DEFAULTS
 
            #No.FUN-550029 --start--
        BEFORE INPUT
            CALL cl_set_docno_format("imm01")
            #No.FUN-550029 --end--
 
        AFTER FIELD imm01
        #No.FUN-550029 --start--
            CALL s_check_no("aim",l_imm.imm01,l_imm_t.imm01,"9","imm_file","imm01","")
                 RETURNING li_result,l_imm.imm01
            DISPLAY BY NAME l_imm.imm01
            IF (NOT li_result) THEN
               NEXT FIELD imm01
            END IF
#            LET g_t1=l_imm.imm01[1,3]
#            CALL s_mfgslip(g_t1,'aim','9')
#            IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0) NEXT FIELD imm01
#            END IF
#            IF p_cmd = 'a' AND cl_null(l_imm.imm01[5,10]) AND g_smy.smyauno = 'N'
#               THEN NEXT FIELD imm01
#            END IF
#            IF l_imm.imm01 != l_imm_t.imm01 OR l_imm_t.imm01 IS NULL THEN
#                IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(l_imm.imm01[5,10]) THEN
#                   CALL cl_err('','9056',0) NEXT FIELD imm01
#                END IF
#                SELECT count(*) INTO g_cnt FROM imm_file
#                    WHERE imm01 = l_imm.imm01
#                IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err(l_imm.imm01,-239,0)
#                    LET l_imm.imm01 = l_imm_t.imm01
#                    DISPLAY BY NAME l_imm.imm01
#                    NEXT FIELD imm01
#                END IF
#            END IF
            #No.FUN-550029 --end--
            #FUN-660008-begin-mark
            #IF cl_null(l_imm.imm08) THEN
            #   LET l_imm.imm08=g_smy.smy51
            #   DISPLAY BY NAME l_imm.imm08
            #END IF
            #FUN-660008-end-mark
 
        AFTER FIELD imm02
	   IF g_sma.sma53 IS NOT NULL AND l_imm.imm02 <= g_sma.sma53 THEN
	      CALL cl_err('','mfg9999',0) NEXT FIELD imm02
	   END IF
           CALL s_yp(l_imm.imm02) RETURNING g_yy,g_mm
           IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
              CALL cl_err('','mfg6091',0) NEXT FIELD imm02
           END IF
 
        AFTER FIELD imm08
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(l_imm.imm08) THEN
               NEXT FIELD imm08
            END IF 
            #No.FUN-AA0049--end                   
	   SELECT imd01 FROM imd_file WHERE imd01=l_imm.imm08
                                         AND imdacti = 'Y' #MOD-4B0169
      	   IF STATUS THEN
#             CALL cl_err('sel imd:',STATUS,1) NEXT FIELD imm08
              CALL cl_err3("sel","imd_file",l_imm.imm08,"",STATUS,"","sel imd",1)   #NO.FUN-640266 #No.FUN-660156
              NEXT FIELD imm08
           END IF
 
 
        AFTER FIELD imm09
           CALL t325c_imm09() #檢查出貨單號且出貨單號屬於'3'出至境外倉
           IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
           END IF
#------目的倉庫------------------------------------------------
        AFTER FIELD t_img02 #倉庫
         IF NOT cl_null(l_img.t_img02) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(l_img.t_img02) THEN
               NEXT FIELD t_img02
            END IF 
            #No.FUN-AA0049--end         
            CALL  s_stkchk(l_img.t_img02,'A') RETURNING l_code
            IF NOT l_code THEN
                #無此倉庫或性質不符!
                CALL cl_err(l_img.t_img02,'mfg1100',1)
                NEXT FIELD t_img02
            END IF
            #====>
            CALL  s_swyn(l_img.t_img02) RETURNING sn1,sn2
            IF sn1=1 AND l_img.t_img02 != t_imn15 THEN
                #====>警告! 您所輸入之倉庫為不可用倉
                CALL cl_err(l_img.t_img02,'mfg6080',1)
                LET t_imn15 = l_img.t_img02
                NEXT FIELD t_img02
            ELSE
                IF sn2=2 AND l_img.t_img02 != t_imn15 THEN
                    #====>警告! 您所輸入之倉庫為MPS/MRP不可用倉
                    CALL cl_err(l_img.t_img02,'mfg6085',0)
                    LET t_imn15 = l_img.t_img02
                    NEXT FIELD t_img02
                END IF
            END IF
         END IF
 
        AFTER FIELD t_img03  #儲位
         IF NOT cl_null(l_img.t_img03) THEN
            CALL s_lwyn(l_img.t_img02,l_img.t_img03)
                                   RETURNING sn1,sn2
            IF sn1=1 AND l_img.t_img03 != t_imn16 THEN
                #====>警告! 您所輸入之儲位為不可用倉儲位
                CALL cl_err(l_img.t_img03,'mfg6081',0)
                LET t_imn16 = l_img.t_img03
                NEXT FIELD t_img03
            ELSE
                IF sn2=2 AND l_img.t_img03 != t_imn16 THEN
                    #====>警告! 您所輸入之儲位為MPS/MRP不可用倉之儲位
                    CALL cl_err(l_img.t_img03,'mfg6086',0)
                    LET t_imn16 = l_img.t_img03
                    NEXT FIELD t_img03
                END IF
            END IF
            LET sn1=0 LET sn2=0
         END IF
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
	   IF l_imm.imm08 IS NULL THEN
              DISPLAY BY NAME l_imm.imm08
              CALL cl_err('','9033',0) NEXT FIELD imm08
	   END IF
 
        ON ACTION controlp
          CASE WHEN INFIELD(imm01) #查詢單
#                 LET g_t1=l_imm.imm01[1,3]
                 LET g_t1=s_get_doc_no(l_imm.imm01)    #No.FUN-550029
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_smy"
                 LET g_qryparam.default1 = g_t1,'aim','9'
                 CALL cl_create_qry() RETURNING g_t1
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET l_imm.imm01[1,3]=g_t1
                 LET l_imm.imm01=g_t1                  #No.FUN-550029
                 DISPLAY BY NAME l_imm.imm01
                 NEXT FIELD imm01
               WHEN INFIELD(imm08) #查詢在途倉
                 #No.FUN-AA0049--begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.default1 = l_imm.imm08 #MOD-4A0213
                 #LET g_qryparam.arg1     = 'W'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING l_imm.imm08
                 CALL q_imd_1(FALSE,TRUE,l_imm.imm08,'W',"","","") RETURNING l_imm.imm08
                 #No.FUN-AA0049--end
#                 CALL FGL_DIALOG_SETBUFFER( l_imm.imm08 )
                 DISPLAY BY NAME l_imm.imm08
                 NEXT FIELD imm08
               WHEN INFIELD(imm09) #查詢出至境外倉出貨單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oga3"
                 LET g_qryparam.default1 = l_imm.imm09,'3',''
                 CALL cl_create_qry() RETURNING l_imm.imm09
#                 CALL FGL_DIALOG_SETBUFFER( l_imm.imm09 )
                 DISPLAY BY NAME l_imm.imm09
                 NEXT FIELD imm09
               WHEN INFIELD(t_img02) OR INFIELD(t_img03) OR INFIELD(t_img04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_img4"
                 LET g_qryparam.default1 = ""
                 CALL cl_create_qry() RETURNING    l_img.t_img02,
                                      l_img.t_img03,l_img.t_img04
                 DISPLAY BY NAME
                        l_img.t_img02,l_img.t_img03,l_img.t_img04
                 IF INFIELD(t_img02) THEN NEXT FIELD t_img02 END IF
                 IF INFIELD(t_img03) THEN NEXT FIELD t_img03 END IF
                 IF INFIELD(t_img04) THEN NEXT FIELD t_img04 END IF
 
               OTHERWISE EXIT CASE
            END CASE
 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t325c_imm09() #檢查出貨單號且出貨單號屬於'3'出至境外倉
DEFINE
   l_ogaconf  LIKE oga_file.ogaconf
 
   LET g_errno=''
   SELECT ogaconf INTO l_ogaconf FROM oga_file
    WHERE oga01 = l_imm.imm09
      AND oga00 = '3' #出至境外倉
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aim-325'
       WHEN l_ogaconf='N'       LET g_errno='9029'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
 
FUNCTION t325c_b()
 DEFINE
    l_ogb   RECORD LIKE ogb_file.*,
    l_imn   RECORD LIKE imn_file.*,
    l_x     LIKE type_file.num5    #No.FUN-690026 SMALLINT
 DEFINE l_imni  RECORD LIKE imni_file.*   #FUN-B70074
 DEFINE l_flag  LIKE type_file.chr1       #FUN-B70074
 
    DECLARE t325c_b CURSOR FOR
         SELECT * FROM ogb_file
             WHERE ogb01=l_imm.imm09
    LET l_x=0
    FOREACH t325c_b INTO l_ogb.*
        LET l_x = l_x + 1
        LET l_imn.imn01  = l_imm.imm01
        LET l_imn.imn02  = l_x
        LET l_imn.imn03  = l_ogb.ogb04
        LET l_imn.imn04  = l_ogb.ogb09
        LET l_imn.imn05  = l_ogb.ogb091
        LET l_imn.imn06  = l_ogb.ogb092
        #No.FUN-AA0049--begin
       #IF NOT s_chk_ware(l_imn.imn04) THEN
       #   EXIT FOREACH 
       #END IF 
        #No.FUN-AA0049--end             
        LET l_imn.imn09  = l_ogb.ogb05
        LET l_imn.imn10  = l_ogb.ogb12
        LET l_imn.imn12  = 'N'
        IF cl_null(l_img.t_img02) THEN
            LET l_imn.imn15  = l_ogb.ogb09
        ELSE
            LET l_imn.imn15  = l_img.t_img02
        END IF
        IF cl_null(l_img.t_img03) THEN
            LET l_imn.imn16  = l_ogb.ogb091
        ELSE
            LET l_imn.imn16  = l_img.t_img03
        END IF
        IF cl_null(l_img.t_img04) THEN
            LET l_imn.imn17  = l_ogb.ogb092
        ELSE
            LET l_imn.imn17  = l_img.t_img04
        END IF
        LET l_imn.imn20  = l_ogb.ogb05
        LET l_imn.imn21  = 1
        LET l_imn.imn22  = l_imn.imn10 * l_imn.imn21
        LET l_imn.imn22  = s_digqty(l_imn.imn22,l_imn.imn20)   #FUN-BB0084
        LET l_imn.imn9301=l_ogb.ogb930    #FUN-680006
        LET l_imn.imn9302=l_imn.imn9301   #FUN-680006
        LET l_imn.imnplant=g_plant   #No.FUN-870100
        LET l_imn.imnlegal=g_legal   #No.FUN-980004 add
        INSERT INTO imn_file VALUES(l_imn.*)
        #FUN-B70074-add-str--
        IF NOT s_industry('std') THEN
           INITIALIZE l_imni.* TO NULL
           LET l_imni.imni01 = l_imn.imn01
           LET l_imni.imni02 = l_imn.imn02
           LET l_flag = s_ins_imni(l_imni.*,l_imn.imnplant)
        END IF
        #FUN-B70074-add-end--
    END FOREACH
END FUNCTION
#Patch....NO.TQC-610036 <001> #
