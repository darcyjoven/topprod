# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: apmp841.4gl
# Descriptions...: 三角貿易倉退單拋轉還原作業(正拋時使用)
# Date & Author..: 01/11/18 By Tommy 由 axmp901 改寫
# Modify.........: NO.FUN-560043 05/07/05 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.FUN-620025 06/02/15 By day 流通版多角貿易修改
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.MOD-680014 06/08/11 By Claire 還原時傳異動類別 '3' 表倉退至 s_mchkARAP 再給oma00='21'
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: NO.FUN-670007 06/09/11 by Yiting 
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-710030 07/01/23 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830035 08/03/18 By Claire 調整採購單資料取法不以對應的收貨單單頭,而是以倉退單單身資料
# Modify.........: No.FUN-830132 08/04/01 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-8C0046 08/12/05 By wujie  中間站不應該異動銷退單的庫存
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.TQC-970181 09/07/23 By destiny 1.選取rvv_file資料時條件缺少一個key                                            
#                                                    2.829行sql沒有declare,foreach會出錯 
# Modify.........: No.FUN-980081 09/08/19 By destiny 修改傳到s_mupimg里的參數
# Modify.........: No.TQC-980223 09/08/25 By sherry  如果多角貿易流程編號有倉庫別，則使用此倉庫                                                                 
# Modify.........: No.TQC-980231 09/08/31 By lilingyu "倉退單號"改為可開窗
# Modify.........: No.FUN-980059 09/09/14 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A20072 10/02/10 By Dido 給予 rvv33,rvv34 空白                                                                
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A40178 10/05/10 By Smapmin 修正MOD-8C0046
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A90100 11/01/20 By Smapmin 批序號管理拋轉還原倉退單時各站都應刪除批/序號內容
# Modify.........: No.FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加ICD行業功能
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao s_mupimg(的倒數第三個參數應該傳-1) 
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: No.CHI-C80009 12/08/22 By Sakura ICD相關處理1.ohbi_file欄位key錯修改2.最終站不需再處理倉退單
# Modify.........: No.FUN-C50136 12/08/27 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
# Modify.........: No.MOD-C80126 12/08/16 By jt_chen 修正倉退單號開窗選擇指定單號後，無法回傳於畫面

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
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8083
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE n_poy   RECORD LIKE poy_file.*    #FUN-670007
 
DEFINE tm RECORD
          rvu01  LIKE rvu_file.rvu01
       END RECORD
 
  DEFINE l_dbs_new      LIKE type_file.chr21  #No.FUN-680136 VARCHAR(21)    #New DataBase Name
  DEFINE l_dbs_tra      LIKE type_file.chr21  #FUN-980092 
  DEFINE l_plant_new    LIKE type_file.chr21  #No.FUN-980059 VARCHAR(21)   
  DEFINE n_dbs_new      LIKE type_file.chr21  #FUN-670007
  DEFINE s_azp  RECORD LIKE azp_file.*
  DEFINE l_azp  RECORD LIKE azp_file.*
  DEFINE n_azp  RECORD LIKE azp_file.*        #FUN-670007
  DEFINE g_sw     LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
  DEFINE g_argv1  LIKE rvu_file.rvu01
  DEFINE g_pmm50  LIKE pmm_file.pmm50
  DEFINE g_oha01  LIKE oha_file.oha01
  DEFINE l_aza50  LIKE aza_file.aza50      #No.FUN-620025
  DEFINE l_pmm01  LIKE pmm_file.pmm01      #No.FUN-620025
  DEFINE l_oea01  LIKE oea_file.oea01      #No.FUN-620025
  DEFINE g_oha05  LIKE oha_file.oha05      #No.FUN-620025
  DEFINE l_rvu02  LIKE rvu_file.rvu02      #No.FUN-620025
  DEFINE g_oha1018   LIKE oha_file.oha1018 #No.FUN-620025
  DEFINE g_rvu01  LIKE rvu_file.rvu01
  DEFINE p_last   LIKE type_file.num5         #No.FUN-680136 SMALLINT     #流程之最後家數
  DEFINE p_last_plant LIKE type_file.chr10   #No.FUN-680136 VARCHAR(10)  #No.TQC-6A0079
DEFINE   g_msg        LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE   g_flag       LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   g_ima906        LIKE ima_file.ima906   #FUN-560043
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
#  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'   #FUN-C50136

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_argv1 = ARG_VAL(1)

#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_argv1) THEN
      CALL cl_err('','apm-936',1)
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------

#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066 mark
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--

   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN
      CALL p841_p1()
   ELSE
      LET tm.rvu01 = g_argv1
      OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS
      CALL p841_p2()
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
 
FUNCTION p841_p1()
 DEFINE l_ac LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_i LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   OPEN WINDOW p841_w WITH FORM "apm/42f/apmp841"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   WHILE TRUE
      DISPLAY BY NAME tm.rvu01
      ERROR ''
 
      INPUT BY NAME tm.rvu01  WITHOUT DEFAULTS
 
         AFTER FIELD rvu01
            IF NOT cl_null(tm.rvu01) THEN
               SELECT * INTO g_rvu.*,g_rva.*
                  FROM rvu_file,rva_file
                 WHERE rvu01=tm.rvu01
                   AND rva01 = rvu02
                 AND rvu00 = '3'
                   AND rvu08 = 'TAP'  #no.6113
                   AND rvu20 = 'Y'
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","rvu_file,rva_file","","",STATUS,"","sel rvu",0)  #No.FUN-660129
                  NEXT FIELD rvu01
               END IF
            END IF
 
            ON ACTION controlp
              CASE
                WHEN INFIELD(rvu01) 
                   CALL cl_init_qry_var()
                  #LET g_qryparam.state = 'c'                #MOD-C80126 mark
                   LET g_qryparam.form ="q_rvu01_1"  
                   CALL cl_create_qry() RETURNING tm.rvu01   #MOD-C80126 g_qryparam.multiret -> tm.rvu01 
                  #DISPLAY g_qryparam.multiret TO rvu01      #MOD-C80126 mark
                   DISPLAY tm.rvu01 TO FORMONLY.rvu01        #MOD-C80126 add
                   NEXT FIELD rvu01 
              END CASE                       
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION CONTROLG call cl_cmdask()
 
            ON ACTION locale                    #genero
               LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT INPUT
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
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
 
       IF NOT cl_sure(0,0) THEN
          CONTINUE WHILE
       END IF
 
       CALL p841_p2()
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
 CLOSE WINDOW p841_w
 
END FUNCTION
 
FUNCTION p841_p2()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_sql3   LIKE type_file.chr1000  #FUN-560043  #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_oeb  RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_j    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_msg  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(60)
  DEFINE l_rvb29 LIKE rvb_file.rvb29,       #退貨量
         l_rvb31 LIKE rvb_file.rvb31        #可入庫量
  DEFINE l_ogb      RECORD LIKE ogb_file.*
  DEFINE l_oga01    LIKE oga_file.oga01
  DEFINE l_oga02    LIKE oga_file.oga02
  DEFINE l_sql4  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_poy02 LIKE poy_file.poy02 #NO.FUN-670007
  DEFINE l_c     LIKE type_file.num5   #No.FUN-680136 SMALLINT                  #NO.FUN-670007
  DEFINE k       LIKE type_file.num5   #NO.FUN-670007 
 
   CALL cl_wait()
   BEGIN WORK
   LET g_success='Y'
   LET s_oea62=0
 
     SELECT * INTO g_rvu.*,g_rva.*
       FROM rvu_file,rva_file
      WHERE rvu01 = tm.rvu01 AND rva01 = rvu02
	AND rvu00 = '3'
        AND rvu08 = 'TAP'  #no.6113
	AND rvu20 = 'Y'  #已拋轉
     IF SQLCA.SQLCODE THEN LET g_success='N' RETURN END IF
     IF cl_null(g_rva.rva02) THEN
        #只讀取第一筆採購單之資料
        LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
                    "  WHERE pmm01 = rvb04 ",
                    "    AND rvb01 = '",g_rva.rva01,"'"
        PREPARE pmm_pre FROM l_sql1
        DECLARE pmm_f CURSOR FOR pmm_pre
        OPEN pmm_f
        FETCH pmm_f INTO g_pmm.*
     ELSE
        #讀取該入庫單之採購訂單
        SELECT * INTO g_pmm.*
          FROM pmm_file
         WHERE pmm01 = g_rva.rva02
     END IF
     IF SQLCA.SQLCODE THEN
        CALL cl_err('sel pmm:',STATUS,1)
        LET g_success='N'
        RETURN
     END IF
     SELECT * INTO g_rvv.*
       FROM rvu_file,rvv_file
      WHERE rvu01 = g_rvu.rvu01 AND rvu01 = rvv01
        AND rvv02=1                                                   #No.TQC-970181
     LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvv_file ",
                 "  WHERE pmm01 = rvv36 ",
                 "    AND rvv01 = '",g_rvu.rvu01,"'"
     PREPARE pmm_pre2 FROM l_sql1
     DECLARE pmm_f2 CURSOR FOR pmm_pre2
     FOREACH pmm_f2 INTO g_pmm.*
     IF g_pmm.pmm906 = 'N' THEN
	CALL cl_err('','apm-012',1)
        LET g_success= 'N'
        RETURN
     END IF
     LET g_pmm50 = g_pmm.pmm50
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_pmm.pmm904,g_rvu.rvu03) THEN
        LET g_success='N'
        RETURN
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
 
     CALL s_mtrade_last_plant(g_pmm.pmm904)
          RETURNING p_last,p_last_plant       #記錄最後一筆之家數
     IF cl_null(p_last) THEN
        LET g_success = 'N'
        RETURN
     END IF
 
     END FOREACH   #FUN-830035 add
 
     #依流程代碼最多6層
     CALL s_showmsg_init()        #No.FUN-710030
         FOR i = 1 TO p_last
     IF g_success="N" THEN
        LET g_totsuccess="N"
        LET g_success="Y"
     END IF
           #得到廠商/客戶代碼及database
           CALL p841_azp(i)
           CALL p841_getno(i)                        #No.8106 取得還原單號
           IF s_mchkARAP(l_plant_new,g_rvu.rvu99,'3') THEN   #MOD-680014 modify #No.FUN-980059
              LET g_success = 'N' EXIT FOR
           END IF
           LET l_oea62=0
             CALL p841_p3(i)
     END FOR  {一個訂單流程代碼結束}
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
         #更新倉退單之拋轉否='N'
         UPDATE rvu_file
            SET rvu20 = 'N' ,
                rvu99 = ''       #No.8106
          WHERE rvu01 = g_rvu.rvu01
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg("rvu01",g_rvu.rvu01,"upd rvu:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","upd rvu:",1)
            END IF
         END IF
 
END FUNCTION
      
FUNCTION p841_p3(i)
DEFINE i  LIKE type_file.num5   
DEFINE l_rvb29 LIKE rvb_file.rvb29,   #退貨量
       l_rvb31 LIKE rvb_file.rvb31    #可入庫量
DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
DEFINE l_ogb   RECORD LIKE ogb_file.*
DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
DEFINE l_sql3  LIKE type_file.chr1000 #FUN-560043  #No.FUN-680136 VARCHAR(1600)
DEFINE l_sql4  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_oga02 LIKE oga_file.oga02
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_rvv   RECORD LIKE rvv_file.* #No.FUN-830132
DEFINE l_sql21 STRING                 #No.TQC-970181 
DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
#FUN-B90012-add-str---
DEFINE l_ogbiicd028  LIKE ogbi_file.ogbiicd028           
DEFINE l_ogbiicd029  LIKE ogbi_file.ogbiicd029           
DEFINE l_ohbiicd028   LIKE ohbi_file.ohbiicd028
DEFINE l_ohbiicd029   LIKE ohbi_file.ohbiicd029
DEFINE l_rvviicd02   LIKE rvvi_file.rvviicd02           
DEFINE l_rvviicd05   LIKE rvvi_file.rvviicd05
DEFINE l_oha02        LIKE oha_file.oha02
DEFINE b_rvv   RECORD LIKE rvv_file.*
DEFINE l_ogb_l RECORD LIKE ogb_file.*
DEFINE l_ohb   RECORD LIKE ohb_file.*
DEFINE l_flag  LIKE type_file.chr1            
#FUN-B90012-add-end--
#FUN-BC0104-add-str--
DEFINE l_rvv04  LIKE rvv_file.rvv04,
       l_rvv05  LIKE rvv_file.rvv05,
       l_rvv45  LIKE rvv_file.rvv45,
       l_rvv46  LIKE rvv_file.rvv46,
       l_rvv47  LIKE rvv_file.rvv47,
       l_flagg  LIKE type_file.chr1,
       l_qcl05  LIKE qcl_file.qcl05,
       l_type1  LIKE type_file.chr1
#FUN-BC0104-add-end--
#DEFINE l_oia07  LIKE oia_file.oia07   #FUN-C50136
#DEFINE l_oga03  LIKE oga_file.oga03   #FUN-C50136
#DEFINE l_oha03  LIKE oha_file.oha03   #FUN-C50136

    #-----MOD-A90100---------
    #刪除tlfs_file 
    LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlfs_file'),
           " WHERE tlfs01 = ? ",
           "   AND tlfs10 = ? ",
           "   AND tlfs11 = ? ",
           "   AND tlfs111 = ? "
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
    PREPARE del_tlfs FROM l_sql2

    #刪除批/序號資料檔(rvbs_file)
    LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'),
               " WHERE rvbs00 = ? ",
               "   AND rvbs01 = ? "
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2		
    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
    PREPARE del_rvbs FROM l_sql2
    #-----END MOD-A90100----- 
 
    #讀取倉退單身檔(rvv_file)
    DECLARE  rvv_cus CURSOR FOR
     SELECT * FROM rvv_file WHERE rvv01 = g_rvu.rvu01
    FOREACH rvv_cus INTO g_rvv.*
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        SELECT ima906 INTO g_ima906 FROM ima_file
         WHERE ima01 = g_rvv.rvv31
 
         DECLARE pmm_f1 CURSOR FOR 
          SELECT * FROM pmm_file 
                  WHERE pmm01 = g_rvv.rvv36
         OPEN pmm_f1
         FETCH pmm_f1 INTO g_pmm.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('sel pmm:',STATUS,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
 
        LET l_sql1 = "SELECT rvu02  ",                                         
                     #" FROM ",l_dbs_tra CLIPPED,"rvu_file ",   #FUN-980092
                     " FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                     " WHERE rvu99='",g_rvu.rvu99,"' "                              
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
        PREPARE rvu_p1 FROM l_sql1                                                  
        IF STATUS THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","rvu_p1",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","rvu_p1",1)
           END IF
        END IF
        DECLARE rvu_c1 CURSOR FOR rvu_p1                                            
        OPEN rvu_c1                                                                 
        FETCH rvu_c1 INTO l_rvu02                                           
        IF SQLCA.SQLCODE <> 0 THEN                                                  
           LET l_rvu02=''
        END IF                                                                      
        CLOSE rvu_c1                                                                
 
        IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND
                        g_poz.poz011 <> '2') THEN
            IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
                #刪除倉退單身檔-->l_dbs_new
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",
           LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-A50102
            DECLARE p841_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p841_u_tlf_c USING g_rvu01,g_rvv.rvv02,
                                       l_rvu02,g_rvv.rvv05  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
                #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-980092
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                           " WHERE (tlf026 = ? ",
                           "   AND tlf027 = ?)",
                           "   AND (tlf036 = ? ",
                           "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                PREPARE del1_tlf FROM l_sql2
                EXECUTE del1_tlf USING g_rvu01,g_rvv.rvv02,
                                       l_rvu02,    g_rvv.rvv05  #No.FUN-620025
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_msg = l_dbs_tra,'del tlf(rvv)'
                   LET g_success='N'
                   IF g_bgerr THEN
                      CALL s_errmsg("","",g_msg,STATUS,1)
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err3("","","","",STATUS,"",g_msg,1)
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


                #-----MOD-A90100---------
                EXECUTE del_tlfs USING g_rvv.rvv31,g_rvu01,g_rvv.rvv02,g_rvu.rvu03
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF
                #-----END MOD-A90100----- 
                
                #FUN-B90012-add-str--
                IF s_industry('icd') THEN
                   LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                                "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",",
                                          cl_get_target_table(l_plant_new,'rvvi_file'),
                                " WHERE rvv01 = '",g_rvu01,"'",
                                "   AND rvv02 = '",g_rvv.rvv02,"'",
                                "   AND rvv01 = rvvi01 ",
                                "   AND rvv02 = rvvi02 "
                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                   PREPARE b_rvv_p FROM l_sql2
                   EXECUTE b_rvv_p INTO b_rvv.*,l_rvviicd02,l_rvviicd05

                   CALL s_icdpost(12,b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                                    b_rvv.rvv34,b_rvv.rvv35,b_rvv.rvv17,
                                    g_rvu01,g_rvv.rvv02,g_rvu.rvu03,'N',
                                    b_rvv.rvv04,b_rvv.rvv05,l_rvviicd05,
                                    l_rvviicd02,l_plant_new)
                   RETURNING l_flag
                   IF l_flag = 0 THEN
                      LET g_success = 'N'
                   END IF
                END IF
                #FUN-B90012-add-end--                
                 
                IF g_ima906 = '2' OR g_ima906 = '3' THEN
                   #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092
                   LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
                              " WHERE (tlff026 = ? ",
                              "   AND tlff027 = ?)",
                              "   AND (tlff036 = ? ",
                              "   AND tlff037 = ?)"
                	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                   PREPARE del1_tlff FROM l_sql3
                   EXECUTE del1_tlff USING g_rvu01,g_rvv.rvv02,
                                           l_rvu02,    g_rvv.rvv05  #No.FUN-620025
                   IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                      LET g_msg = l_dbs_tra,'del tlff(rvv)'
                      LET g_success='N'
                      IF g_bgerr THEN
                         CALL s_errmsg("","",g_msg,STATUS,1)
                         CONTINUE FOREACH
                      ELSE
                         CALL cl_err3("","","","",STATUS,"",g_msg,1)
                         EXIT FOREACH
                      END IF
                   END IF
                END IF
            END IF
            # 抓取來源收貨單的退貨量與可入庫量更新rvb..
            SELECT rvb29,rvb31 INTO l_rvb29,l_rvb31 FROM rvb_file
             WHERE rvb01 = g_rvv.rvv04 AND rvb02 = g_rvv.rvv05
            IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
            IF cl_null(l_rvb31) THEN LET l_rvb31 = 0 END IF
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"rvb_file ",   #FUN-980092
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                       "   SET rvb29 = ?,",
                       "       rvb31 = ? ",
                       " WHERE rvb01 = '",l_rvu02,"'",      #No.FUN-620025
                       "   AND rvb02 = ",g_rvv.rvv05
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_rvb FROM l_sql2
            EXECUTE upd_rvb USING l_rvb29,l_rvb31
            #更新採購單身之入庫量及交貨量
            LET l_sql2 = " SELECT pmm01 ",
                        #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 
                        "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102                    
                        "  WHERE pmm99 = '",g_pmm.pmm99,"'"   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE pmm_prepare2 FROM l_sql2                                             
            DECLARE pmm_curs2 CURSOR FOR pmm_prepare2                                   
            OPEN pmm_curs2                                                              
            FETCH pmm_curs2 INTO l_pmm01
            IF SQLCA.sqlcode THEN                                                       
               IF g_bgerr THEN
                  CALL s_errmsg("","","fetch pmm_curs2",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch pmm_curs2",1)
               END IF
               LET g_success = 'N'                                                      
            END IF                                                                      
            CLOSE pmm_curs2                             
            LET l_sql2 = " SELECT oea01 ",
                        #"   FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 
                        "   FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102                     
                        "  WHERE oea99 = '",g_pmm.pmm99,"'"   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE oea_prepare2 FROM l_sql2                                             
            DECLARE oea_curs2 CURSOR FOR oea_prepare2                                   
            OPEN oea_curs2                                                              
            FETCH oea_curs2 INTO l_oea01
            IF SQLCA.sqlcode THEN                                                       
               IF g_bgerr THEN
                  CALL s_errmsg("","","fetch oea_curs2",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch oea_curs2",1)
               END IF
               LET g_success = 'N'                                                      
            END IF                                                                      
            CLOSE oea_curs2                             
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102 
                    " SET pmn58 = pmn58 - ? ",
                    " WHERE pmn01 = ? AND pmn02 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn FROM l_sql2
            EXECUTE upd_pmn USING
                    g_rvv.rvv17,
                    l_pmm01,g_rvv.rvv37        #No.FUN-620025
            IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_msg = l_dbs_tra,'upd pmn'
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,STATUS,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",STATUS,"",g_msg,1)
                  EXIT FOREACH
               END IF
            END IF
        END IF
 
        IF g_rvv.rvv31[1,4]<>'MISC' THEN  #No.8743
            #刪除銷退單身檔-->l_dbs_new
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ", 
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-A50102
            DECLARE p832_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c2  USING g_oha01,g_rvv.rvv02,
                                         g_oha01,g_rvv.rvv02  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
            #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-980092
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                       " WHERE (tlf026 = ? ",
                       "   AND tlf027 = ?)",
                       "   AND (tlf036 = ? ",
                       "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE del2_tlf FROM l_sql2
            EXECUTE del2_tlf USING g_oha01,g_rvv.rvv02,
                                   g_oha01,g_rvv.rvv02
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_msg = l_dbs_tra,'del tlf(ohb)'
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,STATUS,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",STATUS,"",g_msg,1)
                  EXIT FOREACH
               END IF
            END IF
    ##NO.FUN-8C0131   add--begin
            FOR l_i = 1 TO la_tlf.getlength()
               LET g_tlf.* = la_tlf[l_i].*
               #IF NOT s_untlf1(l_dbs_tra) THEN 
               IF NOT s_untlf1(l_plant_new) THEN   #FUN-A50102
                  LET g_success='N' RETURN
               END IF 
            END FOR       
  ##NO.FUN-8C0131   add--end 

            #-----MOD-A90100---------
            EXECUTE del_tlfs USING g_rvv.rvv31,g_oha01,g_rvv.rvv02,g_rvu.rvu03
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'
               CALL s_errmsg('','',g_msg,STATUS,1)
               LET g_success='N'
            END IF
            #-----END MOD-A90100-----  
            #FUN-B90012-add-str--
            IF s_industry('icd') THEN
              #LET l_sql2="SELECT ohb_file.*,l_ohbiicd028,l_ohbiicd029 ",          #CHI-C80009 mark
               LET l_sql2="SELECT ohb_file.*,ohbiicd028,ohbiicd029 ",              #CHI-C80009 add
                          "  FROM ",cl_get_target_table( l_plant_new,'ohb_file'),",",
                                   #cl_get_target_table( l_plant_new,'ohbi_fle'),  #CHI-C80009 mark
                                    cl_get_target_table( l_plant_new,'ohbi_file'), #CHI-C80009 add
                          " WHERE ohb01 = '",g_oha01,"'",
                          "   AND ohb03 = '",g_rvv.rvv02,"'",
                          "   AND ohb01 = ohbi01 ",
                          "   AND ohb03 = ohbi03 "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE l_ohb_p FROM l_sql2
               EXECUTE l_ohb_p INTO l_ohb.*,l_ohbiicd028,l_ohbiicd029
               LET l_sql2 = "SELECT oha02 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
                            " WHERE oha01 = '",g_oha01,"'"
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE l_oha_p FROM l_sql2
               EXECUTE l_oha_p INTO l_rvu02
               CALL s_icdpost(11,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                 l_ohb.ohb092,l_ohb.ohb05,l_ohb.ohb12,
                                 g_oha01,g_rvv.rvv02,l_oha02,
                                 'N',l_ohb.ohb31,l_ohb.ohb32,l_ohbiicd029,l_ohbiicd028,l_plant_new)
               RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-B90012-add-end--
            IF g_ima906 = '2' OR g_ima906 = '3' THEN
               #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092
               LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
                          " WHERE (tlff026 = ? ",
                          "   AND tlff027 = ?)",
                          "   AND (tlff036 = ? ",
                          "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
               PREPARE del2_tlff FROM l_sql3
               EXECUTE del2_tlff USING g_oha01,g_rvv.rvv02,
                                      g_oha01,g_rvv.rvv02
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_msg = l_dbs_tra,'del tlff(ohb)'
                  LET g_success='N'
                  IF g_bgerr THEN
                     CALL s_errmsg("","",g_msg,STATUS,1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("","","","",STATUS,"",g_msg,1)
                     EXIT FOREACH
                  END IF
               END IF
            END IF
        END IF
 
	#更新最終資料庫img及ima(幫銷退單做入帳還原的動作)
        #抓取扣帳的倉儲批.... no.4475
        IF (i = p_last AND cl_null(g_pmm50)) OR (i = p_last AND g_poz.poz011 = '2') THEN     #No.MOD-8C0046 
           LET l_sql2 = "SELECT ohb09,ohb091,ohb092 ",
                        #"  FROM ",l_dbs_tra,"ohb_file" ,       #FUN-980092
                        "  FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102  
                        " WHERE ohb01 ='",g_oha01,"'",
                        "   AND ohb03 =",g_rvv.rvv02
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE ohb09_pre FROM l_sql2
           DECLARE ohb09_cs CURSOR FOR ohb09_pre
           OPEN ohb09_cs
           FETCH ohb09_cs INTO g_rvv.rvv32,g_rvv.rvv33,g_rvv.rvv34
           IF STATUS THEN
              LET g_success='N'
              IF g_bgerr THEN
                 CALL s_errmsg("","","sel ohb09:",STATUS,1)
                 CONTINUE FOREACH
              ELSE
                 CALL cl_err3("","","","",STATUS,"","sel ohb09:",1)
                 EXIT FOREACH
              END IF
           END IF
        #END IF    #No.MOD-8C0046   #MOD-A40178往下移
        IF NOT cl_null(g_poy.poy11) THEN                                                                                            
           LET g_rvv.rvv32 = g_poy.poy11                                                                                            
           LET g_rvv.rvv33 = ' '           #MOD-A20072                                                                                             
           LET g_rvv.rvv34 = ' '           #MOD-A20072                                                                                 
        END IF                                                                                                                      
        CALL s_mupimg(-1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
	                 g_rvv.rvv34,g_rvv.rvv17*g_rvv.rvv35_fac,
                         #g_rvu.rvu03,l_plant_new,0,'','')  #FUN-980092    #MOD-A90100
                         g_rvu.rvu03,l_plant_new,-1,g_oha01,g_rvv.rvv02)  #FUN-980092    #MOD-A90100   #TQC-B90236
#CHI-C80009---mark---START
#       #FUN-B90012-add-str--
#       IF s_industry('icd') THEN
#          LET l_sql2 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table( l_plant_new,'rvvi_file'),
#                       " WHERE rvvi01 = '",g_oha01,"'",    
#                       "   AND rvvi02 = '",g_rvv.rvv02,"'"
#          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
#          CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
#          PREPARE l_rvvi_p FROM l_sql2
#          EXECUTE l_rvvi_p INTO l_rvviicd02,l_rvviicd05  

#          CALL s_icdpost(12,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,g_rvv.rvv34,
#                         g_rvv.rvv35,g_rvv.rvv17,g_oha01,g_rvv.rvv02,
#                         g_rvu.rvu03,'N',g_rvv.rvv04,g_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new) 
#             RETURNING l_flag
#          IF l_flag = 0 THEN
#             LET g_success = 'N'
#          END IF
#       END IF
#       #FUN-B90012-add-end--
#CHI-C80009---mark-----END
        IF g_ima906 = '2' THEN
           CALL s_mupimgg(-1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
	                    g_rvv.rvv34,g_rvv.rvv80,g_rvv.rvv82,
                            g_rvu.rvu03, l_plant_new)  #FUN-980092
           CALL s_mupimgg(-1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
	                    g_rvv.rvv34,g_rvv.rvv83,g_rvv.rvv85,
                            g_rvu.rvu03, l_plant_new)  #FUN-980092
        END IF
        IF g_ima906 = '3' THEN
           CALL s_mupimgg(-1,g_rvv.rvv31,g_rvv.rvv32,g_rvv.rvv33,
	                    g_rvv.rvv34,g_rvv.rvv83,g_rvv.rvv85,
                            g_rvu.rvu03, l_plant_new)  #FUN-980092
        END IF
        END IF    #MOD-A40178
        CALL s_mudima(g_rvv.rvv31,l_plant_new)   #FUN-980092
        IF g_success='N' THEN EXIT FOREACH END IF
        #讀取流程代碼中之銷單資料
        #LET l_sql2="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092
        LET l_sql2="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102  
                " WHERE oeb01 ='",l_oea01,"' ",
                "   AND oeb03 =",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE oeb_cu2  FROM l_sql2
        DECLARE oeb_p2 CURSOR FOR oeb_cu2
        OPEN oeb_p2
        FETCH oeb_p2 INTO l_oeb.*
        CLOSE oeb_p2
        IF SQLCA.sqlcode<>0 THEN
           LET g_success = 'N'
           IF g_bgerr THEN
              CALL s_errmsg("","","sel oeb_p2:",SQLCA.sqlcode,1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","sel oeb_p2:",1)
              EXIT FOREACH
           END IF
        END IF
       END FOREACH {rvv_cus}
 
#      #FUN-C50136--add-str--
#      IF g_oaz.oaz96 ='Y' THEN
#         LET l_sql2 = "SELECT oha03 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
#                      " WHERE oha01 = ? ",
#                      "   AND oha41='Y' ",
#                      "   AND (oha05 ='3' OR oha05 = '4')"
#         PREPARE sel_oha FROM l_sql2
#         EXECUTE sel_oha USING g_oha01 INTO l_oha03
#         CALL s_ccc_oia07('G',l_oha03) RETURNING l_oia07
#         IF l_oia07 = '0' THEN
#            CALL s_ccc_rback(l_oha03,'G',g_oha01,0,l_plant_new)
#         END IF
#      END IF
#      #FUN-C50136--add-end--
       #刪除銷退單單頭檔(oha_file)
       #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092
       LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                  " WHERE oha01= ?  ",
                  "   AND oha41='Y' ",    #三角貿易倉退單   #No.FUN-620025 
                  "   AND (oha05='3' OR oha05='4') "        #No.FUN-620025
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
       PREPARE del_oha FROM l_sql2
       EXECUTE del_oha USING g_oha01
       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          LET g_msg = l_dbs_tra,'del oha'
          IF g_bgerr THEN
             CALL s_errmsg("","",g_msg,STATUS,1)
          ELSE
             CALL cl_err3("","","","",STATUS,"",g_msg,1)
          END IF
          LET g_success='N'
       END IF
       #刪除銷退單身檔
       #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ohb_file", #FUN-980092
       LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102
                 " WHERE ohb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
       PREPARE del_ogb FROM l_sql2
       EXECUTE del_ogb USING g_oha01
       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          LET g_msg = l_dbs_tra,'del ohb'
          IF g_bgerr THEN
             CALL s_errmsg("","",g_msg,STATUS,1)
          ELSE
             CALL cl_err3("","","","",STATUS,"",g_msg,1)
          END IF
          LET g_success='N'
    #FUN-B70074-add-str--
       ELSE 
          IF NOT s_industry('std') THEN 
             IF NOT s_del_ohbi(g_oha01,'',l_plant_new) THEN 
                LET g_success='N'
             END IF 
          END IF
    #FUN-B70074-add-end--
       END IF
       #-----MOD-A90100---------
       #刪除批/序號資料
       EXECUTE del_rvbs USING 'axmt840',g_oha01
       IF SQLCA.SQLCODE THEN
          LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'
          CALL s_errmsg('','',g_msg,STATUS,1)
          LET g_success='N'
       END IF
       #-----END MOD-A90100-----
       #FUN-B90012-add-str--
       IF s_industry('icd') THEN
          CALL icd_ida_del(g_oha01,'',l_plant_new)  
       END IF
       #FUN-B90012-add-end--
 
       IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND
                          g_poz.poz011 <> '2') THEN
          #刪除倉退單頭檔-->l_dbs_new
          #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
          LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                   " WHERE rvu01= ? ",
                   "   AND rvu00='3'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
          PREPARE del_rvu FROM l_sql2
          EXECUTE del_rvu USING g_rvu01
          IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
             LET g_msg = l_dbs_tra,'del rvu'
             IF g_bgerr THEN
                CALL s_errmsg("","",g_msg,STATUS,1)
             ELSE
                CALL cl_err3("","","","",STATUS,"",g_msg,1)
             END IF
             LET g_success='N'
          END IF
          #刪除倉退單身檔-->l_dbs_new
          #LET l_sql2 = "SELECT * FROM ",l_dbs_tra CLIPPED,"rvv_file", #FUN-980092
          LET l_sql2 = "SELECT * FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
                       " WHERE rvv01= ? ",
                       "   AND rvv03='3'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
          PREPARE sel_rvv FROM l_sql2
          DECLARE rvv_p2 CURSOR FOR sel_rvv                    #No.TQC-970181
          FOREACH rvv_p2 USING g_rvu01 INTO l_rvv.*            #No.TQC-970181
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             CALL s_iqctype_rvv(l_rvv.rvv01,l_rvv.rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg   #FUN-BC0104
             #LET l_sql21 = " DELETE FROM ",l_dbs_tra CLIPPED,"rvv_file ",  #FUN-980092
             LET l_sql21 = " DELETE FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
                         "  WHERE rvv01 = ?",
                         "    AND rvv02 = ?"
 
 	     CALL cl_replace_sqldb(l_sql21) RETURNING l_sql21       #FUN-920032
             CALL cl_parse_qry_sql(l_sql21,l_plant_new) RETURNING l_sql21 #FUN-980092
             PREPARE del_rvv FROM l_sql21
             EXECUTE del_rvv USING l_rvv.rvv01,l_rvv.rvv02
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra,'del rvv'
                IF g_bgerr THEN
                   CALL s_errmsg("","",g_msg,STATUS,1)
                   CONTINUE FOREACH    #No.FUN-830132 add
                ELSE
                   CALL cl_err3("","","","",STATUS,"",g_msg,1)
                   CONTINUE FOREACH    #No.FUN-830132 add
                END IF
                LET g_success='N'
             ELSE
                #FUN-BC0104-add-str--
                IF l_flagg = 'Y' THEN 
                   CALL s_qcl05_sel(l_rvv46) RETURNING l_qcl05
                   IF l_qcl05='1' THEN LET l_type1='5' ELSE LET l_type1 ='1' END IF
                   IF NOT s_iqctype_upd_qco20(l_rvv04,l_rvv05,l_rvv45,l_rvv47,l_type1) THEN
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
                END IF
                #FUN-BC0104-add-end--
                IF NOT s_industry('std') THEN
                   IF NOT s_del_rvvi(l_rvv.rvv01,l_rvv.rvv02,l_plant_new) THEN  #FUN-980092
                      LET g_success = 'N'
                      CONTINUE FOREACH     #No.FUN-830132 add
                   END IF
                END IF
             END IF
          END FOREACH
          #-----MOD-A90100---------
          #刪除批/序號資料
          EXECUTE del_rvbs USING 'apmt742',g_rvu01
          IF SQLCA.SQLCODE THEN
             LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'
             CALL s_errmsg('','',g_msg,STATUS,1)
             LET g_success='N'
          END IF
          #-----END MOD-A90100-----
          #FUN-B90012-add-str--
          IF s_industry('icd') THEN
             CALL icd_idb_del(g_rvu01,'',l_plant_new)
          END IF
          #FUN-B90012-add-end--
       END IF
         
       IF l_aza50 = 'Y' THEN     #使用分銷功能
          IF g_oha05= '4'  THEN       #有代送出貨單生成
             #獲取代送出貨單資料
             #LET l_sql4 = " SELECT oga01,oga02,ogb_file.* FROM ",l_dbs_tra CLIPPED,  #FUN-980092
             #             "   oga_file,", l_dbs_tra CLIPPED, "ogb_file", 
             LET l_sql4 = " SELECT oga01,oga02,ogb_file.* FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          "     ,", cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102           
                          "  WHERE oga1012 ='",g_oha01,"'",   
                          "    AND oga00 = '1' ",
                          "    AND (oga10 IS NULL OR oga10 =' ' ) ",   #帳單編號必須為null
                          "    AND oga01 = ogb01 "
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
             PREPARE oga01_pre FROM l_sql4
             DECLARE oga01_cs CURSOR FOR oga01_pre
             OPEN oga01_cs 
             FETCH oga01_cs INTO l_oga01,l_oga02,l_ogb.*  #代送之出貨單
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
                IF g_bgerr THEN
                   CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                END IF
                LET g_success = 'N'
             END IF
 
             #刪除tlf檔(出貨單) -->l_dbs_new 
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ", 
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-A50102
            DECLARE p832_u_tlf_c4 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c4 USING l_oga01,l_ogb.ogb03,
                                        l_oga01,l_ogb.ogb03  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
             #LET l_sql4="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092
             LET l_sql4="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                        " WHERE (tlf026 = ?  ",
                        "   AND  tlf027 = ?) ",
                        "   AND (tlf036 = ?  ",
                        "   AND  tlf037 = ?) "
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
             PREPARE del0_tlf FROM l_sql4
             EXECUTE del0_tlf USING l_oga01,l_ogb.ogb03,l_oga01,l_ogb.ogb03       
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN 
                LET g_msg = l_dbs_tra CLIPPED,'del tlf'
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
             #-----MOD-A90100---------
             EXECUTE del_tlfs USING l_ogb.ogb04,l_oga01,l_ogb.ogb03,l_oga02
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'
                CALL s_errmsg('','',g_msg,STATUS,1)
                LET g_success='N'
             END IF
             #-----END MOD-A90100-----  
             #FUN-B90012-add-str--
             IF s_industry('icd') THEN
                LET l_sql2 = "SELECT ogb_file.*,ogbiicd028,ogbiicd029 ",
                             "  FROM ",cl_get_target_table(l_plant_new,'ogb_file'),",",
                                       cl_get_target_table(l_plant_new,'ogbi_file'),
                             " WHERE ogb01 = '",l_oga01,"'",
                             "   AND ogb03 = '",l_ogb.ogb03,"'",
                             "   AND ogb01 = ogbi01 ",
                             "   AND ogb03 = ogbi03 "
                CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                PREPARE l_ogb_p FROM l_sql2
                EXECUTE l_ogb_p INTO l_ogb_l.*,l_ogbiicd028,l_ogbiicd029
    
                CALL s_icdpost(12,l_ogb_l.ogb04,l_ogb_l.ogb09,
                                  l_ogb_l.ogb091,l_ogb_l.ogb092,
                                  l_ogb_l.ogb05,l_ogb_l.ogb12,
                                  l_oga01,l_ogb.ogb03,l_oga02,
                                  'N','','',l_ogbiicd028,l_ogbiicd029,l_plant_new)
                RETURNING l_flag
                IF l_flag = 0 THEN
                   LET g_success = 'N'
                END IF
             END IF
             #FUN-B90012-add-end--
             #刪除tlff檔(出貨單) -->l_dbs_tra
             IF g_ima906 = '2' OR g_ima906 = '3' THEN
                #LET l_sql4="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092
                LET l_sql4="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                           " WHERE (tlff026 = ? ",
                           "   AND tlff027 = ?) ",
                           "   AND (tlff036 = ? ",
                           "   AND tlff037 = ?) "
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
                PREPARE del_tlf2 FROM l_sql4
                EXECUTE del_tlf2 USING l_oga01,l_ogb.ogb03,l_oga01,l_ogb.ogb03     
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
                CALL s_mupimg(1,l_ogb.ogb04, l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                              #l_ogb.ogb12*l_ogb.ogb15_fac,l_oga02,l_plant_new,0,'','')  #FUN-980092    #MOD-A90100
                              l_ogb.ogb12*l_ogb.ogb15_fac,l_oga02,l_plant_new,-1,l_ogb.ogb01,l_ogb.ogb03)  #FUN-980092    #MOD-A90100  #TQC-B90236
                #FUN-B90012-add-str--
                IF s_industry('icd') THEN
                   LET l_sql2 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
                                " WHERE ogbi01 = '",l_ogb.ogb01,"'",
                                "   AND ogbi03 = '",l_ogb.ogb03,"'"
                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                   PREPARE l_ogbi_p FROM l_sql2
                   EXECUTE l_ogbi_p INTO l_ogbiicd028,l_ogbiicd029

                   CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb05,l_ogb.ogb12,l_ogb.ogb01,l_ogb.ogb03,
                                  l_oga02,'N','','',l_ogbiicd029,l_ogbiicd028,l_plant_new) 
                      RETURNING l_flag
                   IF l_flag = 0 THEN
                      LET g_success = 'N'
                   END IF
                END IF
                #FUN-B90012-add-end--
                IF g_ima906 = '2' THEN
                   CALL s_mupimgg(1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb910,l_ogb.ogb912,l_oga02,l_plant_new)   #FUN-980092
                   CALL s_mupimgg(1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb913,l_ogb.ogb915,l_oga02,l_plant_new)   #FUN-980092
                END IF
                IF g_ima906 = '3' THEN
                   CALL s_mupimgg(1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb913,l_ogb.ogb915,l_oga02,l_plant_new)   #FUN-980092
                END IF
                CALL s_mudima(l_ogb.ogb04,l_plant_new)  #FUN-980092
             END IF
 
#            #FUN-C50136--add-str--
#            IF g_oaz.oaz96 ='Y' THEN
#               LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                            " WHERE oga01 = ? ",
#                            "   AND oga09 ='2'"
#               PREPARE sel_oga FROM l_sql2
#               EXECUTE sel_oga USING l_oga01 INTO l_oga03
#               CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#               IF l_oia07 = '0' THEN
#                  CALL s_ccc_rback(l_oga03,'D',l_oga01,0,l_plant_new)
#               END IF
#            END IF
#            #FUN-C50136--add-end--
             #刪除出貨單資料
             #LET l_sql4="DELETE FROM ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092
             LET l_sql4="DELETE FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                        " WHERE oga01= ?  ",
                        "   AND oga09='2' "     
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
             PREPARE del_oga FROM l_sql4
             EXECUTE del_oga USING l_oga01
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra CLIPPED,'del oga.'
                IF g_bgerr THEN
                   CALL s_errmsg("","",g_msg,STATUS,1)
                ELSE
                   CALL cl_err3("","","","",STATUS,"",g_msg,1)
                END IF
                LET g_success='N'
             END IF
             #LET l_sql4="DELETE FROM ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092  
             LET l_sql4="DELETE FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102        
                        " WHERE ogb01= ? "
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
             PREPARE del_ogb1 FROM l_sql4
             EXECUTE del_ogb1 USING l_oga01
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra CLIPPED,'del ogb.'
                IF g_bgerr THEN
                   CALL s_errmsg("","",g_msg,STATUS,1)
                ELSE
                   CALL cl_err3("","","","",STATUS,"",g_msg,1)
                END IF
                LET g_success='N'
             ELSE
                IF NOT s_industry('std') THEN
                   IF NOT s_del_ogbi(l_oga01,'',l_plant_new) THEN  #FUN-980092
                      LET g_success = 'N'
                   END IF
                END IF
             END IF
             #-----MOD-A90100---------
             #刪除批/序號資料
             EXECUTE del_rvbs USING 'axmt620',l_oga01
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'
                CALL s_errmsg('','',g_msg,STATUS,1)
                LET g_success='N'
             END IF
             #-----END MOD-A90100-----
             #FUN-B90012-add-str--
             IF s_industry('icd') THEN
                CALL icd_idb_del(l_oga01,'',l_plant_new)  
             END IF
             #FUN-B90012-add-end--
          END IF
       END IF
 
END FUNCTION
 
#取得工廠資料並且 抓取要還原的單號
FUNCTION p841_azp(l_i)
  DEFINE l_i      LIKE type_file.num5,      #當站站別  #No.FUN-680136 SMALLINT
         l_sql1   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(800)
         l_next   LIKE poy_file.poy02    #FUN-670007
 
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
FUNCTION p841_getno(i)
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
     IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102  
                    "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                    "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rvu01_pre FROM l_sql
        DECLARE rvu01_cs CURSOR FOR rvu01_pre
        OPEN rvu01_cs
        FETCH rvu01_cs INTO g_rvu01                              #倉退單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
           IF g_bgerr THEN
              CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
           END IF
           LET g_success = 'N'
        END IF
     END IF
 
     #LET l_sql = " SELECT oha01,oha05,oha1018 FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092 
     LET l_sql = " SELECT oha01,oha05,oha1018 FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102  
                 "  WHERE oha99 ='",g_rvu.rvu99,"'",
                 "    AND (oha05 = '3' OR oha05 = '4') "   #No.FUN-620025
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oha01_pre FROM l_sql
     DECLARE oha01_cs CURSOR FOR oha01_pre
     OPEN oha01_cs
     FETCH oha01_cs INTO g_oha01,g_oha05,g_oha1018         #No.FUN-620025
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'
       IF g_bgerr THEN
          CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
       END IF
        LET g_success = 'N'
     END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
