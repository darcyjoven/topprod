# Prog. Version..: '5.30.06-13.04.10(00010)'     #
#
# Pattern name...: aimp701.4gl
# Descriptions...: 工廠間調撥－撥入確認作業
# Date & Author..: 93/07/08 By Apple
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-540059 05/06/19 By wujie  單據編號格式放大
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570249 05/07/27 By Carrier 多單位內容修改
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-610049 06/01/17 By Claire 欄位對應調整
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: NO.MOD-610082 06/03/24 By PENGU 1.第1087行LET g_invqty=g_imy..imy16*g_imy.imy18在前幾行的CALL p701_set_origin_field()
                                      #              會讓g_imy.imy16=(imy32*imy28)+(imy31*imy25)也就是已經轉成庫存單位了
                                      #            2.程式第1090行不應是拿g_imn.imn10跟l_qty比，應該拿imn22來比
# Modify.........: No.FUN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710025 07/01/18 By bnlent  錯誤訊息匯整 
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.FUN-770057 07/08/20 By rainy 改為多欄輸入
# Modify.........: No.TQC-7B0010 07/11/01 By Judy 多單位:單一單位，參考單位時不寫入imgg_file
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理:專案table gja_file改為 pja_file
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.TQC-930155 09/04/02 By dongbg open cursor或fetch cursor失敗時不要rollback,給g_success賦值
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.FUN-980092 09/09/09 By By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan ¹w³]³æ¤@¼ƶq®ɡA¥[¤W§PÂ¡A³æ¤@¼ƶq¬°ªũά°1®ɡA¤~¹w³]
# Modify.........: No:TQC-9A0126 09/10/26 By liuxqa 处理ROWID
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:CHI-A90045 10/10/13 By lilingyu 撥入審核後,未處理wip在途倉庫存
# Modify.........: No.MOD-AB0007 10/11/01 By sabrina 若"累計撥入量"大於"撥出數量"則要顯示警告訊息
# Modify.........: No:MOD-AB0009 10/11/23 By sabrina 跳到項次2(無輸入資料)時，按下確定沒反應
#                                                    更改入庫倉庫時，在離開批號欄位後倉庫會被更新回default值
# Modify.........: No.TQC-AC0053 10/12/09 By destiny 营运中心间调拨时拨入仓库没有库存
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:MOD-B20090 11/02/18 By sabrina 單身按放棄時，資料不應做寫入動作 
# Modify.........: No:TQC-BA0007 11/10/20 By Smapmin 沒有輸入確認日期與密碼欄位直接按確認,g_go就沒有給值,導致直接離開程式
#                                                    無法移至上面的行數
# Modify.........: No:FUN-BB0083 11/12/08 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C20048 12/02/09 By fengrui 增加數量欄位小數取位
# Modify.........: No:MOD-BC0029 12/06/15 By ck2yuan 應將確認人更新到imn25
# Modify.........: No.CHI-D10014 13/04/03 By bart 1.增加開窗2.增加批序號
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-DB0036 13/11/18 By wangrr 畫面檔'調撥單號'增加開窗

DATABASE ds   
 
GLOBALS "../../config/top.global"
 
DEFINE g_cmd        LIKE type_file.chr1000        #No.FUN-690026 VARCHAR(100)
 DEFINE g_imy  DYNAMIC  ARRAY OF RECORD
                 imy02   LIKE   imy_file.imy02,
                 imy04   LIKE   imy_file.imy04,
                 img01   LIKE   img_file.img01,
                 ima02   LIKE   ima_file.ima02,
                 ima05   LIKE   ima_file.ima05,
                 ima08   LIKE   ima_file.ima08,
                 imy06   LIKE   imy_file.imy06,
                 ims06   LIKE   ims_file.ims06,
                 imn11   LIKE   imn_file.imn11,
                 img02   LIKE   img_file.img02,
                 img03   LIKE   img_file.img03,
                 img04   LIKE   img_file.img04,
                 img09   LIKE   img_file.img09,
                 img35   LIKE   img_file.img35,
                 img26   LIKE   img_file.img26,
                 img19   LIKE   img_file.img19,
                 img36   LIKE   img_file.img36,
                 imn10   LIKE   imn_file.imn10,
                 imn23   LIKE   imn_file.imn23,
                 imy16   LIKE   imy_file.imy16,
                 imy17   LIKE   imy_file.imy17,
                 imn9302 LIKE   imn_file.imn9302,
                 gem02c  LIKE   gem_file.gem02,
                 imy18   LIKE   imy_file.imy18,
                 invqty  LIKE   img_file.img10,
                 desc    LIKE   ze_file.ze03,
                 imn33   LIKE   imn_file.imn33,
                 ims15   LIKE   ims_file.ims15,
                 imn30   LIKE   imn_file.imn30,
                 ims14   LIKE   ims_file.ims14,
                 imy27   LIKE   imy_file.imy27,
                 imy28   LIKE   imy_file.imy28,
                 imy29   LIKE   imy_file.imy29,
                 imy24   LIKE   imy_file.imy24,
                 imy25   LIKE   imy_file.imy25,
                 imy26   LIKE   imy_file.imy26    
               END RECORD,
        g_imy_o  RECORD
                 imy02   LIKE   imy_file.imy02,
                 imy04   LIKE   imy_file.imy04,
                 img01   LIKE   img_file.img01,
                 ima02   LIKE   ima_file.ima02,
                 ima05   LIKE   ima_file.ima05,
                 ima08   LIKE   ima_file.ima08,
                 imy06   LIKE   imy_file.imy06,
                 ims06   LIKE   ims_file.ims06,
                 imn11   LIKE   imn_file.imn11,
                 img02   LIKE   img_file.img02,
                 img03   LIKE   img_file.img03,
                 img04   LIKE   img_file.img04,
                 img09   LIKE   img_file.img09,
                 img35   LIKE   img_file.img35,
                 img26   LIKE   img_file.img26,
                 img19   LIKE   img_file.img19,
                 img36   LIKE   img_file.img36,
                 imn10   LIKE   imn_file.imn10,
                 imn23   LIKE   imn_file.imn23,
                 imy16   LIKE   imy_file.imy16,
                 imy17   LIKE   imy_file.imy17,
                 imn9302 LIKE   imn_file.imn9302,
                 gem02c  LIKE   gem_file.gem02,
                 imy18   LIKE   imy_file.imy18,
                 invqty  LIKE   img_file.img10,
                 desc    LIKE   ze_file.ze03,
                 imn33   LIKE   imn_file.imn33,
                 ims15   LIKE   ims_file.ims15,
                 imn30   LIKE   imn_file.imn30,
                 ims14   LIKE   ims_file.ims14,
                 imy27   LIKE   imy_file.imy27,
                 imy28   LIKE   imy_file.imy28,
                 imy29   LIKE   imy_file.imy29,
                 imy24   LIKE   imy_file.imy24,
                 imy25   LIKE   imy_file.imy25,
                 imy26   LIKE   imy_file.imy26    
                 END RECORD,
    g_imy01        LIKE imy_file.imy01,
    g_imy03        LIKE imy_file.imy03,
    g_imy04        LIKE imy_file.imy04,
    g_imy05        LIKE imy_file.imy05,
    g_imy06        LIKE imy_file.imy06,
    g_imy19        LIKE imy_file.imy19,
    g_imy20        LIKE imy_file.imy20,
    g_imy31        LIKE imy_file.imy32,
    g_imy32        LIKE imy_file.imy32,
    g_imy01_o      LIKE imy_file.imy01,
    g_imy03_o      LIKE imy_file.imy03,
    g_imy04_o      LIKE imy_file.imy04,
    g_imy05_o      LIKE imy_file.imy05,
    g_imy06_o      LIKE imy_file.imy06,
    g_imy19_o      LIKE imy_file.imy19,
    g_imy20_o      LIKE imy_file.imy20,
    l_ac,l_ac_t    LIKE type_file.num5,    #未取消的ARRAY CNT 
    g_rec_b        LIKE type_file.num5,
    g_wc           STRING, 
    g_row_count    LIKE type_file.num10,
    g_curs_index   LIKE type_file.num10,
    g_jump         LIKE type_file.num10,
    mi_no_ask      LIKE type_file.num5,
    g_imn041       LIKE imn_file.imn041,
    g_imn151       LIKE imn_file.imn151,
       g_img DYNAMIC ARRAY OF  RECORD LIKE img_file.*,
       g_ims        RECORD LIKE ims_file.*,
      
       g_imn        RECORD LIKE imn_file.*,
       g_pass       LIKE gen_file.gen01,          #FUN-660078
       g_pp         RECORD
                    dummy LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                    pass  LIKE azb_file.azb02,
	            cdate LIKE type_file.dat      #No.FUN-690026 DATE
                    END RECORD,
       g_go         LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
       g_sql        string,                       #No.FUN-580092 HCN
       g_t1         LIKE smy_file.smyslip,        #No.FUN-690026 VARCHAR(03)
       g_imy01_t    LIKE imy_file.imy01,
       g_imy02_t    LIKE imy_file.imy02,
       g_imf04      LIKE imf_file.imf04,
       g_imf05      LIKE imf_file.imf05,
       g_ima25      LIKE ima_file.ima25,
       g_ima100     LIKE ima_file.ima100,
       g_ima_fac    LIKE imy_file.imy18,
       t_img02      LIKE img_file.img02,
       t_img03      LIKE img_file.img03,
       h_qty        LIKE img_file.img10,
       g_invqty     LIKE img_file.img10,
       sn1,sn2,g_no LIKE type_file.num5
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_ima906         LIKE ima_file.ima906,
       g_ima907         LIKE ima_file.ima907,
       g_imgg10_1       LIKE imgg_file.imgg10,
       g_imgg10_2       LIKE imgg_file.imgg10,
       g_sw             LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       g_factor         LIKE img_file.img21,
       g_tot            LIKE img_file.img10,
       g_flag           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_chr            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_imgno      LIKE type_file.num5   #No.TQC-9A0126 rowid 
#CHI-A90045 --begin--
DEFINE g_imm08          LIKE imm_file.imm08
DEFINE g_imn05          LIKE imn_file.imn05
DEFINE g_imn06          LIKE imn_file.imn06
DEFINE g_img10          LIKE img_file.img10
#CHI-A90045 --end--
#FUN-BB0083---add---str
DEFINE g_imy17_t        LIKE imy_file.imy17
DEFINE g_imy24_t        LIKE imy_file.imy24
DEFINE g_imy27_t        LIKE imy_file.imy27
#FUN-BB0083---add---end
DEFINE g_ima918         LIKE ima_file.ima918   #CHI-D10014
DEFINE g_ima921         LIKE ima_file.ima921   #CHI-D10014
DEFINE l_r              LIKE type_file.chr1    #CHI-D10014
DEFINE g_qty            LIKE type_file.num5    #CHI-D10014

MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
    IF s_shut(0) THEN EXIT PROGRAM END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074

    CALL  g_imy.CLEAR()           #FUN-770057
    CALL  g_img.CLEAR()           #FUN-770057

    OPEN WINDOW p701_w WITH FORM "aim/42f/aimp701"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL p701_mu_ui()
 
    CALL p701_pass()
    IF g_go='N' THEN EXIT PROGRAM END IF
   CALL p701()      #FUN-770057
    CLOSE WINDOW p701_w                         #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION p701_cur()
 DEFINE  l_sql  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
#---->撥出單單身讀取(LOCK 此筆單身)
    LET l_sql=
        "SELECT ims_file.*",
        " FROM  ims_file ",
        "   WHERE ims01= ? ",        #撥出單號
        "   AND ims02= ? ",        #撥出項次
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE ims_p FROM l_sql
    DECLARE ims_lock CURSOR FOR ims_p
 
#---->調撥單單身讀取(LOCK 此筆單身)
    LET l_sql=
        "SELECT imn09,imn10,imn11,imn041,imn23,imn151,",
        "       imn15,imn16,imn17,imn20,imn33,imn35,imn30,imn32,imn43,",
        "       imn45,imn40,imn42,imn9302 ", #FUN-670093
        " FROM  imn_file ",
        "   WHERE imn01= ? ",        #調撥單號
        "   AND imn02= ? ",        #調撥項次
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE imn_p FROM l_sql
    DECLARE imn_lock CURSOR FOR imn_p
 
#---->讀取料件基本資料檔(LOCK 此筆單身)
    LET l_sql=
        "SELECT ima02,ima05,ima08,ima25 ", #FUN-560183 拿掉ima86
        " FROM ima_file",
        "   WHERE  ima01= ? ",       #料號
        "   FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE ima_p FROM l_sql
    DECLARE ima_lock CURSOR FOR ima_p

#---->DEFAULT 項次  950228 Add By Jackson
    LET l_sql=
        " SELECT ims02 FROM ims_file   WHERE ims01= ? "
    PREPARE imy_pr FROM l_sql
    DECLARE imy_cs SCROLL CURSOR FOR imy_pr
 
END FUNCTION
 
FUNCTION p701()
  DEFINE li_result   LIKE type_file.num5,        #No.FUN-550029  #No.FUN-690026 SMALLINT
         l_cnt       LIKE type_file.num5
  IF s_shut(0) THEN RETURN END IF
  CALL ui.Interface.refresh()
 
  MESSAGE ""
  CALL cl_opmsg('a')
  WHILE TRUE
    CLEAR FORM
    LET g_imy19 = g_pp.cdate
    LET g_imy20 = g_pass
    LET g_imy01 = NULL
    LET g_imy03 = NULL
    LET g_imy05 = NULL
    INITIALIZE g_imn.* TO NULL
    LET g_rec_b = 0
    CALL g_imy.CLEAR()
    CALL p701_imy20()
    CALL p701_i()                #輸入單頭
    IF INT_FLAG THEN             #使用者不輸入了
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
    END IF
    CALL p701_plant()
 
    LET l_cnt = 0
    CALL  s_auto_assign_no("aim",g_imy01,g_imy19,"H","imy_file","imy01", 
                           "","","")
          RETURNING li_result,g_imy01
    IF (NOT li_result) THEN
       CONTINUE WHILE
    END IF
    DISPLAY g_imy01 TO imy01
 
    LET g_imy01_t=''
    CALL s_get_bookno(YEAR(g_imy19))
         RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_imy19,'aoo-081',1)
       EXIT WHILE 
    END IF
 
    #進入單身輸入
     LET g_no=0
     CALL p701_b()             
  END WHILE 
END FUNCTION
 
FUNCTION p701_plant()
  IF cl_null(g_imy05) THEN RETURN END IF
  SELECT DISTINCT imn041,imn151 
    INTO g_imn041,g_imn151
    FROM imn_file
   WHERE imn01 = g_imy05
  IF SQLCA.sqlcode THEN
    LET g_imn041 = ''
    LET g_imn151 = ''
  END IF
  DISPLAY g_imn041 TO imn041
  DISPLAY g_imn151 TO imn151 
END FUNCTION
 
FUNCTION p701_b()
 DEFINE
    l_n,i           LIKE type_file.num5,    #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態  
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5,     #可刪除否  
    l_diff     LIKE imn_file.imn10
 DEFINE  l_cnt      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_code     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_cmd      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
         l_str      LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(78)
         l_qty      LIKE imn_file.imn23,
         l_img26    LIKE img_file.img26,
         l_sta      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_status   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 DEFINE  l_where    STRING,  #串 aimp702的單身條件
         l_pmt      LIKE type_file.num5,
         l_case     STRING                  #FUN-BB0083 add
DEFINE   l_i        LIKE type_file.num5     #CHI-D10014
DEFINE   l_rvbs06   LIKE rvbs_file.rvbs06   #CHI-D10014
DEFINE   l_imy16    LIKE imy_file.imy16     #CHI-D10014

    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_imy01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    #-----TQC-BA0007---------
    #LET g_forupd_sql =
    # "  SELECT imy02,imy04,'',   '',   '',   '',   imy06,0,    0,    '', ",
    # "         '',   '',   '',   '',   '',   '',   '',   0,    0, imy16,",
    # "         imy17,'',   '',   imy18,0,    '',   '',   0,    '',0,",
    # "         imy27,imy28,imy29,imy24,imy25,imy26 ",
    # "  FROM ims_file ",
    # "  WHERE ims01 = ? ",
    # "    AND ims02 = ? ",
    # "  FOR UPDATE "
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    #
    #DECLARE p701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    #-----END TQC-BA0007-----
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    #LET l_allow_delete = FALSE   #TQC-BA0007
    LET l_allow_delete = cl_detail_input_auth("delete")   #TQC-BA0007
 
    INPUT ARRAY g_imy WITHOUT DEFAULTS FROM s_imy.*
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
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_imy_o.* = g_imy[l_ac].*  #BACKUP
            #FUN-BB0083---add---str
            LET g_imy17_t = g_imy[l_ac].imy17
            LET g_imy24_t = g_imy[l_ac].imy24
            LET g_imy27_t = g_imy[l_ac].imy27
            #FUN-BB0083---add---end
 
            #-----TQC-BA0007---------
            #OPEN p701_bcl USING g_imy01,g_imy_o.imy02
            ##DISPLAY g_imy01,g_imy_o.imy02  CHI-A70049 mark
            #IF STATUS THEN
            #   CALL cl_err("OPEN p701_bcl:", STATUS, 1)
            #   LET l_lock_sw = "Y"
            #ELSE
            #   FETCH p701_bcl INTO g_imy[l_ac].*
            #   IF SQLCA.sqlcode THEN
            #       CALL cl_err(g_imy_o.imy02,SQLCA.sqlcode,1)
            #       LET l_lock_sw = "Y"
            #   END IF
            #   LET g_imy[l_ac].gem02c=s_costcenter_desc(g_imy[l_ac].imn9302) 
            #END IF
            #-----END TQC-BA0007-----
            CALL cl_show_fld_cont()    
         END IF
         LET g_no=g_no+1
         CALL p701_cur()

        AFTER ROW   #TQC-BA0007
            #CHI-D10014---begin
            IF NOT cl_null(g_imy[l_ac].img01) AND NOT cl_null(g_imy[l_ac].imy02) THEN 
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_imy[l_ac].img01
                  AND imaacti = "Y"
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  SELECT SUM(rvbs06) INTO l_rvbs06
                    FROM rvbs_file
                   WHERE rvbs00 = g_prog
                     AND rvbs01 = g_imy01
                     AND rvbs02 = g_imy[l_ac].imy02
                     AND rvbs09 = 1
                     AND rvbs13 = 0

                  IF cl_null(l_rvbs06) THEN
                     LET l_rvbs06 = 0
                  END IF

                  IF g_imy[l_ac].imy16 <> l_rvbs06 THEN
                     CALL cl_err(g_imy[l_ac].imy02,"aim-011",1)
                     NEXT FIELD imy16
                  END IF
               END IF
            END IF    
            #CHI-D10014---end
          COMMIT WORK   #TQC-BA0007
          #FUN-BB0083---add---str
          LET g_imy17_t = NULL
          LET g_imy24_t = NULL
          LET g_imy27_t = NULL
          #FUN-BB0083---add---end
 
        BEFORE FIELD imy02
          IF g_imy[l_ac].imy02 IS NULL OR g_imy[l_ac].imy02 = 0
             OR g_imy02_t IS NULL OR g_imy02_t = ' '
          THEN 
                LET g_imy[l_ac].imy02=g_imy[l_ac].imy04
                DISPLAY BY NAME g_imy[l_ac].imy02
          END IF
 
        AFTER FIELD imy02
           #MOD-AB0009---mark---start---
           #IF g_imy[l_ac].imy02 IS NULL OR g_imy[l_ac].imy02 <=0
           #THEN NEXT FIELD ims02
           #END IF
           #MOD-AB0009---mark---end---
            IF g_imy[l_ac].imy02 IS NOT NULL THEN
                SELECT count(*) INTO l_n
                    FROM imy_file
                    WHERE imy01 = g_imy01
                      AND imy02 = g_imy[l_ac].imy02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    DISPLAY BY NAME g_imy[l_ac].imy02
                    NEXT FIELD imy02
                END IF
            END IF
 
 
        BEFORE FIELD imy04
            OPEN imy_cs USING g_imy03
            FETCH ABSOLUTE g_no imy_cs INTO g_imy[l_ac].imy04
            CALL p701_set_entry_b()
            CALL p701_set_no_required()
 
        AFTER FIELD imy04   #撥出項次
            IF g_imy[l_ac].imy04 IS NULL OR g_imy[l_ac].imy04 = ' ' THEN
                #NEXT FIELD imy04      #MOD-AB0009 mark
            ELSE 
                #判斷不可重覆輸入撥出項次
                 FOR i = 1 TO g_rec_b
                   IF i <> l_ac THEN
                      IF g_imy[i].imy04 = g_imy[l_ac].imy04 THEN
                        CALL cl_err(g_imy[l_ac].imy04,'asf-406',0)
                        NEXT FIELD imy04
                      END IF
                   END IF
                 END FOR
 
                 CALL p701_imy04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_imy[l_ac].imy04,g_errno,0)
                    LET g_imy[l_ac].imy04 = g_imy_o.imy04
                    DISPLAY BY NAME g_imy[l_ac].imy04
                    NEXT FIELD imy04
                 END IF
            END IF
            CALL p701_set_no_entry_b()
            CALL p701_set_required()
 
        BEFORE FIELD img02   #倉庫
            IF g_sma.sma12 ='N' THEN NEXT FIELD imy16 END IF
 
        AFTER FIELD img02  #倉庫
            IF g_imy[l_ac].img02 IS NULL OR g_imy[l_ac].img02 = ' ' THEN
                NEXT FIELD img02
            END IF
 #------>check-1
            IF NOT s_imfchk1(g_imy[l_ac].img01,g_imy[l_ac].img02)
               THEN CALL cl_err(g_imy[l_ac].img01,'mfg9036',0)
                    NEXT FIELD img02
            END IF
 #------>check-2
            CALL s_stkchk(g_imy[l_ac].img02,'A') RETURNING l_code
            IF NOT l_code THEN
               CALL cl_err(g_imy[l_ac].img02,'mfg1100',0)
               NEXT FIELD img02
            END IF
            CALL  s_swyn(g_imy[l_ac].img02) RETURNING sn1,sn2
            IF sn1=1 AND g_imy[l_ac].img02!=t_img02
               THEN CALL cl_err(g_imy[l_ac].img02,'mfg6080',0)
                    LET t_img02=g_imy[l_ac].img02
                    NEXT FIELD img02
                ELSE IF sn2=2 AND g_imy[l_ac].img02!=t_img02
                       THEN CALL cl_err(g_imy[l_ac].img02,'mfg6085',0)
                            LET t_img02=g_imy[l_ac].img02
                            NEXT FIELD img02
                      END IF
	              #IF NOT s_imechk(g_imy[l_ac].img02,g_imy[l_ac].img03) THEN NEXT FIELD img03 END IF  #FUN-D40103 add  #TQC-D50124 mark
            END IF
			LET sn1=0 LET sn2=0
            IF g_imy[l_ac].img02 IS NULL THEN LET g_imy[l_ac].img02=' ' END IF
     
 
        AFTER FIELD img03      #儲位
#------>chk-1
            IF NOT s_imfchk(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03)
               THEN CALL cl_err(g_imy[l_ac].img03,'mfg6095',0)
                    NEXT FIELD img03
            END IF
            IF g_imy[l_ac].img03 IS NOT NULL THEN
                CALL s_hqty(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03)
                    RETURNING g_cnt,g_imf04,g_imf05
                IF g_imf04 IS NULL THEN LET g_imf04=0 END IF
                LET h_qty=g_imf04
                CALL  s_lwyn(g_imy[l_ac].img02,g_imy[l_ac].img03) RETURNING sn1,sn2
    			IF sn1=1 AND g_imy[l_ac].img03!=t_img03
                   THEN CALL cl_err(g_imy[l_ac].img03,'mfg6081',0)
                        LET t_img03=g_imy[l_ac].img03
                        NEXT FIELD img03
                   ELSE IF sn2=2 AND g_imy[l_ac].img03!=t_img03
                           THEN CALL cl_err(g_imy[l_ac].img03,'mfg6086',0)
                                LET t_img03=g_imy[l_ac].img03
                        NEXT FIELD img03
                        END IF
                END IF
                LET sn1=0 LET sn2=0
          END IF
          IF g_imy[l_ac].img03 IS NULL THEN LET g_imy[l_ac].img03=' ' END IF
	#IF NOT s_imechk(g_imy[l_ac].img02,g_imy[l_ac].img03) THEN NEXT FIELD img03 END IF  #FUN-D40103 add #TQC-D50124 mark
 
        AFTER FIELD img04      #批號
            IF g_imy[l_ac].img04 IS NULL THEN LET g_imy[l_ac].img04=' ' END IF
            CALL p701_img04()
            IF INT_FLAG THEN 
               LET INT_FLAG = 0
               RETURN 
            END IF
            IF g_chr='L' THEN #Locked
                CALL cl_err(g_img[l_ac].img04,'aoo-060',0)
                NEXT FIELD img04
            END IF
#----->-3333 表該批號不存在, 則庫存單位預設為料件預設庫存單位
#           借方會計科目預設為{0,1,2}
            IF g_imgno !='-3333' THEN
              IF NOT s_actimg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04)
                  THEN CALL cl_err('inactive','mfg6117',0)
                       NEXT FIELD img02
              END IF
            ELSE LET g_imy[l_ac].img09 = g_imn.imn09
                 DISPLAY BY NAME g_imy[l_ac].img09
            END IF
            DISPLAY BY NAME g_imy[l_ac].img04
 
        AFTER FIELD img35   #專案號碼
            IF  NOT cl_null(g_imy[l_ac].img35)
            THEN 
                 SELECT pja01 FROM pja_file
                             WHERE pja01=g_imy[l_ac].img35
                               AND pjaacti = 'Y'
                               AND pjaclose = 'N'    #No.FUN-960038
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","pja_file",g_imy[l_ac].img35,"","mfg3064",   #FUN-810045 gja_file->pja_file
                                 "","",0)  #No.FUN-660156
                    NEXT FIELD img35
                 END IF
            END IF
 
        BEFORE FIELD img26
            CALL s_act(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03)
                 RETURNING l_img26,l_status
            IF l_status='0' AND g_imy[l_ac].img26 IS NULL
               THEN CALL cl_err(g_imy[l_ac].img26,'mfg6112',0)
            END IF
            IF l_status MATCHES '[12]' THEN
               LET g_imy[l_ac].img26=l_img26
               DISPLAY BY NAME g_imy[l_ac].img26
            END IF
 
        AFTER FIELD img26   #會計科目
           IF l_status ='0' THEN
              IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_imy[l_ac].img26,g_bookno1) THEN  #No.FUN-730033
                    CALL cl_err(g_imy[l_ac].img26,'mfg0018',0)
                    #FUN-B10049--begin
                    CALL cl_init_qry_var()                                         
                    LET g_qryparam.form ="q_aag"                                   
                    LET g_qryparam.default1 = g_imy[l_ac].img26 
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.arg1 = g_bookno1
                    LET g_qryparam.where = " aag01 LIKE '",g_imy[l_ac].img26 CLIPPED,"%' "                                                                        
                    CALL cl_create_qry() RETURNING g_imy[l_ac].img26
                    DISPLAY BY NAME g_imy[l_ac].img26
                    #FUN-B10049--end                        
                    NEXT FIELD img26
                END IF
              END IF
            END IF
 
        BEFORE FIELD img09
            IF g_imgno !='-3333' THEN
               IF g_sma.sma115='Y' THEN
                  NEXT FIELD imy27
               ELSE
                  NEXT FIELD imy16
               END IF
            END IF
 
        BEFORE FIELD img36
            IF g_imgno !='-3333' THEN
               NEXT FIELD img04
            END IF
        #FUN-BB0083---add---str
        AFTER FIELD imy17
           LET l_case = ""  #FUN-C20048 add
           IF NOT cl_null(g_imy[l_ac].imy16) AND g_imy[l_ac].imy16<>0 THEN  #FUN-C20048 add
              CALL p701_imy16_check() RETURNING l_case
           END IF           #FUN-C20048 add 
           LET g_imy17_t = g_imy[l_ac].imy17
           CASE l_case
              WHEN "imy16"
                 NEXT FIELD imy16
              WHEN "imy17"
                 NEXT FIELD imy17
              OTHERWISE EXIT CASE
          END CASE  
        #FUN-BB0083---add---end
        #CHI-D10014---begin
        BEFORE FIELD imy16
            SELECT SUM(rvbs06)
              INTO l_imy16
              FROM rvbs_file
             WHERE rvbs00 = 'aimp701'
               AND rvbs01 = g_imy01
               AND rvbs02 = g_imy[l_ac].imy02
               AND rvbs09 = 1
             IF l_imy16 <> 0 THEN
                LET g_imy[l_ac].imy16 = l_imy16 - g_imy[l_ac].imn23  
             ELSE  
                LET g_imy[l_ac].imy16 = g_imy[l_ac].imn10 - g_imy[l_ac].imn23
             END IF 
            DISPLAY BY NAME g_imy[l_ac].imy16
        #CHI-D10014---end
        AFTER FIELD imy16    #本次實收數量
            #FUN-BB0083---add---str
             CALL p701_imy16_check() RETURNING l_case
             CASE l_case
                 WHEN "imy16"
                    NEXT FIELD imy16
                 WHEN "imy17"
                    NEXT FIELD imy17
                 OTHERWISE EXIT CASE
             END CASE
            #FUN-BB0083---add---end
            
            #FUN-BB0083---mark---str
            #IF g_imy[l_ac].imy16 IS NULL OR g_imy[l_ac].imy16 = ' '
            #   OR g_imy[l_ac].imy16 <= 0
            #THEN NEXT FIELD imy16
            #END IF
            ##檢查撥出/撥入單位是否可以轉換
            # CALL s_umfchk(g_imy[l_ac].img01,g_imn.imn09,g_imy[l_ac].img09)
            #      RETURNING l_status,g_imy[l_ac].imy18
            #      IF l_status THEN
            #         CALL cl_err('','mfg3481',0)
            #         NEXT FIELD imy17
            #      END IF
            ##檢查撥入/料件單位是否可以轉換
            # CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy17,g_ima25)
            #      RETURNING l_status,g_img[l_ac].img21
            #      IF l_status THEN
            #         CALL cl_err('','mfg3075',0)
            #         NEXT FIELD imy17
            #      END IF
            # IF g_imy[l_ac].imy18 IS NULL OR g_imy[l_ac].imy18 <= 0
            # THEN LET g_imy[l_ac].imy18 = 1
            # END IF
            # IF g_img[l_ac].img21 IS NULL OR g_img[l_ac].img21 <= 0
            # THEN LET g_img[l_ac].img21 = 1
            # END IF
            # LET g_imy[l_ac].invqty = g_imy[l_ac].imy16                 #NO.MOD-610082 add
            # DISPLAY BY NAME g_imy[l_ac].imy18
            # DISPLAY BY NAME g_imy[l_ac].invqty 
            # LET l_qty = g_imy[l_ac].imn23 + g_imy[l_ac].invqty
            # #IF l_qty > g_imn.imn22  THEN  #NO:MOD-610082 add     #TQC-BA0007
            # IF l_qty > g_imy[l_ac].imn11  THEN  #NO:MOD-610082 add     #TQC-BA0007
            #    CALL cl_getmsg('mfg3484',g_lang) RETURNING l_str
            #    IF NOT cl_prompt(16,11,l_str) THEN
            #       NEXT FIELD imy16
            #    END IF
            # END IF
            # #FUN-BB0083---mark---end
             #CHI-D10014---begin
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_imy[l_ac].img01
                AND imaacti = "Y"
             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                CALL s_lotin(g_prog,g_imy01,g_imy[l_ac].imy02,0,
                             g_imy[l_ac].img01,g_imy[l_ac].imy17,g_imy[l_ac].img09,
                             1,g_imy[l_ac].imy16,'','SEL')
                   RETURNING l_r,g_qty
                   IF l_r = "Y" THEN
                      LET g_imy[l_ac].imy16 = g_qty
                   END IF
                   DISPLAY BY NAME g_imy[l_ac].imy16
                   
             END IF 
             #CHI-D10014---end
             
        BEFORE FIELD imy27
           CALL p701_set_no_required()
 
        AFTER FIELD imy27
           IF cl_null(g_imy[l_ac].img01) THEN NEXT FIELD imy04 END IF
           IF g_imy[l_ac].img02 IS NULL OR g_imy[l_ac].img03 IS NULL OR
              g_imy[l_ac].img04 IS NULL THEN
              NEXT FIELD img02
           END IF
           IF NOT cl_null(g_imy[l_ac].imy27) THEN
              SELECT gfe02 FROM gfe_file
               WHERE gfe01=g_imy[l_ac].imy27
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imy[l_ac].imy27,"",STATUS,
                              "","gfe:",0)  #No.FUN-660156
                 NEXT FIELD imy27
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',
                               g_imy[l_ac].img09,g_imy[l_ac].imy27,g_ima906)
                   RETURNING g_errno,g_imy32
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imy[l_ac].imy27,g_errno,0)
                 NEXT FIELD imy27
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',g_imy[l_ac].imn33,g_imy[l_ac].imy27,g_ima906)
                   RETURNING g_errno,g_imy[l_ac].imy29
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('imn33/imy27','mfg3075',1)
                 NEXT FIELD imy27
              END IF
              DISPLAY BY NAME g_imy[l_ac].imy29
              CALL s_chk_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,
                              g_imy[l_ac].img03,g_imy[l_ac].img04,
                              g_imy[l_ac].imy27) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imy27
                    END IF
                 END IF
                 CALL s_add_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,
                                 g_imy[l_ac].imy27,g_imy32,g_imy01,g_imy[l_ac].imy02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imy27
                 END IF
              END IF
           END IF
           CALL p701_set_required()
           #FUN-BB0083---add---str
           IF NOT p701_imy28_check() THEN
              LET g_imy27_t = g_imy[l_ac].imy27
              NEXT FIELD imy28
           END IF 
           LET g_imy27_t = g_imy[l_ac].imy27
           #FUN-BB0083---add---end
           
 
        BEFORE FIELD imy28
           IF cl_null(g_imy[l_ac].img01) THEN NEXT FIELD imy04 END IF
           IF g_imy[l_ac].img02 IS NULL OR g_imy[l_ac].img03 IS NULL OR
              g_imy[l_ac].img04 IS NULL THEN
              NEXT FIELD img02
           END IF
           IF NOT cl_null(g_imy[l_ac].imy27) AND g_ima906='3' THEN
              SELECT gfe02 FROM gfe_file
               WHERE gfe01=g_imy[l_ac].imy27
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imy[l_ac].imy27,"",STATUS,
                              "","gfe:",0)  #No.FUN-660156
                 NEXT FIELD imy04
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',
                               g_imy[l_ac].img09,g_imy[l_ac].imy27,g_ima906)
                   RETURNING g_errno,g_imy32
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imy[l_ac].imy27,g_errno,0)
                 NEXT FIELD imy04
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',g_imy[l_ac].imn33,g_imy[l_ac].imy27,g_ima906)
                   RETURNING g_errno,g_imy[l_ac].imy29
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('imn33/imy27','mfg3075',1)
                 NEXT FIELD imy04
              END IF
              CALL s_chk_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,
                              g_imy[l_ac].img03,g_imy[l_ac].img04,
                              g_imy[l_ac].imy27) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imy04
                    END IF
                 END IF
                 CALL s_add_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,
                                 g_imy[l_ac].imy27,g_imy32,g_imy01,g_imy[l_ac].imy02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imy04
                 END IF
              END IF
              CALL p701_set_required()
           END IF
           
 
        AFTER FIELD imy28
           #FUN-BB0083---add---str
            IF NOT p701_imy28_check() THEN
               NEXT FIELD imy28
            END IF
           #FUN-BB0083---add---end

           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imy[l_ac].imy28) THEN
           #   IF g_imy[l_ac].imy28 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imy28
           #   END IF
           #   IF g_ima906='3' THEN
           #      LET g_tot=g_imy[l_ac].imy28*g_imy32
           #      IF cl_null(g_imn.imn32) OR g_imn.imn32=0 THEN  #No.CHI-960022
           #         LET g_imn.imn32=g_tot*g_imy31
           #         DISPLAY BY NAME g_imn.imn32                 #No.CHI-960022
           #      END IF                                         #No.CHI-960022
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
        BEFORE FIELD imy24
           CALL p701_set_no_required()
 
        AFTER FIELD imy24
           IF cl_null(g_imy[l_ac].img01) THEN NEXT FIELD imy04 END IF
           IF g_imy[l_ac].img02 IS NULL OR g_imy[l_ac].img03 IS NULL OR
              g_imy[l_ac].img04 IS NULL THEN
              NEXT FIELD img02
           END IF
           IF NOT cl_null(g_imy[l_ac].imy24) THEN
              SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_imy[l_ac].img01 #TQC-7B0010
              SELECT gfe02 FROM gfe_file
               WHERE gfe01=g_imy[l_ac].imy24
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imy[l_ac].imy24,"",STATUS,
                              "","gfe:",0)  #No.FUN-660156
                 NEXT FIELD imy24
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',
                               g_imy[l_ac].img09,g_imy[l_ac].imy24,'1')
                   RETURNING g_errno,g_imy31
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imy[l_ac].imy24,g_errno,0)
                 NEXT FIELD imy24
              END IF
              CALL s_du_umfchk(g_imy[l_ac].img01,'','','',g_imy[l_ac].imn30,g_imy[l_ac].imy24,g_ima906)
                   RETURNING g_errno,g_imy[l_ac].imy26
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('imn33/imy27','mfg3075',1)
                 NEXT FIELD imy24
              END IF
              DISPLAY BY NAME g_imy[l_ac].imy26
              IF g_ima906 = '2' THEN  #TQC-7B0010
                 CALL s_chk_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,
                                 g_imy[l_ac].img03,g_imy[l_ac].img04,
                                 g_imy[l_ac].imy24) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD imy24
                       END IF
                    END IF
                    CALL s_add_imgg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,
                                    g_imy[l_ac].imy24,g_imy31,g_imy01,g_imy[l_ac].imy02,0)
                         RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imy24
                    END IF
                 END IF
              END IF  #TQC-7B0010
           END IF
           CALL p701_set_required()
           #FUN-BB0083---add---str
           IF NOT p701_imy25_check() THEN
              LET g_imy24_t = g_imy[l_ac].imy24
              NEXT FIELD imy25
           END IF 
           LET g_imy24_t = g_imy[l_ac].imy24
           #FUN-BB0083---add---end
 
 
        AFTER FIELD imy25
           #FUN-BB0083---add---str
            IF NOT p701_imy25_check() THEN
               NEXT FIELD imy25
            END IF
           #FUN-BB0083---add---end

           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imy[l_ac].imy25) THEN
           #   IF g_imy[l_ac].imy25 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imy25
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
      ON ACTION CONTROLP
         CASE
               WHEN INFIELD(imy04) #撥出
                  CALL q_ims(FALSE,TRUE,g_imy03,g_imy[l_ac].imy04,
                                        g_imy05,g_plant)
                       RETURNING g_imy03,g_imy[l_ac].imy04,
                                 g_imy05,g_imy[l_ac].imy06
                  DISPLAY BY NAME g_imy[l_ac].imy04
                  NEXT FIELD imy04
               WHEN INFIELD(img02) #倉庫
                  CALL cl_init_qry_var()
                  IF g_sma.sma42 MATCHES '[3]' THEN
                     LET g_qryparam.form = "q_imfd01"
                  ELSE
                     LET g_qryparam.form = "q_imfd02"
                     LET g_qryparam.arg1 = g_imy[l_ac].img01
                  END IF
                  LET g_qryparam.default1 = g_imy[l_ac].img02
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img02
                  DISPLAY BY NAME g_imy[l_ac].img02
                  NEXT FIELD img02
               WHEN INFIELD(img03) #儲位
                  CALL cl_init_qry_var()
                  IF g_sma.sma42 MATCHES '[13]' THEN
                     LET g_qryparam.form = "q_imfe01"
                  ELSE
                     LET g_qryparam.form = "q_imfe02"
                  END IF
                  LET g_qryparam.default1 = g_imy[l_ac].img03
                  LET g_qryparam.arg1 = g_imy[l_ac].img02
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img03
                  DISPLAY BY NAME g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04
                  NEXT FIELD img03
               WHEN INFIELD(img04) #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_img"
                  LET g_qryparam.default1 = g_imy[l_ac].img01
                  LET g_qryparam.arg1 = g_imy[l_ac].img01
                  LET g_qryparam.arg2 = g_imy[l_ac].img02
                  LET g_qryparam.arg3 = g_imy[l_ac].img03
                  IF g_sma.sma43='2' THEN
                     LET g_qryparam.ordercons = " DESC"
                  END IF
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img04
                  DISPLAY BY NAME g_imy[l_ac].img04
                  NEXT FIELD img04
               WHEN INFIELD(img09) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_imy[l_ac].img09
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img09
                  DISPLAY BY NAME g_imy[l_ac].img09
                  NEXT FIELD img09
               WHEN INFIELD(img35) #專案名稱
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"   #FUN-810045
                  LET g_qryparam.default1 = g_imy[l_ac].img35
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img35
                  DISPLAY BY NAME g_imy[l_ac].img35
                  NEXT FIELD img35
               WHEN INFIELD(img26) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_imy[l_ac].img26
                  LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_imy[l_ac].img26
                  DISPLAY BY NAME g_imy[l_ac].img26
                  NEXT FIELD img26
               WHEN INFIELD(imy24) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_imy[l_ac].imy24
                  CALL cl_create_qry() RETURNING g_imy[l_ac].imy24
                  DISPLAY BY NAME g_imy[l_ac].imy24
                  NEXT FIELD imy24
               WHEN INFIELD(imy27) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_imy[l_ac].imy27
                  CALL cl_create_qry() RETURNING g_imy[l_ac].imy27
                  DISPLAY BY NAME g_imy[l_ac].imy27
                  NEXT FIELD imy27
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION q_img6  #查詢庫存等級外觀
                CALL q_img6(FALSE,TRUE,g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,'A')
                   RETURNING g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,g_imy[l_ac].img19,
                             g_imy[l_ac].img36
                DISPLAY BY NAME g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,
                                g_imy[l_ac].img19,g_imy[l_ac].img36
                NEXT FIELD img02
 
      ON ACTION mntn_stock
                   LET g_cmd = 'aimi200 x'
                   CALL cl_cmdrun(g_cmd)
      ON ACTION mntn_loc
                   LET g_cmd = "aimi201 '",g_imy[l_ac].img02,"'" #BugNo:6598
                   CALL cl_cmdrun(g_cmd)
      ON ACTION mntn_unit
                  CALL cl_cmdrun("aooi101 ")
 
      ON ACTION mntn_unit_conv
                  CALL cl_cmdrun("aooi102 ")
 
      ON ACTION mntn_item_unit_conv
                  CALL cl_cmdrun("aooi103")
 
      ON ACTION def_imf   #預設倉庫/ 儲位
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imf"
               LET g_qryparam.default1 = g_imy[l_ac].img02
               LET g_qryparam.default2 = g_imy[l_ac].img03
               LET g_qryparam.arg1     = g_imy[l_ac].img01
               LET g_qryparam.arg2     = "A"
               IF g_qryparam.arg2 != 'A' THEN
                  LET g_qryparam.where=g_qryparam.where CLIPPED,
                                       " AND ime04 matches'",g_qryparam.arg2,"' "
               END IF
               CALL cl_create_qry() RETURNING g_imy[l_ac].img02,g_imy[l_ac].img03
               DISPLAY BY NAME g_imy[l_ac].img02,g_imy[l_ac].img03
               NEXT FIELD img02
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INSERT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL p701_free()
        END IF
        LET g_rec_b = g_rec_b + 1
 
 
      AFTER INPUT
            IF INT_FLAG THEN 
               LET INT_FLAG = 0
               EXIT INPUT 
            END IF
            IF g_sma.sma115='Y' THEN
               CALL p701_set_origin_field()
               IF g_imy[l_ac].imy16 IS NULL OR g_imy[l_ac].imy16 = ' '
                  OR g_imy[l_ac].imy16 <=0 THEN
                  IF g_ima906 MATCHES '[23]' THEN
                     NEXT FIELD imy25
                  ELSE
                     NEXT FIELD imy28
                  END IF
               END IF
               #檢查撥出/撥入單位是否可以轉換
               CALL s_umfchk(g_imy[l_ac].img01,g_imn.imn09,g_imy[l_ac].img09)
                    RETURNING l_status,g_imy[l_ac].imy18
               IF l_status THEN
                  CALL cl_err('','mfg3481',0)
                  NEXT FIELD imy24
               END IF
               #檢查撥入/料件單位是否可以轉換
               CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy17,g_ima25)
                    RETURNING l_status,g_img[l_ac].img21
               IF l_status THEN
                  CALL cl_err('','mfg3075',0)
                  NEXT FIELD imy24
               END IF
               IF g_imy[l_ac].imy18 IS NULL OR g_imy[l_ac].imy18 <= 0 THEN
                  LET g_imy[l_ac].imy18 = 1
               END IF
               IF g_img[l_ac].img21 IS NULL OR g_img[l_ac].img21 <= 0 THEN
                  LET g_img[l_ac].img21 = 1
               END IF
               LET g_imy[l_ac].invqty = g_imy[l_ac].imy16 * g_imy[l_ac].imy18
               DISPLAY BY NAME g_imy[l_ac].invqty 
               LET l_qty = g_imy[l_ac].imn23 + g_imy[l_ac].invqty
               #IF l_qty > g_imy[l_ac].imn10  THEN   #TQC-BA0007
               IF l_qty > g_imy[l_ac].imn11  THEN   #TQC-BA0007
                  CALL cl_getmsg('mfg3484',g_lang) RETURNING l_str
                  IF NOT cl_prompt(16,11,l_str) THEN
                     NEXT FIELD imy16
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_imy[l_ac].imy02) AND NOT cl_null(g_imy[l_ac].imy04) THEN    #No:MOD-AB0009 add
               IF g_imy[l_ac].imy16 IS NULL OR g_imy[l_ac].imy16 = ' '
                  OR g_imy[l_ac].imy16 <=0
               THEN NEXT FIELD imy16
               END IF
            END IF             #MOD-AB0009 add
           #-----TQC-BA0007--------- 
           ##MOD-B20090---add---start---
           ##將此段移到AFTER INPUT裡
           # LET l_where = NULL
           # FOR i = 1 TO g_rec_b
           #     LET l_ac = i
           #     LET g_success = 'Y'
           #     IF p701_t2() THEN
           #          LET g_success='N'
           #     END IF
           #     CALL s_showmsg()     
           #     IF g_success = 'Y' THEN
           #       CALL cl_cmmsg(4)  
           #       IF g_imy[l_ac].imy16 + g_imy[l_ac].imn23 != g_imy[l_ac].ims06 THEN      
           #          IF cl_null(l_where) THEN 
           #             LET l_where = " imy02 IN(",g_imy[l_ac].imy02 
           #          ELSE
           #             LET l_where = l_where CLIPPED, ",",g_imy[l_ac].imy02
           #          END IF
           #       END IF
           #     ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
           #     END IF
           #     CALL p701_free()       
           # END FOR
           ##MOD-B20090---add---end--- 
           #-----END TQC-BA0007----- 

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #CHI-D10014---begin
      ON ACTION CANCEL
         ROLLBACK WORK
         DELETE FROM rvbs_file
         WHERE rvbs00 = g_prog
           AND rvbs01 = g_imy01
         COMMIT WORK
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 

      ON ACTION modi_lot
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_imy[l_ac].img01
            AND imaacti = "Y"
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            CALL s_lotin(g_prog,g_imy01,g_imy[l_ac].imy02,0,
                         g_imy[l_ac].img01,g_imy[l_ac].imy17,g_imy[l_ac].img09,
                         1,g_imy[l_ac].imy16,'','SEL')
               RETURNING l_r,g_qty
               IF l_r = "Y" THEN
                  LET g_imy[l_ac].imy16 = g_qty
               END IF
               DISPLAY BY NAME g_imy[l_ac].imy16
                
         END IF 
      #CHI-D10014---end
    END INPUT
 
 
   #-----TQC-BA0007---------
   #MOD-B20090---mark---start---
   #將此段移到AFTER INPUT裡
   IF cl_sure(18,20)THEN     #TQC-BA0007
      LET l_where = NULL
      FOR i = 1 TO g_rec_b
          LET l_ac = i
          BEGIN WORK   #TQC-BA0007
          LET g_success = 'Y'
          IF p701_t2() THEN
               LET g_success='N'
          END IF
          #CALL s_showmsg()     #No.FUN-710025   #TQC-BA0007 mark
          IF g_success = 'Y' THEN
            CALL cl_cmmsg(4)  
           #IF g_imy[l_ac].imy16 !=g_imy[l_ac].ims06 THEN                           #MOD-AB0007 mark
            #IF g_imy[l_ac].imy16 + g_imy[l_ac].imn23 != g_imy[l_ac].ims06 THEN      #MOD-AB0007 add   #TQC-BA0007
            IF g_imy[l_ac].invqty + g_imy[l_ac].imn23 != g_imy[l_ac].imn11 THEN      #MOD-AB0007 add   #TQC-BA0007
               IF cl_null(l_where) THEN 
                  LET l_where = " imy02 IN(",g_imy[l_ac].imy02 
               ELSE
                  LET l_where = l_where CLIPPED, ",",g_imy[l_ac].imy02
               END IF
            END IF
            COMMIT WORK   #TQC-BA0007
          ELSE 
             #CHI-D10014---begin 
               IF NOT s_del_rvbs('1',g_imy01,g_imy[l_ac].imy02,0)  THEN       
                  RETURN
               END IF
               IF NOT s_del_rvbs('2',g_imy01,g_imy[l_ac].imy02,0)  THEN       
                  RETURN
               END IF
             #CHI-D10014---END
            CALL cl_rbmsg(4)  ROLLBACK WORK
          END IF
          CALL p701_free()       
      END FOR
   #CHI-D10014---begin
   ELSE 
      FOR g_i = 1 TO g_rec_b
         IF NOT s_del_rvbs('2',g_imy01,g_imy[g_i].imy02,0)  THEN       
            RETURN
         END IF
      END FOR
   #CHI-D10014---END
   END IF   #TQC-BA0007
   #MOD-B20090---mark---end--- 
   #-----END TQC-BA0007-----

   #CLOSE p701_bcl   #TQC-BA0007
   #COMMIT WORK      #TQC-BA0007
 
    IF NOT cl_null(l_where) THEN
      LET l_where = l_where CLIPPED,")"
      CALL cl_getmsg('mfg3487',g_lang) RETURNING l_str
      LET l_pmt = cl_prompt(16,11,l_str)
      IF l_pmt = 1 THEN
            LET l_cmd = "aimp702 ","'",g_imn041,"'", #撥出工廠
                              " '",g_imy01,"'",  #撥入單號
                              " '' ",            #撥入項次
                              " '' ",            #撥出單號
                              " '' ",            #撥出項次
                              " '' ",            #調撥單號
                              " '' ",            #調撥項次
                              " '' ",            #實撥出
                              " '' ",            #實收入
                              " '", l_where CLIPPED , "'"
            CALL cl_cmdrun_wait(l_cmd)  
      END IF
    END IF 
END FUNCTION
 
FUNCTION p701_i()
 DEFINE l_n,l_sw  LIKE type_file.num5,   #No.FUN-690026 SMALLINT
        b_date    LIKE type_file.dat,    #No.FUN-690026 DATE
        e_date    LIKE type_file.dat,    #No.FUN-690026 DATE
        l_cmd     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
 DEFINE li_result LIKE type_file.num5    #No.FUN-690026 SMALLINT
 DEFINE l_imm14   LIKE imm_file.imm14    #FUN-670093
    
      CALL s_azn01(g_sma.sma51,g_sma.sma52) RETURNING b_date,e_date
     LET g_imy03 = ''
     LET g_imy04 = ''
     LET g_imy05 = ''
     LET g_imy06 = ''
      INPUT  g_imy01,g_imy03,g_imy05,g_imy19,g_imy20
               WITHOUT DEFAULTS
           FROM imy01,imy03,imy05,imy19,imy20
 
       ON ACTION locale
          #ROLLBACK WORK   #TQC-BA0007
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_dynamic_locale()
           CALL p701_mu_ui()   #FUN-610067
           LET g_action_choice='locale'
           EXIT INPUT
 
 
 
        AFTER FIELD imy01   #撥入單號
            IF g_imy01 = '   -' OR g_imy01 IS NULL            #FUN-770057
            THEN LET g_imy01=' '      #FUN-770057
				 NEXT FIELD imy01
            END IF
            IF g_imy01 IS NOT NULL THEN          #FUN-770057
	       IF g_imy01_t IS NULL OR g_imy01 != g_imy01_t THEN        #FUN-770057
             CALL  s_check_no("aim",g_imy01,"","H","","","")       #No.FUN-540059
                   RETURNING li_result,g_imy01
             DISPLAY  g_imy01 TO imy01
             IF (NOT li_result) THEN
                  NEXT FIELD imy01
             END IF
            CALL  s_auto_assign_no("aim",g_imy01,g_imy19,"H","imy_file","imy01",  
                  "","","")
                  RETURNING li_result,g_imy01
            IF (NOT li_result) THEN
                NEXT FIELD imy01
            END IF
       	    END IF
 
 
               SELECT count(*) INTO l_n FROM imy_file
                   WHERE imy01 = g_imy01       #FUN-770057
               IF l_n > 0 THEN   #單據編號重複
                   CALL cl_err(g_imy01,-239,0)
                   LET g_imy01 = g_imy01_t
                   DISPLAY BY NAME g_imy01
                   NEXT FIELD imy01
               END IF
           END IF
 
        AFTER FIELD imy03   #撥出單號
            IF g_imy03 IS NULL OR g_imy03 = ' '            #FUN-770057
            THEN NEXT FIELD imy03
            ELSE SELECT count(*) INTO l_n
                                 FROM ims_file
                     WHERE ims01 = g_imy03   #撥出單號        #FUN-770057
                       AND ims09 = g_plant       #撥出工廠
                 IF l_n = 0 OR l_n = ' ' THEN
                     CALL cl_err(g_imy03,'mfg3477',0)
                     LET g_imy03 = g_imy03_o
                     DISPLAY g_imy03 TO imy03
                     NEXT FIELD imy03
                 END IF
                 IF g_sma.sma88 = 'Y' THEN
                    LET g_imy05 = g_imy03
                    DISPLAY g_imy05 TO imy05
                 END IF
            END IF
            LET g_imy03_o = g_imy03              #FUN-770057
            SELECT imm14 INTO l_imm14 FROM imm_file
                                     WHERE imm01=g_imy05        #FUN-770057
            IF SQLCA.sqlcode THEN
               LET l_imm14=NULL
            END IF
            DISPLAY l_imm14 TO FORMONLY.imm14
            DISPLAY s_costcenter_desc(l_imm14) TO FORMONLY.gem02
            #CHI-D10014---begin
            IF NOT cl_null(g_imy05) THEN
               CALL cl_set_comp_entry("imy05",FALSE)
            END IF 
            IF cl_null(g_imy03) THEN
               CALL cl_set_comp_entry("imy05",TRUE)
            END IF 
            #CHI-D10014---end
            
        BEFORE FIELD imy05   #撥出單號
            IF g_sma.sma88 = 'Y' THEN
               EXIT INPUT
            END IF
        AFTER FIELD imy05   #調撥單號
            IF g_imy05 IS NULL OR g_imy05 = ' '            #FUN-770057
            THEN NEXT FIELD imy05
            ELSE SELECT count(*) INTO l_n FROM ims_file
                     WHERE ims01 = g_imy03   #撥出單號
                       AND ims03 = g_imy05   #調撥單號
                       AND ims09 = g_plant       #撥出工廠
                 IF l_n = 0 OR l_n = ' ' THEN
                     CALL cl_err(g_imy05,'mfg3477',0)
                     LET g_imy05 = g_imy05_o
                     DISPLAY g_imy05 TO imy05
                     NEXT FIELD imy05
                 END IF
                 SELECT imm14 INTO l_imm14 FROM imm_file
                                          WHERE imm01=g_imy05        #FUN-770057
                 IF SQLCA.sqlcode THEN
                    LET l_imm14=NULL
                 END IF
                 DISPLAY l_imm14 TO FORMONLY.imm14
                 DISPLAY s_costcenter_desc(l_imm14) TO FORMONLY.gem02
            END IF
		AFTER FIELD imy19
            		
           IF cl_null(g_imy19) THEN NEXT FIELD imy19 END IF       #FUN-770057           
		   IF g_sma.sma53 IS NOT NULL AND g_imy19 <= g_sma.sma53 THEN        #FUN-770057
				CALL cl_err('','mfg9999',0) NEXT FIELD imy19
		   END IF
           IF g_imy19 > e_date THEN NEXT FIELD imy19 END IF       #FUN-770057
 
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imy01) #單別
                  LET g_t1=s_get_doc_no(g_imy01)                        #FUN-770057
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','H') RETURNING g_t1 #TQC-670008
                  LET g_imy01=g_t1                                    #FUN-770057
                  DISPLAY g_imy01 TO imy01      #FUN-770057
                  NEXT FIELD imy01
               WHEN INFIELD(imy03) #撥出單號
                  CALL q_ims(FALSE,TRUE,g_imy03,g_imy04,
                                        g_imy05,g_plant)
                       RETURNING g_imy03,g_imy04,
                                 g_imy05,g_imy06
                  DISPLAY  g_imy03 TO imy03
                  DISPLAY  g_imy05 TO imy05
                  
                  NEXT FIELD imy03
               WHEN INFIELD(imy05) #調撥單號
                  CALL q_ims(FALSE,TRUE,g_imy03,g_imy04,
                                        g_imy05,g_plant)
                       RETURNING g_imy03,g_imy04,g_imy05,g_imy06
                  DISPLAY g_imy03 TO imy03
                  #DISPLAY g_imy04 TO imy04 #TQC-DB0036 mark
                  DISPLAY g_imy05 TO imy05
                  #DISPLAY g_imy06 TO imy06 #TQC-DB0036 mark
                  NEXT FIELD imy05
               OTHERWISE EXIT CASE
            END CASE
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        AFTER INPUT
            IF INT_FLAG THEN RETURN END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION
 
FUNCTION p701_imy20()  #確認人員
    DEFINE l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_imy20        #FUN-770057
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION p701_imy04()  #撥出項次
 DEFINE  l_ima02  LIKE ima_file.ima02,
         l_ima05  LIKE ima_file.ima05,
         l_ima08  LIKE ima_file.ima08,
#        l_ima262  LIKE ima_file.ima262     #FUN-A20044 
         l_avl_stk LIKE type_file.num15_3   #FUN-A20044
DEFINE   l_sql     STRING                   #CHI-D10014

       LET g_chr = ' '
 
#---->讀撥出單單身檔(LOCK 此筆資料)
        IF STATUS THEN CALL cl_err('OPEN ims_lock',STATUS,1) 
            RETURN
        END IF
       OPEN ims_lock USING g_imy03,g_imy[l_ac].imy04   #FUN-770057
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3478'
               LET g_chr='L'
           ELSE
               LET g_errno = 'mfg3474'
               LET g_chr='E'
           END IF
           RETURN
       END IF
       FETCH ims_lock
           INTO g_ims.*
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3478'
               LET g_chr='L'
           ELSE
               LET g_errno = 'mfg3474'
               LET g_chr='E'
           END IF
           RETURN
       END IF
       LET g_imy[l_ac].imy06 = g_ims.ims04 #調撥項次   #FUN-770057
       LET g_imy[l_ac].ims06 = g_ims.ims06
       LET g_imy[l_ac].ims14 = g_ims.ims14
       LET g_imy[l_ac].ims15 = g_ims.ims15
#---->讀取調撥單單身檔(LOCK 此筆資料)
     IF STATUS THEN CALL cl_err('OPEN imn_lock',STATUS,1) 
         RETURN
     END IF
       OPEN imn_lock USING g_imy05,g_imy[l_ac].imy06   #FUN-770057
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3463'
               LET g_chr='L'
           ELSE
               LET g_errno = 'mfg3464'
               LET g_chr='E'
           END IF
           RETURN
       END IF
       FETCH imn_lock
           INTO  g_imn.imn09, g_imn.imn10,g_imn.imn11,
                g_imn.imn041,g_imn.imn23, g_imn.imn151,
                g_img[l_ac].img02,g_img[l_ac].img03,g_img[l_ac].img04,g_img[l_ac].img09,
                g_imn.imn33,g_imn.imn35,g_imn.imn30,g_imn.imn32,
                g_imn.imn43,g_imn.imn45,g_imn.imn40,g_imn.imn42,
                g_imn.imn9302 #FUN-670093
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3463'
               LET g_chr='L'
           ELSE
               LET g_errno = 'mfg3464'
               LET g_chr='E'
           END IF
           RETURN
       END IF
 
#---->讀取料件主檔(LOCK 此筆資料)
       OPEN ima_lock USING g_ims.ims05
        IF STATUS THEN CALL cl_err('OPEN ima_lock',STATUS,1) 
            RETURN
        END IF
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3467'
               LET g_chr='L'
           END IF
           RETURN
       END IF
       FETCH ima_lock
           INTO  l_ima02, l_ima05, l_ima08,
                g_ima25  #,g_ima86  ###,g_ima100 #FUN-560183
       IF SQLCA.sqlcode THEN
           #---->已被別的使用者鎖住
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_errno = 'mfg3467'
               LET g_chr='L'
           END IF
#CHI-A90045 --begin--
           IF SQLCA.sqlcode = 100 THEN 
              LET g_errno = 'aim-396'
              LET g_chr = 'L'
           END IF 
#CHI-A90045 --end--           
           RETURN
       END IF
     
       LET g_img[l_ac].img01 = g_ims.ims05      #料件編號
       LET g_imy[l_ac].imy17 = g_imn.imn09      #會計編號   #FUN-770057
      
       LET g_imy[l_ac].img01 = g_ims.ims05      #料件編號
       LET g_imy[l_ac].imy17 = g_imn.imn09      #會計編號
       LET g_imy[l_ac].imn10 = g_imn.imn10
       LET g_imy[l_ac].imn11 = g_imn.imn11
       LET g_imy[l_ac].imn23 = g_imn.imn23
       LET g_imy[l_ac].imn33 = g_imn.imn33
       LET g_imy[l_ac].imn30 = g_imn.imn30
       LET g_imy[l_ac].imn9302 = g_imn.imn9302 
       LET g_imy[l_ac].gem02c = s_costcenter_desc(g_imn.imn9302) 
       LET g_imn041 = g_imn.imn041
       LET g_imn151 = g_imn.imn151
       LET g_imy[l_ac].img01 = g_img[l_ac].img01
       LET g_imy[l_ac].img02 = g_img[l_ac].img02
       LET g_imy[l_ac].img03 = g_img[l_ac].img03
       LET g_imy[l_ac].img04 = g_img[l_ac].img04
       LET g_imy[l_ac].img09 = g_img[l_ac].img09
       LET g_imy[l_ac].img19 = g_img[l_ac].img19
       LET g_imy[l_ac].img26 = g_img[l_ac].img26
       LET g_imy[l_ac].img35 = g_img[l_ac].img35
       LET g_imy[l_ac].img36 = g_img[l_ac].img36
       DISPLAY BY NAME g_imy[l_ac].img01, 
                       g_imy[l_ac].imy17, 
                       g_imy[l_ac].imn10, 
                       g_imy[l_ac].imn11, 
                       g_imy[l_ac].imn23, 
                       g_imy[l_ac].img02,  
                       g_imy[l_ac].img03,  
                       g_imy[l_ac].img04, 
                       g_imy[l_ac].img09, 
                       g_imy[l_ac].imn33, 
                       g_imy[l_ac].imn30, 
                       g_imy[l_ac].imn9302,
                       g_imy[l_ac].gem02c 
 
       IF g_sma.sma115='Y' THEN
          SELECT ima906,ima907 INTO g_ima906,g_ima907
            FROM ima_file WHERE ima01=g_imy[l_ac].img01
          LET g_imy[l_ac].imy24=g_imn.imn40
          LET g_imy[l_ac].imy25=g_imn.imn42
          CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy24,g_imy[l_ac].img09)
               RETURNING g_sw,g_imy31
          IF cl_null(g_imy31) THEN LET g_imy31=1 END IF
          CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy27,g_imy[l_ac].img09)
               RETURNING g_sw,g_imy32
          IF cl_null(g_imy32) THEN LET g_imy32=1 END IF
          LET g_imy[l_ac].imy27=g_imn.imn43
          LET g_imy[l_ac].imy28=g_imn.imn45
          DISPLAY BY NAME g_imy[l_ac].imn33, g_imy[l_ac].imn30, g_imy[l_ac].ims14,
                          g_imy[l_ac].ims15, g_imy[l_ac].imy24, g_imy[l_ac].imy27,
                          g_imy[l_ac].imy25, g_imy[l_ac].imy28
       END IF
 
       CALL p701_plantnam(g_imn.imn041)
       LET g_imy[l_ac].ima02 =  l_ima02 
       LET g_imy[l_ac].ima05 =  l_ima05 
       LET g_imy[l_ac].ima08 =  l_ima08 
       DISPLAY BY NAME g_imy[l_ac].ima02, 
                       g_imy[l_ac].ima05, 
                       g_imy[l_ac].ima08 
       #CHI-D10014---begin
       IF NOT cl_null(g_imy[l_ac].imy04) THEN 
          IF g_imy[l_ac].imy02 IS NULL OR g_imy[l_ac].imy02 = 0
             OR g_imy02_t IS NULL OR g_imy02_t = ' '
          THEN 
             LET g_imy[l_ac].imy02=g_imy[l_ac].imy04
             DISPLAY BY NAME g_imy[l_ac].imy02
          END IF
          DELETE FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = g_imy01
            AND rvbs02 = g_imy[l_ac].imy02
          LET l_sql = "INSERT INTO rvbs_file ",
                      " (rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                      "  rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal) ",      
                      " SELECT '",g_prog,"','",g_imy01,"',",g_imy[l_ac].imy02,  
                      "   ,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                      "        rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,'",g_plant,"','",g_legal,"'", 
                      "   FROM ",cl_get_target_table(g_plant_new,'rvbs_file'),   
                      "  WHERE rvbs00 = 'aimp700' ",
                      "    AND rvbs01 = ? ",
                      "    AND rvbs02 = ? ",
                      "    AND rvbs09 = 1 "
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
          PREPARE rvbs_p1 FROM l_sql
          EXECUTE rvbs_p1 USING g_imy03,g_imy[l_ac].imy04
          IF STATUS THEN
             CALL cl_err('',STATUS,0)
          END IF 
       END IF   
       #CHI-D10014---end  
END FUNCTION
 
FUNCTION p701_plantnam(p_plant)
    DEFINE p_plant LIKE imn_file.imn151,
           l_azp02 LIKE azp_file.azp02,
           l_azp03 LIKE azp_file.azp03
 
    LET g_errno = ' '
 	SELECT azp02,azp03 INTO l_azp02,l_azp03 FROM azp_file
         		WHERE azp01 = p_plant
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                            LET l_azp02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_azp02 TO imn041
       LET g_dbs_new = s_dbstring(l_azp03)         #TQC-950003 ADD   
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
    END IF
END FUNCTION
 
FUNCTION p701_img04()
  DEFINE  l_desc   LIKE ze_file.ze03   #No.FUN-690026 VARCHAR(26)
 
    LET g_chr=''
    IF g_img[l_ac].img02 IS NULL THEN LET g_img[l_ac].img02=' ' END IF
    IF g_img[l_ac].img03 IS NULL THEN LET g_img[l_ac].img03=' ' END IF
    LET g_img[l_ac].img09 = ' ' LET g_img[l_ac].img35 = ' '
    LET g_img[l_ac].img26 = ' ' LET g_img[l_ac].img19 = ' '
    LET g_img[l_ac].img36 = ' '
   #LET g_imy[l_ac].img02 = g_img[l_ac].img02                    #MOD-AB0009 mark  
   #LET g_imy[l_ac].img03 = g_img[l_ac].img03                    #MOD-AB0009 mark   
    IF g_imy[l_ac].img02 IS NULL THEN LET g_imy[l_ac].img02 = g_img[l_ac].img02 END IF    #No:MOD-AB0009 add 
    IF g_imy[l_ac].img03 IS NULL THEN LET g_imy[l_ac].img03 = g_img[l_ac].img03 END IF    #No:MOD-AB0009 add 
    LET g_imy[l_ac].img09 = g_img[l_ac].img09 
    LET g_imy[l_ac].img35 = g_img[l_ac].img35 
    LET g_imy[l_ac].img26 = g_img[l_ac].img26 
    LET g_imy[l_ac].img19 = g_img[l_ac].img19 
    LET g_imy[l_ac].img36 = g_img[l_ac].img36 
 
    DISPLAY BY NAME g_imy[l_ac].img02, 
                    g_imy[l_ac].img03, 
                    g_imy[l_ac].img09, 
                    g_imy[l_ac].img35, 
                    g_imy[l_ac].img26, 
                    g_imy[l_ac].img19, 
                    g_imy[l_ac].img36 
    LET g_sql=
        "SELECT ' ',img09,img10,img19, ",
        " img23,img24,img26,img35,img36",
        " FROM img_file",
        "   WHERE img01='",g_imy[l_ac].img01,"'"  #FUN-770057
 
    #撥入倉庫
    IF g_imy[l_ac].img02 IS NOT NULL THEN    #FUN-770057
        LET g_sql=g_sql CLIPPED," AND img02='", g_imy[l_ac].img02,"'"   #FUN-770057
    ELSE
        LET g_sql=g_sql CLIPPED," AND img02 IS NULL"
    END IF
    #撥入儲位
    IF g_imy[l_ac].img03 IS NOT NULL THEN                               #FUN-770057
        LET g_sql=g_sql CLIPPED," AND img03='", g_imy[l_ac].img03,"'"   #FUN-770057
    ELSE
        LET g_sql=g_sql CLIPPED," AND img03 IS NULL"
    END IF
    #撥入批號
    IF g_imy[l_ac].img04 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img04='", g_imy[l_ac].img04,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img04 IS NULL"
    END IF
    LET g_sql=g_sql CLIPPED," FOR UPDATE"
    LET g_sql=cl_forupd_sql(g_sql)
 
    PREPARE img_p FROM g_sql
    DECLARE img_lock CURSOR FOR img_p
    OPEN img_lock
       IF SQLCA.sqlcode THEN
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_chr='L'
               RETURN
           ELSE
               LET g_chr='E'
               LET g_imgno='-3333'
           END IF
           LET g_img[l_ac].img10=0
       END IF
    FETCH img_lock
        INTO g_imgno,g_img[l_ac].img09,g_img[l_ac].img10,
                         g_img[l_ac].img19,g_img[l_ac].img23,g_img[l_ac].img24,
                         g_img[l_ac].img26,g_img[l_ac].img35,g_img[l_ac].img36
       IF SQLCA.sqlcode THEN
           IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN  #TQC-930155 add -263
               LET g_chr='L'
               RETURN
           ELSE
               LET g_chr='E'
               LET g_imgno='-3333'
           END IF
           LET g_img[l_ac].img10=0
       END IF
    LET l_desc=' '
    IF g_imgno ='-3333'
       THEN LET l_desc='尚未存在之倉庫/儲位/批號'
       ELSE CALL s_wardesc(g_img[l_ac].img23,g_img[l_ac].img24) RETURNING l_desc
    END IF
    LET g_imy[l_ac].img09 = g_img[l_ac].img09
    LET g_imy[l_ac].img19 = g_img[l_ac].img19
    LET g_imy[l_ac].img26 = g_img[l_ac].img26
    LET g_imy[l_ac].img35 = g_img[l_ac].img35
    LET g_imy[l_ac].img36 = g_img[l_ac].img36
    IF g_imgno='-3333'
       THEN CALL p701_loc()
    END IF
    DISPLAY BY NAME g_imy[l_ac].img09, g_imy[l_ac].img35, g_imy[l_ac].img26,
                    g_imy[l_ac].img19, g_imy[l_ac].img36
    IF g_sma.sma115='Y' THEN
       CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy24,g_imy[l_ac].img09)
            RETURNING g_sw,g_imy31
       IF cl_null(g_imy31) THEN LET g_imy31=1 END IF
       CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy27,g_imy[l_ac].img09)
            RETURNING g_sw,g_imy32
       IF cl_null(g_imy32) THEN LET g_imy32=1 END IF
    END IF
 
    LET g_imy[l_ac].desc = l_desc
    DISPLAY BY NAME g_imy[l_ac].desc
END FUNCTION
 
 
FUNCTION p701_loc()
    #取得儲位性質
    IF g_img[l_ac].img03 IS NOT NULL THEN
        SELECT ime05,ime06
            INTO g_img[l_ac].img23,g_img[l_ac].img24
            FROM ime_file
            WHERE ime01=g_imy[l_ac].img02 AND
                  ime02=g_imy[l_ac].img03
		AND imeacti='Y'  #FUN-D40103 add
            IF SQLCA.sqlcode THEN
               LET g_img[l_ac].img23=' ' LET g_img[l_ac].img24=' '
            END IF
    ELSE
        SELECT imd11,imd12
            INTO g_img[l_ac].img23,g_img[l_ac].img24
            FROM imd_file
            WHERE imd01=g_imy[l_ac].img02  #FUN-770057 
            IF SQLCA.sqlcode THEN
               LET g_img[l_ac].img23=' ' LET g_img[l_ac].img24=' '
            END IF
    END IF
END FUNCTION
 
#更新相關的檔案
FUNCTION p701_t2()
#DEFINE  l_imaqty   LIKE ima_file.ima26,   #No.FUN-A20044
 DEFINE  l_imaqty   LIKE type_file.num15_3,#No.FUN-A20044
         l_sql      LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 DEFINE  l_legal    LIKE azw_file.azw02   #FUN-980004 add 
 DEFINE  l_plant    LIKE azp_file.azp01   #FUN-980004 add 
 
    IF g_imy[l_ac].imy16 IS NULL  THEN
       LET g_success='N'
       CALL cl_err('(p701_t:ckp#0.1)','mfg9170',1)
       RETURN 1
    END IF
 
    LET l_plant = g_imn.imn041  #FUN-980004 add
    LET g_plant_new = g_imn041  #CHI-D10014
#---->{ckp#1}產生一筆撥入單單身檔
      INSERT INTO imy_file(imy01,imy02,imy03,imy04,imy05,imy06,
                           imy07,imy08,imy09, imy10,imy11,imy12,
                           imy13,imy14, imy15,imy16,
                           imy17,imy18,imy19,imy20,imy24,imy25,imy26,
                           imy27,imy28,imy29,imyplant,imylegal) #FUN-980004 add imyplant,imylegal
                    VALUES(g_imy01,g_imy[l_ac].imy02,  #撥入單號/撥入項次
                           g_imy03,g_imy[l_ac].imy04,  #撥出單號/撥入項次
                           g_imy05,g_imy[l_ac].imy06,  #調撥單號/調撥項次
                           g_imy[l_ac].img02,              #撥入倉庫
                           g_imy[l_ac].img03,              #儲位
                           g_imy[l_ac].img04,              #批號
                           g_imy[l_ac].img26,              #會計科目
                           g_imy[l_ac].img35,              #專案號碼
                           g_imy[l_ac].img09,              #庫存單位
                           g_imy[l_ac].img19,              #庫存等級
                           g_imy[l_ac].img36,              #外觀代號
                           g_imy[l_ac].img01,              #料件編號
                           g_imy[l_ac].imy16,              #實收數量
                           g_imy[l_ac].imy17,              #實收單位
                           g_imy[l_ac].imy18,              #撥出/撥入轉換率
                           g_imy19,              #確認日期
                           g_imy20,              #確認人員
                           g_imy[l_ac].imy24,
                           g_imy[l_ac].imy25,
                           g_imy[l_ac].imy26,
                           g_imy[l_ac].imy27,
                           g_imy[l_ac].imy28,
                           g_imy[l_ac].imy29,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","imy_file",g_imy01,"","mfg3480",
                      "","(p701_t:ckp#1)",1)  #No.FUN-660156
         LET g_success ='N'
         RETURN 1
      END IF
 
      #---->{ckp#2.2}產生一筆撥出廠撥入單單身檔
        #FUN-A50102--mod--str--
        #LET l_sql = "INSERT INTO ",g_dbs_tra CLIPPED, #FUN-980092  
        #            " imy_file(imy01,imy02,imy03,imy04,imy05,imy06,",
         LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'imy_file'),
                     "(imy01,imy02,imy03,imy04,imy05,imy06,",
        #FUN-A50102--mod--end
                     " imy07,imy08,imy09,imy10,imy11,imy12,imy13,imy14,",
                     " imy15,imy16,imy17,imy18,imy19,imy20,imy24,imy25,", #No.FUN-570249
                     " imy26,imy27,imy28,imy29,imyplant,imylegal)",                         #No.FUN-570249 ##FUN-980004 add imyplant,imylegal
                     " VALUES( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?)" #No.FUN-570249 #FUN-980004 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
         CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980004 add 
         PREPARE imy_cur FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('imy_cur',SQLCA.sqlcode,0)
            LET g_success ='N'
            RETURN 1
         END IF
         EXECUTE imy_cur USING g_imy01,g_imy[l_ac].imy02,
                               g_imy03,g_imy[l_ac].imy04,
                               g_imy05,g_imy[l_ac].imy06,
                               g_imy[l_ac].img02,g_imy[l_ac].img03,
                               g_imy[l_ac].img04,g_imy[l_ac].img26,
                               g_imy[l_ac].img35,g_imy[l_ac].img09,
                               g_imy[l_ac].img19,g_imy[l_ac].img36,
                               g_imy[l_ac].img01,g_imy[l_ac].imy16,
                               g_imy[l_ac].imy17,g_imy[l_ac].imy18,
                               g_imy19,g_imy20,      
                               g_imy[l_ac].imy24,g_imy[l_ac].imy25,      #No.FUN-570249
                               g_imy[l_ac].imy26,g_imy[l_ac].imy27,      #No.FUN-570249
                               g_imy[l_ac].imy28,g_imy[l_ac].imy29,      #No.FUN-570249
                               l_plant,l_legal   #FUN-980004 add
          IF SQLCA.sqlcode THEN
             CALL cl_err('(p701_t:ckp#2.2)','mfg3480',1)
             LET g_success ='N'
             RETURN 1
          END IF
      #CHI-D10014---begin
      LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'rvbs_file'), 
                  " (rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                  "  rvbs021,rvbs022,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,rvbsplant,rvbslegal) ",
                  " SELECT rvbs00,rvbs01,rvbs02,rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,rvbs08, ",
                  "        rvbs021,rvbs022,-1,rvbs10,rvbs11,rvbs12,rvbs13,'",l_plant,"','",l_legal,"'",      
                  "   FROM rvbs_file ",
                  "  WHERE rvbs00 = 'aimp701' ",
                  "    AND rvbs01 = ? ",
                  "    AND rvbs02 = ? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  
      PREPARE rvbs_cur FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('rvbs_cur',SQLCA.sqlcode,0)
      END IF
      
      
      EXECUTE rvbs_cur USING g_imy01,g_imy[l_ac].imy02
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         RETURN 1
      END IF 
      #CHI-D10014---end
#---->{ckp#3}更新撥出廠中的撥出單資料確認
      UPDATE ims_file SET ims07 =ims07 + g_imy[l_ac].imy16
                    WHERE ims01= g_imy03
                      AND ims02= g_imy[l_ac].imy04
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
         CALL cl_err3("upd","ims_file","","","mfg3483",
                      "","(p701_t:ckp#3)",1)  #No.FUN-660156
         LET g_success = 'N'
         RETURN 1
      END IF
 
      #---->{ckp#3.2}更新撥出廠中的撥出單單身確認碼
      #LET l_sql = "UPDATE ",g_dbs_tra CLIPPED,"ims_file", #FUN-980092  #FUN-A50102
       LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'ims_file'),  #FUN-A50102
                   " SET ims07 = ims07 + ? ",
                   " WHERE ims01='",g_imy03,"' AND ",
                   "       ims02='",g_imy[l_ac].imy04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE ims_cur FROM l_sql
       IF SQLCA.sqlcode THEN
          CALL cl_err('ims_cur',SQLCA.sqlcode,0)
          LET g_success = 'N'
          RETURN 1
       END IF
       EXECUTE ims_cur  USING g_imy[l_ac].imy16
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ims_cur:ckp#3.2',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN 1
        END IF
 
#---->{ckp#4}更新撥入調撥單單身檔
      UPDATE imn_file SET imn23 = imn23 + g_imy[l_ac].imy16,   #實撥入量
                          imn15 = g_imy[l_ac].img02,           #倉庫
                          imn16 = g_imy[l_ac].img03,           #儲位
                          imn17 = g_imy[l_ac].img04,           #批號
                          imn18 = g_imy[l_ac].img26,           #會計科目
                          imn19 = g_imy[l_ac].img35,           #專案號碼
                          imn20 = g_imy[l_ac].img09,           #庫存單位
                          imn201= g_imy[l_ac].img19,           #庫存等級
                          imn202= g_imy[l_ac].img36,           #外觀代號   #MOD-BC0029 add ,
                          imn25 = g_imy20                      #MOD-BC002
                    WHERE imn01 = g_imy05 
                      AND imn02 = g_imy[l_ac].imy06
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","imn_file","","","mfg3462",
                      "","(p701_t:ckp#4)",1)  #No.FUN-660156
         LET g_success ='N'
         RETURN 1
      END IF
 
      #---->{ckp#4.2}更新撥出廠中的調撥單單身
          #LET l_sql = "UPDATE ",g_dbs_tra CLIPPED,"imn_file", #FUN-980092 #FUN-A50102
           LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'imn_file'),  #FUN-A50102
                       " SET imn23  = imn23 + ?, ",  
                       "     imn15  = ?,  imn16 = ?, ",
                       "     imn17  = ?,  imn18 = ?, ",
                       "     imn19  = ?,  imn20 = ?, ",
                       "     imn201 = ?, imn202 = ?  ",
                       " WHERE imn01='",g_imy05,"' AND ",
                       "       imn02='",g_imy[l_ac].imy06,"'"
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
           PREPARE imn_cur FROM l_sql
           IF SQLCA.sqlcode THEN
              CALL cl_err('imn_cur',SQLCA.sqlcode,0)
           END IF
           EXECUTE imn_cur  USING g_imy[l_ac].imy16, 
                                  g_imy[l_ac].img02, g_imy[l_ac].img03,
                                  g_imy[l_ac].img04, g_imy[l_ac].img26,
                                  g_imy[l_ac].img35, g_imy[l_ac].img09,
                                  g_imy[l_ac].img19, g_imy[l_ac].img36
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err('(p701_t:ckp#4.2)','mfg3462',1)
              LET g_success ='N'
              RETURN 1
           END IF
    IF g_img[l_ac].img21 IS NULL THEN LET g_img[l_ac].img21 = 1 END IF
    IF g_img[l_ac].img34 IS NULL THEN LET g_img[l_ac].img34 = 1 END IF
    IF g_imy[l_ac].imy18 IS NULL THEN LET g_imy[l_ac].imy18 = 1 END IF
#---->更新庫存明細檔
#CHI-A90045 --begin--
#    CALL s_upimg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,+1,g_imy[l_ac].invqty,g_imy19,#FUN-8C0084
##       5           6           7           8           9
#        g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,g_imy01,
##       10 11          12          13
#        '',g_imy[l_ac].imy17,g_imy[l_ac].imy16,g_imy[l_ac].img09,
##       14          15          16
#        g_imy[l_ac].imy18,g_img[l_ac].img21,g_img[l_ac].img34,
##       17          18          19           20            21
#        g_imy[l_ac].img26,g_imy[l_ac].img35,g_img[l_ac].img27,g_img[l_ac].img28,g_imy[l_ac].img19,
##       22
#        g_imy[l_ac].img36)

    LET l_sql = "SELECT imm08,imn05,imn06 FROM ",
                 cl_get_target_table(g_plant_new,'imm_file'),
                 ",",
                 cl_get_target_table(g_plant_new,'imn_file'),                                   
                 " WHERE imm01 = imn01",
                 "   AND imn01 = '",g_imy05,"'",
                 "   AND imn02 = '",g_imy[l_ac].imy06,"'"     
   PREPARE wip_pb FROM l_sql
   DECLARE wip_cs CURSOR FOR wip_pb    
   FOREACH wip_cs INTO g_imm08,g_imn05,g_imn06 END FOREACH 
   IF cl_null(g_imm08) THEN LET g_imm08 = ' ' END IF 
   IF cl_null(g_imn05) THEN LET g_imn05 = ' ' END IF 
   IF cl_null(g_imn06) THEN LET g_imn06 = ' ' END IF                   
 
    LET l_sql = "SELECT img10 FROM ",cl_get_target_table(g_plant_new,'img_file'),                                 
                 " WHERE img01 = '",g_imy[l_ac].img01,"'",
                 "   AND img02 = '",g_imm08,"'",
                 "   AND img03 = '",g_imn05,"'",
                 "   AND img04 = '",g_imn06,"'"
   PREPARE wip_pb_1 FROM l_sql
   DECLARE wip_cs_1 CURSOR FOR wip_pb_1    
   FOREACH wip_cs_1 INTO g_img10 END FOREACH 
   IF cl_null(g_img10) THEN LET g_img10 = 0 END IF 
   IF g_img10 < g_imy[l_ac].imy16 THEN 
      CALL cl_err('','aim-361',1)
      LET g_success = 'N' 
      RETURN 1 
   END IF    
      
    CALL s_upimg1(g_imy[l_ac].img01,g_imm08,g_imn05,g_imn06,   
         -1,g_imy[l_ac].invqty,g_imy19,           #+1->-1     
          g_imy[l_ac].img01,g_imm08,g_imn05,g_imn06,   
          #g_imy01,'',g_imy[l_ac].imy17,g_imy[l_ac].imy16,g_imy[l_ac].img09,  #CHI-D10014
          g_imy01,g_imy[l_ac].imy02,g_imy[l_ac].imy17,g_imy[l_ac].imy16,g_imy[l_ac].img09, #CHI-D10014
          g_imy[l_ac].imy18,g_img[l_ac].img21,g_img[l_ac].img34,g_imy[l_ac].img26,
          g_imy[l_ac].img35,g_img[l_ac].img27,g_img[l_ac].img28,g_imy[l_ac].img19,
          g_imy[l_ac].img36,g_plant_new)  
                              
#CHI-A90045 --end--        
       IF g_success = 'N' THEN RETURN 1 END IF
#--->更新料件基本資料(ima_file)
    LET l_imaqty =  g_imy[l_ac].imy16 * g_img[l_ac].img21
#CHI-A90045 --begin--    
#    IF s_udima(g_imy[l_ac].img01,                 #料件編號
#	       g_img[l_ac].img23,                 #是否可用倉儲
#	       g_img[l_ac].img24,                 #是否為MRP可用倉儲
#	       l_imaqty,                    #收料數量(換算為庫存單位)
#	       g_imy[l_ac].imy02,                 #最近一次收料日期
#               +1)                          #表收料

    IF s_udima1(g_imy[l_ac].img01,                 #料件編號
	       g_img[l_ac].img23,                 #是否可用倉儲
	       g_img[l_ac].img24,                 #是否為MRP可用倉儲
	       l_imaqty,                    #收料數量(換算為庫存單位)
	       g_imy[l_ac].imy02,                 #最近一次收料日期
          +1,g_plant_new)                          #表收料
#CHI-A90045 --end--               
         THEN RETURN  1 END IF
    IF g_success = 'N' THEN RETURN 1 END IF
    
#TQC-AC0053--begin
    CALL s_upimg(g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,1,
         g_imy[l_ac].imy16,g_imy19,
         g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,
         g_imy01,g_imy[l_ac].imy02,g_imy[l_ac].imy17,g_imy[l_ac].imy16,g_imy[l_ac].img09,
         g_imy[l_ac].imy18,g_img[l_ac].img21,g_img[l_ac].img34,g_imy[l_ac].img26,
         g_imy[l_ac].img35,g_img[l_ac].img27,g_img[l_ac].img28,g_imy[l_ac].img19,
         g_imy[l_ac].img36)
    IF g_success = 'N' THEN RETURN 1 END IF
#TQC-AC0053--end          
 
      IF g_sma.sma115='Y' THEN
         CALL p701_update_du2()
      END IF
      IF g_success='N' THEN RETURN 1 END IF
 
#產生異動記錄資料
    CALL p701_free()
    CALL p701_log(1,0,'',g_imy[l_ac].img01)
    
    IF g_success = 'N' THEN RETURN 1 END IF
 
	RETURN 0
END FUNCTION
 
#---->將已鎖住之資料釋放出來
FUNCTION p701_free()
{*} IF g_sma.sma12='N' THEN
        CLOSE img_lock
    END IF
    CLOSE ims_lock
    CLOSE imn_lock
    CLOSE ima_lock
END FUNCTION
 
#處理異動記錄
FUNCTION p701_log(p_stdc,p_reason,p_code,p_item)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,   #採購單性質
    p_stdc          LIKE type_file.num5,   #是否需取得標準成本#No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,   #是否需取得異動原因#No.FUN-690026 SMALLINT
    p_code          LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(04)
    p_item          LIKE tlf_file.tlf01    #NO.MOD-490217
 
#----來源----
    LET g_tlf.tlf01=p_item      	 #異動料件編號
#   LET g_tlf.tlf02=57         	     #倉庫    #CHI-A90045 
    LET g_tlf.tlf02=50         	     #倉庫    #CHI-A90045       
    LET g_tlf.tlf020=g_imn.imn041    #工廠別
    LET g_tlf.tlf021=g_imm08           	 #倉庫別  #CHI-A90045 ''->g_imm08
    LET g_tlf.tlf022=g_imn05              #儲位別 #CHI-A90045 ''->g_imn05 
    LET g_tlf.tlf023=g_imn06              #批號   #CHI-A90045 ''->g_imn06
    LET g_tlf.tlf024=''          	 #異動後庫存數量
	  LET g_tlf.tlf025=''              #庫存單位(ima_file or img_file)
  	LET g_tlf.tlf026=g_imy03     #撥出單號
  	LET g_tlf.tlf027=g_imy[l_ac].imy04     #撥出項次
#----目的----
#    LET g_tlf.tlf03=50         	 	 #資料來源為倉庫 #CHI-A90045 
     LET g_tlf.tlf03=57         	 	 #資料來源為倉庫 #CHI-A90045 
    LET g_tlf.tlf030=g_imn.imn151    #工廠別
    LET g_tlf.tlf031=g_imy[l_ac].img02  	 #倉庫別
    LET g_tlf.tlf032=g_imy[l_ac].img03  	 #儲位別
    LET g_tlf.tlf033=g_imy[l_ac].img04  	 #批號
    LET g_tlf.tlf034=g_img[l_ac].img10+g_imy[l_ac].imy16 #異動後庫存數量
    LET g_tlf.tlf035=g_imy[l_ac].imy17  	 #庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=g_imy01     #撥入單號
    LET g_tlf.tlf037=g_imy[l_ac].imy02     #撥入項次
#--->異動數量
    LET g_tlf.tlf04=' '              #工作站
    LET g_tlf.tlf05=' '              #作業序號
    LET g_tlf.tlf06=g_imy19      #撥入確認日期       #FUN-770057
    LET g_tlf.tlf07=g_today
    LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user           #產生人
    LET g_tlf.tlf10=g_imy[l_ac].imy16      #調撥數量
    LET g_tlf.tlf11=g_imy[l_ac].imy17      #調撥單位
	LET g_tlf.tlf12=1                #撥出/撥入轉換率
	LET g_tlf.tlf13='aimp701'        #異動命令代號
	LET g_tlf.tlf14=''               #異動原因
	LET g_tlf.tlf15=g_imy[l_ac].img26 #借方會計科目   #FUN-770057
    LET g_tlf.tlf16=''               #貸方會計科目
	LET g_tlf.tlf17=''               #非庫存性料件編號
    CALL s_imaQOH(p_item)
         RETURNING g_tlf.tlf18       #異動後總庫存量
	LET g_tlf.tlf19= ''              #異動廠商/客戶編號
	LET g_tlf.tlf20= g_imy[l_ac].img35     #專案號碼   #FUN-770057

#CHI-A90045 --begin--	
#   CALL s_tlf(p_stdc,p_reason)
    CALL s_tlf1(p_stdc,p_reason,g_plant_new)
    #TQC-AC0053--beging
    LET g_tlf.tlf02=57
    LET g_tlf.tlf03=50
    CALL s_tlf(p_stdc,p_reason) 
    #TQC-AC0053--end
#CHI-A90045 --end--
END FUNCTION
 
#檢查密碼
FUNCTION p701_pass()
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
            AFTER FIELD u
                IF g_pass IS NULL THEN NEXT FIELD u END IF
                SELECT azb02
                    INTO l_azb02
                    FROM azb_file
                    WHERE azb01=g_pass
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","azb_file",g_pass,"","aoo-001",
                                "","",0)  #No.FUN-660156
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
               #DISPLAY g_msg AT 1,4  #CHI-A70049 mark
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
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
            
            ON ACTION controlg      
               CALL cl_cmdask()   
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
 
FUNCTION p701_mu_ui()
    CALL cl_set_comp_visible("imn33,imn30,ims14,ims15,imy27,imy28,imy29,imy24,imy25,imy26",g_sma.sma115='Y')
    CALL cl_set_comp_visible("group04,group05",g_sma.sma115='Y')
    CALL cl_set_comp_visible("imy17,imy16,imy18",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-373',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-374',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-375',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ims15",g_msg CLIPPED)
       CALL cl_getmsg('asm-376',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ims14",g_msg CLIPPED)
       CALL cl_getmsg('asm-393',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy27",g_msg CLIPPED)
       CALL cl_getmsg('asm-394',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy24",g_msg CLIPPED)
       CALL cl_getmsg('asm-389',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy29",g_msg CLIPPED)
       CALL cl_getmsg('asm-390',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy26",g_msg CLIPPED)
       CALL cl_getmsg('asm-395',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy28",g_msg CLIPPED)
       CALL cl_getmsg('asm-396',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy25",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-377',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-378',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-379',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ims15",g_msg CLIPPED)
       CALL cl_getmsg('asm-380',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ims14",g_msg CLIPPED)
       CALL cl_getmsg('asm-385',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy27",g_msg CLIPPED)
       CALL cl_getmsg('asm-386',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy24",g_msg CLIPPED)
       CALL cl_getmsg('asm-391',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy29",g_msg CLIPPED)
       CALL cl_getmsg('asm-392',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy26",g_msg CLIPPED)
       CALL cl_getmsg('asm-387',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy28",g_msg CLIPPED)
       CALL cl_getmsg('asm-388',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imy25",g_msg CLIPPED)
    END IF
    IF g_sma.sma115='N' THEN
       CALL cl_set_comp_att_text("imn33,imn30,ims14,ims15,imy27,imy28,imy29,imy24,imy25,imy26,group04,group05",' ')
    ELSE
       CALL cl_set_comp_att_text("imy17,imy16,imy18",' ')
    END IF
    CALL cl_set_comp_visible("imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093
END FUNCTION
 
FUNCTION p701_set_entry_b()
 
    CALL cl_set_comp_entry("imy24,imy25,imy27,imy28",TRUE)
 
END FUNCTION
 
FUNCTION p701_set_no_entry_b()
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("imy27,imy28",FALSE)
    END IF
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("imy27",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION p701_set_required()
 
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("imy24,imy25,imy27,imy28",TRUE)
  END IF
  IF NOT cl_null(g_imy[l_ac].imy24) THEN     #FUN-770057
     CALL cl_set_comp_required("imy25",TRUE)
  END IF
  IF NOT cl_null(g_imy[l_ac].imy27) THEN     #FUN-770057
     CALL cl_set_comp_required("imy28",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION p701_set_no_required()
  CALL cl_set_comp_required("imy24,imy25,imy27,imy28",FALSE)
END FUNCTION
 
FUNCTION p701_update_du2()
DEFINE l_ima25   LIKE ima_file.ima25
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = g_imy[l_ac].img01
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=g_imy[l_ac].img01
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(g_imy[l_ac].imy28) THEN                                              #CHI-860005
         CALL p701_upd_imgg('1',g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,
                         g_imy[l_ac].img04,g_imy[l_ac].imy27,g_imy32,g_imy[l_ac].imy28,'2')
         IF g_success='N' THEN RETURN END IF
         CALL p701_tlff(g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,l_ima25,
                        g_imy[l_ac].imy28,0,g_imy[l_ac].imy27,g_imy32,'2')
         IF g_success='N' THEN RETURN END IF
      END IF
      IF NOT cl_null(g_imy[l_ac].imy25) THEN                                              #CHI-860005
         CALL p701_upd_imgg('1',g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,
                            g_imy[l_ac].img04,g_imy[l_ac].imy24,g_imy31,g_imy[l_ac].imy25,'1')
         IF g_success='N' THEN RETURN END IF
         CALL p701_tlff(g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,l_ima25,
                        g_imy[l_ac].imy25,0,g_imy[l_ac].imy24,g_imy31,'1')
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(g_imy[l_ac].imy28) THEN                                              #CHI-860005
         CALL p701_upd_imgg('2',g_imy[l_ac].img01,g_imy[l_ac].img02,g_imy[l_ac].img03,
                            g_imy[l_ac].img04,g_imy[l_ac].imy27,g_imy32,g_imy[l_ac].imy28,'2')
         IF g_success = 'N' THEN RETURN END IF
         CALL p701_tlff(g_imy[l_ac].img02,g_imy[l_ac].img03,g_imy[l_ac].img04,l_ima25,
                        g_imy[l_ac].imy28,0,g_imy[l_ac].imy27,g_imy32,'2')
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION p701_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
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
        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"","ima25 null",
                    "","",0)  #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
     CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,+1,p_imgg10,g_imy19,     #FUN-8C0083
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION p701_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
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
   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   g_cnt      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=g_img[l_ac].img01 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
#----來源----
    LET g_tlff.tlff01=g_imy[l_ac].img01       #異動料件編號   #FUN-770057
    LET g_tlff.tlff02=57                     #倉庫
    LET g_tlff.tlff020=g_imn.imn041          #工廠別
    LET g_tlff.tlff021=''                    #倉庫別
    LET g_tlff.tlff022=''                    #儲位別
    LET g_tlff.tlff023=''                    #批號
    LET g_tlff.tlff024=''                    #異動後庫存數量
    LET g_tlff.tlff025=''                    #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=g_imy03           #撥出單號
    LET g_tlff.tlff036=g_imy01           #撥入單號
    LET g_tlff.tlff037=g_imy[l_ac].imy02           #撥入項次
#--->異動數量
    LET g_tlff.tlff04=' '                    #工作站
    LET g_tlff.tlff05=' '                    #作業序號
    LET g_tlff.tlff06=g_imy19            #撥入確認日期     #FUN-770057
    LET g_tlff.tlff07=g_today
    LET g_tlff.tlff08=TIME                   #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                 #產生人
    LET g_tlff.tlff10=p_qty                  #調撥數量
    LET g_tlff.tlff11=p_uom                  #調撥單位
    LET g_tlff.tlff12=p_factor               #庫存/庫存轉換率
    LET g_tlff.tlff13='aimp701'              #異動命令代號
    LET g_tlff.tlff14=''                     #異動原因
    LET g_tlff.tlff15=g_imy[l_ac].img26       #借方會計科目  #FUN-770057
    LET g_tlff.tlff16=''                     #貸方會計科目
    LET g_tlff.tlff17=''                     #非庫存性料件編號
    CALL s_imaQOH(g_img[l_ac].img01)
         RETURNING g_tlff.tlff18             #異動後總庫存量
    LET g_tlff.tlff19= ''                    #異動廠商/客戶編號
    LET g_tlff.tlff20= g_img[l_ac].img35           #專案號碼
    IF cl_null(g_imy[l_ac].imy28) OR g_imy[l_ac].imy28=0 THEN  #FUN-770057
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,g_imy[l_ac].imy27)  #FUN-770057
    END IF
END FUNCTION
 
FUNCTION p701_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac   #No.FUN-690026 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_imy32
    LET l_qty2=g_imy[l_ac].imy28
    LET l_fac1=g_imy31
    LET l_qty1=g_imy[l_ac].imy25
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_imy[l_ac].imy17=g_imy[l_ac].imy24
                   LET g_imy[l_ac].imy16=g_imy[l_ac].imy25
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_imy[l_ac].imy17=g_imy[l_ac].img09
                   LET g_imy[l_ac].imy16=l_tot
          WHEN '3' LET g_imy[l_ac].imy17=g_imy[l_ac].imy24
                   LET g_imy[l_ac].imy16=g_imy[l_ac].imy25
       END CASE
       LET g_imy[l_ac].imy16=s_digqty(g_imy[l_ac].imy16,g_imy[l_ac].imy17)  #FUN-BB0083  add
    END IF
 
END FUNCTION
 
#No.FUN-9C0072 精簡程式碼

#FUN-BB0083---add---str
FUNCTION p701_imy16_check()
#imy16 的單位 imy17
DEFINE   l_str      LIKE ze_file.ze03,      
         l_qty      LIKE imn_file.imn23,
         l_status   LIKE type_file.num5     
   IF NOT cl_null(g_imy[l_ac].imy17) AND NOT cl_null(g_imy[l_ac].imy16) THEN
      IF cl_null(g_imy_o.imy16) OR cl_null(g_imy17_t) OR g_imy_o.imy16 != g_imy[l_ac].imy16 OR g_imy17_t != g_imy[l_ac].imy17 THEN 
         LET g_imy[l_ac].imy16=s_digqty(g_imy[l_ac].imy16,g_imy[l_ac].imy17)
         DISPLAY BY NAME g_imy[l_ac].imy16  
      END IF  
   END IF
   IF g_imy[l_ac].imy16 IS NULL OR g_imy[l_ac].imy16 = ' '
               OR g_imy[l_ac].imy16 <= 0 THEN 
               RETURN "imy16"
            END IF
            #檢查撥出/撥入單位是否可以轉換
             CALL s_umfchk(g_imy[l_ac].img01,g_imn.imn09,g_imy[l_ac].img09)
                  RETURNING l_status,g_imy[l_ac].imy18
                  IF l_status THEN
                     CALL cl_err('','mfg3481',0)
                     RETURN "imy17"
                  END IF
            #檢查撥入/料件單位是否可以轉換
             CALL s_umfchk(g_imy[l_ac].img01,g_imy[l_ac].imy17,g_ima25)
                  RETURNING l_status,g_img[l_ac].img21
                  IF l_status THEN
                     CALL cl_err('','mfg3075',0)
                     RETURN "imy17"
                  END IF
             IF g_imy[l_ac].imy18 IS NULL OR g_imy[l_ac].imy18 <= 0
             THEN LET g_imy[l_ac].imy18 = 1
             END IF
             IF g_img[l_ac].img21 IS NULL OR g_img[l_ac].img21 <= 0
             THEN LET g_img[l_ac].img21 = 1
             END IF
             LET g_imy[l_ac].invqty = g_imy[l_ac].imy16                 #NO.MOD-610082 add
             DISPLAY BY NAME g_imy[l_ac].imy18
             DISPLAY BY NAME g_imy[l_ac].invqty 
             LET l_qty = g_imy[l_ac].imn23 + g_imy[l_ac].invqty
             #IF l_qty > g_imn.imn22  THEN  #NO:MOD-610082 add     #TQC-BA0007
             IF l_qty > g_imy[l_ac].imn11  THEN  #NO:MOD-610082 add     #TQC-BA0007
                CALL cl_getmsg('mfg3484',g_lang) RETURNING l_str
                IF NOT cl_prompt(16,11,l_str) THEN
                   RETURN "imy16"
                END IF
             END IF
RETURN ''
END FUNCTION

FUNCTION p701_imy25_check()
#imy25 的單位 imy24
   IF NOT cl_null(g_imy[l_ac].imy24) AND NOT cl_null(g_imy[l_ac].imy25) THEN
      IF cl_null(g_imy_o.imy25) OR cl_null(g_imy24_t) OR g_imy_o.imy25 != g_imy[l_ac].imy25 OR g_imy24_t != g_imy[l_ac].imy24 THEN 
         LET g_imy[l_ac].imy25=s_digqty(g_imy[l_ac].imy25,g_imy[l_ac].imy24)
         DISPLAY BY NAME g_imy[l_ac].imy25  
      END IF  
   END IF
   IF NOT cl_null(g_imy[l_ac].imy25) THEN
              IF g_imy[l_ac].imy25 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 RETURN FALSE 
              END IF
           END IF
RETURN TRUE 
END FUNCTION

FUNCTION p701_imy28_check()
#imy28 的單位 imy27
   IF NOT cl_null(g_imy[l_ac].imy27) AND NOT cl_null(g_imy[l_ac].imy28) THEN
      IF cl_null(g_imy_o.imy28) OR cl_null(g_imy27_t) OR g_imy_o.imy28 != g_imy[l_ac].imy28 OR g_imy27_t != g_imy[l_ac].imy27 THEN 
         LET g_imy[l_ac].imy28=s_digqty(g_imy[l_ac].imy28,g_imy[l_ac].imy27)
         DISPLAY BY NAME g_imy[l_ac].imy28  
      END IF  
   END IF
   IF NOT cl_null(g_imy[l_ac].imy28) THEN
              IF g_imy[l_ac].imy28 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 RETURN FALSE 
              END IF
              IF g_ima906='3' THEN
                 LET g_tot=g_imy[l_ac].imy28*g_imy32
                 IF cl_null(g_imn.imn32) OR g_imn.imn32=0 THEN  #No.CHI-960022
                    LET g_imn.imn32=g_tot*g_imy31
                    DISPLAY BY NAME g_imn.imn32                 #No.CHI-960022
                 END IF                                         #No.CHI-960022
              END IF
           END IF
RETURN TRUE 
END FUNCTION

   
#FUN-BB0083---add---end
