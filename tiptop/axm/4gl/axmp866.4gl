# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp866.4gl
# Descriptions...: 三角貿易銷退單逆拋還原作業(逆拋時使用)
# Date & Author..: 98/12/14 By Linda
# Modify ........: 00/02/25 By Kammy 由 axmp901 改寫
# Modify.........: No:8981 04/01/29 By ching 增加銷退單逆拋功能
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/07 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.MOD-5B0324 05/11/30 By Nicola 逆拋還原有錯
# Modify.........: NO.FUN-620024 06/02/22 By yoyo  增加代送出貨單
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.MOD-670117 06/07/27 By Claire s_mupimg應調整為入庫
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........; NO.FUN-710019 06/12/25 by Yiting
# Modify.........: NO.MOD-680020 06/12/27 By Mandy 當單頭的出貨單沒有輸入時,抓單身任何一筆出貨單
# Modify.........: No.FUN-710046 07/01/24 By Jackho 增加批處理錯誤統整功能
# Modify.........: NO.TQC-7C0157 07/12/21 BY Yiting 沒有處理到中斷點問題
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/04/01 By hellen 修改delete rvv_file
# Modify.........: No.MOD-840033 08/04/03 By Claire 更新pmn58,oeb25條件調整
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-930083 09/03/09 By rainy FUN-830132 修改delete rvv_file錯誤,未處理跨資料庫問題
# Modify.........: No.MOD-930270 09/04/03 By Dido sel_rvv cursor 少了 DECLARE
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()          
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_mupimg傳參修改營運中心改成機構別
# Modify.........: No.MOD-990016 09/09/01 By Dido 營運中心調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-9C0071 10/01/18 By huangrh 精簡程式
# Modify.........: No.CHI-990031 09/09/16 By chenmoyan 調用s_mupimg時p_no改傳單號,p_line改傳單號項次
#                                                      刪除批序號的資料
# Modify.........: No:MOD-A30088 10/03/15 By Smapmin 延續MOD-850181,將update oeb25的段落拿掉
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A50102 10/06/12 by lixh1  跨庫統一用cl_get_target_table()實現  
# Modify.........: No.FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加ICD行業功能
# Modify.........: No.TQC-B90236 11/10/28 By zhuhao s_mupimg(的倒數第三個參數應該傳1)
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: No:MOD-C40015 12/04/26 By Vampire 沒有刪除apmt742的tlfs
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: No.CHI-C80009 12/08/22 By Sakura ICD相關處理1.ohbi_file欄位key錯修改
# Modify.........: No:CHI-CC0007 12/12/06 By Summer 代採逆拋有中斷點情況,銷退單拋轉還原判斷已存在來源站倉退單不可還原 
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cmd           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   g_forupd_sql STRING
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_oha   RECORD LIKE oha_file.*
DEFINE g_ohb   RECORD LIKE ohb_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_oaq   RECORD LIKE oaq_file.*
DEFINE tm RECORD
          oha05  LIKE oha_file.oha05,
          oha01  LIKE oha_file.oha01
       END RECORD
DEFINE g_poz       RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy       RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_dbs_new   LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)  #New DataBase Name
DEFINE l_dbs_new   LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra   LIKE type_file.chr21   #FUN-980092 
DEFINE l_plant_new     LIKE type_file.chr21  #No.FUN-980020
DEFINE g_rva01     LIKE rva_file.rva01
DEFINE g_rvu01     LIKE rvu_file.rvu01
DEFINE g_rvu03     LIKE rvu_file.rvu03       #CHI-C80009 add
DEFINE g_oha01     LIKE oha_file.oha01
DEFINE t_oha01     LIKE oha_file.oha01
DEFINE g_ofa01     LIKE ofa_file.ofa01
DEFINE s_azp       RECORD LIKE azp_file.*
DEFINE l_azp       RECORD LIKE azp_file.*
DEFINE g_sw        LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE g_argv1     LIKE oha_file.oha01
DEFINE g_argv2     LIKE oha_file.oha05
DEFINE oha_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE rva_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE rvu_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE g_ima906 LIKE ima_file.ima906   #FUN-560043
DEFINE l_oga01  LIKE oga_file.oga01
DEFINE l_oga02  LIKE oga_file.oga02
DEFINE g_oha05  LIKE oga_file.oga05
DEFINE l_ogb    RECORD LIKE ogb_file.*
DEFINE l_aza    RECORD LIKE aza_file.*
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN EXIT PROGRAM  END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN EXIT PROGRAM  END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_argv1) THEN
      CALL cl_err('','apm-936',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------
#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #TQC-D30066
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN
       CALL p866_p1()
    ELSE
       LET tm.oha01 = g_argv1
       LET tm.oha05 = g_argv2
       CALL cl_wait()
       BEGIN WORK
       LET g_success='Y'
       CALL p866_p2()
       CALL s_showmsg()          #No.FUN-710046
       IF g_success = 'Y'
         THEN CALL cl_cmmsg(1) COMMIT WORK
         ELSE CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
    END IF
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p866_p1()
 DEFINE l_i,l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p866_w WITH FORM "axm/42f/axmp866"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 WHILE TRUE
    LET g_action_choice = ''
    LET tm.oha05='2'
    DISPLAY BY NAME tm.oha05,tm.oha01
    INPUT BY NAME tm.oha05,tm.oha01  WITHOUT DEFAULTS HELP 1
 
         AFTER FIELD oha05
            IF cl_null(tm.oha05) THEN
               NEXT FIELD oha05
            END IF
            IF tm.oha05 NOT MATCHES '[23]' THEN
               NEXT FIELD oha05
            END IF
         AFTER FIELD oha01
            IF cl_null(tm.oha01) THEN
               NEXT FIELD oha01
            END IF
            SELECT * INTO g_oha.*
               FROM oha_file
              WHERE oha01=tm.oha01
                AND oha05 IN ('4',tm.oha05)    #No.FUN-620024
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oha_file",tm.oha01,"",SQLCA.SQLCODE,"","sel oha",1)   #No.FUN-660167
               NEXT FIELD oha01
            END IF
            IF NOT cl_null(g_oha.oha10) THEN
               CALL cl_err(g_oha.oha10,'axm-310',0)
               NEXT FIELD oha01
            END IF
            IF g_oha.oha41='N' OR g_oha.oha41 IS NULL THEN
               CALL cl_err(g_oha.oha41,'tri-014',0)
               NEXT FIELD oha01
            END IF
            IF g_oha.oha43='N' THEN
               CALL cl_err(g_oha.oha43,'apm-015',0)
               NEXT FIELD oha01
            END IF
            IF g_oha.oha44 <>'Y' THEN
               CALL cl_err(g_oha.oha44,'tri-012',0)
               NEXT FIELD oha01
            END IF
        ON ACTION locale
           LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT INPUT
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE WHILE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN
      CALL cl_wait()
      BEGIN WORK
      LET g_success='Y'
      CALL p866_p2()
      CALL s_showmsg()          #No.FUN-710046
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
  CLOSE WINDOW p866_w
END FUNCTION
 
FUNCTION p866_p2()
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3  LIKE type_file.chr1000 #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oeb   RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  DEFINE l_x     LIKE type_file.chr3    #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE p_last  LIKE type_file.num5    #No.FUN-680137 SMALLINT     #流程之最後家數
  DEFINE p_last_plant LIKE imd_file.imd01  #No.FUN-680137 VARCHAR(10)
  DEFINE l_poy02 LIKE poy_file.poy02    #no.TQC-7C0157 add
  DEFINE l_c     LIKE type_file.num5    #no.TQC-7C0157 add
  DEFINE l_rvv   RECORD LIKE rvv_file.* #No.FUN-830132
  DEFINE l_pmm01 LIKE pmm_file.pmm01   #MOD-840033
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  #FUN-B90012--add--start---
  DEFINE l_ohbiicd028  LIKE ohbi_file.ohbiicd028  
  DEFINE l_ohbiicd029  LIKE ohbi_file.ohbiicd029     
  DEFINE l_ohb  RECORD LIKE ohb_file.*            
  DEFINE l_flag        LIKE type_file.chr1        
  DEFINE l_rvv_1 RECORD LIKE rvv_file.*           
  DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02  
  DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05  
  #FUN-B90012--add---end--- 
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
# DEFINE l_oga03  LIKE oga_file.oga03  #FUN-C50136
# DEFINE l_oha03  LIKE oha_file.oha03  #FUN-C50136
# DEFINE l_oia07  LIKE oia_file.oia07  #FUN-C50136
  DEFINE l_rvu01 LIKE rvu_file.rvu01              #CHI-CC0007 add

   LET s_oea62=0
     SELECT * INTO g_oha.*
       FROM oha_file
      WHERE oha01=tm.oha01
        AND oha05 IN (tm.oha05,'4')  
        
     IF SQLCA.SQLCODE THEN
        CALL cl_err3("sel","oha_file",tm.oha01,"",status,"","sel oha",1)   #No.FUN-660167
        LET g_success='N' RETURN
     END IF
     IF NOT cl_null(g_oha.oha10) THEN
        CALL cl_err(g_oha.oha10,'axm-310',0) LET g_success='N' RETURN
     END IF
     IF g_oha.oha41='N' OR g_oha.oha41 IS NULL THEN
        CALL cl_err(g_oha.oha41,'tri-014',0) LET g_success='N' RETURN
     END IF
     IF g_oha.oha43='N' THEN
        CALL cl_err(g_oha.oha43,'apm-015',0) LET g_success='N' RETURN
     END IF
     IF g_oha.oha44 <>'Y' THEN
        CALL cl_err(g_oha.oha44,'tri-012',0) LET g_success='N' RETURN
     END IF
 
     IF cl_null(g_oha.oha16) THEN 
         #抓單身任何一筆出貨單號
         SELECT MAX(ohb31) INTO g_oha.oha16 FROM ohb_file
          WHERE ohb01 = g_oha.oha01
     END IF
 
     #讀取該銷退單之出貨單資料
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01 = g_oha.oha16
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err3("sel","oga_file",g_oha.oha16,"",status,"","sel oga",1)   #No.FUN-660167
        LET g_success='N' RETURN
     END IF
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                    "  WHERE oea01 = ogb31 ",
                    "   AND ogb01 = '",g_oga.oga01,"'",  #No.MOD-5B0324
                    "    AND oeaconf = 'Y' " #01/08/16 mandy
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該銷退單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
           AND oeaconf = 'Y' #01/08/16 mandy
     END IF
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err('sel oea',STATUS,1) LET g_success='N' RETURN
     END IF
     IF g_oea.oea902 = 'N' THEN #訂單不為最終流程訂單!
	CALL cl_err('','tri-022',1) LET g_success = 'N' RETURN
     END IF
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oha.oha02) THEN
        LET g_success='N' RETURN
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_oea.oea904
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"",'axm-318',"","",1)   #No.FUN-660167
         LET g_success = 'N' RETURN
     END IF
     IF tm.oha05 = '2' AND g_poz.poz00='2' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1) LET g_success = 'N' RETURN
     END IF
     IF tm.oha05 = '3' AND g_poz.poz00='1' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1) LET g_success = 'N' RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN
         CALL cl_err(g_oea.oea904,'tri-009',1) LET g_success = 'N' RETURN
     END IF
     IF g_poz.poz011 = '1' THEN
        CALL cl_err('','axm-412',1) LET g_success = 'N' RETURN
     END IF
 
     CALL s_showmsg_init()   #No.FUN-710046
     CALL s_tri_last(g_oea.oea904)     #No.8640
     RETURNING p_last,p_last_plant       #記錄最後一筆之家數
 
     #依流程代碼最多6層
     FOR i = p_last TO 0 STEP -1
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF             
          IF i = p_last THEN CONTINUE FOR END IF
           #得到廠商/客戶代碼及database
           CALL p866_azp(i)
           LET l_c = 0
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
             FROM poy_file
           WHERE poy01 = g_poz.poz01
             AND poy04 = g_poz.poz18
 
           SELECT poy02 INTO l_poy02
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           IF g_poz.poz19 = 'Y' AND l_c > 0  THEN
              IF i < =l_poy02 THEN    #目前站別小於等於設定中斷點的營運中心時
                 #CHI-CC0007 add --start--
                 IF tm.oha05 = '3' THEN
                    #檢查是否存在中斷點站倉退單
                    LET l_rvu01=''
                    LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( l_plant_new, 'rvu_file' ),
                                "  WHERE rvu99 ='",g_oha.oha99,"'",
                                "    AND rvu00 = '3' "
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                    PREPARE rvu01_p FROM l_sql
                    DECLARE rvu01_c CURSOR FOR rvu01_p
                    OPEN rvu01_c
                    FETCH rvu01_c INTO l_rvu01
                    IF NOT cl_null(l_rvu01) THEN
                        LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_c'
                        LET g_showmsg=l_rvu01,"/",g_oha.oha99
                        CALL s_errmsg('rvu01,rvu99',g_showmsg,g_msg,'apm1084',1)
                        LET g_success='N'
                    END IF
                 END IF
                 #CHI-CC0007 add --end--
                  EXIT FOR 
              END IF
           END IF
           CALL p866_getno(i)                       #No.8047 取得還原單號
 
           #---------------------先還原 tlf_file-----------------------
           LET l_oea62=0
           #讀取銷退單身檔(ohb_file)
           DECLARE  ohb_cus CURSOR FOR
              SELECT *
                FROM ohb_file
               WHERE ohb01 = g_oha.oha01
           FOREACH ohb_cus INTO g_ohb.*
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
             SELECT ima906 INTO g_ima906 FROM ima_file
                     WHERE ima01 = g_ohb.ohb04
 
             #取得訂單的流程序號
              LET l_sql1= " SELECT * ",
                        #  "   FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092    #FUN-A50102
                          "   FROM ",cl_get_target_table( l_plant_new, 'oea_file' ),   #FUN-A50102
                          "  WHERE oea01 = '",g_ohb.ohb33,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
              PREPARE oea99_pre FROM l_sql1
              DECLARE oea99_cus CURSOR FOR oea99_pre
              OPEN oea99_cus
              FETCH oea99_cus INTO g_oea.*
             #No.CHI-990031 --Begin
             #刪除批/序號異動資料檔(tlfs_file)
            #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlfs_file",    #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlfs_file' ),   #FUN-A50102
                         " WHERE tlfs01 = ? ",
                         "   AND tlfs10 = ? ",      
                         "   AND tlfs11 = ? ",
                         "   AND tlfs111 = ? "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
              PREPARE del_tlfsl FROM l_sql2
             #No.CHI-990031 --End
 
              IF (tm.oha05 = '2' OR (tm.oha05='3' AND i <> 0) ) AND  #No.8047
                  g_ohb.ohb04[1,4]<>'MISC'    THEN #No.8743
                 #刪除tlf檔(銷退單)-->l_dbs_tra
  ##NO.FUN-8C0131   add--begin   
                 # LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",    #FUN-A50102
                  LET l_sql =  " SELECT  * FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),    #FUN-A50102       
                               " WHERE (tlf026 = ? ", 
                               "   AND tlf027 = ?)",  
                               "   AND (tlf036 = ? ", 
                               "   AND tlf037 = ?)" 
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
                  CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
                  DECLARE p866_u_tlf_c CURSOR FROM l_sql
                  LET l_i = 0 
                  CALL la_tlf.clear()
                  FOREACH p866_u_tlf_c  USING g_oha01,g_ohb.ohb03,
                                              g_oha01,g_ohb.ohb03  INTO g_tlf.* 
                     LET l_i = l_i + 1
                     LET la_tlf[l_i].* = g_tlf.*
                  END FOREACH     

  ##NO.FUN-8C0131   add--end
                  #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092   #FUN-A50102
                  LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                             " WHERE (tlf026 = ? ",
                             "   AND tlf027 = ?)",
                             "   AND (tlf036 = ? ",
                             "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE del_tlf FROM l_sql2
                  EXECUTE del_tlf USING g_oha01,g_ohb.ohb03,
                                        g_oha01,g_ohb.ohb03        #no.6178
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                     LET g_msg = l_dbs_tra CLIPPED,'del tlf'
                     LET g_showmsg=g_oha01,"/",g_ohb.ohb03,"/",g_oha01,"/",g_ohb.ohb03
                     CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                     LET g_success='N'
                     EXIT FOREACH
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
               #No.CHI-990031 --Begin
               #刪除批/序號異動資料檔(tlfs_file)
                  EXECUTE del_tlfsl USING g_ohb.ohb04,g_oha.oha01,g_ohb.ohb03,g_oha.oha02
                  IF SQLCA.SQLCODE THEN
                     LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'
                     CALL s_errmsg('','',g_msg,STATUS,1)
                     LET g_success='N'
                  END IF
                #FUN-B90012-add-str--
                IF s_industry('icd') THEN
                  #LET l_sql2="SELECT ohb_file.*,l_ohbiicd028,l_ohbiicd029 ",             #CHI-C80009 mark
                   LET l_sql2="SELECT ohb_file.*,ohbiicd028,ohbiicd029 ",                 #CHI-C80009 add
                              "  FROM ",cl_get_target_table( l_plant_new,'ohb_file'),",",
                                       #cl_get_target_table( l_plant_new,'ohbi_fle'),     #CHI-C80009 mark
                                        cl_get_target_table( l_plant_new,'ohbi_file'),    #CHI-C80009 add
                             #" WHERE ohb01 = '",g_oha.oha01,"'",                         #CHI-C80009 mark
                              " WHERE ohb01 = '",g_oha01,"'",                             #CHI-C80009 add
                              "   AND ohb03 = '",g_ohb.ohb03,"'",
                              "   AND ohb01 = ohbi01 ",
                              "   AND ohb03 = ohbi03 "
                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                   PREPARE l_ohb_p FROM l_sql2
                   EXECUTE l_ohb_p INTO l_ohb.*,l_ohbiicd028,l_ohbiicd029

                   CALL s_icdpost(11,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                     l_ohb.ohb092,l_ohb.ohb05,l_ohb.ohb12,
                                    #g_oha.oha01,g_ohb.ohb03,g_oha.oha02, #CHI-C80009 mark 
                                     g_oha01,g_ohb.ohb03,g_oha.oha02,     #CHI-C80009 add
                                     'N',l_ohb.ohb31,l_ohb.ohb32,l_ohbiicd029,l_ohbiicd028,l_plant_new)
                   RETURNING l_flag
                   IF l_flag = 0 THEN
                      LET g_success = 'N'
                   END IF               
                END IF
                #FUN-B90012-add-end-- 
               #No.CHI-990031 --End
                IF g_ima906 = '2' OR g_ima906 = '3' THEN
                 # LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092   #FUN-A50102
                  LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
                             " WHERE (tlff026 = ? ",
                             "   AND tlff027 = ?)",
                             "   AND (tlff036 = ? ",
                             "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                  PREPARE del_tlff FROM l_sql3
                  EXECUTE del_tlff USING g_oha01,g_ohb.ohb03,
                                         g_oha01,g_ohb.ohb03
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                     LET g_msg = l_dbs_tra CLIPPED,'del tliff'
                     LET g_showmsg=g_oha01,"/",g_ohb.ohb03,"/",g_oha01,"/",g_ohb.ohb03
                     CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                     LET g_success='N'
                     EXIT FOREACH
                  END IF
                END IF
              END IF #No.8047(end)
          IF g_ohb.ohb04[1,4]<>'MISC' THEN  #No.8743

              #MOD-C40015 add start -----
              #刪除批/序號異動資料檔(tlfs_file)
              LET l_sql="DELETE FROM ",cl_get_target_table(l_plant_new,'tlfs_file'),
                        " WHERE tlfs01 = ? ",
                        "   AND tlfs10 = ? ",
                        "   AND tlfs11 = ? ",
                        "   AND tlfs111 = ? "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
              PREPARE del_tlfsl_2 FROM l_sql
              #MOD-C40015 add end    -----

              #刪除tlf檔(倉退單) -->l_dbs_new no.3568 01/10/22
  ##NO.FUN-8C0131   add--begin   
           # LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",    #FUN-A50102
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
            CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102             
            DECLARE p866_u_tlf_c1 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p866_u_tlf_c1 USING g_rvu01,g_ohb.ohb03,
                                        g_rvu01,g_ohb.ohb03  INTO g_tlf.* 
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
             # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092  #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ",
                         "   AND tlf027 = ?)",
                         "   AND (tlf036 = ? ",
                         "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE del3_tlf FROM l_sql2
              EXECUTE del3_tlf USING g_rvu01,g_ohb.ohb03,    #no.6178
                                     g_rvu01,g_ohb.ohb03
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,'del tlf3'
                 LET g_showmsg=g_rvu01,"/",g_ohb.ohb03,"/",g_rvu01,"/",g_ohb.ohb03
                 CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                 LET g_success='N'
                 EXIT FOREACH
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
            #MOD-C40015 add start -----
            EXECUTE del_tlfsl_2 USING g_ohb.ohb04,g_rvu01,g_ohb.ohb03,g_oha.oha02
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'del tlfs:'
               CALL s_errmsg('','',g_msg,STATUS,1)
               LET g_success='N'
            END IF
            #MOD-C40015 add end    -----
            #FUN-B90012-add-str--
            IF s_industry('icd') THEN
               LET l_sql2 = "SELECT * FROM ",cl_get_target_table(l_plant_new,'rvv_file'),
                            " WHERE rvv01 = '",g_rvu01,"' ",
                            "   AND rvv02 = '",g_ohb.ohb03,"' "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE rvv_rvv_1 FROM l_sql2
               EXECUTE rvv_rvv_1 INTO l_rvv_1.*

               LET l_sql2 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),
                            " WHERE rvvi01 = '",g_rvu01,"' ",
                            "   AND rvvi02 = '",g_ohb.ohb03,"' "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE rvvicd_rvv_1 FROM l_sql2
               EXECUTE rvvicd_rvv_1 INTO l_rvviicd02,l_rvviicd05

               CALL s_icdpost(12,l_rvv_1.rvv31,l_rvv_1.rvv32,l_rvv_1.rvv33,l_rvv_1.rvv34,
                              l_rvv_1.rvv35,l_rvv_1.rvv17,g_rvu01,g_ohb.ohb03,
                             #g_oha.oha99,'N',l_rvv_1.rvv04,l_rvv_1.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
                              g_rvu03,'N',l_rvv_1.rvv04,l_rvv_1.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
               RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-B90012-add-end--
            IF g_ima906 = '2' OR g_ima906 = '3' THEN
              #LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file",  #FUN-980092  #FUN-A50102
              LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
                         " WHERE (tlff026 = ? ",
                         "   AND tlff027 = ?)",
                         "   AND (tlff036 = ? ",
                         "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
              PREPARE del3_tlff FROM l_sql3
              EXECUTE del3_tlff USING g_rvu01,g_ohb.ohb03,
                                      g_rvu01,g_ohb.ohb03
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,'del tlff3'
                 LET g_showmsg=g_rvu01,"/",g_ohb.ohb03,"/",g_rvu01,"/",g_ohb.ohb03
                 CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                 LET g_success='N'
                 EXIT FOREACH
              END IF
            END IF
          END IF
              # 代採買替來源廠做入庫還原
              IF tm.oha05 = '3' AND i = 0 THEN             #No.9059
                 #抓取扣帳的倉儲批.... no.4475
                 LET l_sql2 = "SELECT rvv32,rvv33,rvv34 ",
                              #"  FROM ",l_dbs_tra CLIPPED,"rvv_file" ,  #FUN-980092   #FUN-A50102
                              "  FROM ",cl_get_target_table( l_plant_new, 'rvv_file' ),   #FUN-A50102
                              " WHERE rvv01 ='",g_rvu01,"'",
                              "   AND rvv02 =",g_ohb.ohb03
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                 PREPARE rvv32_pre FROM l_sql2
                 DECLARE rvv32_cs CURSOR FOR rvv32_pre
                 OPEN rvv32_cs
                 FETCH rvv32_cs INTO g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092
                 IF SQLCA.SQLCODE <> 0  THEN
                    LET g_msg = l_dbs_tra CLIPPED,'sel rvv32'
                    LET g_showmsg=g_rvu01,"/",g_ohb.ohb03
                    CALL s_errmsg('rvv01,rvv02',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                    LET g_success='N' EXIT FOREACH
                 END IF
                 CALL s_mupimg(1,g_ohb.ohb04,   #MOD-670117 
                                  g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092,
                                   g_ohb.ohb12*g_ohb.ohb15_fac, #MOD-4B0148
                              #    g_oha.oha02,l_plant_new,0,'','')  #FUN-980092 #No.CHI-990031
                                  #g_oha.oha02,l_plant_new,0,g_ohb.ohb01,g_ohb.ohb03) #No.CHI-990031 #TQC-B90236
                                  g_oha.oha02,l_plant_new,1,g_ohb.ohb01,g_ohb.ohb03) #No.CHI-990031 #TQC-B90236
                 #FUN-B90012-add-str--
                 IF s_industry('icd') THEN
                    LET l_sql2 = "SELECT ohbiicd028,ohbiicd029 FROM ",cl_get_target_table( l_plant_new,'ohbi_file'),
                                 " WHERE ohbi01 = '",g_ohb.ohb01,"'",
                                 "   AND ohbi03 = '",g_ohb.ohb03,"'" 
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                    PREPARE l_ohbi_p FROM l_sql2
                    EXECUTE l_ohbi_p INTO l_ohbiicd028,l_ohbiicd029

                    CALL s_icdpost(11,g_ohb.ohb04,g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092,
                                  g_ohb.ohb05,g_ohb.ohb12,g_ohb.ohb01,g_ohb.ohb03,
                                  g_oha.oha02,'N',g_ohb.ohb31,g_ohb.ohb32,l_ohbiicd029,
                                  l_ohbiicd028,l_plant_new)
                       RETURNING l_flag
                    IF l_flag = 0 THEN
                       LET g_success = 'N'
                    END IF
                 END IF
                 #FUN-B90012-add-end--
                 IF g_ima906='2' THEN
                    CALL s_mupimgg(1,g_ohb.ohb04,   #MOD-670117 -1->1
                                     g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092,
                                     g_ohb.ohb910,g_ohb.ohb912,
                                     g_oha.oha02,
                                     l_plant_new)  #FUN-980092
                    CALL s_mupimgg(1,g_ohb.ohb04,   #MOD-670117 -1->1
                                     g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092,
                                     g_ohb.ohb913,g_ohb.ohb915,
                                     g_oha.oha02,
                                     l_plant_new)  #FUN980092
                 END IF
                 IF g_ima906='3' THEN
                    CALL s_mupimgg(1,g_ohb.ohb04,   #MOD-670117 -1->1
                                     g_ohb.ohb09,g_ohb.ohb091,g_ohb.ohb092,
                                     g_ohb.ohb913,g_ohb.ohb915,
                                     g_oha.oha02,
                                     l_plant_new)  #FUN-980092
                 END IF
                 CALL s_mudima(g_ohb.ohb04,l_plant_new)   #FUN-980092
              END IF
              IF NOT p866_chkoeo(g_ohb.ohb33,
                                 g_ohb.ohb34,g_ohb.ohb04) THEN #No.7742
                   #更新採購單身之入庫量及交貨量
                    LET l_sql1= " SELECT pmm01 ",
                               # "   FROM ",l_dbs_tra CLIPPED,"pmm_file ",	#FUN-980092   #FUN-A50102
                                "   FROM ",cl_get_target_table( l_plant_new, 'pmm_file' ),   #FUN-A50102
                                "  WHERE pmm99 = '",g_oea.oea99,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
                    PREPARE pmm01_pre FROM l_sql1
                    DECLARE pmm01_cus CURSOR FOR pmm01_pre
                    OPEN pmm01_cus
                    FETCH pmm01_cus INTO l_pmm01
                   #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092   #FUN-A50102
                   LET l_sql2="UPDATE ",cl_get_target_table( l_plant_new, 'pmn_file' ),   #FUN-A50102
                           " SET pmn58 = pmn58 - ? ",
                           " WHERE pmn01 = ? AND pmn02 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                   PREPARE upd_pmn FROM l_sql2
                   EXECUTE upd_pmn USING
                          g_ohb.ohb12,
                          l_pmm01,g_ohb.ohb34       #MOD-840033
                   IF SQLCA.sqlcode<>0 THEN
                      LET g_msg = l_dbs_tra CLIPPED,'upd pmn'
                      LET g_showmsg=g_ohb.ohb33,"/",g_ohb.ohb34      #No.FUN-710046
                      CALL s_errmsg('pmn01,pmn02',g_showmsg,g_msg,SQLCA.SQLCODE,1) #No.FUN-710046
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
              END IF #No.7742(end)
 
              IF tm.oha05 = '2' OR (tm.oha05='3' AND i <> 0) THEN #No.8047
                  #讀取流程代碼中之銷單資料
                 # LET l_sql2="SELECT *  FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092   #FUN-A50102
                 LET l_sql2="SELECT *  FROM ",cl_get_target_table( l_plant_new, 'oeb_file' ),   #FUN-A50102
                          " WHERE oeb01 ='",g_ohb.ohb33,"' ",
                          "   AND oeb03 =",g_ohb.ohb34
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE oeb_cu2  FROM l_sql2
                  DECLARE oeb_p2 CURSOR FOR oeb_cu2
                  OPEN oeb_p2
                  FETCH oeb_p2 INTO l_oeb.*
                  CLOSE oeb_p2
                  IF SQLCA.sqlcode<>0 THEN
                      LET g_showmsg=g_ohb.ohb33,"/",g_ohb.ohb34
                      CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p2',SQLCA.sqlcode,1) 
                      LET g_success = 'N'
                      EXIT FOREACH
                  END IF
                  #-----MOD-A30088---------
                  #IF NOT p866_chkoeo(g_ohb.ohb33,
                  #                   g_ohb.ohb34,g_ohb.ohb04) THEN #No.7742
                  #   #更新銷單資料
                  #   LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092
                  #           " SET oeb25=oeb25 - ? ",
                  #           " WHERE oeb01 = ? AND oeb03 = ? "
 	          #   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  #   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  #   PREPARE upd_oeb2 FROM l_sql2
                  #   EXECUTE upd_oeb2 USING
                  #           g_ohb.ohb12, g_oea.oea01,g_ohb.ohb34  #MOD-840033
                  #   IF SQLCA.sqlcode<>0 THEN
                  #       LET g_showmsg=g_ohb.ohb33,"/",g_ohb.ohb34
                  #       CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb25',SQLCA.sqlcode,1) 
                  #       LET g_success = 'N'
                  #       EXIT FOREACH
                  #   END IF
                  #   LET l_oea62 = l_oea62 + g_ohb.ohb12*l_oeb.oeb13
                  #END IF  #No.7742(end)
                  #-----END MOD-A30088-----
              END IF      #No.8047(end)
           IF l_aza.aza50='Y' THEN     #使用分銷功能
              IF g_oha05='4' THEN
              #   LET l_sql = " SELECT oga01,oga02,ogb_file.* FROM ",l_dbs_tra CLIPPED,  #FUN-980092     #FUN-A50102
               #              "oga_file,", l_dbs_tra CLIPPED, "ogb_file",       #FUN-A50102
                 LET l_sql = " SELECT oga01,oga02,ogb_file.* FROM ",     #FUN-A50102
                             cl_get_target_table( l_plant_new, 'oga_file' ),",",  #FUN-A50102
                             cl_get_target_table( l_plant_new, 'ogb_file' ),    #FUN-A50102
                             "  WHERE oga1012 ='",g_oha01,"'",   
                             "    AND oga00 = '1' ",
                             "    AND (oga10 IS NULL OR oga10 =' ' ) ",   
                             "    AND oga01 = ogb01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE oga01_pre FROM l_sql
                 DECLARE oga01_cs CURSOR FOR oga01_pre
                 OPEN oga01_cs 
                 FETCH oga01_cs INTO l_oga01,l_oga02,l_ogb.* 
                 IF SQLCA.SQLCODE THEN
                    LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
                    CALL s_errmsg('oga1012',g_oha01,g_msg,SQLCA.SQLCODE,1) 
                    LET g_success = 'N'
                 END IF

  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",   #FUN-A50102
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
            CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
            DECLARE p866_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p866_u_tlf_c2  USING l_oga01,l_ogb.ogb03,
                                         l_oga01,l_ogb.ogb03  INTO g_tlf.* 
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
              #   LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092    #FUN-A50102
                 LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                            " WHERE (tlf026 = ? ",
                            "   AND tlf027 = ?)",
                            "   AND (tlf036 = ? ",
                            "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                 PREPARE del0_tlf FROM l_sql2
                 EXECUTE del0_tlf USING l_oga01,l_ogb.ogb03,l_oga01,l_ogb.ogb03   
                 IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN 
                    LET g_msg = l_dbs_tra CLIPPED,'del tlf'
                    LET g_showmsg=l_oga01,"/",l_ogb.ogb03,"/",l_oga01,"/",l_ogb.ogb03
                    CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                    LET g_success='N'
                 END IF
    ##NO.FUN-8C0131   add--begin
            FOR l_i = 1 TO la_tlf.getlength()
               LET g_tlf.* = la_tlf[l_i].*
               #IF NOT s_untlf1(l_dbs_tra) THEN 
               IF NOT s_untlf1(l_plant_new) THEN #FUN-A50102
                  LET g_success='N' RETURN
               END IF 
            END FOR       
  ##NO.FUN-8C0131   add--end 
    
                 IF g_ima906 = '2' OR g_ima906 = '3' THEN
                   # LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file", #FUN-980092   #FUN-A50102
                    LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
                               " WHERE (tlff026 = ? ",
                               "   AND tlff027 = ?)",
                               "   AND (tlff036 = ? ",
                               "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                    PREPARE del_tlf2 FROM l_sql3
                    EXECUTE del_tlf2 USING l_oga01,l_ogb.ogb03,l_oga01,l_ogb.ogb03 
                    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                       LET g_msg = l_dbs_tra CLIPPED,'del tlff'
                       LET g_showmsg=l_oga01,"/",l_ogb.ogb03,"/",l_oga01,"/",l_ogb.ogb03
                       CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                       LET g_success='N'
                    END IF
                  END IF
 
                # #FUN-C50136--add-str--
                # IF g_oaz.oaz96 ='Y' THEN
                #    LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
                #                 " WHERE oga01 = ? ",
                #                 "   AND oga09 ='2'"
                #    PREPARE sel_oga FROM l_sql2
                #    EXECUTE sel_oga USING l_oga01 INTO l_oga03
                #    CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
                #    IF l_oia07 = '0' THEN
                #       CALL s_ccc_rback(l_oga03,'D',l_oga01,0,l_plant_new)
                #    END IF
                # END IF
                # #FUN-C50136--add-end--
                 # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092   #FUN-A50102
                  LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),   #FUN-A50102
                             " WHERE oga01= ? ",
                             "   AND oga09='2'   "     
         	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE del_oga FROM l_sql2
                  EXECUTE del_oga USING l_oga01
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                     LET g_msg = l_dbs_tra CLIPPED,'del oga:'
                     CALL s_errmsg('oga01',l_oga01,g_msg,STATUS,1) 
                     LET g_success='N'
                  END IF
                #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogb_file",   #FUN-A50102
                  LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogb_file' ),   #FUN-A50102
                             " WHERE ogb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE del_ogb FROM l_sql2
                  EXECUTE del_ogb USING l_oga01
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                     LET g_msg = l_dbs_tra CLIPPED,'del ogb:'
                     CALL s_errmsg('ogb01',l_oga01,g_msg,STATUS,1) 
                     LET g_success='N'
                  ELSE
                     IF NOT s_industry('std') THEN
                        IF NOT s_del_ogbi(l_oga01,'',l_plant_new) THEN  #FUN-980092
                           LET g_success = 'N'
                        END IF
                     END IF
                  END IF
                END IF
              END IF
           END FOREACH {ohb_cus}
                 
           #-------------------刪除各單據資料-------------------
           IF tm.oha05 = '2' OR (tm.oha05='3' AND i <> 0) THEN #No.8047
              ##FUN-C50136--add-str--
              #IF g_oaz.oaz96 ='Y' THEN
              #   LET l_sql2 = "SELECT oha03 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
              #                " WHERE oha01 = ? ",
              #                "   AND oha05 IN ('4','",tm.oha05,"')"
              #   PREPARE sel_oha FROM l_sql2
              #   EXECUTE sel_oha USING g_oha01 INTO l_oha03
              #   CALL s_ccc_oia07('G',l_oha03) RETURNING l_oia07
              #   IF l_oia07 = '0' THEN
              #      CALL s_ccc_rback(l_oha03,'G',g_oha01,0,l_plant_new)
              #   END IF
              #END IF
              ##FUN-C50136--add-end--
               #刪除銷退單單頭檔(oha_file)
              # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092   #FUN-A50102
               LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                          " WHERE oha01= ? ",
                          "   AND oha05 IN ( '4','",tm.oha05,"')"    
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_oha FROM l_sql2
               EXECUTE del_oha USING g_oha01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del oha'
                  LET  g_showmsg=g_oha01,"/",tm.oha05
                  CALL s_errmsg('oha01,oha05',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                  LET g_success='N'
               END IF
               #刪除銷退單身檔
              # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ohb_file",  #FUN-980092   #FUN-A50102
               LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ohb_file' ),   #FUN-A50102
                         " WHERE ohb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_ohb FROM l_sql2
               EXECUTE del_ohb USING g_oha01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del ohb'
                  CALL s_errmsg('ohb01',g_oha01,g_msg,SQLCA.SQLCODE,1) 
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
           END IF #No.8047(end)
          #No.CHI-990031 --Begin
          #刪除批/序號資料          
          # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file",    #FUN-A50102
           LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'rvbs_file' ),   #FUN-A50102
                      " WHERE rvbs00 = ? ",
                      "   AND rvbs01 = ? "
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
           CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
           PREPARE del_rvbsl FROM l_sql2
               
           EXECUTE del_rvbsl USING 'axmt840',g_oha01 
           IF SQLCA.SQLCODE THEN
              LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'
              CALL s_errmsg('','',g_msg,STATUS,1)
              LET g_success='N'
           END IF
          #No.CHI-990031 --End
           #FUN-B90012-add-str--
           IF s_industry('icd') THEN
              CALL icd_ida_del(g_oha01,'',l_plant_new)
           END IF
           #FUN-B90012-add-end--
           #刪除入庫單頭檔-->l_dbs_tra
         #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092   #FUN-A50102
           LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'rvu_file' ),   #FUN-A50102
                    " WHERE rvu01= ? ",
                    "   AND rvu00='3'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_rvu FROM l_sql2
           EXECUTE del_rvu USING g_rvu01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              LET g_msg = l_dbs_tra CLIPPED,'del rvu'
              CALL s_errmsg('rvu01',g_rvu01,g_msg,SQLCA.SQLCODE,1) 
              LET g_success='N'
           END IF
 
           CALL s_iqctype_rvv(l_rvv.rvv01,l_rvv.rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg   #FUN-BC0104
           #刪除入庫單身檔-->l_dbs_tra
          # LET l_sql2 = "SELECT * FROM ",l_dbs_tra CLIPPED,"rvv_file",  #FUN-980092   #FUN-A50102
           LET l_sql2 = "SELECT * FROM ",cl_get_target_table( l_plant_new, 'rvv_file' ),   #FUN-A50102
                        " WHERE rvv01= ? ",
                        "   AND rvv03='3'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE sel_rvv FROM l_sql2
           DECLARE sel_cur CURSOR FOR sel_rvv          #MOD-930270 add
           FOREACH sel_cur USING g_rvu01 INTO l_rvv.*  #MOD-930270 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              #FUN-BC0104-add-str--
              IF l_flagg = 'Y' THEN
                 CALL s_qcl05_sel(l_rvv46) RETURNING l_qcl05
                 IF l_qcl05='1' THEN LET l_type1='5' ELSE LET l_type1='1' END IF
                 IF NOT s_iqctype_upd_qco20(l_rvv04,l_rvv05,l_rvv45,l_rvv47,l_type1) THEN
                    LET g_success='N'
                    CONTINUE FOREACH
                 END IF
              END IF
              #FUN-BC0104-add-end--
              #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvv_file",  #FUN-980092   #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'rvv_file' ),   #FUN-A50102
                         " WHERE rvv01= ? ",
                         "   AND rvv02= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE del_rvv FROM l_sql2
              EXECUTE del_rvv USING  l_rvv.rvv01,l_rvv.rvv02
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,'del rvv'
                 CALL s_errmsg('rvv01',g_rvu01,g_msg,SQLCA.SQLCODE,1) 
                 LET g_success='N'
                 CONTINUE FOREACH      #No.FUN-830132 080401 add
              ELSE
                 IF NOT s_industry('std') THEN
                    IF NOT s_del_rvvi(l_rvv.rvv01,l_rvv.rvv02,l_plant_new) THEN  #FUN-980092
                       LET g_success = 'N'
                    END IF
                 END IF
              END IF
             #No.CHI-990031 --Begin
             #刪除批/序號資料
             # LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file",    #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'rvbs_file' ),   #FUN-A50102
                         " WHERE rvbs00 = ? ",
                         "   AND rvbs01 = ? "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
              PREPARE del_rvbs2 FROM l_sql2
                         
              EXECUTE del_rvbs2 USING 'apmt742',l_rvv.rvv01
              IF SQLCA.SQLCODE THEN
                 LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'
                 CALL s_errmsg('','',g_msg,STATUS,1)
                 LET g_success='N'
              END IF
             #No.CHI-990031 --End
              #FUN-B90012-add-str--
              IF s_industry('icd') THEN
                 CALL icd_idb_del(l_rvv.rvv01,'',l_plant_new)
              END IF
              #FUN-B90012-add-end--
             #No.CHI-990031 --End
           END FOREACH                 #No.FUN-830132 080401 add
       END FOR
       IF g_totsuccess="N" THEN                                                                                                         
          LET g_success="N"                                                                                                             
       END IF 
 
       MESSAGE ''
       #更新銷退單之拋轉否='N'
       UPDATE oha_file
          SET oha44 ='N',
              oha99 = ' '         #No.8047
        WHERE oha41 ='Y'          #三角貿易銷退單
          AND oha01 = g_oha.oha01
       IF SQLCA.SQLCODE <> 0 THEN
          CALL s_errmsg('oha01',g_oha.oha01,'upd oha:',SQLCA.SQLCODE,0)
       END IF
       CALL p866_flow99()         #No.8047
END FUNCTION
 
#取得工廠資料
FUNCTION p866_azp(l_n)
  DEFINE l_source LIKE type_file.num5,    #No.FUN-680137 SMALLINT    #來源站別
         l_sql1   LIKE type_file.chr1000,   #No.FUN-620024  #No.FUN-680137 VARCHAR(800)
         l_n      LIKE type_file.num5           #當站站別  #No.FUN-680137 SMALLINT
 
     ##-------------取得當站資料庫----------------------
      SELECT * INTO g_poy.* FROM poy_file                  #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_n
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950032 ADD       
   
     #------GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = g_poy.poy04
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣                                                                
                  #" FROM ",l_dbs_new CLIPPED,"aza_file ",  #FUN-A50102 
                  " FROM ",cl_get_target_table( l_plant_new, 'aza_file' ),   #FUN-A50102
                  " WHERE aza01 = '0' "                                                                                             
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
     PREPARE aza_p1 FROM l_sql1                                                                                                     
     IF SQLCA.SQLCODE THEN 
        CALL s_errmsg('aza01','0','aza_p1',SQLCA.SQLCODE,1) 
     END IF                                                             
     DECLARE aza_c1  CURSOR FOR aza_p1                                                                                              
     OPEN aza_c1                                                                                                                    
     FETCH aza_c1 INTO l_aza.*                                                                                                      
     CLOSE aza_c1   
 
END FUNCTION
 
FUNCTION p866_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
 # LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_tra,"oeo_file ",  #FUN-980092    #FUN-A50102
  LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oeo_file' ),   #FUN-A50102
            "  WHERE oeo01 = '",p_oeo01,"'",
            "    AND oeo03 = '",p_oeo03,"'",
            "    AND oeo04 = '",p_oeo04,"'",
            "    AND oeo08 = '2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
  PREPARE chkoeo_pre FROM l_sql
  DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
  OPEN chkoeo_cs FETCH chkoeo_cs INTO g_cnt
  IF g_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
 
#取得要還原的單號
FUNCTION p866_getno(l_n)
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE l_n   LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    # LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092    #FUN-A50102
     LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( l_plant_new, 'rvu_file' ),   #FUN-A50102
                 "  WHERE rvu99 ='",g_oha.oha99,"'",
                 "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvu01_pre FROM l_sql
     DECLARE rvu01_cs CURSOR FOR rvu01_pre
     OPEN rvu01_cs
     FETCH rvu01_cs INTO g_rvu01                              #倉退單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
        CALL s_errmsg('rvu99',g_oha.oha99,g_msg,SQLCA.SQLCODE,1) 
        LET g_success = 'N'
     END IF
 
  IF tm.oha05 = '2' OR (tm.oha05='3' AND l_n <> 0) THEN #No.8047
    # LET l_sql = " SELECT oha01,oha05 FROM ",l_dbs_tra CLIPPED,"oha_file ",    #FUN-980092    #FUN-A50102
     LET l_sql = " SELECT oha01,oha05 FROM ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                 "  WHERE oha99 ='",g_oha.oha99,"'",
                 "    AND oha05 IN ('4', '",tm.oha05,"')"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oha01_pre FROM l_sql
     DECLARE oha01_cs CURSOR FOR oha01_pre
     OPEN oha01_cs
     FETCH oha01_cs INTO g_oha01,g_oha05       #銷退單  #No.FUN-620024
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'
        CALL s_errmsg('rvu99',g_oha.oha99,g_msg,SQLCA.SQLCODE,1) 
        LET g_success = 'N'
     END IF
  END IF
END FUNCTION
 
# 清空多角序號
FUNCTION p866_flow99()
        UPDATE oha_file SET oha99 = ' ' WHERE oha01 = g_oha.oha01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('oha01',g_oha.oha01,'upd oha99',SQLCA.SQLCODE,1)
           LET g_success = 'N' RETURN
        END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
