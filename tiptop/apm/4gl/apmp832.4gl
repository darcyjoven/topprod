# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: apmp832.4gl
# Descriptions...: 三角貿易入庫單拋轉還原作業(正拋時使用)
# Date & Author..: 01/11/15 By Tommy 由 axmp901 改寫
# Modify.........: No.8106 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.注意︰正拋收貨單不重新取號，以免
#                                                 分批入庫時會對不到收貨單
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/04 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.FUN-5A0174 05/10/31 By Sarah 刪除收貨單(rva_file)時,需先檢查對應的采購單的
#                                                  pmm901是否為Y,若否則需show err,let g_success='N'
# Modify.........: No.FUN-620025 06/02/20 By Tracy 流通版多角貿易修改
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.MOD-650124 06/06/22 By Mandy 一收貨多入庫時,拋轉還原時,收貨單的多角序號UPDATE max(rvu99)=>入庫單內 
# Modify.........: No.MOD-680014 06/08/11 By Claire 還原時傳異動類別 '1' 表入庫至 s_mchkARAP 再給oma00='12'
# Modify.........: NO.FUN-670007 06/08/29 BY yiting 1.因三角改善，程式站別重新調整，拋轉還原也要一併調整
#                                                   2.刪除條件加上多角序號，符合序號資料全部刪除
#                                                   3.因為如果有設立中斷點時，可能會有抓不到單號的狀況，那刪除資料會抓不到，現在把單號條件拿掉 
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/23 By johnray 錯誤訊息匯總顯示修改
# Modify.........: NO.TQC-7C0046 07/12/06 BY heather 使入庫單號能開窗查詢
# Modify.........: No.TQC-810048 08/01/15 By Claire (1)還原時delete tlf_file失敗,當收貨為合併收貨時即收貨單單頭的採購單為空白
#                                                   (2)pmn50,pmn53還原時採購單條件值應by單身給
# Modify.........: No.FUN-7B0014 08/01/29 By bnlent 行業別規範修改,拆table需修改 
# Modify.........: No.MOD-820010 08/02/13 By Nicola 拋轉還原不可只取第一筆資料的採購資料
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-870206 08/07/16 By claire 取得l_ogb31,l_ogb32的值,才能更新oeb24(當MISC料件時)
# Modify.........: No.MOD-8B0091 08/11/10 By wujie  拋轉還原時，需判斷是否已有INVOICE
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980081 09/08/19 By destiny 修改傳到s_mupimg里的參數
# Modify.........: No.FUN-980059 09/09/14 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990190 09/09/22 By Dido del_tlfsl宣告位置調整 
# Modify.........: No.MOD-9B0188 09/11/27 By lilingyu del_tlfsl在執行時報-254的錯誤
# Modify.........: No.MOD-9C0353 09/12/23 By Dido 語法調整 
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.MOD-A20032 10/02/05 By Dido 抓取收貨單邏輯調整 
# Modify.........: No.CHI-A20005 10/03/03 By Dido 各站入庫單已被刪除,應取消入庫單更新動作 
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70123 10/07/16 By Smapmin 修改CHI-A20005,否則來源站的多角序號沒有辦法刪除
# Modify.........: No:MOD-AA0073 10/10/13 By Dido 當入庫單身若多筆有相同收貨單+項次時,sqlerr3可忽略筆數為0的情況,
#                                                 因為第一次已經刪除所有的收貨+項次的 tlf 資料 
# Modify.........: No.MOD-A90100 10/12/10 By Smapmin 出貨單tlfs_file的資料沒有刪除
# Modify.........: No:MOD-AB0219 10/12/10 By Smapmin 更新庫存量時,數量帶錯
# Modify.........: No:MOD-B10097 11/01/13 By Carrier p832_p3()中不能call p832_flow99,否则会导致非第一站的营运中心单据中的多角序号变空,且这些单据和当前处理的抛转单据完全没有关系
# Modify.........: No.FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:CHI-B70039 11/08/17 By johung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-B90012 11/08/24 By fengrui  增加ICD行業功能
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: No.FUN-C50136 12/08/27 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_rva   RECORD LIKE rva_file.*
DEFINE g_rvu   RECORD LIKE rvu_file.*
DEFINE g_rvv   RECORD LIKE rvv_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE tm RECORD
          rvu01  LIKE rvu_file.rvu01
       END RECORD
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8106
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8106
DEFINE g_rva01     LIKE rva_file.rva01
DEFINE g_rva99     LIKE rva_file.rva99   #FUN-670007
DEFINE g_rvu01     LIKE rvu_file.rvu01
DEFINE l_dbs_new   LIKE type_file.chr21  #No.FUN-680136 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra   LIKE type_file.chr21   #FUN-980092 
DEFINE l_plant_new   LIKE type_file.chr21 #No.FUN_980059
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE g_sw   LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE g_t1   LIKE oay_file.oayslip      #No.FUN-550060  #No.FUN-680136 VARCHAR(5)
DEFINE g_rvv_cnt LIKE type_file.num5     #No.FUN-680136 smallint
DEFINE g_argv1  LIKE rvu_file.rvu01
DEFINE g_pmm50  LIKE pmm_file.pmm50
DEFINE p_last   LIKE type_file.num5      #No.FUN-680136 SMALLINT     #流程之最后家數
DEFINE p_last_plant LIKE azp_file.azp01  #No.FUN-680136 VARCHAR(10)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680136 CHAR(72) #MOD-9C0353 
DEFINE   g_flag          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   g_ima906        LIKE ima_file.ima906   #FUN-560043
DEFINE   l_aza50         LIKE aza_file.aza50    #No.FUN-620025
DEFINE   g_rva02         LIKE rva_file.rva02    #No.FUN-620025
DEFINE   l_poy02         LIKE poy_file.poy02 #NO.FUN-670007
DEFINE   l_c             LIKE type_file.num5 #NO.FUN-670007


MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_argv1) THEN
      CALL cl_err('','apm-936',1)
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------
 
#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--
#  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'   #FUN-C50136

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN
      CALL p832_p1()
   ELSE
      LET tm.rvu01 = g_argv1
      OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS
      CALL p832_p2()
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
      ELSE
         CALL cl_rbmsg(1)
         ROLLBACK WORK
      END IF
      CLOSE WINDOW win
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p832_p1()
 DEFINE l_ac LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_i LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
 OPEN WINDOW p832_w WITH FORM "apm/42f/apmp832"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
 CALL cl_ui_init()
 
 CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.rvu01
 
 WHILE TRUE
    ERROR ''
    INPUT BY NAME tm.rvu01  WITHOUT DEFAULTS
 
         AFTER FIELD rvu01
            IF NOT cl_null(tm.rvu01) THEN
               SELECT * INTO g_rvu.*,g_rva.* FROM rvu_file,rva_file
                WHERE rvu01=tm.rvu01 AND rva01 = rvu02
	          AND rvu00 = '1'    AND rvu08 = 'TAP'  #no.6113
                  AND rvu20 = 'Y'
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","rvu_file,rva_file",tm.rvu01,"",SQLCA.sqlcode,"","sel rvu",0)  #No.FUN-660129
                  NEXT FIELD rvu01
               END IF
               #若已經立帳(已有應付帳款資料)則不可拋轉還原...
               SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file
                WHERE apa01 = apb01
                  AND apb21 = g_rvu.rvu01
                  AND apa42 = 'N'
               IF g_cnt > 0 THEN
                  CALL cl_err('sel apb:','axm-502',0)
                  NEXT FIELD rvu01
               END IF
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG call cl_cmdask()
 
      ON ACTION locale                    #genero
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
       ON ACTION controlp                                                       
          CASE                                                                  
             WHEN INFIELD(rvu01)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form = "q_rvu6"                                   
                LET g_qryparam.default1=tm.rvu01
                CALL cl_create_qry() RETURNING tm.rvu01
                CALL FGL_DIALOG_SETBUFFER(tm.rvu01)                    
                DISPLAY tm.rvu01 TO rvu01
             OTHERWISE EXIT CASE                                                
          END CASE                                                              
 
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C012y
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN  #genero
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   IF NOT cl_sure(0,0) THEN CONTINUE WHILE END IF
 
   CALL p832_p2()
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
   ELSE
      ROLLBACK WORK
      CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
   END IF
   IF g_flag THEN
      CONTINUE WHILE
   ELSE
      EXIT WHILE
   END IF
 
 END WHILE
 CLOSE WINDOW p832_w
END FUNCTION
 
FUNCTION p832_p2()
  DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_sql3   LIKE type_file.chr1000  #FUN-560043  #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_oeb    RECORD LIKE oeb_file.*
  DEFINE l_oea62  LIKE oea_file.oea62
  DEFINE s_oea62  LIKE oea_file.oea62
  DEFINE l_j      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_msg    LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(60)
  DEFINE l_pmm901 LIKE pmm_file.pmm901   #FUN-5A0174
  DEFINE l_oha01  LIKE oha_file.oha01,
         l_oha02  LIKE oha_file.oha02,
         l_oha99  LIKE oha_file.oha99,   #FUN-670007
         l_ohb    RECORD  LIKE ohb_file.*,
         l_sql4   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_sql5   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_pmm01  LIKE pmm_file.pmm01,
         l_ogb31  LIKE ogb_file.ogb31,
         l_ogb32  LIKE ogb_file.ogb32
 
   CALL cl_wait()
 
   BEGIN WORK
 
   LET g_success='Y'
   LET s_oea62=0
     SELECT * INTO g_rvu.*,g_rva.* FROM rvu_file,rva_file
      WHERE rvu01 = tm.rvu01 AND rva01 = rvu02
	AND rvu20 = 'Y'  #已拋轉
        AND rvu00 = '1'
        AND rvu08 = 'TAP'#no.6113
     IF SQLCA.SQLCODE THEN LET g_success='N'  RETURN END IF
        IF cl_null(g_rva.rva02) THEN
           #只讀取第一筆采購單之資料
           LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
                       "  WHERE pmm01 = rvb04 ",
                       "    AND rvb01 = '",g_rva.rva01,"'"
           PREPARE pmm_pre FROM l_sql1
           DECLARE pmm_f CURSOR FOR pmm_pre
           OPEN pmm_f
           FETCH pmm_f INTO g_pmm.*
        ELSE
           #讀取該入庫單之采購訂單
           SELECT * INTO g_pmm.* FROM pmm_file
            WHERE pmm01 = g_rva.rva02
        END IF
     IF SQLCA.SQLCODE THEN
        CALL cl_err('sel pmm:',SQLCA.SQLCODE,1) LET g_success='N' RETURN
     END IF
     IF g_pmm.pmm906 = 'N' THEN
	CALL cl_err('','apm-012',1) LET g_success= 'N'
     END IF
     LET g_pmm50 = g_pmm.pmm50
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_pmm.pmm904,g_rvu.rvu03) THEN
        LET g_success='N' RETURN
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.* FROM poz_file
      WHERE poz01=g_pmm.pmm904 AND poz00='2'
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_pmm.pmm904,"","axm-318","","",0)  #No.FUN-660129
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN
         CALL cl_err(g_pmm.pmm904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.poz011 = '2' THEN
        CALL cl_err('','apm-014',1) LET g_success = 'N' RETURN
     END IF
     CALL s_mtrade_last_plant(g_pmm.pmm904)
          RETURNING p_last,p_last_plant       #記錄最后一筆之家數
     IF cl_null(p_last) THEN LET g_success = 'N'  RETURN END IF
     #依流程代碼最多6層
     CALL s_showmsg_init()        #No.FUN-710030
     FOR i = 1 TO p_last
        IF g_success="N" THEN
           LET g_totsuccess="N"
           LET g_success="Y"
        END IF
           #得到廠商/客戶代碼及database
           CALL p832_azp(i)
           CALL p832_getno(i)                        #No.8106 取得還原單號
           IF s_mchkARAP(l_plant_new,g_rvu.rvu99,'1') THEN   #MOD-680014 modify   #No.FUN-980059
              LET g_success = 'N' EXIT FOR
           END IF
 
               CALL p832_p3(i)
     END FOR
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
 
     MESSAGE ''
     #更新入庫單之拋轉否='N'
     UPDATE rvu_file SET rvu20='N',
                         rvu99=NULL   #MOD-A70123
      WHERE rvu01 = g_rvu.rvu01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        LET g_success='N'
        CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","upd rvu:",0)  #No.FUN-660129
     END IF
 
     CALL p832_flow99(g_plant)  #FUN-980092 
 
END FUNCTION
 
FUNCTION p832_p3(i)
  DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_sql3   LIKE type_file.chr1000  #FUN-560043  #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_oeb    RECORD LIKE oeb_file.*
  DEFINE l_oea62  LIKE oea_file.oea62
  DEFINE s_oea62  LIKE oea_file.oea62
  DEFINE l_j      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_msg    LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(60)
  DEFINE l_pmm901 LIKE pmm_file.pmm901   #FUN-5A0174
  DEFINE l_oha01  LIKE oha_file.oha01,
         l_oha02  LIKE oha_file.oha02,
         l_oha99  LIKE oha_file.oha99,   #FUN-670007
         l_ohb    RECORD  LIKE ohb_file.*,
         l_sql4   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_sql5   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_pmm01  LIKE pmm_file.pmm01,
         l_ogb31  LIKE ogb_file.ogb31,
         l_ogb32  LIKE ogb_file.ogb32,
         l_ogb12  LIKE ogb_file.ogb12,   #MOD-AB0219
         l_ogb15_fac LIKE ogb_file.ogb15_fac   #MOD-AB0219
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_rvviicd02  LIKE rvvi_file.rvviicd02   #FUN-B90012
  DEFINE l_rvviicd05  LIKE rvvi_file.rvviicd05   #FUN-B90012
  DEFINE l_rvbiicd08  LIKE rvbi_file.rvbiicd08   #FUN-B90012
  DEFINE l_rvbiicd16  LIKE rvbi_file.rvbiicd16   #FUN-B90012
  DEFINE l_ogbiicd028 LIKE ogbi_file.ogbiicd028  #FUN-B90012
  DEFINE l_ogbiicd029 LIKE ogbi_file.ogbiicd029  #FUN-B90012
  DEFINE l_flag       LIKE type_file.chr1        #FUN-B90012
  DEFINE l_rva06      LIKE rva_file.rva06        #FUN-B90012
  DEFINE l_pmn07      LIKE pmn_file.pmn07        #FUN-B90012
  DEFINE l_rvv        RECORD LIKE rvv_file.*     #FUN-B90012
  DEFINE l_rvb        RECORD LIKE rvb_file.*     #FUN-B90012
  DEFINE l_ogb        RECORD LIKE ogb_file.*     #FUN-B90012
  #FUN-BC0104-add-str--
  DEFINE l_rvv02      LIKE  rvv_file.rvv02
  DEFINE l_rvv04      LIKE  rvv_file.rvv04
  DEFINE l_rvv05      LIKE  rvv_file.rvv05
  DEFINE l_rvv45      LIKE  rvv_file.rvv45
  DEFINE l_rvv46      LIKE  rvv_file.rvv46
  DEFINE l_rvv47      LIKE  rvv_file.rvv47
  DEFINE l_qcl05      LIKE  qcl_file.qcl05
  DEFINE l_flagg      LIKE  type_file.chr1 
  DEFINE l_type1      LIKE  type_file.chr1
  DEFINE l_cn         LIKE  type_file.num5
  DEFINE l_c          LIKE  type_file.num5
  DEFINE l_rvv_a      DYNAMIC ARRAY OF RECORD
         rvv04        LIKE  rvv_file.rvv04,
         rvv05        LIKE  rvv_file.rvv05,
         rvv45        LIKE  rvv_file.rvv45,
         rvv46        LIKE  rvv_file.rvv46,
         rvv47        LIKE  rvv_file.rvv47,
         flagg        LIKE  type_file.chr1
                      END RECORD
  #FUN-BC0104-add-end--
# DEFINE l_oga03 LIKE oga_file.oga03     #FUN-C50136 add
# DEFINE l_oia07 LIKE oia_file.oia07     #FUN-C50136 add
# DEFINE l_oha03 LIKE oha_file.oha03     #FUN-C50136 add
 
     LET l_oea62=0
     #讀取入庫單身檔(rvv_file)
     DECLARE rvv_cus CURSOR FOR
      SELECT * FROM rvv_file WHERE rvv01 = g_rvu.rvu01
#       LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"tlfs_file", #modify by dxfwo
        #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlfs_file", #l_dbs_new --> l_dbs_tra 
        LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlfs_file'), #FUN-A50102
                   " WHERE tlfs01 = ? ",
                   "   AND tlfs10 = ? ",
                   "   AND tlfs11 = ? ",
                   "   AND tlfs111 = ? "
	CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2	
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
        PREPARE del_tlfsl FROM l_sql2
     FOREACH rvv_cus INTO g_rvv.*
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        SELECT ima906 INTO g_ima906 FROM ima_file
         WHERE ima01 = g_rvv.rvv31
        IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
           #重新取得單身的流程序號
            SELECT pmm99 INTO g_pmm.pmm99 FROM pmm_file
             WHERE pmm01 = g_rvv.rvv36
        #LET l_sql = " SELECT rvv04,rvv36 FROM ",l_dbs_tra CLIPPED,"rvv_file,", #FUN-980092  #MOD-A20032 mark    
         #LET l_sql = " SELECT rvv04,rvv05,rvv36,rvv37 FROM ",l_dbs_tra CLIPPED,"rvv_file,",  #MOD-A20032
         #               l_dbs_tra CLIPPED, "rvu_file",
         LET l_sql = " SELECT rvv04,rvv05,rvv36,rvv37 FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",", #FUN-A50102
                                                             cl_get_target_table(l_plant_new,'rvu_file'),     #FUN-A50102
                     "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                     "    AND rvu01 = rvv01",
                     "    AND rvv02 ='",g_rvv.rvv02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE rvv01_pre FROM l_sql
         DECLARE rvv01_cs CURSOR FOR rvv01_pre
         OPEN rvv01_cs
        #FETCH rvv01_cs INTO g_rvv.rvv04,g_rvv.rvv36      #收貨單,采購單                           #MOD-A20032 mark 
         FETCH rvv01_cs INTO g_rvv.rvv04,g_rvv.rvv05,g_rvv.rvv36,g_rvv.rvv37      #收貨單,采購單   #MOD-A20032
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_tra CLIPPED,'fetch rvv01_cs'
            CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
 
            IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
                #刪除入庫單身檔-->l_dbs_new no.4526
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file", 
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
            DECLARE p832_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c  USING g_rvv.rvv04,g_rvv.rvv05,
                                        g_rvu01,g_rvv.rvv02  INTO g_tlf.* 
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
                 #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092
                 LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                            " WHERE (tlf026 = ? ", 
                            "   AND tlf027 = ?)",  
                            "   AND (tlf036 = ? ", 
                            "   AND tlf037 = ?)" 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                 PREPARE del1_tlf FROM l_sql2
                 EXECUTE del1_tlf USING g_rvv.rvv04,g_rvv.rvv05,   #TQC-810048 cancel mark
                                        g_rvu01,g_rvv.rvv02
                 IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                     LET g_msg = l_dbs_tra,'del tlf(rvv)'
                    LET g_success='N'
                    IF g_bgerr THEN
                       CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                       CONTINUE FOREACH
                    ELSE
                       CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                       EXIT FOREACH
                    END IF
                 END IF
  ##NO.FUN-8C0131   add--begin
                 FOR l_i = 1 TO la_tlf.getlength()
                    LET g_tlf.* = la_tlf[l_i].*
                    #IF NOT s_untlf1(l_dbs_tra) THEN 
                    IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                       LET g_success='N' RETURN
                    END IF 
                 END FOR       
  ##NO.FUN-8C0131   add--end   
                 #刪除批/序號異動資料
                 EXECUTE del_tlfsl USING g_rvv.rvv31,g_rvu01,g_rvv.rvv02,g_rvu.rvu03 
                 IF SQLCA.SQLCODE THEN
                    LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
                    CALL s_errmsg('','',g_msg,STATUS,1)
                    LET g_success='N'
                 END IF
                 #FUN-B90012-add-str--
                 IF s_industry('icd') THEN 
                    LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                                 "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",",
                                           cl_get_target_table(l_plant_new,'rvvi_file'),
                                 " WHERE rvv01 = '",g_rvu01,"' ",
                                 "   AND rvv02 = '",g_rvv.rvv02,"' ",
                                 "   AND rvv01 = rvvi01 ",
                                 "   AND rvv02 = rvvi02 "
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                    PREPARE rvv_rvv_1 FROM l_sql2
                    EXECUTE rvv_rvv_1 INTO l_rvv.*,l_rvviicd02,l_rvviicd05
       
                    CALL s_icdpost(11,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                   l_rvv.rvv35,l_rvv.rvv17,g_rvu01,g_rvv.rvv02,
                                   g_rvu.rvu03,'N',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
                       RETURNING l_flag
                    IF l_flag = 0 THEN
                       LET g_success = 'N'
                    END IF
                 END IF
                 #FUN-B90012-add-end--
 
                 IF g_ima906 = '2' OR g_ima906 = '3' THEN
                     #刪除入庫單身檔-->l_dbs_new
                     #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file",  #FUN-980092
                     LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                             " WHERE (tlff026 = ? ",
                                             "   AND tlff027 = ?)", 
                                             "   AND (tlff036 = ? ",
                                             "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                     PREPARE del1_tlff FROM l_sql3
                     EXECUTE del1_tlff USING g_rvv.rvv04,g_rvv.rvv05,  #TQC-810048 cancel mark
                                             g_rvu01,g_rvv.rvv02
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                         LET g_msg = l_dbs_tra,'del tlff(rvv)'
                        LET g_success='N'
                        IF g_bgerr THEN
                           CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                           CONTINUE FOREACH
                        ELSE
                           CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                           EXIT FOREACH
                        END IF
                     END IF
  
                     #刪除批/序號異動資料
                     EXECUTE del_tlfsl USING g_rvv.rvv31,g_rvu01,g_rvv.rvv02,g_rvu.rvu03 
                     IF SQLCA.SQLCODE THEN
                        LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
                        CALL s_errmsg('','',g_msg,STATUS,1)
                        LET g_success='N'
                     END IF
 
                 END IF
            END IF 
 
            #因為可能分批入庫，若有其他入庫單共用此收貨單
            #       則暫不刪除...
            LET l_sql2 ="SELECT COUNT(*) ",
                        #" FROM ",l_dbs_tra CLIPPED,"rvv_file",    #FUN-980092
                        " FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102  
                        " WHERE rvv04 ='",g_rvv.rvv04,"'",        #TQC-810048 cancel mark
                        "   AND rvv01 != '",g_rvu01,"'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE count_pre FROM l_sql2
            DECLARE count_cs CURSOR FOR count_pre
            OPEN count_cs
            FETCH count_cs INTO g_rvv_cnt
            IF cl_null(g_rvv_cnt) THEN LET g_rvv_cnt = 0 END IF
            CLOSE count_cs
            IF g_rvv_cnt = 0 THEN
                IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
                    #刪除tlf檔(收貨單) -->l_dbs_new no.4526
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",
           LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102  
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
            DECLARE p832_u_tlf_c1 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c1 USING g_rvv.rvv36,g_rvv.rvv37,
                                        g_rvv.rvv04,g_rvv.rvv05   INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
                    #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092
                    LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                               " WHERE (tlf026 = ? ",
                               "   AND tlf027 = ?)", 
                               "   AND (tlf036 = ? ",
                               "   AND tlf037 = ?)" 
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                    PREPARE del3_tlf FROM l_sql2
                    EXECUTE del3_tlf USING g_rvv.rvv36,g_rvv.rvv37,  #TQC-810048 modify
                                           g_rvv.rvv04,g_rvv.rvv05   #TQC-810048 cancel mark
                   #IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN #MOD-AA0073 mark
                    IF SQLCA.SQLCODE <> 0 THEN                       #MOD-AA0073
                       LET g_msg = l_dbs_tra,'del tlf(rvb)'
                       IF g_bgerr THEN
                          CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                       ELSE
                          CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                       END IF
                       LET g_success='N'  
                    END IF
  ##NO.FUN-8C0131   add--begin
                 FOR l_i = 1 TO la_tlf.getlength()
                    LET g_tlf.* = la_tlf[l_i].*
                    #IF NOT s_untlf1(l_dbs_tra) THEN 
                    IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                       LET g_success='N' RETURN
                    END IF 
                 END FOR       
  ##NO.FUN-8C0131   add--end 
  
                    #刪除批/序號異動資料
                    EXECUTE del_tlfsl USING g_rvv.rvv31,g_rva01,g_rvv.rvv02,g_rvu.rvu03 
                    IF SQLCA.SQLCODE THEN
                       LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
                       CALL s_errmsg('','',g_msg,STATUS,1)
                       LET g_success='N'
                    END IF
                    
                    #FUN-B90012-add-str--
                    IF s_industry('icd') THEN 
                       LET l_sql2 = "SELECT rva06 FROM ",cl_get_target_table(l_plant_new,'rva_file'),
                                    " WHERE rva01 = '",g_rvv.rvv04,"'"
                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                       PREPARE rva_rva06 FROM l_sql2
                       EXECUTE rva_rva06 INTO l_rva06
  
                       LET l_sql2 = "SELECT rvb_file.*,rvbiicd08,rvbiicd16 ",
                                    "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",",
                                              cl_get_target_table(l_plant_new,'rvbi_file'),
                                    " WHERE rvb01 = '",g_rvv.rvv04,"'",
                                    "   AND rvb02 = '",g_rvv.rvv02,"'",
                                    "   AND rvb01 = rvbi01 ",
                                    "   AND rvb02 = rvbi02 "
                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                       PREPARE rvbicd_rvb_1 FROM l_sql2
                       EXECUTE rvbicd_rvb_1 INTO l_rvb.*,l_rvbiicd08,l_rvbiicd16  
 
                       LET l_pmn07 = NULL
                       LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(l_plant_new,'pmn_file'),
                                    " WHERE pmn01 = '",l_rvb.rvb04,"'",
                                    "   AND pmn02 = '",l_rvb.rvb03,"'"
                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                       PREPARE pmn_pmn07_1 FROM l_sql2
                       EXECUTE pmn_pmn07_1 INTO l_pmn07

                       CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                                        l_pmn07,l_rvb.rvb07,g_rvv.rvv04,g_rvv.rvv02,
                                        l_rva06,'N','','',l_rvbiicd16,l_rvbiicd08,l_plant_new) 
                       RETURNING l_flag
                       IF l_flag = 0 THEN 
                          LET g_success = 'N'
                       END IF 
                    END IF
                    #FUN-B90012-add-end--
 
                    IF g_ima906 = '2' OR g_ima906 = '3' THEN
                        #刪除tlff檔(收貨單) -->l_dbs_new
                        #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file",  #FUN-9800920
                        LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                   " WHERE (tlff026 = ? ",  
                                   "   AND tlff027 = ?)",       #MOD-9C0353
                                   "   AND (tlff036 = ? ",  
                                   "   AND tlff037 = ?)"   
 	                CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                        CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                        PREPARE del3_tlff FROM l_sql3
                        EXECUTE del3_tlff USING g_rvv.rvv36,g_rvv.rvv37,  #TQC-810048 modify
                                                g_rvv.rvv04,g_rvv.rvv05   #TQC-810048 cancel mark
                       #IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN #MOD-AA0073 mark
                        IF SQLCA.SQLCODE <> 0 THEN                       #MOD-AA0073
                           LET g_msg = l_dbs_tra,'del tlff(rvb)'
                           IF g_bgerr THEN
                              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                           ELSE
                              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                           END IF
                           LET g_success='N'    
                        END IF
  
                        #刪除批/序號異動資料
                        EXECUTE del_tlfsl USING g_rvv.rvv31,g_rvu01,g_rvv.rvv02,g_rvu.rvu03 
                        IF SQLCA.SQLCODE THEN
                           LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
                           CALL s_errmsg('','',g_msg,STATUS,1)
                           LET g_success='N'
                        END IF
 
                    END IF
                END IF
            END IF
        END IF
            #LET l_sql4 = "SELECT ogb31,ogb32 ",   #MOD-AB0219                                                                          
            LET l_sql4 = "SELECT ogb31,ogb32,ogb12,ogb15_fac ",   #MOD-AB0219                                                                          
                         #"  FROM ",l_dbs_tra,"ogb_file" ,   #FUN-980092
                         "  FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102 
                         " WHERE ogb01 ='",g_oga.oga01,"'",                                                                           
                         "   AND ogb03 =",g_rvv.rvv02      
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
            PREPARE ogb31_pre FROM l_sql4                                                                                         
            DECLARE ogb31_cs CURSOR FOR ogb31_pre                                                                                 
            OPEN ogb31_cs                                                                                                         
            #FETCH ogb31_cs INTO l_ogb31,l_ogb32   #MOD-AB0219
            FETCH ogb31_cs INTO l_ogb31,l_ogb32,l_ogb12,l_ogb15_fac   #MOD-AB0219
            IF SQLCA.SQLCODE THEN                                                                                                 
               LET g_msg = l_dbs_tra,'sel ogb31'    
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                  EXIT FOREACH
               END IF
            END IF                                                                                                                
            CLOSE ogb31_cs                                                       
        IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
            #刪除tlf檔(出貨單) -->l_dbs_new no.4526
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",
           LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102  
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
            DECLARE p832_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c2 USING g_oga.oga01,g_rvv.rvv02,
                                        l_ogb31,l_ogb32  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
            #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102  
                       " WHERE (tlf026 = ? ",  
                       "   AND tlf027 = ?)",   
                       "   AND (tlf036 = ? ",  
                       "   AND tlf037 = ?)"    
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE del2_tlf FROM l_sql2
            EXECUTE del2_tlf USING g_oga.oga01,g_rvv.rvv02,                                                                           
                                   l_ogb31,l_ogb32
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra,'del tlf(ogb)'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
               END IF
                LET g_success='N'  
            END IF
    ##NO.FUN-8C0131   add--begin
            FOR l_i = 1 TO la_tlf.getlength()
               LET g_tlf.* = la_tlf[l_i].*
               #IF NOT s_untlf1(l_dbs_tra) THEN 
               IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                  LET g_success='N' RETURN
               END IF 
            END FOR       
  ##NO.FUN-8C0131   add--end   
            #刪除批/序號異動資料
            #EXECUTE del_tlfsl USING g_rvv.rvv31,l_ogb31,l_ogb32,g_rvu.rvu03    #MOD-A90100
            EXECUTE del_tlfsl USING g_rvv.rvv31,g_oga.oga01,g_rvv.rvv02,g_rvu.rvu03    #MOD-A90100
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
               CALL s_errmsg('','',g_msg,STATUS,1)
               LET g_success='N'
            END IF
            #FUN-B90012-add-str--
            IF s_industry('icd') THEN 
               LET l_sql2 = "SELECT ogb_file.*,ogbiicd028,ogbiicd029 ",
                            "  FROM ",cl_get_target_table(l_plant_new,'ogb_file'),",",
                                      cl_get_target_table(l_plant_new,'ogbi_file'),
                            " WHERE ogb01 = '",g_oga.oga01,"'",
                            "   AND ogb03 = '",g_rvv.rvv02,"'",
                            "   AND ogb01 = ogbi01 ",
                            "   AND ogb03 = ogbi03 "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE ogb_ogb_1 FROM l_sql2
               EXECUTE ogb_ogb_1 INTO l_ogb.*,l_ogbiicd028,l_ogbiicd029

               CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,
                              l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb05,l_ogb.ogb12,
                              g_oga.oga01,g_rvv.rvv02,g_rvu.rvu03,
                              'N','','',l_ogbiicd028,l_ogbiicd029,l_plant_new)
                  RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-B90012-add-end--
 
            IF g_ima906 = '2' OR g_ima906 = '3' THEN
                #刪除tlff檔(出貨單) -->l_dbs_new
                #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092
                LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102  
                           " WHERE (tlff026 = ? ", 
                           "   AND tlff027 = ?)",  
                           "   AND (tlff036 = ? ", 
                           "   AND tlff037 = ?)"   
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                PREPARE del2_tlff FROM l_sql3
                EXECUTE del2_tlff USING g_oga.oga01,g_rvv.rvv02,                                                                           
                                        l_ogb31,l_ogb32
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_msg = l_dbs_tra,'del tlff(ogb)'
                   IF g_bgerr THEN
                      CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                   END IF
                    LET g_success='N' 
                END IF
  
                #刪除批/序號異動資料
                EXECUTE del_tlfsl USING g_rvv.rvv31,l_ogb31,l_ogb32,g_rvu.rvu03 
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'   
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF
 
            END IF
        END IF
        IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
        #更新采購單身之入庫量及交貨量
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                       " SET pmn50 = pmn50 - ?,",
                       "     pmn53 = pmn53 - ? ",
                       " WHERE pmn01 = ? AND pmn02 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn FROM l_sql2
            LET l_sql5 = "SELECT pmm01 ",                                                                                
                         #"  FROM ",l_dbs_tra,"pmm_file" ,     #FUN-980092
                         "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102                         
                         " WHERE pmm99 ='",g_pmm.pmm99,"'"
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
         CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-980092
            PREPARE pmm01_pre FROM l_sql5                                                                                      
            DECLARE pmm01_cs CURSOR FOR pmm01_pre                                                                              
            OPEN pmm01_cs                                                                                                      
            FETCH pmm01_cs INTO l_pmm01                                                                               
            IF SQLCA.SQLCODE THEN                                                                                              
                LET g_msg = l_dbs_tra,'sel pmm01'                                                                               
               LET g_success='N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                  EXIT FOREACH
               END IF
            END IF                                                                                                             
            CLOSE pmm01_cs                             
            EXECUTE upd_pmn USING
                            g_rvv.rvv17,g_rvv.rvv17,
                            l_pmm01,g_rvv.rvv37
            IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra,'upd pmn'
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                  EXIT FOREACH
               END IF
            END IF
        END IF
        #做扣帳還原....(幫出貨單扣帳)
        IF i = p_last AND cl_null(g_pmm50) THEN
           #抓取扣帳的倉儲批.... no.4475
           LET l_sql2 = "SELECT ogb09,ogb091,ogb092 ",
                        #"  FROM ",l_dbs_tra,"ogb_file" ,    #FUN-980092
                        "  FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                        " WHERE ogb01 ='",g_oga.oga01,"'",
                        "   AND ogb03 =",g_rvv.rvv02        #No.8630
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE ogb09_pre FROM l_sql2
           DECLARE ogb09_cs CURSOR FOR ogb09_pre
           OPEN ogb09_cs
           FETCH ogb09_cs INTO g_rvv.rvv32,g_rvv.rvv33,g_rvv.rvv34
           IF SQLCA.SQLCODE THEN
              LET g_msg = l_dbs_tra,'sel ware'
           LET g_success='N'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              EXIT FOREACH
           END IF
           END IF
           CLOSE ogb09_cs
           CALL s_mupimg(1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
                           #g_rvv.rvv34,g_rvv.rvv17*g_rvv.rvv35_fac,   #MOD-AB0219
                           g_rvv.rvv34,l_ogb12*l_ogb15_fac,   #MOD-AB0219
                           #g_rvu.rvu03,l_plant_new,1,g_rvv.rvv01,g_rvv.rvv02)  #No.FUN-850100      #No.FUN-980081   #MOD-A90100
                           g_rvu.rvu03,l_plant_new,-1,g_oga.oga01,g_rvv.rvv02)  #No.FUN-850100      #No.FUN-980081   #MOD-A90100
           IF g_ima906 = '2'  THEN
              CALL s_mupimgg(1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
                              g_rvv.rvv34,g_rvv.rvv80,g_rvv.rvv82,
                              g_rvu.rvu03,
                              l_plant_new)  #FUN-980092
              CALL s_mupimgg(1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
                              g_rvv.rvv34,g_rvv.rvv83,g_rvv.rvv85,
                              g_rvu.rvu03,
                              l_plant_new)  #FUN-980092
           END IF
           IF g_ima906 = '3'  THEN
               CALL s_mupimgg(1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
                              g_rvv.rvv34,g_rvv.rvv83,g_rvv.rvv85,
                              g_rvu.rvu03,
                              l_plant_new)  #FUN-980092
           END IF
           CALL s_mudima(g_rvv.rvv31,l_plant_new)  #FUN-980092
           IF g_success='N' THEN EXIT FOREACH END IF
        END IF
 
        IF l_aza50='Y' THEN                   #使用分銷功能
           IF g_oga.oga00='6'  THEN           #有代送銷退單生成  
              #獲取代送銷退單資料  
              LET l_sql = " SELECT oha01,oha02,ohb03,ohb04,ohb09,ohb091,",
                          "        ohb092,ohb12,ohb15_fac,ohb910,ohb912,",
                          "        ohb913,ohb915 FROM ",
                          #  l_dbs_tra CLIPPED," oha_file,",  #FUN-980092
                          #  l_dbs_tra CLIPPED, "ohb_file", 
                            cl_get_target_table(l_plant_new,'oha_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'ohb_file'),     #FUN-A50102             
                          "  WHERE oha1018 ='",g_oga.oga01,"'",                 
                          "    AND oha05 = '1' ",              
                          "    AND (oha10 IS NULL OR oha10 =' ' ) ",   #帳單編號必須為null
                          "    AND oha01 = ohb01 "  
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
              PREPARE oha01_pre FROM l_sql  
              DECLARE oha01_cs CURSOR FOR oha01_pre     
              OPEN oha01_cs   
              FETCH oha01_cs INTO l_oha01,l_oha02,l_ohb.ohb03,l_ohb.ohb04,
                                  l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb12,
                                  l_ohb.ohb15_fac,l_ohb.ohb910,l_ohb.ohb912,
                                  l_ohb.ohb913,l_ohb.ohb915   
              IF SQLCA.SQLCODE THEN     
                 LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'     
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                 END IF
                 LET g_success = 'N'  
              END IF    
              CLOSE oha01_cs    
              #刪除tlf檔(銷退單) -->l_dbs_tra                                                    
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",
           LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
            DECLARE p832_u_tlf_c3 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c3 USING l_oha01,l_ohb.ohb03,l_oha01,
                                        l_ohb.ohb03  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
              #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file",   #FUN-980092
              LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102               
                         " WHERE (tlf026 = ? ",                
                         "   AND  tlf027 = ?)",               
                         "   AND (tlf036 = ? ",              
                         "   AND  tlf037 = ?)"     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE del0_tlf FROM l_sql2    
              EXECUTE del0_tlf 
              USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN        
                 LET g_msg = l_dbs_tra CLIPPED,'del tlf'       
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                 END IF
                 LET g_success='N'
                 RETURN
              END IF        
    ##NO.FUN-8C0131   add--begin
                 FOR l_i = 1 TO la_tlf.getlength()
                    LET g_tlf.* = la_tlf[l_i].*
                    #IF NOT s_untlf1(l_dbs_tra) THEN 
                    IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                       LET g_success='N' RETURN
                    END IF 
                 END FOR       
  ##NO.FUN-8C0131   add--end  
              #刪除tlff檔(銷退單) -->l_dbs_tra    
              IF g_ima906 = '2' OR g_ima906 = '3' THEN       
                 #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092 
                 LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
                            " WHERE (tlff026 = ? ",                  
                            "   AND tlff027 = ?)",                 
                            "   AND (tlff036 = ? ",                  
                            "   AND tlff037 = ?)"     
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                 PREPARE del_tlf2 FROM l_sql3       
                 EXECUTE del_tlf2 
                 USING l_oha01,l_ohb.ohb03, l_oha01,l_ohb.ohb03
                 IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN          
                    LET g_msg = l_dbs_tra CLIPPED,'del tlff'          
                    IF g_bgerr THEN
                       CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                    END IF
                    LET g_success='N'      
                 END IF
              END IF
              #更新img，imgg，ima
              IF i = p_last THEN   
                 CALL s_mupimg(-1,l_ohb.ohb04, l_ohb.ohb09,l_ohb.ohb091,
                               l_ohb.ohb092,l_ohb.ohb12*l_ohb.ohb15_fac,                 
                               l_oha02,l_plant_new,0,'','') #No.FUN-850100     #No.FUN-980081
                 IF g_ima906 = '2' THEN       
                    CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                   l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb912,                      
                                   l_oha02,l_plant_new)    #FUN-980092       
                    CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                   l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb915,                       
                                   l_oha02,l_plant_new)   #FUN-980092   
                 END IF    
                 IF g_ima906 = '3' THEN       
                    CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                   l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb915,                       
                                   l_oha02, l_plant_new)  #FUN-980092
                 END IF    
                 CALL s_mudima(l_ohb.ohb04,l_plant_new)  #FUN-980092
              END IF
#             #FUN-C50136--add-str--
#             IF g_oaz.oaz96 ='Y' THEN
#                LET l_sql2 = "SELECT oha03 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
#                             " WHERE oha01 = ? ",
#                             "   AND oha05 ='1'"
#                PREPARE sel_oha FROM l_sql2
#                EXECUTE sel_oha USING l_oha01 INTO l_oha03
#                CALL s_ccc_oia07('G',l_oha03) RETURNING l_oia07
#                IF l_oia07 = '0' THEN
#                   CALL s_ccc_rback(l_oha03,'G',l_oha01,0,l_plant_new)
#                END IF
#             END IF
#             #FUN-C50136--add-end--
              #刪除銷退單資料
              #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092
              LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102   
                         " WHERE oha01= ? ", 
                         "   AND oha05='1' "     #MOD-9C0353
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE del_oha 
              FROM l_sql2
              EXECUTE del_oha 
              USING l_oha01
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN  
                 LET g_msg = l_dbs_tra CLIPPED,'del oha:'   
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                 END IF
                 LET g_success='N'    
              END IF
              #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ohb_file",
              LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102 
                         " WHERE ohb01= ? "     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE del_ohb 
              FROM l_sql2
              EXECUTE del_ohb 
              USING l_oha01
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN   
                 LET g_msg = l_dbs_tra CLIPPED,'del ohb:'   
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                 END IF
                 LET g_success='N' 
           #FUN-B70074-add-str--
              ELSE 
                 IF NOT s_industry('std') THEN 
                    IF NOT s_del_ohbi(l_oha01,'',l_plant_new) THEN 
                       LET g_success ='N'
                    END IF 
                 END IF
           #FUN-B70074-add-end--
              END IF
           END IF 
        END IF    
        #讀取流程代碼中之銷單資料
        #LET l_sql2="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092
        LET l_sql2="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102 
                   " WHERE oeb01 ='",l_ogb31,"' ",
                   "   AND oeb03 =",l_ogb32
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE oeb_cu2  FROM l_sql2
        DECLARE oeb_p2 CURSOR FOR oeb_cu2
        OPEN oeb_p2
        FETCH oeb_p2 INTO l_oeb.*
        CLOSE oeb_p2
        IF SQLCA.sqlcode<>0 THEN
            LET g_msg = l_dbs_tra,'sel oeb_p2'
           LET g_success = 'N'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              EXIT FOREACH
           END IF
        END IF
        #更新銷單資料
        #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092
        LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102 
                   " SET oeb24=oeb24 - ? ",  
                   " WHERE oeb01 = ? AND oeb03 = ? "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE upd_oeb2 FROM l_sql2
        EXECUTE upd_oeb2 USING     
                g_rvv.rvv17,l_ogb31,l_ogb32 
        IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = l_dbs_tra,'upd oeb24'
           LET g_success = 'N'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              EXIT FOREACH
           END IF
        END IF
#       LET l_oea62 = l_oea62 + g_rvv.rvv17 * g_rvv.rvv38   #CHI-B70039 mark
        LET l_oea62 = l_oea62 + g_rvv.rvv87 * g_rvv.rvv38   #CHI-B70039
        END FOREACH {ogb_cus}
 
        #刪除批/序號資料檔(rvbs_file)
        #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092
        LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102
                   " WHERE rvbs00 = ? ",
                   "   AND rvbs01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_rvbsl FROM l_sql2
 
        #刪除出貨單單頭檔(oga_file)
        #LET l_sql2="SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oga_file", 
        LET l_sql2="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                   " WHERE oga27 IS NOT NULL ",
                   "   AND oga01 ='",g_oga.oga01,"'"                                  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE sel_oga FROM l_sql2                                             
        EXECUTE sel_oga INTO g_cnt                                              
        IF g_cnt >0 THEN                                                        
           CALL cl_err(g_oga.oga01,'apm-731',1)                                 
           LET g_success='N'                                                    
        END IF       
#       #FUN-C50136--add-str--
#       IF g_oaz.oaz96 ='Y' THEN
#          LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                       " WHERE oga01 = ? ",
#                       "   AND oga09 ='6'"
#          PREPARE sel_oga1 FROM l_sql2
#          EXECUTE sel_oga1 USING g_oga.oga01 INTO l_oga03
#          CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_rback(l_oga03,'D',g_oga.oga01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136--add-end--
        #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oga_file", #FUN-980092
        LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                   " WHERE oga01= ? ", 
                   "   AND oga09='6' "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_oga FROM l_sql2
        EXECUTE del_oga USING g_oga.oga01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
           LET g_msg = l_dbs_tra,'del oga'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
           END IF
           LET g_success='N'  
        END IF  
 
        #刪除出貨單身檔
        #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogb_file", #FUN-980092
        LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                   " WHERE ogb01= ? "     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_ogb FROM l_sql2
        EXECUTE del_ogb USING g_oga.oga01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
           LET g_msg = l_dbs_tra,'del ogb'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
           END IF
           LET g_success='N'      
        ELSE
           IF NOT s_industry('std') THEN
              IF NOT s_del_ogbi(g_oga.oga01,'',l_plant_new) THEN  #FUN-980092
                 LET g_success = 'N'
              END IF
           END IF
        END IF
  
        #刪除批/序號資料
        EXECUTE del_rvbsl USING 'axmt821',g_oga.oga01
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'   
           CALL s_errmsg('','',g_msg,STATUS,1)
           LET g_success='N'
        END IF

        #FUN-B90012-add-str--
        IF s_industry('icd') THEN 
           CALL icd_idb_del(g_oga.oga01,'',l_plant_new)
        END IF
        #FUN-B90012-add-end--
 
        IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
            #no.4475因為可能分批入庫，若有其他入庫單共用此收貨單
            #       則暫不刪除...
            IF g_rvv_cnt = 0 THEN
                #檢查對應之采購單是否為多角貿易(pmm901),若否則show err
                #LET l_sql2="SELECT pmm901 FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                LET l_sql2="SELECT pmm901 FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                           " WHERE pmm01 = '",l_pmm01,"'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                DECLARE sel_pmm CURSOR FROM l_sql2
                OPEN sel_pmm
                FETCH sel_pmm INTO l_pmm901
                IF l_pmm901!='Y' THEN    #pmm901:多角貿易否
                   LET g_success='N'
                   IF g_bgerr THEN
                      CALL s_errmsg("","",g_rva.rva01,"apm-990",1)
                   ELSE
                      CALL cl_err3("","","","","apm-990","",g_rva.rva01,1)
                   END IF
                   LET g_success='N'
                   RETURN
                END IF
                CLOSE sel_pmm
 
                #刪除收貨單頭檔-->l_dbs_new
                #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rva_file",  #FUN-980092
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                           " WHERE rva01= ? "   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                PREPARE del_rva FROM l_sql2
                EXECUTE del_rva USING g_rvv.rvv04   #TQC-810048 
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_msg = l_dbs_tra,'del rva'
                   IF g_bgerr THEN
                      CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                   END IF
                   LET g_success='N'  
                END IF
                #刪除收貨單身檔-->l_dbs_tra
                #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvb_file",
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                           " WHERE rvb01= ? "      
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                PREPARE del_rvb FROM l_sql2
                EXECUTE del_rvb USING g_rvv.rvv04   #TQC-810048 
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                    LET g_msg = l_dbs_tra,'del rvb'
                   IF g_bgerr THEN
                      CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                   END IF
                    LET g_success='N'  
                ELSE    #No.FUN-7B0018 080304 add 
                   IF NOT s_industry('std') THEN
                      IF NOT s_del_rvbi(g_rvv.rvv04,'',l_plant_new) THEN #FUN-980092
                         LET g_success = 'N'
                      END IF
                   END IF
                END IF
  
                #刪除批/序號資料
                EXECUTE del_rvbsl USING 'apmt300',g_rvv.rvv04
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'   
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF

                #FUN-B90012-add-str--
                IF s_industry('icd') THEN 
                   CALL icd_ida_del(g_rvv.rvv04,'',l_plant_new)
                END IF
                #FUN-B90012-add-end--
 
            END IF
            #刪除入庫單頭檔-->l_dbs_new
            #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                       " WHERE rvu01= ? ",
                       "   AND rvu00='1'"
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE del_rvu FROM l_sql2
            EXECUTE del_rvu USING g_rvu01
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_msg = l_dbs_tra,'del rvu'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
               END IF
               LET g_success='N'
            END IF
            #FUN-BC0104-add-str--
            LET l_cn = 1
            DECLARE upd_qco20 CURSOR FOR
             SELECT rvv02 FROM rvv_file WHERE rvv01=g_rvu01 AND rvv03 ='1'
            FOREACH upd_qco20 INTO l_rvv02
               CALL s_iqctype_rvv(g_rvu01,l_rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg
               LET l_rvv_a[l_cn].rvv04 = l_rvv04
               LET l_rvv_a[l_cn].rvv05 = l_rvv05
               LET l_rvv_a[l_cn].rvv45 = l_rvv45
               LET l_rvv_a[l_cn].rvv46 = l_rvv46
               LET l_rvv_a[l_cn].rvv47 = l_rvv47
               LET l_rvv_a[l_cn].flagg = l_flagg
               LET l_cn = l_cn + 1 
            END FOREACH
            #FUN-BC0104-add-end--
            #刪除入庫單身檔-->l_dbs_new
            #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvv_file", #FUN-980092
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
                       " WHERE rvv01= ? ",      
                       "   AND rvv03='1'"
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE del_rvv FROM l_sql2
            EXECUTE del_rvv USING g_rvu01
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra,'del rvv'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
               END IF
                LET g_success='N'  
            ELSE
               #FUN-BC0104-add-str--
               FOR l_c=1 TO l_cn-1
                  IF l_rvv_a[l_c].flagg = 'Y' THEN
                     CALL s_qcl05_sel(l_rvv_a[l_c].rvv46) RETURNING l_qcl05
                     IF l_qcl05 ='1' THEN LET l_type1 ='5' ELSE LET l_type1 ='1' END IF
                     IF NOT s_iqctype_upd_qco20(l_rvv_a[l_c].rvv04,l_rvv_a[l_c].rvv05,l_rvv_a[l_c].rvv45,l_rvv_a[l_c].rvv47,l_type1) THEN
                        LET g_success ='N'
                     END IF
                  END IF           
               END FOR    
               #FUN-BC0104-add-end--
               IF NOT s_industry('std') THEN
                  IF NOT s_del_rvvi(g_rvu01,'',l_plant_new) THEN  #FUN-980092
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
  
            #刪除批/序號資料
            EXECUTE del_rvbsl USING 'apmt740',g_rvu01
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'   
               CALL s_errmsg('','',g_msg,STATUS,1)
               LET g_success='N'
            END IF

            #FUN-B90012-add-str--
            IF s_industry('icd') THEN 
               CALL icd_ida_del(g_rvu01,'',l_plant_new)
            END IF
            #FUN-B90012-add-end--
 
        END IF
        #更新銷單單頭資料
        #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092
        LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                   " SET oea62=oea62 - ? ",
                   " WHERE oea01 = ?  "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE upd_oea2 FROM l_sql2
        EXECUTE upd_oea2 USING l_oea62,l_ogb31
        IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
           LET g_msg = l_dbs_tra,'upd oea62'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
           END IF
           LET g_success = 'N'               
        END IF
        #No.MOD-B10097  --Begin
        #IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
        #    CALL p832_flow99(l_plant_new)   #FUN-980092
        #END IF
        #No.MOD-B10097  --End  
END FUNCTION

#FUN-A50102--mark--str-- 
#當有設定中斷工廠時，因中斷站只產生收貨資料，沒有出貨及入庫資料
#所以不能全部都一併處理,應再依此站己產生的單據來做為刪除的依據
#FUNCTION p832_poz(p_dbs)
#DEFINE p_dbs    LIKE type_file.chr21    
#DEFINE l_oea62  LIKE oea_file.oea62
#DEFINE l_sql2   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
#DEFINE l_sql3   LIKE type_file.chr1000  #FUN-560043  #No.FUN-680136 VARCHAR(1600)
#DEFINE i        LIKE type_file.num5
#DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
#DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
#DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
# 
#   LET l_oea62=0
#   DECLARE rvv_cus3 CURSOR FOR
#    SELECT * FROM rvv_file
#     WHERE rvv01 = g_rvu.rvu01 
#   FOREACH rvv_cus3 INTO g_rvv.*
#      IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
#      SELECT ima906 INTO g_ima906 FROM ima_file
#       WHERE ima01 = g_rvv.rvv31
#      IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
#          #因為可能分批入庫，若有其他入庫單共用此收貨單
#          #       則暫不刪除...
#          LET l_sql2 ="SELECT COUNT(*) ",
#                      " FROM ",p_dbs CLIPPED,"rvv_file",
#                      " WHERE rvv04 ='",g_rva01,"'",   #No.FUN-620025 
#                      "   AND rvv01 != '",g_rvu01,"'"
# 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#          PREPARE count_pre3 FROM l_sql2
#          DECLARE count_cs3 CURSOR FOR count_pre3
#          OPEN count_cs3
#          FETCH count_cs3 INTO g_rvv_cnt
#          IF cl_null(g_rvv_cnt) THEN LET g_rvv_cnt = 0 END IF
#          CLOSE count_cs3
#          IF g_rvv_cnt = 0 THEN
#               IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
#                   #刪除tlf檔(收貨單) -->p_dbs no.4526
#  ##NO.FUN-8C0131   add--begin   
#                   LET l_sql =  " SELECT  * FROM ",p_dbs CLIPPED,"tlf_file ", 
#                                " WHERE (tlf026 = ? ", 
#                                "   AND tlf027 = ?)",  
#                                "   AND (tlf036 = ? ", 
#                                "   AND tlf037 = ?)"     
#                   DECLARE p832_u_tlf_c4 CURSOR FROM l_sql
#                   LET l_i = 0 
#                   CALL la_tlf.clear()
#                   FOREACH p832_u_tlf_c4 USING g_rva02,g_rvv.rvv37,
#                                               g_rva01,g_rvv.rvv05  INTO g_tlf.*
#                      LET l_i = l_i + 1
#                      LET la_tlf[l_i].* = g_tlf.*
#                   END FOREACH     
#
#  ##NO.FUN-8C0131   add--end
#                   LET l_sql2="DELETE FROM ",p_dbs CLIPPED,"tlf_file",
#                              " WHERE (tlf026 = ? ",
#                              "   AND tlf027 = ?)", 
#                              "   AND (tlf036 = ? ",
#                              "   AND tlf037 = ?)" 
# 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#                   PREPARE del3_tlf3 FROM l_sql2
#                   EXECUTE del3_tlf3 USING g_rva02,g_rvv.rvv37,
#                                          g_rva01,g_rvv.rvv05
#                   IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#                       LET g_msg = p_dbs,'del tlf(rvb)'
#                      IF g_bgerr THEN
#                         CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
#                      ELSE
#                         CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
#                      END IF
#                       LET g_success='N'  
#                   END IF
#    ##NO.FUN-8C0131   add--begin
#                 FOR l_i = 1 TO la_tlf.getlength()
#                    LET g_tlf.* = la_tlf[l_i].*
#                    IF NOT s_untlf1(p_dbs) THEN 
#                       LET g_success='N' RETURN
#                    END IF 
#                 END FOR       
#  ##NO.FUN-8C0131   add--end  
#                   IF g_ima906 = '2' OR g_ima906 = '3' THEN
#                       #刪除tlff檔(收貨單) -->p_dbs
#                       LET l_sql3="DELETE FROM ",p_dbs CLIPPED,"tlff_file",
#                                  " WHERE (tlff026 = ? ",  
#                                  "   AND tlff027 = ?)",       #MOD-9C0353
#                                  "   AND (tlff036 = ? ",  
#                                  "   AND tlff037 = ?)"   
# 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
#                       PREPARE del3_tlff3 FROM l_sql3
#                       EXECUTE del3_tlff3 USING g_rva02,g_rvv.rvv37,
#                                               g_rva01,g_rvv.rvv05
#                       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#                           LET g_msg = p_dbs,'del tlff(rvb)'
#                          IF g_bgerr THEN
#                             CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
#                          ELSE
#                             CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
#                          END IF
#                           LET g_success='N'    
#                       END IF
#                   END IF
#              END IF
#          END IF
#          #刪除收貨單頭檔-->p_dbs
#          LET l_sql2="DELETE FROM ",p_dbs CLIPPED,"rva_file",
#                     " WHERE rva01= ? "   
# 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#          PREPARE del_rva3 FROM l_sql2
#          EXECUTE del_rva3 USING g_rva01      #No.FUN-620025 
#          IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#             LET g_msg = p_dbs,'del rva'
#             IF g_bgerr THEN
#                CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
#             ELSE
#                CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
#             END IF
#             LET g_success='N'  
#          END IF
#          #刪除收貨單身檔-->p_dbs
#          LET l_sql2="DELETE FROM ",p_dbs CLIPPED,"rvb_file",
#                     " WHERE rvb01= ? "      
# 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#          PREPARE del_rvb3 FROM l_sql2
#          EXECUTE del_rvb3 USING g_rva01
#          IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#              LET g_msg = p_dbs,'del rvb'
#             IF g_bgerr THEN
#                CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
#             ELSE
#                CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
#             END IF
#              LET g_success='N'  
#          ELSE     #No.FUN-7B0018 080304 add
#             IF NOT s_industry('std') THEN
#                IF NOT s_del_rvbi(g_rva01,'',p_dbs) THEN
#                   LET g_success = 'N'
#                END IF
#             END IF
#          END IF
#      END IF
#   END FOREACH
# 
#END FUNCTION
#FUN-A50102--mark--end--
 
#取得工廠資料并且 抓取要還原的單號
FUNCTION p832_azp(l_i)
  DEFINE l_i      LIKE type_file.num5,      #當站站別  #No.FUN-680136 SMALLINT
         l_sql1   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
 
     ##-------------取得當站資料庫(S/O)-----------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_i
 
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_dbs_new = s_dbstring(l_azp.azp03)  #TQC-950010 ADD  
      LET l_plant_new = g_poy.poy04            #FUN-980092
 
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
      LET l_sql1 = "SELECT aza50 ",                                                                                                 
                   #"  FROM ",l_dbs_new CLIPPED,"aza_file ",
                   "  FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                   "  WHERE aza01 = '0' "                                                                                           
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
      PREPARE aza_p1 FROM l_sql1                                                                                                    
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","aza_p1",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","aza_p1",1)
         END IF
      END IF
      DECLARE aza_c1  CURSOR FOR aza_p1                                                                                             
      OPEN aza_c1                                                                                                                   
      FETCH aza_c1 INTO l_aza50                                                                                                     
      CLOSE aza_c1                                                                                                                  
END FUNCTION
 
#取得要還原的單號
FUNCTION p832_getno(i)
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
            IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
               #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092
               LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                           "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                           "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
               PREPARE rvu01_pre FROM l_sql
               DECLARE rvu01_cs CURSOR FOR rvu01_pre
               OPEN rvu01_cs
               FETCH rvu01_cs INTO g_rvu01                              #入庫單
               IF SQLCA.SQLCODE THEN
                  LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
                  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  LET g_success = 'N'  
               END IF
            END IF
 
            #LET l_sql = " SELECT oga_file.* FROM ",l_dbs_tra CLIPPED,"oga_file ",#FUN-980092 
          LET l_sql = " SELECT oga_file.* FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                        "  WHERE oga99 ='",g_rvu.rvu99,"'",
                        "    AND oga09 = '6' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE oga01_pre FROM l_sql
            DECLARE oga01_cs CURSOR FOR oga01_pre
            OPEN oga01_cs
            FETCH oga01_cs INTO g_oga.*                                  #出貨單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               LET g_success = 'N'   
            END IF
END FUNCTION
 
FUNCTION p832_flow99(p_plant)   #FUN-980092
    DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
    DEFINE l_rvu99 LIKE rvu_file.rvu99
    DEFINE l_rva99 LIKE rva_file.rva99
    DEFINE l_count LIKE type_file.num5   #No.FUN-680136 SMALLINT
    DEFINE p_dbs   LIKE type_file.chr21  #No.FUN-680136 VARCHAR(21)
    DEFINE p_dbs_tra  LIKE type_file.chr21  #FUN-980092 
    DEFINE p_plant LIKE type_file.chr21     #FUN-980092 
    
     LET g_plant_new = p_plant    
     CALL s_getdbs()
     LET p_dbs=g_dbs_new
 
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
 
       #-CHI-A20005-mark-
       ##==>入庫單
       #LET l_count=0
       #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
       #            " WHERE rvu01= '",g_rvu.rvu01,"'"
       # CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       # CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
       #PREPARE count_rvu_pre FROM l_sql
       #DECLARE count_rvu CURSOR FOR count_rvu_pre
       #OPEN count_rvu        
       #FETCH count_rvu INTO l_count
       #IF l_count >=1 THEN
       #    #==>更新入庫單rvu99=NULL
       #    LET l_rvu99=NULL
       #    LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092
       #                "   SET rvu99 = ? ",
       #                " WHERE rvu01 = '",g_rvu.rvu01,"'"
       # CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       # CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
       #    PREPARE upd_rvu99 FROM l_sql
       #    EXECUTE upd_rvu99 USING l_rvu99
       #    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       #       IF g_bgerr THEN
       #          CALL s_errmsg("","","upd rvu99",SQLCA.sqlcode,1)
       #       ELSE
       #          CALL cl_err3("","","","",SQLCA.sqlcode,"","upd rvu99",1)
       #       END IF
       #       LET g_success = 'N' RETURN
       #    END IF
       #END IF
       #-CHI-A20005-end-
 
        #==>收貨單
        LET l_count = 0
        LET l_rva99 = NULL
        #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs_tra CLIPPED,"rvv_file",
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'rvv_file'), #FUN-A50102
                    " WHERE rvv04 = '",g_rvu.rvu02,"'",
                    "   AND rvv01 != '",g_rvu.rvu01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
        PREPARE count_rvv_pre FROM l_sql
        DECLARE count_rvv CURSOR FOR count_rvv_pre
        OPEN count_rvv        
        FETCH count_rvv INTO l_count
 
        #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"rva_file",
        LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'rva_file'), #FUN-A50102
                    "   SET rva99 = ?",
                    " WHERE rva01 = '",g_rvu.rvu02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
        PREPARE upd_rva99 FROM l_sql
        IF l_count >= 1 THEN
           #更新收貨單rva99=MAX(rvu99) 
           #LET l_sql = "SELECT MAX(rvu99) FROM ",p_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
           LET l_sql = "SELECT MAX(rvu99) FROM ",cl_get_target_table(p_plant,'rvu_file'), #FUN-A50102
                       " WHERE rvu02  = '",g_rvu.rvu02,"'",
                       "   AND rvu01 != '",g_rvu.rvu01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
           PREPARE max_rvu99_pre FROM l_sql
           DECLARE max_rvu99 CURSOR FOR max_rvu99_pre
           OPEN max_rvu99        
           FETCH max_rvu99 INTO l_rvu99
           IF SQLCA.SQLCODE THEN
              IF g_bgerr THEN
                 CALL s_errmsg("","","sel max_rva99",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","sel max_rva99",1)
              END IF
              LET g_success = 'N' RETURN
           END IF
 
           EXECUTE upd_rva99 USING l_rvu99
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              IF g_bgerr THEN
                 CALL s_errmsg("","","upd rva99",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","upd rva99",1)
              END IF
              LET g_success = 'N' RETURN
           END IF
        ELSE
           #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs_tra CLIPPED,"rva_file",  #FUN-980092
           LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'rva_file'), #FUN-A50102
                       " WHERE rva01= '",g_rvu.rvu02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
           PREPARE count_rva_pre FROM l_sql
           DECLARE count_rva CURSOR FOR count_rva_pre
           OPEN count_rva        
           FETCH count_rva INTO l_count
           IF l_count >=1 THEN
               #更新收貨單rva99=NULL
               LET l_rva99 = NULL
               EXECUTE upd_rva99 USING l_rva99
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_success = 'N' RETURN
               END IF
           END IF
        END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
