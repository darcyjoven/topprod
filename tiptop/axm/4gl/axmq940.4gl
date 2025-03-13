# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: axmq940.4gl
# Descriptions...: 多角訂單追蹤查詢
# Date & Author..: No.FUN-620048 06/02/21 By TSD.andy
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680077 06/08/22 By Claire 加入oea24
# Modify.........: No.FUN-680137 06/09/07 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: NO.TQC-6A0056 06/10/23 by yiting poz05己無資料 
# Modify.........: No.FUN-6A0094 06/11/07 By yjkhero l_time轉g_time
# Modify.........: No.TQC-7C0130 07/12/10 By chenl 出貨明細資料錯
# Modify.........: No.MOD-910074 09/01/08 By claire 採購含稅,未稅金額;以pmn88,pmn88t計算
# Modify.........: No.TQC-910035 09/01/15 By claire 調整程式
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-9A0168 09/10/28 By 過濾作廢單據 
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B10245 11/02/09 By Summer 抓取的單據都要排除作廢
# Modify.........: No:FUN-B30101 11/04/26 By wuxj 顯示多角銷退、Packing、Invoice單號
# Modify.........: No:MOD-B80170 11/08/17 By suncx 訂單明細單身形態為2：採購單的單價抓取錯誤
# Modify.........: No:MOD-B80181 11/08/17 By lixia 銷退頁簽有串單的現象
# Modify.........: No:FUN-B90012 11/09/27 By fengrui 增加刻號／BIN明細 or 查詢
# Modify.........: No:FUN-C10021 12/04/05 By Sakura 使用dialog將單頭單身包起來，原瀏覽/回單頭Action取消
# Modify.........: No:FUN-C30256 12/12/24 By Sakura 多增加出貨通知單明細
# Modify.........: No:FUN-D10119 13/03/03 By Elise 增加匯出Excel功能
# Modify.........: No:FUN-CC0090 13/04/08 By jt_chen 增加消退單立帳資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#DEFINE g_up         LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)#FUN-C10021 mark
DEFINE
    g_oea_a         DYNAMIC ARRAY OF RECORD
                    oea01     LIKE oea_file.oea01,
                    oea02     LIKE oea_file.oea02,
                    oea03     LIKE oea_file.oea03,
                    oea032    LIKE oea_file.oea032,
                    oea10     LIKE oea_file.oea10,
                    oea14     LIKE oea_file.oea14,
                    gen02     LIKE gen_file.gen02,
                    oea904    LIKE oea_file.oea904,
                    azp02     LIKE azp_file.azp02,
                    oea99     LIKE oea_file.oea99,    #FUN-B30101 add
                    oeaconf   LIKE oea_file.oeaconf,
                    oea905    LIKE oea_file.oea905
                    END RECORD,
    g_oea_b         DYNAMIC ARRAY OF RECORD
                    azp01_1   LIKE azp_file.azp01,
                    kind_1    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
                    oea01_1   LIKE oea_file.oea01,
                    oea03_1   LIKE oea_file.oea03,
                    oea032_1  LIKE oea_file.oea032,
                    oea31     LIKE oea_file.oea31,
                    oea32     LIKE oea_file.oea32,
                    oea21     LIKE oea_file.oea21,
                    oea23     LIKE oea_file.oea23,
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    oeb06     LIKE oeb_file.oeb06,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb24     LIKE oeb_file.oeb24,
                    oea24     LIKE oea_file.oea24, #FUN-680077 add 
                    oeb13     LIKE oeb_file.oeb13,
                    oeb15     LIKE oeb_file.oeb15,
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oea05     LIKE oea_file.oea05
                    END RECORD,
    g_oga_b         DYNAMIC ARRAY OF RECORD
                    oga99     LIKE oga_file.oga99,
                    azp01_2   LIKE azp_file.azp01,
                    kind_2    LIKE type_file.chr1,  #No.FUN-680137 VARCHAR(1)
                    oga01     LIKE oga_file.oga01,
                    oga31     LIKE oga_file.oga31,
                    oga32     LIKE oga_file.oga32,
                    oga21     LIKE oga_file.oga21,
                    oga23     LIKE oga_file.oga23,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb04     LIKE ogb_file.ogb04,
                    ogb06     LIKE ogb_file.ogb06,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb13     LIKE ogb_file.ogb13,
                    oga05     LIKE oga_file.oga05
                    END RECORD,
#FUN-C30256---add---START
    g_oga1_b        DYNAMIC ARRAY OF RECORD
                    oga99_1     LIKE oga_file.oga99,
                    azp01_7   LIKE azp_file.azp01,
                    kind_5    LIKE type_file.chr1,  #No.FUN-680137 VARCHAR(1)
                    oga01_1     LIKE oga_file.oga01,
                    oga31_1     LIKE oga_file.oga31,
                    oga32_1     LIKE oga_file.oga32,
                    oga21_1     LIKE oga_file.oga21,
                    oga23_1     LIKE oga_file.oga23,
                    ogb03_1     LIKE ogb_file.ogb03,
                    ogb04_1     LIKE ogb_file.ogb04,
                    ogb06_1     LIKE ogb_file.ogb06,
                    ogb12_1     LIKE ogb_file.ogb12,
                    ogb13_1     LIKE ogb_file.ogb13,
                    oga05_1     LIKE oga_file.oga05
                    END RECORD, 
#FUN-C30256---add-----END
    g_oma_b         DYNAMIC ARRAY OF RECORD
                    oma99     LIKE oma_file.oma99,
                    azp01_3   LIKE azp_file.azp03,
                    kind_3    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
                    oma01     LIKE oma_file.oma01,
                    oma03     LIKE oma_file.oma03,
                    oma032    LIKE oma_file.oma032,
                    oma32     LIKE oma_file.oma32,
                    oma21     LIKE oma_file.oma21,
                    oma23     LIKE oma_file.oma23,
                    oma24     LIKE oma_file.oma24,
                    oma54t    LIKE oma_file.oma54t,
                    oma56t    LIKE oma_file.oma56t
                    END RECORD,

  #-----No.FUN-B30101--START----
    g_ohb_b         DYNAMIC ARRAY OF RECORD
                    oha99     LIKE oha_file.oha99,
                    azp01_4   LIKE azp_file.azp03,
                    kind_4    LIKE type_file.chr1,
                    oha01     LIKE oha_file.oha01,
                    ohb03     LIKE ohb_file.ohb03,
                    ohb50     LIKE ohb_file.ohb50,
                    ohb04     LIKE ohb_file.ohb04,
                    ohb06     LIKE ohb_file.ohb06,
                    ima021    LIKE ima_file.ima021,
                    ohb09     LIKE ohb_file.ohb09,
                    ohb091    LIKE ohb_file.ohb091,
                    ohb092    LIKE ohb_file.ohb092,
                    ohb05     LIKE ohb_file.ohb05,
                    ohb12     LIKE ohb_file.ohb12
                    END RECORD,
    g_ogd_b         DYNAMIC ARRAY OF RECORD
                    oga99_2   LIKE oga_file.oga99,
                    azp01_5   LIKE azp_file.azp03,
                    oga01_2   LIKE oga_file.oga01,
                    ogd03     LIKE ogd_file.ogd03,
                    ogb04_2   LIKE ogb_file.ogb04,
                    ogd04     LIKE ogd_file.ogd04,
                    ogd08     LIKE ogd_file.ogd08,
                    ogd09     LIKE ogd_file.ogd09,
                    ogd10     LIKE ogd_file.ogd10,
                    ogd11     LIKE ogd_file.ogd11,
                    ogd12b    LIKE ogd_file.ogd12b,
                    ogd12e    LIKE ogd_file.ogd12e,
                    ogd13     LIKE ogd_file.ogd13,
                    ogd14     LIKE ogd_file.ogd14,
                    ogd14t    LIKE ogd_file.ogd14t,
                    ogd15     LIKE ogd_file.ogd15,
                    ogd15t    LIKE ogd_file.ogd15t,
                    ogd16     LIKE ogd_file.ogd16,
                    ogd16t    LIKE ogd_file.ogd16t
                    END RECORD,
    g_ofb_b         DYNAMIC ARRAY OF RECORD
                    ofa99     LIKE ofa_file.ofa99,
                    azp01_6   LIKE azp_file.azp03,
                    ofa01     LIKE ofa_file.ofa01,
                    ofb03     LIKE ofb_file.ofb03,
                    ofb04     LIKE ofb_file.ofb04,
                    ofb06     LIKE ofb_file.ofb06,
                    ima021_2  LIKE ima_file.ima021,
                    ofb05     LIKE ofb_file.ofb05,
                    ofb12     LIKE ofb_file.ofb12,
                    ofb13     LIKE ofb_file.ofb13,
                    ofb14     LIKE ofb_file.ofb14,
                    ofb14t    LIKE ofb_file.ofb14t,
                    ofb11     LIKE ofb_file.ofb11,
                    ofb33     LIKE ofb_file.ofb33
                    END RECORD,
   #--NO.FUN-B30101--END--

    g_plant_1       DYNAMIC ARRAY OF RECORD
                    no        LIKE azp_file.azp01,
                    db_name   LIKE azp_file.azp03,
                    db_name_tra LIKE azp_file.azp03 #FUN-980091
                    END RECORD,
    g_wc1           STRING,
    g_oga99_wc      STRING,
    g_oga99_1_wc    STRING, #FUN-C30256 add
    g_rec_b1        LIKE type_file.num5,          #單身筆數        #No.FUN-680137 SMALLINT
    g_rec_b2        LIKE type_file.num5,          #單身筆數        #No.FUN-680137 SMALLINT
    g_rec_b3        LIKE type_file.num5,          #單身筆數        #No.FUN-680137 SMALLINT
    g_rec_b4        LIKE type_file.num5,          #單身筆數        #No.FUN-680137 SMALLINT
    g_rec_b5        LIKE type_file.num5,          #單身筆數        #No.FUN-B30101
    g_rec_b6        LIKE type_file.num5,          #單身筆數        #No.FUN-B30101
    g_rec_b7        LIKE type_file.num5,          #單身筆數        #No.FUN-B30101
    g_rec_b8        LIKE type_file.num5,          #單身筆數        #FUN-C30256 add
    g_rec_plant     LIKE type_file.num5,          #No.FUN-680137 SMALLINT              #工廠個數
    g_sql           STRING,
    l_ac,l_ac_t     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_ac1           LIKE type_file.num5           #No.FUN-B90012 SMALLINT
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  #NO.FUN-6A0094 
 
   OPEN WINDOW q940_w WITH FORM "axm/42f/axmq940"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL q940_menu()
   CLOSE WINDOW q940_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #計算使用時間 (退出使間)   #NO.FUN-6A0094 
END MAIN
 
#QBE 查詢資料
FUNCTION q940_cs()
  CLEAR FORM                             #清除畫面
  CALL g_oea_a.clear()
  CALL g_oea_b.clear()
  CALL g_oga_b.clear()
  CALL g_oga1_b.clear()    #FUN-C30256 add
  CALL g_oma_b.clear()
  CALL g_ohb_b.clear()     #NO.FUN-B30101
  CALL g_ogd_b.clear()     #NO.FUN-B30101
  CALL g_ofb_b.clear()     #NO.FUN-B30101
 
  CONSTRUCT g_wc1 ON oea01,oea02,oea03,oea032,oea10,oea14,oea904,oea99,oeaconf,oea905  #NO.FUN-B30101
                  FROM s_oea_a[1].oea01,s_oea_a[1].oea02,s_oea_a[1].oea03,
                       s_oea_a[1].oea032,s_oea_a[1].oea10,s_oea_a[1].oea14,
                       s_oea_a[1].oea904,s_oea_a[1].oea99,s_oea_a[1].oeaconf,s_oea_a[1].oea905  #NO.FUN-B30101
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oea01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oea01_c"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea01
                   NEXT FIELD oea01
 
              WHEN INFIELD(oea03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea03
                   NEXT FIELD oea03
 
              WHEN INFIELD(oea14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea14
                   NEXT FIELD oea14
 
              WHEN INFIELD(oea904)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea904
                   NEXT FIELD oea904
 
              OTHERWISE EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
  END CONSTRUCT
  IF INT_FLAG THEN
     RETURN
  END IF
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc1 = g_wc1 CLIPPED," AND oeagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
  #End:FUN-980030
 
END FUNCTION
 
FUNCTION q940_menu()
   WHILE TRUE
    #  CALL q940_bp("G")
      CALL q940_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q940_q()
            END IF
 
      #FUN-C10021---mark---START
      #  WHEN "view1"
      #       CALL q940_bp2()
 
      #  WHEN "view2"
      #       CALL q940_bp3()
 
      #  WHEN "view3"
      #       CALL q940_bp4()

      ##No.FUN-B30101--ADD--
      #   WHEN "view4"
      #       CALL q940_bp5()

      #   WHEN "view5"
      #       CALL q940_bp6()

      #   WHEN "view6"
      #       CALL q940_bp7()
      ##No.FUN-B30101--END--
      #FUN-C10021---mark---END
           
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            #LET g_up = 'R' #FUN-C10021 mark

        #FUN-D10119---add---S
         WHEN "exporttoexcel"     #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea_a),'','')
            END IF
        #FUN-D10119---add---E
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q940_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_oea_a.clear()
    CALL g_oea_b.clear()
    CALL g_oga_b.clear()
    CALL g_oga1_b.clear() #FUN-C30256 add
    CALL g_oma_b.clear()
#--NO.FUN-B30101--ADD--
    CALL g_ohb_b.clear()
    CALL g_ogd_b.clear()
    CALL g_ofb_b.clear()
#--NO.FUN-B30101--END--
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    DISPLAY '   ' TO FORMONLY.cn3
    DISPLAY '   ' TO FORMONLY.cn4
#--NO.FUN-B30101--ADD--
    DISPLAY '   ' TO FORMONLY.cn5
    DISPLAY '   ' TO FORMONLY.cn6
    DISPLAY '   ' TO FORMONLY.cn7
#--NO.FUN-B30101--END--
    CALL q940_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL q940_b1_fill(g_wc1)
 
    LET l_ac = 1
END FUNCTION
 
FUNCTION q940_plant()
DEFINE  l_poy02  LIKE poy_file.poy02
DEFINE  l_flag   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF cl_null(g_oea_a[l_ac].oea01) THEN
       RETURN 0
    END IF
 
    #TQC-7C0130 --begin--
    #LET g_rec_plant = 1
    LET g_rec_plant = 0
    #TQC-7C0130 --end--
    LET l_flag = 'Y'
    CALL g_plant_1.clear()
 
#NO.TQC-6A0056 mark
#    SELECT poz05 INTO g_plant_1[g_rec_plant].no
#      FROM poz_file
#     WHERE poz01 = g_oea_a[l_ac].oea904
#    IF SQLCA.SQLCODE THEN
##      CALL cl_err(g_oea_a[l_ac].oea904,'TSD0004',0)   #No.FUN-660167
#       CALL cl_err3("sel","poz_file",g_oea_a[l_ac].oea904,"","TSD0004","","",0)   #No.FUN-660167
#       RETURN 0
#    ELSE
#NO.TQC-6A0056 mark
    #TQC-7C0130 mark
    #   SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
    #      FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
    #TQC-7C0130 end
 
       LET g_rec_plant = g_rec_plant + 1
 
       DECLARE q940_plant_cs CURSOR FOR
         SELECT poy02,poy04 FROM poy_file
          WHERE poy01 = g_oea_a[l_ac].oea904
          ORDER BY poy02
 
       FOREACH q940_plant_cs INTO l_poy02,g_plant_1[g_rec_plant].no
         IF STATUS THEN
            CALL cl_err(g_oea_a[l_ac].oea904,'TSD0004',0) 
            LET l_flag = 'N'
            EXIT FOREACH
         END IF
 
         SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
           FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
 
        #FUN-980091 ----------------(S)
         LET g_plant_new = g_plant_1[g_rec_plant].no
         CALL s_gettrandbs()
         LET g_plant_1[g_rec_plant].db_name_tra = g_dbs_tra
        #FUN-980091 ----------------(E)
 
         LET g_rec_plant = g_rec_plant + 1
       END FOREACH
       LET g_rec_plant = g_rec_plant - 1
 #   END IF  #NO.TQC-6A0056 MARK
    IF l_flag = 'Y' THEN
       RETURN 1
    ELSE
       RETURN 0
    END IF
 
END FUNCTION
 
FUNCTION q940_b1_fill(p_wc1)
DEFINE  p_wc1        STRING
DEFINE  l_last       LIKE poy_file.poy02,
        l_last_plant LIKE poy_file.poy04
 
    IF cl_null(p_wc1) THEN
       LET p_wc1 = ' 1=1'
    END IF
 
    LET g_sql = "SELECT oea01,oea02,oea03,oea032,oea10,oea14,",
                "       ' ',oea904,' ',oea99,oeaconf,oea905 ",   #FUN-B30101 ADD oea99
                "  FROM oea_file ",
                " WHERE oea901 = 'Y' ",   #多角訂單
                "   AND oea11  <> '6'",   #不包含(6.多角代採買)
                "   AND oeaconf <> 'X'",  #MOD-9A0168 
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY oea01"
    PREPARE q940_pre1 FROM g_sql
    DECLARE q940_cs1 CURSOR FOR q940_pre1
 
    CALL g_oea_a.clear()
    LET g_rec_b1 = 1
    DISPLAY ' ' TO FORMONLY.cnt
 
    FOREACH q940_cs1 INTO g_oea_a[g_rec_b1].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('b1_fill foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        # ---抓業務姓名-------
        SELECT gen02 INTO g_oea_a[g_rec_b1].gen02
          FROM gen_file WHERE gen01 = g_oea_a[g_rec_b1].oea14
 
        # ---抓出貨工廠(最後一站的工廠名稱)-------
        LET l_last_plant = NULL
        CALL s_tri_last(g_oea_a[g_rec_b1].oea904)
             RETURNING l_last,l_last_plant
        SELECT azp02 INTO g_oea_a[g_rec_b1].azp02
           FROM azp_file
          WHERE azp01 = l_last_plant
 
        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err('', 9035, 0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oea_a.deleteElement(g_rec_b1)
    LET g_rec_b1 = g_rec_b1 - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
END FUNCTION
 
FUNCTION q940_b2_fill()
DEFINE  l_i      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_oea99  LIKE oea_file.oea99
 
    CALL g_oea_b.clear()
    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2
 
    SELECT oea99 INTO l_oea99
      FROM oea_file
     WHERE oea01 = g_oea_a[l_ac].oea01
    IF SQLCA.SQLCODE OR cl_null(l_oea99) THEN
#      CALL cl_err(g_oea_a[l_ac].oea01,SQLCA.SQLCODE,0)   #No.FUN-660167
       CALL cl_err3("sel","oea_file",g_oea_a[l_ac].oea01,"",SQLCA.SQLCODE,"","",0)   #No.FUN-660167
       LET g_rec_b2 = 0
       DISPLAY g_rec_b2 TO FORMONLY.cn2
       RETURN
    END IF
 
    FOR l_i = 1 TO g_rec_plant
        LET g_sql = "SELECT ' ','1',oea01,oea03,oea032,oea31,oea32,oea21,",
                    "        oea23,oeb03,oeb04,oeb06,oeb12,oeb24,oea24,oeb13, ", #FUN-680077 add oea24 匯率
                    "        oeb15,oeb14,oeb14t,oea05 ",
#TQC-950032 MARK&ADD START------------------------------------------------------                                                    
#                   "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.oea_file,",                                                          
#                             g_plant_1[l_i].db_name CLIPPED,".dbo.oeb_file ",                                                          
                   #FUN-980091 ----------------(S)
                   #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oea_file,", #TQC-950032 MARK                              
                   #          s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oeb_file ", #TQC-950032 ADD                               
                   #------------------------------
                    #"  FROM ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"oea_file,",
                    #          s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"oeb_file ",
                   "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oea_file'),",",  #FUN-A50102
                             cl_get_target_table(g_plant_1[l_i].no,'oeb_file'),      #FUN-A50102
                   #FUN-980091 ----------------(E)
#TQC-950032 END----------------------------------------------------------------------------------       
                    " WHERE oea01 = oeb01 ",
                    "   AND oea99 = '",l_oea99,"'",
                    "   AND oeaconf <> 'X' ", #MOD-B10245 add
                    " ORDER BY oea01,oeb03 "
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-980091
        PREPARE q940_pre2 FROM g_sql
        DECLARE q940_cs2 CURSOR FOR q940_pre2
 
        LET g_sql = "SELECT ' ','2',pmm01,pmm09,pmc03,pmm41,pmm20,pmm21,",
                    "       pmm22,pmn02,pmn04,pmn041,pmn20,pmn50,pmm42,",   #pmn31, ", #FUN-680077 add pmm42 匯率   #MOD-B80170 mark pmn31
                    "       CASE gec07 WHEN 'Y' THEN pmn31t WHEN 'N' THEN pmn31 ELSE 0 END CASE, ",  #MOD-B80170 add
                   #"       pmn33,pmn31*pmn20,pmn31t*pmn20,' '",    #MOD-910074 mark
                    "       pmn33,pmn88,pmn88t,' '",                #MOD-910074  #TQC-910035 modify
#TQC-950032 MARK&ADD START--------------------------------------------------                                                        
#                   "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.pmm_file,",                                                          
#                             g_plant_1[l_i].db_name CLIPPED,".dbo.pmn_file,",                                                          
#                   " OUTER ",g_plant_1[l_i].db_name CLIPPED,".dbo.pmc_file ",                                                          
                   #FUN-980091 ----------------(S)
                   #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmm_file,",                                               
                   #          s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmn_file,",                                               
                   #" OUTER ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmc_file ",                                               
                   #------------------------------
                    #"  FROM ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"pmm_file,",
                    #          s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"pmn_file,",
                    #" OUTER ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmc_file ",
                    "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'pmm_file'),",",  #FUN-A50102
                              cl_get_target_table(g_plant_1[l_i].no,'gec_file'),",",  #MOD-B80170
                              cl_get_target_table(g_plant_1[l_i].no,'pmn_file'),",",  #FUN-A50102
                    " OUTER ",cl_get_target_table(g_plant_1[l_i].no,'pmc_file'),      #FUN-A50102
                   #FUN-980091 ----------------(E)
#TQC-950032 END---------------------------------------------------------------   
                    " WHERE pmm01 = pmn01 ",
                    "   AND pmm09 = pmc_file.pmc01 ",
                    "   AND pmm99 = '",l_oea99,"'",
                    "   AND pmm18 <> 'X' ",   #MOD-B10245 add
                    "   AND gec01 = pmm21 ",  #MOD-B80170 add
                    "   AND gec011= '1' ",    #MOD-B80170 add
                    " ORDER BY pmm01,pmn02 "
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-980091
        PREPARE q940_pre3 FROM g_sql
        DECLARE q940_cs3 CURSOR FOR q940_pre3
 
        IF NOT(g_rec_b2 > g_max_rec) THEN
           FOREACH q940_cs2 INTO g_oea_b[g_rec_b2].*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b2_fill foreach1:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
 
              LET g_oea_b[g_rec_b2].azp01_1 = g_plant_1[l_i].no
 
              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
 
        IF NOT(g_rec_b2 > g_max_rec) THEN
           FOREACH q940_cs3 INTO g_oea_b[g_rec_b2].*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b2_fill foreach2:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
 
              LET g_oea_b[g_rec_b2].azp01_1 = g_plant_1[l_i].no
 
              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
    END FOR
    CALL g_oea_b.deleteElement(g_rec_b2)
 
    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q940_b3_fill()
DEFINE l_oga99    LIKE oga_file.oga99
DEFINE l_i        LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    CALL g_oga_b.clear()
    LET g_rec_b3 = 1
    DISPLAY ' ' TO FORMONLY.cn3
 
    DECLARE q940_oga99_cs CURSOR FOR
      SELECT DISTINCT(oga99) FROM oga_file,ogb_file
       WHERE oga01 = ogb01 AND ogb31 = g_oea_a[l_ac].oea01
         AND ogaconf <> 'X'    #MOD-B10245 add
 
    LET l_i = 1
    LET g_oga99_wc = ''
    FOREACH q940_oga99_cs INTO l_oga99
      IF SQLCA.SQLCODE THEN
         CALL cl_err('b3_fill foreach1:',SQLCA.SQLCODE,0)  
         LET g_oga99_wc = ''
         EXIT FOREACH
      END IF
      IF l_i > 1 THEN
         LET g_oga99_wc = g_oga99_wc CLIPPED,","
      END IF
      LET l_i = l_i + 1
      LET g_oga99_wc = g_oga99_wc,"'",l_oga99 CLIPPED,"'"
    END FOREACH
 
    IF NOT cl_null(g_oga99_wc) THEN
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT oga99,' ','3',oga01,oga31,oga32,oga21,oga23,",
                       "       ogb03,ogb04,ogb06,ogb12,ogb13,oga05 ",
#TQC-950032 MARK&ADD START-----------------------------------------------------                                                     
#                      "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.oga_file,",                                                       
#                                g_plant_1[l_i].db_name CLIPPED,".dbo.ogb_file ",                                                       
                      #FUN-980091 ----------------(S)
                      #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oga_file,",                                            
                      #          s_dbstring(g_plant_1[l_i].db_name CLIPPED),"ogb_file ",                                            
                      #------------------------------
                      # "  FROM ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"oga_file,", 
                      #           s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"ogb_file ",
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oga_file'),",",  #FUN-A50102 
                                 cl_get_target_table(g_plant_1[l_i].no,'ogb_file'),      #FUN-A50102
                      #FUN-980091 ----------------(E)
#TQC-950032 END-------------------------------------------------------------------------    
                       " WHERE oga01 = ogb01 ",
                       "   AND oga09 = '4' ",  #(4.三角貿易出貨單)
                       "   AND oga99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND ogaconf <> 'X' ",   #MOD-B10245 add
                       " ORDER BY oga01,ogb03 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-980091
           PREPARE q940_pre4 FROM g_sql
           DECLARE q940_cs4 CURSOR FOR q940_pre4
 
           LET g_sql = "SELECT rva99,' ','1',rva01,pmm41,pmm20,pmm21,pmm22,",
                       "       rvb02,rvb05,pmn041,rvb07,rvb10,' ' ",
#TQC-950032 MARK&ADD START--------------------------------------------------------                                                  
#                      "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.rva_file,",                                                       
#                                g_plant_1[l_i].db_name CLIPPED,".dbo.rvb_file,",                                                       
#                      " OUTER ",g_plant_1[l_i].db_name CLIPPED,".dbo.pmm_file,",                                                       
#                      " OUTER ",g_plant_1[l_i].db_name CLIPPED,".dbo.pmn_file ",                                                       
                      #FUN-980091 ----------------(S)
                      #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rva_file,",                                            
                      #          s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rvb_file,",                                            
                      #" OUTER ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmm_file,",                                            
                      #" OUTER ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmn_file ",                                            
                      #------------------------------
                      # "  FROM ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"rva_file,", 
                      #           s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"rvb_file,",
                      # " OUTER ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"pmm_file,",
                      # " OUTER ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"pmn_file ",
                      "  FROM ", cl_get_target_table(g_plant_1[l_i].no,'rva_file'),",",  #FUN-A50102  
                                 cl_get_target_table(g_plant_1[l_i].no,'rvb_file'),",",  #FUN-A50102 
                       " OUTER ",cl_get_target_table(g_plant_1[l_i].no,'pmm_file'),",",  #FUN-A50102 
                       " OUTER ",cl_get_target_table(g_plant_1[l_i].no,'pmn_file'),      #FUN-A50102 
                      #FUN-980091 ----------------(E)
#TQC-950032 END-----------------------------------------------------------------   
                       " WHERE rva01 = rvb01 ",
                       "   AND rvb04 = pmm_file.pmm01 ",
                       "   AND rvb04 = pmn_file.pmn01 ",
                       "   AND rvb03 = pmn_file.pmn02 ",
                       "   AND rva99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND rvaconf <> 'X' ",   #MOD-B10245 add
                       "   AND pmm18 <> 'X' ",     #MOD-B10245 add
                       " ORDER BY rva01,rvb02 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-980091
           PREPARE q940_pre5 FROM g_sql
           DECLARE q940_cs5 CURSOR FOR q940_pre5
 
           LET g_sql = "SELECT rvu99,' ','2',rvu01,pmm41,pmm20,pmm21,pmm22,",
                       "       rvv02,rvv31,rvv031,rvv17,rvv38,' ' ",
#TQC-950032 MARK&ADD START----------------------------------------------------                                                      
#                      "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.rvu_file,",                                                       
#                                g_plant_1[l_i].db_name CLIPPED,".dbo.rvv_file,",                                                       
#                      " OUTER ",g_plant_1[l_i].db_name CLIPPED,".dbo.pmm_file ",                                                       
                      #FUN-980091 ----------------(S)
                      #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rvu_file,",                                            
                      #          s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rvv_file,",                                            
                      #" OUTER ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"pmm_file ",                                            
                      #------------------------------
                      # "  FROM ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"rvu_file,",
                      #           s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"rvv_file,",
                      # " OUTER ",s_dbstring(g_plant_1[l_i].db_name_tra CLIPPED),"pmm_file ",
                      "  FROM ", cl_get_target_table(g_plant_1[l_i].no,'rvu_file'),",",  #FUN-A50102  
                                 cl_get_target_table(g_plant_1[l_i].no,'rvv_file'),",",  #FUN-A50102 
                       " OUTER ",cl_get_target_table(g_plant_1[l_i].no,'pmm_file'),      #FUN-A50102 
                      #FUN-980091 ----------------(E)
#TQC-950032 END---------------------------------------------------------------------      
                       " WHERE rvu01 = rvv01 ",
                       "   AND rvv36 = pmm_file.pmm01 ",
                       "   AND rvu99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND rvu00 = '1' ",      #異動類別(1.入庫)
                       "   AND rvuconf <> 'X' ",   #MOD-B10245 add
                       "   AND pmm18 <> 'X' ",     #MOD-B10245 add
                       " ORDER BY rvu01,rvv02 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-980091
           PREPARE q940_pre6 FROM g_sql
           DECLARE q940_cs6 CURSOR FOR q940_pre6
 
           IF NOT(g_rec_b3 > g_max_rec) THEN
              FOREACH q940_cs4 INTO g_oga_b[g_rec_b3].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b3_fill foreach2:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oga_b[g_rec_b3].azp01_2 = g_plant_1[l_i].no
 
                 LET g_rec_b3 = g_rec_b3 + 1
                 IF g_rec_b3 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
 
           IF NOT(g_rec_b3 > g_max_rec) THEN
              FOREACH q940_cs5 INTO g_oga_b[g_rec_b3].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b3_fill foreach3:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oga_b[g_rec_b3].azp01_2 = g_plant_1[l_i].no
 
                 LET g_rec_b3 = g_rec_b3 + 1
                 IF g_rec_b3 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
             END FOREACH
           END IF
 
           IF NOT(g_rec_b3 > g_max_rec) THEN
              FOREACH q940_cs6 INTO g_oga_b[g_rec_b3].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b3_fill foreach4:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oga_b[g_rec_b3].azp01_2 = g_plant_1[l_i].no
 
                 LET g_rec_b3 = g_rec_b3 + 1
                 IF g_rec_b3 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
       END FOR
 
       CALL g_oga_b.deleteElement(g_rec_b3)
 
       LET g_rec_b3 = g_rec_b3 - 1
       DISPLAY g_rec_b3 TO FORMONLY.cn3
    ELSE
       LET g_rec_b3 = 0
       DISPLAY g_rec_b3 TO FORMONLY.cn3
    END IF
END FUNCTION

#FUN-C30256---add---START 
FUNCTION q940_b8_fill()
DEFINE l_oga99_1    LIKE oga_file.oga99
DEFINE l_i        LIKE type_file.num5
 
    CALL g_oga1_b.clear()
    LET g_rec_b8 = 1
    DISPLAY ' ' TO FORMONLY.cn8
 
    DECLARE q940_oga99_1_cs CURSOR FOR
      SELECT DISTINCT(oga99) FROM oga_file,ogb_file
       WHERE oga01 = ogb01 AND ogb31 = g_oea_a[l_ac].oea01
         AND ogaconf <> 'X'
 
    LET l_i = 1
    LET g_oga99_1_wc = ''
    FOREACH q940_oga99_1_cs INTO l_oga99_1
      IF SQLCA.SQLCODE THEN
         CALL cl_err('b8_fill foreach1:',SQLCA.SQLCODE,0)  
         LET g_oga99_1_wc = ''
         EXIT FOREACH
      END IF
      IF l_i > 1 THEN
         LET g_oga99_1_wc = g_oga99_1_wc CLIPPED,","
      END IF
      LET l_i = l_i + 1
      LET g_oga99_1_wc = g_oga99_1_wc,"'",l_oga99_1 CLIPPED,"'"
    END FOREACH
 
    IF NOT cl_null(g_oga99_1_wc) THEN
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT oga99,' ','1',oga01,oga31,oga32,oga21,oga23,",
                       "       ogb03,ogb04,ogb06,ogb12,ogb13,oga05 ",
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oga_file'),",",
                                 cl_get_target_table(g_plant_1[l_i].no,'ogb_file'),
                       " WHERE oga01 = ogb01 ",
                       "   AND oga09 = '5' ",  #(5.三角貿易出貨通知單)
                       "   AND oga99 IN (",g_oga99_1_wc CLIPPED,")",
                       "   AND ogaconf <> 'X' ",
                       " ORDER BY oga01,ogb03 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql
           PREPARE q940_pre88 FROM g_sql
           DECLARE q940_cs88 CURSOR FOR q940_pre88
 
           IF NOT(g_rec_b8 > g_max_rec) THEN
              FOREACH q940_cs88 INTO g_oga1_b[g_rec_b8].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b8_fill foreach2:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oga1_b[g_rec_b8].azp01_7 = g_plant_1[l_i].no
 
                 LET g_rec_b8 = g_rec_b8 + 1
                 IF g_rec_b8 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
       END FOR
 
       CALL g_oga1_b.deleteElement(g_rec_b8)
 
       LET g_rec_b8 = g_rec_b8 - 1
       DISPLAY g_rec_b8 TO FORMONLY.cn8
    ELSE
       LET g_rec_b8 = 0
       DISPLAY g_rec_b8 TO FORMONLY.cn8
    END IF
END FUNCTION
#FUN-C30256---add-----END 

FUNCTION q940_b4_fill()
DEFINE  l_i  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_oha99    LIKE oga_file.oga99    #FUN-CC0090 add
DEFINE  l_oha99_wc STRING                 #FUN-CC0090 add
 
    CALL g_oma_b.clear()
    LET g_rec_b4 = 1
    DISPLAY ' ' TO FORMONLY.cn4
    #FUN-CC0090 -- add start #撈取銷退產生的多角流程代碼--
    DECLARE q940_oha99_b4_cs CURSOR FOR
      SELECT DISTINCT(oha99) FROM oha_file,ohb_file
       WHERE oha01 = ohb01 AND ohb33 = g_oea_a[l_ac].oea01
         AND ohaconf <> 'X'
    LET l_i = 1
    LET l_oha99_wc = ''
    FOREACH q940_oha99_b4_cs INTO l_oha99
       IF SQLCA.SQLCODE THEN
         CALL cl_err('b4_fill foreach1:',SQLCA.SQLCODE,0)
         LET l_oha99_wc = ''
         EXIT FOREACH
      END IF
      IF l_i > 1 THEN
         LET l_oha99_wc = l_oha99_wc CLIPPED,","
      END IF
      LET l_i = l_i + 1
      LET l_oha99_wc = l_oha99_wc,"'",l_oha99 CLIPPED,"'"
    END FOREACH
    #FUN-CC0090 -- add end --
 
    IF NOT cl_null(g_oga99_wc) THEN
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT oma99,' ','1',oma01,oma03,oma032,oma32,oma21,",
                       "       oma23,oma24,oma54t,oma56t ",
                      #"  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.oma_file ",            #TQC-950032 MARK                           
                       #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oma_file ", #TQC-950032 ADD 
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oma_file'),      #FUN-A50102 
                       " WHERE oma00 = '12' ",
                       "   AND oma99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND omavoid <> 'Y' ",   #MOD-B10245 add
                       " ORDER BY oma01 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-A50102
           PREPARE q940_pre7 FROM g_sql
           DECLARE q940_cs7 CURSOR FOR q940_pre7
 
           #FUN-CC0090 -- add start --
           LET g_sql = "SELECT oma99,' ','1',oma01,oma03,oma032,oma32,oma21,",
                       "       oma23,oma24,oma54t,oma56t ",
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oma_file'),
                       " WHERE oma00 = '21' ",
                       "   AND oma99 IN (",l_oha99_wc CLIPPED,")",
                       "   AND omavoid <> 'Y' ",
                       " ORDER BY oma01 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql
           PREPARE q940_pre71 FROM g_sql
           DECLARE q940_cs71 CURSOR FOR q940_pre71
           #FUN-CC0090 -- add end --

           LET g_sql = "SELECT apa99,' ','2',apa01,apa06,apa07,apa11,apa15,",
                       "       apa13,apa14,apa34f,apa34 ",
                      #"  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.apa_file ",            #TQC-950032 MARK                           
                       #"  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"apa_file ", #TQC-950032 ADD 
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'apa_file'),      #FUN-A50102 
                       " WHERE apa00 = '11' ",
                       "   AND apa99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND apa42 <> 'Y' ",   #MOD-B10245 add
                       " ORDER BY apa01 "
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql #FUN-A50102
           PREPARE q940_pre8 FROM g_sql
           DECLARE q940_cs8 CURSOR FOR q940_pre8
 
           #FUN-CC0090 -- add start --
           LET g_sql = "SELECT apa99,' ','2',apa01,apa06,apa07,apa11,apa15,",
                       "       apa13,apa14,apa34f,apa34 ",
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'apa_file'),
                       " WHERE apa00 = '21' ",
                       "   AND apa99 IN (",l_oha99_wc CLIPPED,")",
                       "   AND apa42 <> 'Y' ",   #MOD-B10245 add
                       " ORDER BY apa01 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant_1[l_i].no) RETURNING g_sql
           PREPARE q940_pre81 FROM g_sql
           DECLARE q940_cs81 CURSOR FOR q940_pre81
           #FUN-CC0090 -- add end --

           IF NOT(g_rec_b4 > g_max_rec) THEN
              FOREACH q940_cs7 INTO g_oma_b[g_rec_b4].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b4_fill foreach1:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oma_b[g_rec_b4].azp01_3 = g_plant_1[l_i].no
 
                 LET g_rec_b4 = g_rec_b4 + 1
                 IF g_rec_b4 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
 
           #FUN-CC0090 -- add start --
           IF NOT(g_rec_b4 > g_max_rec) THEN
              FOREACH q940_cs71 INTO g_oma_b[g_rec_b4].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b4_fill foreach11:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF

                 LET g_oma_b[g_rec_b4].azp01_3 = g_plant_1[l_i].no

                 LET g_rec_b4 = g_rec_b4 + 1
                 IF g_rec_b4 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
           #FUN-CC0090 -- add end --

           IF NOT(g_rec_b4 > g_max_rec) THEN
              FOREACH q940_cs8 INTO g_oma_b[g_rec_b4].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b4_fill foreach2:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
 
                 LET g_oma_b[g_rec_b4].azp01_3 = g_plant_1[l_i].no
 
                 LET g_rec_b4 = g_rec_b4 + 1
                 IF g_rec_b4 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
             END FOREACH
           END IF

           #FUN-CC0090 -- add start --
           IF NOT(g_rec_b4 > g_max_rec) THEN
              FOREACH q940_cs81 INTO g_oma_b[g_rec_b4].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b4_fill foreach21:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF

                 LET g_oma_b[g_rec_b4].azp01_3 = g_plant_1[l_i].no

                 LET g_rec_b4 = g_rec_b4 + 1
                 IF g_rec_b4 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
             END FOREACH
           END IF
           ##FUN-CC0090 -- add end --
       END FOR
 
       CALL g_oma_b.deleteElement(g_rec_b4)
 
       LET g_rec_b4 = g_rec_b4 - 1
       DISPLAY g_rec_b4 TO FORMONLY.cn4
    ELSE
       LET g_rec_b4 = 0
       DISPLAY g_rec_b4 TO FORMONLY.cn4
    END IF
END FUNCTION

#--NO.FUN-B30101--add---begin
FUNCTION q940_b5_fill()
DEFINE  l_i  LIKE type_file.num5          #No.FUN-680137 SMALLINT
#MOD-B80181--add--str--
DEFINE  l_oha99     LIKE oha_file.oha99
DEFINE  l_oha99_wc  STRING
#MOD-B80181--add--end--

    CALL g_ohb_b.clear()
    LET g_rec_b5=1
    DISPLAY ' ' TO FORMONLY.cn5

    #MOD-B80181--add--str--
    DECLARE q940_oha99_cs CURSOR FOR
     SELECT DISTINCT(oha99) FROM oha_file,ohb_file
      WHERE oha01 = ohb01 AND ohb33 = g_oea_a[l_ac].oea01
        AND ohaconf <> 'X'

    LET l_i = 1
    LET l_oha99_wc = ''
    FOREACH q940_oha99_cs INTO l_oha99
      IF SQLCA.SQLCODE THEN
         CALL cl_err('b5_fill foreach1:',SQLCA.SQLCODE,0)
         LET l_oha99_wc = ''
         EXIT FOREACH
      END IF
      IF l_i > 1 THEN
         LET l_oha99_wc = l_oha99_wc CLIPPED,","
      END IF
      LET l_i = l_i + 1
      LET l_oha99_wc = l_oha99_wc,"'",l_oha99 CLIPPED,"'"
    END FOREACH
    #MOD-B80181--add--end--

    #IF NOT cl_null(g_oga99_wc) THEN
    IF NOT cl_null(l_oha99_wc) THEN  #MOD-B8018
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT oha99,'','1',oha01,ohb03,ohb50,ohb04,ohb06,'',",
                       "       ohb09,ohb091,ohb092,ohb05,ohb12 ",
                       "  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oha_file, ",
                                 s_dbstring(g_plant_1[l_i].db_name CLIPPED),"ohb_file ",
                       " WHERE oha01=ohb01 ",
                       #"   AND oha99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND oha99 IN (",l_oha99_wc CLIPPED,")",    #MOD-B80181
                       "   AND ohaconf <> 'X' ",
                       " ORDER BY ohb03 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
           PREPARE q940_pre9 FROM g_sql
           DECLARE q940_cs9 CURSOR FOR q940_pre9

           LET g_sql= " SELECT rvu99,'','2',rvu01,rvv02,rvv26,rvv31,rvv031,'',",
                      "        rvv32,rvv33,rvv34,rvv35,rvv17 ",
                      "  FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rvu_file, ",
                                s_dbstring(g_plant_1[l_i].db_name CLIPPED),"rvv_file ",
                      " WHERE rvu01=rvv01",
                      #"   AND rvu99 IN (",g_oga99_wc CLIPPED,")",
                      "   AND rvu99 IN (",l_oha99_wc CLIPPED,")",   #MOD-B80181
                      "   AND rvu00 = '3' ",
                      "   AND rvuconf <> 'X' ",
                      " ORDER BY rvv02 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
           PREPARE q940_pre92 FROM g_sql
           DECLARE q940_cs92 CURSOR FOR q940_pre92
           
           IF NOT(g_rec_b5 > g_max_rec) THEN
              FOREACH q940_cs9 INTO g_ohb_b[g_rec_b5].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b5_fill foreach1:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF

                 LET g_ohb_b[g_rec_b5].azp01_4 = g_plant_1[l_i].no
                 SELECT ima021 INTO g_ohb_b[g_rec_b5].ima021 FROM ima_file
                      WHERE ima01=g_ohb_b[g_rec_b5].ohb04

                 LET g_rec_b5 = g_rec_b5+1
                 IF g_rec_b5> g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
 
           IF NOT(g_rec_b5 > g_max_rec) THEN
              FOREACH q940_cs92 INTO g_ohb_b[g_rec_b5].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b5_fill foreach1:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF

                 LET g_ohb_b[g_rec_b5].azp01_4 = g_plant_1[l_i].no

                 SELECT ima021 INTO g_ohb_b[g_rec_b5].ima021 FROM ima_file
                      WHERE ima01=g_ohb_b[g_rec_b5].ohb04

                 LET g_rec_b5 = g_rec_b5+1
                 IF g_rec_b5> g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF

       END FOR

       CALL g_ohb_b.deleteElement(g_rec_b5)

       LET g_rec_b5 = g_rec_b5 - 1
       DISPLAY g_rec_b5 TO FORMONLY.cn5
    ELSE
       LET g_rec_b5 = 0
       DISPLAY g_rec_b5 TO FORMONLY.cn5
    END IF
END FUNCTION

FUNCTION q940_b6_fill()
DEFINE  l_i  LIKE type_file.num5          #No.FUN-680137 SMALLINT

    CALL g_ogd_b.clear()
    LET g_rec_b6 = 1
    DISPLAY ' ' TO FORMONLY.cn6

    IF NOT cl_null(g_oga99_wc) THEN
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT oga99,'',oga01,ogd03,'',ogd04,ogd08,ogd09,ogd10,ogd11,",
                       "       ogd12b,ogd12e,ogd13,ogd14,ogd14t,ogd15,ogd15t,ogd16,ogd16t",
                       " FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"oga_file,",
                                s_dbstring(g_plant_1[l_i].db_name CLIPPED),"ogd_file",
                       " WHERE oga01=ogd01",
                       "   AND oga99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND ogaconf <> 'X' ",
                       " ORDER BY ogd03 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
           PREPARE q940_pre10 FROM g_sql
           DECLARE q940_cs10 CURSOR FOR q940_pre10

           IF NOT(g_rec_b6 > g_max_rec) THEN
              FOREACH q940_cs10 INTO g_ogd_b[g_rec_b6].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b6_fill foreach1:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF

                 SELECT ogb04 INTO g_ogd_b[g_rec_b6].ogb04_2 FROM ogb_file
                      WHERE ogb01= g_ogd_b[g_rec_b6].oga01_2

                 LET g_ogd_b[g_rec_b6].azp01_5 = g_plant_1[l_i].no

                 LET g_rec_b6 = g_rec_b6 + 1
                 IF g_rec_b6 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
       END FOR

       CALL g_ogd_b.deleteElement(g_rec_b6)

       LET g_rec_b6 = g_rec_b6 - 1
       DISPLAY g_rec_b6 TO FORMONLY.cn6
    ELSE
       LET g_rec_b6 = 0
       DISPLAY g_rec_b6 TO FORMONLY.cn6
    END IF
END FUNCTION

FUNCTION q940_b7_fill()
DEFINE  l_i  LIKE type_file.num5          #No.FUN-680137 SMALLINT

    CALL g_ofb_b.clear()
    LET g_rec_b7 = 1
    DISPLAY ' ' TO FORMONLY.cn7

    IF NOT cl_null(g_oga99_wc) THEN
       FOR l_i = 1 TO g_rec_plant
           LET g_sql = "SELECT ofa99,'',ofa01,ofb03,ofb04,ofb06,'',ofb05,ofb12,ofb13,",
                       "       ofb14,ofb14t,ofb11,ofb33 ",
                       " FROM ",s_dbstring(g_plant_1[l_i].db_name CLIPPED),"ofa_file,",
                                s_dbstring(g_plant_1[l_i].db_name CLIPPED),"ofb_file",
                       " WHERE ofa01=ofb01",
                       "   AND ofa99 IN (",g_oga99_wc CLIPPED,")",
                       "   AND ofaconf <> 'X' ",
                       " ORDER BY ofb03 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
           PREPARE q940_pre11 FROM g_sql
           DECLARE q940_cs11 CURSOR FOR q940_pre11

           IF NOT(g_rec_b7 > g_max_rec) THEN
              FOREACH q940_cs11 INTO g_ofb_b[g_rec_b7].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err('b7_fill foreach1:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 SELECT ima021 INTO g_ofb_b[g_rec_b7].ima021_2 FROM ima_file
                      WHERE ima01= g_ofb_b[g_rec_b7].ofb04

                 LET g_ofb_b[g_rec_b7].azp01_6 = g_plant_1[l_i].no

                 LET g_rec_b7 = g_rec_b7 + 1
                 IF g_rec_b7 > g_max_rec THEN
                    CALL cl_err('',9035,0)
                    EXIT FOREACH
                 END IF
              END FOREACH
           END IF
       END FOR

       CALL g_ofb_b.deleteElement(g_rec_b7)

       LET g_rec_b7 = g_rec_b7 - 1
       DISPLAY g_rec_b7 TO FORMONLY.cn7
    ELSE
       LET g_rec_b7 = 0
       DISPLAY g_rec_b7 TO FORMONLY.cn7
    END IF
END FUNCTION
#--NO.FUN-B30101--END
 
FUNCTION q940_bp()
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  # IF g_up <> "G" THEN
  #FUN-C10021---mark---START
  #IF g_up = "V" THEN
  #   RETURN
  #END IF
  #FUN-C10021---mark---END 
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_oea_a TO s_oea_a.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)#FUN-C10021
   DIALOG ATTRIBUTES(UNBUFFERED) #FUN-C10021 add
      DISPLAY ARRAY g_oea_a TO s_oea_a.* ATTRIBUTE(COUNT=g_rec_b1) #FUN-C10021 add
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         IF q940_plant() THEN
            CALL q940_b2_fill()
            CALL q940_b3_fill()
            CALL q940_b8_fill()  #FUN-C30256 adD
            CALL q940_b4_fill()
         #--NO.FUN-B30101--ADD--
            CALL q940_b5_fill()
            CALL q940_b6_fill()
            CALL q940_b7_fill()
         #--NO.FUN-B30101--END--
         ELSE
            CALL g_oea_b.clear()
            CALL g_oga_b.clear()
            CALL g_oma_b.clear()
         #--NO.FUN-B30101--ADD--
            CALL g_ohb_b.clear()
            CALL g_ogd_b.clear()
            CALL g_ofb_b.clear()
         #--NO.FUN-B30101--END--
            DISPLAY 0 TO FORMONLY.cn2
            DISPLAY 0 TO FORMONLY.cn3
            DISPLAY 0 TO FORMONLY.cn4
         #--NO.FUN-B30101--ADD--
            DISPLAY 0 TO FORMONLY.cn5
            DISPLAY 0 TO FORMONLY.cn6
            DISPLAY 0 TO FORMONLY.cn7
         #--NO.FUN-B30101--END--
         END IF
          #FUN-C10021---mark---START
          #CALL q940_bp2_refresh()
          #CALL q940_bp3_refresh()
          #CALL q940_bp4_refresh()
          ##--NO.FUN-B30101--ADD--
          #CALL q940_bp5_refresh()
          #CALL q940_bp6_refresh()
          #CALL q940_bp7_refresh()
          ##--NO.FUN-B30101--END--
          #FUN-C10021---mark---END

#FUN-C10021---add---START  
      END DISPLAY
      DISPLAY ARRAY g_oea_b TO s_oea_b.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE ROW
      END DISPLAY  
      DISPLAY ARRAY g_oga_b TO s_oga_b.* ATTRIBUTE(COUNT=g_rec_b3)
      #FUN-B90012--add--Begin--
      BEFORE DISPLAY
         IF NOT s_industry("icd") THEN  
            CALL cl_set_act_visible("aic_s_icdqry",FALSE)
         END IF  
      #FUN-B90012--add---End--
      
      BEFORE ROW
         LET l_ac1 = ARR_CURR()  #FUN-B90012--add--

      #FUN-B90012--add--Begin--
      ON ACTION aic_s_icdqry
         LET g_action_choice="aic_s_icdqry"
         IF cl_chk_act_auth() THEN
            CALL q940_s_icdqry()
         END IF
         LET g_action_choice=" "
      #FUN-B90012--add---End---
      END DISPLAY
#FUN-C30256---add---START 
      DISPLAY ARRAY g_oga1_b TO s_oga1_b.* ATTRIBUTE(COUNT=g_rec_b8)
        BEFORE ROW
      END DISPLAY
#FUN-C30256---add-----END
      DISPLAY ARRAY g_oma_b TO s_oma_b.* ATTRIBUTE(COUNT=g_rec_b4)
        BEFORE ROW
      END DISPLAY
      DISPLAY ARRAY g_ohb_b TO s_ohb_b.* ATTRIBUTE(COUNT=g_rec_b5)
        BEFORE ROW
      END DISPLAY
      DISPLAY ARRAY g_ogd_b TO s_ogd_b.* ATTRIBUTE(COUNT=g_rec_b6)
        BEFORE ROW
      END DISPLAY
      DISPLAY ARRAY g_ofb_b TO s_ofb_b.* ATTRIBUTE(COUNT=g_rec_b7)
        BEFORE ROW      
      END DISPLAY
#FUN-C10021---add---END          
      ON ACTION query
         LET g_action_choice="query"
           #EXIT DISPLAY #FUN-C10021 mark
           EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION help
         LET g_action_choice="help"
           #EXIT DISPLAY #FUN-C10021 mark
           EXIT DIALOG   #FUN-C10021 add 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
           #EXIT DISPLAY #FUN-C10021 mark
           EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION controlg
         LET g_action_choice="controlg"
           #EXIT DISPLAY #FUN-C10021 mark
           EXIT DIALOG   #FUN-C10021 add 
 
      ON ACTION cancel
         LET g_action_choice="exit"
           #EXIT DISPLAY #FUN-C10021 mark
           EXIT DIALOG   #FUN-C10021 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
           #CONTINUE DISPLAY #FUN-C10021 mark
           CONTINUE DIALOG   #FUN-C10021 add
 
      ON ACTION about
         CALL cl_about()

     #FUN-D10119---add---S
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 
     #FUN-D10119---add---E
 
      #FUN-C10021---mark---START
      # ON ACTION view1
      #    LET g_action_choice = "view1"
      #    EXIT DISPLAY
      
      # ON ACTION view2
      #    LET g_action_choice = "view2"
      #    EXIT DISPLAY
      
      # ON ACTION view3
      #    LET g_action_choice = "view3"
      #    EXIT DISPLAY
      
      ##--NO.FUN-B30101--ADD
      # ON ACTION view4
      #    LET g_action_choice = "view4"
      #    EXIT DISPLAY
      
      # ON ACTION view5
      #    LET g_action_choice = "view5"
      #    EXIT DISPLAY
      
      # ON ACTION view6
      #    LET g_action_choice = "view6"
      #    EXIT DISPLAY
      ##--NO.FUN-B30101--END 
      #FUN-C10021---mark---END
  #END DISPLAY #FUN-C10021 mark
  END DIALOG #FUN-C10021 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C10021---mark---START 
#FUNCTION q940_bp2_refresh()
#  DISPLAY ARRAY g_oea_b TO s_oea_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION help
#        CALL cl_show_help()
#
#     ON ACTION controlg
#        CALL cl_cmdask()
#
#  END DISPLAY
#END FUNCTION
#
#FUNCTION q940_bp3_refresh()
#  DISPLAY ARRAY g_oga_b TO s_oga_b.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION help
#        CALL cl_show_help()
#
#     ON ACTION controlg
#        CALL cl_cmdask()
#
#  END DISPLAY
#END FUNCTION
#
#FUNCTION q940_bp4_refresh()
#  DISPLAY ARRAY g_oma_b TO s_oma_b.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION help
#        CALL cl_show_help()
#
#     ON ACTION controlg
#        CALL cl_cmdask()
#
#  END DISPLAY
#END FUNCTION

##--NO.FUN-B30101--ADD--
#FUNCTION q940_bp5_refresh()
#  DISPLAY ARRAY g_ohb_b TO s_ohb_b.* ATTRIBUTE(COUNT=g_rec_b5,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     ON ACTION help
#        CALL cl_show_help()

#     ON ACTION controlg
#        CALL cl_cmdask()

#  END DISPLAY
#END FUNCTION

#FUNCTION q940_bp6_refresh()
#  DISPLAY ARRAY g_ogd_b TO s_ogd_b.* ATTRIBUTE(COUNT=g_rec_b6,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     ON ACTION help
#        CALL cl_show_help()

#     ON ACTION controlg
#        CALL cl_cmdask()

#  END DISPLAY
#END FUNCTION

#FUNCTION q940_bp7_refresh()
#  DISPLAY ARRAY g_ofb_b TO s_ofb_b.* ATTRIBUTE(COUNT=g_rec_b7,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     ON ACTION help
#        CALL cl_show_help()

#     ON ACTION controlg
#        CALL cl_cmdask()

#  END DISPLAY
#END FUNCTION
##--NO.FUN-B30101--END-- 

#FUNCTION q940_bp2()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_oea_b TO s_oea_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#
#     BEFORE ROW
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY
#
#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY
#
#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY
#
# #--NO.FUN-B30101--ADD----
#     #瀏覽單身頁簽四：銷退
#     ON ACTION view4
#        LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY

#     #瀏覽單身頁簽五：Packing
#     ON ACTION view5
#        LET g_up = "V"
#        LET g_action_choice="view5"
#        EXIT DISPLAY

#     #瀏覽單身頁簽六：Invoice
#     ON ACTION view6
#        LET g_up = "V"
#        LET g_action_choice="view6"
#        EXIT DISPLAY
# #--NO.FUN-B30101--END--
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION q940_bp3()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
#
#  LET g_action_choice = " "
#  LET l_ac1 = 1                   #FUN-B90012--add--

#  CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_oga_b TO s_oga_b.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)

#     #FUN-B90012--add--Begin--
#     BEFORE DISPLAY
#        IF NOT s_industry("icd") THEN  
#           CALL cl_set_act_visible("aic_s_icdqry",FALSE)
#        END IF  
#     #FUN-B90012--add---End--
#     
#     BEFORE ROW
#        LET l_ac1 = ARR_CURR()  #FUN-B90012--add--
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY
#
#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY
#
# #--NO.FUN-B30101--ADD---
#     #瀏覽單身頁簽四：銷退
#     ON ACTION view4
#        LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY

#     #瀏覽單身頁簽五：Packing
#     ON ACTION view5
#        LET g_up = "V"
#        LET g_action_choice="view5"
#        EXIT DISPLAY

#     #瀏覽單身頁簽六：Invoice
#     ON ACTION view6
#        LET g_up = "V"
#        LET g_action_choice="view6"
#        EXIT DISPLAY
# #--NO.FUN-B30101--END--

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#     #FUN-B90012--add--Begin--
#     ON ACTION aic_s_icdqry
#        LET g_action_choice="aic_s_icdqry"
#        IF cl_chk_act_auth() THEN
#           CALL q940_s_icdqry()
#        END IF
#        LET g_action_choice=" "
#     #FUN-B90012--add---End---
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION q940_bp4()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#     DISPLAY ARRAY g_oma_b TO s_oma_b.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
#
#     BEFORE ROW
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY
#
#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY
#
# #--NO.FUN-B30101--ADD---
#     #瀏覽單身頁簽四：銷退
#     ON ACTION view4
#        LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY

#     #瀏覽單身頁簽五：Packing
#     ON ACTION view5
#        LET g_up = "V"
#        LET g_action_choice="view5"
#        EXIT DISPLAY

#     #瀏覽單身頁簽六：Invoice
#     ON ACTION view6
#        LET g_up = "V"
#        LET g_action_choice="view6"
#        EXIT DISPLAY
# #--NO.FUN-B30101--END--

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION

##--NO.FUN-B30101--ADD---
#FUNCTION q940_bp5()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 CHAR(1)

#  LET g_action_choice = " "

#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_ohb_b TO s_ohb_b.* ATTRIBUTE(COUNT=g_rec_b5,UNBUFFERED)

#     BEFORE ROW

#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY

#     ON ACTION locale
#        CALL cl_dynamic_locale()

#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY

#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY

#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY

#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY

#     #瀏覽單身頁簽五：Packing
#     ON ACTION view5
#        LET g_up = "V"
#        LET g_action_choice="view5"
#        EXIT DISPLAY

#     #瀏覽單身頁簽六：Invoice
#     ON ACTION view6
#        LET g_up = "V"
#        LET g_action_choice="view6"
#        EXIT DISPLAY

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION

#FUNCTION q940_bp6()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 CHAR(1)

#  LET g_action_choice = " "

#  CALL cl_set_act_visible("accept,cancel", FALSE)
#     DISPLAY ARRAY g_ogd_b TO s_ogd_b.* ATTRIBUTE(COUNT=g_rec_b6,UNBUFFERED)

#     BEFORE ROW

#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY

#     ON ACTION locale
#        CALL cl_dynamic_locale()

#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY

#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY

#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY

#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY

#     #瀏覽單身頁簽四：銷退
#     ON ACTION view4
#        LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY

#     #瀏覽單身頁簽六：Invoice
#     ON ACTION view6
#        LET g_up = "V"
#        LET g_action_choice="view6"
#        EXIT DISPLAY

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION

#FUNCTION q940_bp7()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 CHAR(1)

#  LET g_action_choice = " "

#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_ofb_b TO s_ofb_b.* ATTRIBUTE(COUNT=g_rec_b7,UNBUFFERED)

#     BEFORE ROW

#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY

#     ON ACTION locale
#        CALL cl_dynamic_locale()

#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY

#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY
#                                             
#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY

#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY

#     #瀏覽單身頁簽四：銷退
#     ON ACTION view4
#        LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY

#     #瀏覽單身頁簽五：Packing
#     ON ACTION view5
#        LET g_up = "V"
#        LET g_action_choice="view5"
#        EXIT DISPLAY

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
##--NO.FUN-B30101--END-- 
#FUN-C10021---mark---END

#FUN-B90012--add--Begin---
FUNCTION q940_s_icdqry()
DEFINE l_oga09    LIKE  oga_file.oga09,
       l_ogaconf  LIKE  oga_file.ogaconf,
       l_ogapost  LIKE  oga_file.ogapost,
       l_rvaconf  LIKE  rva_file.rvaconf,
       l_rvuconf  LIKE  rvu_file.rvuconf,
       l_plant_new LIKE type_file.chr20

   IF cl_null(g_oga_b[l_ac1].oga01) THEN RETURN END IF 

   LET l_oga09 = ' '
   LET l_ogaconf = ' '
   LET l_ogapost = ' '
   LET l_rvaconf = ' '
   LET l_rvuconf = ' '
   IF NOT cl_null(g_oga_b[l_ac1].azp01_2) THEN
      LET l_plant_new = g_oga_b[l_ac1].azp01_2
   ELSE
      LET l_plant_new = g_plant
   END IF
     
   CASE g_oga_b[l_ac1].kind_2
      WHEN '1' 
         LET g_sql = "SELECT DISTINCT rvaconf FROM ",cl_get_target_table(l_plant_new,'rva_file'),
                     " WHERE rva01 = '",g_oga_b[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_rvaconf FROM g_sql
         EXECUTE q940_rvaconf INTO l_rvaconf

         CALL s_icdqry_plant(l_plant_new)
         CALL s_icdqry(0,g_oga_b[l_ac1].oga01,'',l_rvaconf,'') 
         CALL s_icdqry_plant("")
         
      WHEN '2'
         LET g_sql = "SELECT DISTINCT rvuconf FROM ",cl_get_target_table(l_plant_new,'rvu_file'),
                     " WHERE rvu01 = '",g_oga_b[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_rvuconf FROM g_sql
         EXECUTE q940_rvuconf INTO l_rvuconf

         CALL s_icdqry_plant(l_plant_new)
         CALL s_icdqry(1,g_oga_b[l_ac1].oga01,'',l_rvuconf,'')
         CALL s_icdqry_plant("")
         
      WHEN '3' 
         LET g_sql = "SELECT DISTINCT oga09,ogaconf,ogapost FROM ",cl_get_target_table(l_plant_new,'oga_file'),
                     " WHERE oga01 = '",g_oga_b[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_oga_1 FROM g_sql
         EXECUTE q940_oga_1 INTO l_oga09,l_ogaconf,l_ogapost
      
         IF NOT cl_null(g_oga_b[l_ac1].ogb03) THEN
            IF l_oga09 MATCHES '[15]' THEN
               CALL s_icdqry_plant(l_plant_new)
               CALL s_icdqry(2,g_oga_b[l_ac1].oga01,g_oga_b[l_ac1].ogb03,l_ogaconf,g_oga_b[l_ac1].ogb04)
            ELSE
               CALL s_icdqry_plant(l_plant_new)
               CALL s_icdqry(2,g_oga_b[l_ac1].oga01,g_oga_b[l_ac1].ogb03,l_ogapost,g_oga_b[l_ac1].ogb04)
            END IF
            CALL s_icdqry_plant("")
         END IF
   END CASE 
END FUNCTION 
#FUN-B90012--add---End----
