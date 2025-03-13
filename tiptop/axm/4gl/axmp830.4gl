# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp830.4gl
# Descriptions...: 三角貿易出貨單拋轉還原作業(正拋使用)
# Date & Author..: 98/12/14 By Linda
# Modify ........: 00/01/14 By Kammy 還原 1.驗收單       2.入庫單
#                                         3.Packing List 4.Invoice
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.MOD-530005 05/03/03 By ching UPDATE pmn修正
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/04 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.FUN-620024 06/02/17 By Rayven 刪除產生的代送銷退單
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/07/27 BY yiting 1.oaz203->oax04,oaz204->oax05
#                                                   2.此處不再處理拋轉出通單還原，axmp831處理
# Modify.........: No.TQC-680067 06/08/18 By Claire s_mchkARAP多加入一個參數傳入
# Modify.........: NO.FUN-670007 06/08/30 by Yiting 1.三角站別己在apmi000做更改，拋轉原還時也要一併處理
#                                                   2.還原時不用處理出通單，出通單己有新增axmp831程式 
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0183 06/12/29 By chenl   增加開窗查詢功能。
# Modify.........: No.FUN-710046 07/01/23 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-770160 07/08/24 By Claire 拋轉還原時先確認是否存在銷退單
# Modify.........: No.MOD-770131 07/08/24 By Claire 重取訂單流程序號再重新取得各站訂單號碼
# Modify.........: NO.FUN-780025 07/08/31 BY yiting 拋轉還原出貨單時應一併刪除ogbb_file
# Modify.........: No.TQC-7B0159 07/12/03 By Judy 切換語言別
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/04/01 By hellen 修改delete rvv_file
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-880076 08/08/15 By claire 判斷單身所屬的訂單是否已經結案,若結案則不可拋轉還原
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息管理 
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_mupimg傳參修改營運中心改成機構別
# Modify.........: No.FUN-980059 09/09/10 By arman GP5.2架構,修改Sub相關傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990145 09/09/15 By Dido CURSOR 語法調整 
# Modify.........: No.FUN-980092 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990233 09/09/28 By Dido 還原不可更新過帳碼  
# Modify.........: No:TQC-9A0131 09/10/26 By Dido 訂單結案碼應以各站訂單為主  
# Modify.........: No:MOD-9C0140 09/12/21 By Dido 當多訂單合併一出貨通知單時, 出貨單扣帳還原原拋轉至各站之出通單, invoice還是會存在 
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:CHI-9C0037 10/01/14 By Dido 來源站不刪除 tlf_file 
# Modify.........: No:MOD-A10139 10/01/22 By Dido 不應將刪除invoice的判斷包在packing之中 
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A50102 10/06/10 by lixh1  跨庫統一用cl_get_target_table()實現
# Modify.........: No:MOD-A60171 10/07/30 By Smapmin 沒有扣除來源站的img數量
# Modify.........: No:MOD-A60152 10/07/30 By Smapmin 變數重複定義
# Modify.........: No:TQC-AC0410 10/12/31 By lixh1  修改s_mupimg(),s_mupimgg()參數
# Modify.........: No.FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.TQC-B80244 11/08/30 By guoch EXECTE处 将axmt300改apmt300
# Modify.........: No.FUN-B90012 11/09/13 By xianghui  增加ICD行業功能
# Modify.........: No.FUN-BC0104 12/01/18 By xianghui 數量異動回寫qco20
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: No.FUN-C80001 12/09/03 By bart 1.還原時需刪除ogc_file,ogg_file
#                                                 2.多倉儲時tlf_file,tlff_file,tlfs_file漏刪
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE l_oga   RECORD LIKE oga_file.*    #NO.FUN-620024
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_oha   RECORD LIKE oha_file.*    #NO.FUN-620024
DEFINE g_ohb   RECORD LIKE ohb_file.*      #NO.FUN-620024
DEFINE tm RECORD
          oga01  LIKE oga_file.oga01
       END RECORD
DEFINE g_poz     RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.7993
DEFINE g_poy     RECORD LIKE poy_file.*    #流程代碼資料(單身) No.7993
DEFINE s_poy     RECORD LIKE poy_file.*    #來源流程資料(單身) No.7993
DEFINE g_rva01   LIKE rva_file.rva01
DEFINE g_rvu01   LIKE rvu_file.rvu01
DEFINE g_oga01   LIKE oga_file.oga01
DEFINE t_oga01   LIKE oga_file.oga01
DEFINE g_ofa01   LIKE ofa_file.ofa01
DEFINE s_dbs_new LIKE type_file.chr21     #New DataBase Name #No.FUN-680137 VARCHAR(21)
DEFINE l_dbs_new LIKE type_file.chr21     #New DataBase Name #No.FUN-680137 VARCHAR(21)
DEFINE l_plant_new LIKE type_file.chr21     #New DataBase Name #No.FUN-680137 VARCHAR(21) #No.FUN-980059
DEFINE s_azp     RECORD LIKE azp_file.*
DEFINE l_azp     RECORD LIKE azp_file.*
DEFINE g_sw      LIKE type_file.chr1      #No.FUN-680137 VARCHAR(1)
DEFINE g_t1      LIKE oay_file.oayslip    #No.FUN-550070 #No.FUN-680137 VARCHAR(5)
DEFINE g_argv1   LIKE oga_file.oga01
DEFINE oga_t1    LIKE oay_file.oayslip    #No.FUN-550070 #No.FUN-680137 VARCHAR(05)
DEFINE rva_t1    LIKE oay_file.oayslip    #No.FUN-680137 VARCHAR(05)
DEFINE rvu_t1    LIKE oay_file.oayslip    #No.FUN-680137 VARCHAR(05)
DEFINE l_aza50   LIKE aza_file.aza50      #No.FUN-620024
DEFINE g_pmm01   LIKE pmm_file.pmm01      #No.FUN-620024
DEFINE g_sql     STRING
DEFINE g_cnt     LIKE type_file.num10     #No.FUN-680137 INTEGER
DEFINE l_n       LIKE type_file.num10     #MOD-770160 add
DEFINE g_msg     LIKE type_file.chr1000   #No.FUN-680137 VARCHAR(72)
DEFINE g_ima906  LIKE ima_file.ima906     #FUN-560043
DEFINE l_poy02 LIKE poy_file.poy02 #NO.FUN-670007
DEFINE l_c     LIKE type_file.num5 #NO.FUN-670007
DEFINE p_last  LIKE type_file.num5     #流程之最後家數 #No.FUN-680137 SMALLINT
DEFINE p_last_plant LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)
DEFINE l_dbs_tra  LIKE azw_file.azw05   #FUN-980092 add
DEFINE s_dbs_tra  LIKE azw_file.azw05   #FUN-980092 add
DEFINE s_plant_new  LIKE azp_file.azp01   #FUN-980092 add
 
MAIN
   OPTIONS                              #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                      #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   LET g_argv1 = ARG_VAL(1)
 
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
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      OPEN WINDOW p830_w WITH FORM "axm/42f/axmp830" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      
      CALL cl_ui_init()
 
      CALL p830_p1()
 
      CLOSE WINDOW p830_w
   ELSE
      OPEN WINDOW p830_w WITH FORM "axm/42f/axmp830" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      
      CALL cl_ui_init()
 
      LET tm.oga01 = g_argv1
 
      IF cl_sure(0,0) THEN
         CALL p830_p2()
      END IF
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
 
FUNCTION p830_p1()
 DEFINE l_ac       LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_i,l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_cnt      LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p830_w WITH FORM "axm/42f/axmp830" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oga01
 WHILE TRUE
    LET g_action_choice = ''
    INPUT BY NAME tm.oga01  WITHOUT DEFAULTS  
         AFTER FIELD oga01
            IF cl_null(tm.oga01) THEN
               NEXT FIELD oga01
            END IF
            SELECT * INTO g_oga.*
               FROM oga_file
              WHERE oga01=tm.oga01
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",0)   #No.FUN-660167
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga10 IS NOT NULL THEN
               CALL cl_err(g_oga.oga10,'axm-502',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
               CALL cl_err(g_oga.oga901,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga09<>'4' THEN
               CALL cl_err(g_oga.oga905,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga905='N' THEN
               CALL cl_err(g_oga.oga905,'tri-012',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga906 <>'Y' THEN
               CALL cl_err(g_oga.oga906,'apm-012',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.ogaconf != 'Y' THEN #01/08/20 mandy
                CALL cl_err(g_oga.oga01,'axm-184',0)
                NEXT FIELD oga01 
            END IF
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(oga01)
             CALL cl_init_qry_var()
             LET g_qryparam.form="q_oga10"
             LET g_qryparam.default1=tm.oga01
             CALL cl_create_qry() RETURNING tm.oga01
             DISPLAY BY NAME tm.oga01
             NEXT FIELD oga01
         END CASE
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()
      ON ACTION locale
         LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
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
      CALL p830_p2()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
  CLOSE WINDOW p830_w
END FUNCTION
 
FUNCTION p830_p2()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3 LIKE type_file.chr1000 #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql4 LIKE type_file.chr1000 #NO.FUN-620024 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql5 LIKE type_file.chr1000 #NO.FUN-620024 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oeb  RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-620024  #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024
  DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024
  DEFINE l_oha01 LIKE oha_file.oha01      #NO.FUN-620024
  DEFINE l_ogb   RECORD LIKE ogb_file.*   #MOD-A60171
  DEFINE l_rvv   RECORD LIKE rvv_file.*   #FUN-C80001
 
   CALL cl_wait() 
   LET s_oea62=0
 
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01=tm.oga01
     IF SQLCA.SQLCODE THEN
        CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",1)   #No.FUN-660167
        RETURN
     END IF
 
     #確認是否存在銷退單,若存才則不往下執行
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM oha_file,ohb_file
      WHERE oha01=ohb01 AND ohaconf!='X' AND ohb31 = g_oga.oga01
      IF l_n > 0 THEN
         CALL cl_err(g_oga.oga01,'axm-030',1)
         RETURN
      END IF
 
     IF g_oga.oga10 IS NOT NULL THEN
        CALL cl_err(g_oga.oga10,'axm-502',1)
        RETURN           
     END IF
     IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
        CALL cl_err(g_oga.oga901,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga09<>'4' THEN
        CALL cl_err(g_oga.oga905,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga905='N' THEN
        CALL cl_err(g_oga.oga905,'tri-012',1)
        RETURN
     END IF
     IF g_oga.oga906 <>'Y' THEN
        CALL cl_err(g_oga.oga906,'apm-012',1)
        RETURN
     END IF
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                    "  WHERE oea01 = ogb31 ",
                    "    AND ogb01 = '",g_oga.oga01,"'",
                    "    AND oeaconf = 'Y' "  #01/08/16 mandy
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
           AND oeaconf = 'Y'   #01/08/16 mandy
     END IF
     IF SQLCA.sqlcode THEN
         CALL cl_err('sel oea',STATUS,1)
         LET g_success = 'N'
         RETURN
     END IF
 
     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' RETURN
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)   #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN 
         CALL cl_err(g_oea.oea904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.poz011 = '2' THEN
        CALL cl_err('','axm-411',1) LET g_success = 'N' RETURN
     END IF
     CALL s_mtrade_last_plant(g_oea.oea904) 
                 RETURNING p_last,p_last_plant    #記錄最後一筆之家數
     IF s_mchkARAP('',g_oga.oga99,'1') THEN       #TQC-680067 modify 
        LET g_success = 'N' RETURN
     END IF
 
     BEGIN WORK 
     LET g_success='Y'
     #-----MOD-A60171---------
     CALL p830_azp(1)
     #FUN-C80001---begin
    #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
        DECLARE rvv_cs CURSOR FOR
              SELECT * FROM rvv_file,rvu_file
               WHERE rvv01 = rvu01
                 AND rvu99 = g_oga.oga99
        FOREACH rvv_cs INTO l_rvv.* 
           IF STATUS THEN 
              CALL cl_err('foreach:rvv_cs',STATUS,1) 
              LET g_success= 'N'            
              RETURN
           END IF
           CALL s_mupimg(-1,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                         l_rvv.rvv17*l_rvv.rvv35_fac, 
                         g_oga.oga02,s_plant_new,1,l_rvv.rvv01,l_rvv.rvv02) 
           IF g_ima906 = '2' THEN                  
               CALL s_mupimgg(-1,l_rvv.rvv31,
                              l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv80,l_rvv.rvv82,
                              g_oga.oga02,
                              s_plant_new)    
               CALL s_mupimgg(-1,l_rvv.rvv31,
                              l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv83,l_rvv.rvv85, 
                              g_oga.oga02,
                              s_plant_new)  
           ELSE
              IF g_ima906 = '3' THEN
                 CALL s_mupimgg(-1,l_rvv.rvv31,
                                  l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv85, 
                                  g_oga.oga02,
                                  s_plant_new) 
              END IF
           END IF
        CALL s_mudima(l_rvv.rvv31,s_plant_new)    
        END FOREACH            
     ELSE
     #FUN-C80001---end
        DECLARE ogb_cs CURSOR FOR
          SELECT * FROM ogb_file WHERE ogb01 = g_oga.oga01
        FOREACH ogb_cs INTO l_ogb.* 
           IF STATUS THEN 
              CALL cl_err('foreach:ogb_cs',STATUS,1) 
              LET g_success= 'N'            
              RETURN
           END IF
           CALL s_mupimg(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                         l_ogb.ogb12*l_ogb.ogb15_fac, 
                     #   g_oga.oga02,s_dbs_new,-1,l_ogb.ogb01,l_ogb.ogb03)   #TQC-AC0410
                         g_oga.oga02,s_plant_new,-1,l_ogb.ogb01,l_ogb.ogb03) #TQC-AC0410
           IF g_ima906 = '2' THEN                  
               CALL s_mupimgg(-1,l_ogb.ogb04,
                              l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb910,l_ogb.ogb912,
                              g_oga.oga02,
                           #  s_dbs_new)      #TQC-AC0410
                              s_plant_new)    #TQC-AC0410 
               CALL s_mupimgg(-1,l_ogb.ogb04,
                              l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb913,l_ogb.ogb915, 
                              g_oga.oga02,
                           #  s_dbs_new)      #TQC-AC0410
                              s_plant_new)    #TQC-AC0410
           ELSE
              IF g_ima906 = '3' THEN
                 CALL s_mupimgg(-1,l_ogb.ogb04,
                                  l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb913,l_ogb.ogb915, 
                                  g_oga.oga02,
                          #       s_dbs_new)   #TQC-AC0410
                                  s_plant_new) #TQC-AC0410
              END IF
           END IF
     # CALL s_mudima(l_ogb.ogb04,s_dbs_new)      #TQC-AC0410
        CALL s_mudima(l_ogb.ogb04,s_plant_new)    #TQC-AC0410 
        END FOREACH
     #-----END MOD-A60171-----
     END IF #FUN-C80001
     #依流程代碼最多6層
     FOR i = 1 TO p_last
           #得到廠商/客戶代碼及database
           CALL p830_azp(i)
#NO.FUN-670007 mark-- 正拋不做斷點，先mark
           CALL p830_getno()                      #No.7993 取得還原單號
              LET g_t1 = s_get_doc_no(g_oga.oga01)         #No.FUN-550070 
              CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)                      
                  RETURNING g_sw,oga_t1,rva_t1,rvu_t1,l_x,l_x   #No.7993
              IF g_sw THEN LET g_success = 'N' RETURN END IF 
              IF s_mchkARAP(l_plant_new,g_oga.oga99,'1') THEN   #TQC-680067 modify #No.FUN-980059
                 LET g_success = 'N' EXIT FOR
              END IF
               CALL p830_p3(i)
       END FOR
 
       MESSAGE ''
       #更新出貨單之拋轉否='N'
       UPDATE oga_file
          SET oga905='N'
        WHERE oga909='Y'          #三角貿易訂單
          AND oga01 = g_oga.oga01
       IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
          CALL cl_err3("upd","oga_file",g_oga.oga01,"",STATUS,"","upd oga",1)   #No.FUN-660167
          LET g_success='N' 
       END IF
       IF NOT cl_null(g_oga.oga011) THEN #通知單號
          UPDATE oga_file SET ogapost='N' WHERE oga01=g_oga.oga011
       END IF
       CALL p830_flow99()         #No.7993
       CALL s_showmsg()           #No.FUN-710046
     ##更新來源訂單之訂單
 
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION p830_p3(i)
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3 LIKE type_file.chr1000 #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql4 LIKE type_file.chr1000 #NO.FUN-620024 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql5 LIKE type_file.chr1000 #NO.FUN-620024 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oeb  RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-620024  #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  #DEFINE p_last  LIKE type_file.num5     #流程之最後家數 #No.FUN-680137 SMALLINT   #MOD-A60152
  #DEFINE p_last_plant LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)   #MOD-A60152
  DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024
  DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024
  DEFINE l_oha01 LIKE oha_file.oha01      #NO.FUN-620024
  DEFINE l_ogbb_cnt     LIKE type_file.num10 #no.FUN-780025
  DEFINE l_rvv   RECORD LIKE rvv_file.*   #No.FUN-830132
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  #FUN-B90012-add-str--
  DEFINE l_ogbiicd028   LIKE ogbi_file.ogbiicd028
  DEFINE l_ogbiicd029   LIKE ogbi_file.ogbiicd029   
  DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08
  DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16
  DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02
  DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05
  DEFINE l_pmn07        LIKE pmn_file.pmn07
  DEFINE l_rva06        LIKE rva_file.rva06
  DEFINE l_rvu03        LIKE rvu_file.rvu03
  DEFINE l_flag         LIKE type_file.chr1
  DEFINE l_rvb   RECORD LIKE rvb_file.*
  DEFINE b_rvv   RECORD LIKE rvv_file.*
  DEFINE l_ogb_l RECORD LIKE ogb_file.*
  DEFINE l_ogg_l RECORD LIKE ogg_file.* #FUN-C80001 add
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
# DEFINE l_oha03  LIKE oha_file.oha03    #FUN-C50136
# DEFINE l_oga03  LIKE oga_file.oga03    #FUN-C50136
# DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136
  DEFINE l_ogc    RECORD LIKE ogc_file.*  #FUN-C80001
  DEFINE l_ogg    RECORD LIKE ogg_file.*  #FUN-C80001
  DEFINE l_idd    RECORD LIKE idd_file.*  #FUN-C80001
  DEFINE l_oga011 LIKE oga_file.oga011    #FUN-C80001
  DEFINE l_fac    LIKE ima_file.ima31_fac #FUN-C80001
  DEFINE l_qty    LIKE ogb_file.ogb915        #FUN-C80001
  
    LET l_sql5 = "SELECT oga00,oga01 ",                                  
          #     " FROM ",l_dbs_tra CLIPPED,"oga_file ",   #FUN-980092 add     #FUN-A50102
                " FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),      #FUN-A50102
                " WHERE oga99='",g_oga.oga99,"'" 
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
     CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-980092
    PREPARE oga_p2 FROM l_sql5                                     
    IF SQLCA.SQLCODE THEN
       CALL cl_err('oga_p2',SQLCA.SQLCODE,1)
    END IF
    DECLARE oga_c2 CURSOR FOR oga_p2                               
    OPEN oga_c2                                                    
    FETCH oga_c2 INTO l_oga.oga00,l_oga.oga01                      
    IF SQLCA.SQLCODE <> 0 THEN                                     
       LET g_success='N'    
       RETURN              
    END IF                                                         
    CLOSE oga_c2
  
    #---------------------先還原 tlf_file-----------------------
    LET l_oea62=0
    #讀取出貨單身檔(ogb_file)
#    LET l_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add  #FUN-A50102
    LET l_sql = "SELECT * FROM ",cl_get_target_table( l_plant_new, 'ogb_file' ),  #FUN-A50102
                " WHERE ogb01 = '",g_oga01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
    PREPARE ogb_pre FROM l_sql
    DECLARE  ogb_cus CURSOR FOR ogb_pre
    CALL s_showmsg_init()   #No.FUN-710046
    FOREACH ogb_cus INTO g_ogb.*
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
       IF SQLCA.SQLCODE <>0 THEN 
           CALL s_errmsg('','','ogb_cus',STATUS,1)   #No.FUN-710046
           LET g_success= 'N'           #No.FUN-8A0086 
       END IF 
       SELECT ima906 INTO g_ima906 FROM ima_file 
        WHERE ima01 = g_ogb.ogb04
 
       #MOD-880076-begin-add 訂單若已結案不可拋轉還原
        LET l_sql1= " SELECT oeb70 ",
                   # "   FROM ",l_dbs_new CLIPPED,"oeb_file ",	#TQC-9A0131     #FUN-A50102
                    "   FROM ",cl_get_target_table( l_plant_new, 'oeb_file' ),   #FUN-A50102
                    "  WHERE oeb01 = '",g_ogb.ogb31,"'",
                    "    AND oeb03 = '",g_ogb.ogb32,"'"
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1     #FUN-A50102
        CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102            
        PREPARE oeb99_pre FROM l_sql1
        DECLARE oeb99_cus CURSOR FOR oeb99_pre
        OPEN oeb99_cus
        FETCH oeb99_cus INTO l_oeb.oeb70
        IF l_oeb.oeb70 = 'Y' THEN
           LET g_showmsg=g_ogb.ogb01,"/",g_ogb.ogb03,"/",g_ogb.ogb31,"/",g_ogb.ogb32         
           CALL s_errmsg('ogb01,ogb03,ogb31,ogb32',g_showmsg,'Warning SO:','axm-202',1) 
           LET g_success='N'                                                 
        END IF 
 
        #重新取得單身的訂單號碼
         LET l_sql1= " SELECT oea99 ",
               #      "   FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add  #FUN-A50102
                     "   FROM ",cl_get_target_table( l_plant_new, 'oea_file' ),   #FUN-A50102
                     "  WHERE oea01 = '",g_ogb.ogb31,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
         PREPARE oea99_pre FROM l_sql1
         DECLARE oea99_cus CURSOR FOR oea99_pre
         OPEN oea99_cus
         FETCH oea99_cus INTO g_oea.oea99
         CLOSE oea99_cus
 
        #重取本站的訂單號碼
       #  LET l_sql1= " SELECT oea01 FROM ",s_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add   #FUN-A50102
         LET l_sql1= " SELECT oea01 FROM ",cl_get_target_table( s_plant_new, 'oea_file' ),   #FUN-A50102
                     "  WHERE oea99 = '",g_oea.oea99,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
         PREPARE oea_pre1 FROM l_sql1
         DECLARE oea_f1 CURSOR FOR oea_pre1
         OPEN oea_f1 
         FETCH oea_f1 INTO g_oea.oea01
         CLOSE oea_f1
 
       LET l_sql4 = "SELECT pmm01 ",
                 #   "  FROM ",s_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add   #FUN-A50102
                    "  FROM ",cl_get_target_table( s_plant_new, 'pmm_file' ),   #FUN-A50102
                    " WHERE pmm99 ='",g_oea.oea99,"'"
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
       CALL cl_parse_qry_sql(l_sql4,s_plant_new) RETURNING l_sql4 #FUN-980092
       PREPARE pmm_pre FROM l_sql4
       DECLARE pmm_cus CURSOR FOR pmm_pre
       OPEN pmm_cus
       FETCH pmm_cus INTO g_pmm01
       IF SQLCA.SQLCODE <>0 THEN 
           CALL s_errmsg('','','pmm_cus',STATUS,1)     #No.FUN-710046
       END IF
 
       #刪除批/序號異動資料檔(tlfs_file)
#       LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlfs_file",   #FUN-980092 add   #FUN-A50102
       LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlfs_file' ),    #FUN-A50102
                  " WHERE tlfs01 = ? ",
                  "   AND tlfs10 = ? ",
                  #"   AND tlfs11 = ? ",  #FUN-C80001
                  "   AND tlfs111 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
       PREPARE del_tlfsl FROM l_sql2
       
        # LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"tlfs_file",  #FUN-980092 add   #FUN-A50102
       LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlfs_file' ),     #FUN-A50102
                  " WHERE tlfs01 = ? ",
                  "   AND tlfs10 = ? ",
                  #"   AND tlfs11 = ? ",  #FUN-C80001
                  "   AND tlfs111 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
       PREPARE del_tlfss FROM l_sql2
 
      #-CHI-9C0037-mark-
      #IF i = 1 AND g_ogb.ogb04[1,4]<>'MISC' THEN #No.8743 #來源的tlf
      #   #刪除tlf檔(出貨單) -->s_dbs_new
      #   LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"tlf_file",  #FUN-980092 add
      #              " WHERE (tlf026 = ? ",
      #              "   AND tlf027 = ?)",
      #              "   AND (tlf036 = ? ",
      #              "   AND tlf037 = ?)"
      #  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      #  CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
      #   PREPARE del0_tlf FROM l_sql2
      #   EXECUTE del0_tlf USING g_oga.oga01,g_ogb.ogb03,
      #                          g_oea.oea01,g_ogb.ogb32   #NO.FUN-620024
      #   IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN #No.8410
      #      LET g_msg = l_dbs_tra CLIPPED,'del tlf'   #FUN-980092 add
      #      CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  #No.FUN-710046 
      #      LET g_success='N'
      #      CONTINUE FOREACH  #No.FUN-710046  
      #   END IF
      # 
      #   #刪除批/序號異動資料
      #   EXECUTE del_tlfss USING g_ogb.ogb04,g_oga.oga01,g_ogb.ogb03,g_oga.oga02 
      #   IF SQLCA.SQLCODE THEN
      #      LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'    #FUN-980092 add
      #      CALL s_errmsg('','',g_msg,STATUS,1)
      #      LET g_success='N'
      #   END IF
      #
      #   IF g_ima906 = '2' OR g_ima906 = '3' THEN
      #       #刪除tlff檔(出貨單) -->s_dbs_new
      #       LET l_sql3="DELETE FROM ",s_dbs_tra CLIPPED,"tlff_file",  #FUN-980092 add
      #                  " WHERE (tlff026 = ? ",
      #                  "   AND tlff027 = ?)",
      #                  "   AND (tlff036 = ? ",
      #                  "   AND tlff037 = ?)"
      #  CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
      #  CALL cl_parse_qry_sql(l_sql3,s_plant_new) RETURNING l_sql3 #FUN-980092
      #       PREPARE del0_tlf2 FROM l_sql3
      #       EXECUTE del0_tlf2 USING g_oga.oga01,g_ogb.ogb03,
      #                               g_oea.oea01,g_ogb.ogb32   #NO.FUN-620024
      #       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN 
      #          LET g_msg = l_dbs_tra CLIPPED,'del tlff'
      #           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  #No.FUN-710046   
      #          LET g_success='N'
      #          CONTINUE FOREACH   #No.FUN-710046  
      #       END IF
      #
      #       #刪除批/序號異動資料
      #       EXECUTE del_tlfss USING g_ogb.ogb04,g_oga.oga01,g_ogb.ogb03,g_oga.oga02 
      #       IF SQLCA.SQLCODE THEN
      #          LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'    #FUN-980092 add
      #          CALL s_errmsg('','',g_msg,STATUS,1)
      #          LET g_success='N'
      #       END IF
      #
      #   END IF
      #END IF
      #-CHI-9C0037-end-
       IF i = p_last THEN
          #FUN-C80001---begin
          IF g_ogb.ogb17 = 'Y' THEN
             IF g_sma.sma115 = 'Y' THEN 
                LET l_sql="SELECT * FROM ",cl_get_target_table( l_plant_new, 'ogg_file' ), 
                          " WHERE ogg01 = '",g_ogb.ogb01,"'",
                          "   AND ogg03 = ",g_ogb.ogb03

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql                  
                DECLARE ogg_cs1 CURSOR FROM l_sql

                FOREACH ogg_cs1 INTO l_ogg.* 
                   IF g_ima906 = '2' THEN
                      IF l_ogg.ogg20 = 2 THEN
                         LET l_sql="SELECT SUM(ogg12) FROM ",cl_get_target_table( l_plant_new, 'ogg_file' ), 
                                   " WHERE ogg01 = '",g_ogb.ogb01,"'",
                                   "   AND ogg03 = ",g_ogb.ogb03,
                                   "   AND ogg092= '",l_ogg.ogg092,"'",
                                   "   AND ogg20= 1 "
                         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  
                         PREPARE ogg_pre FROM l_sql                   
                         EXECUTE ogg_pre INTO l_qty 
                        
                         CALL s_umfchk(g_ogb.ogb04,l_ogg.ogg15,g_ogb.ogb15) 
                            RETURNING l_flag,l_fac 
                         CALL s_mupimg(1,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                        l_qty+l_ogg.ogg12*l_fac, 
                                        g_oga.oga02,l_azp.azp01,-1,g_ogb.ogb01,g_ogb.ogb03)
                      END IF 
                   ELSE
                      IF l_ogg.ogg20 = 1 THEN 
                         CALL s_mupimg(1,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                        l_ogg.ogg12*l_ogg.ogg15_fac, 
                                        g_oga.oga02,l_azp.azp01,-1,g_ogb.ogb01,g_ogb.ogb03)
                      END IF 
                   END IF 
                   
                   IF g_ima906 = '2' THEN
                      IF l_ogg.ogg20 = 1 THEN             
                         CALL s_mupimgg(1,l_ogg.ogg17,
                                         l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                         l_ogg.ogg15,l_ogg.ogg12,
                                         g_oga.oga02,
                                         l_plant_new)  
                      ELSE  
                         CALL s_mupimgg(1,l_ogg.ogg17,
                                         l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                         l_ogg.ogg15,l_ogg.ogg12, 
                                         g_oga.oga02,
                                         l_plant_new)
                      END IF 
                   ELSE
                      IF g_ima906 = '3' THEN
                         IF l_ogg.ogg20 = 2 THEN
                            CALL s_mupimgg(1,l_ogg.ogg17,
                                            l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                            l_ogg.ogg15,l_ogg.ogg12, 
                                            g_oga.oga02,
                                            l_plant_new) 
                         END IF 
                      END IF
                   END IF
                END FOREACH    
             ELSE
                LET l_sql="SELECT * FROM ",cl_get_target_table( l_plant_new, 'ogc_file' ), 
                          " WHERE ogc01 = '",g_ogb.ogb01,"'",
                          "   AND ogc03 = ",g_ogb.ogb03

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql                  
                DECLARE ogc_cs1 CURSOR FROM l_sql

                FOREACH ogc_cs1 INTO l_ogc.* 
                   CALL s_mupimg(1,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                        l_ogc.ogc12*l_ogc.ogc15_fac, 
                        g_oga.oga02,l_azp.azp01,-1,g_ogb.ogb01,g_ogb.ogb03)
                END FOREACH 
             END IF 
          ELSE
          #FUN-C80001---end
             CALL s_mupimg(1,g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                           g_ogb.ogb12*g_ogb.ogb15_fac, #MOD-4B0148
                           g_oga.oga02,l_azp.azp01,-1,g_ogb.ogb01,g_ogb.ogb03)  #No.FUN-870007
             IF g_ima906 = '2' THEN                    #NO.FUN-620024
                CALL s_mupimgg(1,g_ogb.ogb04,
                               g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                               g_ogb.ogb910,g_ogb.ogb912,
                               g_oga.oga02,
                               l_plant_new) #FUN-980092 add
                CALL s_mupimgg(1,g_ogb.ogb04,
                               g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                               g_ogb.ogb913,g_ogb.ogb915, 
                               g_oga.oga02,
                               l_plant_new)   #FUN-980092 add
             ELSE
                IF g_ima906 = '3' THEN
                   CALL s_mupimgg(1,g_ogb.ogb04,
                                    g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                                    g_ogb.ogb913,g_ogb.ogb915, 
                                    g_oga.oga02,
                                    l_plant_new)   #FUN-980092 add
                 END IF
             END IF
          END IF  #FUN-C80001
          CALL s_mudima(g_ogb.ogb04,l_plant_new) #FUN-980092 add
       END IF
       IF g_ogb.ogb04[1,4]<>'MISC' THEN  #No.8743
           #刪除tlf檔(出貨單) -->l_dbs_new
  ##NO.FUN-8C0131   add--begin  
         #  LET l_sql="SELECT * FROM ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-A50102
           LET l_sql="SELECT * FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                       " WHERE (tlf026 = ? ",
                       "   AND tlf027 = ?)",
                       "   AND (tlf036 = ? ",
                       "   AND tlf037 = ?)"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102 
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-A50102                 
           DECLARE p830_u_tlf_c CURSOR FROM l_sql 
           LET l_i = 0 
           CALL la_tlf.clear()
           FOREACH p830_u_tlf_c USING g_oga01,g_ogb.ogb03,
                                      g_ogb.ogb31,g_ogb.ogb32  INTO g_tlf.*    
              LET l_i = l_i + 1
              LET la_tlf[l_i].* = g_tlf.*
           END FOREACH     
  ##NO.FUN-8C0131   add--end  
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),
                         " WHERE tlf026 = ? ",
                         "   AND tlf036 = ? ",
                         "   AND tlf037 = ?"
           ELSE 
           #FUN-C80001---end
      #    LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file",   #FUN-980092 add   #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ",
                         "   AND tlf027 = ?)",
                         "   AND (tlf036 = ? ",
                         "   AND tlf037 = ?)"
           END IF  #FUN-C80001
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_tlf FROM l_sql2
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              EXECUTE del_tlf USING g_oga01,g_ogb.ogb31,g_ogb.ogb32
              IF SQLCA.SQLCODE THEN 
                 LET g_msg = l_dbs_tra CLIPPED,'del tlf'  
                 CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1) 
                 LET g_success='N'
              END IF 
           ELSE 
           #FUN-C80001---end
              EXECUTE del_tlf USING g_oga01,g_ogb.ogb03,
                                    g_ogb.ogb31,g_ogb.ogb32    #no.6178 
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,'del tlf'   #FUN-980092 add
                 CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  #No.FUN-710046  
                 LET g_success='N'
              END IF
           END IF  #FUN-C80001
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
           #EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
           EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_oga.oga02  #FUN-C80001
           IF SQLCA.SQLCODE THEN
              LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'     #FUN-980092 add
              CALL s_errmsg('','',g_msg,STATUS,1)
              LET g_success='N'
           END IF
           #FUN-B90012-add-str--
           IF s_industry('icd') THEN
              LET l_sql2 = "SELECT ogb_file.*,ogbiicd028,ogbiicd029 ",
                           "  FROM ",cl_get_target_table(l_plant_new,'ogb_file'),",",
                                     cl_get_target_table(l_plant_new,'ogbi_file'),
                           " WHERE ogb01 = '",g_oga01,"'",
                           "   AND ogb03 = '",g_ogb.ogb03,"'",
                           "   AND ogb01 = ogbi01 ",
                           "   AND ogb03 = ogbi03 "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
              PREPARE l_ogb_p FROM l_sql2
              EXECUTE l_ogb_p INTO l_ogb_l.*,l_ogbiicd028,l_ogbiicd029
              #FUN-C80001---begin
              LET l_sql2 = "SELECT oga011 ",
                           "  FROM ",cl_get_target_table(l_plant_new,'oga_file'),
                           " WHERE oga01 = '",g_oga01,"'"
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
              PREPARE l_oga_p1 FROM l_sql2
              EXECUTE l_oga_p1 INTO l_oga011
              
              LET l_sql2 = " SELECT * FROM ",cl_get_target_table(l_plant_new,'idd_file'),
                           " WHERE idd10 = '",g_oga01,"'",
                           "   AND idd11 = ",g_ogb.ogb03
              DECLARE p830_g_idd CURSOR FROM l_sql2

             #抓取雙單位倉儲批資料
             LET l_sql2= " SELECT * FROM ",cl_get_target_table(l_plant_new,'ogg_file'),
                         " WHERE ogg01 = '",g_oga01,"'",
                         "   AND ogg03 = ",g_ogb.ogb03,
                         "   AND ogg20 = 1"
             DECLARE l_ogg_p CURSOR FROM l_sql2 

            #IF g_ogb.ogb17 = 'Y' AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
             IF g_ogb.ogb17 = 'Y' AND g_pod.pod08 = 'Y' THEN  #FUN-D30099
                IF NOT cl_null(l_oga011) THEN 
                   FOREACH p830_g_idd INTO l_idd.*
                      LET l_idd.idd10 = l_oga011
                      CALL p830_idd_to_idb(l_idd.*,l_plant_new)
                   END FOREACH
                END IF 
                FOREACH l_ogg_p INTO l_ogg_l.*
                   CALL s_icdpost(12,l_ogg_l.ogg17,l_ogg_l.ogg09,
                                     l_ogg_l.ogg091,l_ogg_l.ogg092,
                                     l_ogg_l.ogg15,l_ogg_l.ogg12,
                                     g_oga01,g_ogb.ogb03,g_oga.oga02,
                                     'N','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                   RETURNING l_flag
                   IF l_flag = 0 THEN
                      LET g_success = 'N'
                   END IF
                END FOREACH
             ELSE 
                 IF NOT cl_null(l_oga011) THEN 
                    FOREACH p830_g_idd INTO l_idd.*
                       IF NOT cl_null(l_oga011) THEN 
                          LET l_idd.idd10 = l_oga011
                          CALL p830_idd_to_idb(l_idd.*,l_plant_new)
                       END IF 
                     END FOREACH    
                 END IF 
              #FUN-C80001---end
                 CALL s_icdpost(12,l_ogb_l.ogb04,l_ogb_l.ogb09,
                                   l_ogb_l.ogb091,l_ogb_l.ogb092,
                                   l_ogb_l.ogb05,l_ogb_l.ogb12,
                                   g_oga01,g_ogb.ogb03,g_oga.oga02,
                                  #'N','','',l_ogbiicd028,l_ogbiicd029,l_plant_new) #FUN-C80001 mark
                                   'N','','',l_ogbiicd029,l_ogbiicd028,l_plant_new) #FUN-C80001 add
                 RETURNING l_flag
                 IF l_flag = 0 THEN
                    LET g_success = 'N'
                 END IF
             END IF  #FUN-C80001
           END IF
           #FUN-B90012-add-end--
 
           IF g_ima906 = '2' OR g_ima906 = '3' THEN
           #刪除tlff檔(出貨單) -->l_dbs_new
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                  LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),
                             " WHERE tlff026 = ? ",
                             "   AND tlff036 = ? "
               ELSE 
               #FUN-C80001---end 
           #    LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file",  #FUN-980092 add   #FUN-A50102
                  LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
                             " WHERE (tlff026 = ? ",
                             "   AND tlff027 = ?)",
                             "   AND (tlff036 = ? ",
                             "   AND tlff037 = ?)"
               END IF  #FUN-C80001
 	           CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
               CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
               PREPARE del_tlf2 FROM l_sql3
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                  EXECUTE del_tlf2 USING g_oga01,g_ogb.ogb31 
                  IF SQLCA.SQLCODE THEN
                      LET g_msg = l_dbs_tra CLIPPED,'del tlff'   
                      CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  
                      LET g_success='N'
                  END IF
               ELSE
               #FUN-C80001---end
                  EXECUTE del_tlf2 USING g_oga01,g_ogb.ogb03,
                                         g_ogb.ogb31,g_ogb.ogb32 
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                      LET g_msg = l_dbs_tra CLIPPED,'del tlff'   #FUN-980092 add
                      CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  #No.FUN-710046
                      LET g_success='N'
                  END IF
               END IF  #FUN-C80001
               #刪除批/序號異動資料
               #EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
               EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_oga.oga02  #FUN-C80001
               IF SQLCA.SQLCODE THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del tlfs:'      #FUN-980092 add
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
 
           END IF
           #刪除tlf檔(收貨單) -->s_dbs_new no.3568 01/10/22
  ##NO.FUN-8C0131   add--begin  
       #    LET l_sql="SELECT * FROM ",s_dbs_tra CLIPPED,"tlf_file",  #FUN-A50102
             LET l_sql="SELECT * FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),   #FUN-A50102
                       " WHERE (tlf026 = ? ",
                       "   AND tlf027 = ?)",
                       "   AND (tlf036 = ? ",
                       "   AND tlf037 = ?)"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
           CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102                     
           DECLARE p830_u_tlf_c1 CURSOR FROM l_sql 
           LET l_i = 0 
           CALL la_tlf.clear()
           FOREACH p830_u_tlf_c1 USING g_pmm01,g_ogb.ogb32,
                                  g_rva01,g_ogb.ogb03  INTO g_tlf.*    
              LET l_i = l_i + 1
              LET la_tlf[l_i].* = g_tlf.*
           END FOREACH     
  ##NO.FUN-8C0131   add--end 
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),
                         " WHERE tlf026 = ? ",
                         "   AND tlf036 = ? "
           ELSE 
           #FUN-C80001---end 
       #    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"tlf_file",  #FUN-980092 add   #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ",
                         "   AND tlf027 = ?)",
                         "   AND (tlf036 = ? ",
                         "   AND tlf037 = ?)"
           END IF  #FUN-C80001
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del2_tlf FROM l_sql2
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              EXECUTE del2_tlf USING g_pmm01,g_rva01
              IF SQLCA.SQLCODE THEN
                 LET g_msg = s_dbs_tra CLIPPED,'del tlf'  
                 CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   
                 LET g_success='N'
              END IF
           ELSE
           #FUN-C80001---end
              EXECUTE del2_tlf USING g_pmm01,g_ogb.ogb32,                      #NO.FUN-620024
                                     g_rva01,g_ogb.ogb03
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_msg = s_dbs_tra CLIPPED,'del tlf'   #FUN-980092 add
                 CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
                 LET g_success='N'
              END IF
           END IF  #FUN-C80001
    ##NO.FUN-8C0131   add--begin
           FOR l_i = 1 TO la_tlf.getlength()
              LET g_tlf.* = la_tlf[l_i].*
              #IF NOT s_untlf1(s_dbs_tra) THEN 
              IF NOT s_untlf1(s_plant_new) THEN  #FUN-A50102
                 LET g_success='N' RETURN
              END IF 
           END FOR       
  ##NO.FUN-8C0131   add--end 
 
           #刪除批/序號異動資料
           #EXECUTE del_tlfss USING g_ogb.ogb04,g_rva01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
           EXECUTE del_tlfss USING g_ogb.ogb04,g_rva01,g_oga.oga02  #FUN-C80001
           IF SQLCA.SQLCODE THEN
              LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'    #FUN-980092 add
              CALL s_errmsg('','',g_msg,STATUS,1)
              LET g_success='N'
           END IF
           #FUN-B90012-add-str--
          #IF s_industry('icd') AND g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
           IF s_industry('icd') AND g_pod.pod08 <> 'Y' THEN  #FUN-D30099 
              LET l_sql2 = "SELECT rva06 FROM ",cl_get_target_table(s_plant_new,'rva_file'),
                           " WHERE rva01 = '",g_rva01,"'"
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
              PREPARE l_rva_p FROM l_sql2
              EXECUTE l_rva_p INTO l_rva06

              LET l_sql2 = "SELECT rvb_file.*,rvbiicd08,rvbiicd16 ",
                           "  FROM ",cl_get_target_table(s_plant_new,'rvb_file'),",",
                                     cl_get_target_table(s_plant_new,'rvbi_file'),
                           " WHERE rvb01 = '",g_rva01,"'",
                           "   AND rvb02 = '",g_ogb.ogb03,"'",
                           "   AND rvb01 = rvbi01 ",
                           "   AND rvb02 = rvbi02 "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
              PREPARE l_rvb_p FROM l_sql2
              EXECUTE l_rvb_p INTO l_rvb.*,l_rvbiicd08,l_rvbiicd16 

              LET l_pmn07 = NULL
              LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(s_plant_new,'pmn_file'),
                           " WHERE pmn01 = '",l_rvb.rvb04,"'",
                           "   AND pmn02 = '",l_rvb.rvb03,"'"
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
              PREPARE l_pmn_p FROM l_sql2
              EXECUTE l_pmn_p INTO l_pmn07

              CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                               l_pmn07,l_rvb.rvb07,g_rva01,g_ogb.ogb03,
                               l_rva06,'N','','',l_rvbiicd16,l_rvbiicd08,s_plant_new)
              RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success = 'N'
              END IF
           END IF
           #FUN-B90012-add-end--
 
           IF g_ima906 = '2' OR g_ima906 = '3' THEN
               #刪除tlff檔(收貨單) -->s_dbs_new 
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                  LET l_sql3="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlff_file' ),
                             " WHERE tlff026 = ? ",
                             "   AND tlff036 = ? "
               ELSE
               #FUN-C80001---end
           #    LET l_sql3="DELETE FROM ",s_dbs_tra CLIPPED,"tlff_file",  #FUN-980092 add   #FUN-A50102
                  LET l_sql3="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlff_file' ),   #FUN-A50102
                             " WHERE (tlff026 = ? ",
                             "   AND tlff027 = ?)",
                             "   AND (tlff036 = ? ",
                             "   AND tlff037 = ?)"
               END IF  #FUN-C80001
 	           CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
               CALL cl_parse_qry_sql(l_sql3,s_plant_new) RETURNING l_sql3 #FUN-980092
               PREPARE del2_tlf2 FROM l_sql3
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                  EXECUTE del2_tlf2 USING g_pmm01,g_rva01
                  IF SQLCA.SQLCODE THEN
                      LET g_msg = s_dbs_tra CLIPPED,'del tlff'  
                      CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   
                      LET g_success='N'
                  END IF
               ELSE 
               #FUN-C80001---end
                  EXECUTE del2_tlf2 USING g_pmm01,g_ogb.ogb32,                      #NO.FUN-620024
                                          g_rva01,g_ogb.ogb03
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                      LET g_msg = s_dbs_tra CLIPPED,'del tlff'   #FUN-980092 add
                      CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
                      LET g_success='N'
                  END IF
               END IF #FUN-C80001
               #刪除批/序號異動資料
               #EXECUTE del_tlfss USING g_ogb.ogb04,g_rva01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
               EXECUTE del_tlfss USING g_ogb.ogb04,g_rva01,g_oga.oga02  #FUN-C80001
               IF SQLCA.SQLCODE THEN
                  LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'    #FUN-980092 add
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
 
           END IF
           #刪除tlf檔(入庫單) -->s_dbs_new no.3568 01/10/22
  ##NO.FUN-8C0131   add--begin   
         #   LET l_sql =  " SELECT  * FROM ",s_dbs_tra CLIPPED,"tlf_file ",   #FUN-A50102
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"   
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102                      
            DECLARE p830_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p830_u_tlf_c2 USING g_rva01,g_ogb.ogb03,
                                       g_rvu01,g_ogb.ogb03  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ), 
                         " WHERE tlf026 = ? ",
                         "   AND tlf036 = ? "

           ELSE
           #FUN-C80001---end
       #    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"tlf_file",  #FUN-980092 add   #FUN-A50102
              LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ",
                         "   AND tlf027 = ?)",
                         "   AND (tlf036 = ? ",
                         "   AND tlf037 = ?)"
           END IF  #FUN-C80001
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del3_tlf FROM l_sql2
           #FUN-C80001---begin
          #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
           IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
              EXECUTE del3_tlf USING g_rva01,g_rvu01
              IF SQLCA.SQLCODE THEN
                  LET g_msg = s_dbs_tra CLIPPED,'del tlf'  
                  CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   
                  LET g_success='N'
              END IF
           ELSE
           #FUN-C80001---end
              EXECUTE del3_tlf USING g_rva01,g_ogb.ogb03,    #no.6178(收貨單)
                                     g_rvu01,g_ogb.ogb03
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_msg = s_dbs_tra CLIPPED,'del tlf'   #FUN-980092 add
                  CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
                  LET g_success='N'
              END IF
           END IF  #FUN-C80001
    ##NO.FUN-8C0131   add--begin
           FOR l_i = 1 TO la_tlf.getlength()
              LET g_tlf.* = la_tlf[l_i].*
              #IF NOT s_untlf1(s_dbs_tra) THEN 
              IF NOT s_untlf1(s_plant_new) THEN #FUN-A50102
                 LET g_success='N' RETURN
              END IF 
           END FOR       
  ##NO.FUN-8C0131   add--end 
 
           #刪除批/序號異動資料
           #EXECUTE del_tlfss USING g_ogb.ogb04,g_rvu01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
           EXECUTE del_tlfss USING g_ogb.ogb04,g_rvu01,g_oga.oga02  #FUN-C80001
           IF SQLCA.SQLCODE THEN
              LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'    #FUN-980092 add
              CALL s_errmsg('','',g_msg,STATUS,1)
              LET g_success='N'
           END IF
           #FUN-B90012-add-str--
          #IF s_industry('icd') AND g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
           IF s_industry('icd') AND g_pod.pod08 <> 'Y' THEN  #FUN-D30099
              LET l_sql2 = "SELECT rvu03 FROM ",cl_get_target_table(s_plant_new,'rvu_file'),
                           " WHERE rvu01 = '",g_rvu01,"'"
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
              PREPARE l_rvu_p FROM l_sql2
              EXECUTE l_rvu_p INTO l_rvu03

              LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                           "  FROM ",cl_get_target_table(s_plant_new,'rvv_file'),",",
                                     cl_get_target_table(s_plant_new,'rvvi_file'),
                           " WHERE rvv01 = '",g_rvu01,"'",
                           "   AND rvv02 = '",g_ogb.ogb03,"'",
                           "   AND rvv01 = rvvi01 ",
                           "   AND rvv02 = rvvi02 "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
              PREPARE b_rvv_p FROM l_sql2
              EXECUTE b_rvv_p INTO b_rvv.*,l_rvviicd02,l_rvviicd05

              CALL s_icdpost(11,b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                               b_rvv.rvv34,b_rvv.rvv35,b_rvv.rvv17,
                               g_rvu01,g_ogb.ogb03,l_rvu03,'N',
                               b_rvv.rvv04,b_rvv.rvv05,l_rvviicd05,
                               l_rvviicd02,s_plant_new)
              RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success = 'N'
              END IF
           END IF
           #FUN-B90012-add-end-- 
 
           IF g_ima906 = '2' OR g_ima906 = '3' THEN
               #刪除tlff檔(入庫單) -->s_dbs_new 
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                  LET l_sql3="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlff_file' ),   #FUN-A50102
                             " WHERE tlff026 = ? ",
                             "   AND tlff036 = ? "
               ELSE 
               #FUN-C80001---end
           #    LET l_sql3="DELETE FROM ",s_dbs_tra CLIPPED,"tlff_file",   #FUN-980092 add  #FUN-A50102
                  LET l_sql3="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlff_file' ),   #FUN-A50102
                             " WHERE (tlff026 = ? ",
                             "   AND tlff027 = ?)",
                             "   AND (tlff036 = ? ",
                             "   AND tlff037 = ?)"
               END IF  #FUN-C80001 
               CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
               CALL cl_parse_qry_sql(l_sql3,s_plant_new) RETURNING l_sql3 #FUN-980092
               PREPARE del3_tlf2 FROM l_sql3
               #FUN-C80001---begin
              #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                  EXECUTE del3_tlf2 USING g_rva01,g_rvu01
                  IF SQLCA.SQLCODE THEN
                     LET g_msg = s_dbs_tra CLIPPED,'del tlff' 
                     CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)                      
                     LET g_success='N'
                  END IF
               ELSE
               #FUN-C80001---end
                  EXECUTE del3_tlf2 USING g_rva01,g_ogb.ogb03,    #no.6178(收貨單)
                                          g_rvu01,g_ogb.ogb03
                  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                     LET g_msg = s_dbs_tra CLIPPED,'del tlff'  #FUN-980092 add
                     CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)  #No.FUN-710046                      
                     LET g_success='N'
                  END IF
               END IF  #FUN-C80001
               #刪除批/序號異動資料
               #EXECUTE del_tlfss USING g_ogb.ogb04,g_rvu01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
               EXECUTE del_tlfss USING g_ogb.ogb04,g_rvu01,g_oga.oga02  #FUN-C80001
               IF SQLCA.SQLCODE THEN
                  LET g_msg = s_dbs_tra CLIPPED,'del tlfs:'     #FUN-980092 add
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
 
           END IF
       END IF
       IF l_aza50 = 'Y' THEN                  #使用分銷功能
          IF l_oga.oga00 = '6' THEN           #有代送銷退單生成
             #獲取代送銷退單資料
             LET l_sql = " SELECT oha01,oha02,ohb03,ohb31,ohb32,",
                         " ohb04,ohb09,ohb091,ohb092,ohb12,",
                         " ohb15_fac,ohb910,ohb912,ohb913,ohb915",
                    #     "   FROM ",l_dbs_tra CLIPPED,   #FUN-980092 add   #FUN-A50102
                    #     "oha_file,", l_dbs_tra CLIPPED, "ohb_file",#FUN-980092 add   #FUN-A50102
                         "   FROM ",cl_get_target_table( l_plant_new, 'oha_file' ),",",   #FUN-A50102
                                    cl_get_target_table( l_plant_new, 'ohb_file' ),       #FUN-A50102
                         "  WHERE oha1018 ='",l_oga.oga01,"'", 
                         "    AND oha05 = '1' ",
                         "    AND (oha10 IS NULL OR oha10 =' ' ) ",   #帳單編號必須為null
                         "    AND oha01 = ohb01 "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE oha01_pre FROM l_sql
             DECLARE oha01_cs CURSOR FOR oha01_pre
                OPEN oha01_cs 
             FETCH oha01_cs INTO l_oha01,l_oha.oha02,l_ohb.ohb03,
                                 l_ohb.ohb31,l_ohb.ohb32,l_ohb.ohb04,
                                 l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                 l_ohb.ohb12,l_ohb.ohb15_fac,l_ohb.ohb910,
                                 l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb915  #代送之銷退單
             IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'  #FUN-980092 add
                CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
                LET g_success = 'N'
             END IF
 
             #刪除tlf檔(銷退單) -->l_dbs_new                                                
  ##NO.FUN-8C0131   add--begin   
        #    LET l_sql =  " SELECT  * FROM ",l_dbs_tra CLIPPED,"tlf_file ",    #FUN-A50102
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),    #FUN-A50102  
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"   
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102                      
            DECLARE p830_u_tlf_c3 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p830_u_tlf_c3 USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
           #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-980092 add  #FUN-A50102
             LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlf_file' ),  #FUN-A50102
                        " WHERE (tlf026 = ? ",
                        "   AND tlf027 = ?)",
                        "   AND (tlf036 = ? ",
                        "   AND tlf037 = ?)"
 	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
             CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
             PREPARE del0_tlfa FROM l_sql2
             EXECUTE del0_tlfa USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03 
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN 
                LET g_msg = l_dbs_tra CLIPPED,'del tlf'   #FUN-980092 add
                CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046                  
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
 
             #刪除tlff檔(銷退單) -->l_dbs_new
             IF g_ima906 = '2' OR g_ima906 = '3' THEN
              #  LET l_sql3="DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file",   #FUN-A50102
                LET l_sql3="DELETE FROM ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
                           " WHERE (tlff026 = ? ",
                           "   AND tlff027 = ?)",
                           "   AND (tlff036 = ? ",
                           "   AND tlff037 = ?)"
 	            CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
                PREPARE del_tlf2a FROM l_sql3
                EXECUTE del_tlf2a USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03 
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del tlff'   #FUN-980092 add
                   CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
                   LET g_success='N'
                END IF
             END IF
 
             #更新img，imgg，ima
             IF i = p_last THEN
                CALL s_mupimg(-1,l_ohb.ohb04, l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                              l_ohb.ohb12*l_ohb.ohb15_fac,l_oha.oha02,l_azp.azp01,0,'','')  #No.FUN-870007
                IF g_ima906 = '2' THEN
                   CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                  l_ohb.ohb910,l_ohb.ohb912, l_oha.oha02,l_plant_new) #FUN-980092 add
                   CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                  l_ohb.ohb913,l_ohb.ohb915, l_oha.oha02, l_plant_new)   #FUN-980092 add
                ELSE
                   IF g_ima906 = '3' THEN
                      CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                     l_ohb.ohb913,l_ohb.ohb915, g_oha.oha02, l_plant_new) #FUN-980092 add
                   END IF
                END IF
                CALL s_mudima(l_ohb.ohb04,l_plant_new) #FUN-980092 add
             END IF
 
#            #FUN-C50136--add-str--
#            IF g_oaz.oaz96 ='Y' THEN
#               LET l_sql2 = "SELECT oha03 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
#                            " WHERE oha01 = ? ",
#                            "   AND oha05 ='1'"
#               PREPARE sel_oha FROM l_sql2
#               EXECUTE sel_oha USING l_oha01 INTO l_oha03
#               CALL s_ccc_oia07('G',l_oha03) RETURNING l_oia07
#               IF l_oia07 = '0' THEN
#                  CALL s_ccc_rback(l_oha03,'G',l_oha01,0,l_plant_new)
#               END IF
#            END IF
#            #FUN-C50136--add-end--
             #刪除銷退單資料
           #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092 add   #FUN-A50102
             LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                        " WHERE oha01= ? ",
                        "   AND oha05='1'   "     
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
             PREPARE del_oha FROM l_sql2
             EXECUTE del_oha USING l_oha01
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra CLIPPED,'del oha:'      #FUN-980092 add
                CALL s_errmsg('','',g_msg,STATUS,1)   #No.FUN-710046 
                LET g_success='N'
             END IF
           #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ohb_file",  #FUN-980092 add   #FUN-A50102
             LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ohb_file' ),   #FUN-A50102
                        " WHERE ohb01= ? "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
             PREPARE del_ohb FROM l_sql2
             EXECUTE del_ohb USING l_oha01
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_tra CLIPPED,'del ohb:'   #FUN-980092 add
                   CALL s_errmsg('','',g_msg,STATUS,1)   #No.FUN-710046 
                   LET g_success='N'
    #FUN-B70074-add-str--
             ELSE 
                IF NOT s_industry('std') THEN 
                   IF NOT s_del_ohbi(l_oha01,'',l_plant_new) THEN 
                      LET g_success='N'
                   END IF 
                END IF
    #FUN-B70074-add-end--
             END IF
          END IF
       END IF
 
       IF NOT p830_chkoeo(g_ogb.ogb31, 
                          g_ogb.ogb32,g_ogb.ogb04) THEN #No.7742
            #更新採購單身之入庫量及交貨量
          #  LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add   # FUN-A50102
            LET l_sql2="UPDATE ",cl_get_target_table( s_plant_new, 'pmn_file' ),   # FUN-A50102
                    " SET pmn50 = pmn50 - ?,",
                    "     pmn53 = pmn53 - ? ",
                     " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-530005
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn FROM l_sql2
            EXECUTE upd_pmn USING 
                 g_ogb.ogb12,g_ogb.ogb12,
                 g_pmm01,g_ogb.ogb32         #NO.FUN-620024
            IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_msg = s_dbs_tra CLIPPED,'upd pmn'   #FUN-980092 add
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046 
               LET g_success = 'N'
            END IF
          
            #取流程代碼中之銷單資料
         #   LET l_sql2="SELECT *  FROM ",l_dbs_tra CLIPPED,"oeb_file",   #FUN-980092 add   #FUN-A50102
            LET l_sql2="SELECT *  FROM ",cl_get_target_table( l_plant_new, 'oeb_file' ),    #FUN-A50102
                    " WHERE oeb01 ='",g_ogb.ogb31,"' ",
                    "   AND oeb03 =",g_ogb.ogb32
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE oeb_cu2  FROM l_sql2
            DECLARE oeb_p2 CURSOR FOR oeb_cu2
            OPEN oeb_p2 
            FETCH oeb_p2 INTO l_oeb.* 
            CLOSE oeb_p2 
            IF SQLCA.sqlcode<>0 THEN
                CALL s_errmsg('','','sel oeb_p2:',SQLCA.sqlcode,1) #No.FUN-710046 
                LET g_success = 'N'
            END IF
            #更新銷單資料
        #    LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add    #FUN-A50102
            LET l_sql2="UPDATE ",cl_get_target_table( l_plant_new, 'oeb_file' ),    #FUN-A50102
                    " SET oeb24=oeb24 - ? ",
                    " WHERE oeb01 = ? AND oeb03 = ? "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_oeb2 FROM l_sql2
            EXECUTE upd_oeb2 USING 
                    g_ogb.ogb12, g_ogb.ogb31,g_ogb.ogb32
            IF SQLCA.sqlcode<>0 THEN
              LET g_msg = l_dbs_tra CLIPPED,'upd oeb24'  #FUN-980092 add     
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)   #No.FUN-710046                  
               LET g_success = 'N'
            END IF
            LET l_oea62 = l_oea62 + g_ogb.ogb12*l_oeb.oeb13
            IF i = 1 THEN
                 #讀取來源銷單資料
                 SELECT * INTO g_oeb.*
                   FROM oeb_file
                  WHERE oeb01 = g_oea.oea01 AND oeb03 = g_ogb.ogb32 #NO.FUN-620024
                 #更新來源銷單之已出貨量
                 UPDATE oeb_file
                   SET oeb24 = oeb24 - g_ogb.ogb12
                  WHERE oeb01 = g_oea.oea01 AND oeb03 = g_ogb.ogb32 #NO.FUN-620024
                 IF SQLCA.sqlcode<>0 THEN
                     LET g_showmsg= g_oea.oea01,"/", g_ogb.ogb32   #No.FUN-710046                               
                     CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd2 oeb24:',SQLCA.sqlcode,1)  #No.FUN-710046             
                     LET g_success = 'N'
                 END IF
                 LET s_oea62 = g_ogb.ogb12*g_oeb.oeb13
                 #更新來源訂單之訂單 2000/02/24 add
                 UPDATE oea_file
                    SET oea62 = oea62- s_oea62   #已出貨未稅金額
                    WHERE oea01=g_oea.oea01 #NO.FUN-620024
                 IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                    CALL s_errmsg('oea01',g_oea.oea01,'upd oea62',STATUS,1)  #No.FUN-710046  
                    LET g_success='N' 
                 END IF
             END IF
       END IF #No.7742(end)
    END FOREACH {ogb_cus}
    #FUN-C80001---begin
   #IF s_industry('icd') AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
    IF s_industry('icd') AND g_pod.pod08 = 'Y' THEN  #FUN-D30099

       LET l_sql2 = "SELECT rva06 FROM ",cl_get_target_table(s_plant_new,'rva_file'),
                    " WHERE rva01 = '",g_rva01,"'"
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
       PREPARE l_rva_p1 FROM l_sql2
       EXECUTE l_rva_p1 INTO l_rva06

       LET l_sql2 = "SELECT rvb_file.*,rvbiicd08,rvbiicd16 ",
                    "  FROM ",cl_get_target_table(s_plant_new,'rvb_file'),",",
                              cl_get_target_table(s_plant_new,'rvbi_file'),
                    " WHERE rvb01 = '",g_rva01,"'",
                    "   AND rvb01 = rvbi01 ",
                    "   AND rvb02 = rvbi02 "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
       DECLARE l_rvb_c1 CURSOR FROM l_sql2
       FOREACH l_rvb_c1 INTO l_rvb.*,l_rvbiicd08,l_rvbiicd16 

          LET l_pmn07 = NULL
          LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(s_plant_new,'pmn_file'),
                       " WHERE pmn01 = '",l_rvb.rvb04,"'",
                       "   AND pmn02 = '",l_rvb.rvb03,"'"
          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
          CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
          PREPARE l_pmn_p1 FROM l_sql2
          EXECUTE l_pmn_p1 INTO l_pmn07

          CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                            l_pmn07,l_rvb.rvb07,g_rva01,l_rvb.rvb02,
                            l_rva06,'N','','',l_rvbiicd16,l_rvbiicd08,s_plant_new)
          RETURNING l_flag
          IF l_flag = 0 THEN
             LET g_success = 'N'
          END IF
       END FOREACH 
    
       LET l_sql2 = "SELECT rvu03 FROM ",cl_get_target_table(s_plant_new,'rvu_file'),
                    " WHERE rvu01 = '",g_rvu01,"'"
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
       PREPARE l_rvu_p1 FROM l_sql2
       EXECUTE l_rvu_p1 INTO l_rvu03

       LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                    "  FROM ",cl_get_target_table(s_plant_new,'rvv_file'),",",
                              cl_get_target_table(s_plant_new,'rvvi_file'),
                    " WHERE rvv01 = '",g_rvu01,"'",
                    "   AND rvv01 = rvvi01 ",
                    "   AND rvv02 = rvvi02 "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
       DECLARE b_rvv_c1 CURSOR FROM l_sql2
       
       FOREACH  b_rvv_c1 INTO b_rvv.*,l_rvviicd02,l_rvviicd05
          CALL s_icdpost(11,b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                            b_rvv.rvv34,b_rvv.rvv35,b_rvv.rvv17,
                            g_rvu01,b_rvv.rvv02,l_rvu03,'N',
                            b_rvv.rvv04,b_rvv.rvv05,l_rvviicd05,
                            l_rvviicd02,s_plant_new)
          RETURNING l_flag
          IF l_flag = 0 THEN
             LET g_success = 'N'
          END IF
       END FOREACH 
    END IF
    #FUN-C80001---end
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
    #更新銷單單頭資料
#    LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add  #FUN-A50102
    LET l_sql2="UPDATE ",cl_get_target_table( l_plant_new, 'oea_file' ),  #FUN-A50102
            " SET oea62=oea62 - ? ",
            " WHERE oea01 = ?  "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE upd_oea2 FROM l_sql2
    EXECUTE upd_oea2 USING l_oea62, g_ogb.ogb31
    IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('','','upd oea62:',SQLCA.sqlcode,1)    #No.FUN-710046
        LET g_success = 'N'
    END IF
    #-------------------刪除各單據資料-------------------
    #刪除批/序號資料檔(rvbs_file)
  #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file",   #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'rvbs_file' ),    #FUN-A50102
               " WHERE rvbs00 = ? ",
               "   AND rvbs01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_rvbsl FROM l_sql2
 
#    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvbs_file' ),    #FUN-A50102
               " WHERE rvbs00 = ? ",
               "   AND rvbs01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_rvbss FROM l_sql2
 
#   #FUN-C50136--add-str--
#   IF g_oaz.oaz96 ='Y' THEN
#      LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                   " WHERE oga01 = ? ",
#                   "   AND oga09 ='4'"
#      PREPARE sel_oga FROM l_sql2
#      EXECUTE sel_oga USING g_oga01 INTO l_oga03
#      CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#      IF l_oia07 = '0' THEN
#         CALL s_ccc_rback(l_oga03,'D',g_oga01,0,l_plant_new)
#      END IF
#   END IF
#   #FUN-C50136--add-end--
    #刪除出貨單單頭檔(oga_file)
  #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),   #FUN-A50102
               " WHERE oga01= ? ",
               "   AND oga09='4'   "     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_oga FROM l_sql2
    EXECUTE del_oga USING g_oga01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
       LET g_msg = l_dbs_tra CLIPPED,'del oga:'    #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046 
       LET g_success='N'
    END IF
 
    #出貨單單身 -->l_dbs_new
  #  LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogb_file' ),   #FUN-A50102
               " WHERE ogb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_ogb FROM l_sql2
    EXECUTE del_ogb USING g_oga01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
       LET g_msg = l_dbs_tra CLIPPED,'del ogb:'           #No.FUN-710046   #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)            #No.FUN-710046 
       LET g_success='N'
    ELSE
       IF NOT s_industry('std') THEN
          IF NOT s_del_ogbi(g_oga01,'',l_plant_new) THEN #FUN-980092 add
             LET g_success = 'N'
          END IF
       END IF
    END IF
    #FUN-C80001---begin
    LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogc_file' ),   
               " WHERE ogc01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
    PREPARE del_ogc FROM l_sql2
    EXECUTE del_ogc USING g_oga01
    IF SQLCA.SQLCODE THEN
       LET g_msg = l_dbs_tra CLIPPED,'del ogc:'          
       CALL s_errmsg('','',g_msg,STATUS,1)           
       LET g_success='N'
    END IF 
    LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogg_file' ),   
               " WHERE ogg01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
    PREPARE del_ogg FROM l_sql2
    EXECUTE del_ogg USING g_oga01
    IF SQLCA.SQLCODE THEN
       LET g_msg = l_dbs_tra CLIPPED,'del ogg:'          
       CALL s_errmsg('','',g_msg,STATUS,1)           
       LET g_success='N'
    END IF 
    #FUN-C80001---end
    #刪除批/序號資料
    EXECUTE del_rvbsl USING 'axmt820',g_oga01
    IF SQLCA.SQLCODE THEN
       LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'     #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)
       LET g_success='N'
    END IF
    #FUN-B90012-add-str--
    IF s_industry('icd') THEN
        CALL icd_idb_del(g_oga01,'',l_plant_new)
        #FUN-C80001---begin
        LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'idd_file' ),  
                   " WHERE idd10= ? "
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2
        PREPARE del_idd1 FROM l_sql2
        EXECUTE del_idd1 USING g_rva01
        IF SQLCA.SQLCODE  THEN
           LET g_msg = s_dbs_tra CLIPPED,'del idd:'    
           CALL s_errmsg('','',g_msg,STATUS,1)     
           LET g_success='N'
        END IF
        EXECUTE del_idd1 USING g_rvu01
        IF SQLCA.SQLCODE  THEN
           LET g_msg = s_dbs_tra CLIPPED,'del idd:'    
           CALL s_errmsg('','',g_msg,STATUS,1)     
           LET g_success='N'
        END IF   
        #FUN-C80001---end
    END IF
    #FUN-B90012-add-end--
 
    #刪除收貨單頭檔-->s_dbs_new
#    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rva_file",   #FUN-980092 add  #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rva_file' ),   #FUN-A50102
               " WHERE rva01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_rva FROM l_sql2
    EXECUTE del_rva USING g_rva01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
       LET g_msg = s_dbs_tra CLIPPED,'del rva:'       #FUN-980092 add
        CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046 
        LET g_success='N'
    END IF
    #刪除收貨單身檔-->s_dbs_new
#    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rvb_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvb_file' ),   #FUN-A50102
               " WHERE rvb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_rvb FROM l_sql2
    EXECUTE del_rvb USING g_rva01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
       LET g_msg = s_dbs_tra CLIPPED,'del rvb:'  #FUN-980092 add
        CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046           
        LET g_success='N'
    ELSE
       IF NOT s_industry('std') THEN
          IF NOT s_del_rvbi(g_rva01,'',s_plant_new) THEN #FUN-980092 add
             LET g_success = 'N'
          END IF
       END IF
    END IF
 
    #刪除批/序號資料
    EXECUTE del_rvbss USING 'apmt300',g_rva01
    IF SQLCA.SQLCODE THEN
       LET g_msg = s_dbs_tra CLIPPED,'del rvbs:'     #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)
       LET g_success='N'
    END IF
 
    #FUN-B90012-add-str--
    IF s_industry('icd') THEN
       CALL icd_ida_del(g_rva01,'',s_plant_new)
    END IF
    #FUN-B90012-add-end--
    #刪除入庫單頭檔-->s_dbs_new
#    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rvu_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvu_file' ),   #FUN-A50102
               " WHERE rvu01= ? ",
               "   AND rvu00='1'"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE del_rvu FROM l_sql2
    EXECUTE del_rvu USING g_rvu01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_msg = s_dbs_tra CLIPPED,'del rvu:'   #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)           #No.FUN-710046 
       LET g_success='N'
    END IF
 
    #刪除入庫單身檔-->s_dbs_new
#    LET l_sql2 = "SELECT * FROM ",s_dbs_tra CLIPPED,"rvv_file",  #FUN-980092 add     #FUN-A50102
    LET l_sql2 = "SELECT * FROM ",cl_get_target_table( s_plant_new, 'rvv_file' ),     #FUN-A50102
                 " WHERE rvv01= ? ",
                 "   AND rvv03='1'"
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2		#FUN-920032
    CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE rvv_pre FROM l_sql2				#MOD-990145
    DECLARE rvv_cus CURSOR FOR rvv_pre			#MOD-990145
    FOREACH rvv_cus USING g_rvu01 INTO l_rvv.*		#MOD-990145
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL s_iqctype_rvv(l_rvv.rvv01,l_rvv.rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg  #FUN-BC0104
  #    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rvv_file",  #FUN-980092 add   #FUN-A50102
       LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvv_file' ),   #FUN-A50102
                  " WHERE rvv01= ? ",
                  "   AND rvv02= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
       PREPARE del_rvv FROM l_sql2
       EXECUTE del_rvv USING l_rvv.rvv01,l_rvv.rvv02
       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_msg = s_dbs_tra CLIPPED,'del rvv:'  #FUN-980092 add
           CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046 
           LET g_success='N'
           CONTINUE FOREACH        #No.FUN-830132 080401 add
       ELSE
          #FUN-BC0104-add-str--
          IF l_flagg = 'Y' THEN
             CALL s_qcl05_sel(l_rvv46) RETURNING l_qcl05
             IF l_qcl05='1' THEN LET l_type1='5' ELSE LET l_type1 ='1' END IF 
             IF NOT s_iqctype_upd_qco20(l_rvv04,l_rvv05,l_rvv45,l_rvv47,l_type1) THEN 
                LET g_success='N'
                CONTINUE FOREACH
             END IF
          END IF
          #FUN-BC0104-add-end--
          IF NOT s_industry('std') THEN
             IF NOT s_del_rvvi(l_rvv.rvv01,l_rvv.rvv02,s_plant_new) THEN  #FUN-980092 add
                LET g_success = 'N'
                CONTINUE FOREACH  #No.FUN-830132 080401 add
             END IF
          END IF
       END IF
    END FOREACH                    #No.FUN-830132 080401 add
 
    #刪除批/序號資料
   #EXECUTE del_rvbss USING 'axmt740',g_rvu01  #FUN-C80001 mark
    EXECUTE del_rvbss USING 'apmt740',g_rvu01  #FUN-C80001 add
    IF SQLCA.SQLCODE THEN
       LET g_msg = s_dbs_tra CLIPPED,'del rvbs:'    #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)
       LET g_success='N'
    END IF
    #FUN-B90012-add-str--
    IF s_industry('icd') THEN
       CALL icd_ida_del(g_rvu01,'',s_plant_new)
    END IF
    #FUN-B90012-add-end--
 
    #no.FUN-780025 刪除出貨單序號檔--------------------------
    SELECT COUNT(*) INTO l_ogbb_cnt 
      FROM ogbb_file
     WHERE ogbb01 = l_oga.oga01
    IF l_ogbb_cnt > 0 THEN
   #    LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogbb_file", #FUN-980092 add   #FUN-A50102
        LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogbb_file' ), #FUN-A50102
                   " WHERE ogbb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_ogbb FROM l_sql2
        EXECUTE del_ogbb USING l_oga.oga01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_msg = l_dbs_tra CLIPPED,'del ogbb:'  #FUN-980092 add
            CALL s_errmsg('','',g_msg,STATUS,1)  
            LET g_success='N'
        END IF 
    END IF
 
    IF (g_oaz.oaz67 = '2' AND g_oax.oax05='Y') THEN    #FUN-670007
    #NO.FUN-670007 來源為出貨單時才DELETE (PACKING/INVOICE)，不然就在axmp831處理
        SELECT COUNT(*) INTO g_cnt FROM ogd_file,oga_file
         WHERE ogd01=oga01 AND oga99=g_oga.oga99 AND oga30='Y'     #MOD-9C0140
        IF g_cnt> 0 THEN               #有輸入Packing List才拋轉
            LET l_ogd01 = g_oga01
            IF NOT cl_null(g_oga01) THEN   #本區有抓到出貨單號時再DELETE
                #刪除包裝單身檔-->l_dbs_new
             #   LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add   #FUN-A50102
                LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ogd_file' ),   #FUN-A50102
                           " WHERE ogd01= ? "
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                PREPARE del_ogd FROM l_sql2
                EXECUTE del_ogd USING l_ogd01
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                   LET g_msg = l_dbs_tra CLIPPED,'del ogd:'  #FUN-980092 add
                    CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046          
                    LET g_success='N'
                END IF
                IF NOT s_industry('std') THEN
                   IF NOT s_del_ogdi(l_ogd01,'','',l_plant_new) THEN #FUN-980092 add
                      LET g_success = 'N'
                   END IF
                END IF
            END IF    #FUN-670007
        END IF        #MOD-A10139
    END IF            #MOD-A10139
    IF g_oax.oax04='Y' AND g_oaz.oaz67 = '2' AND NOT cl_null(g_ofa01) THEN    #NO.FUN-670007
        SELECT * INTO g_ofa.* FROM ofa_file
         WHERE ofa01=g_oga.oga27
        #刪除Invoice單頭檔-->l_dbs_new
     #   LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ofa_file",  #FUN-980092 add  #FUN-A50102
        LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ofa_file' ),  #FUN-A50102
         " WHERE ofa01= ? "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_ofa FROM l_sql2
        EXECUTE del_ofa USING g_ofa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_msg = l_dbs_new CLIPPED,'del ofa:' #FUN-980092 add
            CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046                 
            LET g_success='N'
        END IF
        #刪除Invoice單身檔-->l_dbs_new
   #     LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ofb_file",  #FUN-980092 add     #FUN-A50102
        LET l_sql2="DELETE FROM ",cl_get_target_table( l_plant_new, 'ofb_file' ),     #FUN-A50102
                   " WHERE ofb01= ? "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
        PREPARE del_ofb FROM l_sql2
        EXECUTE del_ofb USING g_ofa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_msg = l_dbs_tra CLIPPED,'del ofb:' #FUN-980092 add
            CALL s_errmsg('','',g_msg,STATUS,1)          #No.FUN-710046 
            LET g_success='N'
        END IF
    END IF        #FUN-670007
       #END IF            #MOD-A10139 mark
   #END IF                #MOD-A10139 mark
END FUNCTION
 
#當有設定中斷工廠時，因中斷站只產生收貨資料，沒有出貨及入庫資料
#所以不能全部都一併處理,應再依此站己產生的單據來做為刪除的依據
FUNCTION p830_poz(p_plant)  #FUN-980092 add
DEFINE p_dbs    LIKE type_file.chr21    
DEFINE p_poy04  LIKE poy_file.poy04 
DEFINE l_rvb01  LIKE rvb_file.rvb01
DEFINE l_rvb02  LIKE rvb_file.rvb02
DEFINE l_rvb03  LIKE rvb_file.rvb03
DEFINE l_rvb04  LIKE rvb_file.rvb04
DEFINE l_azp03 LIKE azp_file.azp03  #FUN-980092 add
DEFINE p_plant LIKE azp_file.azp01  #FUN-980092 add
DEFINE l_dbs   LIKE azp_file.azp03  #FUN-980092 add
DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
    
    IF NOT cl_null(p_plant) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
       LET l_dbs = s_dbstring(l_azp03)
 
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
       LET p_dbs = g_dbs_tra
    END IF
 
     LET g_sql = " SELECT rvb01,rvb02,rvb03,rvb04 ",
         #        "   FROM ",p_dbs CLIPPED,"rvb_file ",  #FUN-A50102
                 "   FROM ",cl_get_target_table( g_plant_new, 'rvb_file' ),   #FUN-50102
                 "  WHERE rvb01 ='",g_rva01,"'"
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql( g_sql, g_plant_new ) RETURNING g_sql     #FUN-A50102
     PREPARE rvb01_pre FROM g_sql
     DECLARE rvb01_cs CURSOR FOR rvb01_pre
     FOREACH rvb01_cs INTO l_rvb01,l_rvb02,l_rvb03,l_rvb04           #收貨單
     IF SQLCA.SQLCODE THEN
        LET g_msg = p_dbs CLIPPED,'fetch rvb01_cs'      #FUN-980092 add
        CALL cl_err(g_msg,SQLCA.SQLCODE,1)  
        LET g_success = 'N'                
     END IF
        #刪除tlf檔(收貨單) -->s_dbs_new no.3568 01/10/22
  ##NO.FUN-8C0131   add--begin   
       #     LET l_sql =  " SELECT  * FROM ",s_dbs_tra CLIPPED,"tlf_file ",    #FUN-A50102
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),   #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"   
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    #FUN-A50102
            CALL cl_parse_qry_sql( l_sql, s_plant_new ) RETURNING l_sql     #FUN-A50102                         
            DECLARE p832_u_tlf_c5 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p832_u_tlf_c5 USING l_rvb04,l_rvb03,
                                        l_rvb01,l_rvb02 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
   #     LET g_sql="DELETE FROM ",s_dbs_tra CLIPPED,"tlf_file",  #FUN-980092 add    #FUN-A50102
        LET g_sql="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlf_file' ),    #FUN-A50102
                   " WHERE (tlf026 = ? ",
                   "   AND tlf027 = ?)",
                   "   AND (tlf036 = ? ",
                   "   AND tlf037 = ?)"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,s_plant_new) RETURNING g_sql #FUN-980092
        PREPARE del_poz_tlf FROM g_sql
        EXECUTE del_poz_tlf USING l_rvb04,l_rvb03, 
                               l_rvb01,l_rvb02
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg = s_dbs_tra CLIPPED,'del tlf'  #FUN-980092 add
            CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            LET g_success='N'
        END IF
    ##NO.FUN-8C0131   add--begin
        FOR l_i = 1 TO la_tlf.getlength()
           LET g_tlf.* = la_tlf[l_i].*
           #IF NOT s_untlf1(s_dbs_tra) THEN
          IF NOT s_untlf1(s_plant_new) THEN  #FUN-A50102
              LET g_success='N' RETURN
           END IF 
        END FOR       
  ##NO.FUN-8C0131   add--end 
        IF g_ima906 = '2' OR g_ima906 = '3' THEN
            #刪除tlff檔(收貨單) -->s_dbs_new 
     #       LET g_sql="DELETE FROM ",s_dbs_tra CLIPPED,"tlff_file",  #FUN-980092 add   #FUN-A50102
            LET g_sql="DELETE FROM ",cl_get_target_table( s_plant_new, 'tlff_file' ),  #FUN-A50102
                       " WHERE (tlff026 = ? ",
                       "   AND tlff027 = ?)",
                       "   AND (tlff036 = ? ",
                       "   AND tlff037 = ?)"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,s_plant_new) RETURNING g_sql #FUN-980092
            PREPARE del_poz_tlff FROM g_sql
            EXECUTE del_poz_tlff USING l_rvb04,l_rvb03,l_rvb01,l_rvb02
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                LET g_msg = s_dbs_tra CLIPPED,'del tlff' #FUN-980092 add
                CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                LET g_success='N'
            END IF
        END IF
   END FOREACH
 
   #刪除收貨單頭檔-->s_dbs_new
 #  LET g_sql="DELETE FROM ",s_dbs_tra CLIPPED,"rva_file",#FUN-980092 add   #FUN-A50102
   LET g_sql="DELETE FROM ",cl_get_target_table( s_plant_new, 'rva_file' ), #FUN-A50102
              " WHERE rva01= ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,s_plant_new) RETURNING g_sql #FUN-980092
   PREPARE del_poz_rva FROM g_sql
   EXECUTE del_poz_rva USING g_rva01
   IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_msg = s_dbs_tra CLIPPED,'del rva:'   #FUN-980092 add
       CALL s_errmsg('','',g_msg,STATUS,1)      #No.FUN-710046
       LET g_success='N'
   END IF
   #刪除收貨單身檔-->s_dbs_new
#   LET g_sql="DELETE FROM ",s_dbs_tra CLIPPED,"rvb_file",  #FUN-980092 add     #FUN-A50102
    LET g_sql="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvb_file' ),    #FUN-A50102
              " WHERE rvb01= ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,s_plant_new) RETURNING g_sql #FUN-980092
   PREPARE del_poz_rvb FROM g_sql
   EXECUTE del_poz_rvb USING g_rva01
   IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_msg = s_dbs_tra CLIPPED,'del rvb:'   #FUN-980092 add
       LET g_showmsg=s_dbs_new CLIPPED,'del rvb:'  #No.FUN-710046
       CALL s_errmsg('','',g_msg,STATUS,1)      #No.FUN-710046    
       LET g_success='N'
   ELSE
       IF NOT s_industry('std') THEN
          IF NOT s_del_rvbi(g_rva01,'',s_plant_new) THEN #FUN-980092 add
             LET g_success = 'N'
          END IF
       END IF
   END IF
 
   #刪除批/序號資料
   #  EXECUTE del_rvbss USING 'axmt300',g_rva01  #TQC-B80244 mark
   EXECUTE del_rvbss USING 'apmt300',g_rva01   #TQC-B80244 add
   IF SQLCA.SQLCODE THEN
      LET g_msg = s_dbs_tra CLIPPED,'del rvbs:'   #FUN-980092 add
      CALL s_errmsg('','',g_msg,STATUS,1)
      LET g_success='N'
   END IF
#FUN-C80001---add---START
    #刪除批/序號資料
    EXECUTE del_rvbss USING 'apmt740',g_rvu01  
    IF SQLCA.SQLCODE THEN
       LET g_msg = s_dbs_tra CLIPPED,'del rvbs:'    
       CALL s_errmsg('','',g_msg,STATUS,1)
       LET g_success='N'
    END IF 
#FUN-C80001---add-----END
   #FUN-B90012-add-str--
   IF s_industry('icd') THEN
      CALL icd_ida_del(g_rva01,'',s_plant_new)
   END IF
   #FUN-B90012-add-end-- 
END FUNCTION
 
#取得工廠資料並且 抓取要還原的單號
FUNCTION p830_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別 #No.FUN-680137 SMALLINT
         l_sql1   LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(800)
         l_front  LIKE type_file.num5     #FUN-670007
 
     ##-------------取得來源資料庫(P/O)-----------------
      LET l_front = l_n - 1
      LET l_source = l_n 
 
        SELECT * INTO s_poy.* FROM poy_file 
         WHERE poy01 = g_poz.poz01 AND poy02 = l_front    #FUN-670007
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_azp.azp03 CLIPPED,"."
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
 
     ##-------------取得當站資料庫(S/O)-----------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_n 
 
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_dbs_new = l_azp.azp03 CLIPPED,"." 
      LET l_plant_new = l_azp.azp01         #No.FUN-980059
      
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
      LET l_sql1 = "SELECT aza50 ",                                             
            #       "  FROM ",l_dbs_new CLIPPED,"aza_file ",      #FUN-A50102
                   "  FROM ",cl_get_target_table( l_plant_new, 'aza_file' ),  #FUN-A50102
                   "  WHERE aza01 = '0' "                                       
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1    #FUN-A50102
      PREPARE aza_p1 FROM l_sql1                                                
      IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','aza_p1',SQLCA.SQLCODE,1) #No.FUN-710046
      END IF        
      DECLARE aza_c1  CURSOR FOR aza_p1                                         
      OPEN aza_c1                                                               
      FETCH aza_c1 INTO l_aza50                                                 
      CLOSE aza_c1                                                              
END FUNCTION
 
#取得要還原的單號
FUNCTION p830_getno() 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE p_poy04  LIKE poy_file.poy04 
 
#     LET l_sql = " SELECT rva01 FROM ",s_dbs_tra CLIPPED,"rva_file ",#FUN-980092 add  #FUN-A50102
     LET l_sql = " SELECT rva01 FROM ",cl_get_target_table( s_plant_new, 'rva_file' ), #FUN-A50102
                 "  WHERE rva99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rva01_pre FROM l_sql
     DECLARE rva01_cs CURSOR FOR rva01_pre
     OPEN rva01_cs 
     FETCH rva01_cs INTO g_rva01                              #收貨單
     IF SQLCA.SQLCODE THEN
       LET g_msg = s_dbs_tra CLIPPED,'fetch rva01_cs'  #FUN-980092 add
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)      #No.FUN-710046
        LET g_success = 'N'                
     END IF
 
    #     LET l_sql = " SELECT rvu01 FROM ",s_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092 add    #FUN-A50102
         LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( s_plant_new, 'rvu_file' ),     #FUN-A50102
                     "  WHERE rvu99 ='",g_oga.oga99,"'",
                     "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
         PREPARE rvu01_pre FROM l_sql
         DECLARE rvu01_cs CURSOR FOR rvu01_pre
         OPEN rvu01_cs 
         FETCH rvu01_cs INTO g_rvu01                              #入庫單
         IF SQLCA.SQLCODE THEN
           LET g_msg = s_dbs_tra CLIPPED,'fetch rvu01_cs'  #FUN-980092 add
            CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)      #No.FUN-710046  
            LET g_success = 'N'              
         END IF
        # LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",   #FUN-980092 add    #FUN-A50102
         LET l_sql = " SELECT oga01 FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),      #FUN-A50102
                     "  WHERE oga99 ='",g_oga.oga99,"'",
                     "    AND oga09 = '4' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE oga01_pre FROM l_sql
         DECLARE oga01_cs CURSOR FOR oga01_pre
         OPEN oga01_cs 
         FETCH oga01_cs INTO g_oga01                              #出貨單
         IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'   #FUN-980092 add
            CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)      #No.FUN-710046              
            LET g_success = 'N'               
         END IF
 
         IF NOT cl_null(g_oga.oga27) AND g_oax.oax04 = 'Y' AND g_oaz.oaz67 = '2' THEN    #NO.FUN-670007              
         #   LET l_sql = " SELECT ofa01 FROM ",l_dbs_tra CLIPPED,"ofa_file ",  #FUN-980092 add    #FUN-A50102
            LET l_sql = " SELECT ofa01 FROM ",cl_get_target_table( l_plant_new, 'ofa_file' ),     #FUN-A50102
                        "  WHERE ofa99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE ofa01_pre FROM l_sql
            DECLARE ofa01_cs CURSOR FOR ofa01_pre
            OPEN ofa01_cs 
            FETCH ofa01_cs INTO g_ofa01                              #INVOICE#
            IF SQLCA.SQLCODE THEN
              LET g_msg = l_dbs_tra CLIPPED,'fetch ofa01_cs'  #FUN-980092 add
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)      #No.FUN-710046   
               LET g_success = 'N'                 
            END IF
         END IF
END FUNCTION
 
FUNCTION p830_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
#  LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_tra,"oeo_file ",  #FUN-980092 add   #FUN-A50102
  LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oeo_file' ),  #FUN-A50102
            "  WHERE oeo01 = '",p_oeo01,"'",
            "    AND oeo03 = '",p_oeo03,"'",
            "    AND oeo04 = '",p_oeo04,"'",
            "    AND oeo08 = '2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
  PREPARE chkoeo_pre FROM l_sql
  DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
  OPEN chkoeo_cs 
  FETCH chkoeo_cs INTO g_cnt
  IF g_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION 
 
#No.7993 清空多角序號
FUNCTION p830_flow99()
     
        UPDATE oga_file SET oga99 = ' ' WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga99',SQLCA.SQLCODE,1) #No.FUN-710046  
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN   #NO.FUN-670007
           UPDATE ofa_file SET ofa99= ' ' WHERE ofa01 = g_oga.oga27
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.SQLCODE,1) #No.FUN-710046
              LET g_success = 'N' RETURN
           END IF
        END IF
END FUNCTION 
#No:FUN-9C0071--------精簡程式-----
#FUN-C80001---begin
FUNCTION p830_idd_to_idb(p_idd,p_plant)
  DEFINE p_idd       RECORD LIKE idd_file.*
  DEFINE p_plant     LIKE type_file.chr21 
  DEFINE l_idb       RECORD LIKE idb_file.*
  DEFINE l_sql       STRING 
  
     INITIALIZE l_idb.* TO NULL
     LET l_idb.idb01 = p_idd.idd01
     LET l_idb.idb02 = p_idd.idd02
     LET l_idb.idb03 = p_idd.idd03
     LET l_idb.idb04 = p_idd.idd04
     LET l_idb.idb05 = p_idd.idd05
     LET l_idb.idb06 = p_idd.idd06
     LET l_idb.idb07 = p_idd.idd10
     LET l_idb.idb08 = p_idd.idd11
     LET l_idb.idb09 = g_oga.oga02
     LET l_idb.idb10 = p_idd.idd29
     LET l_idb.idb11 = p_idd.idd13
     LET l_idb.idb12 = p_idd.idd07
     LET l_idb.idb13 = p_idd.idd15
     LET l_idb.idb14 = p_idd.idd16
     LET l_idb.idb15 = p_idd.idd17
     LET l_idb.idb16 = p_idd.idd18
     LET l_idb.idb17 = p_idd.idd19
     LET l_idb.idb18 = p_idd.idd20
     LET l_idb.idb19 = p_idd.idd21
     LET l_idb.idb20 = p_idd.idd22
     LET l_idb.idb21 = p_idd.idd23
     LET l_idb.idb22 = ''
     LET l_idb.idb23 = ''
     LET l_idb.idb24 = ''
     LET l_idb.idb25 = p_idd.idd25
     LET l_idb.idbplant = p_idd.iddplant  
     LET l_idb.idblegal = p_idd.iddlegal 

     LET l_sql="INSERT INTO ",cl_get_target_table(p_plant, 'idb_file' ), 
                  " (idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10 ",
                  " ,idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20 ",
                  " ,idb21,idb22,idb23,idb24,idb25,idbplant,idblegal) ",
                  " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE ins_idb FROM l_sql
     EXECUTE ins_idb USING l_idb.idb01,l_idb.idb02,l_idb.idb03,l_idb.idb04,l_idb.idb05,
                           l_idb.idb06,l_idb.idb07,l_idb.idb08,l_idb.idb09,l_idb.idb10,
                           l_idb.idb11,l_idb.idb12,l_idb.idb13,l_idb.idb14,l_idb.idb15,
                           l_idb.idb16,l_idb.idb17,l_idb.idb18,l_idb.idb19,l_idb.idb20,
                           l_idb.idb21,l_idb.idb22,l_idb.idb23,l_idb.idb24,l_idb.idb25,
                           l_idb.idbplant,l_idb.idblegal
      
     IF SQLCA.SQLCODE THEN
        CALL cl_err('ins idb:',SQLCA.SQLCODE,0)
        LET g_success = 'N'
     END IF
END FUNCTION 
#FUN-C80001---end
