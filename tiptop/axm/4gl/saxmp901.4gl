# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp901.4gl
# Descriptions...: 三角貿易出貨單拋轉還原作業(逆拋時使用)
# Date & Author..: 98/12/14 By Linda
# Modify ........: 00/02/25 By Kammy 由 axmp901 改寫
# Modify.........: No.8047 03/09/03 By Kammy 1.銷售逆拋、採購逆拋合併
#                                            2.請注意：採購逆拋來源廠不拋出貨單
# Modify.........: No.9059 04/01/27 Kammy 代採買 call s_mupimg 應判斷為 i = 0
#                                         而且 i = 1
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.MOD-520099 05/03/03 By ching 出通單更新錯誤處理
# Modify.........: No.MOD-5C0147 05/12/28 By Nicola l_slip改抓ofa01
# Modify.........: No.TQC-5C0131 05/12/29 By Nicola 抓取l_slip時，多加一個條件
# Modify.........: No.FUN-620029 06/02/11 By Carrier 將axmp901拆開成axmp901及saxmp901
# Modify.........: No.FUN-620024 06/02/22 By Rayven 刪除產生的代送銷退單
# Modify.........: No.FUN-620054 06/03/08 By ice 增加對指定工廠的三角貿易出貨單拋轉還原
# Modify.........: No.MOD-660081 06/06/20 By Pengu 在第139,249行錯誤訊息有誤
# Modify.........: No.MOD-620076 06/06/21 By Mandy 當多訂單合併一出貨通知單時, 出貨單扣帳還原(call axmp901), 原拋轉至各站之出通單, packing還是會存在
# Modify.........: No.FUN-660167 06/06/27 By wujie cl_err-->cl_err3
# Modify.........: NO.FUN-670007 06/07/27 BY yiting 1.oaz203->oax04 ,oaz204->oax05
#                                                   2.拋轉還原時不再還原出通單，己有新增axmp911
#                                                   3.s_mutislip因應三角改善,加傳入站別參數以取得apmi000設定單別
#                                                   4.s_mchkARAP因MOD-680014多加入code參數，要多傳入一碼
# Modify.........: No.FUN-680137 06/09/11 By bnlent  欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-710019 07/01/11 BY yiting 三角專案
# Modify.........: No.FUN-710046 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: NO.MOD-740421 07/04/25 BY Yiting ofa011的抓取要指到目前要還原的工廠別，不然會抓不到還原單號
# Modify.........: No.MOD-770160 07/08/02 By Claire 拋轉還原時先確認是否存在銷退單
# Modify.........: NO.FUN-780025 07/08/31 BY yiting 拋轉還原出貨單時應一併刪除ogbb_file
# Modify.........: NO.MOD-7A0073 07/10/15 BY claire oan_file的check應取消,目前整合至poy_file
# Modify.........: NO.TQC-7C0059 07/12/07 by fangyan 增加出庫單號的開窗查詢
# Modify.........: No.CHI-7B0041 07/12/09 By claire 訊息調整 axm-305-->tri-012
# Modify.........: No.TQC-7C0146 07/12/19 By claire 拋轉還原要確認中斷點後單據是否已產生,若是則不可拋轉還原
# Modify.........: NO.TQC-7C0157 07/12/20 BY yiting 抓invoice資料前要先確認參數設定
# Modify.........: No.MOD-810094 08/01/11 By Claire (1)合併出貨重取單身訂單流程序號
#                                                   (2)重新取出貨單單身的項次及訂單項次
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-820102 08/03/18 By Claire MISC料在還原時不會回寫,已出貨量(oeb24)的更新
# Modify.........: No.CHI-830015 08/03/18 By Claire (1)axm-933訊息由控卡改為警告
#                                                   (2)訊息調整更明確
# Modify.........: No.MOD-830167 08/03/20 By Claire 中斷點的拋轉還原,pmn50沒有更新
# Modify.........: No.FUN-830132 08/04/01 By hellen 修改delete rvv_file
# Modify.........: No.MOD-840325 08/04/20 By claire 中斷點的rvv_file未刪除
# Modify.........: No.MOD-850041 08/05/06 By Claire sql要加入營運中心
# Modify.........: No.MOD-850150 08/05/15 By Claire axm-933要加入g_success='N'控卡
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.TQC-870035 08/07/24 By claire axm-026改為axm-934
# Modify.........: No.MOD-880002 08/08/01 By claire 開窗資料代採/銷售出貨單
# Modify.........: No.MOD-880076 08/08/15 By claire 判斷單身所屬的訂單是否已經結案,若結案則不可拋轉還原
# Modify.........: No.CHI-8B0047 09/01/14 By xiaofeizhu 正拋時不詢問是否自動產生出貨單，逆拋時才開窗詢問
# Modify.........: No.MOD-940054 09/04/07 By Dido 訊息調整 axm-305-->tri-012 
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.MOD-950285 09/05/26 By Dido 中斷點判斷邏輯調整
# Modify.........: No.MOD-970127 09/07/14 By Dido 增加中斷點刪除收貨單
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_mupimg傳參修改營運中心改成機構別
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990037 09/09/08 By Dido 中斷點交貨量累加問題與入庫單存在檢核邏輯調整 
# Modify.........: No.FUN-980059 09/09/10 By arman GP5.2架構,修改Sub相關傳入參數
# Modify.........: No.FUN-980092 09/09/22 By TSD.hoho GP5.2 跨資料庫語法修改 
# Modify.........: No.MOD-9C0305 09/12/21 By jan plant取值錯誤
# Modify.........: No.FUN-9C0073 10/01/06 By chenls   程序精簡
# Modify.........: No:FUN-A10099 10/01/20 By Carrier 入庫單串imgs_file時,傳錯單號
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A30134 10/04/19 By Smapmin 中斷點的情況下,入庫單可能產生後再作廢,故要將作廢的入庫單排除
# Modify.........: No.FUN-A50102 10/06/18 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80058 10/08/09 By Smapmin 中斷點的情況下,出貨單可能產生後再作廢,故要將作廢的出貨單排除
# Modify.........: NO:MOD-B30034 11/03/09 By Smapmin 若中斷點的收貨單已產生IQC單,也不可還原
# Modify.........: No.FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加多角ICD行業功能 
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: No:MOD-C20156 12/02/17 By Vampire FOREACH前沒有跑到DECLARE段,另拋轉還原也要刪除rvbs_file
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 排除需簽收的出貨單不拋轉(oga65='Y'),出貨單/簽收單傳入參數值修改
# Modify.........: No:MOD-C30755 12/06/07 By Vampire 判斷處理中斷點的地方,增加回寫pmn50
# Modify.........: No:MOD-C40140 12/06/08 By Vampire g_ogb.ogb12,g_pmm01,g_ogb.ogb32值會取不到
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: No.CHI-C80009 12/08/17 By Sakura 1.mark代採買段的多角ICD行業功能
#                                                   2.還原FUN-C40072 外部呼叫CALL p901_p2傳的參數值、transaction的判斷
# Modify.........: No.FUN-C80001 12/09/03 By bart 還原時需刪除ogc_file,ogg_file
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:MOD-CC0076 13/04/09 By jt_chen MOD-C30755回寫pmn50時,未重取單身訂單多角序號
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE l_oga   RECORD LIKE oga_file.*    #NO.FUN-620024 
DEFINE l_ogb   RECORD LIKE ogb_file.*    #NO.FUN-620024 
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_oha   RECORD LIKE oha_file.*    #NO.FUN-620024                         
DEFINE g_ohb   RECORD LIKE ohb_file.*    #NO.FUN-620024 
DEFINE tm RECORD
          oga09  LIKE oga_file.oga09,
          oga01  LIKE oga_file.oga01
       END RECORD
DEFINE g_poz       RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy       RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_poy       RECORD LIKE poy_file.*    #NO.FUN-620024
DEFINE s_dbs_new   LIKE type_file.chr21      #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_new   LIKE type_file.chr21      #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_plant_new LIKE type_file.chr21      #No.FUN-980059 VARCHAR(21)    #New DataBase Name
DEFINE s_dbs_new_tra   LIKE type_file.chr21 
DEFINE l_dbs_new_tra   LIKE type_file.chr21 
DEFINE s_plant_new     LIKE type_file.chr21 
DEFINE g_rva01     LIKE rva_file.rva01 
DEFINE g_rvu01     LIKE rvu_file.rvu01 
DEFINE g_oga01     LIKE oga_file.oga01
DEFINE t_oga01     LIKE oga_file.oga01
DEFINE g_ofa01     LIKE ofa_file.ofa01
DEFINE s_azp       RECORD LIKE azp_file.*
DEFINE l_azp       RECORD LIKE azp_file.*
DEFINE g_sw        LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip  #No.FUN-550070  #No.FUN-680137 VARCHAR(5)
DEFINE g_argv1     LIKE oga_file.oga01
DEFINE g_argv2     LIKE oga_file.oga09
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE oga_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE rva_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE rvu_t1      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE l_aza50     LIKE aza_file.aza50      #No.FUN-620024
DEFINE g_pmm01     LIKE pmm_file.pmm01      #No.FUN-620024 
DEFINE l_c         LIKE type_file.num5      #FUN-670007
DEFINE l_poy02     LIKE poy_file.poy02      #FUN-670007
DEFINE l_n         LIKE type_file.num5      #MOD-770160 add
DEFINE g_cnt       LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_msg       LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE g_ima906    LIKE ima_file.ima906   #FUN-560043
DEFINE g_pmm01_1   LIKE pmm_file.pmm01      #CHI-8B0047
DEFINE g_pmm909    LIKE pmm_file.pmm909     #CHI-8B0047
DEFINE g_oea37     LIKE oea_file.oea37      #CHI-8B0047
DEFINE g_pmn24     LIKE pmn_file.pmn24      #CHI-8B0047
DEFINE t_oga       RECORD LIKE oga_file.*   #CHI-8B0047
DEFINE l_rvu01     LIKE rvu_file.rvu01      #CHI-8B0047
DEFINE g_flag      LIKE type_file.chr10     #CHI-8B0047
 
FUNCTION p901(p_argv1,p_argv2)
   DEFINE p_argv1       LIKE oga_file.oga01
   DEFINE p_argv2       LIKE oga_file.oga09
 
   WHENEVER ERROR CONTINUE
  
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
 
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN 
       CALL p901_p1()
    ELSE
#FUN-C40072---add---START
       IF g_argv2 = '8' THEN
          LET g_argv2 ='4'
          LET tm.oga09 = g_argv2
       ELSE
#FUN-C40072---add-----END
          LET tm.oga09 = g_argv2
       END IF #FUN-C40072 add
       LET tm.oga01 = g_argv1
       OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS 
       CALL p901_p2('','','')    #NO.FUN-620054 #FUN-C40072 mark #CHI-C80009 remark
       #CALL p901_p2(g_argv1,g_argv2,'')         #FUN-C40072 add #CHI-C80009 mark
       CLOSE WINDOW win
    END IF
END FUNCTION
 
FUNCTION p901_p1()
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137  SMALLINT
 DEFINE l_sql STRING #FUN-C40072 add
 
    LET p_row = 5  LET p_col = 16
 
    OPEN WINDOW p901_w AT p_row,p_col WITH FORM "axm/42f/axmp901" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oga09,tm.oga01
 WHILE TRUE
    LET g_action_choice = ''
    INPUT BY NAME tm.oga09,tm.oga01  WITHOUT DEFAULTS  
     ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
           WHEN INFIELD(oga01)                                                                                                      
             CALL cl_init_qry_var()                                                                                                 
             IF tm.oga09 = '6' THEN             #MOD-880002
                LET g_qryparam.form="q_oga111"  #MOD-880002                                                                                          
             ELSE 
                LET g_qryparam.form="q_oga11"   #MOD-880002                                                                                        
             END IF 
             LET g_qryparam.default1=tm.oga01                                                                                       
             CALL cl_create_qry() RETURNING tm.oga01                                                                                
             DISPLAY BY NAME tm.oga01                                                                                               
             NEXT FIELD oga01                                                                                                       
         END CASE       
         AFTER FIELD oga09
            IF cl_null(tm.oga09) THEN 
               NEXT FIELD oga09
            END IF
            IF tm.oga09 NOT MATCHES '[46]' THEN
               NEXT FIELD oga09
            END IF
         AFTER FIELD oga01
            IF cl_null(tm.oga01) THEN
               NEXT FIELD oga01
            END IF
#FUN-C40072---add---START
            LET l_sql= "SELECT * FROM oga_file ",
                       "  WHERE oga01 = '",tm.oga01,"' ",
                       "   AND oga65='N' "
            IF tm.oga09 = '4' THEN
               LET l_sql = l_sql CLIPPED, " AND oga09 IN ('4','8')"
            ELSE
               LET l_sql = l_sql CLIPPED, " AND oga09 = '",tm.oga09,"'"
            END IF
            PREPARE p901_pre FROM l_sql
            EXECUTE p901_pre INTO g_oga.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oga_file",tm.oga01,tm.oga09,SQLCA.SQLCODE,"","sel oga",1)
               NEXT FIELD oga01
            END IF
#FUN-C40072---add-----END

#FUN-C40072---mark---START
#           SELECT * INTO g_oga.*
#              FROM oga_file
#             WHERE oga01=tm.oga01 
#               AND oga09=tm.oga09  #No.8047
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err3("sel","oga_file",tm.oga01,tm.oga09,SQLCA.SQLCODE,"","sel oga",1)    #No.FUN-660167
#              NEXT FIELD oga01 
#           END IF
#FUN-C40072---mark-----END
            IF g_oga.oga10 IS NOT NULL THEN
               CALL cl_err(g_oga.oga10,'axm-502',1)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
               CALL cl_err(g_oga.oga901,'axm-406',1)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga905='N' THEN
               CALL cl_err(g_oga.oga905,'tri-012',1)      #CHI-7B0041
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga906 <>'Y' THEN
               CALL cl_err(g_oga.oga906,'axm-402',1)      #No.MOD-660081 modify
               NEXT FIELD oga01 
            END IF
            IF g_oga.ogaconf <>'Y' THEN
               CALL cl_err(g_oga.oga01,'axm-184',1)
               NEXT FIELD oga01 
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         call cl_cmdask()
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
      CALL p901_p2('','','')    #NO.FUN-620054
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
 CLOSE WINDOW p901_w
END FUNCTION
 
FUNCTION p901_p2(p_oga01,p_oga09,p_plant)  #FUN-980092 add
  DEFINE p_oga01   LIKE oga_file.oga01     #No.FUN-620054 出貨單號
  DEFINE p_oga09   LIKE oga_file.oga09     #NO.FUN-620054 單據別
  DEFINE p_dbs   LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)  #No.FUN-620054 Database
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3  LIKE type_file.chr1000  #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql4  LIKE type_file.chr1000  #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql5  LIKE type_file.chr1000  #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oeb   RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
  DEFINE p_last  LIKE type_file.num5    #No.FUN-680137 SMALLINT     #流程之最後家數
  DEFINE p_last_plant LIKE cre_file.cre08  #No.FUN-680137 VARCHAR(10)
  DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024                         
  DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024                         
  DEFINE l_oha01 LIKE oha_file.oha01      #NO.FUN-620024 
  DEFINE l_ogbb_cnt  LIKE type_file.num10 #no.FUN-780025
  DEFINE l_pmn01 LIKE pmn_file.pmn01,
         l_pmn02 LIKE pmn_file.pmn02,
         l_oeb01 LIKE oeb_file.oeb01,
         l_oeb03 LIKE oeb_file.oeb03,
         l_cnt   LIKE type_file.num5
  DEFINE l_ogb01 LIKE ogb_file.ogb01      #CHI-830015
  DEFINE l_rvv   RECORD LIKE rvv_file.*   #No.FUN-830132
  DEFINE l_sql_1     STRING                    #CHI-8B0047
  DEFINE l_pmn24     LIKE pmn_file.pmn24       #CHI-8B0047
 
  DEFINE p_dbs_tra LIKE type_file.chr21 #FUN-980092 add
  DEFINE p_plant   LIKE azp_file.azp01 #FUN-980092 add
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_rvb01 LIKE rvb_file.rvb01,   #MOD-B30034
         l_rvb02 LIKE rvb_file.rvb02    #MOD-B30034
  DEFINE l_ogbiicd028  LIKE ogbi_file.ogbiicd028    #FUN-B90012
  DEFINE l_ogbiicd029  LIKE ogbi_file.ogbiicd029    #FUN-B90012
  #FUN-B90012-add-str--
  DEFINE l_ogb_l RECORD LIKE ogb_file.*
  DEFINE l_ogg_l RECORD LIKE ogg_file.* #FUN-C80001 add
  DEFINE l_flag  LIKE type_file.chr1
  DEFINE l_rvb   RECORD LIKE rvb_file.*
  DEFINE b_rvv   RECORD LIKE rvv_file.*
  DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08
  DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16
  DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02
  DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05
  DEFINE l_pmn07        LIKE pmn_file.pmn07       
  DEFINE l_rva06        LIKE rva_file.rva06
  DEFINE l_rvu03        LIKE rvu_file.rvu03
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
# DEFINE l_oga03  LIKE oga_file.oga03  #FUN-C50136
# DEFINE l_oha03  LIKE oha_file.oha03  #FUN-C50136
# DEFINE l_oia07  LIKE oia_file.oia07  #FUN-C50136
  DEFINE l_oga011 LIKE oga_file.oga011 #FUN-C80001
  DEFINE l_idd    RECORD LIKE idd_file.*  #FUN-C80001
  
  LET g_flag = 'N'                             #CHI-8B0047 
 
  LET g_plant_new = p_plant
  CALL s_getdbs()       LET p_dbs = g_dbs_new
  CALL s_gettrandbs()   LET p_dbs_tra = g_dbs_tra
 
   IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add  #FUN-C40072 mark #CHI-C80009 remark
      CALL cl_wait()
      BEGIN WORK 
   END IF                                                         #FUN-C40072 mark #CHI-C80009 remark
   LET g_success='Y'
   LET s_oea62=0
     IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
#FUN-C40072---mark---START
#       SELECT * INTO g_oga.*
#         FROM oga_file
#        WHERE oga01=tm.oga01
#          AND oga09=tm.oga09  #No.8047
#FUN-C40072---mark-----END

#FUN-C40072---add---START
        LET l_sql= "SELECT * FROM oga_file ",
                   "  WHERE oga01 = '",tm.oga01,"' ",
                   "   AND oga65='N' "
        IF tm.oga09 = '4' THEN
           LET l_sql = l_sql CLIPPED, " AND oga09 IN ('4','8')"
        ELSE
           LET l_sql = l_sql CLIPPED, " AND oga09 = '",tm.oga09,"'"
        END IF
        PREPARE p901_pre1 FROM l_sql
        EXECUTE p901_pre1 INTO g_oga.*
#FUN-C40072---add-----END
     ELSE
        LET l_sql = " SELECT * ",
                   #"   FROM ",p_dbs CLIPPED,"oga_file ", #FUN-980092 mark
                    #"   FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
                    "   FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                    "  WHERE oga01 = '",p_oga01,"' ",
                   #"    AND oga09 = '",p_oga09,"' "           #FUN-C40072 mark
                    "   AND oga65='N' "                        #FUN-C40072 add
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
        PREPARE oga_pre FROM l_sql
        EXECUTE oga_pre INTO g_oga.*
        IF cl_null(tm.oga09) THEN LET tm.oga09 = p_oga09 END IF
     END IF
     IF SQLCA.SQLCODE THEN RETURN END IF
     IF g_oga.oga10 IS NOT NULL THEN
        CALL cl_err(g_oga.oga10,'axm-502',1)
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
 
     IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
        CALL cl_err(g_oga.oga901,'axm-406',1)
        RETURN           
     END IF
    #IF g_oga.oga09 NOT MATCHES '[46]' THEN  #FUN-C40072 mark
     IF g_oga.oga09 NOT MATCHES '[468]' THEN #FUN-C40072 add
        CALL cl_err(g_oga.oga905,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga905='N' THEN
        CALL cl_err(g_oga.oga905,'tri-012',1) RETURN  #MOD-940054 add
        RETURN
     END IF
     IF g_oga.oga906 <>'Y' THEN
        CALL cl_err(g_oga.oga906,'axm-402',1)        #No.MOD-660081 modify
        RETURN
     END IF
     #抓取單別拋轉設定檔
     LET g_t1 = s_get_doc_no(g_oga.oga01)          #No.FUN-550070
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
           LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                       "  WHERE oea01 = ogb31 ",
                       "    AND ogb01 = '",g_oga.oga01,"'",
                       "    AND oeaconf = 'Y' " #01/08/16 mandy
        ELSE
           #LET l_sql1= " SELECT * FROM ",p_dbs_tra CLIPPED,"oea_file, ",
           #            "               ",p_dbs_tra CLIPPED,"ogb_file ",
           LET l_sql1= " SELECT * FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                       "             , ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
                       "  WHERE oea01 = ogb31 ",
                       "    AND ogb01 = '",g_oga.oga01,"'",
                       "    AND oeaconf = 'Y' " #01/08/16 mandy
          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032             
          CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
        END IF 	 
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
           SELECT * INTO g_oea.*
             FROM oea_file
            WHERE oea01 = g_oga.oga16
              AND oeaconf = 'Y' #01/08/16 mandy
        ELSE
           LET l_sql = " SELECT * ",
                      #"   FROM ",p_dbs CLIPPED,"oea_file ", #FUN-980092 mark
                       #"   FROM ",p_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                       "   FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                       "  WHERE oea01 = '",g_oga.oga16,"' ",
                       "    AND oeaconf = 'Y'  "  #01/08/16 mandy
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add 	 
           PREPARE oea2_pre FROM l_sql
           EXECUTE oea2_pre INTO g_oea.*
        END IF
     END IF
     IF g_oea.oea902 = 'N' THEN
	CALL cl_err('','axm-934',1)  #訂單不為最終流程訂單!  #TQC-870035 modify
	LET g_success = 'N'
     END IF
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' RETURN
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 
     #No.FUN-620054 --end--
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)      #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF tm.oga09 = '4' AND g_poz.poz00='2' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF tm.oga09 = '6' AND g_poz.poz00='1' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        RETURN
     END IF
 
     IF g_poz.pozacti = 'N' THEN 
        CALL cl_err(g_oea.oea904,'tri-009',1)
        LET g_success = 'N'
        RETURN
     END IF
 
     IF g_poz.poz011 = '1' THEN
        CALL cl_err('','axm-412',1) 
        LET g_success = 'N'
        RETURN
     END IF
    
    #若中斷點已產生出貨單或入庫單即不可拋轉還原
     LET l_cnt=0
     IF g_poz.poz19 = 'Y'  THEN    #已設立中斷點
        SELECT COUNT(*) INTO l_cnt   #check poz18設定的中斷營運中心是否存在單身設>
          FROM poy_file
        WHERE poy01 = g_poz.poz01
          AND poy04 = g_poz.poz18
     END IF 
        IF l_cnt > 0 THEN 
           LET l_cnt = 0 
           SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poz.poz18
           LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED) #TQC-950020   
           LET l_plant_new = l_azp.azp01   #MOD-9C0305
 
           LET g_plant_new = l_plant_new
           CALL s_gettrandbs()   LET l_dbs_new_tra = g_dbs_tra
 
           LET l_sql = " SELECT pmn01,pmn02 ",                       #FUN-980092 add
                       #"   FROM ",l_dbs_new_tra CLIPPED,"pmn_file,", #FUN-980092 add
                       #           l_dbs_new_tra CLIPPED,"pmm_file",  #FUN-980092 add
                       "   FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", #FUN-A50102
                                  cl_get_target_table(l_plant_new,'pmm_file'),     #FUN-A50102 
                       "  WHERE pmm99 ='",g_oea.oea99,"'",
                       "    AND pmm01 = pmn01"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
           PREPARE pmn01_pre1 FROM l_sql
           DECLARE pmn01_cs1 CURSOR FOR pmn01_pre1
           OPEN pmn01_cs1 
           FETCH pmn01_cs1 INTO l_pmn01,l_pmn02
          #判斷是否已入庫應用收貨單號+項次串
           LET l_sql = " SELECT COUNT(*) ",
                       #"   FROM ",l_dbs_new_tra CLIPPED,"rvv_file,",
                       #           l_dbs_new_tra CLIPPED,"rvu_file,",
                       #           l_dbs_new_tra CLIPPED,"rva_file,",
                       #           l_dbs_new_tra CLIPPED,"rvb_file",
                       "   FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",", #FUN-A50102
                                  cl_get_target_table(l_plant_new,'rvu_file'),",", #FUN-A50102
                                  cl_get_target_table(l_plant_new,'rva_file'),",", #FUN-A50102
                                  cl_get_target_table(l_plant_new,'rvb_file'),     #FUN-A50102
                       "  WHERE rva99 ='",g_oga.oga99,"'",
                       "    AND rva01 = rvb01 AND rvu02 = rva01",
                       "    AND rvv05 = rvb02",
                       "    AND rvv01 =  rvu01",
                       "    AND (rvu99 = '",g_oga.oga99,"' OR rvu99 IS NULL) ",
                       "    AND rvuconf <> 'X'"   #MOD-A30134
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
           PREPARE rvv01_pre1 FROM l_sql
           DECLARE rvv01_cs1 CURSOR FOR rvv01_pre1
           OPEN rvv01_cs1 
           FETCH rvv01_cs1 INTO l_cnt
           IF l_cnt = 0 THEN
              #-----MOD-B30034---------
              LET l_sql = " SELECT rvb01,rvb02 FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",",
                                                      cl_get_target_table(l_plant_new,'rva_file'),
                          "  WHERE rva99 ='",g_oga.oga99,"'",
                          "    AND rva01 = rvb01" 
	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
              PREPARE rvb01_pre1 FROM l_sql
              DECLARE rvb01_cs1 CURSOR FOR rvb01_pre1
              OPEN rvb01_cs1 
              FETCH rvb01_cs1 INTO l_rvb01,l_rvb02
              LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'qcs_file'),
                          "  WHERE qcs01 ='",l_rvb01,"'",
                          "    AND qcs02 ='",l_rvb02,"'",       
                          "    AND qcs14 <> 'X' "
	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
              PREPARE qcs_pre1 FROM l_sql
              DECLARE qcs_cs1 CURSOR FOR qcs_pre1
              OPEN qcs_cs1 
              FETCH qcs_cs1 INTO l_cnt
              IF l_cnt = 0 THEN
              #-----END MOD-B30034-----
                 LET l_sql = " SELECT oeb01,oeb03 ",
                             #"   FROM ",l_dbs_new_tra CLIPPED,"oeb_file,",
                             #           l_dbs_new_tra CLIPPED,"oea_file",
                             "   FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                                        cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                             "  WHERE oea99 ='",g_oea.oea99,"'",
                             "    AND oeb01 = oea01" 
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                 PREPARE oeb01_pre1 FROM l_sql
                 DECLARE oeb01_cs1 CURSOR FOR oeb01_pre1
                 OPEN oeb01_cs1 
                 FETCH oeb01_cs1 INTO l_oeb01,l_oeb03
                 LET l_sql = " SELECT COUNT(*) ",
                             #"   FROM ",l_dbs_new_tra CLIPPED,"ogb_file,",
                             #           l_dbs_new_tra CLIPPED,"oga_file ",
                             "   FROM ",cl_get_target_table(l_plant_new,'ogb_file'),",", #FUN-A50102
                                        cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102
                             "  WHERE ogb31 ='",l_oeb01,"'",
                             "    AND ogb32 ='",l_oeb03,"'",          #CHI-830015 modify
                             "    AND oga01 =  ogb01",                #CHI-830015 add
                             "    AND (oga99 = '",g_oga.oga99,"' OR oga99 IS NULL) ",  #CHI-830015 add
                             "    AND ogaconf <> 'X'"   #MOD-A80058
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                 PREPARE ogb01_pre1 FROM l_sql
                 DECLARE ogb01_cs1 CURSOR FOR ogb01_pre1
                 OPEN ogb01_cs1 
                 FETCH ogb01_cs1 INTO l_cnt
                 IF l_cnt > 0 THEN
                    LET g_msg = 'SO:',l_oeb01,'-',l_oeb03 CLIPPED
                    IF g_bgerr THEN
                       LET g_showmsg=l_dbs_new,"/",l_oeb01,"/",l_oeb03    
                       CALL s_errmsg('poy04,ogb01,ogb03',g_showmsg,'Warning SO:','axm-933',1)   
                       LET g_success = 'N'   #MOD-850150 add
                    ELSE
                      CALL cl_err(g_msg,'axm-933',1) 
                      LET g_success = 'N'   #MOD-850150 add
                      RETURN                #MOD-850150 add
                    END IF
                 END IF 
              #-----MOD-B30034---------
              ELSE
                 LET g_msg = 'QC:',l_rvb01,'-',l_rvb02 CLIPPED
                 IF g_bgerr THEN
                    LET g_showmsg=l_dbs_new,"/",l_rvb01,"/",l_rvb02    
                    CALL s_errmsg('poy04,qcs01,qcs02',g_showmsg,'QC:','axm-933',1)   
                    LET g_success = 'N' 
                 ELSE
                   CALL cl_err(g_msg,'axm-933',1) 
                   LET g_success = 'N' 
                   RETURN               
                 END IF
              END IF
              #-----END MOD-B30034-----
           ELSE
             LET g_msg = 'PO:',l_pmn01,'-',l_pmn02 CLIPPED
              IF g_bgerr THEN
                 LET g_showmsg=l_dbs_new,"/",l_pmn01,"/",l_pmn02    
                 CALL s_errmsg('poy04,pmn01,pmn02',g_showmsg,'Warning PO:','axm-933',1)   
                 LET g_success = 'N'   #MOD-850150 add
              ELSE
                CALL cl_err(g_msg,'axm-933',1) 
                LET g_success = 'N'   #MOD-850150 add
                RETURN                #MOD-850150 add
              END IF
           END IF           
           LET l_cnt=0
        END IF 
      CALL s_mtrade_last_plant(g_oea.oea904) 
                 RETURNING p_last,p_last_plant       #記錄最後一筆之家數
 
     #依流程代碼最多6層
     FOR i = p_last TO 0 STEP -1
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
         IF i = p_last THEN CONTINUE FOR END IF 
         #得到廠商/客戶代碼及database
         CALL p901_azp(i)
         LET l_c = 0
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = g_poz.poz01
           AND poy04 = g_poz.poz18
         SELECT poy02 INTO l_poy02
           FROM poy_file
          WHERE poy01 = g_poz.poz01
            AND poy04 = g_poz.poz18
         IF g_poz.poz19 = 'Y' THEN
            IF ( l_c > 0 AND (i <= l_poy02)) THEN   #MOD-950285 add 
               CALL p901_getno(i,l_plant_new)          #FUN-980092 add
              #刪除收貨單頭檔-->l_dbs_new
               #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rva_file", #FUN-980092 add
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                        " WHERE rva01= ? "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2		#FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
               PREPARE del_rva_last FROM l_sql2
               EXECUTE del_rva_last USING g_rva01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_msg = l_dbs_new CLIPPED,'del rva'
                  IF  g_bgerr  THEN      
                   CALL s_errmsg('rva01',g_rva01,g_msg,SQLCA.SQLCODE,1) 
                  ELSE
                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF
                   LET g_success='N'
               END IF
             
              #刪除收貨單身檔-->l_dbs_new
               #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rvb_file", #FUN-980092 add
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                        " WHERE rvb01= ? "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2		#FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
               PREPARE del_rvb_last FROM l_sql2
               EXECUTE del_rvb_last USING g_rva01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_msg = l_dbs_new CLIPPED,'del rvb'
                  IF g_bgerr   THEN   
                     CALL s_errmsg('rvb01',g_rva01,g_msg,SQLCA.SQLCODE,1)  
                  ELSE
                     CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF  
                  LET g_success='N'
               ELSE
                  IF NOT s_industry('std') THEN
                    #IF NOT s_del_rvbi(g_rva01,'',l_dbs_new) THEN    #FUN-B90012 mark
                     IF NOT s_del_rvbi(g_rva01,'',l_plant_new) THEN  #FUN-B90012
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
               #MOD-C40140 add start -----
               IF cl_null(p_plant) THEN
                   LET l_sql = " SELECT * FROM ogb_file ",
                               "  WHERE ogb01 = '",g_oga.oga01,"' ",
                               "     AND ogb1005 = '1'"
               ELSE
                   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'ogb_file'),
                               "  WHERE ogb01 = '",g_oga.oga01,"' ",
                               "    AND ogb1005 = '1'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
               END IF
               LET l_sql = l_sql CLIPPED," ORDER BY ogb03"

               PREPARE ogb_pre2 FROM l_sql
               DECLARE ogb_cus2 CURSOR FOR ogb_pre2
               FOREACH ogb_cus2 INTO g_ogb.*
                  IF SQLCA.SQLCODE <>0 THEN
                      EXIT FOREACH
                  END IF
               #MOD-C40140 add end   -----

                  #MOD-C30755 ----- add start -----
                  #IF NOT p901_chkoeo(l_ogb.ogb31,g_ogb.ogb32,l_ogb.ogb04) THEN #MOD-C40140 mark
                  IF NOT p901_chkoeo(g_ogb.ogb31,g_ogb.ogb32,g_ogb.ogb04) THEN  #MOD-C40140 add

                     #MOD-CC0076 add end  -----
                     #重取單身訂單多角序號
                     IF cl_null(p_plant) THEN
                        LET l_sql= " SELECT * FROM oea_file ",
                                   "  WHERE oea01 = '",g_ogb.ogb31,"'"
                     ELSE
                        LET l_sql= " SELECT * ",
                                   "   FROM ",cl_get_target_table(p_plant,'oea_file'),
                                   "  WHERE oea01 = '",g_ogb.ogb31,"'"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
                     END IF
                     PREPARE oea99_pre1 FROM l_sql
                     DECLARE oea99_cus1 CURSOR FOR oea99_pre1
                     OPEN oea99_cus1
                     FETCH oea99_cus1 INTO g_oea.*
                     #MOD-CC0076 add end  -----
                     
                     #MOD-C40140 add start -----
                     LET l_sql = "SELECT pmm01 ",
                                   " FROM ",cl_get_target_table(l_plant_new,'pmm_file'),
                                   " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                     PREPARE pmm_pmm01 FROM l_sql
                     DECLARE pmm_cpmm01 CURSOR FOR pmm_pmm01
                     OPEN pmm_cpmm01
                     FETCH pmm_cpmm01 INTO g_pmm01
                     #MOD-C40140 add end   -----

                     #更新採購單身之入庫量及交貨量
                     LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),
                                " SET pmn50 = pmn50 - ?",
                                " WHERE pmn01 = ? AND pmn02 = ? "
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                     PREPARE upd_pmn_3 FROM l_sql2
                     EXECUTE upd_pmn_3 USING g_ogb.ogb12,g_pmm01,g_ogb.ogb32
                     IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_msg = l_dbs_new CLIPPED,'upd pmn'
                        IF g_bgerr THEN
                           LET g_showmsg=g_pmm01,"/",g_ogb.ogb32
                           CALL s_errmsg('pmn01,pmn02',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                        ELSE
                           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                        END IF
                        LET g_success = 'N'
                        EXIT FOREACH #MOD-C40140 add
                     END IF
                  END IF
                  #MOD-C30755 ----- add end -----
               END FOREACH     #MOD-C40140 add
               EXIT FOR
            END IF
         END IF
         CALL p901_getno(i,p_plant)  #取得還原單號 #FUN-980092 add
         IF s_mchkARAP(l_plant_new,g_oga.oga99,'1') THEN   #NO.FUN-670007 #No.FUN-980059
            LET g_success = 'N' EXIT FOR
         END IF                 

         #MOD-C20156 ----- add start -----
         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'),
                    " WHERE rvbs00 = ? ",
                    "   AND rvbs01 = ? "
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
         PREPARE del_rvbs2 FROM l_sql2
         EXECUTE del_rvbs2 USING 'apmt300',g_rva01
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'del rvbs:'
            CALL s_errmsg('','',g_msg,STATUS,1)
            LET g_success='N'
         END IF
         #MOD-C20156 ----- add end -----
         
         #---------------------先還原 tlf_file-----------------------
         LET l_oea62=0
         #讀取出貨單身檔(ogb_file)
         IF cl_null(p_plant) THEN #FUN-980092 add
            LET l_sql = " SELECT * ",
                        "   FROM ogb_file ",
                        "  WHERE ogb01 = '",g_oga.oga01,"' "
         ELSE
            LET l_sql = " SELECT * ",
                       #"   FROM ",p_dbs CLIPPED,"ogb_file ", #FUN-980092 mark
                        #"   FROM ",p_dbs_tra CLIPPED,"ogb_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
                        "  WHERE ogb01 = '",g_oga.oga01,"' "
         END IF
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
         PREPARE ogb_pre FROM l_sql
         DECLARE  ogb_cus CURSOR FOR ogb_pre
         FOREACH ogb_cus INTO g_ogb.*
             IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
           # 訂單若已結案不可拋轉還原
            LET l_sql1= " SELECT oeb70 ",
                       #"   FROM ",p_dbs CLIPPED,"oeb_file ", #FUN-980092 mark
                        #"   FROM ",p_dbs_tra CLIPPED,"oeb_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'oeb_file'), #FUN-A50102
                        "  WHERE oeb01 = '",g_ogb.ogb31,"'",
                        "    AND oeb03 = '",g_ogb.ogb32,"'"
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
            PREPARE oeb99_pre FROM l_sql1
            DECLARE oeb99_cus CURSOR FOR oeb99_pre
            OPEN oeb99_cus
            FETCH oeb99_cus INTO l_oeb.oeb70
            IF l_oeb.oeb70 = 'Y' THEN
               LET g_showmsg=p_dbs,"/",g_ogb.ogb01,"/",g_ogb.ogb03,"/",g_ogb.ogb31,"/",g_ogb.ogb32         
               CALL s_errmsg('azp01,ogb01,ogb03,ogb31,ogb32',g_showmsg,'Warning SO:','axm-202',1) 
               LET g_success='N'                                                 
            END IF 
 
           #重取單身訂單多角序號
            LET l_sql1= " SELECT * ",
                       #"   FROM ",p_dbs CLIPPED,"oea_file ", #FUN-980092 mark
                        #"   FROM ",p_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                        "  WHERE oea01 = '",g_ogb.ogb31,"'"
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
            PREPARE oea99_pre FROM l_sql1
            DECLARE oea99_cus CURSOR FOR oea99_pre
            OPEN oea99_cus
            FETCH oea99_cus INTO g_oea.*
           # 重取單身訂單多角序號
           
            IF i = 0 AND tm.oga09="6" AND g_flag='N' THEN
               LET l_sql_1 = "SELECT pmm01,pmm909 ",                                  
                            #" FROM ",l_dbs_new CLIPPED,"pmm_file ",    #FUN-980092 mark
                             #" FROM ",l_dbs_new_tra CLIPPED,"pmm_file ",    #FUN-980092 add
                             " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                             " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'" 
 	           CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1 #FUN-980092 add
               PREPARE pmm_p211 FROM l_sql_1                                      
               DECLARE pmm_c211 CURSOR FOR pmm_p211                               
               OPEN pmm_c211                                                    
               FETCH pmm_c211 INTO g_pmm01_1,g_pmm909
    
               LET l_sql_1 = " SELECT pmn24 ",
                             #"   FROM ",l_dbs_new_tra CLIPPED,"pmn_file ", #FUN-980092 add
                             "   FROM ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                             "  WHERE pmn01 = '",g_pmm01_1,"' "
 	           CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1 #FUN-980092 add
               PREPARE pmn_pre21 FROM l_sql_1
               DECLARE pmn_c211 CURSOR FOR pmn_pre21                               
               OPEN pmn_c211                                                    
               FETCH pmn_c211 INTO l_pmn24   
    
               LET l_sql_1 = " SELECT oea37 ",
                             #"   FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                             "   FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                             "  WHERE oea01 = '",l_pmn24,"' "
 	           CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1 #FUN-980092 add
               PREPARE oea_pre21 FROM l_sql_1
               EXECUTE oea_pre21 INTO g_oea37
               IF g_pmm909 = 3 AND g_oea37 = 'Y' THEN
                  LET g_flag = 'Y'
                  CALL p901_exp_delivery()            
               END IF                  
            END IF 
                       
             IF (tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)) THEN #AND  #MOD-820102 modify
                  IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
                      LET l_sql5 = "SELECT oga00,oga01,ogb31,ogb04,ogb32 ",  #MOD-810094 modify ogb32,ogb03 add                                  
                                  #" FROM ",l_dbs_new_tra CLIPPED,"oga_file,", #FUN-980092 add
                                  #         l_dbs_new_tra CLIPPED,"ogb_file ", #FUN-980092 add
                                  " FROM ",cl_get_target_table(l_plant_new,'oga_file'),",", #FUN-A50102
                                           cl_get_target_table(l_plant_new,'ogb_file'),     #FUN-A50102
                                  " WHERE oga01 = ogb01 ",
                                  "   AND oga99='",g_oga.oga99,"'",                         
                                  "   AND ogb03='",g_ogb.ogb03,"'"     #MOD-810094 add
 	                  CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-980092 add
                      PREPARE oga_p2 FROM l_sql5                                           
                      IF SQLCA.SQLCODE THEN                                                
                          IF g_bgerr THEN
                            CALL s_errmsg('oga99',g_oga.oga99,'oga_p2',SQLCA.SQLCODE,0)       
                          ELSE
                            CALL cl_err('oga_p2',SQLCA.SQLCODE,1)
                          END IF
                      END IF                                                               
                      DECLARE oga_c2 CURSOR FOR oga_p2                                     
                      OPEN oga_c2                                                          
                      FETCH oga_c2 INTO l_oga.oga00,l_oga.oga01,l_ogb.ogb31,l_ogb.ogb04,l_ogb.ogb32   #MOD-810094 modify 
                      IF SQLCA.SQLCODE <> 0 THEN                                           
                         IF g_bgerr THEN   
                            CALL s_errmsg('oga99',g_oga.oga99,'oga_c2',SQLCA.SQLCODE,1) 
                         END IF
                         LET g_success='N'                                                 
                         EXIT FOREACH                                                    #NO.FUN-710026 
                      END IF                                                               
                      CLOSE oga_c2                                                         
                  END IF   #FUN-670007
             END IF
 
             IF cl_null(p_plant) THEN #FUN-980092 add
                SELECT ima906 INTO g_ima906 FROM ima_file 
                 WHERE ima01 = g_ogb.ogb04
             ELSE
                LET l_sql = " SELECT ima906 ",
                            #"   FROM ",p_dbs CLIPPED,"ima_file ",
                            "   FROM ",cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
                            "  WHERE ima01 = '",g_ogb.ogb04,"' "
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                PREPARE ima906_pre FROM l_sql
                EXECUTE ima906_pre INTO g_ima906
             END IF
 
             LET l_sql4 = "SELECT pmm01 ",                                        
                          #"  FROM ",l_dbs_new_tra CLIPPED,"pmm_file", #FUN-980092 add
                          "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),     #FUN-A50102
                          " WHERE pmm99 ='",g_oea.oea99,"'"                       
 	         CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
             CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092 add
             PREPARE pmm_pre FROM l_sql4                                          
             DECLARE pmm_cus CURSOR FOR pmm_pre                                   
             OPEN pmm_cus                                                         
             FETCH pmm_cus INTO g_pmm01                                           
             IF SQLCA.SQLCODE <>0 THEN                                            
                IF g_bgerr THEN  
                  CALL s_errmsg('pmm99',g_oea.oea99,'pmm_cus',STATUS,1) LET g_success='N' EXIT FOR 
                ELSE
                   CALL cl_err('pmm_cus',STATUS,1) LET g_success='N' EXIT FOR
                END IF 
             END IF                                                               
 
             #刪除批/序號異動資料檔(tlfs_file)
             #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlfs_file", #FUN-980092 add
             LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlfs_file'),     #FUN-A50102
                        " WHERE tlfs01 = ? ",
                        "   AND tlfs10 = ? ",
                        #"   AND tlfs11 = ? ",  #FUN-C80001
                        "   AND tlfs111 = ? "
 	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
             CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-980092 add
             PREPARE del_tlfsl FROM l_sql2
             
 
             IF (tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)) AND #No.8047
             g_ogb.ogb04[1,4]<>'MISC' THEN #No.8743
                 IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
                      #刪除tlf檔(出貨單)-->l_dbs_new
   ##NO.FUN-8C0131   add--begin   
                      #LET l_sql =  " SELECT  * FROM ",l_dbs_new_tra CLIPPED,"tlf_file ",
                     LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'),     #FUN-A50102
                                   " WHERE (tlf026 = ? ", 
                                   "   AND tlf027 = ?)",  
                                   "   AND (tlf036 = ? ", 
                                   "   AND tlf037 = ?)"  
                      DECLARE p901_u_tlf_c CURSOR FROM l_sql
                      LET l_i = 0 
                      CALL la_tlf.clear()
                      FOREACH p901_u_tlf_c USING g_oga01,g_ogb.ogb03,
                                                 l_ogb.ogb31,l_ogb.ogb32   INTO g_tlf.*
                         LET l_i = l_i + 1
                         LET la_tlf[l_i].* = g_tlf.*
                      END FOREACH     

  ##NO.FUN-8C0131   add--en
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                                    " WHERE tlf026 = ? ",
                                    "   AND tlf036 = ? "
                      ELSE
                      #FUN-C80001---end
                      #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlf_file", #FUN-980092 add
                         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                                    " WHERE (tlf026 = ? ",
                                    "   AND tlf027 = ?)",
                                    "   AND (tlf036 = ? ",
                                    "   AND tlf037 = ?)"
                      END IF  #FUN-C80001
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                      PREPARE del_tlf FROM l_sql2
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                         EXECUTE del_tlf USING g_oga01,l_ogb.ogb31    
                         IF SQLCA.SQLCODE THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlf'
                            IF  g_bgerr  THEN
                               LET g_showmsg=g_oga01,"/",l_ogb.ogb31         
                               CALL s_errmsg('tlf026,tlf036',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE   
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END  IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      ELSE 
                      #FUN-C80001---end
                         EXECUTE del_tlf USING g_oga01,g_ogb.ogb03,      
                                               l_ogb.ogb31,l_ogb.ogb32    
                         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlf'
                            IF  g_bgerr  THEN
                               LET g_showmsg=g_oga01,"/",g_ogb.ogb03,"/",l_ogb.ogb31,"/",g_ogb.ogb32         
                               CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE   
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END  IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      END IF  #FUN-C80001
    ##NO.FUN-8C0131   add--begin
                      FOR l_i = 1 TO la_tlf.getlength()
                         LET g_tlf.* = la_tlf[l_i].*
                         #IF NOT s_untlf1(l_dbs_new_tra) THEN 
                         IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                            LET g_success='N' RETURN
                         END IF 
                      END FOR       
  ##NO.FUN-8C0131   add--end  
                      #刪除批/序號異動資料
                      #EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                      EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_oga.oga02  #FUN-C80001
                      IF SQLCA.SQLCODE THEN
                         LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
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
                         DECLARE p901_g_idd CURSOR FROM l_sql2

                         #抓取雙單位倉儲批資料
                         LET l_sql2= " SELECT * FROM ",cl_get_target_table(l_plant_new,'ogg_file'),
                                     " WHERE ogg01 = '",g_oga01,"'",
                                     "   AND ogg03 = ",g_ogb.ogb03,
                                     "   AND ogg20 = 1"
                         DECLARE l_ogg_p CURSOR FROM l_sql2
              
                        #IF g_ogb.ogb17 = 'Y' AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                         IF g_ogb.ogb17 = 'Y' AND g_pod.pod08 = 'Y' THEN  #FUN-D30099
                            IF NOT cl_null(l_oga011) THEN
                               FOREACH p901_g_idd INTO l_idd.*
                                     LET l_idd.idd10 = l_oga011
                                     CALL p901_idd_to_idb(l_idd.*,l_plant_new)
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
                               FOREACH p901_g_idd INTO l_idd.*
                                  IF NOT cl_null(l_oga011) THEN 
                                     LET l_idd.idd10 = l_oga011
                                     CALL p901_idd_to_idb(l_idd.*,l_plant_new)
                                  END IF 
                               END FOREACH    
                            END IF 
                         #FUN-C80001---end
 
                            CALL s_icdpost(12,l_ogb_l.ogb04,l_ogb_l.ogb09,
                                              l_ogb_l.ogb091,l_ogb_l.ogb092,
                                              l_ogb_l.ogb05,l_ogb_l.ogb12,
                                              g_oga01,g_ogb.ogb03,g_oga.oga02,
                                             #'N','','',l_ogbiicd028,l_ogbiicd029,l_plant_new) #FUN-C80001 mak
                                              'N','','',l_ogbiicd029,l_ogbiicd028,l_plant_new) #FUN-C80001 add #ogbiicd029 母批,ogbiicd028 DATECODE
                            RETURNING l_flag
                            IF l_flag = 0 THEN
                               LET g_success = 'N'
                            END IF
                         END IF  #FUN-C80001
                      END IF
                      #FUN-B90012-add-end--
                      IF g_ima906 = '2' OR g_ima906 = '3' THEN
                          #FUN-C80001---begin
                         #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                          IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                             LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
                                        " WHERE tlff026 = ? ",
                                        "   AND tlff036 = ? "
                          ELSE 
                          #FUN-C80001---end 
                          #LET l_sql3="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlff_file", #FUN-980092 add
                             LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
                                        " WHERE (tlff026 = ? ",
                                        "   AND tlff027 = ?)",
                                        "   AND (tlff036 = ? ",
                                        "   AND tlff037 = ?)"
                          END IF  #FUN-C80001
 	                      CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                          CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092 add
                          PREPARE del_tlff FROM l_sql3
                          #FUN-C80001---begin
                         #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
                          IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                             EXECUTE del_tlff USING g_oga01,l_ogb.ogb31
                             IF SQLCA.SQLCODE THEN
                                LET g_msg = l_dbs_new CLIPPED,'del tlff'
                                IF g_bgerr THEN
                                  LET g_showmsg=g_oga01,"/",l_ogb.ogb31            
                                  CALL s_errmsg('tlff026,tlff036',g_showmsg,g_msg,SQLCA.SQLCODE,1)  
                                ELSE
                                  CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                                END IF   
                                LET g_success='N'
                                EXIT FOREACH
                             END IF  
                          ELSE 
                          #FUN-C80001---end
                             EXECUTE del_tlff USING g_oga01,g_ogb.ogb03,
                                                    l_ogb.ogb31,g_ogb.ogb32
                             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                                LET g_msg = l_dbs_new CLIPPED,'del tlff'
                                IF g_bgerr THEN
                                  LET g_showmsg=g_oga01,"/",g_ogb.ogb03,"/",l_ogb.ogb31,"/",g_ogb.ogb32            
                                  CALL s_errmsg('tlff026,tlff027,tlff036,tlff037',g_showmsg,g_msg,SQLCA.SQLCODE,1)  
                                ELSE
                                  CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                                END IF   
                                LET g_success='N'
                                EXIT FOREACH
                             END IF
                          END IF  ##FUN-C80001
                          #刪除批/序號異動資料
                          #EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                          EXECUTE del_tlfsl USING g_ogb.ogb04,g_oga01,g_oga.oga02  #FUN-C80001
                          IF SQLCA.SQLCODE THEN
                             LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
                             CALL s_errmsg('','',g_msg,STATUS,1)
                             LET g_success='N'
                          END IF
 
                      END IF
                 END IF      #FUN-670007
             END IF #No.8047(end)
             
             IF g_ogb.ogb04[1,4]<>'MISC' THEN  #No.8743
                  #刪除tlf檔(收貨單) -->l_dbs_new no.3568 01/10/22
  ##NO.FUN-8C0131   add--begin   
                  #LET l_sql =  " SELECT  * FROM ",l_dbs_new_tra CLIPPED,"tlf_file ", 
                  LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                               " WHERE (tlf026 = ? ", 
                               "   AND tlf027 = ?)",  
                               "   AND (tlf036 = ? ", 
                               "   AND tlf037 = ?)"                    
                  DECLARE p901_u_tlf_c1 CURSOR FROM l_sql
                  LET l_i = 0 
                  CALL la_tlf.clear()
                  FOREACH p901_u_tlf_c1 USING g_pmm01,g_ogb.ogb32,
                                              g_rva01,g_ogb.ogb03 INTO g_tlf.*
                     LET l_i = l_i + 1
                     LET la_tlf[l_i].* = g_tlf.*
                  END FOREACH     

  ##NO.FUN-8C0131   add--en
                  #FUN-C80001---begin
                 #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                  IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                     LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                                " WHERE tlf026 = ? ",
                                "   AND tlf036 = ? "
                  ELSE 
                  #FUN-C80001---end
                  #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlf_file", #FUN-980092 add
                     LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
                                " WHERE (tlf026 = ? ",
                                "   AND tlf027 = ?)",
                                "   AND (tlf036 = ? ",
                                "   AND tlf037 = ?)"
                  END IF  #FUN-C80001
                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                  PREPARE del2_tlf FROM l_sql2
                  #FUN-C80001---begin
                 #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                  IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                     EXECUTE del2_tlf USING g_pmm01,g_rva01
                     IF SQLCA.SQLCODE THEN
                        LET g_msg = l_dbs_new CLIPPED,'del tlf2'
                        IF  g_bgerr  THEN  
                          LET g_showmsg=g_pmm01,"/",g_rva01           
                          CALL s_errmsg('tlf026,tlf036',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                        ELSE
                          CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                        END IF
                        LET g_success='N'
                        EXIT FOREACH
                     END IF
                  ELSE
                  #FUN-C80001---end
                     EXECUTE del2_tlf USING g_pmm01,g_ogb.ogb32,   #NO.FUN-620024
                                            g_rva01,g_ogb.ogb03
                     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_msg = l_dbs_new CLIPPED,'del tlf2'
                        IF  g_bgerr  THEN  
                          LET g_showmsg=g_pmm01,"/",g_ogb.ogb32,"/",g_rva01,"/",g_ogb.ogb03            
                          CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                        ELSE
                          CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                        END IF
                        LET g_success='N'
                        EXIT FOREACH
                     END IF
                  END IF  #FUN-C80001
    ##NO.FUN-8C0131   add--begin
               FOR l_i = 1 TO la_tlf.getlength()
                  LET g_tlf.* = la_tlf[l_i].*
                  #IF NOT s_untlf1(l_dbs_new_tra) THEN
                  IF NOT s_untlf1(l_plant_new) THEN   #FUN-A50102
                     LET g_success='N' RETURN
                  END IF 
               END FOR       
  ##NO.FUN-8C0131   add--end  
                  #刪除批/序號異動資料
                  #EXECUTE del_tlfsl USING g_ogb.ogb04,g_rva01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                  EXECUTE del_tlfsl USING g_ogb.ogb04,g_rva01,g_oga.oga02   #FUN-C80001
                  IF SQLCA.SQLCODE THEN
                     LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
                     CALL s_errmsg('','',g_msg,STATUS,1)
                     LET g_success='N'
                  END IF
                  #FUN-B90012-add-str--
                 #IF s_industry('icd') AND g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
                  IF s_industry('icd') AND g_pod.pod08 <> 'Y' THEN  #FUN-D30099
                     LET l_sql2 = "SELECT rva06 FROM ",cl_get_target_table(l_plant_new,'rva_file'),
                                  " WHERE rva01 = '",g_rva01,"'"
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                     PREPARE l_rva_p FROM l_sql2
                     EXECUTE l_rva_p INTO l_rva06
 
                     LET l_sql2 = "SELECT rvb_file.*,rvbiicd08,rvbiicd16 ",
                                  "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",",
                                            cl_get_target_table(l_plant_new,'rvbi_file'),
                                  " WHERE rvb01 = '",g_rva01,"'",
                                  "   AND rvb02 = '",g_ogb.ogb03,"'",
                                  "   AND rvb01 = rvbi01 ",
                                  "   AND rvb02 = rvbi02 "
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                     PREPARE l_rvb_p FROM l_sql2
                     EXECUTE l_rvb_p INTO l_rvb.*,l_rvbiicd08,l_rvbiicd16  
                     LET l_pmn07 = NULL
                     LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(l_plant_new,'pmn_file'),
                                  " WHERE pmn01 = '",l_rvb.rvb04,"'",
                                  "   AND pmn02 = '",l_rvb.rvb03,"'"
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                     PREPARE l_pmn_p FROM l_sql2
                     EXECUTE l_pmn_p INTO l_pmn07
                     CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                                      l_pmn07,l_rvb.rvb07,g_rva01,g_ogb.ogb03,
                                      l_rva06,'N','','',l_rvbiicd16,l_rvbiicd08,l_plant_new) 
                     RETURNING l_flag
                     IF l_flag = 0 THEN 
                        LET g_success = 'N'
                     END IF 
                  END IF
                  #FUN-B90012-add-end--
                  IF g_ima906 = '2' OR g_ima906 = '3' THEN
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                         LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                    " WHERE tlff026 = ? ",
                                    "   AND tlff036 = ? "
                      ELSE
                      #FUN-C80001---end
                      #LET l_sql3="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlff_file", #FUN-980092 add
                         LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                    " WHERE (tlff026 = ? ",
                                    "   AND tlff027 = ?)",
                                    "   AND (tlff036 = ? ",
                                    "   AND tlff037 = ?)"
                      END IF  #FUN-C80001
 	                  CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092 add
                      PREPARE del2_tlff FROM l_sql3
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                         EXECUTE del2_tlff USING g_pmm01,g_rva01
                         IF SQLCA.SQLCODE THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlff2'
                            IF g_bgerr THEN
                               LET g_showmsg=g_pmm01,"/",g_rva01               
                               CALL s_errmsg('tlff026,tlff036',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      ELSE
                      #FUN-C80001---end
                         EXECUTE del2_tlff USING g_pmm01,g_ogb.ogb32,   #NO.FUN-620024
                                                 g_rva01,g_ogb.ogb03
                         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlff2'
                            IF g_bgerr THEN
                               LET g_showmsg=g_pmm01,"/",g_ogb.ogb32,"/",g_rva01,"/",g_ogb.ogb03                
                               CALL s_errmsg('tlff026,tlff027,tlff036,tlff037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      END IF  #FUN-C80001
                      #刪除批/序號異動資料
                      #EXECUTE del_tlfsl USING g_ogb.ogb04,g_rva01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                      EXECUTE del_tlfsl USING g_ogb.ogb04,g_rva01,g_oga.oga02  #FUN-C80001
                      IF SQLCA.SQLCODE THEN
                         LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
                         CALL s_errmsg('','',g_msg,STATUS,1)
                         LET g_success='N'
                      END IF
 
                  END IF
                  IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
                      #刪除tlf檔(入庫單) -->l_dbs_new no.3568 01/10/22
   ##NO.FUN-8C0131   add--begin   
                      #LET l_sql =  " SELECT  * FROM ",l_dbs_new_tra CLIPPED,"tlf_file ",
                     LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                                   " WHERE (tlf026 = ? ", 
                                   "   AND tlf027 = ?)",  
                                   "   AND (tlf036 = ? ", 
                                   "   AND tlf037 = ?)"     
                      DECLARE p901_u_tlf_c2 CURSOR FROM l_sql
                      LET l_i = 0 
                      CALL la_tlf.clear()
                      FOREACH p901_u_tlf_c2 USING g_rva01,g_ogb.ogb03,
                                                 g_rvu01,g_ogb.ogb03  INTO g_tlf.*
                         LET l_i = l_i + 1
                         LET la_tlf[l_i].* = g_tlf.*
                      END FOREACH     
       
  ##NO.FUN-8C0131   add--end1   add--end
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                                    " WHERE tlf026 = ? ",
                                    "   AND tlf036 = ? "
                      ELSE 
                      #FUN-C80001---end 
                      #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlf_file", #FUN-980092 add
                         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102 
                                    " WHERE (tlf026 = ? ",
                                    "   AND tlf027 = ?)",
                                    "   AND (tlf036 = ? ",
                                    "   AND tlf037 = ?)"
                      END IF  #FUN-C80001
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                      PREPARE del3_tlf FROM l_sql2
                      #FUN-C80001---begin
                     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
                         EXECUTE del3_tlf USING g_rva01,g_rvu01
                         IF SQLCA.SQLCODE THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlf3'
                            IF  g_bgerr THEN
                               LET g_showmsg=g_rva01,"/",g_rvu01           
                               CALL s_errmsg('tlf026,tlf036',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE 
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      ELSE 
                      #FUN-C80001---end
                         EXECUTE del3_tlf USING g_rva01,g_ogb.ogb03,    #no.6178(收貨單)
                                                g_rvu01,g_ogb.ogb03
                         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                            LET g_msg = l_dbs_new CLIPPED,'del tlf3'
                            IF  g_bgerr THEN
                               LET g_showmsg=g_rva01,"/",g_ogb.ogb03,"/",g_rvu01,"/",g_ogb.ogb03            
                               CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                            ELSE 
                               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                            END IF
                            LET g_success='N'
                            EXIT FOREACH
                         END IF
                      END IF  #FUN-C80001
    ##NO.FUN-8C0131   add--begin
                      FOR l_i = 1 TO la_tlf.getlength()
                          LET g_tlf.* = la_tlf[l_i].*
                          #IF NOT s_untlf1(l_dbs_new_tra) THEN 
                          IF NOT s_untlf1(l_plant_new) THEN 
                             LET g_success='N' RETURN
                          END IF 
                      END FOR       
  ##NO.FUN-8C0131   add--end  
                      #刪除批/序號異動資料
                      #EXECUTE del_tlfsl USING g_ogb.ogb04,g_rvu01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                      EXECUTE del_tlfsl USING g_ogb.ogb04,g_rvu01,g_oga.oga02  #FUN-C80001
                      IF SQLCA.SQLCODE THEN
                         LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
                         CALL s_errmsg('','',g_msg,STATUS,1)
                         LET g_success='N'
                      END IF
 
                      #FUN-B90012-add-str--
                     #IF s_industry('icd') AND g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
                      IF s_industry('icd') AND g_pod.pod08 <> 'Y' THEN  #FUN-D30099 
                         LET l_sql2 = "SELECT rvu03 FROM ",cl_get_target_table(l_plant_new,'rvu_file'),
                                      " WHERE rvu01 = '",g_rvu01,"'"
                         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                         PREPARE l_rvu_p FROM l_sql2
                         EXECUTE l_rvu_p INTO l_rvu03
                         LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                                      "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",",
                                                cl_get_target_table(l_plant_new,'rvvi_file'),
                                      " WHERE rvv01 = '",g_rvu01,"'",
                                      "   AND rvv02 = '",g_ogb.ogb03,"'",
                                      "   AND rvv01 = rvvi01 ",
                                      "   AND rvv02 = rvvi02 "
                         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                         PREPARE b_rvv_p FROM l_sql2
                         EXECUTE b_rvv_p INTO b_rvv.*,l_rvviicd02,l_rvviicd05  
                         CALL s_icdpost(11,b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                                          b_rvv.rvv34,b_rvv.rvv35,b_rvv.rvv17,
                                          g_rvu01,g_ogb.ogb03,l_rvu03,'N',
                                          b_rvv.rvv04,b_rvv.rvv05,l_rvviicd05,
                                          l_rvviicd02,l_plant_new)
                         RETURNING l_flag
                         IF l_flag = 0 THEN 
                            LET g_success = 'N'
                         END IF 
                      END IF
                      #FUN-B90012-add-end--
                      IF g_ima906 = '2' OR g_ima906 = '3' THEN
                          #FUN-C80001---begin
                         #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
                          IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                             LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                        " WHERE tlff026 = ? ",
                                        "   AND tlff036 = ? "
                          ELSE
                          #FUN-C80001---end
                          #LET l_sql3="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlff_file", #FUN-980092 add
                             LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102 
                                        " WHERE (tlff026 = ? ",
                                        "   AND tlff027 = ?)",
                                        "   AND (tlff036 = ? ",
                                        "   AND tlff037 = ?)"
                          END IF   #FUN-C80001
 	                      CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
                          CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092 add
                          PREPARE del3_tlff FROM l_sql3
                          #FUN-C80001---begin
                         #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
                          IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
                             EXECUTE del3_tlff USING g_rva01,g_rvu01
                             IF SQLCA.SQLCODE THEN
                                LET g_msg = l_dbs_new CLIPPED,'del tlff3'
                                IF g_bgerr THEN
                                   LET g_showmsg=g_rva01,"/",g_rvu01               
                                   CALL s_errmsg('tlff026,tlff036',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                                ELSE
                                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                                END IF
                                LET g_success='N'
                                EXIT FOREACH
                             END IF
                          ELSE
                          #FUN-C80001---end
                             EXECUTE del3_tlff USING g_rva01,g_ogb.ogb03,    #no.6178(收貨單)
                                                     g_rvu01,g_ogb.ogb03
                             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                                LET g_msg = l_dbs_new CLIPPED,'del tlff3'
                                IF g_bgerr THEN
                                   LET g_showmsg=g_rva01,"/",g_ogb.ogb03,"/",g_rvu01,"/",g_ogb.ogb03                
                                   CALL s_errmsg('tlff026,tlff027,tlff036,tlff037',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                                ELSE
                                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                                END IF
                                LET g_success='N'
                                EXIT FOREACH
                             END IF
                          END IF   #FUN-C80001
                          #刪除批/序號異動資料
                          #EXECUTE del_tlfsl USING g_ogb.ogb04,g_rvu01,g_ogb.ogb03,g_oga.oga02  #FUN-C80001
                          EXECUTE del_tlfsl USING g_ogb.ogb04,g_rvu01,g_oga.oga02  #FUN-C80001
                          IF SQLCA.SQLCODE THEN
                             LET g_msg = l_dbs_new CLIPPED,'del tlfs:'   
                             CALL s_errmsg('','',g_msg,STATUS,1)
                             LET g_success='N'
                          END IF
 
                      END IF
                  END IF                #FUN-670007
             END IF   #No.8073 end--
             IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
                  # 代採買替來源廠做入庫還原
                  IF tm.oga09 = '6' AND i = 0 THEN  #No.9059
                    #IF g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
                     IF g_pod.pod08 <> 'Y' THEN  #FUN-D30099  
                        #抓取扣帳的倉儲批.... no.4475
                        LET l_sql2 = "SELECT rvv32,rvv33,rvv34 ",
                                     #"  FROM ",l_dbs_new_tra,"rvv_file" , #FUN-980092 add
                                     "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102  
                                     " WHERE rvv01 ='",g_rvu01,"'",
                                     "   AND rvv02 =",g_ogb.ogb03
 	                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                        PREPARE rvv32_pre FROM l_sql2
                        DECLARE rvv32_cs CURSOR FOR rvv32_pre
                        OPEN rvv32_cs
                        FETCH rvv32_cs INTO g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092
                        IF SQLCA.SQLCODE <> 0 THEN  #MOD-4A0340
                           LET g_msg = l_dbs_new CLIPPED,'sel rvv32'
                           IF g_bgerr THEN      
                             LET g_showmsg=g_rvu01,"/",g_ogb.ogb03     
                             CALL s_errmsg('rvv01,rvv02',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                           ELSE 
                             CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                           END IF
                            LET g_success='N' EXIT FOREACH
                        END IF
                        CALL s_mupimg(-1,g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                                         g_ogb.ogb092,g_ogb.ogb12*g_ogb.ogb15_fac,  #MOD-4B0148
                                   #     g_oga.oga02,l_azp.azp01,-1,g_ogb.ogb01,g_ogb.ogb03) #No.FUN-870007  #No.FUN-A10099
                                         g_oga.oga02,l_azp.azp01,+1,g_rvu01,    g_ogb.ogb03) #No.FUN-870007  #No.FUN-A10099
                    #CHI-C80009---mark---START
                    # #FUN-B90012-add-str--
                    # IF s_industry('icd') THEN
                    #    LET l_sql2 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
                    #                 " WHERE ogbi01 = '",g_rvu01,"'",
                    #                 "   AND ogbi03 = '",g_ogb.ogb03,"'"
                    #    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                    #    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
                    #    PREPARE l_ogbi_p2 FROM l_sql2
                    #    EXECUTE l_ogbi_p2 INTO l_ogbiicd028,l_ogbiicd029
                    # 
                    #    CALL s_icdpost(12,g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                    #                   g_ogb.ogb092,g_ogb.ogb05,g_ogb.ogb12,
                    #                   g_rvu01,g_ogb.ogb03,g_oga.oga02,'N',
                    #                   '','',l_ogbiicd029,l_ogbiicd028,l_azp.azp01)
                    #       RETURNING l_flag
                    #    IF l_flag = 0 THEN 
                    #       LET g_success = 'N'
                    #    END IF
                    # END IF
                    #  #FUN-B90012-add-end--
                    #CHI-C80009---mark-----END
                        IF g_ima906 = '2' THEN                    #NO.FUN-620024
                           CALL s_mupimgg(-1,g_ogb.ogb04,
                                             g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                                             g_ogb.ogb910,g_ogb.ogb912,
                                             g_oga.oga02,
                                             l_plant_new) #FUN-980092 add
                           CALL s_mupimgg(-1,g_ogb.ogb04,
                                             g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                                             g_ogb.ogb913,g_ogb.ogb915,
                                             g_oga.oga02,
                                             l_plant_new) #FUN-980092 add
                        ELSE
                           IF g_ima906 = '3' THEN
                              CALL s_mupimgg(-1,g_ogb.ogb04,
                                                g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                                                g_ogb.ogb913,g_ogb.ogb915,
                                                g_oga.oga02,
                                                l_plant_new) #FUN-980092 add
                           END IF
                        END IF
                        CALL s_mudima(g_ogb.ogb04,l_plant_new) #FUN-980092 add
                     END IF  #FUN-C80001 
                  END IF
 
                  IF NOT p901_chkoeo(l_ogb.ogb31,  #NO.FUN-620024
                                     g_ogb.ogb32,l_ogb.ogb04) THEN #NO.FUN-620024
                       #更新採購單身之入庫量及交貨量
                       #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"pmn_file", #FUN-980092 add
                       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                               " SET pmn50 = pmn50 - ?,",
                               "     pmn53 = pmn53 - ? ",
                                " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-4B0167
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                       PREPARE upd_pmn FROM l_sql2
                       EXECUTE upd_pmn USING 
                              g_ogb.ogb12,g_ogb.ogb12,
                              g_pmm01,g_ogb.ogb32      #NO.FUN-620024
                       IF SQLCA.sqlcode<>0 THEN
                          LET g_msg = l_dbs_new CLIPPED,'upd pmn'
                          IF  g_bgerr  THEN   
                            LET g_showmsg=g_pmm01,"/",g_ogb.ogb32   
                            CALL s_errmsg('pmn01,pmn02',g_showmsg,g_msg,SQLCA.SQLCODE,1)     
                          ELSE
                            CALL cl_err(g_msg,SQLCA.SQLCODE,1)    
                          END IF
                          LET g_success = 'N'
                          EXIT FOREACH
                       END IF
                  END IF #No.7742(end)
   
                  IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) THEN #No.8047
                      #讀取流程代碼中之銷單資料
                      #LET l_sql2="SELECT *  FROM ",l_dbs_new_tra CLIPPED,"oeb_file", #FUN-980092 add
                      LET l_sql2="SELECT *  FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                              " WHERE oeb01 ='",l_ogb.ogb31,"' ", #NO.FUN-620024
                              "   AND oeb03 =",g_ogb.ogb32
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                      PREPARE oeb_cu2  FROM l_sql2
                      DECLARE oeb_p2 CURSOR FOR oeb_cu2
                      OPEN oeb_p2 
                      FETCH oeb_p2 INTO l_oeb.* 
                      CLOSE oeb_p2 
                      IF SQLCA.sqlcode<>0 THEN
                          IF  g_bgerr  THEN   
                            LET g_showmsg=l_ogb.ogb31,"/",g_ogb.ogb32  
                            CALL s_errmsg('oeb01,oeb03',g_showmsg,'sel oeb_p2:',SQLCA.sqlcode,1)    
                          ELSE
                            CALL cl_err('sel oeb_p2:',SQLCA.sqlcode,1)
                          END IF
                          LET g_success = 'N'
                          EXIT FOREACH
                      END IF
                      IF NOT p901_chkoeo(l_ogb.ogb31,  #NO.FUN-620024
                                         g_ogb.ogb32,l_ogb.ogb04) THEN #No.7742 #NO.FUN-620024
                         #更新銷單資料
                         #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oeb_file", #FUN-980092 add
                         LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                                 " SET oeb24=oeb24 - ? ",
                                 " WHERE oeb01 = ? AND oeb03 = ? "
 	                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                         PREPARE upd_oeb2 FROM l_sql2
                         EXECUTE upd_oeb2 USING 
                                 g_ogb.ogb12, l_ogb.ogb31,g_ogb.ogb32 #NO.FUN-620024
                         IF SQLCA.sqlcode<>0 THEN
                           IF  g_bgerr THEN  
                            LET g_showmsg=g_ogb.ogb31,"/",g_ogb.ogb32  
                            CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb24:',SQLCA.sqlcode,1) 
                           ELSE
                            CALL cl_err('upd oeb24:',SQLCA.sqlcode,1)
                           END IF 
                             LET g_success = 'N'
                             EXIT FOREACH
                         END IF
                         LET l_oea62 = l_oea62 + g_ogb.ogb12*l_oeb.oeb13
                      END IF  #No.7742(end)
                  END IF      #No.8047(end)
            #中斷點的pmn50需更新
                ELSE 
                IF  ( l_c > 0 AND (g_poy.poy02 = l_poy02 )) THEN #FUN-670007
                  IF NOT p901_chkoeo(l_ogb.ogb31,  
                                     g_ogb.ogb32,l_ogb.ogb04) THEN
                       #更新採購單身之入庫量及交貨量
                       #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"pmn_file", #FUN-980092 add
                       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                               " SET pmn50 = pmn50 - ?",
                                " WHERE pmn01 = ? AND pmn02 = ? "
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                       PREPARE upd_pmn_2 FROM l_sql2
                       EXECUTE upd_pmn_2 USING 
                              g_ogb.ogb12,
                              g_pmm01,g_ogb.ogb32      
                       IF SQLCA.sqlcode<>0 THEN
                          LET g_msg = l_dbs_new CLIPPED,'upd pmn'
                          IF  g_bgerr  THEN   
                            LET g_showmsg=g_pmm01,"/",g_ogb.ogb32   
                            CALL s_errmsg('pmn01,pmn02',g_showmsg,g_msg,SQLCA.SQLCODE,1)     
                          ELSE
                            CALL cl_err(g_msg,SQLCA.SQLCODE,1)    
                          END IF
                          LET g_success = 'N'
                          EXIT FOREACH
                       END IF
                  END IF 
                 END IF 
             END IF           #FUN-670007
         END FOREACH {ogb_cus}
         #FUN-C80001---begin
        #IF s_industry('icd') AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark 
         IF s_industry('icd') AND g_pod.pod08 = 'Y' THEN  #FUN-D30099
            LET l_sql2 = "SELECT rva06 FROM ",cl_get_target_table(l_plant_new,'rva_file'),
                         " WHERE rva01 = '",g_rva01,"'"
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
            PREPARE l_rva_p1 FROM l_sql2
            EXECUTE l_rva_p1 INTO l_rva06
 
            LET l_sql2 = "SELECT rvb_file.*,rvbiicd08,rvbiicd16 ",
                          "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",",
                                    cl_get_target_table(l_plant_new,'rvbi_file'),
                          " WHERE rvb01 = '",g_rva01,"'",
                          "   AND rvb01 = rvbi01 ",
                          "   AND rvb02 = rvbi02 "
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
            DECLARE l_rvb_c1 CURSOR FROM l_sql2

            FOREACH  l_rvb_c1 INTO l_rvb.*,l_rvbiicd08,l_rvbiicd16  
               LET l_pmn07 = NULL
               LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(l_plant_new,'pmn_file'),
                            " WHERE pmn01 = '",l_rvb.rvb04,"'",
                            "   AND pmn02 = '",l_rvb.rvb03,"'"
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE l_pmn_p1 FROM l_sql2
               EXECUTE l_pmn_p1 INTO l_pmn07
               CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                                 l_pmn07,l_rvb.rvb07,g_rva01,l_rvb.rvb02,
                                 l_rva06,'N','','',l_rvbiicd16,l_rvbiicd08,l_plant_new) 
               RETURNING l_flag
               IF l_flag = 0 THEN 
                  LET g_success = 'N'
               END IF
            END FOREACH   
            
            LET l_sql2 = "SELECT rvu03 FROM ",cl_get_target_table(l_plant_new,'rvu_file'),
                         " WHERE rvu01 = '",g_rvu01,"'"
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
            PREPARE l_rvu_p1 FROM l_sql2
            EXECUTE l_rvu_p1 INTO l_rvu03
            LET l_sql2 = "SELECT rvv_file.*,rvviicd02,rvviicd05 ",
                         "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'),",",
                                   cl_get_target_table(l_plant_new,'rvvi_file'),
                         " WHERE rvv01 = '",g_rvu01,"'",
                         "   AND rvv01 = rvvi01 ",
                         "   AND rvv02 = rvvi02 "
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
            DECLARE l_rvv_c1 CURSOR FROM l_sql2
            FOREACH l_rvv_c1 INTO b_rvv.*,l_rvviicd02,l_rvviicd05  
               CALL s_icdpost(11,b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                                 b_rvv.rvv34,b_rvv.rvv35,b_rvv.rvv17,
                                 g_rvu01,b_rvv.rvv02,l_rvu03,'N',
                                 b_rvv.rvv04,b_rvv.rvv05,l_rvviicd05,
                                 l_rvviicd02,l_plant_new)
               RETURNING l_flag
               IF l_flag = 0 THEN 
                  LET g_success = 'N'
               END IF 
            END FOREACH 
         END IF
         IF tm.oga09 = '6' AND i = 0 THEN
           #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
            IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
               LET l_sql2 = "SELECT * ",
                            "  FROM ",cl_get_target_table(l_plant_new,'rvv_file'),  
                            " WHERE rvv01 ='",g_rvu01,"'"
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE rvv32_pre1 FROM l_sql2
               DECLARE rvv32_cs1 CURSOR FOR rvv32_pre1
               FOREACH rvv32_cs1 INTO l_rvv.*
                  IF SQLCA.SQLCODE <> 0 THEN  
                     LET g_msg = l_dbs_new CLIPPED,'sel rvv32'
                     IF g_bgerr THEN      
                        LET g_showmsg=g_rvu01,"/",g_ogb.ogb03     
                        CALL s_errmsg('rvv01,rvv02',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                     ELSE 
                        CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                     END IF
                     LET g_success='N' EXIT FOREACH
                  END IF
                  CALL s_mupimg(-1,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                                   l_rvv.rvv34,l_rvv.rvv17*l_rvv.rvv35_fac, 
                                   g_oga.oga02,l_azp.azp01,+1,l_rvv.rvv01,l_rvv.rvv02) 
   
                  IF g_ima906 = '2' THEN                  
                     CALL s_mupimgg(-1,l_rvv.rvv31,
                                       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                       l_rvv.rvv80,l_rvv.rvv82,
                                       g_oga.oga02,
                                       l_plant_new)
                     CALL s_mupimgg(-1,l_rvv.rvv31,
                                       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                       l_rvv.rvv83,l_rvv.rvv85,
                                       g_oga.oga02,
                                       l_plant_new) 
                  ELSE
                     IF g_ima906 = '3' THEN
                        CALL s_mupimgg(-1,l_rvv.rvv31,
                                          l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                          l_rvv.rvv83,l_rvv.rvv85,
                                          g_oga.oga02,
                                          l_plant_new) 
                      END IF
                  END IF
                  CALL s_mudima(l_rvv.rvv31,l_plant_new) 
               END FOREACH 
            END IF 
         END IF 
         #FUN-C80001---end
                     
         #更新銷單單頭資料
         IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) THEN #No.8047
             IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
                 #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oea_file", #FUN-980092 add
                 LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                            " SET oea62=oea62 - ? ",
                            " WHERE oea01 = ?  "
 	             CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                 PREPARE upd_oea2 FROM l_sql2
                 EXECUTE upd_oea2 USING l_oea62, l_ogb.ogb31  #NO.FUN-620024
                 IF SQLCA.sqlcode<>0 THEN
                    IF  g_bgerr  THEN  
                      CALL s_errmsg('oea01',l_ogb.ogb31,'upd oea62:',SQLCA.sqlcode,1) 
                    ELSE 
                      CALL cl_err('upd oea62:',SQLCA.sqlcode,1)    
                    END IF
                    LET g_success = 'N'
                 END IF
             END IF                                     #FUN-670007
         END IF #No.8047(end)
 
         #-------------------刪除各單據資料-------------------
         #刪除批/序號資料檔(rvbs_file)
         #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rvbs_file", #FUN-980092 add
         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102
                    " WHERE rvbs00 = ? ",
                    "   AND rvbs01 = ? "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-980092 add
         PREPARE del_rvbsl FROM l_sql2
 
         IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) THEN #No.8047
             IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
#               #FUN-C50136--add-str--
#               IF g_oaz.oaz96 ='Y' THEN
#                  LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                               " WHERE oga01 = ? ",
#                               "   AND oga09 ='",tm.oga09,"'"
#                  PREPARE sel_oga FROM l_sql2
#                  EXECUTE sel_oga USING g_oga01 INTO l_oga03
#                  CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#                  IF l_oia07 = '0' THEN
#                     CALL s_ccc_rback(l_oga03,'D',g_oga01,0,l_plant_new)
#                  END IF
#               END IF
#               #FUN-C50136--add-end--
                #刪除出貨單單頭檔(oga_file)
                #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                           " WHERE oga01= ? ",
                           "   AND oga09= '",tm.oga09,"'"
                CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                PREPARE del_oga FROM l_sql2
                EXECUTE del_oga USING g_oga01
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_msg = l_dbs_new CLIPPED,'del oga'
                   IF g_bgerr  THEN
                      LET g_showmsg=g_oga01,"/",tm.oga09          
                      CALL s_errmsg('oga01,oga09',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                   ELSE
                      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                   END IF
                   LET g_success='N'
                END IF

                #刪除出貨單身檔
                #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ogb_file", #FUN-980092 add
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                           " WHERE ogb01= ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                PREPARE del_ogb FROM l_sql2
                EXECUTE del_ogb USING g_oga01
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_msg = l_dbs_new CLIPPED,'del ogb'
                   IF  g_bgerr  THEN      
                      CALL s_errmsg('ogb01',g_oga01,g_msg,SQLCA.SQLCODE,1) 
                   ELSE 
                      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                   END IF
                   LET g_success='N'
                 ELSE
                    IF NOT s_industry('std') THEN
                       IF NOT s_del_ogbi(g_oga01,'',l_plant_new) THEN #FUN-980092 add
                          LET g_success = 'N'
                       END IF
                    END IF
                END IF

                #FUN-C80001---begin
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogc_file'),
                           " WHERE ogc01= ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
                PREPARE del_ogc FROM l_sql2
                EXECUTE del_ogc USING g_oga01
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_new CLIPPED,'del ogc:'   
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogg_file'),
                           " WHERE ogg01= ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
                PREPARE del_ogg FROM l_sql2
                EXECUTE del_ogg USING g_oga01
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_new CLIPPED,'del ogg:'   
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF
                #FUN-C80001---end
 
                IF tm.oga09 = "4" THEN
                   EXECUTE del_rvbsl USING 'axmt820',g_oga01
                ELSE
                   EXECUTE del_rvbsl USING 'axmt821',g_oga01
                END IF
                #刪除批/序號資料
                IF SQLCA.SQLCODE THEN
                   LET g_msg = l_dbs_new CLIPPED,'del rvbs:'   
                   CALL s_errmsg('','',g_msg,STATUS,1)
                   LET g_success='N'
                END IF
                #FUN-B90012-add-str--
                IF s_industry('icd') THEN
                   CALL icd_idb_del(g_oga01,'',l_plant_new)
                END IF
                #FUN-B90012-add-end--
 
             END IF       #FUN-670007
         END IF #No.8047(end)
 
         #刪除收貨單頭檔-->l_dbs_new
         #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rva_file", #FUN-980092 add
         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                  " WHERE rva01= ? "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-980092 add
         PREPARE del_rva FROM l_sql2
         EXECUTE del_rva USING g_rva01
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = l_dbs_new CLIPPED,'del rva'
            IF  g_bgerr  THEN      
             CALL s_errmsg('rva01',g_rva01,g_msg,SQLCA.SQLCODE,1) 
            ELSE
             CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            END IF
             LET g_success='N'
         END IF
 
         #刪除收貨單身檔-->l_dbs_new
         #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rvb_file", #FUN-980092 add
         LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                  " WHERE rvb01= ? "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-980092 add
         PREPARE del_rvb FROM l_sql2
         EXECUTE del_rvb USING g_rva01
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = l_dbs_new CLIPPED,'del rvb'
            IF g_bgerr   THEN   
               CALL s_errmsg('rvb01',g_rva01,g_msg,SQLCA.SQLCODE,1)  
            ELSE
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            END IF  
            LET g_success='N'
         ELSE
            IF NOT s_industry('std') THEN
              #IF NOT s_del_rvbi(g_rva01,'',l_dbs_new) THEN        #FUN-B90012 mark
               IF NOT s_del_rvbi(g_rva01,'',l_plant_new) THEN      #FUN-B90012
                  LET g_success = 'N'
               END IF
            END IF
         END IF
 
         #刪除批/序號資料
         EXECUTE del_rvbsl USING 'apmt300',g_rva01
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'del rvbs:'   
            CALL s_errmsg('','',g_msg,STATUS,1)
            LET g_success='N'
         END IF
         #FUN-B90012-add-str--
         IF s_industry('icd') THEN
            CALL icd_ida_del(g_rva01,'',l_plant_new)
         END IF
         #FUN-B90012-add-end--
 
         IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
             #刪除入庫單頭檔-->l_dbs_new
             #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rvu_file", #FUN-980092 add
             LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                      " WHERE rvu01= ? ",
                      "   AND rvu00='1'"
 	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
             CALl cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
             PREPARE del_rvu FROM l_sql2
             EXECUTE del_rvu USING g_rvu01
             IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                LET g_msg = l_dbs_new CLIPPED,'del rvu'
                IF g_bgerr THEN  
                  LET g_showmsg=g_rvu01,"/",'1'                
                  CALL s_errmsg('rvu01,rvu00',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                ELSE
                  CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                END IF
                LET g_success='N'
             END IF
 
             #刪除入庫單身檔-->l_dbs_new
             #LET l_sql2 = "SELECT * FROM ",l_dbs_new_tra CLIPPED,"rvv_file", #FUN-980092 add
             LET l_sql2 = "SELECT * FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
                          " WHERE rvv01= ? ",
                          "   AND rvv03='1'"   #MOD-840325 modify 3->1
 	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
             CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-980092 add
             PREPARE sel_rvv FROM l_sql2
             DECLARE sel_rvv_cs CURSOR FOR sel_rvv          #MOD-840325 add
             FOREACH sel_rvv_cs USING g_rvu01 INTO l_rvv.*  #MOD-840325 modify
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF

                CALL s_iqctype_rvv(l_rvv.rvv01,l_rvv.rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg  #FUN-BC0104
                #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"rvv_file", #FUN-980092 add
                LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
                           " WHERE rvv01= ? ",
                           "   AND rvv02= ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-980092 add
                PREPARE del_rvv FROM l_sql2
                EXECUTE del_rvv USING l_rvv.rvv01,l_rvv.rvv02
                IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_msg = l_dbs_new CLIPPED,'del rvv'
                   IF g_bgerr THEN
                      LET g_showmsg=l_rvv.rvv01,"/",l_rvv.rvv02          
                      CALL s_errmsg('rvv01,rvv02',g_showmsg,g_msg,SQLCA.SQLCODE,1)   #MOD-840325
                      CONTINUE FOREACH     #No.FUN-830132 add 080401
                   ELSE
                      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                      CONTINUE FOREACH     #No.FUN-830132 add 080401
                   END IF
                   LET g_success='N'
                ELSE
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
                   IF NOT s_industry('std') THEN
                      IF NOT s_del_rvvi(l_rvv.rvv01,l_rvv.rvv02,l_plant_new) THEN #FUN-980092 add
                         LET g_success = 'N'
                         CONTINUE FOREACH  #No.FUN-830132 add 080401
                      END IF
                   END IF
                END IF
             END FOREACH                   #No.FUN-830132 add 080401
 
             #刪除批/序號資料
             EXECUTE del_rvbsl USING 'apmt740',g_rvu01
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_new CLIPPED,'del rvbs:'   
                CALL s_errmsg('','',g_msg,STATUS,1)
                LET g_success='N'
             END IF
             #FUN-B90012-add-str--
             IF s_industry('icd') THEN
                CALL icd_ida_del(g_rvu01,'',l_plant_new)
             END IF
             #FUN-B90012-add-end--
 
             # 刪除出貨單序號檔--------------------------
             #LET l_sql2="SELECT COUNT(*) FROM ",l_dbs_new_tra CLIPPED,"ogbb_file", #FUN-980092 add
             LET l_sql2="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'ogbb_file'), #FUN-A50102
                        " WHERE ogbb01= '",g_oga01,"' " 
 	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
             CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
             PREPARE ogbb_pre1 FROM l_sql2
             DECLARE ogbb_cs1 CURSOR FOR ogbb_pre1
             OPEN ogbb_cs1 
             FETCH ogbb_cs1 INTO l_ogbb_cnt
             IF l_ogbb_cnt > 0 THEN
                 #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ogbb_file", #FUN-980092 add
                 LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogbb_file'), #FUN-A50102
                            " WHERE ogbb01= ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-980092 add
                 PREPARE del_ogbb FROM l_sql2
                 EXECUTE del_ogbb USING g_oga01
                 IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                    LET g_msg = l_dbs_new CLIPPED,'del ogbb:'
                     CALL s_errmsg('','',g_msg,STATUS,1)  
                     LET g_success='N'
                 END IF 
             END IF
 
             IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) THEN #No.8047
                 IF g_oax.oax05='Y' AND g_oaz.oaz67 = '2' THEN  #NO.FUN-670007
                     IF cl_null(p_plant) THEN #FUN-980092 add
                         SELECT COUNT(*) INTO g_cnt FROM ogd_file,oga_file
                          WHERE ogd01=oga01 AND oga99=g_oga.oga99 AND oga30='Y' #MOD-620076 #當多訂單合併一出貨通知單時,因為oga16不會有值,所以改用多角序號oga99
                     ELSE
                         LET l_sql = " SELECT COUNT(*) ",
                                     #"   FROM ",p_dbs_tra CLIPPED,"ogd_file,",
                                     #           p_dbs_tra CLIPPED,"oga_file ",
                                     "   FROM ",cl_get_target_table(p_plant,'ogd_file'),",", #FUN-A50102
                                                cl_get_target_table(p_plant,'oga_file'),     #FUN-A50102
                                     "  WHERE ogd01 = oga01 ",
                                     "    AND oga99 = '",g_oga.oga99,"' ", #MOD-620076 #當多訂單合併一出貨通知單時,因為oga16不會有值,所以改用多角序號oga99
                                     "    AND oga30='Y' "
 	                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
                         PREPARE ogd_pre FROM l_sql
                         EXECUTE ogd_pre INTO g_cnt
                     END IF
                     IF g_cnt > 0 THEN   #有輸入Packing List才拋轉
                         # 若包裝單之出貨單號來源為'1'出貨通知單
                         #        則還要拋轉出貨通知單才可...
                              #刪除出貨單單頭檔(oga_file)
                              #刪除出貨單身檔
                           LET l_ogd01 = g_oga01
                     END IF    
                     #刪除包裝單身檔-->l_dbs_new
                     #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ogd_file", #FUN-980092 add
                     LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogd_file'),     #FUN-A50102
                                " WHERE ogd01= ? "
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-980092 add
                     PREPARE del_ogd FROM l_sql2
                     EXECUTE del_ogd USING l_ogd01
                     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_msg = l_dbs_new CLIPPED,'del ogd'
                        IF g_bgerr THEN
                          CALL s_errmsg('ogb01',l_ogd01,g_msg,SQLCA.SQLCODE,1) 
                        ELSE 
                          CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                        END IF
                        LET g_success='N'
                     END IF
                     IF NOT s_industry('std') THEN                                   
                        IF NOT s_del_ogdi(l_ogd01,'','',l_plant_new) THEN   #FUN-980092 add
                           LET g_success = 'N'
                        END IF                                                       
                     END IF                                                          
                 END IF
                
                 IF g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN   #NO.FUN-670007
                     IF cl_null(p_plant) THEN #FUN-980092 add
                        SELECT * INTO g_ofa.* FROM ofa_file
                         WHERE ofa01=g_oga.oga27
                     ELSE
                        LET l_sql = " SELECT * ",
                                    #"   FROM ",p_dbs_tra CLIPPED,"ofa_file ", #FUN-980092 add
                                    "   FROM ",cl_get_target_table(p_plant,'ofa_file'),     #FUN-A50102
                                    "  WHERE ofa01 = '",g_oga.oga27,"' "
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980092 add
                        PREPARE ofa2_pre FROM l_sql
                        EXECUTE ofa2_pre INTO g_ofa.*
                     END IF
                     #刪除Invoice單頭檔-->l_dbs_new
                     #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ofa_file", #FUN-980092 add
                     LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ofa_file'),     #FUN-A50102
                                " WHERE ofa01= ? "
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-980092 add
                     PREPARE del_ofa FROM l_sql2
                     EXECUTE del_ofa USING g_ofa01
                     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_msg = l_dbs_new CLIPPED,'del ofa'
                        IF g_bgerr  THEN
                         CALL s_errmsg('ofa01',g_ofa01,g_msg,SQLCA.SQLCODE,1) 
                        ELSE 
                         CALL cl_err(g_msg,SQLCA.SQLCODE,1) 
                        END IF
                        LET g_success='N'
                     END IF
                     #刪除Invoice單身檔-->l_dbs_new
                     #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ofb_file", #FUN-980092 add
                     LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ofb_file'),     #FUN-A50102
                                " WHERE ofb01= ? "
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-980092 add
                     PREPARE del_ofb FROM l_sql2
                     EXECUTE del_ofb USING g_ofa01
                     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_msg = l_dbs_new CLIPPED,'del ofb'
                        IF  g_bgerr THEN
                         CALL s_errmsg('ofb01',g_ofa01,g_msg,SQLCA.SQLCODE,1) 
                        ELSE
                         CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                        END IF
                        LET g_success='N'
                     END IF
                 END IF
             END IF   
         END IF                  #FUN-670007
     END FOR
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
     IF l_aza50 = 'Y' THEN                  #使用分銷功能
        IF l_oga.oga00 = '6' THEN           #有代送銷退單生成
           #獲取代送銷退單資料
           LET l_sql = " SELECT oha01,ohb03,ohb31,ohb32 ",
                       #"   FROM ",l_dbs_new_tra CLIPPED,"oha_file,", 
                       #           l_dbs_new_tra CLIPPED, "ohb_file",
                       "   FROM ",cl_get_target_table(l_plant_new,'oha_file'),",", #FUN-A50102 
                                  cl_get_target_table(l_plant_new,'ohb_file'),     #FUN-A50102
                       "  WHERE oha1018 ='",l_oga.oga01,"'", 
                       "    AND oha05 = '1' ",
                       "    AND (oha10 IS NULL OR oha10 =' ' ) ",   #帳單編號必須為null
                       "    AND oha01 = ohb01 "
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-980092 add
           PREPARE oha01_pre FROM l_sql
           DECLARE oha01_cs CURSOR FOR oha01_pre
              OPEN oha01_cs 
           FETCH oha01_cs INTO l_oha01,l_ohb.ohb03,l_ohb.ohb31,l_ohb.ohb32  #代送之銷退單
           IF SQLCA.SQLCODE THEN
              LET g_msg = l_dbs_new CLIPPED,'fetch oha01_cs'
               IF  g_bgerr   THEN    
                LET g_showmsg=l_oga.oga01,"/",1       
                CALL s_errmsg('oha1018,oha05',g_showmsg,g_msg,SQLCA.SQLCODE,1)
               ELSE
                CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               END IF
              LET g_success = 'N'
           END IF
 
           #刪除tlf檔(銷退單) -->l_dbs_new                                                
  ##NO.FUN-8C0131   add--begin   
            #LET l_sql =  " SELECT  * FROM ",l_dbs_new_tra CLIPPED,"tlf_file ", 
            LET l_sql =  " SELECT  * FROM ",cl_get_target_table(l_plant_new,'tlf_file'),     #FUN-A50102
                         " WHERE (tlf026 = ? ", 
                         "   AND tlf027 = ?)",  
                         "   AND (tlf036 = ? ", 
                         "   AND tlf037 = ?)"     
            DECLARE p901_u_tlf_c3 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p901_u_tlf_c3 USING l_oha01,l_ohb.ohb03,
                                        l_oha01,l_ohb.ohb03  INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
           #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlf_file", #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'tlf_file'),     #FUN-A50102
                      " WHERE (tlf026 = ? ",
                      "   AND tlf027 = ?)",
                      "   AND (tlf036 = ? ",
                      "   AND tlf037 = ?)"
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-980092 add
           PREPARE del0_tlfa FROM l_sql2
           EXECUTE del0_tlfa USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03 
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN 
              LET g_msg = l_dbs_new CLIPPED,'del tlf'
              IF g_bgerr THEN
                LET g_showmsg=l_oha01,"/",l_ohb.ohb03,"/",l_oha01,"/",l_ohb.ohb03             
                CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,g_msg,SQLCA.SQLCODE,1)  
              ELSE
                CALL cl_err(g_msg,SQLCA.SQLCODE,1)
              END IF
                LET g_success='N'
           END IF
    ##NO.FUN-8C0131   add--begin
            FOR l_i = 1 TO la_tlf.getlength()
               LET g_tlf.* = la_tlf[l_i].*
               #IF NOT s_untlf1(l_dbs_new_tra) THEN 
               IF NOT s_untlf1(l_plant_new) THEN  #FUN-A50102
                  LET g_success='N' RETURN
               END IF 
            END FOR       
  ##NO.FUN-8C0131   add--end 
 
           #刪除tlff檔(銷退單) -->l_dbs_new
           IF g_ima906 = '2' OR g_ima906 = '3' THEN
               #LET l_sql3="DELETE FROM ",l_dbs_new_tra CLIPPED,"tlff_file", #FUN-980092 add
               LET l_sql3="DELETE FROM ",cl_get_target_table(l_plant_new,'tlff_file'),     #FUN-A50102
                          " WHERE (tlff026 = ? ",
                          "   AND tlff027 = ?)",
                          "   AND (tlff036 = ? ",
                          "   AND tlff037 = ?)"
 	           CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
               CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3  #FUN-980092 add
               PREPARE del_tlf2a FROM l_sql3
               EXECUTE del_tlf2a USING l_oha01,l_ohb.ohb03,l_oha01,l_ohb.ohb03 
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_msg = l_dbs_new CLIPPED,'del tlff'
                  IF  g_bgerr THEN    
                   LET g_showmsg=l_oha01,"/",l_ohb.ohb03,"/",l_oha01,"/",l_ohb.ohb03                 
                   CALL s_errmsg('tlff026,tlff027,tlff036,tlff037',g_showmsg,g_msg,SQLCA.SQLCODE,1)  
                  ELSE
                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF
                  LET g_success='N'
               END IF
           END IF
 
#          #FUN-C50136--add-str--
#          IF g_oaz.oaz96 ='Y' THEN
#             LET l_sql2 = "SELECT oha03 FROM ",cl_get_target_table(l_plant_new,'oha_file'),
#                          " WHERE oha01 = ? ",
#                          "   AND oha05 ='1'"
#             PREPARE sel_oha FROM l_sql2
#             EXECUTE sel_oha USING l_oha01 INTO l_oha03
#             CALL s_ccc_oia07('G',l_oha03) RETURNING l_oia07
#             IF l_oia07 = '0' THEN
#                CALL s_ccc_rback(l_oha03,'G',l_oha01,0,l_plant_new)
#             END IF
#          END IF
#          #FUN-C50136--add-end--
           #刪除銷退單資料
           #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"oha_file", #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oha_file'),     #FUN-A50102
                      " WHERE oha01= ? ",
                      "   AND oha05='1'   "     
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-980092 add
           PREPARE del_oha FROM l_sql2
           EXECUTE del_oha USING l_oha01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              LET g_msg = l_dbs_new CLIPPED,'del oha:'
              IF  g_bgerr THEN   
               LET g_showmsg=l_oha01,"/",1                          
               CALL s_errmsg('oha01,oha05',g_showmsg,g_msg,STATUS,1)  
              ELSE
               CALL cl_err(g_msg,STATUS,1)
              END IF
               LET g_success='N'
           END IF
           #LET l_sql2="DELETE FROM ",l_dbs_new_tra CLIPPED,"ohb_file", #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ohb_file'),     #FUN-A50102
                      " WHERE ohb01= ? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-980092 add
           PREPARE del_ohb FROM l_sql2
           EXECUTE del_ohb USING l_oha01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              LET g_msg = l_dbs_new CLIPPED,'del ohb:'
               IF  g_bgerr THEN     
                CALL s_errmsg('ohb01',l_oha01,g_msg,STATUS,1) 
               ELSE 
                CALL cl_err(g_msg,STATUS,1)
               END IF
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
            
 
     MESSAGE ''
     #更新出貨單之拋轉否='N'
     IF cl_null(p_plant) THEN #FUN-980092 add
         UPDATE oga_file
            SET oga905='N',
                oga99 = ' '         #No.8047
          WHERE oga909='Y'          #三角貿易出貨單
            AND oga01 = g_oga.oga01
     ELSE
         #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
         LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'oga_file'),     #FUN-A50102
                     "    SET oga905 = 'N', ",
                     "        oga99 = ' '  ",       #No.8047
                     #   ogapost = 'N'       #No.8047
                     "  WHERE oga909='Y' ",          #三角貿易出貨單
                     "    AND oga01 = '",g_oga.oga01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-980092 add
         PREPARE oga_upd_pre FROM l_sql
         EXECUTE oga_upd_pre
     END IF
     IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
        IF g_bgerr THEN  
         LET g_showmsg='Y',"/",g_oga.oga01       
         CALL s_errmsg('oga909,oga01',g_showmsg,'upd oga',STATUS,1) 
        ELSE 
         CALL cl_err('upd oga',STATUS,1)      
        END IF
        LET g_success='N'
     END IF
     CALL p901_flow99(p_plant) #FUN-980092 add
 
     IF cl_null(p_oga01) AND cl_null(p_plant) THEN  #FUN-C40072 mark #CHI-C80009 remark
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
     END IF                                         #FUN-C40072 mark #CHI-C80009 remark
   
END FUNCTION
 
#取得工廠資料
FUNCTION p901_azp(l_n)
   DEFINE l_source LIKE type_file.num5,       #No.FUN-680137 SMALLINT,    #來源站別
          l_n      LIKE type_file.num5       #當站站別  #No.FUN-680137 SMALLINT
   DEFINE l_sql1   LIKE type_file.chr1000   #NO.FUN-620024  #No.FUN-680137 VARCHAR(800)
 
   #-------------取得當站資料庫----------------------
   SELECT * INTO g_poy.* FROM poy_file                  #取得當站流程設定
    WHERE poy01 = g_poz.poz01
      AND poy02 = l_n
 
 
   SELECT * INTO l_azp.* FROM azp_file
    WHERE azp01 = g_poy.poy04
 
   LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED) #TQC-950020    
 
  LET l_plant_new = l_azp.azp01  #MOD-9C0305
  LET g_plant_new = l_plant_new
  CALL s_gettrandbs()   LET l_dbs_new_tra = g_dbs_tra
 
   LET l_sql1 = "SELECT aza50 ",                                             
                #"  FROM ",l_dbs_new CLIPPED,"aza_file ",
                "  FROM ",cl_get_target_table(g_poy.poy04,'aza_file'),     #FUN-A50102            
                "  WHERE aza01 = '0' "                                       
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,g_poy.poy04) RETURNING l_sql1 #FUN-A50102
   PREPARE aza_p1 FROM l_sql1                                                
   IF SQLCA.SQLCODE THEN 
     IF g_bgerr THEN
         CALL s_errmsg('aza01',0,'aza_p1',SQLCA.SQLCODE,1)
     ELSE
         CALL cl_err('aza_p1',SQLCA.SQLCODE,1)
     END IF       
   END IF    
   DECLARE aza_c1  CURSOR FOR aza_p1                                         
   OPEN aza_c1                                                               
   FETCH aza_c1 INTO l_aza50                                                 
   CLOSE aza_c1                                                              
 
END FUNCTION
 
FUNCTION p901_chkoeo(p_oeo01,p_oeo03,p_oeo04)
   DEFINE p_oeo01 LIKE oeo_file.oeo01
   DEFINE p_oeo03 LIKE oeo_file.oeo03
   DEFINE p_oeo04 LIKE oeo_file.oeo04
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
   #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_new_tra,"oeo_file ", #FUN-980092 add
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeo_file'),     #FUN-A50102   
             "  WHERE oeo01 = '",p_oeo01,"'",
             "    AND oeo03 = '",p_oeo03,"'",
             "    AND oeo04 = '",p_oeo04,"'",
             "    AND oeo08 = '2' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
   PREPARE chkoeo_pre FROM l_sql
 
   DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
 
   OPEN chkoeo_cs 
   FETCH chkoeo_cs INTO g_cnt
 
   IF g_cnt > 0 THEN
      RETURN 1
   ELSE
      RETURN 0 
   END IF
 
END FUNCTION 
 
#取得要還原的單號
FUNCTION p901_getno(l_n,p_plant)       #FUN-980092 add
   DEFINE p_dbs LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)              #No.FUN-620054
   DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
   DEFINE l_slip LIKE oga_file.oga01
   DEFINE l_n   LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
   DEFINE p_dbs_tra   LIKE type_file.chr21 #FUN-980092 add
   DEFINE p_plant     LIKE azp_file.azp01 #FUN-980092 add
   
   LET g_plant_new = p_plant
   CALL s_getdbs()       LET p_dbs = g_dbs_new
   CALL s_gettrandbs()   LET p_dbs_tra = g_dbs_tra
 
       #LET l_sql = " SELECT rva01 FROM ",l_dbs_new_tra CLIPPED,"rva_file ", #FUN-980092 add
       LET l_sql = " SELECT rva01 FROM ",cl_get_target_table(l_plant_new,'rva_file'),     #FUN-A50102    
                   "  WHERE rva99 ='",g_oga.oga99,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
       PREPARE rva01_pre FROM l_sql
 
       DECLARE rva01_cs CURSOR FOR rva01_pre
 
       OPEN rva01_cs 
       FETCH rva01_cs INTO g_rva01                              #收貨單
       IF SQLCA.SQLCODE THEN
          LET g_msg = l_dbs_new CLIPPED,'fetch rva01_cs'
        IF g_bgerr THEN   
          CALL s_errmsg('rva99',g_oga.oga99,g_msg,SQLCA.SQLCODE,1)
        ELSE
          CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        END IF
          LET g_success = 'N'
       END IF
       
       IF l_c = 0 OR ( l_c > 0 AND (g_poy.poy02 > l_poy02 )) THEN #FUN-670007
           #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new_tra CLIPPED,"rvu_file ", #FUN-980092 add
           LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'),     #FUN-A50102    
                       "  WHERE rvu99 ='",g_oga.oga99,"'",
                       "    AND rvu00 = '1' "
 
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
           PREPARE rvu01_pre FROM l_sql
           DECLARE rvu01_cs CURSOR FOR rvu01_pre
           OPEN rvu01_cs 
           FETCH rvu01_cs INTO g_rvu01                              #入庫單
           IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
            IF  g_bgerr   THEN       
              LET g_showmsg=g_oga.oga99,"/",'1'                   
              CALL s_errmsg('rvu99,rvu00',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
            ELSE
              CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            END IF
            LET g_success = 'N'
           END IF
 
           IF tm.oga09 = '4' OR (tm.oga09='6' AND l_n <> 0) THEN #No.8047
               #LET l_sql = " SELECT oga01 FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
               LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102    
                           "  WHERE oga99 ='",g_oga.oga99,"'",
                           "    AND oga09 = '",tm.oga09,"'"
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
               PREPARE oga01_pre FROM l_sql
               DECLARE oga01_cs CURSOR FOR oga01_pre
               OPEN oga01_cs 
               FETCH oga01_cs INTO g_oga01                              #出貨單
               IF SQLCA.SQLCODE THEN
                  LET g_msg = l_dbs_new CLIPPED,'fetch oga01_cs'
                  IF  g_bgerr THEN 
                    LET g_showmsg=g_oga.oga99,"/",tm.oga09           
                    CALL s_errmsg('oga99,oga09',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
                  ELSE 
                    CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF
                  LET g_success = 'N'
               END IF
 
# 目前出通單拋轉還原己分開處理saxmp911
   
              LET l_slip=''
              IF g_oaz.oaz67 = '2' AND g_oax.oax04 = 'Y' THEN   #no.TQC-7C0157 參數有設要拋packing才抓
                  IF cl_null(p_plant) THEN #FUN-980092 add
                     #LET l_sql = " SELECT ofa01 FROM ",l_dbs_new_tra CLIPPED,"ofa_file ", #FUN-980092 add
                     LET l_sql = " SELECT ofa01 FROM ",cl_get_target_table(l_plant_new,'ofa_file'),     #FUN-A50102  
                                 "  WHERE ofa011= '",g_oga01,"'",    #FUN-670007 當INVOICE來源設為出貨單時，ofa011存放的是出貨單號
                                 "    AND ofa99 = '",g_oga.oga99,"'"   #No.TQC-5C0131
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                     PREPARE ofa01_pre2 FROM l_sql
                     DECLARE ofa01_cs2 CURSOR FOR ofa01_pre2
                     OPEN ofa01_cs2 
                     FETCH ofa01_cs2 INTO l_slip                              #通知單
                     IF SQLCA.SQLCODE THEN
                        LET g_msg = l_dbs_new CLIPPED,'fetch ofa01_cs2'
                        CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                     END IF
                  ELSE
                     LET l_sql = " SELECT ofa01 ",
                                #"   FROM ",p_dbs CLIPPED,"ofa_file ", #FUN-980092 mark
                                 #"   FROM ",p_dbs_tra CLIPPED,"ofa_file ", #FUN-980092 add
                                 "   FROM ",cl_get_target_table(p_plant,'ofa_file'),     #FUN-A50102  
                                 #"  WHERE ofa011 = '",g_oga.oga011,"' ",
                                 "  WHERE ofa011 = '",g_oga01,"' ",   #FUN-670007 
                                 "    AND ofa99 = '",g_oga.oga99,"' "   #No.TQC-5C0131
 	                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
                     PREPARE ofa_pre FROM l_sql
                     EXECUTE ofa_pre INTO l_slip
                  END IF
              ELSE 
                 LET l_slip=g_oga.oga27
              END IF
   
              IF NOT cl_null(l_slip) AND g_oax.oax04 = 'Y' AND g_oaz.oaz67 = '2' THEN      #NO.FUN-670007             
                 #LET l_sql = " SELECT ofa01 FROM ",l_dbs_new_tra CLIPPED,"ofa_file ", #FUN-980092 add
                 LET l_sql = " SELECT ofa01 FROM ",cl_get_target_table(l_plant_new,'ofa_file'),     #FUN-A50102  
                             "  WHERE ofa99 ='",g_oga.oga99,"'"
   
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALl cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                 PREPARE ofa01_pre FROM l_sql
                 DECLARE ofa01_cs CURSOR FOR ofa01_pre
                 OPEN ofa01_cs 
                 FETCH ofa01_cs INTO g_ofa01                              #INVOICE#
                 IF SQLCA.SQLCODE THEN
                    LET g_msg = l_dbs_new CLIPPED,'fetch ofa01_cs'
                    IF g_bgerr THEN
                      CALL s_errmsg('ofa99',g_oga.oga99,g_msg,SQLCA.SQLCODE,1)    
                    ELSE
                      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                    END IF
                    LET g_success = 'N'
                 END IF
              END IF
           END IF
       END IF                #FUN-670007
 
END FUNCTION
 
# 清空多角序號
FUNCTION p901_flow99(p_plant)    #FUN-980092 add
   DEFINE p_dbs   LIKE type_file.chr21,     #No.FUN-680137 VARCHAR(21)     #No.FUN-620054
          l_sql   LIKE type_file.chr1000    #No.FUN-620054  #No.FUN-680137 VARCHAR(200)
 
   DEFINE p_dbs_tra   LIKE type_file.chr21 #FUN-980092 add
   DEFINE p_plant     LIKE azp_file.azp01 #FUN-980092 add
   
   LET g_plant_new = p_plant
   CALL s_getdbs()       LET p_dbs = g_dbs_new
   CALL s_gettrandbs()   LET p_dbs_tra = g_dbs_tra
 
   IF cl_null(p_plant) THEN #FUN-980092 add
        UPDATE oga_file SET oga99 = ' ' WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN      
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga99',SQLCA.SQLCODE,1)  
         ELSE 
           CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1)    
         END IF 
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN  #NO.FUN-670007
           UPDATE ofa_file SET ofa99= ' ' WHERE ofa01 = g_oga.oga27 
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             IF  g_bgerr THEN  
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.SQLCODE,1)              
             ELSE 
              CALL cl_err3("upd","ofa_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd ofa99",1) 
             END IF
              LET g_success = 'N' RETURN
           END IF
        END IF
   ELSE
      #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"oga_file SET oga99 = ' ' ", #FUN-980092 add
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'oga_file'),     #FUN-A50102  
                     " SET oga99 = ' ' ",
                  "  WHERE oga01 = '",g_oga.oga01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980092 add
      PREPARE oga_upd2_pre FROM l_sql
      EXECUTE oga_upd2_pre
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        IF g_bgerr THEN
         CALL s_errmsg('oga01',g_oga.oga01,'upd oga01',SQLCA.SQLCODE,1)  
        ELSE
         CALL cl_err('upd oga99',SQLCA.SQLCODE,1)
        END IF 
         LET g_success = 'N' RETURN
      END IF
      #更新INVOICE ofa99
      IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN   #NO.FUN-670007
         #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"ofa_file SET ofa99= ' ' ", #FUN-980092 add
         LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ofa_file'),     #FUN-A50102 
                        " SET ofa99= ' ' ",
                     "  WHERE ofa01 = '",g_oga.oga27,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
         PREPARE ofa_upd_pre FROM l_sql
         EXECUTE ofa_upd_pre
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            IF  g_bgerr THEN  
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.SQLCODE,1)   
            ELSE
              CALL cl_err('upd ofa99',SQLCA.SQLCODE,1)
            END IF       
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF 
END FUNCTION 
 
FUNCTION p901_exp_delivery()
  DEFINE l_sql STRING
  DEFINE l_cnt1   LIKE type_file.num5 
# DEFINE l_oga03  LIKE oga_file.oga03   #FUN-C50136
# DEFINE l_oia07  LIKE oia_file.oia07   #FUN-C50136
  
  LET g_success = 'Y'
  LET l_cnt1 = 0
  
  #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new_tra CLIPPED,"rvu_file", #FUN-980092 add
  LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'),     #FUN-A50102 
              "  WHERE rvu99 = '",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
  PREPARE rvu01_pre1 FROM l_sql
  DECLARE rvu01_cs1 CURSOR FOR rvu01_pre1
  OPEN rvu01_cs1 
  FETCH rvu01_cs1 INTO l_rvu01
  CLOSE rvu01_cs1  
 
  #LET l_sql= "SELECT COUNT(*) FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
  LET l_sql= "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102 
             " WHERE oga914 = '",l_rvu01,"' "                                                                                       
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
  PREPARE oga12_p2 FROM l_sql                                                                                                       
  DECLARE oga12_curs2 CURSOR FOR oga12_p2                                                                                           
  OPEN oga12_curs2                                                                                                                  
  FETCH oga12_curs2 INTO l_cnt1                                                                                                    
  CLOSE oga12_curs2 
 
  IF l_cnt1 > 0 THEN
 
    #LET l_sql= "SELECT * FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
    LET l_sql= "SELECT * FROM ",cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102 
               " WHERE oga914 = '",l_rvu01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
    PREPARE oga13_p2 FROM l_sql
    DECLARE oga13_curs2 CURSOR FOR oga13_p2   
    OPEN oga13_curs2
    FETCH oga13_curs2 INTO t_oga.*
    CLOSE oga13_curs2  
 
    IF NOT cl_null(t_oga.ogaconf) THEN
      IF t_oga.ogaconf = 'N' AND t_oga.oga55 = '0' THEN    
#        #FUN-C50136--add-str--
#        IF g_oaz.oaz96 ='Y' THEN
#           LET l_sql = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                       " WHERE oga01 = ? "
#           PREPARE sel_oga1 FROM l_sql
#           EXECUTE sel_oga1 USING t_oga.oga01 INTO l_oga03
#           CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#           IF l_oia07 = '0' THEN
#              CALL s_ccc_rback(l_oga03,'D',t_oga.oga01,0,l_plant_new)
#           END IF
#        END IF
#        #FUN-C50136--add-end--
         #刪除出貨單單頭檔(oga_file)
         #LET l_sql ="DELETE FROM ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
         LET l_sql ="DELETE FROM ",cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102 
                    " WHERE oga01= ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
         PREPARE del_oga1 FROM l_sql
         EXECUTE del_oga1 USING t_oga.oga01
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = l_dbs_new CLIPPED,'del oga'
            IF g_bgerr  THEN
               LET g_showmsg=t_oga.oga01,"/",tm.oga09          
               CALL s_errmsg('oga01,oga09',g_showmsg,g_msg,SQLCA.SQLCODE,1) 
            ELSE
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            END IF
            LET g_success='N'
         END IF
 
         #刪除出貨單身檔
         #LET l_sql ="DELETE FROM ",l_dbs_new_tra CLIPPED,"ogb_file", #FUN-980092 add
         LET l_sql ="DELETE FROM ",cl_get_target_table(l_plant_new,'ogb_file'),     #FUN-A50102 
                    " WHERE ogb01= ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
         PREPARE del_ogb1 FROM l_sql
         EXECUTE del_ogb1 USING t_oga.oga01
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = l_dbs_new CLIPPED,'del ogb'
            IF g_bgerr  THEN      
               CALL s_errmsg('ogb01',t_oga.oga01,g_msg,SQLCA.SQLCODE,1) 
            ELSE 
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            END IF
            LET g_success='N'
         END IF
      ELSE
      	 CALL cl_err('','axm-709',1)
      	 LET g_success = 'N'
      END IF	    
    END IF  
  END IF
  
END FUNCTION

#FUN-9C0073  By chenls  -------精簡程序-------
#FUN-C80001---begin
FUNCTION p901_idd_to_idb(p_idd,p_plant)
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
