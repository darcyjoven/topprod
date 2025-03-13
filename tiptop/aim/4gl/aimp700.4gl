# Prog. Version..: '5.30.06-13.04.10(00010)'     #
#
# Pattern name...: aimp700.4gl
# Descriptions...: 工廠間調撥－撥出確認作業
# Date & Author..: 93/07/05 By Apple
# NOTE...........: 調撥單已列印但作廢,可是必須保存作為憑證
# Modify.........: NO.MOD-490217  04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-550029 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-550011 05/05/25 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570249 05/07/27 By Carrier 多單位內容修改
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.FUN-5C0077 05/12/23 By yoyo報表欄位增加imn29
# Modify.........: No.FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: NO.FUN-650172 06/05/24 by Claire 修改語法
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE              
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710025 07/01/18 By bnlent  錯誤訊息匯整 
# Modify.........: No.TQC-740249 07/04/24 By Rayven 語言別功能無效 
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.FUN-770057 07/08/13 By rainy 改為多欄輸入
# Modify.........: No.TQC-790001 07/09/03 By Mandy PK 問題
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID  
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930155 09/04/02 By dongbg open cursor或fetch cursor失敗時不要rollback,給g_success賦值
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/09 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:CHI-A90045 10/10/12 By lilingyu 兩階段調撥,撥出審核後,庫存沒有轉移到在途倉
# Modify.........: No:MOD-AB0009 10/11/23 By sabrina 跳到項次2(無輸入資料)時，按下確定沒反應
# Modify.........: No:MOD-AC0329 10/12/25 By (1) 單身在BEFORE ROW時不用做資料lock
#                                            (2) 過帳時應使用g_ims[l_ac]的變數，否則扣帳只會扣到最後一筆資料 
# Modify.........: No:MOD-B20021 11/02/10 By sabrina 若單身皆已確認，則單頭immconf、imm04、imm03也要更新為'Y'
# Modify.........: No:MOD-B20090 11/02/18 By sabrina 單身按放棄時，資料不應做寫入動作 
# Modify.........: No:TQC-BA0007 11/10/20 By Smapmin 沒有輸入確認日期與密碼欄位直接按確認,g_go就沒有給值,導致直接離開程式
# Modify.........: No:FUN-BB0084 11/12/09 By lixh1 增加數量欄位小數取位
# Modify.........: No:TQC-C60073 12/06/11 By chenjing 修改點擊確定以後移動不成功問題
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.MOD-CA0009 12/10/12 By Elise 倉庫有效日期不應控卡
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No.MOD-D30212 13/03/26 By bart s_upimg 的傳遞變數應使用g_ims[l_ac]的變數
# Modify.........: No.CHI-D10014 13/04/03 By bart 1.增加開窗2.增加批序號
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    #FUN-770057 begin
       #g_ims         RECORD LIKE ims_file.*,
       #g_ims_t       RECORD LIKE ims_file.*,
       g_ims01        LIKE  ims_file.ims01,
       g_ims10        LIKE  ims_file.ims10,
       g_ims11        LIKE  ims_file.ims11,
       g_ims  DYNAMIC ARRAY OF  RECORD
                ims02   LIKE  ims_file.ims02,
                ims04   LIKE  ims_file.ims04,
                imn03   LIKE  imn_file.imn03,
                ima02   LIKE  ima_file.ima02,
                ima05   LIKE  ima_file.ima05,
                ima08   LIKE  ima_file.ima08,
                imn29   LIKE  imn_file.imn29,
                imn04   LIKE  imn_file.imn04,
                imn05   LIKE  imn_file.imn05,
                imn06   LIKE  imn_file.imn06,
                desc    LIKE  ze_file.ze03,
                imn10   LIKE  imn_file.imn10,
                imn091  LIKE  imn_file.imn091,
                imn09   LIKE  imn_file.imn09,
                imn092  LIKE  imn_file.imn092,
                imn07   LIKE  imn_file.imn07,
                img10   LIKE  img_file.img10,
                imn11   LIKE  imn_file.imn11,
                imn9301 LIKE  imn_file.imn9301,
                gem02b  LIKE  gem_file.gem02,
                imn33   LIKE  imn_file.imn33,
                imn35   LIKE  imn_file.imn35,
                imgg10_2 LIKE imgg_file.imgg10,
                imn30   LIKE  imn_file.imn30,
                imn32   LIKE  imn_file.imn32,
                imgg10_1 LIKE imgg_file.imgg10,
                imn9302 LIKE  imn_file.imn9302,
                gem02c  LIKE  gem_file.gem02,
                ims06   LIKE  ims_file.ims06, 
                imn09_2 LIKE  imn_file.imn09,
                ims15   LIKE  ims_file.ims15,
                imn33_2 LIKE  imn_file.imn33,
                ims14   LIKE  ims_file.ims14,
                imn30_2 LIKE  imn_file.imn30
               END RECORD, 
      g_ims_t  RECORD
                ims02   LIKE  ims_file.ims02,
                ims04   LIKE  ims_file.ims04,
                imn03   LIKE  imn_file.imn03,
                ima02   LIKE  ima_file.ima02,
                ima05   LIKE  ima_file.ima05,
                ima08   LIKE  ima_file.ima08,
                imn29   LIKE  imn_file.imn29,
                imn04   LIKE  imn_file.imn04,
                imn05   LIKE  imn_file.imn05,
                imn06   LIKE  imn_file.imn06,
                desc    LIKE  ze_file.ze03,
                imn10   LIKE  imn_file.imn10,
                imn091  LIKE  imn_file.imn091,
                imn09   LIKE  imn_file.imn09,
                imn092  LIKE  imn_file.imn092,
                imn07   LIKE  imn_file.imn07,
                img10   LIKE  img_file.img10,
                imn11   LIKE  imn_file.imn11,
                imn9301 LIKE  imn_file.imn9301,
                gem02b  LIKE  gem_file.gem02,
                imn33   LIKE  imn_file.imn33,
                imn35   LIKE  imn_file.imn35,
                imgg10_2 LIKE imgg_file.imgg10,
                imn30   LIKE  imn_file.imn30,
                imn32   LIKE  imn_file.imn32,
                imgg10_1 LIKE imgg_file.imgg10,
                imn9302 LIKE  imn_file.imn9302,
                gem02c  LIKE  gem_file.gem02,
                ims06   LIKE  ims_file.ims06, 
                imn09_2 LIKE  imn_file.imn09,
                ims15   LIKE  ims_file.ims15,
                imn33_2 LIKE  imn_file.imn33,
                ims14   LIKE  ims_file.ims14,
                imn30_2 LIKE  imn_file.imn30
               END RECORD, 
                     
    l_ac,l_ac_t    LIKE type_file.num5,    #未取消的ARRAY CNT 
    g_rec_b        LIKE type_file.num5,
    g_wc           STRING, 
    g_row_count    LIKE type_file.num10,
    g_curs_index   LIKE type_file.num10,
    g_jump         LIKE type_file.num10,
    mi_no_ask      LIKE type_file.num5,
    g_imn041       LIKE imn_file.imn041,
    g_imn151       LIKE imn_file.imn151,
    #FUN-770057 end
       g_imm         RECORD LIKE imm_file.*,
       g_imm_o       RECORD LIKE imm_file.*,
       g_imn         RECORD LIKE imn_file.*,
       g_pass        LIKE ims_file.ims11,          #FUN-660078
       g_pp          RECORD
                     dummy LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                     pass  LIKE azb_file.azb02,
	             cdate LIKE type_file.dat      #No.FUN-690026 DATE
                     END RECORD,
       g_sql         string,  #No.FUN-580092 HCN
       g_t1          LIKE oay_file.oayslip,        #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
       s_no          LIKE type_file.num5,          #No.FUN-690026 SMALLINT
       g_ims01_t     LIKE ims_file.ims01,
       g_ims02_t     LIKE ims_file.ims02,
       g_img10       LIKE img_file.img10,
       g_img21_fac   LIKE img_file.img21,
       g_img23       LIKE img_file.img23,
       g_img24       LIKE img_file.img24,
       g_img26       LIKE img_file.img26,
      #g_ima86       LIKE ima_file.ima86,          #FUN-560183
       g_invqty      LIKE img_file.img10,
       g_status,g_go LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
       g_yn,g_no     LIKE type_file.num5
 
DEFINE g_forupd_sql     STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_ima906         LIKE ima_file.ima906,
       g_ima907         LIKE ima_file.ima907,
       g_imgg10_1       LIKE imgg_file.imgg10,   
       g_imgg10_2       LIKE imgg_file.imgg10,   
       g_sw             LIKE type_file.num5,     #No.FUN-690026 SMALLINT
       g_factor         LIKE img_file.img21,
       g_tot            LIKE img_file.img10,
       g_flag           LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
DEFINE g_chr            LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
DEFINE l_qcs091         LIKE qcs_file.qcs091     #No.FUN-5C0077
DEFINE g_cnt            LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_i              LIKE type_file.num5      #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(72)
DEFINE g_imm01          LIKE imm_file.imm01      #No.FUN-610090
DEFINE g_unit_arr       DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                        END RECORD
DEFINE g_count          LIKE type_file.num5    #CHI-A90045
DEFINE g_count_1        LIKE type_file.num5    #CHI-A90045 
DEFINE g_img10_wip      LIKE img_file.img10    #CHI-A90045
DEFINE l_flag01         LIKE type_file.chr1    #FUN-C80107 add
DEFINE g_ima918         LIKE ima_file.ima918   #CHI-D10014
DEFINE g_ima921         LIKE ima_file.ima921   #CHI-D10014
DEFINE l_r              LIKE type_file.chr1    #CHI-D10014
DEFINE g_qty            LIKE type_file.num5    #CHI-D10014

MAIN
   OPTIONS
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074
 
   #INITIALIZE g_ims.* TO NULL  #FUN-770057
   CALL g_ims.CLEAR()           #FUN-770057
   INITIALIZE g_imm.* TO NULL
   INITIALIZE g_imn.* TO NULL
 
   OPEN WINDOW p700_w WITH FORM "aim/42f/aimp700"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL p700_mu_ui()
 
   CALL p700_pass()
 
   IF g_go = 'N' THEN
      CLOSE WINDOW p700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0074
      EXIT PROGRAM
   END IF
 
   CALL p700()    #FUN-770057
 
   CLOSE WINDOW p700_w                         #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION p700_cur()
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
    #---->調撥單單身讀取(LOCK 此筆單身)
    LET l_sql=
        "SELECT * ",
        " FROM  imn_file ",
        "   WHERE imn01= ? ",
        "   AND imn02= ? ",
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE imn_p FROM l_sql
    DECLARE imn_lock CURSOR FOR imn_p
 
    #---->多倉時讀取庫存資料明細檔(LOCK 此筆單身)
    IF g_sma.sma12 = 'Y' THEN 
       LET l_sql=
           "SELECT ",
           " img10,img21,img23,img24,img26 ",
           " FROM  img_file ",
           "   WHERE img01= ? ",
           "   AND img02= ? ",
           "   AND img03= ? ",
           "   AND img04= ? ",
           "   FOR UPDATE "
       LET l_sql=cl_forupd_sql(l_sql)

       PREPARE img_p FROM l_sql
       DECLARE img_lock CURSOR FOR img_p
 
       #No.FUN-570249  --begin
       LET l_sql=
           "SELECT imgg10",
           " FROM  imgg_file ",
           "   WHERE imgg01= ? ",
           "   AND imgg02= ? ",
           "   AND imgg03= ? ",
           "   AND imgg04= ? ",
           "   AND imgg09= ? ",
           "   FOR UPDATE "
       LET l_sql=cl_forupd_sql(l_sql)

       PREPARE imgg_p FROM l_sql
       DECLARE imgg_lock1 CURSOR FOR imgg_p
       #No.FUN-570249  --end
    END IF
 
    #---->讀取料件基本資料檔(LOCK 此筆單身)
    LET l_sql=
#       "SELECT ima02,ima05,ima08,ima262 ", #FUN-560183 拿掉ima86    #FUN-A20044
        "SELECT ima02,ima05,ima08,'' ",        #FUN-A20044   
        " FROM ima_file",
        "   WHERE ima01= ? ",
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE ima_p FROM l_sql
    DECLARE ima_lock CURSOR FOR ima_p
 
    #---->DEFAULT 調撥項次
    LET l_sql= 
        " SELECT imn02 FROM imn_file WHERE imn01 = ? "
         PREPARE imn_pr FROM l_sql
         DECLARE imn_cs SCROLL CURSOR FOR imn_pr
 
END FUNCTION 
 
#FUN-770057 begin
FUNCTION p700()
  DEFINE li_result   LIKE type_file.num5,        #No.FUN-550029  #No.FUN-690026 SMALLINT
         l_cnt       LIKE type_file.num5
  IF s_shut(0) THEN RETURN END IF
  CALL ui.Interface.refresh()
 
  MESSAGE ""
  CALL cl_opmsg('a')
  WHILE TRUE
    CLEAR FORM
    LET g_ims01 = null
    LET g_ims10 = g_pp.cdate
    LET g_ims11 = g_pass
    LET g_rec_b = 0
    INITIALIZE g_imm.* TO NULL
    INITIALIZE g_imn.* TO NULL
    CALL g_ims.clear()
    CALL p700_i()                #輸入單頭
    IF INT_FLAG THEN             #使用者不輸入了
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
    END IF
    CALL p700_plant()
 
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ims_file WHERE ims01 = g_ims01
    IF l_cnt = 0 AND g_sma.sma88 ='N' THEN
      CALL s_auto_assign_no("aim",g_ims01,g_ims10,"9","ims_file","ims01",
                            "","","")
      RETURNING li_result,g_ims01
      IF (NOT li_result) THEN
           CONTINUE WHILE
      END IF
      DISPLAY g_ims01 TO ims01
    END IF
 
    #進入單身輸入
     #LET g_no=0   #TQC-BA0007
     CALL p700_b()             
    END WHILE
END FUNCTION
 
FUNCTION p700_plant()
 
  IF cl_null(g_imm.imm01) THEN RETURN END IF
  SELECT DISTINCT imn041,imn151 
    INTO g_imn041,g_imn151
    FROM imn_file
   WHERE imn01 = g_imm.imm01
  IF SQLCA.sqlcode THEN
    LET g_imn041 = ''
    LET g_imn151 = ''
  END IF
  DISPLAY g_imn041 TO imn041
  DISPLAY g_imn151 TO imn151 
END FUNCTION
 
FUNCTION p700_b()
DEFINE
    l_n,i           LIKE type_file.num5,    #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態  
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5,     #可刪除否  
    l_diff     LIKE imn_file.imn10
DEFINE b_imn        RECORD LIKE imn_file.*  #No.FUN-610090
DEFINE l_ims02      LIKE ims_file.ims02     #FUN-770057
DEFINE l_cnt        LIKE type_file.num5     #MOD-B20021 add
DEFINE l_sql        STRING                  #CHI-D10014
DEFINE l_i          LIKE type_file.num5     #CHI-D10014
DEFINE l_rvbs06     LIKE rvbs_file.rvbs06   #CHI-D10014
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_ims01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    #-----TQC-BA0007---------
    #LET g_forupd_sql =
    # "  SELECT ims02,ims04,'','','','','','','','', ",
    # "         '','','','','','','','','','',",
    # "         '','','','','','','','',ims06,0,",
    # "         ims15,0,ims14,0 ",
    # "  FROM ims_file ",
    # "  WHERE ims01 = ? ",
    # "    AND ims02 = ? ",
    # "  FOR UPDATE "
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    #
    #DECLARE p700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    #-----END TQC-BA0007----- 
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")   #TQC-BA0007
    #LET l_allow_delete = FALSE   #TQC-BA0007
 
    INPUT ARRAY g_ims WITHOUT DEFAULTS FROM s_ims.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         LET g_success = "Y"   #TQC-BA0007
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_ims_t.* = g_ims[l_ac].*  #BACKUP
          #MOD-AC0329---mark---start--- 
          # OPEN p700_bcl USING g_ims01,g_ims_t.ims02
          ##DISPLAY g_ims01,g_ims_t.ims02   #CHI-A70049 mark
          # IF STATUS THEN
          #    CALL cl_err("OPEN p700_bcl:", STATUS, 1)
          #    LET l_lock_sw = "Y"
          # ELSE
          #    FETCH p700_bcl INTO g_ims[l_ac].*
          #    IF SQLCA.sqlcode THEN
          #        CALL cl_err(g_ims_t.ims02,SQLCA.sqlcode,1)
          #        LET l_lock_sw = "Y"
          #    END IF
          #    LET g_ims[l_ac].gem02b=s_costcenter_desc(g_ims[l_ac].imn9301) 
          #    LET g_ims[l_ac].gem02c=s_costcenter_desc(g_ims[l_ac].imn9302) 
          # END IF
          #MOD-AC0329---mark---end---
            CALL cl_show_fld_cont()    
         END IF
         #LET g_no=g_no+1   #TQC-BA0007
         CALL p700_cur()
 
      BEFORE FIELD ims02
        IF g_ims[l_ac].ims02 IS NULL OR g_ims[l_ac].ims02 = 0 
           OR g_ims02_t IS NULL OR g_ims02_t = ' ' THEN
           LET g_ims[l_ac].ims02=g_ims[l_ac].ims04
           DISPLAY BY NAME g_ims[l_ac].ims02
        END IF
        SELECT COUNT(*) INTO l_n
          FROM ims_file
         WHERE ims01 = g_ims01
           AND ims02 = g_ims[l_ac].ims02
        IF l_n > 0 THEN
          SELECT MAX(ims02) INTO l_ims02
            FROM ims_file
           WHERE ims01 = g_ims01
          LET g_ims[l_ac].ims02 = l_ims02 + 1
          DISPLAY BY NAME g_ims[l_ac].ims02
        END IF
 
      AFTER FIELD ims02  
        #MOD-AB0009---mark---start---
        #IF g_ims[l_ac].ims02 IS NULL OR g_ims[l_ac].ims02 <=0 THEN
        #   NEXT FIELD ims02
        #END IF
        #MOD-AB0009---mark---end---
         IF g_ims[l_ac].ims02 IS NOT NULL THEN  
            SELECT COUNT(*) INTO l_n
              FROM ims_file
             WHERE ims01 = g_ims01
               AND ims02 = g_ims[l_ac].ims02
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               DISPLAY BY NAME g_ims[l_ac].ims02
               NEXT FIELD ims02
            END IF
            #-----TQC-BA0007---------
            FOR i = 1 TO g_rec_b
              IF i <> l_ac THEN
                 IF g_ims[i].ims02 = g_ims[l_ac].ims02 THEN
                   CALL cl_err(g_ims[l_ac].ims02,'asf-406',0)
                   NEXT FIELD ims02
                 END IF
              END IF
            END FOR
            #-----END TQC-BA0007-----
         END IF
 
      BEFORE FIELD ims04
        IF cl_null(g_ims[l_ac].ims04) THEN
         OPEN imn_cs USING g_imm.imm01
         #FETCH ABSOLUTE g_no imn_cs INTO g_ims[l_ac].ims04   #TQC-BA0007
         FETCH ABSOLUTE l_ac imn_cs INTO g_ims[l_ac].ims04   #TQC-BA0007
         CALL p700_set_entry_b()  
        END IF
 
      AFTER FIELD ims04          
        #MOD-AB0009---mark---start---
        #IF g_ims[l_ac].ims04 IS NULL OR g_ims[l_ac].ims04 = ' ' OR g_ims[l_ac].ims04 = 0 THEN
        #   LET g_ims[l_ac].ims04 = g_ims_t.ims04 
        #   DISPLAY BY NAME g_ims[l_ac].ims04
        #   NEXT FIELD ims04
        #END IF
        #MOD-AB0009---mark---end---
         #檢查撥出單身是否重複
         IF g_ims[l_ac].ims04 != g_ims_t.ims04 OR g_ims_t.ims04 IS NULL THEN
           #判斷目前輸入的array是否有重覆
            FOR i = 1 TO g_rec_b
              IF i <> l_ac THEN
                 IF g_ims[i].ims04 = g_ims[l_ac].ims04 THEN
                   CALL cl_err(g_ims[l_ac].ims04,'asf-406',0)
                   NEXT FIELD ims04
                 END IF
              END IF
            END FOR
           ##
            SELECT COUNT(*) INTO l_n
              FROM ims_file
             WHERE ims01 = g_ims01     #撥出單號
               AND ims02 = g_ims[l_ac].ims02     #撥出批次
               AND ims03 = g_imm.imm01     #調撥單號
               AND ims04 = g_ims[l_ac].ims04     #調撥項次
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_ims[l_ac].ims04 = g_ims_t.ims04
               NEXT FIELD ims04
            END IF
            CALL p700_ims04()              #MOD-AB0009 add
         END IF
        #CALL p700_ims04()                 #MOD-AB0009 mark
 
         IF NOT cl_null(g_chr) THEN
            CALL cl_err(g_ims[l_ac].ims04,g_errno,0)
            IF g_errno="mfg3471" THEN
               DECLARE p700_s1_c2 CURSOR FOR SELECT * FROM imn_file
                 WHERE imn01 = g_imm.imm01
                   AND imn02 = g_ims[l_ac].ims04
            
               LET g_imm01 = ""
               #LET g_success = "Y"   #TQC-BA0007
               #CALL s_showmsg_init()    #No.FUN-710025    #TQC-BA0007
               FOREACH p700_s1_c2 INTO b_imn.*
                  IF STATUS THEN
                     LET g_success = "N"    #FUN-8A0086
                     EXIT FOREACH
                  END IF
            
                  #-----TQC-BA0007--------- 
                  #IF g_success='N' THEN                                                                                                        
                  # LET g_totsuccess='N'                                                                                                      
                  # LET g_success="Y"                                                                                                         
                  #END IF                   
                  #-----END TQC-BA0007-----                                                                                                     
 
                  IF g_sma.sma115 = 'Y' THEN
                     IF g_ima906 = '2' THEN  #子母單位
                        LET g_unit_arr[1].unit= b_imn.imn30
                        LET g_unit_arr[1].fac = b_imn.imn31
                        LET g_unit_arr[1].qty = b_imn.imn32
                        LET g_unit_arr[2].unit= b_imn.imn33
                        LET g_unit_arr[2].fac = b_imn.imn34
                        LET g_unit_arr[2].qty = b_imn.imn35
                        CALL s_dismantle(g_imm.imm01,b_imn.imn02,g_imm.imm12,
                                         b_imn.imn03,b_imn.imn04,b_imn.imn05,
                                         b_imn.imn06,g_unit_arr,g_imm01)
                               RETURNING g_imm01
                        #-----TQC-BA0007--------- 
                        IF g_success='N' THEN                                                                                                        
                           LET g_totsuccess='N'                                                                                                      
                           LET g_success="Y"                                                                                                         
                        END IF 
                        #-----END TQC-BA0007-----                                                                                                                      
                     END IF
                  END IF
               END FOREACH
               IF g_totsuccess="N" THEN                                                                                                         
                   LET g_success="N"                                                                                                             
               END IF                                                                                                                           
 
               IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
                  LET g_msg="aimt324 '",g_imm01,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
               END IF
            END IF
            NEXT FIELD ims04
         END IF 
         CALL p700_set_no_entry_b()  
 
 
 
      #BEFORE FIELD ims06  #CHI-D10014
      IF NOT cl_null(g_ims[l_ac].ims04) THEN  #CHI-D10014
         LET l_diff = g_ims[l_ac].imn10 - g_ims[l_ac].imn11
         LET g_ims[l_ac].ims06 = l_diff 
         DISPLAY BY NAME g_ims[l_ac].ims06 
         #CHI-D10014---begin
         IF g_ims[l_ac].ims02 IS NULL OR g_ims[l_ac].ims02 = 0 
            OR g_ims02_t IS NULL OR g_ims02_t = ' ' THEN
            LET g_ims[l_ac].ims02=g_ims[l_ac].ims04
            DISPLAY BY NAME g_ims[l_ac].ims02
         END IF
         DELETE FROM rvbs_file
         WHERE rvbs00 = g_prog
           AND rvbs01 = g_ims01
           AND rvbs02 = g_ims[l_ac].ims02
         LET l_sql = "INSERT INTO rvbs_file ",
                     " (rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                     "  rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal) ",
               " SELECT '",g_prog,"','",g_ims01,"',",g_ims[l_ac].ims02,  
               "   ,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
               "        rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal ",
               "   FROM rvbs_file ",
               "  WHERE rvbs00 = 'aimt700' ",
               "    AND rvbs01 = ? ",
               "    AND rvbs02 = ? "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
         PREPARE rvbs_p1 FROM l_sql
         EXECUTE rvbs_p1 USING g_imm.imm01,g_ims[l_ac].ims04
         IF STATUS THEN
            CALL cl_err('',STATUS,0)
         END IF 
      END IF 
         #CHI-D10014---end
         
      AFTER FIELD ims06
         CALL p700_ims06()
         IF g_status ='N' THEN NEXT FIELD ims06 END IF
         #CHI-D10014---begin
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_ims[l_ac].imn03
            AND imaacti = "Y"
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            CALL s_lotout(g_prog,g_ims01,g_ims[l_ac].ims02,0,
                          g_ims[l_ac].imn03,g_ims[l_ac].imn04,
                          g_ims[l_ac].imn05,g_ims[l_ac].imn06,
                          g_ims[l_ac].imn09,g_ims[l_ac].imn09,1,
                          g_ims[l_ac].ims06,'','SEL')
                   RETURNING l_r,g_qty
            IF l_r = 'Y' THEN
               LET g_ims[l_ac].ims06 = g_qty
            END IF
            DISPLAY BY NAME g_ims[l_ac].ims06

         END IF
         #CHI-D10014---end
         
      AFTER FIELD ims14
         CALL p700_ims14()
         CALL p700_set_origin_field()
         #---->檢查是否已超撥(不允許)
         IF (g_ims[l_ac].imn11 + g_ims[l_ac].ims06) > g_ims[l_ac].imn10 THEN 
            #CALL s_errmsg('','','','mfg3470',0)    #TQC-BA0007
            CALL cl_err('','mfg3470',0)    #TQC-BA0007
            LET g_status ='N' 
         END IF
         IF g_status ='N' THEN NEXT FIELD ims14 END IF
 
      AFTER FIELD ims15
         CALL p700_ims15()
         CALL p700_set_origin_field()
         #---->檢查是否已超撥(不允許)
         IF (g_ims[l_ac].imn11 + g_ims[l_ac].ims06) > g_ims[l_ac].imn10 THEN 
            #CALL s_errmsg('','','','mfg3470',0)    #TQC-BA0007
            CALL cl_err('','mfg3470',0)    #TQC-BA0007
            LET g_status ='N' 
         END IF
         IF g_status ='N' THEN NEXT FIELD ims15 END IF
     
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ims04) #調撥項次
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imn1"
               LET g_qryparam.default1 = g_imm.imm01
               IF NOT cl_null(g_imm.imm01) THEN
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.where = " imn01 = '",g_imm.imm01,"'"
               END IF
               CALL cl_create_qry() RETURNING g_imm.imm01,g_ims[l_ac].ims04,
                                              g_ims[l_ac].imn03
               SELECT imn04,imn05,imn06,imn09 
                 INTO g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,g_ims[l_ac].imn09
                 FROM imn_file
                WHERE imn27 IN ('N','n') AND imn01 = g_imm.imm01
                  AND imn02 = g_ims[l_ac].ims04 AND imn03 = g_ims[l_ac].imn03
               DISPLAY BY NAME g_ims[l_ac].ims04 
               DISPLAY BY NAME g_imm.imm01,g_ims[l_ac].imn03,g_ims[l_ac].imn04,
                               g_ims[l_ac].imn05,g_ims[l_ac].imn06,g_ims[l_ac].imn09
                               
               NEXT FIELD ims04
            OTHERWISE EXIT CASE
         END CASE
 
     #MOD-AC0329---add---start---
      AFTER ROW
         #CHI-D10014---begin
         IF NOT cl_null(g_ims[l_ac].imn03) AND NOT cl_null(g_ims[l_ac].ims06) THEN 
            SELECT ima918,ima921 INTO g_ima918,g_ima921
              FROM ima_file
             WHERE ima01 = g_ims[l_ac].imn03
               AND imaacti = "Y"
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               SELECT SUM(rvbs06) INTO l_rvbs06
                 FROM rvbs_file
                WHERE rvbs00 = g_prog
                  AND rvbs01 = g_ims01
                  AND rvbs02 = g_ims[l_ac].ims02
                  AND rvbs09 = -1
                  AND rvbs13 = 0

               IF cl_null(l_rvbs06) THEN
                  LET l_rvbs06 = 0
               END IF

               IF g_ims[l_ac].ims06 <> l_rvbs06 THEN
                  CALL cl_err(g_ims[l_ac].ims02,"aim-011",1)
                  NEXT FIELD ims06
               END IF
            END IF
         END IF   
         #CHI-D10014---end
         COMMIT WORK
     #MOD-AC0329---add---end---

    #  #ON ROW CHANGE
      AFTER INSERT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL p700_free()
        END IF
        LET g_rec_b = g_rec_b + 1
        #LET g_success = 'Y'
        #IF p700_t2() THEN
        #   LET g_success='N'
        #ELSE 
        #   LET g_yn=g_yn+1
        #END IF
        #IF g_success = 'Y' THEN
        #  CALL cl_cmmsg(4)  
        #  COMMIT WORK
        #  CALL p700_free()       
        #ELSE 
        #  CALL cl_rbmsg(4)  
        #  ROLLBACK WORK
        #END IF
 
 
      AFTER INPUT 
         IF INT_FLAG THEN 
            LET INT_FLAG = 0
            EXIT INPUT 
         END IF
         IF g_sma.sma115='Y' THEN
            IF cl_null(g_ims[l_ac].ims14) AND cl_null(g_ims[l_ac].ims15) OR
               g_ims[l_ac].ims14 <0 OR  g_ims[l_ac].ims15<0 OR
              (g_ims[l_ac].ims14 =0 AND g_ims[l_ac].ims15=0) THEN
              NEXT FIELD ims14
            END IF
            CALL p700_set_origin_field()
            #---->檢查是否已超撥(不允許)
            IF (g_ims[l_ac].imn11 + g_ims[l_ac].ims06) > g_ims[l_ac].imn10 THEN 
               #CALL s_errmsg('','','','mfg3470',0)    #TQC-BA0007
               CALL cl_err('','mfg3470',0)    #TQC-BA0007
               LET g_status ='N' 
            END IF
         END IF
         IF NOT cl_null(g_ims[l_ac].ims02) AND NOT cl_null(g_ims[l_ac].ims04) THEN      #No:MOD-AB0009 add
            IF g_ims[l_ac].ims06 IS NULL OR g_ims[l_ac].ims06 = ' ' OR g_ims[l_ac].ims06 <= 0 THEN
               NEXT FIELD ims06
            END IF
         END IF         #MOD-AB0009 add
        #-----TQC-BA0007---------
        ##MOD-B20090---add---start---
        ##將此段移到AFTER INPUT裡
        ##整批處理
        # BEGIN WORK          
        # FOR i = 1 TO g_rec_b
        #    LET l_ac = i
        #    LET g_success = 'Y'
        #    IF p700_t2() THEN
        #       LET g_success='N'
        #    ELSE 
        #       LET g_yn=g_yn+1
        #       LET l_cnt = 0
        #       SELECT COUNT(*) INTO l_cnt FROM imn_file
        #        WHERE imn01 = g_imm.imm01
        #          AND imn12 = 'N'
        #       IF l_cnt = 0 THEN
        #          UPDATE imm_file SET immconf = 'Y',imm04 = 'Y',imm03 = 'Y'
        #           WHERE imm01 = g_imm.imm01
        #       END IF
        #    END IF
        #  END FOR
        #  IF g_success = 'Y' THEN
        #    CALL cl_cmmsg(4)  
        #    COMMIT WORK
        #    CALL p700_free()       
        #  ELSE 
        #    CALL cl_rbmsg(4)  
        #    ROLLBACK WORK
        #  END IF
        ##MOD-B20090---add---end---
        #-----END TQC-BA0007-----

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
      #CHI-D10014---begin
      ON ACTION CANCEL
         ROLLBACK WORK
         DELETE FROM rvbs_file
         WHERE rvbs00 = g_prog
           AND rvbs01 = g_ims01
         COMMIT WORK 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 

      ON ACTION modi_lot
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_ims[l_ac].imn03
            AND imaacti = "Y"
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            CALL s_lotout(g_prog,g_ims01,g_ims[l_ac].ims02,0,
                          g_ims[l_ac].imn03,g_ims[l_ac].imn04,
                          g_ims[l_ac].imn05,g_ims[l_ac].imn06,
                          g_ims[l_ac].imn09,g_ims[l_ac].imn09,1,
                          g_ims[l_ac].ims06,'','SEL')
                   RETURNING l_r,g_qty
            IF l_r = 'Y' THEN
               LET g_ims[l_ac].ims06 = g_qty
            END IF
            DISPLAY BY NAME g_ims[l_ac].ims06

         END IF
      #CHI-D10014---end
    END INPUT
 
    #-----TQC-BA0007---------
    #MOD-B20090---mark---start---
    #將此段移到AFTER INPUT裡
    #整批處理
    IF cl_sure(18,20) THEN     #TQC-BA0007
       BEGIN WORK            #MOD-AC0329 add
       LET g_success = 'Y'   #TQC-BA0007
       FOR i = 1 TO g_rec_b
          LET l_ac = i
          #LET g_success = 'Y'   #TQC-BA0007
          IF p700_t2() THEN
             LET g_success='N'
          ELSE 
             LET g_yn=g_yn+1
            #MOD-B20021---add---start---
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM imn_file
              WHERE imn01 = g_imm.imm01
                AND imn12 = 'N'
             IF l_cnt = 0 THEN
                UPDATE imm_file SET immconf = 'Y',imm04 = 'Y',imm03 = 'Y'
                 WHERE imm01 = g_imm.imm01
             END IF
            #MOD-B20021---add---end---
          END IF
        END FOR
        IF g_success = 'Y' THEN
          CALL cl_cmmsg(4)  
          COMMIT WORK
          CALL p700_free()       
        ELSE 
           #CHI-D10014---begin
           FOR g_i = 1 TO g_rec_b
              IF NOT s_del_rvbs('1',g_ims01,g_ims[g_i].ims02,0)  THEN       
                 RETURN
              END IF
              IF NOT s_del_rvbs('2',g_ims01,g_ims[g_i].ims02,0)  THEN       
                 RETURN
              END IF
           END FOR
           #CHI-D10014---end
           CALL cl_rbmsg(4)  
           ROLLBACK WORK
        END IF
    #CHI-D10014---begin
    ELSE
        FOR g_i = 1 TO g_rec_b
            IF NOT s_del_rvbs('1',g_ims01,g_ims[g_i].ims02,0)  THEN       
               RETURN
            END IF
        END FOR
    #CHI-D10014---end
    END IF   #TQC-BA0007
    #MOD-B20090---mark---end---
    #-----END TQC-BA0007-----
   ##
 
    #CLOSE p700_bcl   #TQC-BA0007
    #COMMIT WORK   #TQC-BA0007
END FUNCTION
#FUN-770057 end
 
 
#FUN-770057 remark begin
#FUNCTION p700_p()
#    DEFINE  li_result    LIKE type_file.num5                #No.FUN-550029  #No.FUN-690026 SMALLINT
#
#    CALL cl_opmsg('a')
#    MESSAGE ""
#    CALL ui.Interface.refresh()
#    CLEAR FORM                                 # 清螢墓欄位內容
#   #FUN-770057 begin
#    #INITIALIZE g_ims.* TO NULL
#    CALL g_ims.clear()
#    LET g_ims01 = null
#    LET g_ims10 = null
#    LET g_ims11 = null
#   #FUN-770057 end
#    INITIALIZE g_imn.* TO NULL
#
#    #---->迴路一
#    WHILE TRUE
#        IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
#        LET s_no=0
#        LET g_yn=1
#        LET g_ims.ims10 = g_pp.cdate
#        LET g_ims.ims11 = g_pass
#        LET g_no=0
#
#        CALL p700_i()                           # 各欄位輸入
#
#        IF INT_FLAG THEN                        # 若按了DEL鍵
#           LET INT_FLAG = 0
#           EXIT WHILE
#        END IF
#        LET g_ims01_t=''
#
#        #---->迴路二
#        WHILE TRUE
#           BEGIN WORK
#           IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
#           LET g_no=g_no+1
#           CALL s_showmsg()    #No.FUN-710025
#           CALL p700_cur()
#           CALL p700_i2()                      # 各欄位輸入
#           IF INT_FLAG THEN                         # 若按了DEL鍵
#               LET INT_FLAG = 0
#               CALL p700_c2()
#               CALL p700_free()
#               EXIT WHILE
#           END IF
#           IF NOT cl_sure(14,19) THEN
#               CONTINUE WHILE
#           END IF
#           IF g_yn = 1 AND g_sma.sma88 ='N'
#           #No.FUN-550029 --start--
#           THEN CALL s_auto_assign_no("aim",g_ims.ims01,g_ims.ims10,"9","ims_file","ims01",
#                  "","","")
#                  RETURNING li_result,g_ims.ims01
#              IF (NOT li_result) THEN
#                  CONTINUE WHILE
#              END IF
#              DISPLAY BY NAME g_ims.ims01
#           END IF
#
##          THEN IF g_smy.smyauno='Y' AND cl_null(g_ims.ims01[5,10])
##               THEN CALL s_smyauno(g_ims.ims01,g_ims.ims10)
##				 RETURNING g_i,g_ims.ims01
##                    IF g_i THEN CONTINUE WHILE END IF
##        DISPLAY BY NAME g_ims.ims01 
##               END IF
##          END IF
#           #No.FUN-550029 --end--  
#           LET g_success = 'Y'
#           IF p700_t() THEN
#               LET g_success='N'
#           ELSE LET g_yn=g_yn+1
#		   END IF
#              IF g_success = 'Y'
#                 THEN CALL cl_cmmsg(4)  COMMIT WORK
#                 ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
#              END IF
#           CALL p700_c2()
#           LET g_ims02_t = ' '
#        END WHILE
#        CALL p700_c2()
#    END WHILE
#END FUNCTION
#FUN-770057 end
 
#FUN-770057 remark begin
#FUNCTION p700_c2()
#    LET g_ims.ims04 = ' '    LET g_imn.imn03 = ' '
#    LET g_imn.imn29 = ' '    #No.FUN-5C0077
#    LET g_imn.imn04 = ' '    LET g_imn.imn05 = ' '
#    LET g_imn.imn06 = ' '    LET g_imn.imn10 = ' '
#    LET g_imn.imn11 = ' '    LET g_imn.imn091 = ' '
#    LET g_imn.imn09 = ' '    LET g_imn.imn092 = ' '
#    LET g_imn.imn07 = ' '    LET g_imn.imn151 = ' '
#    LET g_imm.imm14 = ' '   #FUN-670093
#    LET g_imn.imn9301 = ' '   #FUN-670093
#    LET g_imn.imn9302 = ' '   #FUN-670093
#    
#    CLEAR ims02,ims04,imn03,imn29,imn04,imn05,imn06,imn10,imn11,    #No.FUN-5C0077
#          imn091,imn09, imn092,imn07,imn151,imm14,imn9301,imn9302 #FUN-670093
#    CLEAR ima05,ima08,desc,img10,ima02,imn09_2
#    #No.FUN-570249  --begin
#    LET g_imn.imn30 = ' '    LET g_imn.imn33 = ' '
#    LET g_imn.imn32 = ' '    LET g_imn.imn35 = ' '
#    CLEAR imn33,imn30,imn35,imn32
#    CLEAR imgg10_1,imgg10_2,imn33_2,imn30_2
#    #No.FUN-570249  --end  
#END FUNCTION
#FUN-770057 remark end
 
#--------------------------------------------------------------------
FUNCTION p700_i()
 DEFINE  l_n        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_cmd      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
         b_date     LIKE type_file.dat,     #No.FUN-690026 DATE
         e_date     LIKE type_file.dat,     #No.FUN-690026 DATE
         l_gen02    LIKE gen_file.gen02
 DEFINE  li_result  LIKE type_file.num5     #No.FUN-550029 #No.FUN-690026 SMALLINT
 
      CALL s_azn01(g_sma.sma51,g_sma.sma52) RETURNING b_date,e_date
      #INPUT BY NAME g_ims.ims01,g_imm.imm01, g_ims.ims10, g_ims.ims11 #FUN-770057 remark
      INPUT  g_ims01,g_imm.imm01, g_ims10, g_ims11              #FUN-770057 
               WITHOUT DEFAULTS 
            FROM ims01,imm01,ims10,ims11
 
       #No.TQC-740249 --start--  取消原來的mark
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         EXIT INPUT
       #No.TQC-740249 --end--
 
        #No.FUN-550029  --start                                                 
        BEFORE INPUT                                                            
            CALL cl_set_docno_format("ims01")                                   
            CALL cl_set_docno_format("imm01")                                   
        #NO.Fun-550029  --end
 
 
        BEFORE FIELD ims01   #撥出單號
            SELECT gen02 INTO l_gen02
                          FROM gen_file
                           #WHERE gen01=g_ims.ims11  #FUN-770057
                           WHERE gen01=g_ims11       #FUN-770057 
            DISPLAY l_gen02 TO FORMONLY.gen02_2 
            IF g_sma.sma88 ='Y' THEN 
              NEXT FIELD imm01
            END IF
 
        AFTER FIELD ims01   #撥出單號
 #No.MOD-540182 --start--
#           LET g_ims.ims01[4,4]='-'
#           DISPLAY BY NAME g_ims.ims01 
#           IF g_ims.ims01 = '   -' OR g_ims.ims01 IS NULL THEN
#               LET g_ims.ims01=''
#	NEXT FIELD ims01
#           END IF
            #IF g_ims.ims01 IS NOT NULL THEN
            IF g_ims01 IS NOT NULL THEN
	      #IF g_ims01_t IS NULL OR g_ims.ims01 != g_ims01_t THEN   #FUN-770057
	      IF g_ims01_t IS NULL OR g_ims01 != g_ims01_t THEN        #FUN-770057
                #FUN-770057 begin
                #CALL s_check_no("aim",g_ims.ims01,g_ims01_t,"9","ims_file","ims01","")
                #       RETURNING li_result,g_ims.ims01
                #DISPLAY BY NAME g_ims.ims01
                CALL s_check_no("aim",g_ims01,g_ims01_t,"9","ims_file","ims01","")   
                       RETURNING li_result,g_ims01
                DISPLAY g_ims01 TO ims01
                #FUN-770057 end
                IF (NOT li_result) THEN
                       NEXT FIELD ims01
                END IF
              END IF
            END IF
 
#               	LET g_t1=g_ims.ims01[1,3]
#				CALL s_mfgslip(g_t1,'aim','9')	#檢查單別
#               	IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#                   	CALL cl_err(g_t1,g_errno,0)
#					LET g_ims.ims01=g_ims01_t
#                   	NEXT FIELD ims01
#               	END IF
#              	END IF
#               IF g_ims.ims01[1,3] IS NOT NULL AND  #並且單號空白時,
#                  cl_null(g_ims.ims01[5,10]) THEN	    #請使用者自行輸入
#                  IF g_smy.smyauno='N' THEN        #新增並要不自動編號
#                     NEXT FIELD ims01
#                  ELSE			                    #要不, 則單號不用輸入
#                     NEXT FIELD imm01	
#                  END IF
#               END IF
#          END IF
#           IF g_ims.ims01 != g_ims01_t OR g_ims01_t IS NULL THEN
#               IF NOT cl_chk_data_continue( g_ims.ims01[5,10]) THEN
#                  CALL cl_err('','9056',0)
#                  NEXT FIELD ims01
#               END IF
#               SELECT count(*) INTO l_n FROM ims_file
#                   WHERE ims01 = g_ims.ims01
#               IF l_n > 0 THEN   #單據編號重複
#                   CALL cl_err(g_ims.ims01,-239,0)
#                   LET g_ims.ims01 = g_ims01_t
#                   DISPLAY BY NAME g_ims.ims01 
#                   NEXT FIELD ims01
#               END IF
#            END IF
 
       AFTER FIELD imm01   #調撥單號
            #====>mandy 01/08/02 增加控管輸入的調撥單號不可為無效單
            SELECT * FROM imm_file
                WHERE imm01 = g_imm.imm01
                  AND immacti = 'Y'
            IF STATUS THEN 
#              CALL cl_err(g_imm.imm01,'9028',0) #此筆資料已無效, 不可使用#No.FUN-660156
               CALL cl_err3("sel","imm_file",g_imm.imm01,"","9028","","",0)  #No.FUN-660156
               NEXT FIELD imm01 
            END IF
 
            IF g_imm.imm01 IS NULL OR g_imm.imm01 = ' '
            THEN NEXT FIELD imm01
            ELSE CALL p700_imm01()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err(g_imm.imm01,g_errno,0)
                    LET g_imm.imm01 = g_imm_o.imm01
                    DISPLAY BY NAME g_imm.imm01
                    NEXT FIELD imm01
                 END IF
                 IF g_sma.sma88 = 'Y' THEN 
                   #FUN-770057 begin 
                    #LET g_ims.ims01 = g_imm.imm01 
                    #DISPLAY BY NAME g_ims.ims01
                    LET g_ims01 = g_imm.imm01 
                    DISPLAY  g_ims01  TO ims01
                   #FUN-770057 end 
                 END IF
            END IF
            LET g_imm_o.imm01 = g_imm.imm01
###94/12/05 Add By Jackson
        AFTER FIELD ims10
           #FUN-770057 begin
            #IF cl_null(g_ims.ims10) THEN NEXT FIELD ims10 END IF
            #IF cl_null(g_ims.ims10) THEN NEXT FIELD ims10 END IF
            #IF g_sma.sma53 IS NOT NULL AND g_ims.ims10 <= g_sma.sma53 
            #   THEN CALL cl_err('','mfg9999',0) NEXT FIELD ims10
            #END IF
            #IF g_ims.ims10 > e_date THEN NEXT FIELD ims10 END IF
            IF cl_null(g_ims10) THEN NEXT FIELD ims10 END IF
            
            
            IF g_sma.sma53 IS NOT NULL AND g_ims10 <= g_sma.sma53 
               THEN CALL cl_err('','mfg9999',0) NEXT FIELD ims10
            END IF
            IF g_ims10 > e_date THEN NEXT FIELD ims10 END IF
           #FUN-770057 end
 
            
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ims01) #單別
                  #LET g_t1=s_get_doc_no(g_ims.ims01)  #No.FUN-550029 #FUN-770057
                  LET g_t1=s_get_doc_no(g_ims01)                      #FUN-770057
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','9') RETURNING g_t1 #TQC-670016
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
                  #LET g_ims.ims01 =g_t1     #No.FUN-550029   #FUN-770057
                  LET g_ims01 =g_t1                           #FUN-770057
                  #DISPLAY BY NAME g_ims.ims01                #FUN-770057
                  DISPLAY g_ims01 TO ims01                     #FUN-770057
                  NEXT FIELD ims01
               WHEN INFIELD(imm01) #調撥單號
#                 CALL q_imm1(8,31,g_imm.imm01,'4',g_plant) RETURNING g_imm.imm01
#                 CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
                  CALL cl_init_qry_var()
                  IF NOT cl_null(g_plant) THEN
                     LET g_qryparam.form = "q_imm101"
                     LET g_qryparam.default1 = g_imm.imm01
                     LET g_qryparam.arg1 = "4"
                     LET g_qryparam.arg2 = g_plant
                  ELSE
                     LET g_qryparam.form = "q_imm102"
                     LET g_qryparam.default1 = g_imm.imm01
                     LET g_qryparam.arg1 = "4"
                  END IF
                  CALL cl_create_qry() RETURNING g_imm.imm01
#                  CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
                  DISPLAY BY NAME g_imm.imm01 
                  NEXT FIELD imm01
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION mntn_doc_pty
              #WHEN INFIELD(ims01) #建立單據性質
				 LET l_cmd="asmi300 'aim' " 
				 CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
#FUN-770057 remark begin
##FUNCTION p700_i2()
##   DEFINE l_cnt,l_n  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
##          l_diff     LIKE imn_file.imn10
##   DEFINE b_imn      RECORD LIKE imn_file.*  #No.FUN-610090
##
##   #No.FUN-570249  --begin
##   INPUT BY NAME g_ims.ims04,g_ims.ims02,g_ims.ims06,g_ims.ims15,g_ims.ims14
##       WITHOUT DEFAULTS 
##   #No.FUN-570249  --end
##
##      ###950228 Mod By Jackson
##      BEFORE FIELD ims02
##        IF g_ims.ims02 IS NULL OR g_ims.ims02 = 0 
##           OR g_ims02_t IS NULL OR g_ims02_t = ' ' THEN
##          #SELECT max(ims02)+1 
##          #  INTO g_ims.ims02
##          #  FROM ims_file
##          # WHERE ims01 = g_ims.ims01
##          #IF g_ims.ims02 IS NULL THEN
##          #   LET g_ims.ims02 = 1 
##          #END IF
##           LET g_ims.ims02=g_ims.ims04
##           DISPLAY BY NAME g_ims.ims02
##        END IF
##
##      AFTER FIELD ims02  
##         IF g_ims.ims02 IS NULL OR g_ims.ims02 <=0 THEN
##            NEXT FIELD ims02
##         END IF
##         IF g_ims.ims02 IS NOT NULL THEN  
##            SELECT COUNT(*) INTO l_n
##              FROM ims_file
##             WHERE ims01 = g_ims.ims01
##               AND ims02 = g_ims.ims02
##            IF l_n > 0 THEN
##               CALL cl_err('',-239,0)
##               DISPLAY BY NAME g_ims.ims02
##               NEXT FIELD ims02
##            END IF
##         END IF
##
##      ###950228 Add By Jackson
##      BEFORE FIELD ims04
##         OPEN imn_cs USING g_imm.imm01
##         FETCH ABSOLUTE g_no imn_cs INTO g_ims.ims04
##         CALL p700_set_entry_b()  #No.FUN-570249
##
##      AFTER FIELD ims04          
##         IF g_ims.ims04 IS NULL OR g_ims.ims04 = ' ' OR g_ims.ims04 = 0 THEN
##            LET g_ims.ims04 = g_ims_t.ims04 
##            DISPLAY BY NAME g_ims.ims04
##            NEXT FIELD ims04
##         END IF
##         #檢查撥出單身是否重複
##         IF g_ims.ims04 != g_ims_t.ims04 OR g_ims_t.ims04 IS NULL THEN
##            SELECT COUNT(*) INTO l_n
##              FROM ims_file
##             WHERE ims01 = g_ims.ims01     #撥出單號
##               AND ims02 = g_ims.ims02     #撥出批次
##               AND ims03 = g_imm.imm01     #調撥單號
##               AND ims04 = g_ims.ims04     #調撥項次
##            IF l_n > 0 THEN
##               CALL cl_err('',-239,0)
##               LET g_ims.ims04 = g_ims_t.ims04
##               NEXT FIELD ims04
##            END IF
##         END IF
##         CALL p700_ims04()
##         IF NOT cl_null(g_chr) THEN
##            CALL cl_err(g_ims.ims04,g_errno,0)
##            #-----No.FUN-610090-----
##            IF g_errno="mfg3471" THEN
##               DECLARE p700_s1_c2 CURSOR FOR SELECT * FROM imn_file
##                 WHERE imn01 = g_imm.imm01
##                   AND imn02 = g_ims.ims04
##            
##               LET g_imm01 = ""
##               LET g_success = "Y"
##              #BEGIN WORK
##               CALL s_showmsg_init()    #No.FUN-710025 
##               FOREACH p700_s1_c2 INTO b_imn.*
##                  IF STATUS THEN
##                     EXIT FOREACH
##                  END IF
##            
##          #No.FUN-710025--Begin--                                                                                                      
##           IF g_success='N' THEN                                                                                                        
##            LET g_totsuccess='N'                                                                                                      
##            LET g_success="Y"                                                                                                         
##           END IF                                                                                                                       
##          #No.FUN-710025--End-
##
##                  IF g_sma.sma115 = 'Y' THEN
##                     IF g_ima906 = '2' THEN  #子母單位
##                        LET g_unit_arr[1].unit= b_imn.imn30
##                        LET g_unit_arr[1].fac = b_imn.imn31
##                        LET g_unit_arr[1].qty = b_imn.imn32
##                        LET g_unit_arr[2].unit= b_imn.imn33
##                        LET g_unit_arr[2].fac = b_imn.imn34
##                        LET g_unit_arr[2].qty = b_imn.imn35
##                        CALL s_dismantle(g_imm.imm01,b_imn.imn02,g_imm.imm12,
##                                         b_imn.imn03,b_imn.imn04,b_imn.imn05,
##                                         b_imn.imn06,g_unit_arr,g_imm01)
##                               RETURNING g_imm01
##                     END IF
##                  END IF
##               END FOREACH
##          #No.FUN-710025--Begin--                                                                                                             
##          IF g_totsuccess="N" THEN                                                                                                         
##              LET g_success="N"                                                                                                             
##          END IF                                                                                                                           
##          #No.FUN-710025--End--
##
##            
##               IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
##           #      COMMIT WORK
##                  LET g_msg="aimt324 '",g_imm01,"'"
##                  CALL cl_cmdrun_wait(g_msg)
##               ELSE
##           #      ROLLBACK WORK
##               END IF
##            END IF
##            #-----No.FUN-610090 END-----
##            NEXT FIELD ims04
##         END IF 
##         CALL p700_set_no_entry_b()  #No.FUN-570249
##
##      BEFORE FIELD ims06
##         LET l_diff = g_imn.imn10 - g_imn.imn11
##         LET g_ims.ims06 = l_diff 
##         DISPLAY BY NAME g_ims.ims06 
##
##      AFTER FIELD ims06
##         CALL p700_ims06()
##         IF g_status ='N' THEN NEXT FIELD ims06 END IF
##
##      #No.FUN-570249  --begin
##      AFTER FIELD ims14
##         CALL p700_ims14()
##         CALL p700_set_origin_field()
##         #---->檢查是否已超撥(不允許)
##         IF (g_imn.imn11 + g_ims.ims06) > g_imn.imn10 THEN 
##         #No.FUN-710025--Begin--
##         #  CALL cl_err('','mfg3470',0) 
##            CALL s_errmsg('','','','mfg3470',0) 
##         #No.FUN-710025--End--
##            LET g_status ='N' 
##         END IF
##         IF g_status ='N' THEN NEXT FIELD ims14 END IF
##
##      AFTER FIELD ims15
##         CALL p700_ims15()
##         CALL p700_set_origin_field()
##         #---->檢查是否已超撥(不允許)
##         IF (g_imn.imn11 + g_ims.ims06) > g_imn.imn10 THEN 
##         #No.FUN-710025--710025--
##         #  CALL cl_err('','mfg3470',0) 
##            CALL s_errmsg('','','','mfg3470',0) 
##         #No.FUN-710025--End--
##            LET g_status ='N' 
##         END IF
##         IF g_status ='N' THEN NEXT FIELD ims15 END IF
##     
##      #No.FUN-570249  --end  
##
##      ON ACTION CONTROLP
##         CASE
##            WHEN INFIELD(ims04) #調撥項次
###              CALL q_imn1(0,0,g_imm.imm01) 
###              RETURNING g_imm.imm01,g_ims.ims04,g_imn.imn03,
###                        g_imn.imn04,g_imn.imn05,g_imn.imn06,
###                        g_imn.imn09
###              CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
###              CALL FGL_DIALOG_SETBUFFER( g_ims.ims04 )
###              CALL FGL_DIALOG_SETBUFFER( g_imn.imn03 )
###              CALL FGL_DIALOG_SETBUFFER( # g_imn.imn04 )
###              CALL FGL_DIALOG_SETBUFFER( g_imn.imn05 )
###              CALL FGL_DIALOG_SETBUFFER( g_imn.imn06 )
###              CALL FGL_DIALOG_SETBUFFER( # g_imn.imn09 )
##               CALL cl_init_qry_var()
##               LET g_qryparam.form = "q_imn1"
##               LET g_qryparam.default1 = g_imm.imm01
##               IF NOT cl_null(g_imm.imm01) THEN
##                  LET g_qryparam.construct = "N"
##                  LET g_qryparam.where = " imn01 = '",g_imm.imm01,"'"
##               END IF
##               CALL cl_create_qry() RETURNING g_imm.imm01,g_ims.ims04,
##                                              g_imn.imn03
###               CALL FGL_DIALOG_SETBUFFER( g_imm.imm01 )
###               CALL FGL_DIALOG_SETBUFFER( g_ims.ims04 )
###               CALL FGL_DIALOG_SETBUFFER( g_imn.imn03 )
##               SELECT imn04,imn05,imn06,imn09 
##                 INTO g_imn.imn04,g_imn.imn05,g_imn.imn06,g_imn.imn09
##                 FROM imn_file
##                WHERE imn27 IN ('N','n') AND imn01 = g_imm.imm01
##                  AND imn02 = g_ims.ims04 AND imn03 = g_imn.imn03
##               DISPLAY BY NAME g_ims.ims04 
##               DISPLAY BY NAME g_imm.imm01,g_imn.imn03,g_imn.imn04,
##                               g_imn.imn05,g_imn.imn06,g_imn.imn09
##                               
##               NEXT FIELD ims04
##            OTHERWISE EXIT CASE
##         END CASE
##
##      ON ACTION CONTROLR
##         CALL cl_show_req_fields()
##
##      ON ACTION CONTROLG
##         CALL cl_cmdask()
##
##      AFTER INPUT 
##         IF INT_FLAG THEN EXIT INPUT END IF
##         #No.FUN-570249  --begin
##         IF g_sma.sma115='Y' THEN
##            IF cl_null(g_ims.ims14) AND cl_null(g_ims.ims15) OR
##               g_ims.ims14 <0 OR g_ims.ims15<0 OR
##              (g_ims.ims14=0 AND g_ims.ims15=0) THEN
##              NEXT FIELD ims14
##            END IF
##            CALL p700_set_origin_field()
##            #---->檢查是否已超撥(不允許)
##            IF (g_imn.imn11 + g_ims.ims06) > g_imn.imn10 THEN 
##            #No.FUN-710025--Begin--
##            #  CALL cl_err('','mfg3470',0) 
##               CALL s_errmsg('','','','mfg3470',0)
##            #No.FUN-710025--End--
##               LET g_status ='N' 
##            END IF
##         END IF
##         #No.FUN-570249  --end  
##         IF g_ims.ims06 IS NULL OR g_ims.ims06 = ' ' OR g_ims.ims06 <= 0 THEN
##            NEXT FIELD ims06
##         END IF
##
##      ON IDLE g_idle_seconds
##         CALL cl_on_idle()
##         CONTINUE INPUT
## 
##      ON ACTION about         #MOD-4C0121
##         CALL cl_about()      #MOD-4C0121
## 
##      ON ACTION help          #MOD-4C0121
##         CALL cl_show_help()  #MOD-4C0121
## 
##   END INPUT
##
##END FUNCTION
#FUN-770057 end
 
#調撥單號
FUNCTION p700_imm01()
    DEFINE l_immacti LIKE imm_file.immacti
 
    LET g_errno = ' '
    SELECT imm02,imm03,imm05,imm06,imm07,imm08,imm09,immacti,imm14 #FUN-670093
      INTO g_imm.imm02,g_imm.imm03,g_imm.imm05,g_imm.imm06,
           g_imm.imm07,g_imm.imm08,g_imm.imm09,l_immacti,g_imm.imm14
      FROM imm_file
     WHERE imm01 = g_imm.imm01
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3384'
                       LET g_imm.imm02 = NULL LET g_imm.imm03 = NULL 
                       LET g_imm.imm07 = NULL LET g_imm.imm08 = NULL 
                       LET g_imm.imm09 = NULL
         WHEN g_imm.imm05 != g_imm.imm06 AND g_imm.imm03 = 'Y' 
              LET g_errno = 'mfg3459'
    #====>mandy 01/08/02 增加控管輸入的調撥單號不可為無效單
         WHEN l_immacti != 'Y' 
              LET g_errno = '9028' #此筆資料已無效, 不可使用
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY BY NAME g_imm.imm02,g_imm.imm07,g_imm.imm08,g_imm.imm09,g_imm.imm14 #FUN-670093
       CALL p700_imm09('d')
       DISPLAY s_costcenter_desc(g_imm.imm14) TO FORMONLY.gem02 #FUN-670093
    END IF
END FUNCTION
   
FUNCTION p700_imm09(p_cmd)  #申請人員
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02 LIKE gen_file.gen02,
           l_gen03 LIKE gen_file.gen03,
           l_gem02 LIKE gem_file.gem02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti
           INTO l_gen02,l_gen03,l_genacti
           FROM gen_file WHERE gen01 = g_imm.imm09
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	SELECT gem02 INTO l_gem02
		FROM gem_file WHERE gem01=l_gen03
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02 
       #DISPLAY l_gen03 TO FORMONLY.gen03  #FUN-670093
       #DISPLAY l_gem02 TO FORMONLY.gem02  #FUN-670093
    END IF
END FUNCTION
   
FUNCTION p700_peo()  #確認人員
    DEFINE l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           #FROM gen_file WHERE gen01 = g_ims.ims11 #FUN-770057
           FROM gen_file WHERE gen01 = g_ims11      #FUN-770057
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_gen02 TO FORMONLY.gen02_2 
    END IF
END FUNCTION
   
FUNCTION p700_ims04()  #調撥項次
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima05   LIKE ima_file.ima05,
          l_ima08   LIKE ima_file.ima08,
#         l_ima262  LIKE ima_file.ima262,           #FUN-A20044
          l_avl_stk LIKE type_file.num15_3,         #FUN-A20044   
          l_unavl_stk LIKE type_file.num15_3,       #FUN-A20044
          l_avl_stk_mpsmrp LIKE type_file.num15_3,  #FUN-A20044
          l_desc    LIKE ze_file.ze03    #No.FUN-690026 VARCHAR(26)
 
   LET g_chr = ' '
 
   #---->讀取調撥單單身檔(LOCK 此筆資料)
   #OPEN imn_lock USING g_imm.imm01,g_ims.ims04         #FUN-770057
   OPEN imn_lock USING g_imm.imm01,g_ims[l_ac].ims04    #FUN-770057
   #TQC-930155 add
   IF SQLCA.sqlcode THEN
      #---->已被別的使用者鎖住
      #TQC-930155 begin
      #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
      IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
      #TQC-930155 end
         LET g_errno = 'mfg3463'
         LET g_chr='L'
      ELSE
         LET g_errno = 'mfg3464'
         LET g_chr='E'
      END IF
 
      RETURN
   END IF
   #TQC-930155 end
   FETCH imn_lock INTO g_imn.*
   IF SQLCA.sqlcode THEN
      #---->已被別的使用者鎖住
      #TQC-930155 begin
      #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
      IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
      #TQC-930155 end
         LET g_errno = 'mfg3463'
         LET g_chr='L'
      ELSE
         LET g_errno = 'mfg3464'
         LET g_chr='E'
      END IF
 
      RETURN
   END IF
  #FUN-770057
   IF g_imn.imn27 = 'Y' THEN
      CALL cl_err('','axm-202',0)
      LET g_chr = 'E'
   END IF
  #FUN-770057
   #---->多倉時讀取調撥單單身檔(LOCK 此筆資料)
   IF g_sma.sma12 = 'Y' THEN
      IF g_imn.imn04 IS NULL THEN LET g_imn.imn04 = ' ' END IF
      IF g_imn.imn05 IS NULL THEN LET g_imn.imn05 = ' ' END IF
      IF g_imn.imn06 IS NULL THEN LET g_imn.imn06 = ' ' END IF
 
      OPEN img_lock USING g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06
      #TQC-930155 begin 
      #IF STATUS THEN
      #   CALL cl_err('OPEN img_lock',STATUS,1) 
      #   RETURN
      #END IF
      IF SQLCA.sqlcode THEN
         #---->已被別的使用者鎖住
         #TQC-930155 begin
         #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
         IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
         #TQC-930155 end
            LET g_errno = 'mfg3465'
            LET g_chr='L'
         ELSE
            LET g_errno = 'mfg3466'
            LET g_chr='E'
         END IF
         RETURN
      END IF
      #TQC-930155 end
 
      FETCH img_lock INTO g_img10,g_img21_fac,
                          g_img23,g_img24,g_img26
      IF SQLCA.sqlcode THEN
         #---->已被別的使用者鎖住
         #TQC-930155 begin
         #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
         IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
         #TQC-930155 end
            LET g_errno = 'mfg3465'
            LET g_chr='L'
         ELSE
            LET g_errno = 'mfg3466'
            LET g_chr='E'
         END IF
         RETURN
      END IF
  
     #MOD-CA0009---mark---S      
     ### No:2537 modify 1998/10/15 --------------------------------
     #SELECT COUNT(*) INTO g_count_1 FROM img_file   #CHI-A90045 g_cnt - > g_count_1
     # WHERE img01 = g_imn.imn03   #料號
     #   AND img02 = g_imn.imn04   #倉庫
     #   AND img03 = g_imn.imn05   #儲位
     #   AND img04 = g_imn.imn06   #批號
     #   AND img18 < g_imm.imm02   #調撥日期
     #IF g_count_1 > 0 THEN    #大於有效日期   #CHI-A90045 g_cnt->g_count_1
     #   LET g_errno = 'aim-400'   #須修改
     #   LET g_chr = 'E'
     #   RETURN
     #END IF
     #MOD-CA0009---mark---E
 
      #---->檢查是否有庫存量
      LET g_invqty = g_img10 
     #IF g_invqty <= 0 AND g_sma.sma894[4,4]='N' THEN   #FUN-C80107 mark
      LET l_flag01 = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn.imn04) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imn.imn04,g_plant) RETURNING l_flag01                   #FUN-D30024--add  #TQC-D40078 g_plant
      IF g_invqty <= 0 AND l_flag01 = 'N' THEN   #FUN-C80107 add
         LET g_errno = 'mfg3471'
         LET g_chr='E'
         RETURN
      END IF
 
      CALL s_wardesc(g_img23,g_img24) RETURNING l_desc
      DISPLAY l_desc TO FORMONLY.desc
 
      #No.FUN-570249  --begin
      IF g_sma.sma115='Y' THEN
         LET g_imgg10_1=0
         LET g_imgg10_2=0
         SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_imn.imn03
         IF NOT cl_null(g_imn.imn30) THEN
            IF g_ima906='2' THEN
               OPEN imgg_lock1 USING g_imn.imn03,g_imn.imn04,
                                     g_imn.imn05,g_imn.imn06,g_imn.imn30
               IF STATUS THEN
                  CALL cl_err('OPEN imgg_lock',STATUS,1) 
                  RETURN
               END IF
               FETCH imgg_lock1 INTO g_imgg10_1
               IF SQLCA.sqlcode THEN
                  #---->已被別的使用者鎖住
                  #TQC-930155 begin
                  #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
                  IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
                  #TQC-930155 end
                      LET g_errno = 'mfg3465'
                      LET g_chr='L'
                  ELSE
                      LET g_errno = 'mfg3466'
                      LET g_chr='E'
                  END IF
                  RETURN
               END IF
            ELSE
               LET g_imgg10_1 = g_invqty 
            END IF
         END IF
 
         IF NOT cl_null(g_imn.imn33) THEN
            OPEN imgg_lock1 USING g_imn.imn03,g_imn.imn04,
                                 g_imn.imn05,g_imn.imn06,g_imn.imn33
            IF STATUS THEN
               CALL cl_err('OPEN imgg_lock1',STATUS,1) 
               RETURN
            END IF
            FETCH imgg_lock1 INTO g_imgg10_2
            IF SQLCA.sqlcode THEN
               #---->已被別的使用者鎖住
               #TQC-930155 begin
               #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
               IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
               #TQC-930155 end
                   LET g_errno = 'mfg3465'
                   LET g_chr='L'
               ELSE
                   LET g_errno = 'mfg3466'
                   LET g_chr='E'
               END IF
               RETURN
            END IF
         END IF
      END IF
      #No.FUN-570249  --end
   END IF
 
   #---->讀取料件主檔(LOCK 此筆資料)
   OPEN ima_lock USING g_imn.imn03
   #TQC-630155 begin
   #IF STATUS THEN
   #   CALL cl_err('OPEN ima_lock',STATUS,1) 
   #   RETURN
   #END IF
   IF SQLCA.sqlcode THEN
      #---->已被別的使用者鎖住
      #TQC-930155 begin
      #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
      IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
      #TQC-930155 end
         LET g_errno = 'mfg3467'
         LET g_chr='L'
      ELSE
         LET g_errno = 'mfg3468'
         LET g_chr='E'
      END IF
      RETURN
   END IF
   #TQC-630155 end
 
   FETCH ima_lock INTO l_ima02,l_ima05, 
#                      l_ima08,l_ima262  # g_ima86  #FUN-560183   #FUN-A20044
                       l_ima08,l_avl_stk #FUN-A20044
   IF SQLCA.sqlcode THEN
      #---->已被別的使用者鎖住
      #TQC-930155 begin
      #IF SQLCA.sqlcode=-246 OR STATUS =-250 THEN 
      IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN 
      #TQC-930155 end
         LET g_errno = 'mfg3467'
         LET g_chr='L'
      ELSE
         LET g_errno = 'mfg3468'
         LET g_chr='E'
      END IF
      RETURN
   END IF
   CALL s_getstock(g_imn.imn03,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
   IF g_sma.sma12 = 'N' THEN 
#     LET g_invqty = l_ima262                                                      #FUN-A20044
      LET g_invqty = l_avl_stk                                                     #FUN-A20044
   END IF
 
  #FUN-770057 begin
   #DISPLAY BY NAME g_imn.imn03,g_imn.imn29,g_imn.imn04,g_imn.imn05,   #No.FUN-5C0077
   #                g_imn.imn06,g_imn.imn10,g_imn.imn11,
   #                g_imn.imn091,g_imn.imn09,g_imn.imn092,
   #                g_imn.imn07,g_imn.imn151,g_imn.imn33, #No.FUN-570249
   #                g_imn.imn30,g_imn.imn35,g_imn.imn32,  #No.FUN-570249
   #                g_imn.imn9301,g_imn.imn9302 #FUN-670093
   #DISPLAY g_invqty TO FORMONLY.img10       
   #DISPLAY l_ima02 TO FORMONLY.ima02        
   #DISPLAY l_ima05 TO FORMONLY.ima05        
   #DISPLAY l_ima08 TO FORMONLY.ima08        
   #DISPLAY g_imn.imn09 TO FORMONLY.imn09_2  
   #DISPLAY g_imn.imn30 TO FORMONLY.imn30_2  #No.FUN-570249
   #DISPLAY g_imn.imn33 TO FORMONLY.imn33_2  #No.FUN-570249
   #DISPLAY g_imgg10_1 TO FORMONLY.imgg10_1  #No.FUN-570249
   #DISPLAY g_imgg10_2 TO FORMONLY.imgg10_2  #No.FUN-570249
   #DISPLAY s_costcenter_desc(g_imn.imn9301) TO FORMONLY.gem02b #FUN-670093
   #DISPLAY s_costcenter_desc(g_imn.imn9302) TO FORMONLY.gem02c #FUN-670093
   LET  g_ims[l_ac].imn03  =g_imn.imn03  
   LET  g_ims[l_ac].imn29  =g_imn.imn29  
   LET  g_ims[l_ac].imn04  =g_imn.imn04 
   LET  g_ims[l_ac].imn05  =g_imn.imn05   
   LET  g_ims[l_ac].imn06  =g_imn.imn06  
   LET  g_ims[l_ac].imn10  =g_imn.imn10  
   LET  g_ims[l_ac].imn11  =g_imn.imn11
   LET  g_ims[l_ac].imn091 =g_imn.imn091 
   LET  g_ims[l_ac].imn09  =g_imn.imn09  
   LET  g_ims[l_ac].imn092 =g_imn.imn092
   LET  g_ims[l_ac].imn07  =g_imn.imn07  
   LET  g_ims[l_ac].imn33  =g_imn.imn33 
   LET  g_ims[l_ac].imn30  =g_imn.imn30  
   LET  g_ims[l_ac].imn35  =g_imn.imn35 
   LET  g_ims[l_ac].imn32  =g_imn.imn32  
   LET  g_ims[l_ac].imn9301=g_imn.imn9301
   LET  g_ims[l_ac].imn9302=g_imn.imn9302 
   LET  g_ims[l_ac].img10  =g_invqty       
   LET  g_ims[l_ac].ima02  =l_ima02         
   LET  g_ims[l_ac].ima05  =l_ima05         
   LET  g_ims[l_ac].ima08  =l_ima08         
   LET  g_ims[l_ac].imn09_2=g_imn.imn09    
   LET  g_ims[l_ac].imn30_2=g_imn.imn30    
   LET  g_ims[l_ac].imn33_2=g_imn.imn33    
   LET  g_ims[l_ac].imgg10_1 =g_imgg10_1  
   LET  g_ims[l_ac].imgg10_2 =g_imgg10_2  
   LET  g_ims[l_ac].gem02b =s_costcenter_desc(g_imn.imn9301) 
   LET  g_ims[l_ac].gem02c =s_costcenter_desc(g_imn.imn9302) 
  #FUN-770057 end
                   
   CALL p700_plantnam(g_imn.imn151)
 
END FUNCTION
 
FUNCTION p700_plantnam(p_plant)
   DEFINE p_plant   LIKE imn_file.imn151,
          l_azp03   LIKE azp_file.azp03,
          l_azp02   LIKE azp_file.azp02
 
   LET g_errno = ' '
       SELECT azp02,azp03 INTO l_azp02,l_azp03
         FROM azp_file
        WHERE azp01 = p_plant
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg9142'
         LET l_azp02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      DISPLAY l_azp02 TO imn151  
      LET g_dbs_new = l_azp03,'.'
      LET g_plant_new = p_plant #FUN-980092 GP5.2 Modify
      CALL s_gettrandbs()       #FUN-980092 GP5.2 Modify #改抓Transaction DB
   END IF
 
END FUNCTION
 
FUNCTION p700_ims06() 
   DEFINE l_msg   LIKE ze_file.ze03  #No.FUN-690026 VARCHAR(70) 
 
   LET g_status = 'Y'
#---->檢查庫存是否足夠
    #IF g_invqty < g_ims.ims06 AND g_sma.sma894[4,4]='N' THEN         #FUN-770057
   #IF g_invqty < g_ims[l_ac].ims06 AND g_sma.sma894[4,4]='N' THEN    #FUN-770057  #FUN-C80107 mark
    LET l_flag01 = NULL    #FUN-C80107 add
    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_ims[l_ac].imn04) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024--mark
    CALL s_inv_shrt_by_warehouse(g_ims[l_ac].imn04,g_plant) RETURNING l_flag01                   #FUN-D30024--add #TQC-D40078 g_plant
    IF g_invqty < g_ims[l_ac].ims06 AND l_flag01 = 'N' THEN #FUN-C80107 add
       CALL cl_getmsg('mfg3469',g_lang) RETURNING l_msg
       IF NOT cl_prompt(16,9,l_msg) THEN 
          LET g_status ='N' RETURN 
       END IF
       IF g_status ='Y' THEN 
          #LET g_ims.ims06 = g_invqty         #FUN-770057
          #DISPLAY BY NAME g_ims.ims06         #FUN-770057
          LET g_ims[l_ac].ims06 = g_invqty    #FUN-770057
          DISPLAY BY NAME g_ims[l_ac].ims06   #FUN-770057
       END IF
    END IF 
#---->檢查是否已超撥(不允許)
    #IF (g_imn.imn11 + g_ims.ims06) > g_imn.imn10 THEN                   #FUN-770057
    IF (g_ims[l_ac].imn11 + g_ims[l_ac].ims06) > g_ims[l_ac].imn10 THEN  #FUN-770057
       CALL cl_err('','mfg3470',0) 
       LET g_status ='N' 
    END IF
{
    IF (g_imn.imn11 + g_ims.ims06) > g_imn.imn10 THEN 
       CALL cl_getmsg('mfg3470',g_lang) RETURNING l_msg
       IF NOT cl_prompt(16,9,l_msg) THEN 
          LET g_status ='N' RETURN 
       END IF
    END IF
}
END FUNCTION
 
#--------------------------------------------------------------------
#FUN-FUN-770057 begin
FUNCTION p700_t2()
  DEFINE l_sql LIKE type_file.chr1000                                                          #No.FUN-690026 VARCHAR(4000)
  DEFINE l_imn10 LIKE imn_file.imn10                                              
  DEFINE l_imn29 LIKE imn_file.imn29                                              
  DEFINE l_imn03 LIKE imn_file.imn03                                              
  DEFINE l_qcs01 LIKE qcs_file.qcs01                                              
  DEFINE l_qcs02 LIKE qcs_file.qcs02                                              
  DEFINE #l_sql1    LIKE type_file.chr1000,
         l_sql1      STRING,     #NO.FUN-910082 
         l_zero   LIKE ims_file.ims06,
         l_qty    LIKE ima_file.ima100,
         l_exe2   LIKE type_file.chr1     
 
  DEFINE l_legal LIKE type_file.chr10 #No.FUN-980004 
  DEFINE l_plant LIKE type_file.chr10 #No.FUN-980004 
  DEFINE l_imn09 LIKE imn_file.imn09  #FUN-BB0084 
  DEFINE l_imn11 LIKE imn_file.imn11  #FUN-BB0084
  DEFINE l_ims06      LIKE ims_file.ims06  #FUN-BB0084
  DEFINE l_ims06_1    LIKE ims_file.ims06  #FUN-BB0084
 
   LET l_plant = g_imn151  #FUN-980004 add
   LET g_plant_new = g_imn151  #CHI-D10014
   IF g_ims[l_ac].ims06 IS NULL  THEN 
      LET g_success='N' 
      CALL cl_err('(p700_t:ckp#0.1)','mfg9170',1)
      RETURN 1
   END IF
   LET l_sql1="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",     
              " WHERE imn01= '",g_imm.imm01,"'"                                  
   PREPARE t324_curs1 FROM l_sql1                                                
   DECLARE t324_pre1 CURSOR FOR t324_curs1                                      
   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02               
    IF l_imn29='Y' THEN                                                         
      LET l_qcs091=0
      SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file                            
       WHERE qcs01=l_qcs01                                                      
         AND qcs02=l_qcs02                                                      
         AND qcs14='Y'                                                          
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF                           
      IF l_qcs091 < l_imn10 THEN                                                
         CALL cl_err(l_imn03,'aim1003',1)                                            
         RETURN                                                                 
      END IF                                                                    
    END IF                                                                      
   END FOREACH                    
#---->{ckp#2}產生一筆撥出單單身檔
      #No.FUN-570249  --begin
      IF cl_null(g_ims[l_ac].ims02) THEN LET g_ims[l_ac].ims02 = 0 END IF  #TQC-790001
      INSERT INTO ims_file(ims01,ims03,ims02,ims04,
                           ims05,ims06,ims07,ims08,
                           ims09,ims10,ims11,ims14,ims15,imsplant,imslegal) #No.FUN-980004  add imsplant,imslegal
                    VALUES(g_ims01,           #撥出單號
                           g_imm.imm01,       #調撥單號
                           g_ims[l_ac].ims02, #撥出項次 
                           g_ims[l_ac].ims04,       #調撥項次 
                           g_ims[l_ac].imn03,       #料件編號 
                           g_ims[l_ac].ims06,       #實撥數量 
                           0,                 #撥入確認碼
                           g_imn041,      #撥出工廠
                           g_imn151,      #撥入工廠
                           g_ims10,       #確認日期
                           g_ims11,       #確認人員
                           g_ims[l_ac].ims14,       #單位一數量
                           g_ims[l_ac].ims15,g_plant,g_legal)  #單位二數量 #No.FUN-980004 add g_plant,g_legal
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","ims_file",g_ims01,g_imm.imm01,STATUS,"",
                      "(p700_t:ckp#2)",1)  #No.FUN-660156
         LET g_success ='N'
         RETURN 1
      END IF
         #---->產生至撥入廠
#         LET l_sql = "INSERT INTO ",g_dbs_new CLIPPED,
         #LET l_sql = "INSERT INTO ",g_dbs_tra CLIPPED,  #FUN-980092 GP5.2 Modify  #FUN-A50102
          LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'ims_file'),  #FUN-A50102
                     #"ims_file(ims01,ims03,ims02,ims04,",    #FUN-A50102
                      "(ims01,ims03,ims02,ims04,",            #FUN-A50102
                      "ims05,ims06,ims07,ims08,ims09,ims10,ims11,ims14,ims15,imsplant,imslegal)", #FUN-980004 add imsplant,imslegal
                      " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?)" #FUN-980004 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
         CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980004 add
          PREPARE ims_cur FROM l_sql
          IF SQLCA.sqlcode THEN
             CALL cl_err('ims_cur',SQLCA.sqlcode,0)
          END IF
          LET l_zero = 0
          EXECUTE ims_cur USING g_ims01,       #撥出單號
                                g_imm.imm01,       #調撥單號
                                g_ims[l_ac].ims02,       #撥出批次 
                                g_ims[l_ac].ims04,       #調撥項次 
                                g_ims[l_ac].imn03,       #料件編號 
                                g_ims[l_ac].ims06,       #實撥數量 
                                l_zero,
                                g_imn041,      #撥出工廠
                                g_imn151,      #撥入工廠
                                g_ims10,       #確認日期
                                g_ims11,       #確認人員
                                g_ims[l_ac].ims14,       #單位一數量
                                g_ims[l_ac].ims15,       #單位二數量
                                l_plant,    #FUN-980004 add
                                l_legal     #FUN-980004 add
            IF SQLCA.sqlcode THEN 
               CALL cl_err('(p700_t:ckp#2.2)','mfg3461',1)
               LET g_success ='N'
               RETURN 1
            END IF
 
#---->{ckp#3}更新調撥單單身檔
#FUN-BB0084 --------------Begin------------------
     SELECT imn09 INTO l_imn09 FROM imn_file
      WHERE imn01 = g_imm.imm01
        AND imn02 = g_ims[l_ac].ims04
     LET l_ims06_1 = g_ims[l_ac].ims06 
     LET l_ims06_1 = s_digqty(l_ims06_1,l_imn09)    
#FUN-BB0084 --------------End--------------------
#     UPDATE imn_file SET imn11 = imn11 + g_ims[l_ac].ims06,   #實撥出量    #FUN-BB0084
      UPDATE imn_file SET imn11 = imn11 + l_ims06_1,                        #FUN-BB0084        
                          imn12 ='Y',                    #確認碼
                          imn13 =g_ims11,            #確認人
                          imn14 =g_ims10             #確認日期
                    WHERE imn01 = g_imm.imm01
                      AND imn02 = g_ims[l_ac].ims04
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","imn_file","","","mfg3462","",
                      "(p700_t:ckp#3)",1)  #No.FUN-660156
         LET g_success ='N'
         RETURN 1
      END IF
 
      #---->{ckp#3.2}更新[撥入廠]調撥單單身檔
#FUN-BB0084 ----------------Begin------------------
            LET l_sql = "SELECT imn09,imn11 FROM ",cl_get_target_table(g_plant_new,'imn_file'),
                        " WHERE imn01='",g_imm.imm01,"' ", 
                        "   AND imn02= ",g_ims[l_ac].ims04 CLIPPED
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
            PREPARE imn_cur_imn09 FROM l_sql
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL cl_err('imn_cur_imn09',SQLCA.sqlcode,0)
               RETURN 1
            END IF    
            LET l_imn09 = NULL
            EXECUTE imn_cur_imn09 INTO l_imn09,l_imn11 
          # IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN       #TQC-C60073
            IF SQLCA.sqlcode THEN                               #TQC-C60073
               LET g_success = 'N'
               CALL cl_err('imn_cur_imn09',SQLCA.sqlcode,0)
               RETURN 1
            END IF 
            IF cl_null(l_imn11) THEN LET l_imn11 = 0 END IF
            LET l_ims06 = g_ims[l_ac].ims06
            LET l_ims06 = s_digqty(l_ims06,l_imn09)  
            LET l_imn11 = l_imn11 + l_ims06
#FUN-BB0084 ----------------End--------------------
#           LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"imn_file", 
           #LET l_sql = "UPDATE ",g_dbs_tra CLIPPED,"imn_file", #FUN-980092 GP5.2 Modify  #FUN-A50102
            LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'imn_file'),   #FUN-A50102
            #           " SET imn11= imn11 + ? , imn12= ?, imn13= ?, ",          #FUN-BB0084 mark 
                        " SET imn11= ? , imn12= ?, imn13= ?, ",                  #FUN-BB0084 add
                        "     imn14= ? ",
                        " WHERE imn01='",g_imm.imm01,"' ", 
                        "   AND imn02= ",g_ims[l_ac].ims04 CLIPPED
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
            PREPARE imn_cur FROM l_sql
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL cl_err('imn_cur',SQLCA.sqlcode,0)
               RETURN 1
            END IF
            LET l_exe2 = 'Y'
 
          # EXECUTE imn_cur USING g_ims[l_ac].ims06,l_exe2,  #FUN-BB0084 mark
            EXECUTE imn_cur USING l_imn11,l_exe2,            #FUN-BB0084 add
                                  g_ims11,g_ims10 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
               LET g_success = 'N'
               CALL cl_err('imn_cur:ckp#3.2',SQLCA.sqlcode,0)
               RETURN 1
             END IF
 
      #FUN-550011................begin
      IF NOT s_stkminus(g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,
                       #g_ims[l_ac].imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN #FUN-D30024--mark
                        g_ims[l_ac].imn10,1,g_imm.imm02) THEN                   #FUN-D30024--add
         LET g_success='N'
         #RETURN   #TQC-BA0007
         RETURN 1  #TQC-BA0007
      END IF
      #CHI-D10014---begin
      LET l_sql = "INSERT INTO rvbs_file ",
                  " (rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                  "  rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal) ",
               " SELECT rvbs00,rvbs01,rvbs02, ", 
               "        rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
               "        rvbs021,rvbs022,1,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal ",
               "   FROM rvbs_file ",
               "  WHERE rvbs00 = 'aimp700' ",
               "    AND rvbs01 = ? ",
               "    AND rvbs02 = ? "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
         PREPARE rvbs_p2 FROM l_sql
         EXECUTE rvbs_p2 USING g_ims01,g_ims[l_ac].ims02
         IF STATUS THEN
            CALL cl_err('',STATUS,0)
         END IF
      #CHI-D10014---end   
#---->更新倉庫庫存明細資料[單倉與多倉已在(s_upimg.4gl 處理掉)]
#                    1          2  3                4
     #CALL s_upimg(' ',-1,g_ims[l_ac].ims06,g_imm.imm02, #No.FUN-8C0084
     #CALL s_upimg(g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,-1,g_ims[l_ac].ims06,g_imm.imm02, #FUN-8C0084            #MOD-AC0329 mark
      CALL s_upimg(g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,-1,g_ims[l_ac].ims06,g_imm.imm02, #MOD-AC0329 add
#         5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
          #g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,'','','','','','','','','','','','','','')  #MOD-D30212
          #g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,'','','','','','','','','','','','','','')  #MOD-D30212  #CHI-D10014
          g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,g_ims01,g_ims[l_ac].ims02,'','','','','','','','','','','','')  #CHI-D10014
      IF g_success = 'N' THEN RETURN 1 END IF
 
#---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
 
#---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
      IF s_udima(g_ims[l_ac].imn03,              #料件編號
	      		     g_img23,                  #是否可用倉儲
  		    	     g_img24,                  #是否為MRP可用倉儲
  			         g_ims[l_ac].ims06*g_img21_fac,  #調撥數量(換算為庫存單位)
			           g_imm.imm02,              #最近一次調撥日期
			           -1)                       #表調撥出
    	THEN RETURN 1 
      END IF
 
      IF g_sma.sma115='Y' THEN
         CALL p700_update_du()
      END IF
      IF g_success='N' THEN RETURN 1 END IF
      
#CHI-A90045 --begin--
      LET g_count = 0 
      #MOD-D30212---begin
      #SELECT COUNT(*),img10 INTO g_count,g_img10_wip FROM img_file
      # WHERE img01 = g_imn.imn03
      #   AND img02 = g_imm.imm08
      #   AND img03 = g_imn.imn05
      #   AND img04 = g_imn.imn06
      # GROUP BY img10  
      SELECT COUNT(*),img10 INTO g_count,g_img10_wip FROM img_file
       WHERE img01 = g_ims[l_ac].imn03
         AND img02 = g_imm.imm08
         AND img03 = g_ims[l_ac].imn05
         AND img04 = g_ims[l_ac].imn06
       GROUP BY img10 
      #MOD-D30212---end
      IF g_count = 0 THEN 
         #CALL s_add_img(g_imn.imn03,g_imm.imm08,g_imn.imn05,g_imn.imn06,'','',g_imm.imm02) #MOD-D30212   
         CALL s_add_img(g_ims[l_ac].imn03,g_imm.imm08,g_ims[l_ac].imn05,g_ims[l_ac].imn06,'','',g_imm.imm02) #MOD-D30212   
         IF g_errno = 'N' THEN 
            RETURN 1
         END IF 
      END IF 
      #CALL s_upimg(g_imn.imn03,g_imm.imm08,g_imn.imn05,g_imn.imn06,+1,  #MOD-D30212
      #             g_ims[l_ac].ims06,g_imm.imm02,g_imn.imn03,  #MOD-D30212
      #             g_imm.imm08,g_imn.imn05,g_imn.imn06,'','',  #MOD-D30212
      CALL s_upimg(g_ims[l_ac].imn03,g_imm.imm08,g_ims[l_ac].imn05,g_ims[l_ac].imn06,+1,  #MOD-D30212
                   g_ims[l_ac].ims06,g_imm.imm02,g_ims[l_ac].imn03,  #MOD-D30212
                   #g_imm.imm08,g_ims[l_ac].imn05,g_ims[l_ac].imn06,'','',  #MOD-D30212  #CHI-D10014
                   g_imm.imm08,g_ims[l_ac].imn05,g_ims[l_ac].imn06,g_ims01,g_ims[l_ac].ims02, #CHI-D10014
                   '','','','','','','','','','','','')
      IF g_success = 'N' THEN 
         RETURN 1 
      END IF                                                  
#CHI-A90045 --end--    
 
#---->產生異動記錄資料
    CALL p700_free()
    CALL p700_log2(1,0,'',g_ims[l_ac].imn03)
    
#CHI-A90045 --begin--
    CALL p700_log2_wip(1,0,g_ims[l_ac].imn03)
#CHI-A90045 --end--
    
    IF g_success = 'N' THEN RETURN 1 END IF
    
	RETURN 0
END FUNCTION
 
###更新相關的檔案
##FUNCTION p700_t()
###No.FUN-5C0077--start                                                           
##DEFINE l_sql LIKE type_file.chr1000                                                          #No.FUN-690026 VARCHAR(4000)
##DEFINE l_imn10 LIKE imn_file.imn10                                              
##DEFINE l_imn29 LIKE imn_file.imn29                                              
##DEFINE l_imn03 LIKE imn_file.imn03                                              
##DEFINE l_qcs01 LIKE qcs_file.qcs01                                              
##DEFINE l_qcs02 LIKE qcs_file.qcs02                                              
###No.FUN-5C0077--end   
##DEFINE l_sql1    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(600)
##       l_zero   LIKE ims_file.ims06,
##       l_qty    LIKE ima_file.ima100,
##       l_exe2   LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
##
##    IF g_ims.ims06 IS NULL  THEN 
##       LET g_success='N' 
##       CALL cl_err('(p700_t:ckp#0.1)','mfg9170',1)
##       RETURN 1
##    END IF
###No.FUN-5C0077--start
##   LET l_sql1="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",     
##             " WHERE imn01= '",g_imm.imm01,"'"                                  
##   PREPARE t324_curs1 FROM l_sql1                                                
##   DECLARE t324_pre1 CURSOR FOR t324_curs1                                      
##   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02               
##    IF l_imn29='Y' THEN                                                         
##      LET l_qcs091=0
##      SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file                            
##       WHERE qcs01=l_qcs01                                                      
##         AND qcs02=l_qcs02                                                      
##         AND qcs14='Y'                                                          
##      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF                           
##      IF l_qcs091 < l_imn10 THEN                                                
##         CALL cl_err(l_imn03,'aim1003',1)                                            
##         RETURN                                                                 
##      END IF                                                                    
##    END IF                                                                      
##   END FOREACH                    
##{
##   IF g_imn.imn29='Y' THEN                                                
##      SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file                                 
##       WHERE qcs01=g_imm.imn01                                                  
##         AND qcs02=g_imn.imn02                                            
##      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF                           
##      IF l_qcs091 < g_imn.imn10 THEN                                      
##         CALL cl_err('','aim1003',1)                                            
##         RETURN                                                                 
##      END IF                                                                    
##   END IF                                
##}
###No.FUN-5C0077--end
###---->{ckp#2}產生一筆撥出單單身檔
##      #No.FUN-570249  --begin
##      INSERT INTO ims_file(ims01,ims03,ims02,ims04,
##                           ims05,ims06,ims07,ims08,
##                           ims09,ims10,ims11,ims14,ims15)
##                    VALUES(g_ims.ims01,       #撥出單號
##                           g_imm.imm01,       #調撥單號
##                           g_ims.ims02,       #撥出批次 
##                           g_ims.ims04,       #調撥項次 
##                           g_imn.imn03,       #料件編號 
##                           g_ims.ims06,       #實撥數量 
##                           0,                 #撥入確認碼
##                           g_imn.imn041,      #撥出工廠
##                           g_imn.imn151,      #撥入工廠
##                           g_ims.ims10,       #確認日期
##                           g_ims.ims11,       #確認人員
##                           g_ims.ims14,       #單位一數量
##                           g_ims.ims15)       #單位二數量
##      #No.FUN-570249  --end  
##      IF SQLCA.sqlcode THEN 
##        #CALL cl_err('(p700_t:ckp#2)','mfg3461',1)
###        CALL cl_err('(p700_t:ckp#2)',STATUS,1)  #No.FUN-660156
##         CALL cl_err3("ins","ims_file",g_ims.ims01,g_imm.imm01,STATUS,"",
##                      "(p700_t:ckp#2)",1)  #No.FUN-660156
##         LET g_success ='N'
##         RETURN 1
##      END IF
##         #---->產生至撥入廠
##          #No.FUN-570249  --begin
##          LET l_sql = "INSERT INTO ",g_dbs_new CLIPPED,
##                      "ims_file(ims01,ims03,ims02,ims04,",
##                      "ims05,ims06,ims07,ims08,ims09,ims10,ims11,ims14,ims15)",
##                      " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
##          PREPARE ims_cur FROM l_sql
##          IF SQLCA.sqlcode THEN
##             CALL cl_err('ims_cur',SQLCA.sqlcode,0)
##          END IF
##          LET l_zero = 0
##          EXECUTE ims_cur USING g_ims.ims01,       #撥出單號
##                                g_imm.imm01,       #調撥單號
##                                g_ims.ims02,       #撥出批次 
##                                g_ims.ims04,       #調撥項次 
##                                g_imn.imn03,       #料件編號 
##                                g_ims.ims06,       #實撥數量 
##                                l_zero,
##                                g_imn.imn041,      #撥出工廠
##                                g_imn.imn151,      #撥入工廠
##                                g_ims.ims10,       #確認日期
##                                g_ims.ims11,       #確認人員
##                                g_ims.ims14,       #單位一數量
##                                g_ims.ims15        #單位二數量
##            #No.FUN-570249  --end
##            IF SQLCA.sqlcode THEN 
##               CALL cl_err('(p700_t:ckp#2.2)','mfg3461',1)
##               LET g_success ='N'
##               RETURN 1
##            END IF
##
###---->{ckp#3}更新調撥單單身檔
##      UPDATE imn_file SET imn11 = imn11 + g_ims.ims06,   #實撥出量
##                          imn12 ='Y',                    #確認碼
##                          imn13 =g_ims.ims11,            #確認人
##                          imn14 =g_ims.ims10             #確認日期
##                    WHERE imn01=g_imn.imn01 AND imn02=g_imn.imn02
##
##      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
###        CALL cl_err('(p700_t:ckp#3)','mfg3462',1)#No.FUN-660156
##         CALL cl_err3("upd","imn_file","","","mfg3462","",
##                      "(p700_t:ckp#3)",1)  #No.FUN-660156
##         LET g_success ='N'
##         RETURN 1
##      END IF
##
##      #---->{ckp#3.2}更新[撥入廠]調撥單單身檔
##            LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"imn_file",
##                        " SET imn11= imn11 + ? , imn12= ?, imn13= ?, ",
##                        "     imn14= ? ",
##                        " WHERE imn01='",g_imm.imm01,"' AND ", #FUN-650172 AND 前少一個空白
##                        "       imn02= ",g_ims.ims04 CLIPPED
##            PREPARE imn_cur FROM l_sql
##            IF SQLCA.sqlcode THEN
##               LET g_success = 'N'
##               CALL cl_err('imn_cur',SQLCA.sqlcode,0)
##               RETURN 1
##            END IF
##            LET l_exe2 = 'Y'
##
##            EXECUTE imn_cur USING g_ims.ims06,l_exe2,
##                                  g_ims.ims11,g_ims.ims10 
##            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
##               LET g_success = 'N'
##               CALL cl_err('imn_cur:ckp#3.2',SQLCA.sqlcode,0)
##               RETURN 1
##             END IF
##
##      #FUN-550011................begin
##      IF NOT s_stkminus(g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,
##                        g_imn.imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN
##         LET g_success='N'
##         RETURN
##      END IF
##      #FUN-550011................end
##
###---->更新倉庫庫存明細資料[單倉與多倉已在(s_upimg.4gl 處理掉)]
###                1           2  3           4
##      CALL s_upimg(' ',-1,g_ims.ims06,g_imm.imm02,
###         5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22
##          g_imn.imn03,g_imn.imn04,g_imn.imn05,g_imn.imn06,'','','','','','','','','','','','','','')
##      IF g_success = 'N' THEN RETURN 1 END IF
##
###---->若庫存異動後其庫存量小於等於零時將該筆資料刪除
## 
###---->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
##      IF s_udima(g_imn.imn03,              #料件編號
##	   		     g_img23,                  #是否可用倉儲
##  		  	     g_img24,                  #是否為MRP可用倉儲
##  			     g_ims.ims06*g_img21_fac,  #調撥數量(換算為庫存單位)
##			     g_imm.imm02,              #最近一次調撥日期
##			     -1)                       #表調撥出
##    	THEN RETURN 1 
##      END IF
##
##      #No.FUN-570249  --begin
##      IF g_sma.sma115='Y' THEN
##         CALL p700_update_du()
##      END IF
##      IF g_success='N' THEN RETURN 1 END IF
##      #No.FUN-570249  --end   
##
##      #---->{ckp#4} 更新撥入廠的在途量
#### No:2537 modify 1998/10/15 --------------------------------
##{
##       LET l_qty = g_ims.ims06 * g_img21_fac
##      #LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
##      #            " SET ima100 = ima100 + ? ",
##      #            " WHERE ima01='",g_imn.imn03,"'"
##      # PREPARE ima_cur FROM l_sql
##      # IF SQLCA.sqlcode THEN
##      #    CALL cl_err('ckp#4:ima_cur',SQLCA.sqlcode,0)
##      #    LET g_success = 'N'
##      #    RETURN 1
##      # END IF
##
##      # EXECUTE ima_cur USING l_qty
##      # IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
##      #    LET g_success = 'N'
##      #    CALL cl_err('ima_cur:ckp#4','mfg3486',0)
##      #    RETURN 1
##      # END IF
##}
##
###---->產生異動記錄資料
##    CALL p700_free()
##    CALL p700_log(1,0,'',g_imn.imn03)
##    IF g_success = 'N' THEN RETURN 1 END IF
##    
##	RETURN 0
##END FUNCTION
#FUN-770057 end
 
#---->將已鎖住之資料釋放出來
FUNCTION p700_free()
{*} IF g_sma.sma12='N' THEN
        CLOSE img_lock
    END IF
    CLOSE imn_lock 
    CLOSE ima_lock 
END FUNCTION
 
#--------------------------------------------------------------------
#處理異動記錄
#FUN-770057 begin
FUNCTION p700_log2(p_stdc,p_reason,p_code,p_item)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,    #採購單性質
    p_stdc          LIKE type_file.num5,    #是否需取得標準成本 #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,    #是否需取得異動原因 #No.FUN-690026 SMALLINT
    p_code          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(04)
    p_item          LIKE tlf_file.tlf01     #NO.MOD-490217 
 
#----來源----
    LET g_tlf.tlf01=p_item      	 #異動料件編號
    LET g_tlf.tlf02=50         	 	 #資料來源為倉庫
    LET g_tlf.tlf020=g_imn041    #工廠別
    LET g_tlf.tlf021=g_ims[l_ac].imn04   	 #倉庫別
    LET g_tlf.tlf022=g_ims[l_ac].imn05	 #儲位別
    LET g_tlf.tlf023=g_ims[l_ac].imn06	 #批號
    LET g_tlf.tlf024=g_img10-g_ims[l_ac].ims06 #異動後庫存數量
	LET g_tlf.tlf025=g_ims[l_ac].imn09     #庫存單位(ima_file or img_file)
	LET g_tlf.tlf026=g_ims01     #撥出單號
	LET g_tlf.tlf027=g_ims[l_ac].ims02     #撥出項次
#----目的----
    LET g_tlf.tlf03=57         	     #資料目的為多工廠調撥
    LET g_tlf.tlf030=g_imn151    #工廠別
    LET g_tlf.tlf031=' '          	 #倉庫別
    LET g_tlf.tlf032=' '          	 #儲位別
    LET g_tlf.tlf033=' '          	 #入庫批號
    LET g_tlf.tlf034=' '          	 #異動後庫存數量
    LET g_tlf.tlf035=' '          	 #庫存單位(ima_file or img_file)
	LET g_tlf.tlf036=g_imm.imm01     #調撥單號 
	LET g_tlf.tlf037=g_ims[l_ac].ims04     #調撥項次
#--->異動數量
    LET g_tlf.tlf04=' '              #工作站
    LET g_tlf.tlf05=' '              #作業序號
    LET g_tlf.tlf06=g_imm.imm02      #調撥日期
	LET g_tlf.tlf07=g_today          #異動資料產生日期  
	LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user           #產生人
	LET g_tlf.tlf10=g_ims[l_ac].ims06      #調撥數量
	LET g_tlf.tlf11=g_ims[l_ac].imn09      #調撥單位
	LET g_tlf.tlf12=1                #庫存/庫存轉換率
	LET g_tlf.tlf13='aimp700'        #異動命令代號
	LET g_tlf.tlf14=''               #異動原因
	LET g_tlf.tlf15=' '              #借方會計科目
    LET g_tlf.tlf16=g_ims[l_ac].imn07      #貸方會計科目
	LET g_tlf.tlf17=' '              #非庫存性料件編號
    CALL s_imaQOH(g_ims[l_ac].imn03)
         RETURNING g_tlf.tlf18       #異動後總庫存量
	LET g_tlf.tlf19= ''              #異動廠商/客戶編號
	LET g_tlf.tlf20= g_imn.imn08     #專案號碼  
	LET g_tlf.tlf930= g_ims[l_ac].imn9301  #FUN-670093
   #LET g_tlf.tlf61= g_ima86         #成本單位
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION

#CHI-A90045 --begin--
FUNCTION p700_log2_wip(p_stdc,p_reason,p_item)
DEFINE p_stdc          LIKE type_file.num5,    #是否需取得標準成本 
       p_reason        LIKE type_file.num5,    #是否需取得異動原因      
       p_item          LIKE tlf_file.tlf01     

 
#----來源----
  LET g_tlf.tlf01=p_item                  	 #異動料件編號
  LET g_tlf.tlf02=57         	            	 #資料來源為倉庫 
  LET g_tlf.tlf020=g_imn041                  #工廠別
  LET g_tlf.tlf021=g_imm.imm08         	     #倉庫別
  LET g_tlf.tlf022=g_ims[l_ac].imn05	       #儲位別
  LET g_tlf.tlf023=g_ims[l_ac].imn06	       #批號
  LET g_tlf.tlf024=g_img10_wip + g_ims[l_ac].ims06 #異動後庫存數量	
	LET g_tlf.tlf025=g_ims[l_ac].imn09         #庫存單位(ima_file or img_file)
	LET g_tlf.tlf026=g_ims01                   #撥出單號
	LET g_tlf.tlf027=g_ims[l_ac].ims02         #撥出項次
#----目的----
  LET g_tlf.tlf03=50         	               #資料目的為多工廠調撥 
  LET g_tlf.tlf030=g_imn151                  #工廠別   
  LET g_tlf.tlf031=g_imm.imm08               #倉庫別
  LET g_tlf.tlf032=g_ims[l_ac].imn05         #儲位別
  LET g_tlf.tlf033=g_ims[l_ac].imn06         #入庫批號
  LET g_tlf.tlf034=' '                    	 #異動後庫存數量
  LET g_tlf.tlf035=' '          	           #庫存單位(ima_file or img_file)
	LET g_tlf.tlf036=g_imm.imm01               #調撥單號 
	LET g_tlf.tlf037=g_ims[l_ac].ims02         #調撥項次
#--->異動數量
  LET g_tlf.tlf04=' '                        #工作站
  LET g_tlf.tlf05=' '                        #作業序號
  LET g_tlf.tlf06=g_imm.imm02                #調撥日期
	LET g_tlf.tlf07=g_today                    #異動資料產生日期  
	LET g_tlf.tlf08=TIME                       #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user                     #產生人
	LET g_tlf.tlf10=g_ims[l_ac].ims06          #調撥數量
	LET g_tlf.tlf11=g_ims[l_ac].imn09          #調撥單位
	LET g_tlf.tlf12=1                          #庫存/庫存轉換率
	LET g_tlf.tlf13='aimp700'                  #異動命令代號
	LET g_tlf.tlf14=''                         #異動原因
	LET g_tlf.tlf15=' '                        #借方會計科目
  LET g_tlf.tlf16=g_ims[l_ac].imn07          #貸方會計科目
	LET g_tlf.tlf17=' '                        #非庫存性料件編號
  CALL s_imaQOH(g_ims[l_ac].imn03)
       RETURNING g_tlf.tlf18                 #異動後總庫存量
	LET g_tlf.tlf19= ''                        #異動廠商/客戶編號
	LET g_tlf.tlf20= g_imn.imn08               #專案號碼  
	LET g_tlf.tlf930= g_ims[l_ac].imn9301  
  CALL s_tlf(p_stdc,p_reason)
END FUNCTION
#CHI-A90045 --end-

#FUNCTION p700_log(p_stdc,p_reason,p_code,p_item)
#DEFINE
#    l_pmn02         LIKE pmn_file.pmn02,    #採購單性質
#    p_stdc          LIKE type_file.num5,    #是否需取得標準成本 #No.FUN-690026 SMALLINT
#    p_reason        LIKE type_file.num5,    #是否需取得異動原因 #No.FUN-690026 SMALLINT
#    p_code          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(04)
#    p_item          LIKE tlf_file.tlf01     #NO.MOD-490217 
#
##----來源----
#    LET g_tlf.tlf01=p_item      	 #異動料件編號
#    LET g_tlf.tlf02=50         	 	 #資料來源為倉庫
#    LET g_tlf.tlf020=g_imn.imn041    #工廠別
#    LET g_tlf.tlf021=g_imn.imn04   	 #倉庫別
#    LET g_tlf.tlf022=g_imn.imn05	 #儲位別
#    LET g_tlf.tlf023=g_imn.imn06	 #批號
#    LET g_tlf.tlf024=g_img10-g_ims.ims06 #異動後庫存數量
#	LET g_tlf.tlf025=g_imn.imn09     #庫存單位(ima_file or img_file)
#	LET g_tlf.tlf026=g_ims.ims01     #撥出單號
#	LET g_tlf.tlf027=g_ims.ims02     #撥出項次
##----目的----
#    LET g_tlf.tlf03=57         	     #資料目的為多工廠調撥
#    LET g_tlf.tlf030=g_imn.imn151    #工廠別
#    LET g_tlf.tlf031=' '          	 #倉庫別
#    LET g_tlf.tlf032=' '          	 #儲位別
#    LET g_tlf.tlf033=' '          	 #入庫批號
#    LET g_tlf.tlf034=' '          	 #異動後庫存數量
#    LET g_tlf.tlf035=' '          	 #庫存單位(ima_file or img_file)
#	LET g_tlf.tlf036=g_imm.imm01     #調撥單號 
#	LET g_tlf.tlf037=g_ims.ims04     #調撥項次
##--->異動數量
#    LET g_tlf.tlf04=' '              #工作站
#    LET g_tlf.tlf05=' '              #作業序號
#    LET g_tlf.tlf06=g_imm.imm02      #調撥日期
#	LET g_tlf.tlf07=g_today          #異動資料產生日期  
#	LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
#	LET g_tlf.tlf09=g_user           #產生人
#	LET g_tlf.tlf10=g_ims.ims06      #調撥數量
#	LET g_tlf.tlf11=g_imn.imn09      #調撥單位
#	LET g_tlf.tlf12=1                #庫存/庫存轉換率
#	LET g_tlf.tlf13='aimp700'        #異動命令代號
#	LET g_tlf.tlf14=''               #異動原因
#	LET g_tlf.tlf15=' '              #借方會計科目
#    LET g_tlf.tlf16=g_imn.imn07      #貸方會計科目
#	LET g_tlf.tlf17=' '              #非庫存性料件編號
#    CALL s_imaQOH(g_imn.imn03)
#         RETURNING g_tlf.tlf18       #異動後總庫存量
#	LET g_tlf.tlf19= ''              #異動廠商/客戶編號
#	LET g_tlf.tlf20= g_imn.imn08     #專案號碼  
#	LET g_tlf.tlf930= g_imn.imn9301  #FUN-670093
#   #LET g_tlf.tlf61= g_ima86         #成本單位
#    CALL s_tlf(p_stdc,p_reason)
#END FUNCTION
#FUN-770057 end
 
#檢查密碼
FUNCTION p700_pass()
DEFINE
    l_azb02         LIKE azb_file.azb02,
    l_gen02         LIKE gen_file.gen02
 
    LET g_go='N'
 
    OPEN WINDOW cl_pass_w WITH FORM "aim/42f/aimp7001" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("aimp7001")
 
    LET g_pp.pass=NULL
    LET g_cnt=1
	LET g_pp.cdate = g_today
    WHILE TRUE
        INPUT g_pass,g_pp.cdate,g_pp.pass WITHOUT DEFAULTS
            FROM u,cdate,pass
 
            #No.TQC-740249 --start--
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #No.TQC-740249 --end--
 
            AFTER FIELD u
                IF g_pass IS NULL THEN NEXT FIELD u END IF
                SELECT azb02
                    INTO l_azb02
                    FROM azb_file
                    WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pass,'aoo-001',0) #No.FUN-660156
                   CALL cl_err3("sel","azb_file",g_pass,"","aoo-001","",
                                "",0)  #No.FUN-660156
                    NEXT FIELD u
                END IF
				SELECT gen02 INTO l_gen02 FROM gen_file       
							 WHERE gen01 = g_pass
                DISPLAY l_gen02 TO gen02 
            AFTER FIELD cdate 
                IF g_pp.cdate IS NULL OR g_pp.cdate = ' '
                THEN NEXT FIELD cdate 
                END IF
                IF l_azb02 IS NULL OR l_azb02=' ' THEN   #沒有設定密碼
                     LET g_go='Y'
                     EXIT INPUT
                END IF
            BEFORE FIELD pass
                CALL cl_getmsg('aoo-002',g_lang) RETURNING g_msg
               #DISPLAY g_msg AT 1,4   #CHI-A70049 mark 
                DISPLAY BY NAME g_pp.pass 

            #-----TQC-BA0007---------
            #AFTER FIELD pass
            #    IF g_pp.pass IS NULL THEN
            #        NEXT FIELD pass
            #    END IF
            #    IF g_pp.pass != l_azb02 THEN
            #        CALL cl_err(g_cnt,'aoo-003',0)
            #        LET g_cnt=g_cnt+1
            #        LET g_pp.pass=NULL
            #        IF g_cnt > 3 THEN
            #            SLEEP 2
            #            EXIT INPUT
            #        ELSE
            #            NEXT FIELD pass
            #        END IF
            #    ELSE
            #        LET g_go='Y'
            #    END IF
            #-----END TQC-BA0007-----

            #-----TQC-BA0007---------
            #沒有輸入確認日期與密碼欄位直接按確認,g_go就沒有給值,導致直接離開程式
            AFTER INPUT
               IF INT_FLAG THEN 
                  LET INT_FLAG=0
                  LET g_go = 'N'
                  EXIT INPUT
               END IF
               IF g_pp.pass != l_azb02 THEN
                   CALL cl_err(g_cnt,'aoo-003',0)
                   LET g_cnt=g_cnt+1
                   LET g_pp.pass=NULL
                   IF g_cnt > 3 THEN
                       SLEEP 2
                       LET g_go = 'N'
                   ELSE
                       NEXT FIELD pass
                   END IF
               ELSE
                   IF cl_null(l_azb02) THEN
                      LET g_go='Y'
                   ELSE
                      IF cl_null(g_pp.pass) THEN
                         CALL cl_err(g_cnt,'aoo-003',0)
                         LET g_cnt=g_cnt+1
                         IF g_cnt > 3 THEN
                            SLEEP 2 
                            LET g_go='N'
                         ELSE
                            NEXT FIELD pass
                         END IF
                      ELSE
                         LET g_go = 'Y'
                      END IF
                   END IF
               END IF
            #-----END TQC-BA0007-----
 
            #-----TQC-860018---------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
            
            ON ACTION controlg      
               CALL cl_cmdask()     
            #-----END TQC-860018----- 
            #CHI-D10014---begin
            ON ACTION controlp
               CASE WHEN INFIELD(u) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azb1"
                  CALL cl_create_qry() RETURNING g_pass
                  DISPLAY g_pass TO u
                 NEXT FIELD u
               END CASE 
            #CHI-D10014---end
        END INPUT
        IF INT_FLAG THEN
             LET INT_FLAG=0
             EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW cl_pass_w
END FUNCTION
 
#No.FUN-570249  --begin
FUNCTION p700_mu_ui()
    CALL cl_set_comp_visible("imn33,imn30,ims14,ims15,imn35,imn32,imn33_2,imn30_2",g_sma.sma115='Y')
    CALL cl_set_comp_visible("group05",g_sma.sma115='Y')
    CALL cl_set_comp_visible("ims06,imn09_2",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-365',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-366',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-369',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imgg10_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-370',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imgg10_1",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-367',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-368',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-371',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imgg10_2",g_msg CLIPPED)
       CALL cl_getmsg('asm-372',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imgg10_1",g_msg CLIPPED)
    END IF
    IF g_sma.sma115='N' THEN
       CALL cl_set_comp_att_text("imn33,imn30,ims14,ims15,imn35,imn32,imn33_2,imn30_2",' ')
    ELSE
       CALL cl_set_comp_att_text("ims06,imn09_2",' ')
    END IF
    CALL cl_set_comp_visible("imn9301,gem02b,imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093
    CALL cl_set_comp_visible("imgg10_1,imgg10_2",g_sma.sma115='Y')  #FUN-770057
END FUNCTION
 
FUNCTION p700_ims14() 
 DEFINE  l_msg     LIKE ze_file.ze03  #No.FUN-690026 VARCHAR(70) 
 
    LET g_status = 'Y'
#---->檢查庫存是否足夠
    #IF g_imgg10_1 < g_ims.ims14 THEN                  #FUN-770057
    IF g_ims[l_ac].imgg10_1 < g_ims[l_ac].ims14 THEN   #FUN-770057
       IF g_sma.sma117 = 'N' THEN
         #IF g_sma.sma894[4,4]='N' OR cl_null(g_sma.sma894[4,4]) THEN  #FUN-C80107 mark
          LET l_flag01 = NULL    #FUN-C80107 add
          #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_ims[l_ac].imn04) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024--mark
          CALL s_inv_shrt_by_warehouse(g_ims[l_ac].imn04,g_plant) RETURNING l_flag01                   #FUN-D30024--add #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
             CALL cl_getmsg('mfg3469',g_lang) RETURNING l_msg
             IF NOT cl_prompt(16,9,l_msg) THEN 
                LET g_status ='N' RETURN 
             END IF
          END IF
       END IF
       IF g_status ='Y' THEN 
          #LET g_ims.ims14 = g_imgg10_1                  #FUN-770057
          LET g_ims[l_ac].ims14 = g_ims[l_ac].imgg10_1   #FUN-770057
          #DISPLAY BY NAME g_ims.ims14                   #FUN-770057
          DISPLAY BY NAME g_ims[l_ac].ims14              #FUN-770057
       END IF
    END IF 
END FUNCTION
 
FUNCTION p700_ims15() 
 DEFINE  l_msg     LIKE ze_file.ze03  #No.FUN-690026 VARCHAR(70) 
 
    LET g_status = 'Y'
#---->檢查庫存是否足夠
    #IF g_imgg10_2 < g_ims.ims15 THEN                 #FUN-770057
    IF g_ims[l_ac].imgg10_2 < g_ims[l_ac].ims15 THEN  #FUN-770057
       IF g_sma.sma117 = 'N' THEN
         #IF g_sma.sma894[4,4]='N' OR cl_null(g_sma.sma894[4,4]) THEN   #FUN-C80107 mark
          LET l_flag01 = NULL    #FUN-C80107 add
          #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_ims[l_ac].imn04) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024--mark
          CALL s_inv_shrt_by_warehouse(g_ims[l_ac].imn04,g_plant) RETURNING l_flag01                   #FUN-D30024--add #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
             CALL cl_getmsg('mfg3469',g_lang) RETURNING l_msg
             IF NOT cl_prompt(16,9,l_msg) THEN 
                LET g_status ='N' RETURN 
             END IF
          END IF
       END IF
       IF g_status ='Y' THEN 
         #FUN-770057 begin
          #LET g_ims.ims15 = g_imgg10_2
          #DISPLAY BY NAME g_ims.ims15
          LET g_ims[l_ac].ims15 = g_ims[l_ac].imgg10_2
          DISPLAY BY NAME g_ims[l_ac].ims15
         #FUN-770057 end
       END IF
    END IF 
END FUNCTION
 
FUNCTION p700_update_du()
DEFINE l_ima25   LIKE ima_file.ima25
 
   SELECT * INTO g_imn.* FROM imn_file
    WHERE imn01 = g_imm.imm01
      AND imn02 = g_ims[l_ac].ims04
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    #WHERE ima01 = g_imn.imn03   #FUN-770057
    WHERE ima01 = g_ims[l_ac].imn03    #FUN-770057
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    #WHERE ima01=g_imn.imn03         #FUN-770057
    WHERE ima01=g_ims[l_ac].imn03    #FUN-770057
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
     #FUN-770057 begin
      #IF NOT cl_null(g_ims.ims15) AND g_ims.ims15<>0 THEN
         #CALL p700_upd_imgg('1',g_imn.imn03,g_imn.imn04,g_imn.imn05,
         #                g_imn.imn06,g_imn.imn33,g_imn.imn34,g_ims.ims15,'2')
#     IF NOT cl_null(g_ims[l_ac].ims15) AND g_ims[l_ac].ims15<>0 THEN                    #CHI-860005 Mark
      IF NOT cl_null(g_ims[l_ac].ims15) THEN                                             #CHI-860005 
         CALL p700_upd_imgg('1',g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,
                         g_ims[l_ac].imn06,g_ims[l_ac].imn33,g_imn.imn34,g_ims[l_ac].ims15,'2')
        #FUN-770057 end
         IF g_success='N' THEN RETURN END IF
        #FUN-770057 begin
         #CALL p700_tlff(g_imn.imn04,g_imn.imn05,g_imn.imn06,l_ima25,
         #               g_ims.ims15,0,g_imn.imn33,g_imn.imn34,'2')
         CALL p700_tlff2(g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,l_ima25,
                        g_ims[l_ac].ims15,0,g_ims[l_ac].imn33,g_imn.imn34,'2')
        #FUN-770057 end
         IF g_success='N' THEN RETURN END IF
      END IF
      #IF NOT cl_null(g_ims.ims14) AND g_ims.ims14<>0 THEN             #FUN-770057
#     IF NOT cl_null(g_ims[l_ac].ims14) AND g_ims[l_ac].ims14<>0 THEN  #FUN-770057   #CHI-860005 Mark
      IF NOT cl_null(g_ims[l_ac].ims14) THEN                                         #CHI-860005
        #FUN-770057 begin
         #CALL p700_upd_imgg('1',g_imn.imn03,g_imn.imn04,g_imn.imn05,
         #                   g_imn.imn06,g_imn.imn30,g_imn.imn31,g_ims.ims14,'1')
         CALL p700_upd_imgg('1',g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,
                            g_ims[l_ac].imn06,g_ims[l_ac].imn30,g_imn.imn31,g_ims[l_ac].ims14,'1')
        #FUN-770057 end
         IF g_success='N' THEN RETURN END IF
        #FUN-770057 begin
         #CALL p700_tlff(g_imn.imn04,g_imn.imn05,g_imn.imn06,l_ima25,
         #               g_ims.ims14,0,g_imn.imn30,g_imn.imn31,'1')
         CALL p700_tlff2(g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,l_ima25,
                        g_ims[l_ac].ims14,0,g_ims[l_ac].imn30,g_imn.imn31,'1')
        #FUN-770057 end
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      #IF NOT cl_null(g_ims.ims15) AND g_ims.ims15<>0 THEN              #FUN-770057
#     IF NOT cl_null(g_ims[l_ac].ims15) AND g_ims[l_ac].ims15<>0 THEN   #FUN-770057   #CHI-860005 Mark
      IF NOT cl_null(g_ims[l_ac].ims15) THEN                                          #CHI-860005
        #FUN-770057 begin
         #CALL p700_upd_imgg('2',g_imn.imn03,g_imn.imn04,g_imn.imn05,
         #                   g_imn.imn06,g_imn.imn33,g_imn.imn34,g_ims.ims15,'2')
         CALL p700_upd_imgg('2',g_ims[l_ac].imn03,g_ims[l_ac].imn04,g_ims[l_ac].imn05,
                            g_ims[l_ac].imn06,g_ims[l_ac].imn33,g_imn.imn34,g_ims[l_ac].ims15,'2')
        #FUN-770057 end
         IF g_success = 'N' THEN RETURN END IF
        #FUN-770057 begin
         #CALL p700_tlff(g_imn.imn04,g_imn.imn05,g_imn.imn06,l_ima25,
         #               g_ims.ims15,0,g_imn.imn33,g_imn.imn34,'2')
         CALL p700_tlff2(g_ims[l_ac].imn04,g_ims[l_ac].imn05,g_ims[l_ac].imn06,l_ima25,
                        g_ims[l_ac].ims15,0,g_ims[l_ac].imn33,g_imn.imn34,'2')
        #FUN-770057 end
         IF g_success='N' THEN RETURN END IF
      END IF
      #No.CHI-770019  --Begin
      #IF NOT cl_null(g_ims.ims14) AND g_ims.ims14<>0 THEN
      #   CALL p700_tlff(g_imn.imn04,g_imn.imn05,g_imn.imn06,l_ima25,
      #                  g_ims.ims14,0,g_imn.imn30,g_imn.imn31,'1')
      #   IF g_success='N' THEN RETURN END IF
      #END IF
      #No.CHI-770019  --End  
   END IF
 
END FUNCTION
 
FUNCTION p700_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
     # ROLLBACK WORK     #No.TQC-930155
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
     # ROLLBACK WORK     #No.TQC-930155
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
#      CALL cl_err('ima25 null',SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                    "ima25 null",0)  #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
   #CALL s_upimgg(' ',-1,p_imgg10,g_imm.imm02,  #FUN-8C0084
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,-1,p_imgg10,g_imm.imm02, #FUN-8C0084
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
#FUN-770057 begin
FUNCTION p700_tlff2(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   p_flag)
DEFINE
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   l_imgg10   LIKE imgg_file.imgg10,
   p_flag     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
   g_cnt      LIKE type_file.num5        #No.FUN-690026 SMALLINT
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=g_ims[l_ac].imn03 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
    LET g_tlff.tlff01=g_ims[l_ac].imn03         #異動料件編號
    LET g_tlff.tlff02=50       	 	  #資料來源為倉庫
    LET g_tlff.tlff020=g_imn041       #工廠別
    LET g_tlff.tlff021=p_ware        	  #倉庫別
    LET g_tlff.tlff022=p_loca             #儲位別
    LET g_tlff.tlff023=p_lot              #批號
    LET g_tlff.tlff024=l_imgg10           #異動後庫存數量
    LET g_tlff.tlff025=g_ims[l_ac].imn09        #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=g_ims01        #撥出單號
    LET g_tlff.tlff027=g_ims[l_ac].ims02        #撥出項次
#----目的----
    LET g_tlff.tlff03=57                  #資料目的為多工廠調撥
    LET g_tlff.tlff030=g_imn151       #工廠別
    LET g_tlff.tlff031=' '          	  #倉庫別
    LET g_tlff.tlff032=' '          	  #儲位別
    LET g_tlff.tlff033=' '          	  #入庫批號
    LET g_tlff.tlff034=' '          	  #異動後庫存數量
    LET g_tlff.tlff035=' '          	  #庫存單位(ima_file or img_file)
    LET g_tlff.tlff036=g_imm.imm01        #調撥單號 
    LET g_tlff.tlff037=g_ims[l_ac].ims04        #調撥項次
#--->異動數量
    LET g_tlff.tlff04=' '                 #工作站
    LET g_tlff.tlff05=' '                 #作業序號
    LET g_tlff.tlff06=g_imm.imm02         #調撥日期
    LET g_tlff.tlff07=g_today             #異動資料產生日期  
    LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user              #產生人
    LET g_tlff.tlff10=p_qty               #調撥數量
    LET g_tlff.tlff11=p_uom               #調撥單位
    LET g_tlff.tlff12=p_factor            #庫存/庫存轉換率
    LET g_tlff.tlff13='aimp700'           #異動命令代號
    LET g_tlff.tlff14=''                  #異動原因
    LET g_tlff.tlff15=' '                 #借方會計科目
    LET g_tlff.tlff16=g_ims[l_ac].imn07         #貸方會計科目
    LET g_tlff.tlff17=' '                 #非庫存性料件編號
    CALL s_imaQOH(g_ims[l_ac].imn03)
         RETURNING g_tlff.tlff18          #異動後總庫存量
    LET g_tlff.tlff19= ''                 #異動廠商/客戶編號
    LET g_tlff.tlff20= g_imn.imn08        #專案號碼         
    LET g_tlf.tlf930= g_ims[l_ac].imn9302  #FUN-670093
    IF cl_null(g_ims[l_ac].ims15) OR g_ims[l_ac].ims15=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,g_ims[l_ac].imn33)
    END IF
END FUNCTION
#FUNCTION p700_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
#                   p_flag)
#DEFINE
#   p_ware     LIKE img_file.img02,	 ##倉庫
#   p_loca     LIKE img_file.img03,	 ##儲位
#   p_lot      LIKE img_file.img04,     	 ##批號
#   p_unit     LIKE img_file.img09,
#   p_qty      LIKE img_file.img10,       ##數量
#   p_img10    LIKE img_file.img10,       ##異動後數量
#   p_uom      LIKE img_file.img09,       ##img 單位
#   p_factor   LIKE img_file.img21,  	 ##轉換率
#   l_imgg10   LIKE imgg_file.imgg10,
#   p_flag     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
#   g_cnt      LIKE type_file.num5        #No.FUN-690026 SMALLINT
#
#    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
#    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
#    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
#    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
#
#    IF p_uom IS NULL THEN
#       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
#
#    SELECT imgg10 INTO l_imgg10 FROM imgg_file
#     WHERE imgg01=g_imn.imn03 AND imgg02=p_ware
#       AND imgg03=p_loca      AND imgg04=p_lot
#       AND imgg09=p_uom
#    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
#    INITIALIZE g_tlff.* TO NULL
#    LET g_tlff.tlff01=g_imn.imn03         #異動料件編號
#    LET g_tlff.tlff02=50       	 	  #資料來源為倉庫
#    LET g_tlff.tlff020=g_imn.imn041       #工廠別
#    LET g_tlff.tlff021=p_ware        	  #倉庫別
#    LET g_tlff.tlff022=p_loca             #儲位別
#    LET g_tlff.tlff023=p_lot              #批號
#    LET g_tlff.tlff024=l_imgg10           #異動後庫存數量
#    LET g_tlff.tlff025=g_imn.imn09        #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff026=g_ims.ims01        #撥出單號
#    LET g_tlff.tlff027=g_ims.ims02        #撥出項次
##----目的----
#    LET g_tlff.tlff03=57                  #資料目的為多工廠調撥
#    LET g_tlff.tlff030=g_imn.imn151       #工廠別
#    LET g_tlff.tlff031=' '          	  #倉庫別
#    LET g_tlff.tlff032=' '          	  #儲位別
#    LET g_tlff.tlff033=' '          	  #入庫批號
#    LET g_tlff.tlff034=' '          	  #異動後庫存數量
#    LET g_tlff.tlff035=' '          	  #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff036=g_imm.imm01        #調撥單號 
#    LET g_tlff.tlff037=g_ims.ims04        #調撥項次
##--->異動數量
#    LET g_tlff.tlff04=' '                 #工作站
#    LET g_tlff.tlff05=' '                 #作業序號
#    LET g_tlff.tlff06=g_imm.imm02         #調撥日期
#    LET g_tlff.tlff07=g_today             #異動資料產生日期  
#    LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
#    LET g_tlff.tlff09=g_user              #產生人
#    LET g_tlff.tlff10=p_qty               #調撥數量
#    LET g_tlff.tlff11=p_uom               #調撥單位
#    LET g_tlff.tlff12=p_factor            #庫存/庫存轉換率
#    LET g_tlff.tlff13='aimp700'           #異動命令代號
#    LET g_tlff.tlff14=''                  #異動原因
#    LET g_tlff.tlff15=' '                 #借方會計科目
#    LET g_tlff.tlff16=g_imn.imn07         #貸方會計科目
#    LET g_tlff.tlff17=' '                 #非庫存性料件編號
#    CALL s_imaQOH(g_imn.imn03)
#         RETURNING g_tlff.tlff18          #異動後總庫存量
#    LET g_tlff.tlff19= ''                 #異動廠商/客戶編號
#    LET g_tlff.tlff20= g_imn.imn08        #專案號碼         
#    LET g_tlf.tlf930= g_imn.imn9302  #FUN-670093
#    IF cl_null(g_ims.ims15) OR g_ims.ims15=0 THEN
#       CALL s_tlff(p_flag,NULL)
#    ELSE
#       CALL s_tlff(p_flag,g_imn.imn33)
#    END IF
#END FUNCTION
#FUN-770057 end
 
FUNCTION p700_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    #No.MOD-590118  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590118  --end  
   #FUN-770057 begin
    #LET l_fac2=g_imn.imn34
    #LET l_qty2=g_ims.ims15
    #LET l_fac1=g_imn.imn31 
    #LET l_qty1=g_ims.ims14 
    LET l_fac2=g_imn.imn34
    LET l_qty2=g_ims[l_ac].ims15
    LET l_fac1=g_imn.imn31 
    LET l_qty1=g_ims[l_ac].ims14 
   #FUN-770057 end
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_ims[l_ac].ims06=l_qty1     #FUN-770057 l_ac
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ims[l_ac].ims06=l_tot       #FUN-770057 l_ac
          WHEN '3' LET g_ims[l_ac].ims06=l_qty1      #FUN-770057 l_ac
       END CASE
    #No.MOD-590118  --BEGIN
    #ELSE  #不使用雙單位
    #   LET g_ims.ims06=l_qty1
    #No.MOD-590118  --END  
    END IF
END FUNCTION
 
FUNCTION p700_set_entry_b()
 
    CALL cl_set_comp_entry("ims15",TRUE)
 
END FUNCTION
 
FUNCTION p700_set_no_entry_b()
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("ims15",FALSE)
      #FUN-770057 begin
       #LET g_imgg10_2=NULL
       #DISPLAY g_imgg10_2 TO FORMONLY.imgg10_2
       #LET g_ims.ims15=NULL
       #DISPLAY BY NAME g_ims.ims15
       LET g_ims[l_ac].imgg10_2=NULL
       DISPLAY BY NAME g_ims[l_ac].imgg10_2 
       LET g_ims[l_ac].ims15=NULL
       DISPLAY BY NAME g_ims[l_ac].ims15
      #FUN-770057 end
    END IF
END FUNCTION
#No.FUN-570249  --end
