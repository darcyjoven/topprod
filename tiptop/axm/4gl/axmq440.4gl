# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmq440.4gl
# Descriptions...: 訂單工單開立查詢
# Date & Author..: 95/01/20 By Danny
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0045 04/11/16 By Smapmin 帳款客戶,送貨客戶,人員,部門,產品編號開窗
# Modify.........: No.FUN-570175 05/07/20 By Elva  新增雙單位內容
# Modify.........: No.MOD-570253 05/08/11 By Rosayu oeb08=>no use
# Modify.........: No.FUN-610020 06/01/06 By Rayven 單頭新增 acd_q*
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.MOD-6A0040 06/10/16 By pengu 訂單分開多張工單,但只要開出多張工單,axmq440的[製程數量查詢]就查不到東西了
# Modify.........: No.FUN-6A0094 06/11/07 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760107 07/06/23 By claire 修改變數定義方式
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
# Modify.........: No.MOD-7C0200 07/12/26 By claire 單身的查詢條件字串有輸入時,畫面筆數需調整
# Modify.........: No.MOD-820038 08/02/13 By claire 單身輸入條件時,仍查出單頭全部資料
# Modify.........: No.MOD-8A0104 08/10/14 By Smapmin 一張訂單二個項次分別對應不同工單,QBE下訂單單號時只會出現一筆工單資料
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()       
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-A30112 10/03/16 By Smapmin 延續MOD-8A0104的修改,一張訂單二個項次,每個項次又對應到多張工單,QBE只會出現同一筆訂單單號+項次
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B70135 11/07/14 By JoHung 單身無資料時，不可執行製程數量查詢
# Modify.........: No.TQC-CB0069 12/11/21 By xuxz 顯示員工姓名，部門名稱，料件規格
# Modify.........: No.TQC-CC0012 12/12/04 By xuxz 訂單的oea65=Y才會顯示出簽收數量，若oea65=N,oga65=Y出貨簽收的訂單，簽收數量不會顯示出來，不合理。
# Modify.........: No.TQC-CC0016 12/12/04 By qirl 增加顯示開窗
# Modify.........: No.TQC-CC0017 12/12/04 By qirl 增加顯示開窗
# Modify.........: No.TQC-CC0018 12/12/04 By qirl 增加顯示開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
                wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500)                                             
                wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500) 
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,
            oea02   LIKE oea_file.oea02,
            oea03   LIKE oea_file.oea03,
            oea04   LIKE oea_file.oea04,
            oea032  LIKE oea_file.oea032,
            occ02   LIKE occ_file.occ02,
            oea14   LIKE oea_file.oea14,
            gen02   LIKE gen_file.gen02,#TQC-CB0069 add
            oea15   LIKE oea_file.oea15,
            gem02   LIKE gem_file.gem02,#TQC-CB0069 add
            oeaconf LIKE oea_file.oeaconf,
            oeahold LIKE oea_file.oeahold,
            oak02   LIKE oak_file.oak02,   #TQC-CC0016 add
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb092  LIKE oeb_file.oeb092,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            #FUN-570175  --begin
            oeb913  LIKE oeb_file.oeb913,
            oeb915  LIKE oeb_file.oeb915,
            acd_q2  LIKE ogb_file.ogb12, #No.FUN-610020
            oeb910  LIKE oeb_file.oeb910,
            oeb912  LIKE oeb_file.oeb912,
            acd_q1  LIKE ogb_file.ogb12, #No.FUN-610020
            #FUN-570175  --end
            acd_q   LIKE ogb_file.ogb12,  #MOD-760107 modify  type_file.num10,   #No.FUN-610020  #No.FUN-680137 INTEGER
            oeb24   LIKE oeb_file.oeb24,  #MOD-760107 modify  type_file.num10,         #No.FUN-680137 INTEGER
            oeb25   LIKE oeb_file.oeb25,  #MOD-760107 modify  type_file.num10,         #No.FUN-680137 INTEGER
            unqty   LIKE oeb_file.oeb24,  #MOD-760107 modify  type_file.num10,         #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb70   LIKE oeb_file.oeb70,
            oeb06   LIKE oeb_file.oeb06,
            ima021  LIKE ima_file.ima021,#TQC-CB0069 add
            #oeb08  LIKE oeb_file.oeb08, #MOD-570253mark
            oeb09   LIKE oeb_file.oeb09,
            oeb09_1 LIKE imd_file.imd02,  #TQC-CC0016 add
            oeb091  LIKE oeb_file.oeb091,
            oeb091_1 LIKE ime_file.ime03,     #TQC-CC0016 add
            oeb16   LIKE oeb_file.oeb16
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb01   LIKE sfb_file.sfb01,
            sfb04_d LIKE type_file.chr8,          #No.FUN-680137 VARCHAR(8)
            sfb13   LIKE sfb_file.sfb13,
            sfb15   LIKE sfb_file.sfb15,
            sfb08   LIKE sfb_file.sfb08,
            sfb081  LIKE sfb_file.sfb081,
            sfb09   LIKE sfb_file.sfb09,
            sfb82   LIKE sfb_file.sfb82,
            gem02   LIKE gem_file.gem02      #TQC-CC0016 add
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_argv2         LIKE oeb_file.oeb03,
    g_sfb01         LIKE sfb_file.sfb01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_cmd           LIKE type_file.chr1000,         #No.FUN-680137  VARCHAR(100)	
     g_sql          STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
 
   #No.7895
   DEFINE l_dbs_new LIKE type_file.chr21     #New DataBase Name #No.FUN-680137 VARCHAR(21)
   DEFINE l_azp  RECORD LIKE azp_file.*
   DEFINE l_last  LIKE type_file.num5      #流程之最後家數      #No.FUN-680137 SMALLINT
   DEFINE l_last_plant  LIKE faj_file.faj02            #No.FUN-680137 VARCHAR(10)
 
DEFINE   g_cnt           LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10           #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10           #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10           #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094 
        RETURNING g_time                  #NO.FUN-6A0094 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)
    LET g_query_flag=1
 
    OPEN WINDOW q440_w WITH FORM "axm/42f/axmq440"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----FUN-610067---------
    CALL q440_def_form()
    #FUN-570175 --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
#      CALL cl_set_comp_visible("acd_q2,acd_q1",FALSE) #No.FUN-610020
#      CALL cl_set_comp_visible("group03",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#      #No.FUN-610020  --Begin
#      CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
#      CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
#      #No.FUN-610020  --End
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#      #No.FUN-610020  --Begin
#      CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
#      CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
#      #No.FUN-610020  --End
#   END IF
    #FUN-570175 --end
    #-----END FUN-610067-----
#    IF cl_chk_act_auth() THEN
#       CALL q440_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q440_q() END IF
    CALL q440_menu()
    CLOSE WINDOW q440_w
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094 
        RETURNING g_time                   #NO.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q440_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
           IF NOT cl_null(g_argv2) THEN
              LET tm.wc=tm.wc CLIPPED," AND oeb03=",g_argv2
           END IF
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sfb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON
                     oea01,oea02,oea03,oea032,oea04,
                     oea14,oea15,oeahold,oeaconf,oeb70,
                     oeb03,oeb04,oeb06,oeb05,oeb12,oeb15,
                     oeb913,oeb915,oeb910,oeb912, #FUN-570175
                     #oeb08,oeb09,oeb091,oeb092, #MOD-570253
                            oeb09,oeb091,oeb092, #MOD-570253
                     oeb16,oeb24,oeb25
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION CONTROLP
           CASE
             #--TQC-CC0016--add--star--
             WHEN INFIELD(oea01) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oea01"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea01
                  NEXT FIELD oea01
             WHEN INFIELD(oeb03) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oeb031"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb03
                  NEXT FIELD oeb03
             WHEN INFIELD(oeahold) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oea12_2"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeahold
                  NEXT FIELD oeahold 
             #--TQC-CC0017--add--star--
             WHEN INFIELD(oeb09) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oeb09"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb09
                  NEXT FIELD oeb09
             WHEN INFIELD(oeb091) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oeb091"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb091
                  NEXT FIELD oeb091
             WHEN INFIELD(oeb092) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oeb092"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb092
                  NEXT FIELD oeb092
             #--TQC-CC0017--add--end---
             #--TQC-CC0016--add--end---
             WHEN INFIELD(oea03) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
             WHEN INFIELD(oea04) #送貨客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04
             WHEN INFIELD(oea14) #人員   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea14
                  NEXT FIELD oea14
             WHEN INFIELD(oea15) #部門   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea15
                  NEXT FIELD oea15
             WHEN INFIELD(oeb04) #產品編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb04
                  NEXT FIELD oeb04
           END CASE
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           CALL q440_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   IF (cl_null(tm.wc) OR tm.wc=' 1=1')  AND tm.wc2= ' 1=1'  THEN #MOD-7C0200 modify
      LET g_sql=" SELECT oea01,oeb03 ",
                "   FROM oea_file, ",
                "        oeb_file  ",
                " WHERE oea01=oeb01 AND ",tm.wc CLIPPED,
                "   AND oeaconf != 'X' "   #01/08/16 mandy
   ELSE
      #LET g_sql=" SELECT oea01,oeb03 ",   #MOD-A30112
      LET g_sql=" SELECT DISTINCT oea01,oeb03 ",   #MOD-A30112
                "   FROM oea_file, ",
                "        oeb_file  ",
                "       ,sfb_file  ",     #MOD-7C0200
                " WHERE oea01=oeb01 AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED,
                "   AND sfb22 = oea01 ",  #MOD-7C0200
                "   AND sfb221= oeb03 ",  #MOD-7C0200
                "   AND oeaconf != 'X' "   #01/08/16 mandy
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY oea01,oeb03"
   PREPARE q440_prepare FROM g_sql
   DECLARE q440_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q440_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   #BugNO:3330 01/08/15 mandy
   IF (cl_null(tm.wc) OR tm.wc=' 1=1')  AND tm.wc2= ' 1=1'  THEN #MOD-7C0200 add
      LET g_sql = "SELECT COUNT(*)  ",
                  "   FROM oea_file, ",
                  "        oeb_file  ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND oeaconf != 'X' ", #01/08/15 mandy
                  "   AND oeb01 = oea01 "
  #MOD-7C0200-begin-add
   ELSE 
      #LET g_sql = "SELECT COUNT(*)  ",           #MOD-820038 mark
      #LET g_sql=" SELECT COUNT(DISTINCT oea01) ",#MOD-820038  #MOD-8A0104mark 
      LET g_sql=" SELECT COUNT(DISTINCT oea01||oeb03) ",       #MOD-8A0104  
                  "   FROM oea_file, ",
                  "        oeb_file  ",
                  "       ,sfb_file  ",    
                  " WHERE ",tm.wc CLIPPED,
                  "   AND ",tm.wc2 CLIPPED,
                  "   AND oeaconf != 'X' ", #01/08/15 mandy
                  "   AND sfb22 = oea01 ", 
                  "   AND sfb221= oeb03 ",  
                  "   AND oeb01 = oea01 "
   END IF 
  #MOD-7C0200-end-add
 
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q440_pp  FROM g_sql
   DECLARE q440_cnt   CURSOR FOR q440_pp
END FUNCTION
 
FUNCTION q440_b_askkey()
   CONSTRUCT tm.wc2 ON sfb01,sfb04_d,sfb13,sfb15,sfb08,sfb081,sfb09,sfb82
                  FROM s_sfb[1].sfb01,s_sfb[1].sfb04_d,s_sfb[1].sfb13,
                       s_sfb[1].sfb15,s_sfb[1].sfb08,s_sfb[1].sfb081,
                       s_sfb[1].sfb09,s_sfb[1].sfb82
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
         #--TQC-CC0018--add--star--
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(sfb01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfa10"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01 
                  NEXT FIELD sfb01
             WHEN INFIELD(sfb82) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfb821"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb82
                  NEXT FIELD sfb82
             WHEN INFIELD(sfb04_d) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfb040"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb04_d
                  NEXT FIELD sfb04_d
          END CASE
         #--TQC-CC0018--add---end---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q440_menu()
   DEFINE l_cnt    LIKE type_file.num5  #MOD-760107 modify INTEGER    #No.MOD-6A0040 add
 
   WHILE TRUE
      CALL q440_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q440_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "製程數量查詢"
         WHEN "query_routing_quantity"
           #-------No.MOD-6A0040 modify
           #SELECT sfb01 INTO g_sfb01 FROM sfb_file
           #WHERE sfb22 = g_oea.oea01
           #IF SQLCA.sqlcode THEN
           #   LET g_sfb01 = ' '
           #END IF
            LET l_cnt = ARR_CURR()
            IF l_cnt > 0 THEN        #MOD-B70135 add
               LET g_sfb01 = g_sfb[l_cnt].sfb01
           #-------No.MOD-6A0040 end
               LET g_cmd="aecq700 '",g_sfb01,"'"  clipped
               CALL cl_cmdrun(g_cmd)
            END IF                   #MOD-B70135 add
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q440_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q440_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q440_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q440_cnt
        FETCH q440_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q440_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q440_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q440_cs INTO g_oea.oea01,g_oea.oeb03
       WHEN 'P' FETCH PREVIOUS q440_cs INTO g_oea.oea01,g_oea.oeb03
       WHEN 'F' FETCH FIRST    q440_cs INTO g_oea.oea01,g_oea.oeb03
       WHEN 'L' FETCH LAST     q440_cs INTO g_oea.oea01,g_oea.oeb03
       WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump q440_cs INTO g_oea.oea01,g_oea.oeb03
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
       #SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold,#TQC-CB0069 mark
        SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,'',oea15,'',oeaconf,oeahold,'',#TQC-CB0069 add
        #FUN-570175  --begin
          oeb03,oeb04,oeb092,oeb05,oeb12,oeb913,oeb915,0,    #No.FUN-610020
          oeb910,oeb912,0,0,oeb24,oeb25,(oeb12-oeb24+oeb25-oeb26),   #No.FUN-610020
        #FUN-570175  --end
           #oeb15,oeb70,oeb06,oeb08,oeb09,oeb091,oeb16 # MOD-570253
           #oeb15,oeb70,oeb06,      oeb09,oeb091,oeb16 #MOD-570253#TQC-CB0069 mark
            oeb15,oeb70,oeb06,''    ,oeb09,'',oeb091,'',oeb16#TQC-CB0069 add
	  INTO g_oea.*
	  FROM oea_file,oeb_file
     WHERE oea01= g_oea.oea01
       AND oeb03= g_oea.oeb03
       AND oea01=oeb01
 
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","oea_file,oeb_file",g_oea.oea01,g_oea.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
    #No.FUN-610020  --Begin
    SELECT SUM(ogb12),SUM(ogb915),SUM(ogb912)
      INTO g_oea.acd_q,g_oea.acd_q2,g_oea.acd_q1
      FROM ogb_file,oga_file,oea_file,oeb_file
     WHERE ogb31 = g_oea.oea01 AND ogb32 = g_oea.oeb03
       AND ogb01 = oga01
       AND oeb01 = oea01
       AND oeb01 = ogb31 AND oeb03 = ogb32
      #AND oea65 = 'Y'#TQC-CC0012 mark
       AND ogaconf = 'Y' AND ogapost = 'Y'
       AND oga09 = '8' 
    IF cl_null(g_oea.acd_q2) THEN LET g_oea.acd_q2 = 0 END IF
    IF cl_null(g_oea.acd_q1) THEN LET g_oea.acd_q1 = 0 END IF
    IF cl_null(g_oea.acd_q ) THEN LET g_oea.acd_q  = 0 END IF
 
    IF cl_null(g_oea.oeb913) AND cl_null(g_oea.oeb915) THEN
       LET g_oea.acd_q2 = ''
    END IF
    IF cl_null(g_oea.oeb910) AND cl_null(g_oea.oeb912) THEN
       LET g_oea.acd_q1 = ''
    END IF
    #No.FUN-610020  --End
 
    CALL q440_show()
END FUNCTION
 
FUNCTION q440_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
  #TQC-CB0069--add-str
   SELECT gen02 INTO g_oea.gen02 FROM gen_file WHERE gen01 = g_oea.oea14
   IF SQLCA.SQLCODE THEN LET g_oea.gen02=' ' END IF
   SELECT gem02 INTO g_oea.gem02 FROM gem_file WHERE gem01 = g_oea.oea15
   IF SQLCA.SQLCODE THEN LET g_oea.gem02=' ' END IF
   SELECT ima021 INTO g_oea.ima021 FROM ima_file WHERE ima01 = g_oea.oeb04
   IF SQLCA.SQLCODE THEN LET g_oea.ima021 = ' ' END IF
  #TQC-CB0069--add--end
  #TQC-CC0016---add--star--
   SELECT oak02 INTO g_oea.oak02 FROM oak_file WHERE oak01 = g_oea.oeahold
   IF SQLCA.SQLCODE THEN LET g_oea.oak02=' ' END IF
   SELECT imd02 INTO g_oea.oeb09_1 FROM imd_file WHERE imd01 = g_oea.oeb09
   SELECT ime03 INTO g_oea.oeb091_1 FROM ime_file WHERE ime01 = g_oea.oeb091
  #TQC-CC0016---add--end---
   DISPLAY BY NAME g_oea.*
   CALL q440_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q440_b_fill()              #BODY FILL UP
 DEFINE l_sql          LIKE type_file.chr1000          #No.FUN-680137 VARCHAR(1000)
 DEFINE l_oea901       LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 DEFINE l_oea904       LIKE type_file.chr8          #No.FUN-680137 VARCHAR(8)
 DEFINE l_dbs_new_tra  LIKE type_file.chr21
 
 LET l_last=''
 LET l_last_plant=' '
 SELECT oea901,oea904 INTO l_oea901,l_oea904 FROM oea_file
  WHERE oea01=g_oea.oea01
 IF l_oea901='Y' THEN
    SELECT MAX(poy02) INTO l_last FROM poy_file
     WHERE poy01 = l_oea904
    SELECT poy04 INTO l_last_plant FROM poy_file
     WHERE poy01 = l_oea904  AND poy02 = l_last
    SELECT * INTO l_azp.* FROM azp_file WHERE azp01=l_last_plant
   #LET l_dbs_new = l_azp.azp03 CLIPPED,"."  #TQC-950032 MARK                                                                       
    LET l_dbs_new = s_dbstring(l_azp.azp03) #TQC-950032 ADD        
 
   #FUN-980091 ------------------(S)
    LET g_plant_new = l_last_plant
    CALL s_gettrandbs()
    LET l_dbs_new_tra = g_dbs_tra
   #FUN-980091 ------------------(E)
 ELSE
    LET l_dbs_new = ' '
   #FUN-980091 ------------------(S)
    LET l_last_plant = g_plant 
    LET g_plant_new = l_last_plant
    CALL s_gettrandbs()
    LET l_dbs_new_tra = g_dbs_tra
   #FUN-980091 ------------------(E)
 END IF
 #No.7895
 LET l_sql  = "SELECT * ",
             #" FROM ",l_dbs_new CLIPPED,"sfb_file ", #FUN-980091 mark
              #" FROM ",l_dbs_new_tra CLIPPED,"sfb_file ", #FUN-980091 add
              " FROM ",cl_get_target_table(l_last_plant,'sfb_file'), #FUN-A50102
              " WHERE sfb22='",g_oea.oea01,"' "
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 CALL cl_parse_qry_sql(l_sql,l_last_plant) RETURNING l_sql #FUN-980091
 PREPARE sfb_p1 FROM l_sql
 DECLARE sfb_c1 CURSOR FOR sfb_p1
 OPEN sfb_c1
 FETCH sfb_c1 INTO g_sfb01
 IF SQLCA.sqlcode THEN LET g_sfb01 = ' ' END IF
 CLOSE sfb_c1
 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT sfb01,sfb04,sfb13,sfb15,sfb08,sfb081,",
        "       sfb09,sfb82 ,''  ",   #TQC-CC0016---ADD--''
       #"  FROM ",l_dbs_new CLIPPED,"sfb_file  ", #No.7895 #FUN-980091 mark
        #"  FROM ",l_dbs_new_tra CLIPPED,"sfb_file  ", #FUN-980091 add
        "  FROM ",cl_get_target_table(l_last_plant,'sfb_file'), #FUN-A50102
        " WHERE sfb22='",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND sfb221=",g_oea.oeb03,
        "   AND sfb87!='X' ",
        " ORDER BY 1"
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_last_plant) RETURNING l_sql #FUN-980091
    PREPARE q440_pb FROM l_sql
    DECLARE q440_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q440_pb
#TQC-790065--start--
#   FOR g_cnt = 1 TO g_sfb.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_sfb[g_cnt].* TO NULL
#   END FOR
    CALL g_sfb.clear()
#TQC-790065---end--
    LET g_cnt = 1
    FOREACH q440_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s_wostatu(g_sfb[g_cnt].sfb04_d) RETURNING g_sfb[g_cnt].sfb04_d
        IF SQLCA.SQLCODE THEN LET g_sfb[g_cnt].sfb04_d=' ' END IF
        IF g_sfb[g_cnt].sfb08 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb08 = 0
        END IF
        IF g_sfb[g_cnt].sfb081 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb081 = 0
        END IF
        IF g_sfb[g_cnt].sfb09 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb09 = 0
        END IF
  #TQC-CC0016---add--star-- 
    
   SELECT gem02 INTO g_sfb[g_cnt].gem02 FROM gem_file WHERE gem01 = g_sfb[g_cnt].sfb82 
   IF SQLCA.SQLCODE THEN LET g_sfb[g_cnt].gem02=' ' END IF
  #TQC-CC0016---add--end---
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q440_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                             #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q440_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q440_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q440_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q440_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q440_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL q440_def_form()     #FUN-610067
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 製程數量查詢
      ON ACTION query_routing_quantity
         LET g_action_choice="query_routing_quantity"
         EXIT DISPLAY
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0038
   LET g_action_choice = 'exporttoexcel'
   EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-----FUN-610067---------
FUNCTION q440_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("acd_q2,acd_q1",FALSE) #No.FUN-610020
       CALL cl_set_comp_visible("group03",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END FUN-610067-----
