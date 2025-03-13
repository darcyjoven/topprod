# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almt310.4gl
# Descriptions...: 正式商戶變更作業 
# Date & Author..: NO.FUN-870010 08/08/01 By lilingyu 
# Modify.........: No.FUN-960134 09/07/15 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30099 10/03/15 By Smapmin SQL語法加上SQLCA.sqlcode的判斷
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷 
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A60064 10/06/28 By shiwuying update_i300()中加 Transaction
# Modify.........: No:FUN-A70063 10/07/13 By chenying azf02 = '3' 抓取品牌代碼改抓 tqa_file.tqa03='2';
#                                                     欄位azf01 改抓tqa01, 欄位azf03 改抓tqa02 
# Modify.........: No:FUN-A70063 10/07/14 By chenying q_azfp1替換成q_tqap1,q_lue08替換成q_lue08_1
# Modify.........: No:FUN-A80073 10/08/19 By wangxin 新增所屬營運中心、商戶客戶類別、商戶客戶性質、
#                                                    商戶收款客戶、慣用語言欄位
#                                                    確認時需一併將新增的欄位寫入客戶基本資料檔(occ_file)中
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-AA0078 10/10/26 By wangxin 程式修正
# Modify.........: NO:FUN-AB0096 10/11/24 By wangxin 將程式中,luhplant 改成 luhstore
# Modify.........: NO:TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90056 11/09/13 By baogc 招商歐亞達回收，部份邏輯的新增與修改
# Modify.........: No.FUN-B90121 12/01/13 By baogc 修改BUG


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C40030 12/04/11 by pauline 拿掉主品牌重複控管，僅提示重複，可以繼續輸入 控卡與almi300一致
# Modify.........: No:TQC-C40051 12/04/13 by pauline "產地" 欄位的開窗及欄位檢查,改成使用axmi365 oqw_file 的資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80021 12/08/07 By Lori alm-1252 此訊息代碼長度過長, 導致取得的訊息為 'alm-125'修正成alm1252
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C80089 12/09/17 By jt_chen 新增、修改時改CALL q_nmt(anmi080全國銀行檔)
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:MOD-D30126 13/03/14 By Sakura 加上統一編號(lue56)欄位,變更發出後一併回寫almi300(lne55),axmi221(occ11)統一編號欄位
# Modify.........: No:CHI-D20015 13/03/26 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_lue       RECORD    LIKE lue_file.*,  
         g_lue_t     RECORD    LIKE lue_file.*,					
         g_lue_o     RECORD    LIKE lue_file.*,    
         g_lue01_t             LIKE lue_file.lue01,
         g_lue02_t             LIKE lue_file.lue02
                      
DEFINE g_wc                    STRING 
DEFINE g_wc1                   STRING   #FUN-B90056 ADD
DEFINE g_wc2                   STRING   #FUN-B90056 ADD
DEFINE g_wc3                   STRING   #FUN-B90056 ADD
DEFINE g_sql                   STRING                 
DEFINE g_forupd_sql            STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done     LIKE type_file.num5   
DEFINE g_chr                   LIKE type_file.chr1 
DEFINE g_cnt                   LIKE type_file.num10
DEFINE g_i                     LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                   LIKE type_file.chr1000
DEFINE g_curs_index            LIKE type_file.num10
DEFINE g_row_count             LIKE type_file.num10 
DEFINE g_jump                  LIKE type_file.num10             
DEFINE g_no_ask                LIKE type_file.num5 
DEFINE g_void                  LIKE type_file.chr1
DEFINE g_confirm               LIKE type_file.chr1
DEFINE g_lue01                 LIKE lue_file.lue01
DEFINE g_gg                    LIKE type_file.num5
DEFINE g_date                  LIKE lue_file.luedate
DEFINE g_modu                  LIKE lue_file.luemodu
DEFINE g_flag2                 LIKE type_file.chr1      #FUN-A80073 ---ADD---
#FUN-B90056 Add Begin ---
DEFINE g_lue03                 LIKE lue_file.lue03
DEFINE l_ac1                   LIKE type_file.num5
DEFINE l_ac2                   LIKE type_file.num5
DEFINE l_ac3                   LIKE type_file.num5
DEFINE g_rec_b1                LIKE type_file.num5
DEFINE g_rec_b2                LIKE type_file.num5
DEFINE g_rec_b3                LIKE type_file.num5
DEFINE g_flag_b                LIKE type_file.chr1
DEFINE g_lug                   DYNAMIC ARRAY OF RECORD
                      lug03    LIKE lug_file.lug03,
                      tqa02_3  LIKE tqa_file.tqa02,
                      lug04    LIKE lug_file.lug04,
                      lug05    LIKE lug_file.lug05,
                      lug06    LIKE lug_file.lug06,
                      lug07    LIKE lug_file.lug07
                               END RECORD
DEFINE g_lug_t                 RECORD
                      lug03    LIKE lug_file.lug03,
                      tqa02_3  LIKE tqa_file.tqa02,
                      lug04    LIKE lug_file.lug04,
                      lug05    LIKE lug_file.lug05,
                      lug06    LIKE lug_file.lug06,
                      lug07    LIKE lug_file.lug07
                               END RECORD
DEFINE g_luf                   DYNAMIC ARRAY OF RECORD
                      luf03    LIKE luf_file.luf03,
                      tqa02_2  LIKE tqa_file.tqa02,
                      luf04    LIKE luf_file.luf04,
                      geo02_2  LIKE geo_file.geo02
                               END RECORD
DEFINE g_luf_t                 RECORD
                      luf03    LIKE luf_file.luf03,
                      tqa02_2  LIKE tqa_file.tqa02,
                      luf04    LIKE luf_file.luf04,
                      geo02_2  LIKE geo_file.geo02
                               END RECORD
DEFINE g_luh                   DYNAMIC ARRAY OF RECORD
                      luhstore LIKE luh_file.luhstore,
                      rtz13_2  LIKE rtz_file.rtz13,
                      luhlegal LIKE luh_file.luhlegal,
                      azt02    LIKE azt_file.azt02,
                      luh04    LIKE luh_file.luh04,
                      luh05    LIKE luh_file.luh05,
                      luh06    LIKE luh_file.luh06,
                      luh07    LIKE luh_file.luh07
                               END RECORD
DEFINE g_luh_t                 RECORD
                      luhstore LIKE luh_file.luhstore,
                      rtz13_2  LIKE rtz_file.rtz13,
                      luhlegal LIKE luh_file.luhlegal,
                      azt02    LIKE azt_file.azt02,
                      luh04    LIKE luh_file.luh04,
                      luh05    LIKE luh_file.luh05,
                      luh06    LIKE luh_file.luh06,
                      luh07    LIKE luh_file.luh07
                               END RECORD
#FUN-B90056 Add End -----
     
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM lue_file WHERE lue01 = ? AND lue02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t310_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t310_w WITH FORM "alm/42f/almt310"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lue34,lue35",FALSE)
##-TQC-B30101 ADD--END-------
   CALL cl_set_combo_lang("lue66") #No.FUN-AA0078 Add By shi

  #FUN-B90056 Add Begin ---
   CALL cl_set_comp_visible("lue31,lue32,lue33",FALSE)
  #FUN-B90056 Add End -----
 
   LET g_action_choice = ""
   CALL t310_menu()
 
   CLOSE WINDOW t310_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t310_curs()
 
    CLEAR FORM    
    CALL g_lug.clear()  #FUN-B90056 ADD
    CALL g_luf.clear()  #FUN-B90056 ADD
    CALL g_luh.clear()  #FUN-B90056 ADD

    DIALOG ATTRIBUTE(UNBUFFERED) #FUN-B90056 ADD

       CONSTRUCT BY NAME g_wc ON  
                         lue01,lue02,lue03,lue04,lue05,lue06,lue07,
                         lue61,lue62,                          #FUN-A80073 ---ADD---
                         lue08,lue09,lue10,lue12,lue13,lue14,lue15,lue16,
                        #lue17,lue18,lue19,lue20,lue21,lue22,lue23,lue24,               #FUN-B90056 MARK
                         lue17,lue18,lue19,lue20,lue21,lue22,lue28,lue23,lue24,         #FUN-B90056 ADD
                        #lue27,lue28,lue29,lue26,lue25,lue30,lue56,lue31,               #FUN-B90056 MARK
                         lue29,                                                         #FUN-B90056 ADD
                         lue56,                                                         #MOD-D30126 add
                        #lue32,lue33,lue34,lue35,lue36,lue37,lue38,lue60,               #FUN-B90056 MARK
                         lue32,lue33,lue31,lue60,lue55,lue34,lue35,lue36,lue37,lue38,   #FUN-B90056 ADD
                        #lue55,lue39,lue40,lue41,lue42,lue57,lue58,lue43,               #FUN-B90056 MARK
                         lue39,lue40,lue41,lue42,lue57,lue58,lue43,                     #FUN-B90056 ADD
                         lue44,lue45,lue46,lue47,lue48,lue49,lue59,lue50,
                         lue51,lue52,lue53,
                         lue63,lue64,lue66,                    #FUN-A80073 ---ADD---
                         lue54,lueuser,luegrup,lueoriu,lueorig,luecrat,luemodu,luedate  #No:FUN-9B0136
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(lue01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue01
                    NEXT FIELD lue01                     
                
                 WHEN INFIELD(lue03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lue03"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lue03
                     NEXT FIELD lue03  
                         
                 WHEN INFIELD(lue04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lue04"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lue04
                     NEXT FIELD lue04      
                 
                 WHEN INFIELD(lue08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lue08_1"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lue08
                     NEXT FIELD lue08      
                  
                 WHEN INFIELD(lue09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lue09"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lue09
                     NEXT FIELD lue09           
                 
                 WHEN INFIELD(lue40)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue40"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue40
                    NEXT FIELD lue40
                 
                 WHEN INFIELD(lue42)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue42"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue42
                    NEXT FIELD lue42
                 
                 WHEN INFIELD(lue50)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lue50"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lue50
                   NEXT FIELD lue50                
               
                 WHEN INFIELD(lue57)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lue57"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lue57
                   NEXT FIELD lue57                
 
                 WHEN INFIELD(lue58)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lue58"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lue58
                   NEXT FIELD lue58                
                 ###FUN-A80073 START ###
                 WHEN INFIELD(lue61)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue61"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue61
                    NEXT FIELD lue61   
                    
                 WHEN INFIELD(lue62)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue62"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue62
                    NEXT FIELD lue62
                    
                 WHEN INFIELD(lue64)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lue64"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lue64
                    NEXT FIELD lue64      
                 ###FUN-A80073 END ###
                 OTHERWISE
                    EXIT CASE
              END CASE
      #FUN-B90056 Add Begin ---
       END CONSTRUCT

       CONSTRUCT g_wc1 ON lug03,lug04,lug05,lug06,lug07
                     FROM s_lug[1].lug03,s_lug[1].lug04,s_lug[1].lug05,s_lug[1].lug06,
                          s_lug[1].lug07

          BEFORE CONSTRUCT
             CALL cl_qbe_init()

          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(lug03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_lug03"
                   LET g_qryparam.state='c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lug03
                   NEXT FIELD lug03

             END CASE

       END CONSTRUCT

       CONSTRUCT g_wc2 ON luf03,luf04 FROM s_luf[1].luf03,s_luf[1].luf04

          BEFORE CONSTRUCT
             CALL cl_qbe_init()

          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(luf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_luf01"
                   LET g_qryparam.state='c'
                  #FUN-B90121 Mark Begin ---
                  #LET g_qryparam.arg1 = g_lue.lue01
                  #LET g_qryparam.arg2 = g_lue.lue02
                  #FUN-B90121 Mark End -----
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO luf03
                   NEXT FIELD luf03

                WHEN INFIELD(luf04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_luf04"
                   LET g_qryparam.state='c'
                   LET g_qryparam.arg1 = g_lue.lue01
                   LET g_qryparam.arg2 = g_lue.lue02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO luf04
                   NEXT FIELD luf04

              END CASE
       END CONSTRUCT

       CONSTRUCT g_wc3 ON luhstore,luhlegal,luh04,luh05,luh06,luh07
                     FROM s_luh[1].luhstore,s_luh[1].luhlegal,
                          s_luh[1].luh04,s_luh[1].luh05,s_luh[1].luh06,
                          s_luh[1].luh07

          BEFORE CONSTRUCT
             CALL cl_qbe_init()

          ON ACTION controlp
             CASE
                WHEN INFIELD(luhstore)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_luhstore"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " luhstore IN ",g_auth," "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO luhstore
                   NEXT FIELD luhstore
                WHEN INFIELD(luhlegal)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_luhlegal"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " luhstore IN ",g_auth," "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO luhlegal
                   NEXT FIELD luhlegal
                OTHERWISE
                   EXIT CASE
             END CASE
       END CONSTRUCT
      #FUN-B90056 Add End -----
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG   #FUN-B90056 MOD
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
 
       ON ACTION controlg 
          CALL cl_cmdask() 
 
       ON ACTION qbe_select                                           
          CALL cl_qbe_select()                                         
 
       ON ACTION qbe_save                                             
          CALL cl_qbe_save()   

      #FUN-B90056 Add Begin ---
       ON ACTION accept
          ACCEPT DIALOG

       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DIALOG
      #FUN-B90056 Add End -----
 
      #END CONSTRUCT   #FUN-B90056 MARK
    END DIALOG         #FUN-B90056 ADD

    IF INT_FLAG THEN
       RETURN
    END IF
   
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lueuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND luegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND luegrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lueuser', 'luegrup')
    #End:FUN-980030
 
   #FUN-B90056 Add&Mark Begin ---
   #LET g_sql = "SELECT lue01,lue02 FROM lue_file ",
   #            " WHERE ",g_wc CLIPPED,
   #            " ORDER BY lue01"

    IF g_wc3 = " 1=1" THEN
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lue01,lue02 FROM lue_file ",
                         " WHERE ",g_wc CLIPPED,
                         " ORDER BY lue01"
          ELSE
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,lug_file ",
                         " WHERE lue01 = lug01 ",
                         "   AND lue02 = lug02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         " ORDER BY lue01"
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,luf_file ",
                         " WHERE lue01 = luf01 ",
                         "   AND lue02 = luf02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                         " ORDER BY lue01"
          ELSE
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,lug_file,luf_file ",
                         " WHERE lue01 = lug01 AND lue01 = luf01 ",
                         "   AND lue02 = lug02 AND lue02 = luf02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED,
                         " ORDER BY lue01"
          END IF
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,luh_file ",
                         " WHERE lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lue01"
          ELSE
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,lug_file,luh_file ",
                         " WHERE lue01 = lug01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = lug02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lue01"
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,luf_file,luh_file ",
                         " WHERE lue01 = luf01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = luf02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lue01"
          ELSE
             LET g_sql = "SELECT UNIQUE lue01,lue02 ",
                         "  FROM lue_file,lug_file,luf_file,luh_file ",
                         " WHERE lue01 = lug01 AND lue01 = luf01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = lug02 AND lue02 = luf02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lue01"
          END IF
       END IF
    END IF
   #FUN-B90056 Add&Mark End -----
 
    PREPARE t310_prepare FROM g_sql
    DECLARE t310_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t310_prepare
 
   #FUN-B90056 Add&Mark Begin ---
   #LET g_sql = "SELECT COUNT(*) FROM lue_file WHERE ",g_wc CLIPPED
 
    IF g_wc3 = " 1=1" THEN
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(*) FROM lue_file ",
                         " WHERE ",g_wc CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,lug_file ",
                         " WHERE lue01 = lug01 ",
                         "   AND lue02 = lug02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,luf_file ",
                         " WHERE lue01 = luf01 ",
                         "   AND lue02 = luf02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,lug_file,luf_file ",
                         " WHERE lue01 = lug01 AND lue01 = luf01 ",
                         "   AND lue02 = lug02 AND lue02 = luf02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
          END IF
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,luh_file ",
                         " WHERE lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,lug_file,luh_file ",
                         " WHERE lue01 = lug01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = lug02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc3 CLIPPED
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,luf_file,luh_file ",
                         " WHERE lue01 = luf01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = luf02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lue01,lue02) ",
                         "  FROM lue_file,lug_file,luf_file,luh_file ",
                         " WHERE lue01 = lug01 AND lue01 = luf01 AND lue01 = luh01 AND luhstore IN ",g_auth,
                         "   AND lue02 = lug02 AND lue02 = luf02 AND lue02 = luh02 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
          END IF
       END IF
    END IF
   #FUN-B90056 Add&Mark End -----
    PREPARE t310_precount FROM g_sql
    DECLARE t310_count CURSOR FOR t310_precount
END FUNCTION
 
FUNCTION t310_menu()
   DEFINE l_msg        LIKE type_file.chr1000  
   DEFINE l_count      LIKE type_file.num5
   
   #FUN-B90056 Add&Mark Begin ---
   #MENU ""
   #    BEFORE MENU
   #       CALL cl_navigator_setting(g_curs_index,g_row_count)         
    WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
   #    ON ACTION insert
   #       LET g_action_choice="insert"
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t310_a()
           END IF 
           CALL t310_pic()
              
      # ON ACTION reproduce
      #    LET g_action_choice="reproduce"
      #    IF cl_chk_act_auth() THEN
      #       CALL t310_copy()
      #    END IF   
           
   #    ON ACTION query
   #       LET g_action_choice="query"
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t310_q()
           END IF
 
   #    ON ACTION modify
   #       LET g_action_choice="modify"
        WHEN "modify"
           IF cl_chk_act_auth() THEN             
              CALL t310_u('w','')
           END IF           
 
   #    ON ACTION delete
   #       LET g_action_choice="delete"
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t310_r()
           END IF
       
   #    ON ACTION next
   #       CALL t310_fetch('N')
 
   #    ON ACTION previous
   #       CALL t310_fetch('P')
     
   #    ON ACTION confirm
   #       LET g_action_choice="confirm"
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL t310_confirm()
           END IF   
           CALL t310_pic()
                   
   #    ON ACTION unconfirm
   #       LET g_action_choice="unconfirm"
        WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL t310_unconfirm()
           END IF   
           CALL t310_pic()
           
   #    ON ACTION void
   #       LET g_action_choice = "void"
        WHEN "void"
           IF cl_chk_act_auth() THEN 
              CALL t310_v(1)
           END IF    
           CALL t310_pic()
   #FUN-B90056 Add&Mark End -----
        #FUN-D20039 ----------STA
        WHEN "undo_void"
           IF cl_chk_act_auth() THEN
              CALL t310_v(2)
           END IF
           CALL t310_pic()
        #FUN-D20039 ----------END
        
 #       ON ACTION qianhe
 #          LET g_action_choice = "qianhe"   
 #          IF cl_chk_act_auth() THEN 
 #             CALL i300_qianhe()
 #          END IF 
 #          CALL i300_pic()
  
   #FUN-B90056 Add&Mark Begin ---
   #     ON ACTION brand
   #        LET g_action_choice = "brand"                                                       
   #        IF cl_chk_act_auth() THEN                                                           
   #           IF NOT cl_null(g_lue.lue01) AND NOT cl_null(g_lue.lue02) THEN                                      
   #             LET l_msg = "almt3101  '",g_lue.lue04 CLIPPED,"' '",g_lue.lue01,"' '",g_lue.lue02,"'"
   #             CALL cl_cmdrun_wait(l_msg)                                                             
   #           ELSE                                                                               
   #             CALL cl_err('',-400,1)                                                          
   #           END IF                                                                             
   #        END IF                    
   #                  
   #     ON ACTION business
   #        LET g_action_choice = "business"                                                           
   #        IF cl_chk_act_auth() THEN                                         
   #          IF NOT cl_null(g_lue.lue01) AND NOT cl_null(g_lue.lue02) THEN                    
   #             LET l_msg = "almt3102  '",g_lue.lue04 CLIPPED,"' '",g_lue.lue01,"' '",g_lue.lue02,"'"
   #             CALL cl_cmdrun_wait(l_msg)                                               
   #          ELSE                                                       
   #              CALL cl_err('',-400,1)                                                      
   #          END IF                                                                                 
   #       END IF                
   #      
   #     ON ACTION sta
   #        LET g_action_choice = "sta" 
   #        IF cl_chk_act_auth() THEN 
   #           IF NOT cl_null(g_lue.lue01) AND NOT cl_null(g_lue.lue02) THEN                                  
   #              LET l_msg = "almt3103  '",g_lue.lue04 CLIPPED,"'  '",g_lue.lue01,"' '",g_lue.lue02,"'"
   #              CALL cl_cmdrun_wait(l_msg)                                                           
   #            ELSE                                                                             
   #              CALL cl_err('',-400,1)                                                                  
   #           END IF        
   #        END IF 
          
   #     ON ACTION send 
   #        LET g_action_choice = "send"
         WHEN "send"
            IF cl_chk_act_auth() THEN
               IF g_lue.lue36 != 'Y' THEN 
                  CALL cl_err('','alm-194',1)
               ELSE
               	 IF g_lue.lue02 = '0' THEN
               	    CALL cl_err('','alm-206',1)
               	 ELSE 
                     IF g_lue.lue55 = 'Y' THEN
                        CALL cl_err('','alm-944',0)
                     ELSE
                        IF NOT cl_null(g_lue.lue01) AND NOT cl_null(g_lue.lue02) THEN
                           IF NOT cl_confirm('alm-207') THEN
                           ELSE
                              CALL update_i300()
                              CALL t310_change_image() #FUN-B90056
                              CALL t310_show()
                           END IF 
                        ELSE
             	          CALL cl_err('',-400,1)
                        END IF 
                     END IF
                  END IF 
               END IF     
            END IF 
            
######維 護四證 確認四證#
   #     ON ACTION Maintenance
   #        LET g_action_choice = "Maintenance"
   #        IF cl_chk_act_auth() THEN   
   #           IF g_lue.lue55 = 'Y' THEN
   #              CALL cl_err('','alm-663',1)
   #           ELSE
   #              IF g_lue.lue60 = 'Y' THEN
   #                 CALL cl_err('','alm-660',1)
   #              ELSE                      
   #                 IF g_lue.lue02 = '0' THEN 
   #                    CALL cl_err('','alm-753',0)
   #                 ELSE
   #                    CALL t310_u('u','M')             #維護四證
   #                 END IF
   #              END IF
   #           END IF
   #        END IF
 
   #        ON ACTION Review                 
   #           LET g_action_choice = "Review"
   #           IF cl_chk_act_auth() THEN  
   #              IF g_lue.lue55 = 'Y' THEN
   #                 CALL cl_err('','alm-662',1)
   #              ELSE
   #                 IF g_lue.lue60 = 'Y' THEN
   #                    CALL cl_err('','alm-659',1)                                                     
   #                 ELSE
   #                    IF g_lue.lue36 = 'Y' THEN
   #                       IF g_lue.lue26 IS NULL THEN
   #                          CALL cl_err('','alm-661',1)
   #                       ELSE
   #                          IF g_lue.lue02 ='0' THEN
   #                             CALL cl_err('','alm-753',0)
   #                          ELSE
   #                             IF NOT cl_confirm('alm-658') THEN
   #                             ELSE
   #                                LET g_lue.lue60 = 'Y'
   #                                UPDATE lue_file
   #                                   SET lue60 = 'Y'
   #                                 WHERE lue01 = g_lue.lue01
   #                                   AND lue02 = g_lue.lue02
   #                               #No.TQC-A30075 -BEGIN-----
   #                                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
   #                                   CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
   #                                   LET g_lue.lue06 = 'N'
   #                                END IF
   #                               #No.TQC-A30075 -END-------
   #                                CALL t310_show()
   #                             END IF
   #                          END IF
   #                       END IF
   #                    ELSE
   #                       CALL cl_err('','alm-657',1)
   #                    END IF
   #                 END IF
   #              END IF
   #           END IF
######## ################
                 
   #     ON ACTION help
   #        CALL cl_show_help()
 
   #     ON ACTION exit
   #        LET g_action_choice = "exit"
   #        EXIT MENU
 
   #     ON ACTION jump
   #        CALL t310_fetch('/')
 
   #     ON ACTION first
   #        CALL t310_fetch('F')
 
   #     ON ACTION last
   #        CALL t310_fetch('L')
 
   #     ON ACTION controlg
         WHEN "controlg"
            CALL cl_cmdask()
 
   #     ON ACTION locale
   #        CALL cl_dynamic_locale()
   #        CALL cl_show_fld_cont() 
   #        CALL t310_pic() 
            
   #     ON IDLE g_idle_seconds
   #        CALL cl_on_idle()
   #        CONTINUE MENU
 
   #     ON ACTION about 
   #        CALL cl_about() 
 
   #     ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
   #        LET INT_FLAG = FALSE 
   #        LET g_action_choice = "exit"
   #        EXIT MENU
         WHEN "exit"
            EXIT WHILE
 
   #     ON ACTION related_document 
   #        LET g_action_choice="related_document"
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lue.lue01) THEN
                  LET g_doc.column1 = "lue01"
                  LET g_doc.value1 = g_lue.lue01
                  CALL cl_doc()
               END IF
            END IF

        WHEN "detail"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lue.lue01) THEN
                 CALL t310_b()
              ELSE
                 CALL cl_err('','-400',1)
              END IF
           END IF

       #FUN-B90056 Mark Begin ---
       #WHEN "cer_confirm"
       #   IF cl_chk_act_auth() THEN
       #      IF NOT cl_null(g_lue.lue01) THEN
       #         CALL t310_cer_confirm()
       #      ELSE
       #         CALL cl_err('','-400',1)
       #      END IF
       #   END IF
       #FUN-B90056 Mark End -----

        WHEN "upd_image"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lue.lue01) THEN
                 CALL t310_upd_image()
              ELSE
                 CALL cl_err('','-400',1)
              END IF
           END IF

      END CASE
    END WHILE
   #END MENU
   #FUN-B90056 Add&Mark End -----
    CLOSE t310_cs
END FUNCTION  

#FUN-B90056 Add Begin ---
FUNCTION t310_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lug TO s_lug.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_luf TO s_luf.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_luh TO s_luh.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '3'
            LET l_ac3 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '3'
            LET l_ac3 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice = "query"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice = "modify"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DIALOG

      ON ACTION first
         CALL t310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION previous
         CALL t310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION next
         CALL t310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION last
         CALL t310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION upd_image
         LET g_action_choice = "upd_image"
         EXIT DIALOG

     #FUN-B90056 Mark Begin ---
     #ON ACTION cer_confirm
     #   LET g_action_choice = "cer_confirm"
     #   EXIT DIALOG
     #FUN-B90056 Mark End -----

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"
         EXIT DIALOG

      ON ACTION void
         LET g_action_choice = "void"
         EXIT DIALOG
     
      #FUN-D20039 --------------sta
      ON ACTION undo_void
         LET g_action_choice = "undo_void"
         EXIT DIALOG
      #FUN-D20039 --------------end

      ON ACTION send
         LET g_action_choice = "send"
         EXIT DIALOG

      ON ACTION help
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      AFTER DIALOG 
         CONTINUE DIALOG
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
         
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B90056 Add End -----
 
FUNCTION t310_i(p_cmd,w_cmd,m_cmd)
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  w_cmd      LIKE type_file.chr1
DEFINE  m_cmd      LIKE type_file.chr1
DEFINE  l_cnt      LIKE type_file.num5 
DEFINE  l_lue02    LIKE lue_file.lue02
DEFINE  l_luu      LIKE type_file.num5
DEFINE  l_gec02    LIKE gec_file.gec02
DEFINE  l_gec04    LIKE gec_file.gec04
DEFINE  l_gec07    LIKE gec_file.gec07 
DEFINE  l_gecacti  LIKE gec_file.gecacti
DEFINE  l_oag02    LIKE oag_file.oag02
#DEFINE  l_nma02    LIKE nma_file.nma02   #MOD-C80089 mark
#DEFINE  l_nmaacti  LIKE nma_file.nmaacti #MOD-C80089 mark
DEFINE  l_nmt02    LIKE nmt_file.nmt02    #MOD-C80089 add
DEFINE  l_nmtacti  LIKE nmt_file.nmtacti  #MOD-C80089 add
DEFINE  l_count    LIKE type_file.num5 
DEFINE  l_aziacti  LIKE azi_file.aziacti
DEFINE  l_azi02    LIKE azi_file.azi02
DEFINE  l_ool02    LIKE ool_file.ool02
DEFINE  l_lue05    LIKE lue_file.lue05    #FUN-A80073 ---ADD---
DEFINE  l_oca02    LIKE oca_file.oca02    #FUN-A80073 ---ADD---
DEFINE  l_lue64_n  LIKE occ_file.occ02    #FUN-A80073 ---ADD---
DEFINE  l_occ02    LIKE occ_file.occ02    #FUN-A80073 ---ADD---
 
   DISPLAY BY NAME  g_lue.lue02,g_lue.lue03,g_lue.lue34,g_lue.lue35,g_lue.lue36,g_lue.lue37,
                    g_lue.lue38,g_lue.lue55,g_lue.lueuser,g_lue.luegrup,g_lue.luecrat,
                    g_lue.luemodu,g_lue.luedate,g_lue.lue24,g_lue.lue29,g_lue.lue32,
                    g_lue.lue33,g_lue.lue60,g_lue.lue31,g_lue.lue59
                    ,g_lue.lue61,g_lue.lue62,g_lue.lue63,             #FUN-A80073 ---ADD---
                    g_lue.lue64,g_lue.lue66                           #FUN-A80073 ---ADD--- 
    #INPUT BY NAME  g_lue.lue01,g_lue.lue04,g_lue.lue05,g_lue.lue06,g_lue.lue07,  #FUN-B90056 MARK 
     INPUT BY NAME  g_lue.lue01,g_lue.lue03,g_lue.lue04,g_lue.lue05,g_lue.lue06,g_lue.lue07, #FUN-B90056 ADD
                    g_lue.lue61,g_lue.lue62,                          #FUN-A80073 ---ADD---
                    g_lue.lueoriu,g_lue.lueorig,
                    g_lue.lue08,g_lue.lue09,g_lue.lue10,g_lue.lue12,g_lue.lue13,g_lue.lue14,
                    g_lue.lue15,g_lue.lue16,g_lue.lue17,g_lue.lue18,g_lue.lue19,g_lue.lue20,
                   #g_lue.lue21,g_lue.lue22,g_lue.lue23,g_lue.lue24,g_lue.lue27,g_lue.lue28, #FUN-B90056 MARK
                    g_lue.lue21,g_lue.lue22,g_lue.lue28,g_lue.lue23,g_lue.lue24,             #FUN-B90056 ADD
                   #g_lue.lue29,g_lue.lue26,g_lue.lue25,g_lue.lue30,g_lue.lue56,g_lue.lue39, #FUN-B90056 MAEK
                    g_lue.lue29,g_lue.lue56,g_lue.lue39,                                     #FUN-B90056 ADD #MOD-D30126 add lue56
                    g_lue.lue40,g_lue.lue41,g_lue.lue42,g_lue.lue57,g_lue.lue58,g_lue.lue43,
                    g_lue.lue44,g_lue.lue45,g_lue.lue46,g_lue.lue47,g_lue.lue48,g_lue.lue49,
                    g_lue.lue59,g_lue.lue50,g_lue.lue52,g_lue.lue53,
                    g_lue.lue63,g_lue.lue64,g_lue.lue66,              #FUN-A80073 ---ADD---
                    g_lue.lue54
    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t310_set_entry(p_cmd)              
          CALL t310_set_no_entry(p_cmd)        
          IF m_cmd = 'M' THEN
             CALL cl_set_comp_entry("lue01,lue02,lue05,
                                     lue04,lue06,lue07,lue08,lue09,lue10,lue16,lue18,
                                    #lue23,lue24,lue27,lue28,lue29,lue40,lue41,lue42, #FUN-B90056 MARK
                                     lue23,lue24,lue28,lue29,lue40,lue41,lue42,       #FUN-B90056 ADD
                                     lue43,lue44,lue45,lue57,lue58,
                                     lue12,lue13,lue14,lue15,lue17,
                                     lue19,lue20,lue21,lue22,
                                     lue39,lue46,lue47,lue48,lue49,lue50,lue51,lue52,
                                     lue53,lue54,lue55,lue59",FALSE)
          ELSE
             CALL cl_set_comp_entry("lue01,lue05,
                                     lue04,lue06,lue07,lue08,lue09,lue10,lue16,lue18,
                                    #lue23,lue24,lue27,lue28,lue29,lue40,lue41,lue42, #FUN-B90056 MARK
                                     lue23,lue24,lue28,lue29,lue40,lue41,lue42,       #FUN-B90056 ADD
                                     lue43,lue44,lue45,lue57,lue58,
                                     lue12,lue13,lue14,lue15,lue17,
                                     lue19,lue20,lue21,lue22,
                                     lue39,lue46,lue47,lue48,lue49,lue50,lue52,
                                     lue53,lue54,lue59",TRUE)
            IF w_cmd = 'u' THEN
               CALL cl_set_comp_entry("lue01",FALSE)
            END IF
          END IF
         #No.FUN-AA0078 Begin--- By shi
          IF g_lue.lue63 = '1' THEN
             CALL cl_set_comp_entry("lue64",FALSE)
          ELSE
             CALL cl_set_comp_entry("lue64",TRUE)
          END IF
         #No.FUN-AA0078 End-----
          CALL t310_set_lue03_entry()   #FUN-B90056 ADD
          LET g_before_input_done = TRUE      
    
     BEFORE FIELD lue66                              #FUN-A80073 ---ADD---
        CALL cl_set_combo_lang("lue66")              #FUN-A80073 ---ADD---
             
     AFTER FIELD lue01 
        LET g_lue01 = NULL 
        IF NOT cl_null(g_lue.lue01) THEN
           IF (p_cmd = 'a' AND w_cmd = 'a') OR 
              (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue01 != g_lue_t.lue01) THEN
              CALL t310_check_lue01(g_lue.lue01)                
              IF g_success = 'N' THEN                                                 
                 LET g_lue.lue01 = g_lue_t.lue01                                     
                 DISPLAY BY NAME g_lue.lue01                                                 
                 NEXT FIELD lue01                                                              
              ELSE               	  
                 CALL t310_xxx()    
              END IF
           END IF   
        ELSE 
           CALL cl_err('','alm-062',1)
           NEXT FIELD lue01    
        END IF    

    #FUN-B90056 Add Begin ---
     AFTER FIELD lue03
        LET g_lue03 = NULL
        IF NOT cl_null(g_lue.lue03) THEN
           IF (p_cmd = 'a' AND w_cmd = 'a') OR
              (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue03 != g_lue_t.lue03) THEN
              CALL t310_check_lue03(g_lue.lue03)
              IF g_success = 'N' THEN
                 DISPLAY BY NAME g_lue.lue03
                 NEXT FIELD lue03
              ELSE
                 LET g_lue_t.lue03 = g_lue.lue03
                 CALL t310_lue03()
              END IF
           END IF
        END IF
    #FUN-B90056 Add End -----
                 
       BEFORE FIELD lue04 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue05 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue06 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue07 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue08 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue09 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue10
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF   
        BEFORE FIELD lue12
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF  
          BEFORE FIELD lue13 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue14 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue15
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue16
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue17
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue18
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue19
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue20
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue21
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue22
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue23
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue24
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
       #FUN-B90056 Mark Begin ---
       #  BEFORE FIELD lue25
       #IF cl_null(g_lue.lue01) THEN
       #   CALL cl_err('','alm-420',1)
       #   NEXT FIELD lue01
       # END IF
       #  BEFORE FIELD lue26
       #IF cl_null(g_lue.lue01) THEN
       #   CALL cl_err('','alm-420',1)
       #   NEXT FIELD lue01
       # END IF
       #  BEFORE FIELD lue27
       #IF cl_null(g_lue.lue01) THEN
       #   CALL cl_err('','alm-420',1)
       #   NEXT FIELD lue01
       # END IF
       #FUN-B90056 Mark End -----
          BEFORE FIELD lue28
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue29
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF         
       #FUN-B90056 Mark Begin ---
       #  BEFORE FIELD lue30
       #IF cl_null(g_lue.lue01) THEN
       #   CALL cl_err('','alm-420',1)
       #   NEXT FIELD lue01
       # END IF 
       #MOD-D30126 remark---START
       BEFORE FIELD lue56
        IF cl_null(g_lue.lue01) THEN
          CALL cl_err('','alm-420',1)
          NEXT FIELD lue01
        END IF 
       #FUN-B90056 Mark End -----
       #MOD-D30126 rmark---END
          BEFORE FIELD lue39
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue40
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF 
          BEFORE FIELD lue41
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue42
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue43
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue44
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue45 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue46 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue47
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue48
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue49
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue50
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue52
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue53
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
          BEFORE FIELD lue54 
        IF cl_null(g_lue.lue01) THEN
           CALL cl_err('','alm-420',1)
           NEXT FIELD lue01
         END IF
      ###########################
      AFTER FIELD lue04
          IF NOT cl_null(g_lue.lue04) THEN 
             IF (p_cmd = 'a' AND w_cmd = 'a') OR 
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue04 != g_lue_t.lue04) OR
                (p_cmd = 'u' AND w_cmd = 'h') THEN
                CALL t310_check_lue04(g_lue.lue04)
                IF g_success = 'N' THEN                                                       
                   LET g_lue.lue04 = g_lue_t.lue04                                             
                   DISPLAY BY NAME g_lue.lue04                                                 
                   NEXT FIELD lue04 
                ELSE
                   CALL t310_xxx_lue04(g_lue.lue04)                 	                              
                END IF
             END IF 
          END IF        
###FUN-A80073 START ###
     AFTER FIELD lue61 
        IF NOT cl_null(g_lue.lue61) THEN 
           SELECT COUNT(*) INTO l_count FROM azp_file
            WHERE azp01  = g_lue.lue61
           IF l_count = 0 THEN
             CALL cl_err('','aap-025',0)
             LET g_lue.lue61 = g_lue_t.lue61                          
             DISPLAY BY NAME g_lue.lue61                                              
             NEXT FIELD lue61 
           END IF
           CALL i300_xxx_lue61(g_lue.lue61)     
        ELSE
         	DISPLAY '' TO FORMONLY.lue61_n     
        END IF 
           
     AFTER FIELD lue62
        IF NOT cl_null(g_lue.lue62) THEN
                SELECT oca02 INTO l_oca02 FROM oca_file  
                WHERE oca01 = g_lue.lue62
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oca_file",g_lue.lue62,"",STATUS,"","select oca",1) 
                  NEXT FIELD lue62
               END IF
               DISPLAY l_oca02 TO FORMONLY.lue62_n 
               CALL s_field_chk(g_lue.lue62,'4',g_plant,'lue62') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_lue.lue62,'aoo-043',1)
                  LET g_lue.lue62 = g_lue_t.lue62
                  DISPLAY BY NAME g_lue.lue62
                  NEXT FIELD lue62
               END IF
            ELSE                               
               DISPLAY ' ' TO FORMONLY.lue62_n   
            END IF
     
         
     ON CHANGE lue63               #FUN-AA0078 
        CASE g_lue.lue63
           WHEN '1'
              DISPLAY '' TO FORMONLY.lue64_n
              LET g_lue.lue64 = g_lue.lue01
              LET g_lue.lue65 = g_lue.lue01
              DISPLAY BY NAME g_lue.lue64
              DISPLAY g_lue.lue05 TO FORMONLY.lue64_n
              CALL cl_set_comp_entry("lue64",FALSE)
           WHEN '2'
              LET g_lue.lue64 = ''
              DISPLAY BY NAME g_lue.lue64 
              DISPLAY '' TO FORMONLY.lue64_n
              LET g_lue.lue65 = g_lue.lue01
              CALL cl_set_comp_entry("lue64",TRUE)
              #CALL i300_xxx_lue64(g_lue.lue64)
        END CASE          
     
     AFTER FIELD lue64
        #FUN-AA0078 add  ----------begin---------
        IF cl_null(g_lue.lue64) THEN
          #NEXT FIELD lue64
        END IF
        #FUN-AA0078 add  ----------end---------
        IF NOT cl_null(g_lue.lue64) THEN
           IF g_lue.lue64 = g_lue.lue01 THEN
              CALL cl_err('','alm-h07',1)
              NEXT FIELD lue64
           ELSE    
              SELECT COUNT(*) INTO l_count FROM occ_file WHERE occ06 IN ('1','3') AND occacti = 'Y' AND occ01 = g_lue.lue64
              IF l_count > 0 THEN
                 SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_lue.lue64
                 DISPLAY l_occ02 TO FORMONLY.lue64_n
              ELSE
                 CALL cl_err(g_lue.lue64,'alm-h06',1)
                 LET g_lue.lue64 = ''
                 DISPLAY BY NAME g_lue.lue64
                 DISPLAY '' TO FORMONLY.lue64_n
                 NEXT FIELD lue64
              END IF 	
           END IF          
        ELSE
           DISPLAY '' TO FORMONLY.lue64_n	        
        END IF      
     ###FUN-A80073 END ###
     AFTER FIELD lue08
         IF NOT cl_null(g_lue.lue08) THEN 
           IF (p_cmd = 'a' AND w_cmd = 'a') OR 
              (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue08 != g_lue_t.lue08) OR
              (p_cmd = 'u' AND w_cmd = 'h') THEN
            CALL t310_xxx_lue08(g_lue.lue08)
            IF g_success = 'N' THEN 
                LET g_lue.lue08 = g_lue_t.lue08
                DISPLAY BY NAME g_lue.lue08
                NEXT FIELD lue08
             ELSE
             	  CALL t310_xxx_lue081(g_lue.lue08)   
             END IF 
           END IF    
         ELSE
#        	  DISPLAY '' TO FORMONLY.azf03      #NO.FUN-A70063 mark 
        	  DISPLAY '' TO FORMONLY.tqa02      #NO.FUN-A70063 
         END IF  
        
     AFTER FIELD lue09
         IF NOT cl_null(g_lue.lue09) THEN 
           IF (p_cmd = 'a' AND w_cmd = 'a') OR 
              (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue09 != g_lue_t.lue09) OR
              (p_cmd = 'u' AND w_cmd = 'h') THEN 
            CALL t310_xxx_lue09(g_lue.lue09)
            IF g_success = 'N' THEN 
                LET g_lue.lue09 = g_lue_t.lue09
                DISPLAY BY NAME g_lue.lue09
                NEXT FIELD lue09
             ELSE
             	  CALL t310_xxx_lue091(g_lue.lue09)   
             END IF    
          END IF   
         ELSE
         	  DISPLAY '' TO FORMONLY.geo02  
         END IF      
   
        AFTER FIELD lue24 
         IF NOT cl_null(g_lue.lue24) THEN
            IF g_lue.lue24 < 0 THEN 
               CALL cl_err('','alm-236',1)
               NEXT FIELD lue24 
            END IF 
         END IF 
         
       AFTER FIELD lue29 
         IF NOT cl_null(g_lue.lue29) THEN
            IF g_lue.lue29 < 0 THEN 
               CALL cl_err('','alm-241',1)
               NEXT FIELD lue29 
            END IF 
         END IF     
   
     #FUN-B90056 Mark Begin ---
     #AFTER FIELD lue26
     #   IF NOT cl_null(g_lue.lue26) THEN 
     #      IF (p_cmd = 'a' AND w_cmd = 'a') OR 
     #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue26 != g_lue_t.lue26) OR
     #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue26 IS NULL) OR 
     #         (p_cmd = 'u' AND w_cmd = 'h') THEN 
     #         LET l_count = 0
     #         SELECT COUNT(*) INTO l_count FROM lue_file 
     #          WHERE lue26 = g_lue.lue26
     #            AND lue01 != g_lue.lue01
     #          IF l_count > 0 THEN 
     #             CALL cl_err('','alm-625',1)
     #             NEXT FIELD lue26
     #          END IF  
     #       END IF    
     #   END IF 
     #   
     #AFTER FIELD lue25
     #   IF NOT cl_null(g_lue.lue25)  AND NOT cl_null(g_lue.lue30) AND NOT cl_null(g_lue.lue56) THEN
     #     IF (p_cmd = 'a' AND w_cmd = 'a') OR 
     #        (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue25 != g_lue_t.lue25) OR
     #        (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue25 IS NULL) OR  
     #        (p_cmd = 'u' AND w_cmd = 'h') THEN 
     #         LET l_cnt = 0 
     #         SELECT COUNT(*) INTO l_cnt FROM lue_file
     #          WHERE lue25 = g_lue.lue25
     #            AND lue30 = g_lue.lue30
     #            AND lue56 = g_lue.lue56
     #            AND lue01 != g_lue.lue01
     #          IF l_cnt > 0 THEN 
     #             CALL cl_err('','alm-140',0)
     #             NEXT FIELD lue25
     #          END IF   
     #       END IF   
     #    END IF 
     
     #AFTER FIELD lue30
     #   IF NOT cl_null(g_lue.lue30)  AND NOT cl_null(g_lue.lue25) AND NOT cl_null(g_lue.lue56) THEN
     #     IF (p_cmd = 'a' AND w_cmd = 'a') OR 
     #        (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue30 != g_lue_t.lue30) OR
     #        (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue30 IS NULL) OR  
     #        (p_cmd = 'u' AND w_cmd = 'h') THEN 
     #         LET l_cnt = 0 
     #         SELECT COUNT(*) INTO l_cnt FROM lue_file
     #          WHERE lue25 = g_lue.lue25
     #            AND lue30 = g_lue.lue30
     #            AND lue56 = g_lue.lue56
     #            AND lue01 != g_lue.lue01
     #          IF l_cnt > 0 THEN 
     #             CALL cl_err('','alm-140',0)
     #             NEXT FIELD lue30
     #          END IF   
     #       END IF   
     #    END IF 
     #MOD-D30126 rmark---START
      AFTER FIELD lue56
        IF NOT cl_null(g_lue.lue56) THEN
           ###FUN-A80073 START ###
              SELECT COUNT(*) INTO l_cnt FROM lue_file
               WHERE lue56 = g_lue.lue56
              IF l_cnt > 0 THEN 
                CALL cl_err('','alm-h03',0)
              END IF 
              ###FUN-A80073 END ### 
        END IF
        IF NOT cl_null(g_lue.lue30)  AND NOT cl_null(g_lue.lue25) AND NOT cl_null(g_lue.lue56) THEN
          IF (p_cmd = 'a' AND w_cmd = 'a') OR 
             (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue56 != g_lue_t.lue56) OR
             (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue56 IS NULL) OR  
             (p_cmd = 'u' AND w_cmd = 'h') THEN 
              LET l_cnt = 0 
              SELECT COUNT(*) INTO l_cnt FROM lue_file
               WHERE lue25 = g_lue.lue25
                 AND lue30 = g_lue.lue30
                 AND lue56 = g_lue.lue56
                 AND lue01 != g_lue.lue01
               IF l_cnt > 0 THEN 
                  CALL cl_err('','alm-140',0)
                  NEXT FIELD lue56
               END IF   
              ###FUN-A80073 START ###
              SELECT COUNT(*) INTO l_cnt FROM lue_file
               WHERE lue56 = g_lue.lue56
              IF l_cnt > 0 THEN 
                CALL cl_err('','alm-h03',0)
              END IF 
              ###FUN-A80073 END ### 
            END IF   
         END IF 
     #FUN-B90056 Mark End -----
     #MOD-D30126 rmark---END
       
     AFTER FIELD lue40
          IF NOT cl_null(g_lue.lue40) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM gec_file
              WHERE gec01 = g_lue.lue40
                AND gec011 = '2'
              IF l_cnt < 1 THEN 
                 CALL cl_err('','alm-141',0)
                 LET g_lue.lue40 = g_lue_t.lue40
                 DISPLAY BY NAME g_lue.lue40
                 NEXT FIELD lue40
              ELSE
              	 SELECT gecacti INTO l_gecacti FROM gec_file
              	  WHERE gec01 = g_lue.lue40
              	    AND gec011 = '2'
              	 IF l_gecacti != 'Y' THEN 
              	    CALL cl_err('','alm-142',0)
                    LET g_lue.lue40 = g_lue_t.lue40
                    DISPLAY BY NAME g_lue.lue40
                    NEXT FIELD lue40   
                 ELSE
                 	  DISPLAY '' TO FORMONLY.gec02
                    DISPLAY '' TO FORMONLY.gec04 
                    DISPLAY '' TO FORMONLY.gec07 
                 	  SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
                 	   WHERE gec01 = g_lue.lue40
                 	     AND gecacti = 'Y'
                 	     AND gec011 = '2'
                 	  DISPLAY l_gec02 TO FORMONLY.gec02     
                 	  DISPLAY l_gec04 TO FORMONLY.gec04 
                 	  DISPLAY l_gec07 TO FORMONLY.gec07 
                 END IF    
              END IF     
          ELSE
          	  DISPLAY '' TO FORMONLY.gec02 
          	  DISPLAY '' TO FORMONLY.gec04 
          	  DISPLAY '' TO FORMONLY.gec07                                 
          END IF 
      
     AFTER FIELD lue57
         IF NOT cl_null(g_lue.lue57) THEN                                                                                
            LET l_count = 0                      
            SELECT ool02 INTO l_ool02 FROM ool_file
             WHERE ool01 = g_lue.lue57     
            IF STATUS = 100 THEN
                CALL cl_err('','alm-145',0)                           
                DISPLAY BY NAME g_lue.lue57                                             
                NEXT FIELD lue57                                                              
            END IF
            DISPLAY l_ool02 TO FORMONLY.ool02
         END IF
 
     AFTER FIELD lue58
        IF NOT cl_null(g_lue.lue58) THEN                                                      
           LET l_count = 0                                               
           SELECT azi02,aziacti INTO l_azi02,l_aziacti
             FROM azi_file
            WHERE azi01 = g_lue.lue58
           IF STATUS = 100 THEN
              CALL cl_err('','alm-146',0)                                   
              LET g_lue.lue58 = g_lue_t.lue58                                   
              DISPLAY BY NAME g_lue.lue58                                                
              NEXT FIELD lue58                                                                      
           ELSE                                           
              IF l_aziacti != 'Y' THEN                                      
                 CALL cl_err('','alm-089',0)                                        
                 LET g_lue.lue58 = g_lue_t.lue58                                                
                 DISPLAY BY NAME g_lue.lue58                                               
                 NEXT FIELD lue58
              END IF
              DISPLAY l_azi02 TO FORMONLY.azi02
           END IF                                                                                  
        END IF                    
 
     AFTER FIELD lue42
          IF NOT cl_null(g_lue.lue42) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM oag_file
              WHERE oag01 = g_lue.lue42
             IF l_cnt < 1 THEN 
                CALL cl_err('','alm-143',0)
                LET g_lue.lue42 = g_lue_t.lue42
                DISPLAY BY NAME g_lue.lue42
                NEXT FIELD lue42
             ELSE
             	  DISPLAY '' TO FORMONLY.oag02
             	  SELECT oag02 INTO l_oag02 FROM oag_file
             	   WHERE oag01 = g_lue.lue42
             	   DISPLAY l_oag02 TO FORMONLY.oag02    
             END IF    
          ELSE
          	 DISPLAY '' TO FORMONLY.oag02    
          END IF  
      
     AFTER FIELD lue50
          IF NOT cl_null(g_lue.lue50) THEN 
             LET l_cnt = 0 
            #SELECT COUNT(*) INTO l_cnt FROM nma_file   #MOD-C80089 -- mark
            # WHERE nma01 = g_lue.lue50                 #MOD-C80089 -- mark
             SELECT COUNT(*) INTO l_cnt FROM nmt_file   #MOD-C80089 -- add
              WHERE nmt01 = g_lue.lue50                 #MOD-C80089 -- add
             IF l_cnt < 1 THEN 
                CALL cl_err('','alm-144',0)
                LET g_lue.lue50 = g_lue_t.lue50
                DISPLAY BY NAME g_lue.lue50
                NEXT FIELD lue50
             ELSE
               #SELECT nmaacti INTO l_nmaacti FROM nma_file   #MOD-C80089 -- mark
               # WHERE nma01 = g_lue.lue50                    #MOD-C80089 -- mark
                SELECT nmtacti INTO l_nmtacti FROM nmt_file   #MOD-C80089 -- add
                 WHERE nmt01 = g_lue.lue50                    #MOD-C80089 -- add
             	 IF l_nmtacti != 'Y' THEN                     #MOD-C80089 l_nmaacti != 'Y' -> l_nmtacti != 'Y' 
             	    CALL cl_err('','alm-004',0)
             	    LET g_lue.lue50 = g_lue_t.lue50
                  DISPLAY BY NAME g_lue.lue50
                  NEXT FIELD lue50
                 ELSE
                    DISPLAY '' TO lue51 
                   #SELECT nma02 INTO l_nma02 FROM nma_file   #MOD-C80089 -- mark
             	   #   WHERE nma01 = g_lue.lue50              #MOD-C80089 -- mark
                    SELECT nmt02 INTO l_nmt02 FROM nmt_file   #MOD-C80089 -- add
                     WHERE nmt01 = g_lue.lue50                #MOD-C80089 -- add
             	    LET g_lue.lue51 = l_nmt02                 #MOD-C80089 l_nma02 -> l_nmt02
             	    DISPLAY l_nmt02 TO lue51                  #MOD-C80089 l_nma02 -> l_nmt02
             	   END IF   
             END IF    
          ELSE
             LET l_nmt02 = NULL                               #MOD-C80089 l_nma02 -> l_nmt02
             DISPLAY l_nmt02 TO lue51                         #MOD-C80089 l_nma02 -> l_nmt02
             LET g_lue.lue51 = l_nmt02                        #MOD-C80089 l_nma02 -> l_nmt02
          END IF  
                   
     AFTER INPUT        
        LET g_lue.lueuser = s_get_data_owner("lue_file") #FUN-C10039
        LET g_lue.luegrup = s_get_data_group("lue_file") #FUN-C10039
        IF INT_FLAG THEN
           LET g_lue01 = ''
           EXIT INPUT    
        END IF
        	 ##################
        IF NOT cl_null(g_lue.lue25) OR NOT cl_null(g_lue.lue26) OR
           NOT cl_null(g_lue.lue30) OR NOT cl_null(g_lue.lue56) THEN
           IF cl_null(g_lue.lue26) OR cl_null(g_lue.lue25) OR
              cl_null(g_lue.lue30) OR cl_null(g_lue.lue56) THEN
              CALL cl_err('','alm-656',1)
              NEXT FIELD lue26
           ELSE
              IF NOT cl_null(g_lue.lue26) THEN
                 IF (p_cmd = 'a' AND w_cmd = 'a') OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue26 != g_lue_t.lue26) OR
                    (p_cmd = 'u' AND w_cmd = 'h') OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue26 IS NULL) THEN
                    SELECT COUNT(*) INTO l_count FROM lue_file
                     WHERE lue26 = g_lue.lue26
                       AND lue01 != g_lue.lue01
                    IF l_count > 0 THEN
                       CALL cl_err('','alm-625',1)
                       NEXT FIELD lue26
                    END IF
                 END IF
              END IF
              IF NOT cl_null(g_lue.lue25) AND NOT cl_null(g_lue.lue30) AND NOT cl_null(g_lue.lue56) THEN
                 IF (p_cmd = 'a' AND w_cmd = 'a') OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue25 != g_lue_t.lue25) OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue30 != g_lue_t.lue30) OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue56 != g_lue_t.lue56) OR
                    (p_cmd = 'u' AND w_cmd = 'h') OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue25 IS NULL) THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM lue_file
                      WHERE lne25 = g_lue.lue25
                        AND lne30 = g_lue.lue30
                        AND lne55 = g_lue.lue56
                        AND lue01 != g_lue.lue01
                     IF l_cnt > 0 THEN
                        CALL cl_err('','alm-140',0)
                        NEXT FIELD lue25
                     END IF
                  END IF
               END IF
           END IF
        END IF
 
  #       IF NOT cl_null(g_lue.lue26) THEN 
  #         IF (p_cmd = 'a' AND w_cmd = 'a') OR 
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue26 != g_lue_t.lue26) OR
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue26 IS NULL) OR 
  #            (p_cmd = 'u' AND w_cmd = 'h') THEN 
  #            LET l_count = 0
  #            SELECT COUNT(*) INTO l_count FROM lue_file 
  #             WHERE lue26 = g_lue.lue26
  #             IF l_count > 0 THEN 
  #                CALL cl_err('','alm-625',1)
  #                NEXT FIELD lue26
  #             END IF  
  #          END IF    
  #        END IF 
  #       IF NOT cl_null(g_lue.lue25)  AND NOT cl_null(g_lue.lue30) AND NOT cl_null(g_lue.lue56) THEN
  #        IF (p_cmd = 'a' AND w_cmd = 'a') OR 
  #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue25 != g_lue_t.lue25) OR
  #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue25 IS NULL) OR  
  #           (p_cmd = 'u' AND w_cmd = 'h') THEN 
  #            LET l_cnt = 0 
  #            SELECT COUNT(*) INTO l_cnt FROM lue_file
  #             WHERE lue25 = g_lue.lue25
  #               AND lue30 = g_lue.lue30
  #               AND lue56 = g_lue.lue56
  #             IF l_cnt > 0 THEN 
  #                CALL cl_err('','alm-140',0)
  #                NEXT FIELD lue25
  #             END IF   
  #          END IF   
  #        END IF 
  #       IF NOT cl_null(g_lue.lue30) AND NOT cl_null(g_lue.lue25) AND NOT cl_null(g_lue.lue56) THEN
  #         IF (p_cmd = 'a' AND w_cmd = 'a') OR 
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue30 != g_lue_t.lue30) OR
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue30 IS NULL) OR  
  #            (p_cmd = 'u' AND w_cmd = 'h') THEN 
  #             LET l_cnt = 0 
  #             SELECT COUNT(*) INTO l_cnt FROM lue_file
  #              WHERE lue25 = g_lue.lue25
  #                AND lue30 = g_lue.lue30
  #                AND lue56 = g_lue.lue56 
  #              IF l_cnt > 0 THEN 
  #                 CALL cl_err('','alm-140',0)
  #                 NEXT FIELD lue30
  #              END IF   
  #           END IF   
  #        END IF 
  #        IF NOT cl_null(g_lue.lue30) AND NOT cl_null(g_lue.lue25) AND NOT cl_null(g_lue.lue56) THEN
  #         IF (p_cmd = 'a' AND w_cmd = 'a') OR 
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue56 != g_lue_t.lue56) OR
  #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lue_t.lue56 IS NULL) OR  
  #            (p_cmd = 'u' AND w_cmd = 'h') THEN 
  #             LET l_cnt = 0 
  #             SELECT COUNT(*) INTO l_cnt FROM lue_file
  #              WHERE lue25 = g_lue.lue25
  #                AND lue30 = g_lue.lue30
  #                AND lue56 = g_lue.lue56 
  #              IF l_cnt > 0 THEN 
  #                 CALL cl_err('','alm-140',0)
  #                 NEXT FIELD lue56
  #              END IF   
  #           END IF   
  #        END IF 
        	 #################################
       	 IF NOT cl_null(g_lue.lue25) THEN             
           IF (p_cmd = 'u' AND w_cmd = 'u' AND g_lue.lue25 = g_lue_t.lue25) OR 
               (p_cmd = 'a' AND w_cmd = 'a') THEN
           ELSE
                  LET l_cnt = 0                                                
                  SELECT COUNT(lue25) INTO l_cnt FROM lue_file                                      
                   WHERE lue25 = g_lue.lue25                                        
                  IF l_cnt > 0 THEN                                                               
                     CALL cl_err('','alm-140',0)                                              
                     NEXT FIELD lue25                                                                 
                  END IF                                                                              
              END IF    
            END IF          
  #     END IF      
      
     ON ACTION CONTROLP
        CASE  
         WHEN INFIELD(lue01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lne10"  
            LET g_qryparam.default1 = g_lue.lue01
            LET g_qryparam.default2 = l_lue02
            CALL cl_create_qry() RETURNING g_lue.lue01,l_lue02
            LET l_lue02 = l_lue02 + 1 
            LET l_luu = l_lue02 
            LET g_lue.lue02  =  l_luu            
            DISPLAY BY NAME g_lue.lue01,g_lue.lue02
            NEXT FIELD lue01
                
         WHEN INFIELD(lue04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rtz28"  
            LET g_qryparam.default1 = g_lue.lue04
            CALL cl_create_qry() RETURNING g_lue.lue04
            DISPLAY BY NAME g_lue.lue04
            NEXT FIELD lue04
            
          WHEN INFIELD(lue08)
            CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_azfp1"            #NO.FUN-A70063 mark 
            LET g_qryparam.form = "q_tqap1"            #NO.FUN-A70063
            LET g_qryparam.default1 = g_lue.lue08         
            CALL cl_create_qry() RETURNING g_lue.lue08
            DISPLAY BY NAME g_lue.lue08
            NEXT FIELD lue08   
          
           WHEN INFIELD(lue09)
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_geo"   #TQC-C40051 mark 
            LET g_qryparam.form = "q_oqw"   #TQC-C40051 add
            LET g_qryparam.default1 = g_lue.lue09
            CALL cl_create_qry() RETURNING g_lue.lue09
            DISPLAY BY NAME g_lue.lue09
            NEXT FIELD lue09
          
           WHEN INFIELD(lue40)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gec9"  
            LET g_qryparam.default1 = g_lue.lue40           
            CALL cl_create_qry() RETURNING g_lue.lue40
            DISPLAY BY NAME g_lue.lue40
            NEXT FIELD lue40 
          
           WHEN INFIELD(lue42)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oag"  
            LET g_qryparam.default1 = g_lue.lue42
            CALL cl_create_qry() RETURNING g_lue.lue42
            DISPLAY BY NAME g_lue.lue42
            NEXT FIELD lue42
          
           WHEN INFIELD(lue50)
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_nma"    #MOD-C80089 mark
            LET g_qryparam.form = "q_nmt"    #MOD-C80089 add 
            LET g_qryparam.default1 = g_lue.lue50
            CALL cl_create_qry() RETURNING g_lue.lue50
            DISPLAY BY NAME g_lue.lue50
            NEXT FIELD lue50
            
           WHEN INFIELD(lue57)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ool"  
            LET g_qryparam.default1 = g_lue.lue57
            CALL cl_create_qry() RETURNING g_lue.lue57
            DISPLAY BY NAME g_lue.lue57
            NEXT FIELD lue57
 
           WHEN INFIELD(lue58)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azi"  
            LET g_qryparam.default1 = g_lue.lue58
            CALL cl_create_qry() RETURNING g_lue.lue58
            DISPLAY BY NAME g_lue.lue58
            NEXT FIELD lue58
          ###FUN-A80073 START ###
                 WHEN INFIELD(lue61)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azp"
                    LET g_qryparam.default1 = g_lue.lue61
                    CALL cl_create_qry() RETURNING g_lue.lue61
                    DISPLAY BY NAME g_lue.lue61
                    NEXT FIELD lue61   
                    
                 WHEN INFIELD(lue62)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oca"
                    LET g_qryparam.default1 = g_lue.lue62
                    CALL cl_create_qry() RETURNING g_lue.lue62
                    DISPLAY BY NAME g_lue.lue62
                    NEXT FIELD lue62  
                    
                 WHEN INFIELD(lue64)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = ":_occ02_2" #FUN-AA0078 By shi
                    LET g_qryparam.form = "q_occ02_2" #FUN-AA0078 By shi
                    LET g_qryparam.default1 = g_lue.lue64
                    CALL cl_create_qry() RETURNING g_lue.lue64,l_lue64_n
                    DISPLAY BY NAME g_lue.lue64
                    DISPLAY l_lue64_n TO FORMONLY.lue64_n
                    NEXT FIELD lue64         
                 ###FUN-A80073 END ###  
          OTHERWISE
            EXIT CASE
        END CASE
        
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF  
        CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name 
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about 
        CALL cl_about() 
 
     ON ACTION help 
        CALL cl_show_help() 
 
   END INPUT
END FUNCTION

#FUN-B90056 Add Begin ---
FUNCTION t310_check_lue03(p_cmd)
DEFINE p_cmd      LIKE lue_file.lue03
DEFINE l_count    LIKE type_file.num5
DEFINE l_lnb33    LIKE lnb_file.lnb33

   SELECT COUNT(*) INTO l_count FROM lnb_file
    WHERE lnb01 = p_cmd

   IF l_count < 1 THEN
      CALL cl_err('','alm-162',0)
      LET g_success = 'N'
   ELSE
      LET l_count = 0
      SELECT COUNT(lne03) INTO l_count FROM lne_file
       WHERE lne03 = p_cmd AND lne01 <> g_lue.lue01
      IF l_count  > 0 THEN
         CALL cl_err('','alm-187',0)
         LET g_success = 'N'
      ELSE
         SELECT lnb33 INTO l_lnb33 FROM lnb_file
          WHERE lnb01 = p_cmd
         IF l_lnb33 != 'Y' THEN
            CALL cl_err('','alm-120',0)
            LET g_success = 'N'
         ELSE
            LET g_success = 'Y'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t310_lue03()
DEFINE l_lnb03    LIKE lnb_file.lnb03
DEFINE l_lnb05    LIKE lnb_file.lnb05
DEFINE l_lnb06    LIKE lnb_file.lnb06
DEFINE l_lnb07    LIKE lnb_file.lnb07
DEFINE l_lnb08    LIKE lnb_file.lnb08
DEFINE l_lnb09    LIKE lnb_file.lnb09
DEFINE l_lnb10    LIKE lnb_file.lnb10
DEFINE l_lnb12    LIKE lnb_file.lnb12
DEFINE l_lnb13    LIKE lnb_file.lnb13
DEFINE l_lnb14    LIKE lnb_file.lnb14
DEFINE l_lnb15    LIKE lnb_file.lnb15
DEFINE l_lnb16    LIKE lnb_file.lnb16
DEFINE l_lnb17    LIKE lnb_file.lnb17
DEFINE l_lnb18    LIKE lnb_file.lnb18
DEFINE l_lnb19    LIKE lnb_file.lnb19
DEFINE l_lnb20    LIKE lnb_file.lnb20
DEFINE l_lnb21    LIKE lnb_file.lnb21
DEFINE l_lnb22    LIKE lnb_file.lnb22
DEFINE l_lnb23    LIKE lnb_file.lnb23
DEFINE l_lnb24    LIKE lnb_file.lnb24
DEFINE l_lnb25    LIKE lnb_file.lnb25
DEFINE l_lnb26    LIKE lnb_file.lnb26
DEFINE l_lnb27    LIKE lnb_file.lnb27
DEFINE l_lnb28    LIKE lnb_file.lnb28
DEFINE l_lnb29    LIKE lnb_file.lnb29
DEFINE l_lnb30    LIKE lnb_file.lnb30
DEFINE l_lnb37    LIKE lnb_file.lnb37
DEFINE l_lnb38    LIKE lnb_file.lnb38
DEFINE l_lnb39    LIKE lnb_file.lnb39
DEFINE l_lnb40    LIKE lnb_file.lnb40
DEFINE l_lnb41    LIKE lnb_file.lnb41
DEFINE l_lnb42    LIKE lnb_file.lnb42
DEFINE l_lnb43    LIKE lnb_file.lnb43
DEFINE l_lnb44    LIKE lnb_file.lnb44
DEFINE l_lnb45    LIKE lnb_file.lnb45
DEFINE l_lnb46    LIKE lnb_file.lnb46
DEFINE l_lnb47    LIKE lnb_file.lnb47
DEFINE l_lnb48    LIKE lnb_file.lnb48
DEFINE l_lnb49    LIKE lnb_file.lnb49
DEFINE l_lnb50    LIKE lnb_file.lnb50
DEFINE l_lnb51    LIKE lnb_file.lnb51
DEFINE l_lnb52    LIKE lnb_file.lnb52
DEFINE l_lnb53    LIKE lnb_file.lnb53

   IF NOT cl_null(g_lue.lue03) THEN

      SELECT lnb03,lnb05,lnb06,lnb07,lnb08,lnb09,lnb10,lnb12,lnb13,lnb14,lnb15,
             lnb16,lnb17,lnb18,lnb19,lnb20,lnb21,lnb22,lnb23,lnb24,lnb25,lnb26,lnb27,
             lnb28,lnb29,lnb30,lnb37,lnb38,lnb39,lnb40,lnb41,lnb42,lnb43,lnb44,lnb45,
             lnb46,lnb47,lnb48,lnb49,lnb50,lnb51,lnb52,lnb53
        INTO l_lnb03,l_lnb05,l_lnb06,l_lnb07,l_lnb08,l_lnb09,l_lnb10,l_lnb12,
             l_lnb13,l_lnb14,l_lnb15,l_lnb16,l_lnb17,l_lnb18,l_lnb19,l_lnb20,
             l_lnb21,l_lnb22,l_lnb23,l_lnb24,l_lnb25,l_lnb26,l_lnb27,l_lnb28,
             l_lnb29,l_lnb30,l_lnb37,l_lnb38,l_lnb39,l_lnb40,l_lnb41,l_lnb42,
             l_lnb43,l_lnb44,l_lnb45,l_lnb46,l_lnb47,l_lnb48,l_lnb49,l_lnb50,
             l_lnb51,l_lnb52,l_lnb53
        FROM lnb_file
       WHERE lnb01 = g_lue.lue03

      IF g_lue.lue03 = g_lue03 THEN
         LET l_lnb03     = g_lue.lue04
         LET l_lnb05     = g_lue.lue05
         LET l_lnb06     = g_lue.lue06
         LET l_lnb07     = g_lue.lue07
         LET l_lnb08     = g_lue.lue08
         LET l_lnb09     = g_lue.lue09
         LET l_lnb10     = g_lue.lue10
         LET l_lnb12     = g_lue.lue12
         LET l_lnb13     = g_lue.lue13
         LET l_lnb14     = g_lue.lue14
         LET l_lnb15     = g_lue.lue15
         LET l_lnb16     = g_lue.lue16
         LET l_lnb17     = g_lue.lue17
         LET l_lnb18     = g_lue.lue18
         LET l_lnb19     = g_lue.lue19
         LET l_lnb20     = g_lue.lue20
         LET l_lnb21     = g_lue.lue21
         LET l_lnb22     = g_lue.lue22
         LET l_lnb23     = g_lue.lue23
         LET l_lnb24     = g_lue.lue24
         LET l_lnb25     = g_lue.lue25
         LET l_lnb26     = g_lue.lue26
         LET l_lnb27     = g_lue.lue27
         LET l_lnb28     = g_lue.lue28
         LET l_lnb29     = g_lue.lue29
         LET l_lnb30     = g_lue.lue30
         LET l_lnb37     = g_lue.lue40
         LET l_lnb38     = g_lue.lue41
         LET l_lnb39     = g_lue.lue42
         LET l_lnb40     = g_lue.lue43
         LET l_lnb41     = g_lue.lue44 
         LET l_lnb42     = g_lue.lue45 
         LET l_lnb43     = g_lue.lue46 
         LET l_lnb44     = g_lue.lue47 
         LET l_lnb45     = g_lue.lue48 
         LET l_lnb46     = g_lue.lue49 
         LET l_lnb47     = g_lue.lue50 
         LET l_lnb48     = g_lue.lue51 
         LET l_lnb49     = g_lue.lue52 
         LET l_lnb50     = g_lue.lue53
         LET l_lnb51     = g_lue.lue54
         LET l_lnb52     = g_lue.lue57
         LET l_lnb53     = g_lue.lue58
         LET g_lue.lue04 = l_lnb03
         LET g_lue.lue05 = l_lnb05
         LET g_lue.lue06 = l_lnb06
         LET g_lue.lue07 = l_lnb07
         LET g_lue.lue08 = l_lnb08
         LET g_lue.lue09 = l_lnb09
         LET g_lue.lue10 = l_lnb10    
         LET g_lue.lue12 = l_lnb12
         LET g_lue.lue13 = l_lnb13
         LET g_lue.lue14 = l_lnb14
         LET g_lue.lue15 = l_lnb15
         LET g_lue.lue16 = l_lnb16
         LET g_lue.lue17 = l_lnb17 
         LET g_lue.lue18 = l_lnb18
         LET g_lue.lue19 = l_lnb19
         LET g_lue.lue20 = l_lnb20
         LET g_lue.lue21 = l_lnb21
         LET g_lue.lue22 = l_lnb22    
         LET g_lue.lue23 = l_lnb23
         LET g_lue.lue24 = l_lnb24 
         LET g_lue.lue25 = l_lnb25
         LET g_lue.lue26 = l_lnb26
         LET g_lue.lue27 = l_lnb27
         LET g_lue.lue28 = l_lnb28
         LET g_lue.lue29 = l_lnb29 
         LET g_lue.lue30 = l_lnb30 
         LET g_lue.lue40 = l_lnb37
         LET g_lue.lue41 = l_lnb38
         LET g_lue.lue42 = l_lnb39
         LET g_lue.lue43 = l_lnb40
         LET g_lue.lue44 = l_lnb41
         LET g_lue.lue45 = l_lnb42
         LET g_lue.lue46 = l_lnb43
         LET g_lue.lue47 = l_lnb44
         LET g_lue.lue48 = l_lnb45
         LET g_lue.lue49 = l_lnb46
         LET g_lue.lue50 = l_lnb47
         LET g_lue.lue51 = l_lnb48
         LET g_lue.lue52 = l_lnb49
         LET g_lue.lue53 = l_lnb50
         LET g_lue.lue54 = l_lnb51
         LET g_lue.lue57 = l_lnb52
         LET g_lue.lue58 = l_lnb53
      ELSE
         LET l_lnb03     = l_lnb03
         LET l_lnb05     = l_lnb05
         LET l_lnb06     = l_lnb06
         LET l_lnb07     = l_lnb07
         LET l_lnb08     = l_lnb08
         LET l_lnb09     = l_lnb09
         LET l_lnb10     = l_lnb10
         LET l_lnb12     = l_lnb12
         LET l_lnb13     = l_lnb13
         LET l_lnb14     = l_lnb14
         LET l_lnb15     = l_lnb15
         LET l_lnb16     = l_lnb16
         LET l_lnb17     = l_lnb17
         LET l_lnb18     = l_lnb18
         LET l_lnb19     = l_lnb19
         LET l_lnb20     = l_lnb20
         LET l_lnb21     = l_lnb21
         LET l_lnb22     = l_lnb22
         LET l_lnb23     = l_lnb23
         LET l_lnb24     = l_lnb24
         LET l_lnb25     = l_lnb25
         LET l_lnb26     = l_lnb26
         LET l_lnb27     = l_lnb27
         LET l_lnb28     = l_lnb28
         LET l_lnb29     = l_lnb29
         LET l_lnb30     = l_lnb30
         LET l_lnb37     = l_lnb37
         LET l_lnb38     = l_lnb38
         LET l_lnb39     = l_lnb39
         LET l_lnb40     = l_lnb40
         LET l_lnb41     = l_lnb41
         LET l_lnb42     = l_lnb42
         LET l_lnb43     = l_lnb43
         LET l_lnb44     = l_lnb44
         LET l_lnb45     = l_lnb45
         LET l_lnb46     = l_lnb46
         LET l_lnb47     = l_lnb47
         LET l_lnb48     = l_lnb48
         LET l_lnb49     = l_lnb49
         LET l_lnb50     = l_lnb50
         LET l_lnb51     = l_lnb51
         LET l_lnb52     = l_lnb52
         LET l_lnb53     = l_lnb53
         LET g_lue.lue04 = l_lnb03
         LET g_lue.lue05 = l_lnb05
         LET g_lue.lue06 = l_lnb06
         LET g_lue.lue07 = l_lnb07
         LET g_lue.lue08 = l_lnb08
         LET g_lue.lue09 = l_lnb09
         LET g_lue.lue10 = l_lnb10
         LET g_lue.lue12 = l_lnb12
         LET g_lue.lue13 = l_lnb13
         LET g_lue.lue14 = l_lnb14
         LET g_lue.lue15 = l_lnb15
         LET g_lue.lue16 = l_lnb16
         LET g_lue.lue17 = l_lnb17
         LET g_lue.lue18 = l_lnb18
         LET g_lue.lue19 = l_lnb19
         LET g_lue.lue20 = l_lnb20
         LET g_lue.lue21 = l_lnb21
         LET g_lue.lue22 = l_lnb22
         LET g_lue.lue23 = l_lnb23
         LET g_lue.lue24 = l_lnb24
         LET g_lue.lue25 = l_lnb25
         LET g_lue.lue26 = l_lnb26
         LET g_lue.lue27 = l_lnb27
         LET g_lue.lue28 = l_lnb28
         LET g_lue.lue29 = l_lnb29
         LET g_lue.lue30 = l_lnb30
         LET g_lue.lue40 = l_lnb37
         LET g_lue.lue41 = l_lnb38
         LET g_lue.lue42 = l_lnb39
         LET g_lue.lue43 = l_lnb40
         LET g_lue.lue44 = l_lnb41
         LET g_lue.lue45 = l_lnb42
         LET g_lue.lue46 = l_lnb43
         LET g_lue.lue47 = l_lnb44
         LET g_lue.lue48 = l_lnb45
         LET g_lue.lue49 = l_lnb46
         LET g_lue.lue50 = l_lnb47
         LET g_lue.lue51 = l_lnb48
         LET g_lue.lue52 = l_lnb49
         LET g_lue.lue53 = l_lnb50
         LET g_lue.lue54 = l_lnb51
         LET g_lue.lue57 = l_lnb52
         LET g_lue.lue58 = l_lnb53
      END IF
      DISPLAY l_lnb03,l_lnb05,l_lnb06,l_lnb07,l_lnb08,l_lnb09,l_lnb10,l_lnb12,
              l_lnb13,l_lnb14,l_lnb15,l_lnb16,l_lnb17,l_lnb18,l_lnb19,l_lnb20,
              l_lnb21,l_lnb22,l_lnb23,l_lnb24,l_lnb28,
              l_lnb29,l_lnb37,l_lnb38,l_lnb39,l_lnb40,l_lnb41,l_lnb42,
              l_lnb43,l_lnb44,l_lnb45,l_lnb46,l_lnb47,l_lnb48,l_lnb49,l_lnb50,
              l_lnb51,l_lnb52,l_lnb53
           TO lue04,lue05,lue06,lue07,lue08,lue09,lue10,lue12,lue13,lue14,lue15,
              lue16,lue17,lue18,lue19,lue20,lue21,lue22,lue23,lue24,
              lue28,lue29,lue40,lue41,lue42,lue43,lue44,lue45,lue46,
              lue47,lue48,lue49,lue50,lue51,lue52,lue53,lue54,lue57,lue58

      LET g_lue03 = g_lue.lue03
      CALL t310_lue04(g_lue.lue04)
      CALL t310_lue03_show()
   END IF
END FUNCTION

FUNCTION t310_lue04(p_cmd)
DEFINE p_cmd          LIKE lue_file.lue04
DEFINE l_rtz13        LIKE rtz_file.rtz13

   IF NOT cl_null(p_cmd) THEN
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = p_cmd
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   ELSE
      DISPLAY '' TO FORMONLY.rtz13
   END IF
END FUNCTION

FUNCTION t310_lue03_show()
DEFINE  l_tqa02    LIKE tqa_file.tqa02
DEFINE  l_geo02    LIKE geo_file.geo02
DEFINE  l_gec02    LIKE gec_file.gec02
DEFINE  l_gec04    LIKE gec_file.gec04
DEFINE  l_gec07    LIKE gec_file.gec07
DEFINE  l_oag02    LIKE oag_file.oag02
DEFINE  l_ool02    LIKE ool_file.ool02
DEFINE  l_azi02    LIKE azi_file.azi02
DEFINE  l_azp02    LIKE azp_file.azp02
DEFINE  l_oca02    LIKE oca_file.oca02
DEFINE  l_occ02    LIKE occ_file.occ02 

   DISPLAY '' TO FORMONLY.tqa02
   DISPLAY '' TO FORMONLY.geo02
   DISPLAY '' TO FORMONLY.gec02
   DISPLAY '' TO FORMONLY.gec04
   DISPLAY '' TO FORMONLY.gec07
   DISPLAY '' TO FORMONLY.oag02
   DISPLAY '' TO FORMONLY.lue61_n
   DISPLAY '' TO FORMONLY.lue62_n
   DISPLAY '' TO FORMONLY.lue64_n

   IF NOT cl_null(g_lue.lue08) THEN
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa03 = '2'
         AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
            OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
         AND tqa01 = g_lue.lue08
         AND tqaacti = 'Y'
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF

   IF NOT cl_null(g_lue.lue09) THEN
     #TQC-C40051 mark START
     #SELECT geo02 INTO l_geo02 FROM geo_file
     # WHERE geo01 = g_lue.lue09
     #   AND geoacti = 'Y'
     #TQC-C40051 mark END
     #TQC-C40051 add START
      SELECT oqw02 INTO l_geo02 FROM oqw_file
       WHERE oqw01 = g_lue.lue09
         AND oqwacti = 'Y'
     #TQC-C40051 add END
       DISPLAY l_geo02 TO FORMONLY.geo02
   END IF

   IF NOT cl_null(g_lue.lue40) THEN
      SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
       WHERE gec01 = g_lue.lue40
         AND gecacti = 'Y'
         AND gec011  = '2'
       DISPLAY l_gec02 TO FORMONLY.gec02
       DISPLAY l_gec04 TO FORMONLY.gec04
       DISPLAY l_gec07 TO FORMONLY.gec07
   END IF 
       
   IF NOT cl_null(g_lue.lue42) THEN 
      SELECT oag02 INTO l_oag02 FROM oag_file
       WHERE oag01 = g_lue.lue42
      DISPLAY l_oag02 TO FORMONLY.oag02
   END IF  
 
   IF NOT cl_null(g_lue.lue57) THEN
      SELECT ool02 INTO l_ool02 FROM ool_file
       WHERE ool01 = g_lue.lue56
      DISPLAY l_ool02 TO FORMONLY.ool02
   END IF
    
   IF NOT cl_null(g_lue.lue58) THEN
      SELECT azi02 INTO l_azi02 FROM azi_file
       WHERE azi01 = g_lue.lue57
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
       
   IF NOT cl_null(g_lue.lue61) THEN 
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_lue.lue61
     DISPLAY l_azp02 TO FORMONLY.lue61_n
   END IF
   
   IF NOT cl_null(g_lue.lue62) THEN
    SELECT oca02 INTO l_oca02 FROM oca_file
     WHERE oca01 = g_lue.lue62
     DISPLAY l_oca02 TO FORMONLY.lue62_n  
   END IF
       
   IF NOT cl_null(g_lue.lue64) THEN 
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_lue.lue64
     AND occacti = 'Y'
     DISPLAY l_occ02 TO FORMONLY.lue64_n
   END IF
END FUNCTION 
#FUN-B90056 Add End -----
 
FUNCTION t310_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lue.* TO NULL
    INITIALIZE g_lue_t.* TO NULL
    INITIALIZE g_lue_o.* TO NULL
    
    LET g_lue01_t = NULL
    LET g_lue02_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cn2
    
    CALL t310_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lue.* TO NULL
       LET g_lue01_t = NULL
       LET g_lue02_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t310_count
    FETCH t310_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    OPEN t310_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
       INITIALIZE g_lue.* TO NULL
       LET g_lue01_t = NULL
       LET g_lue02_t = NULL
       LET g_wc = NULL
    ELSE
       CALL t310_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION t310_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     t310_cs INTO g_lue.lue01,g_lue.lue02
        WHEN 'P' FETCH PREVIOUS t310_cs INTO g_lue.lue01,g_lue.lue02
        WHEN 'F' FETCH FIRST    t310_cs INTO g_lue.lue01,g_lue.lue02
        WHEN 'L' FETCH LAST     t310_cs INTO g_lue.lue01,g_lue.lue02
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about 
                     CALL cl_about() 
 
                  ON ACTION help 
                     CALL cl_show_help() 
 
                  ON ACTION controlg 
                     CALL cl_cmdask() 
 
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t310_cs INTO g_lue.lue01,g_lue.lue02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
       INITIALIZE g_lue.* TO NULL
       LET g_lue01_t = NULL
       LET g_lue02_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lue.* FROM lue_file  
     WHERE lue01 = g_lue.lue01
       AND lue02 = g_lue.lue02
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lue.lueuser 
       LET g_data_group = g_lue.luegrup
       CALL t310_show() 
    END IF
END FUNCTION
 
FUNCTION t310_show()
    LET g_lue_t.* = g_lue.*
    LET g_lue_o.* = g_lue.*
    DISPLAY BY NAME g_lue.lue01,g_lue.lue02,g_lue.lue03,g_lue.lue04,g_lue.lue05, g_lue.lueoriu,g_lue.lueorig,
                    g_lue.lue06,g_lue.lue07,g_lue.lue08,g_lue.lue09,g_lue.lue10,
                    g_lue.lue12,g_lue.lue13,g_lue.lue14,g_lue.lue15,g_lue.lue16,
                    g_lue.lue17,g_lue.lue18,g_lue.lue19,g_lue.lue20,g_lue.lue21,
                   #g_lue.lue22,g_lue.lue23,g_lue.lue24,g_lue.lue27,g_lue.lue28, #FUN-B90056 MARK
                    g_lue.lue22,g_lue.lue23,g_lue.lue24,g_lue.lue28,             #FUN-B90056 ADD
                   #g_lue.lue29,g_lue.lue26,g_lue.lue25,g_lue.lue30,g_lue.lue56, #FUN-B90056 MARK
                    g_lue.lue29,g_lue.lue56,                                     #FUN-B90056 ADD #MOD-D30126 add lue56
                    g_lue.lue31,g_lue.lue32,g_lue.lue33,g_lue.lue34,g_lue.lue35,
                    g_lue.lue36,g_lue.lue37,g_lue.lue38,g_lue.lue39,g_lue.lue40,
                    g_lue.lue41,g_lue.lue42,g_lue.lue43,g_lue.lue44,g_lue.lue45,
                    g_lue.lue46,g_lue.lue47,g_lue.lue48,g_lue.lue49,g_lue.lue50,
                    g_lue.lue51,g_lue.lue52,g_lue.lue53,g_lue.lue54,g_lue.lue55,
                    g_lue.lue57,g_lue.lue58,g_lue.lue59,g_lue.lue60,
                    g_lue.lueuser,g_lue.luegrup,g_lue.luecrat,g_lue.luemodu,
                    g_lue.luedate,
                    g_lue.lue61,g_lue.lue62,g_lue.lue63,g_lue.lue64,g_lue.lue66  #FUN-A80073 ---ADD---
    CALL cl_show_fld_cont()  
    CALL t310_pic()
    CALL t310_xxx_lue04(g_lue.lue04)
    CALL t310_xxx_show() 
   #FUN-B90056 Add Begin ---
    CALL t310_b1_fill(g_wc1)
    CALL t310_b2_fill(g_wc2)
    CALL t310_b3_fill(g_wc3)
   #FUN-B90056 Add ENd -----
END FUNCTION
 
FUNCTION t310_xxx_show()
#DEFINE  l_azf03    LIKE azf_file.azf03           #NO.FUN-A70063 mark
 DEFINE  l_tqa02    LIKE tqa_file.tqa02           #NO.FUN-A7006
 DEFINE  l_geo02    LIKE geo_file.geo02
 DEFINE  l_gec02    LIKE gec_file.gec02
 DEFINE  l_gec04    LIKE gec_file.gec04 
 DEFINE  l_gec07    LIKE gec_file.gec07 
 DEFINE  l_oag02    LIKE oag_file.oag02
 DEFINE  l_ool02    LIKE ool_file.ool02
 DEFINE  l_azi02    LIKE azi_file.azi02
 DEFINE  l_azp02    LIKE azp_file.azp02           #FUN-A80073 ---ADD---
 DEFINE  l_oca02    LIKE oca_file.oca02           #FUN-A80073 ---ADD---
 DEFINE  l_occ02    LIKE occ_file.occ02           #FUN-A80073 ---ADD---
  
#DISPLAY '' TO FORMONLY.azf03                     #NO.FUN-A70063 mark
 DISPLAY '' TO FORMONLY.tqa02                     #NO.FUN-A70063 
 DISPLAY '' TO FORMONLY.geo02
 DISPLAY '' TO FORMONLY.gec02
 DISPLAY '' TO FORMONLY.gec04
 DISPLAY '' TO FORMONLY.gec07
 DISPLAY '' TO FORMONLY.oag02
 DISPLAY '' TO FORMONLY.lue61_n #FUN-A80073 ---ADD---
 DISPLAY '' TO FORMONLY.lue62_n #FUN-A80073 ---ADD---
 DISPLAY '' TO FORMONLY.lue64_n #FUN-A80073 ---ADD---
#NO.FUN-A70063---mark begin 
#IF NOT cl_null(g_lue.lue08) THEN 
#   SELECT azf03 INTO l_azf03 FROM azf_file
#    WHERE azf01 = g_lue.lue08
#      AND azf02 = '3'
#      AND azfacti = 'Y'
#   DISPLAY l_azf03 TO FORMONLY.azf03   
#END IF
#NO.FUN-A70063---mark end 
#NO.FUN-A70063---begin
IF NOT cl_null(g_lue.lue08) THEN
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = g_lue.lue08
       AND tqa03 = '2'
       AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
       AND tqaacti = 'Y'
    DISPLAY l_tqa02 TO FORMONLY.tqa02
 END IF
#NO.FUN-A70063---end
 
 IF NOT cl_null(g_lue.lue09) THEN 
   #TQC-C40051 mark START
   #SELECT geo02 INTO l_geo02 FROM geo_file
   # WHERE geo01 = g_lue.lue09
   #   AND geoacti = 'Y'
   #TQC-C40051 mark END
   #TQC-C40051 add START
    SELECT oqw02 INTO l_geo02 FROM oqw_file
     WHERE oqw01 = g_lue.lue09
       AND oqwacti = 'Y'
   #TQC-C40051 add END
     DISPLAY l_geo02 TO FORMONLY.geo02  
 END IF 
 
 IF NOT cl_null(g_lue.lue40) THEN 
    SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
     WHERE gec01 = g_lue.lue40
       AND gecacti = 'Y'
       AND gec011 = '2'
     DISPLAY l_gec02 TO FORMONLY.gec02  
     DISPLAY l_gec04 TO FORMONLY.gec04 
     DISPLAY l_gec07 TO FORMONLY.gec07 
 END IF 
 
 IF NOT cl_null(g_lue.lue42) THEN 
    SELECT oag02 INTO l_oag02 FROM oag_file
     WHERE oag01 = g_lue.lue42
    DISPLAY l_oag02 TO FORMONLY.oag02 
 END IF  
 
   IF NOT cl_null(g_lue.lue57) THEN
      SELECT ool02 INTO l_ool02 FROM ool_file
       WHERE ool01 = g_lue.lue57
      DISPLAY l_ool02 TO FORMONLY.ool02
   END IF
 
   IF NOT cl_null(g_lue.lue58) THEN
      SELECT azi02 INTO l_azi02 FROM azi_file
       WHERE azi01 = g_lue.lue58
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
   
   ###FUN-A80073 START ###
   IF NOT cl_null(g_lue.lue61) THEN 
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_lue.lue61
     DISPLAY l_azp02 TO FORMONLY.lue61_n  
   END IF
   
   IF NOT cl_null(g_lue.lue62) THEN 
    SELECT oca02 INTO l_oca02 FROM oca_file
     WHERE oca01 = g_lue.lue62
     DISPLAY l_oca02 TO FORMONLY.lue62_n  
   END IF
 
   IF NOT cl_null(g_lue.lue64) THEN 
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_lue.lue64 
     AND occacti = 'Y'  
     DISPLAY l_occ02 TO FORMONLY.lue64_n  
   END IF
   ###FUN-A80073 END ###
END FUNCTION 
 
FUNCTION t310_xxx()
  DEFINE l_gec02    LIKE gec_file.gec02
  DEFINE l_gec04    LIKE gec_file.gec04 
  DEFINE l_gec07    LIKE gec_file.gec07 
  DEFINE l_oag02    LIKE oag_file.oag02
  DEFINE l_ool02    LIKE ool_file.ool02   #FUN-AA0078 add
  DEFINE l_azi02    LIKE azi_file.azi02   #FUN-AA0078 add
  DEFINE l_lue61_n  LIKE azp_file.azp02   #FUN-AA0078 add
  DEFINE l_lue62_n  LIKE oca_file.oca02   #FUN-AA0078 add
  DEFINE l_lne03    LIKE lne_file.lne03,
         l_lne04    LIKE lne_file.lne04,
         l_lne05    LIKE lne_file.lne05,
         l_lne06    LIKE lne_file.lne06,
         l_lne07    LIKE lne_file.lne07,
         l_lne08    LIKE lne_file.lne08,
         l_lne09    LIKE lne_file.lne09,
         l_lne10    LIKE lne_file.lne10,        
         l_lne12    LIKE lne_file.lne12,
         l_lne13    LIKE lne_file.lne13,
         l_lne14    LIKE lne_file.lne14,
         l_lne15    LIKE lne_file.lne15,
         l_lne16    LIKE lne_file.lne16,
         l_lne17    LIKE lne_file.lne17,
         l_lne18    LIKE lne_file.lne18,
         l_lne19    LIKE lne_file.lne19,
         l_lne20    LIKE lne_file.lne20,
         l_lne21    LIKE lne_file.lne21,
         l_lne22    LIKE lne_file.lne22,
         l_lne23    LIKE lne_file.lne23,
         l_lne24    LIKE lne_file.lne24,
         l_lne25    LIKE lne_file.lne25,
         l_lne26    LIKE lne_file.lne26,
         l_lne27    LIKE lne_file.lne27,
         l_lne28    LIKE lne_file.lne28,
         l_lne29    LIKE lne_file.lne29,
         l_lne30    LIKE lne_file.lne30,  
         l_lne31    LIKE lne_file.lne31,
         l_lne32    LIKE lne_file.lne32,
         l_lne33    LIKE lne_file.lne33,    
         l_lne34    LIKE lne_file.lne34,
         l_lne35    LIKE lne_file.lne35,
         l_lne39    LIKE lne_file.lne39,
         l_lne40    LIKE lne_file.lne40,
         l_lne41    LIKE lne_file.lne41,
         l_lne42    LIKE lne_file.lne42,
         l_lne43    LIKE lne_file.lne43,
         l_lne44    LIKE lne_file.lne44,
         l_lne45    LIKE lne_file.lne45,
         l_lne46    LIKE lne_file.lne46,
         l_lne47    LIKE lne_file.lne47,
         l_lne48    LIKE lne_file.lne48,
         l_lne49    LIKE lne_file.lne49,
         l_lne50    LIKE lne_file.lne50,
         l_lne51    LIKE lne_file.lne51,
         l_lne52    LIKE lne_file.lne52,
         l_lne53    LIKE lne_file.lne53,
         l_lne54    LIKE lne_file.lne54,
         l_lne55    LIKE lne_file.lne55,
         l_lne56    LIKE lne_file.lne56,
         l_lne57    LIKE lne_file.lne57,
         l_lne58    LIKE lne_file.lne58,  #FUN-B90056 ADD
         l_lne59    LIKE lne_file.lne59,  #FUN-B90056 ADD
         l_lne61    LIKE lne_file.lne61,  #FUN-A80073 ---ADD---
         l_lne62    LIKE lne_file.lne62,  #FUN-A80073 ---ADD---
         l_lne63    LIKE lne_file.lne63,  #FUN-A80073 ---ADD---
         l_lne64    LIKE lne_file.lne64,  #FUN-A80073 ---ADD---
         l_lne65    LIKE lne_file.lne65,  #FUN-A80073 ---ADD---
         l_lne66    LIKE lne_file.lne66,  #FUN-A80073 ---ADD---
         l_lneuser  LIKE lne_file.lneuser,
         l_lnegrup  LIKE lne_file.lnegrup,
         l_lnecrat  LIKE lne_file.lnecrat,
         l_lnemodu  LIKE lne_file.lnemodu,
         l_lnedate  LIKE lne_file.lnedate        
   
  IF NOT cl_null(g_lue.lue01) THEN  
    
    SELECT lne03,lne04,lne05,lne06,lne07,lne08,lne09,lne10,lne12,lne13,lne14,lne15,
           lne16,lne17,lne18,lne19,lne20,lne21,lne22,lne23,lne24,lne25,lne26,lne27,
           lne28,lne29,lne30,lne31,lne32,lne33,lne34,lne35,lne39,
           lne40,lne41,lne42,lne43,lne44,lne45,lne46,lne47,lne48,lne49,lne50,lne51,
           lne52,lne53,lne54,lne55,lne56,lne57,lneuser,lnegrup,lnecrat,lnemodu,lnedate
           ,lne61,lne62,lne63,                   #FUN-A80073 ---ADD---
            lne65,lne64,lne66                    #FUN-A80073 ---ADD---                    
           ,lne58,lne59                          #FUN-B90056 ADD
      INTO l_lne03,l_lne04,l_lne05,l_lne06,l_lne07,l_lne08,l_lne09,l_lne10,l_lne12,
           l_lne13,l_lne14,l_lne15,l_lne16,l_lne17,l_lne18,l_lne19,l_lne20,l_lne21,
           l_lne22,l_lne23,l_lne24,l_lne25,l_lne26,l_lne27,l_lne28,l_lne29,l_lne30,
           l_lne31,l_lne32,l_lne33,l_lne34,l_lne35,
           l_lne39,l_lne40,l_lne41,l_lne42,l_lne43,l_lne44,l_lne45,l_lne46,l_lne47,
           l_lne48,l_lne49,l_lne50,l_lne51,l_lne52,l_lne53,l_lne54,l_lne55,l_lne56,
           l_lne57,l_lneuser,l_lnegrup,l_lnecrat,l_lnemodu,l_lnedate
           ,l_lne61,l_lne62,l_lne63,             #FUN-A80073 ---ADD---
            l_lne65,l_lne64,l_lne66              #FUN-A80073 ---ADD---    
           ,l_lne58,l_lne59                      #FUN-B90056 ADD
      FROM lne_file
     WHERE lne01 = g_lue.lue01     
 
     IF g_lue.lue01 = g_lue01 THEN 
        LET l_lne03     = g_lue.lue03
        LET l_lne04     = g_lue.lue04
        LET l_lne05     = g_lue.lue05
        LET l_lne06     = g_lue.lue06
        LET l_lne07     = g_lue.lue07
        LET l_lne08     = g_lue.lue08
        LET l_lne09     = g_lue.lue09
        LET l_lne10     = g_lue.lue10       
        LET l_lne12     = g_lue.lue12
        LET l_lne13     = g_lue.lue13
        LET l_lne14     = g_lue.lue14
        LET l_lne15     = g_lue.lue15
        LET l_lne16     = g_lue.lue16
        LET l_lne17     = g_lue.lue17
        LET l_lne18     = g_lue.lue18
        LET l_lne19     = g_lue.lue19
        LET l_lne20     = g_lue.lue20
        LET l_lne21     = g_lue.lue21
        LET l_lne22     = g_lue.lue22                        
        LET l_lne23     = g_lue.lue23
        LET l_lne24     = g_lue.lue24
        LET l_lne25     = g_lue.lue25
        LET l_lne26     = g_lue.lue26
        LET l_lne27     = g_lue.lue27
        LET l_lne28     = g_lue.lue28
        LET l_lne29     = g_lue.lue29
        LET l_lne30     = g_lue.lue30 
        LET l_lne31     = g_lue.lue31
        LET l_lne32     = g_lue.lue32
        LET l_lne33     = g_lue.lue33
        LET l_lne34     = g_lue.lue34
        LET l_lne35     = g_lue.lue35
        LET l_lne39     = g_lue.lue39 
        LET l_lne40     = g_lue.lue40 
        LET l_lne41     = g_lue.lue41 
        LET l_lne42     = g_lue.lue42 
        LET l_lne43     = g_lue.lue43 
        LET l_lne44     = g_lue.lue44 
        LET l_lne45     = g_lue.lue45 
        LET l_lne46     = g_lue.lue46 
        LET l_lne47     = g_lue.lue47 
        LET l_lne48     = g_lue.lue48 
        LET l_lne49     = g_lue.lue49 
        LET l_lne50     = g_lue.lue50 
        LET l_lne51     = g_lue.lue51 
        LET l_lne52     = g_lue.lue52
        LET l_lne53     = g_lue.lue53
        LET l_lne54     = g_lue.lue54
        LET l_lne55     = g_lue.lue56
        LET l_lne56     = g_lue.lue57
        LET l_lne57     = g_lue.lue58
        LET l_lne58     = g_lue.lue59  #FUN-B90056 ADD
        LET l_lne59     = g_lue.lue60  #FUN-B90056 ADD
        LET l_lne61     = g_lue.lue61  #FUN-A80073 add
        LET l_lne62     = g_lue.lue62  #FUN-A80073 add
        LET l_lne63     = g_lue.lue63  #FUN-A80073 add
        LET l_lne64     = g_lue.lue64  #FUN-A80073 add
        LET l_lne65     = g_lue.lue65  #FUN-A80073 add
        LET l_lne66     = g_lue.lue66  #FUN-A80073 add
        LET l_lneuser   = g_lue.lueuser
        LET l_lnegrup   = g_lue.luegrup
        LET l_lnecrat   = g_lue.luecrat
        LET l_lnemodu   = g_lue.luemodu
        LET l_lnedate   = g_lue.luedate
        LET g_lue.lue03 = l_lne03
        LET g_lue.lue04 = l_lne04
        LET g_lue.lue05 = l_lne05
        LET g_lue.lue06 = l_lne06
        LET g_lue.lue07 = l_lne07
        LET g_lue.lue08 = l_lne08
        LET g_lue.lue09 = l_lne09
        LET g_lue.lue10 = l_lne10      
        LET g_lue.lue12 = l_lne12
        LET g_lue.lue13 = l_lne13
        LET g_lue.lue14 = l_lne14
        LET g_lue.lue15 = l_lne15
        LET g_lue.lue16 = l_lne16
        LET g_lue.lue17 = l_lne17 
        LET g_lue.lue18 = l_lne18
        LET g_lue.lue19 = l_lne19
        LET g_lue.lue20 = l_lne20
        LET g_lue.lue21 = l_lne21
        LET g_lue.lue22 = l_lne22                        
        LET g_lue.lue23 = l_lne23
        LET g_lue.lue24 = l_lne24 
        LET g_lue.lue25 = l_lne25
        LET g_lue.lue26 = l_lne26
        LET g_lue.lue27 = l_lne27
        LET g_lue.lue28 = l_lne28
        LET g_lue.lue29 = l_lne29 
        LET g_lue.lue30 = l_lne30 
        LET g_lue.lue31 = l_lne31 
        LET g_lue.lue32 = l_lne32 
        LET g_lue.lue33 = l_lne33 
        LET g_lue.lue34 = l_lne34 
        LET g_lue.lue35 = l_lne35 
        LET g_lue.lue39 = l_lne39 
        LET g_lue.lue40 = l_lne40 
        LET g_lue.lue41 = l_lne41 
        LET g_lue.lue42 = l_lne42 
        LET g_lue.lue43 = l_lne43 
        LET g_lue.lue44 = l_lne44 
        LET g_lue.lue45 = l_lne45 
        LET g_lue.lue46 = l_lne46 
        LET g_lue.lue47 = l_lne47 
        LET g_lue.lue48 = l_lne48 
        LET g_lue.lue49 = l_lne49 
        LET g_lue.lue50 = l_lne50 
        LET g_lue.lue51 = l_lne51 
        LET g_lue.lue52 = l_lne52
        LET g_lue.lue53 = l_lne53
        LET g_lue.lue54 = l_lne54
        LET g_lue.lue56 = l_lne55 
        LET g_lue.lue57 = l_lne56
        LET g_lue.lue58 = l_lne57
        LET g_lue.lue59 = l_lne58  #FUN-B90056 ADD
        LET g_lue.lue60 = l_lne59  #FUN-B90056 ADD
        LET g_lue.lue61 = l_lne61  #FUN-A80073 add
        LET g_lue.lue62 = l_lne62  #FUN-A80073 add
        LET g_lue.lue63 = l_lne63  #FUN-A80073 add
        LET g_lue.lue64 = l_lne64  #FUN-A80073 add
        LET g_lue.lue65 = l_lne65  #FUN-A80073 add
        LET g_lue.lue66 = l_lne66  #FUN-A80073 add
        LET g_lue.lueuser = l_lneuser  
        LET g_lue.luegrup = l_lnegrup    
        LET g_lue.luecrat = l_lnecrat    
        LET g_lue.luemodu = l_lnemodu      
        LET g_lue.luedate = l_lnedate    
     ELSE
        LET l_lne03     = l_lne03
        LET l_lne04     = l_lne04
        LET l_lne05     = l_lne05
        LET l_lne06     = l_lne06
        LET l_lne07     = l_lne07
        LET l_lne08     = l_lne08
        LET l_lne09     = l_lne09
        LET l_lne10     = l_lne10       
        LET l_lne12     = l_lne12
        LET l_lne13     = l_lne13
        LET l_lne14     = l_lne14
        LET l_lne15     = l_lne15
        LET l_lne16     = l_lne16
        LET l_lne17     = l_lne17
        LET l_lne18     = l_lne18
        LET l_lne19     = l_lne19
        LET l_lne20     = l_lne20
        LET l_lne21     = l_lne21
        LET l_lne22     = l_lne22                      
        LET l_lne23     = l_lne23
        LET l_lne24     = l_lne24
        LET l_lne25     = l_lne25
        LET l_lne26     = l_lne26
        LET l_lne27     = l_lne27
        LET l_lne28     = l_lne28
        LET l_lne29     = l_lne29
        LET l_lne30     = l_lne30
        LET l_lne31     = l_lne31
        LET l_lne32     = l_lne32
        LET l_lne33     = l_lne33
        LET l_lne34     = l_lne34
        LET l_lne35     = l_lne35
        LET l_lne39     = l_lne39
        LET l_lne40     = l_lne40
        LET l_lne41     = l_lne41
        LET l_lne42     = l_lne42
        LET l_lne43     = l_lne43
        LET l_lne44     = l_lne44
        LET l_lne45     = l_lne45
        LET l_lne46     = l_lne46
        LET l_lne47     = l_lne47
        LET l_lne48     = l_lne48
        LET l_lne49     = l_lne49
        LET l_lne50     = l_lne50
        LET l_lne51     = l_lne51    
        LET l_lne52     = l_lne52
        LET l_lne53     = l_lne53
        LET l_lne54     = l_lne54
        LET l_lne55     = l_lne55
        LET l_lne56     = l_lne56
        LET l_lne57     = l_lne57
        LET l_lne58     = l_lne58   #FUN-B90056 ADD
        LET l_lne59     = l_lne59   #FUN-B90056 ADD
        LET l_lne61     = l_lne61   #FUN-A80073 add
        LET l_lne62     = l_lne62   #FUN-A80073 add
        LET l_lne63     = l_lne63   #FUN-A80073 add
        LET l_lne64     = l_lne64   #FUN-A80073 add
        LET l_lne65     = l_lne65   #FUN-A80073 add
        LET l_lne66     = l_lne66   #FUN-A80073 add
        LET l_lneuser   = l_lneuser  
        LET l_lnegrup   = l_lnegrup
        LET l_lnecrat   = l_lnecrat
        LET l_lnemodu   = l_lnemodu
        LET l_lnedate   = l_lnedate
        LET g_lue.lue03 = l_lne03
        LET g_lue.lue04 = l_lne04
        LET g_lue.lue05 = l_lne05
        LET g_lue.lue06 = l_lne06
        LET g_lue.lue07 = l_lne07
        LET g_lue.lue08 = l_lne08
        LET g_lue.lue09 = l_lne09
        LET g_lue.lue10 = l_lne10      
        LET g_lue.lue12 = l_lne12
        LET g_lue.lue13 = l_lne13
        LET g_lue.lue14 = l_lne14
        LET g_lue.lue15 = l_lne15
        LET g_lue.lue16 = l_lne16
        LET g_lue.lue17 = l_lne17 
        LET g_lue.lue18 = l_lne18
        LET g_lue.lue19 = l_lne19
        LET g_lue.lue20 = l_lne20
        LET g_lue.lue21 = l_lne21
        LET g_lue.lue22 = l_lne22                        
        LET g_lue.lue23 = l_lne23
        LET g_lue.lue24 = l_lne24 
        LET g_lue.lue25 = l_lne25
        LET g_lue.lue26 = l_lne26
        LET g_lue.lue27 = l_lne27
        LET g_lue.lue28 = l_lne28
        LET g_lue.lue29 = l_lne29 
        LET g_lue.lue30 = l_lne30
        LET g_lue.lue31 = l_lne31 
        LET g_lue.lue32 = l_lne32 
        LET g_lue.lue33 = l_lne33 
        LET g_lue.lue34 = l_lne34 
        LET g_lue.lue35 = l_lne35 
        LET g_lue.lue39 = l_lne39 
        LET g_lue.lue40 = l_lne40 
        LET g_lue.lue41 = l_lne41 
        LET g_lue.lue42 = l_lne42 
        LET g_lue.lue43 = l_lne43 
        LET g_lue.lue44 = l_lne44 
        LET g_lue.lue45 = l_lne45 
        LET g_lue.lue46 = l_lne46 
        LET g_lue.lue47 = l_lne47 
        LET g_lue.lue48 = l_lne48 
        LET g_lue.lue49 = l_lne49 
        LET g_lue.lue50 = l_lne50 
        LET g_lue.lue51 = l_lne51 
        LET g_lue.lue52 = l_lne52
        LET g_lue.lue53 = l_lne53
        LET g_lue.lue54 = l_lne54
        LET g_lue.lue56 = l_lne55 
        LET g_lue.lue57 = l_lne56
        LET g_lue.lue58 = l_lne57
        LET g_lue.lue59 = l_lne58   #FUN-B90056 ADD
        LET g_lue.lue60 = l_lne59   #FUN-B90056 ADD
        LET g_lue.lue61 = l_lne61   #FUN-A80073 add
        LET g_lue.lue62 = l_lne62   #FUN-A80073 add
        LET g_lue.lue63 = l_lne63   #FUN-A80073 add
        LET g_lue.lue64 = l_lne64   #FUN-A80073 add
        LET g_lue.lue65 = l_lne65   #FUN-A80073 add
        LET g_lue.lue66 = l_lne66   #FUN-A80073 add
        LET g_lue.lueuser = l_lneuser  
        LET g_lue.luegrup = l_lnegrup    
        LET g_lue.luecrat = l_lnecrat    
        LET g_lue.luemodu = l_lnemodu      
        LET g_lue.luedate = l_lnedate    
      END IF
   DISPLAY l_lne03,l_lne04,l_lne05,l_lne06,l_lne07,l_lne08,l_lne09,l_lne10,l_lne12,
           l_lne13,l_lne14,l_lne15,l_lne16,l_lne17,l_lne18,l_lne19,l_lne20,l_lne21,
          #l_lne22,l_lne23,l_lne24,l_lne25,l_lne26,l_lne27,l_lne28,l_lne29,l_lne30, #FUN-B90056 MARK
           l_lne22,l_lne23,l_lne24,l_lne28,l_lne29,                                 #FUN-B90056 ADD
           l_lne31,l_lne32,l_lne33,l_lne34,l_lne35,
           l_lne39,l_lne40,l_lne41,l_lne42,l_lne43,l_lne44,l_lne45,l_lne46,l_lne47,
          #l_lne48,l_lne49,l_lne50,l_lne51,l_lne52,l_lne53,l_lne54,l_lne55,l_lne56, #FUN-B90056 MARK
           l_lne48,l_lne49,l_lne50,l_lne51,l_lne52,l_lne53,l_lne54,l_lne56,         #FUN-B90056 ADD
           l_lne57,l_lneuser,
           l_lnegrup,l_lnecrat,l_lnemodu,l_lnedate  
           ,l_lne61,l_lne62,l_lne63,l_lne64,l_lne66    #FUN-A80073         
           ,l_lne58,l_lne59,                           #FUN-B90056 ADD
           l_lne55                                                                  #MOD-D30126 add
        TO lue03,lue04,lue05,lue06,lue07,lue08,lue09,lue10,lue12,lue13,lue14,lue15,
          #lue16,lue17,lue18,lue19,lue20,lue21,lue22,lue23,lue24,lue25,lue26,lue27, #FUN-B90056 MARK
           lue16,lue17,lue18,lue19,lue20,lue21,lue22,lue23,lue24,                   #FUN-B90056 ADD
          #lue28,lue29,lue30,lue31,lue32,lue33,lue34,lue35,lue39,                   #FUN-B90056 MARK
           lue28,lue29,lue31,lue32,lue33,lue34,lue35,lue39,                         #FUN-B90056 ADD
           lue40,lue41,lue42,lue43,lue44,lue45,lue46,lue47,lue48,lue49,lue50,lue51,
          #lue52,lue53,lue54,lue56,lue57,lue58,lueuser,luegrup,luecrat,luemodu,luedate #FUN-B90056 MARK
           lue52,lue53,lue54,lue57,lue58,lueuser,luegrup,luecrat,luemodu,luedate       #FUN-B90056 ADD
           ,lue61,lue62,lue63,lue64,lue66              #FUN-A80073
           ,lue59,lue60,                               #FUN-B90056 ADD
           lue56                                                                       #MOD-D30126 add
 
       LET g_lue01 = g_lue.lue01
       CALL t310_xxx_lue04(g_lue.lue04)
       CALL t310_xxx_lue081(g_lue.lue08)
       CALL t310_xxx_lue091(g_lue.lue09)
       
      SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
       WHERE gec01 = g_lue.lue40
         AND gecacti = 'Y'
         AND gec011 = '2'
      DISPLAY l_gec02 TO FORMONLY.gec02    
      DISPLAY l_gec04 TO FORMONLY.gec04 
      DISPLAY l_gec07 TO FORMONLY.gec07 
      
      SELECT oag02 INTO l_oag02 FROM oag_file
       WHERE oag01 = g_lue.lue42
      DISPLAY l_oag02 TO FORMONLY.oag02   
      
      #FUN-AA0078 add --------------begin----------------- 
      IF g_lue.lue63 = '1' THEN 
         CALL cl_set_comp_entry("lue64",FALSE)
      END IF   
      SELECT ool02 INTO l_ool02 FROM ool_file
       WHERE ool01 = g_lue.lue57
      DISPLAY l_ool02 TO FORMONLY.ool02
      
      SELECT azi02 INTO l_azi02 FROM azi_file
       WHERE azi01 = g_lue.lue58
      DISPLAY l_azi02 TO FORMONLY.azi02
      
      SELECT azp02 INTO l_lue61_n FROM azp_file
       WHERE azp01 = g_lue.lue61
      DISPLAY l_lue61_n TO FORMONLY.lue61_n
      
      SELECT oca02 INTO l_lue62_n FROM oca_file
       WHERE oca01 = g_lue.lue62
      DISPLAY l_lue62_n TO FORMONLY.lue62_n
      #FUN-AA0078 add --------------end-------------------
      CALL t310_copy_image() #FUN-B90056 
  END IF 
END FUNCTION
 
FUNCTION t310_u(p_w,w_cmd)
 DEFINE   p_w         LIKE type_file.chr1
 DEFINE   w_cmd       LIKE type_file.chr1
 DEFINE   l_n         LIKE type_file.num5
     
    IF cl_null(g_lue.lue01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
    IF cl_null(g_lue.lue02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
  
   IF w_cmd = 'M' THEN
   ELSE
      IF g_lue.lue36 = 'Y' THEN
         CALL cl_err('','alm-027',1)
        RETURN
      END IF    
   END IF
 
   IF g_lue.lue36 = 'X' THEN
      CALL cl_err('','alm-134',1)
     RETURN
   END IF    
   IF g_lue.lue55 = 'Y' THEN 
      CALL cl_err('','alm-193',1)
      RETURN 
   END IF 
       
    SELECT * INTO g_lue.* FROM lue_file 
      WHERE lue01  = g_lue.lue01
       AND lue02   = g_lue.lue02   
   
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lue01_t = g_lue.lue01
    LET g_lue02_t = g_lue.lue02
    BEGIN WORK
 
    OPEN t310_cl USING g_lue.lue01,g_lue.lue02
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:",STATUS,1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_lue.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lue.lue01,SQLCA.sqlcode,1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF    
    
    ###########################
    LET g_date = g_lue.luedate
    LET g_modu = g_lue.luemodu
    ###########################
    IF p_w != 'c' THEN 
      LET g_lue.luemodu = g_user  
      LET g_lue.luedate = g_today 
    ELSE
      LET g_lue.luemodu = NULL  
      LET g_lue.luedate = NULL 
    END IF  	  
       
    CALL t310_show()                 
    WHILE TRUE
        IF p_w != 'c' THEN
           CALL t310_i('u','u',w_cmd)
        ELSE
        	 LET g_lue.lue25 = ''
        	 LET g_lue.lue26 = ''
        	 LET g_lue.lue30 = ''
        	 DISPLAY BY NAME g_lue.lue25,
        	                 g_lue.lue26,
        	                 g_lue.lue30 
           CALL t310_i('u','h','')
        END IF 	    
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_lue_t.luedate = g_date
           LET g_lue_t.luemodu = g_modu
           LET g_lue_t.lue25 = g_lue.lue25
           LET g_lue_t.lue26 = g_lue.lue26
           LET g_lue_t.lue30 = g_lue.lue30
           LET g_lue.*=g_lue_t.*
           CALL t310_show()     
           CALL cl_err('',9001,0)        
           EXIT WHILE           
        END IF
 
       UPDATE lue_file SET lue_file.* = g_lue.* 
         WHERE lue01 = g_lue01_t
           AND lue02 = g_lue02_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t310_cl
    COMMIT WORK
END FUNCTION
 
###FUN-A80073 START ###
FUNCTION i300_xxx_lue61(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue61
  DEFINE l_azp02        LIKE azp_file.azp02
 
   IF NOT cl_null(p_cmd) THEN 
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = p_cmd
     DISPLAY l_azp02  TO FORMONLY.lue61_n       
   ELSE
      DISPLAY '' TO FORMONLY.lue61_n
   END IF  
END FUNCTION

#FUNCTION i300_xxx_lue62(p_cmd)
#  DEFINE p_cmd          LIKE lue_file.lue62
#  DEFINE l_oca02        LIKE oca_file.oca02
# 
#   IF NOT cl_null(p_cmd) THEN 
#      SELECT oca02 INTO l_oca02 FROM oca_file
#       WHERE oca01 = p_cmd
#     DISPLAY l_oca02  TO FORMONLY.lue62_n       
#   ELSE
#      DISPLAY '' TO FORMONLY.lue62_n
#   END IF  
#END FUNCTION

FUNCTION i300_xxx_lue64(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue64
  DEFINE l_lue05        LIKE lue_file.lue05
 
   IF NOT cl_null(p_cmd) THEN 
      SELECT lue05 INTO l_lue05 FROM lue_file
       WHERE lue01 = p_cmd
         AND lue36 = 'Y' 
     DISPLAY l_lue05  TO FORMONLY.lue64_n       
   ELSE
      DISPLAY '' TO FORMONLY.lue64_n
   END IF  
END FUNCTION
###FUN-A80073 END ### 
 
FUNCTION t310_xxx_lue04(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue04
  DEFINE l_rtz13        LIKE rtz_file.rtz13  #FUN-A80148 add
   
   IF NOT cl_null(p_cmd) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01      = p_cmd
         AND rtz28      = 'Y'
     DISPLAY l_rtz13  TO FORMONLY.rtz13       
   ELSE
     DISPLAY '' TO FORMONLY.rtz13
   END IF  
END FUNCTION 
 
FUNCTION t310_xxx_lue08(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue08
  DEFINE l_count        LIKE type_file.num5
# DEFINE l_azfacti      LIKE azf_file.azfacti     #NO.FUN-A70063 mark
# DEFINE l_azf02        LIKE azf_file.azf02       #NO.FUN-A70063 mark
  DEFINE l_tqaacti      LIKE tqa_file.tqaacti     #NO.FUN-A70063
  DEFINE l_tqa03        LIKE tqa_file.tqa03       #NO.FUN-A70063

 
# SELECT COUNT(*) INTO l_count FROM azf_file      #NO.FUN-A70063 mark
#  WHERE azf01 = p_cmd                            #NO.FUN-A70063 mark
  SELECT COUNT(*) INTO l_count FROM tqa_file      #NO.FUN-A70063
   WHERE tqa01 = p_cmd                            #NO.FUN-A70063
     AND tqa03 = '2'

   IF l_count < 1 THEN 
#    CALL cl_err('','alm-121',0)                  #NO.FUN-A70063 mark
     CALL cl_err('','alm1002',0)                  #NO.FUN-A70063
     LET g_success = 'N'
  ELSE
  	 LET l_count = 0
# 	  SELECT COUNT(*) INTO l_count FROM azf_file    #NO.FUN-A70063 mark
# 	  WHERE azf01 = p_cmd                           #NO.FUN-A70063 mark
# 	    AND azf02 = '3'                             #NO.FUN-A70063 mark
          SELECT COUNT(*) INTO l_count FROM tqa_file    #NO.FUN-A70063
          WHERE tqa01 = p_cmd                           #NO.FUN-A70063
            AND tqa03 = '2'                             #NO.FUN-A70063
            AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))  #NO.FUN-A70063 
             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))           #NO.FUN-A70063
            
          IF l_count < 1 THEN 
  	     CALL cl_err('','alm1004',0)
  	     LET g_success = 'N'
  	  ELSE
             #NO.FUN-A70063---begin
# 	     SELECT azfacti INTO l_azfacti FROM azf_file
# 	      WHERE azf01 = p_cmd
# 	        AND azf02 = '3'
             SELECT tqaacti INTO l_tqaacti FROM tqa_file
              WHERE tqa01 = p_cmd
                AND tqa03 = '2'
                AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
                  OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
#  	     IF l_azfacti != 'Y' THEN              #NO.FUN-A70063 mark                
  	     IF l_tqaacti != 'Y' THEN              #NO.FUN-A70063 
             #NO.FUN-A70063---end
  	        CALL cl_err('','alm-139',0)
  	        LET g_success = 'N'
  	     ELSE
        	 LET g_success = 'Y'
  	     END IF 		 
  	  END IF 
  END IF  	       
 #No.FUN-9B0136 BEGIN -----
  IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_count FROM lne_file
       WHERE lne08 = p_cmd
         AND lne01 <> g_lue.lue01
         AND lne36 = 'Y'
      IF l_count > 0 THEN
         CALL cl_err('','alm-706',0)
        #LET g_success = 'N'  #FUN-C40030 mark 
      END IF
   END IF
 #No.FUN-9B0136 END -------
END FUNCTION 

#NO.FUN-A70063---begin 
FUNCTION t310_xxx_lue081(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue08
  DEFINE l_tqa02        LIKE tqa_file.tqa02
  
  DISPLAY '' TO FORMONLY.tqa02
  
  IF NOT cl_null(p_cmd) THEN
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = p_cmd
       AND tqa03 = '2'
       AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
       AND tqaacti = 'Y'
   
     DISPLAY l_tqa02 TO FORMONLY.tqa02 	           
  END IF   
END FUNCTION 
#NO.FUN-A70063---end

#NO.FUN-A70063---mark begin
#FUNCTION t310_xxx_lue081(p_cmd)
# DEFINE p_cmd          LIKE lue_file.lue08
# DEFINE l_azf03        LIKE azf_file.azf03

# DISPLAY '' TO FORMONLY.azf03

# IF NOT cl_null(p_cmd) THEN
#   SELECT azf03 INTO l_azf03 FROM azf_file
#    WHERE azf01 = p_cmd
#      AND azf02 = '3'
#      AND azfacti = 'Y'

#    DISPLAY l_azf03 TO FORMONLY.azf03
# END IF
#END FUNCTION
#NO.FUN-A70063---mark end


FUNCTION t310_xxx_lue09(p_cmd)
DEFINE p_cmd          LIKE lue_file.lue09
DEFINE l_count        LIKE type_file.num5
DEFINE l_geoacti      LIKE geo_file.geoacti

 
 #SELECT COUNT(*) INTO l_count FROM geo_file  #TQC-C40051 mark 
 # WHERE geo01 = p_cmd                        #TQC-C40051 mark
  SELECT COUNT(*) INTO l_count FROM oqw_file  #TQC-C40051 add 
   WHERE oqw01 = p_cmd                        #TQC-C40051 add
  IF l_count < 1 THEN 
     CALL cl_err('','alm-124',0)
     LET g_success = 'N'
  ELSE
    #SELECT geoacti INTO l_geoacti FROM geo_file  #TQC-C40051 mark
    # WHERE geo01 = p_cmd                         #TQC-C40051 mark
     SELECT oqwacti INTO l_geoacti FROM oqw_file  #TQC-C40051 add 
      WHERE oqw01 = p_cmd                         #TQC-C40051 add 
      IF l_geoacti != 'Y' THEN 
         CALL cl_err('','alm-100',0)
         LET g_success = 'N'
      ELSE
      	 LET g_success = 'Y'
      END IF  	    
  END IF  	     	            
END FUNCTION 
 
FUNCTION t310_xxx_lue091(p_cmd)
  DEFINE p_cmd          LIKE lue_file.lue09
  DEFINE l_geo02        LIKE geo_file.geo02
 
 #SELECT geo02 INTO l_geo02 FROM geo_file   #TQC-C40051 mark
 # WHERE geo01 = p_cmd                      #TQC-C40051 mark
 #   AND geoacti = 'Y'                      #TQC-C40051 mark
  SELECT oqw02 INTO l_geo02 FROM oqw_file   #TQC-C40051 add
   WHERE oqw01 = p_cmd                      #TQC-C40051 add 
     AND oqwacti = 'Y'                      #TQC-C40051 add
  DISPLAY l_geo02 TO FORMONLY.geo02     
END FUNCTION 
 
FUNCTION t310_check_lue01(p_cmd)
 DEFINE  p_cmd     LIKE lne_file.lne01
 DEFINE  l_count   LIKE type_file.num5
 DEFINE  l_lne36   LIKE lne_file.lne36
 DEFINE  l_luu     LIKE type_file.num5
 DEFINE  l_lne02   LIKE lne_file.lne02
 
 SELECT lne02 INTO l_lne02 FROM lne_file
  WHERE lne01  = p_cmd
   LET l_luu = l_lne02 + 1 
   LET g_gg = l_luu
    
   LET l_count = 0
   SELECT COUNT(lue01) INTO l_count FROM lue_file
    WHERE lue01 = p_cmd
   IF l_count < 1 THEN
      CALL cl_err('','alm-a01',0)
      LET g_success = 'N'
      RETURN             #FUN-A80073 ---ADD---
   ELSE
      LET g_success = 'Y'
   END IF 
     
     SELECT lne36 INTO l_lne36 FROM lne_file 
      WHERE lne01  = p_cmd
     IF l_lne36 != 'Y' THEN 
        CALL cl_err('','alm-007',0)
        LET g_success = 'N'
        RETURN             #FUN-A80073 ---ADD---
     ELSE
     	LET l_count = 0
     	SELECT COUNT(*) INTO l_count FROM lue_file
     	 WHERE lue01 = p_cmd
           AND lue02 = l_luu
     	IF l_count > 0  THEN 
     	   CALL cl_err('','alm-188',1)
     	   LET g_success = 'N'
     	   RETURN             #FUN-A80073 ---ADD---
     	ELSE
     		 LET g_success = 'Y' 
     		 LET g_lue.lue02 = l_luu
     		 DISPLAY BY NAME g_lue.lue02 
     		 RETURN
     	END IF      	      
     END IF  	  
  
  ###FUN-A80073 MARK START ###
  #SELECT COUNT(*) INTO l_count FROM occ_file
  #  WHERE occ01  = p_cmd
  # IF l_count > 0 THEN
  #    CALL cl_err('','alm-547',0)
  #    LET g_success = 'N'
  #    RETURN             
  # ELSE
  #    LET g_success = 'Y'
  # END IF
  #
  # SELECT COUNT(*) INTO l_count FROM occa_file
  #  WHERE occa01  = p_cmd
  # IF l_count > 0 THEN
  #    CALL cl_err('','alm-549',0)
  #    LET g_success = 'N'
  #    RETURN      
  # ELSE
  #    LET g_success = 'Y'
  #    RETURN      
  # END IF
  ###FUN-A80073 MARK END ###        
END FUNCTION
 
FUNCTION t310_check_lue04(p_cmd)
 DEFINE p_cmd      LIKE lue_file.lue04 
 DEFINE l_count    LIKE type_file.num5
 DEFINE l_rtz28    LIKE rtz_file.rtz28  #FUN-A80148 add
 
 SELECT COUNT(*) INTO l_count FROM rtz_file
   WHERE rtz01 = p_cmd
  
 IF l_count < 1 THEN
    CALL cl_err('','alm-077',0)
    LET g_success = 'N'
 ELSE
    SELECT rtz28 INTO l_rtz28 FROM rtz_file
    WHERE rtz01 = p_cmd
     IF l_rtz28 != 'Y' THEN 
       CALL cl_err('','alm-002',0)
       LET g_success = 'N'
     ELSE
     	 LET g_success = 'Y'
     END IF   
 END IF 
END FUNCTION 
 
FUNCTION t310_set_entry(p_cmd)
  DEFINE    p_cmd    LIKE type_file.chr1
  
  IF p_cmd = 'a' THEN 
    CALL cl_set_comp_entry("lue01",TRUE)
  END IF 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("lue01,lue02,lue03",FALSE)        
  END IF           
END FUNCTION  
 
FUNCTION t310_confirm()
   DEFINE l_lue37         LIKE lue_file.lue37 
   DEFINE l_lue38         LIKE lue_file.lue38   
   
   IF cl_null(g_lue.lue01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------ begin
   IF cl_null(g_lue.lue02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lue.lue36 = 'Y' THEN
      CALL cl_err(g_lue.lue01,'alm-005',1)
      RETURN
   END IF
   IF g_lue.lue36 = 'X' THEN
      CALL cl_err(g_lue.lue01,'alm-134',1)
      RETURN
   END IF
   IF g_lue.lue55 = 'Y' THEN
      CALL cl_err('','alm-193',1)
      RETURN
   END IF
   IF g_lue.lue60 <> 'Y' THEN
      #CALL cl_err('','alm-1252',0)    #TQC-C80021 mark
      CALL cl_err('','alm1252',0)      #TQC-C80021 add
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN RETURN END IF
   SELECT * INTO g_lue.* FROM lue_file
    WHERE lue01      = g_lue.lue01
      AND lue02      = g_lue.lue02
#CHI-C30107 ------------ add ------------ end
   IF cl_null(g_lue.lue02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
   IF g_lue.lue36 = 'Y' THEN
      CALL cl_err(g_lue.lue01,'alm-005',1)
      RETURN
   END IF   
   IF g_lue.lue36 = 'X' THEN
      CALL cl_err(g_lue.lue01,'alm-134',1)
      RETURN
   END IF
   IF g_lue.lue55 = 'Y' THEN 
      CALL cl_err('','alm-193',1)
      RETURN 
   END IF 
  #FUN-B90056 Add Begin ---
   IF g_lue.lue60 <> 'Y' THEN
      #CALL cl_err('','alm-1252',0)    #TQC-C80021 mark
      CALL cl_err('','alm1252',0)      #TQC-C80021 add
      RETURN
   END IF
  #FUN-B90056 Add End -----
   
   SELECT * INTO g_lue.* FROM lue_file
    WHERE lue01      = g_lue.lue01
      AND lue02      = g_lue.lue02
   
    LET l_lue37 = g_lue.lue37
    LET l_lue38 = g_lue.lue38 
   
    BEGIN WORK 
    OPEN t310_cl USING g_lue.lue01,g_lue.lue02
    IF STATUS THEN 
       CALL cl_err("open t310_cl:",STATUS,1)
       CLOSE t310_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    
    FETCH t310_cl INTO g_lue.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN 
    END IF    
#CHI-C30107 ---------- mark --------- begin  
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
#  ELSE
#CHI-C30107 ---------- mark --------- end
   	  LET g_lue.lue36 = 'Y'
      LET g_lue.lue37 = g_user
      LET g_lue.lue38 = g_today 
      UPDATE lue_file
         SET lue36 = g_lue.lue36,
             lue37 = g_lue.lue37,
             lue38 = g_lue.lue38 
       WHERE lue01      = g_lue.lue01
         AND lue02      = g_lue.lue02
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lue:',SQLCA.SQLCODE,0)
         LET g_lue.lue36 = "N"
         LET g_lue.lue37 = l_lue37
         LET g_lue.lue38 = l_lue38     
         DISPLAY BY NAME g_lue.lue36,g_lue.lue37,g_lue.lue38
         RETURN
       ELSE        
         DISPLAY BY NAME g_lue.lue36,g_lue.lue37,g_lue.lue38     
       END IF
#   END IF   #CHI-C30107 mark
     CLOSE t310_cl
  COMMIT WORK      
END FUNCTION
 
FUNCTION t310_unconfirm()  
   DEFINE l_lue37         LIKE lue_file.lue37 
   DEFINE l_lue38         LIKE lue_file.lue38 
   
   IF cl_null(g_lue.lue01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF cl_null(g_lue.lue02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lue.lue02 = '0' THEN
      CALL cl_err('','alm-200',0)
      RETURN
   END IF
      
   SELECT * INTO g_lue.* FROM lue_file
    WHERE lue01      = g_lue.lue01
      AND lue02      = g_lue.lue02
  
   LET l_lue37 = g_lue.lue37
   LET l_lue38 = g_lue.lue38 
  
 
   IF g_lue.lue36 = 'N' THEN
      CALL cl_err(g_lue.lue01,'alm-007',1)
      RETURN
   END IF
  
   IF g_lue.lue36 = 'X' THEN
      CALL cl_err(g_lue.lue01,'alm-134',1)
      RETURN
   END IF
   IF g_lue.lue55 = 'Y' THEN 
      CALL cl_err('','alm-193',1)
      RETURN 
   END IF 
    BEGIN WORK
    OPEN t310_cl USING g_lue.lue01,g_lue.lue02
    
    IF STATUS THEN 
       CALL cl_err("open t310_cl:",STATUS,1)
       CLOSE t310_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t310_cl INTO g_lue.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN 
    END IF  
    
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
       LET g_lue.lue36 = 'N'
       #CHI-D20015---modify---str---
       #LET g_lue.lue37 = NULL
       #LET g_lue.lue38 = NULL
       LET g_lue.lue37 = g_user
       LET g_lue.lue38 = g_today
       #CHI-D20015---modify---end---
       LET g_lue.luemodu = g_user
       LET g_lue.luedate = g_today
       UPDATE lue_file
          SET lue36 = g_lue.lue36,
              lue37 = g_lue.lue37,
              lue38 = g_lue.lue38,
              luemodu = g_user,
              luedate = g_today   
        WHERE lue01      = g_lue.lue01
          AND lue02      = g_lue.lue02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd lue:',SQLCA.SQLCODE,0)
          LET g_lue.lue36 = "Y"
          LET g_lue.lue37 = l_lue37
          LET g_lue.lue38 = l_lue38      
          DISPLAY BY NAME g_lue.lue36,g_lue.lue37,g_lue.lue38
          RETURN
         ELSE   
         	 DISPLAY BY NAME g_lue.lue36,g_lue.lue37,g_lue.lue38,g_lue.luemodu,g_lue.luedate
      END IF
   END IF 
    CLOSE t310_cl
  COMMIT WORK    
END FUNCTION
 
FUNCTION t310_pic()
   CASE g_lue.lue36
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
END FUNCTION
 
FUNCTION t310_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF cl_null(g_lue.lue01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF cl_null(g_lue.lue02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lue.* FROM lue_file
    WHERE lue01      = g_lue.lue01
      AND lue02      = g_lue.lue02
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lue.lue36='X' THEN RETURN END IF
    ELSE
       IF g_lue.lue36<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   
   IF g_lue.lue36 = 'Y' THEN
      CALL cl_err(g_lue.lue01,'9023',0)
      RETURN
   END IF
   IF g_lue.lue55 = 'Y' THEN 
      CALL cl_err('','alm-193',1)
      RETURN 
   END IF 

   BEGIN WORK
    OPEN t310_cl USING g_lue.lue01,g_lue.lue02
    
    IF STATUS THEN 
       CALL cl_err("open t310_cl:",STATUS,1)
       CLOSE t310_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t310_cl INTO g_lue.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN 
    END IF      
    
    IF g_lue.lue36 != 'Y' THEN
      IF g_lue.lue36 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lue.lue36 = 'N'
            LET	g_lue.luemodu = g_user
            LET g_lue.luedate = g_today 
            UPDATE lue_file
               SET lue36 = g_lue.lue36,
                   luemodu = g_lue.luemodu,
                   luedate = g_lue.luedate
             WHERE lue01 = g_lue.lue01
               AND lue02 = g_lue.lue02
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lue:',SQLCA.SQLCODE,0)
               LET g_lue.lue36 = "X"
               DISPLAY BY NAME g_lue.lue36
               RETURN
            ELSE
            	  DISPLAY BY NAME g_lue.lue36,g_lue.luemodu,g_lue.luedate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lue.lue36 = 'X'
            LET g_lue.luemodu = g_user
            LET g_lue.luedate = g_today              
            UPDATE lue_file
               SET lue36 = g_lue.lue36,
                   luemodu = g_lue.luemodu,
                   luedate = g_lue.luedate
             WHERE lue01 = g_lue.lue01
               AND lue02 = g_lue.lue02
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lue:',SQLCA.SQLCODE,0)
               LET g_lue.lue36 = "N"
               DISPLAY BY NAME g_lue.lue36
               RETURN
            ELSE            
               DISPLAY BY NAME g_lue.lue36,g_lue.luemodu,g_lue.luedate
            END IF
         END IF
      END IF
   END IF
  CLOSE t310_cl
  COMMIT WORK  
END FUNCTION 
 
FUNCTION t310_r()
DEFINE l_gca01   LIKE gca_file.gca01 #FUN-B90056 Add 
DEFINE l_gca07   LIKE gca_file.gca07 #FUN-B90056 Add 
DEFINE l_gca08   LIKE gca_file.gca08 #FUN-B90056 Add 
DEFINE l_gca09   LIKE gca_file.gca09 #FUN-B90056 Add 
DEFINE l_gca10   LIKE gca_file.gca10 #FUN-B90056 Add 
 
    IF cl_null(g_lue.lue01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF cl_null(g_lue.lue02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_lue.lue36 = 'Y' THEN 
       CALL cl_err(g_lue.lue01,'alm-028',1)
       RETURN
     END IF
     IF g_lue.lue36 = 'X' THEN 
       CALL cl_err(g_lue.lue01,'alm-134',1)
       RETURN
     END IF
 
    IF g_lue.lue55 = 'Y' THEN 
      CALL cl_err('','alm-193',1)
      RETURN 
   END IF 
    BEGIN WORK
 
    OPEN t310_cl USING g_lue.lue01,g_lue.lue02
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:",STATUS,0)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_lue.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t310_show()
    IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lue01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lue.lue01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lue_file WHERE lue01 = g_lue.lue01
                              AND lue02 = g_lue.lue02
       DELETE FROM luf_file WHERE luf01 = g_lue.lue01
                              AND luf02 = g_lue.lue02      
       DELETE FROM lug_file WHERE lug01 = g_lue.lue01 
                              AND lug02 = g_lue.lue02
       DELETE FROM luh_file WHERE luh01 = g_lue.lue01
                              AND luh02 = g_lue.lue02 
      #FUN-B90056 Add Begin ---
       LET l_gca01 = "lue01=",g_lue.lue01,"|",g_lue.lue02
       SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
        WHERE gca01 =l_gca01
       DELETE FROM gca_file WHERE gca01 = l_gca01
       DELETE FROM gcb_file WHERE gcb01 = l_gca07
                              AND gcb02 = l_gca08
                              AND gcb03 = l_gca09
                              AND gcb04 = l_gca10
      #FUN-B90056 Add End -----
          
       CLEAR FORM
       CALL g_lug.clear() #FUN-B90056 Add 
       CALL g_luf.clear() #FUN-B90056 Add 
       CALL g_luh.clear() #FUN-B90056 Add 
       OPEN t310_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t310_cs
          CLOSE t310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t310_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t310_cs
          CLOSE t310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cn2
       OPEN t310_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t310_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t310_fetch('/')
       END IF
    END IF
    CLOSE t310_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t310_a()
 
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_lue.*    LIKE lue_file.*       
    INITIALIZE g_lue_t.*  LIKE lue_file.*
    INITIALIZE g_lue_o.*  LIKE lue_file.*     
   #FUN-B90056 Add Begin ---
    CALL g_lug.clear()
    CALL g_luf.clear()
    CALL g_luh.clear()
    LET g_wc1 = NULL
    LET g_wc2 = NULL
    LET g_wc3 = NULL
   #FUN-B90056 Add End -----
    
     LET g_lue01_t = NULL
     LET g_lue02_t = NULL 
     LET g_wc = NULL
     CALL cl_opmsg('a') 
     
     WHILE TRUE
        LET g_lue.lueuser = g_user
        LET g_lue.lueoriu = g_user #FUN-980030
        LET g_lue.lueorig = g_grup #FUN-980030
        LET g_lue.luegrup = g_grup  
        LET g_lue.luecrat = g_today   
        LET g_lue.lue24   = 0
        LET g_lue.lue29   = 0
        LET g_lue.lue32   = 0
        LET g_lue.lue33   = 0
        LET g_lue.lue34   = 'N'
        LET g_lue.lue35   = '0'
        LET g_lue.lue36   = 'N'  
        LET g_lue.lue55   = 'N'      
        LET g_lue.lue59   = '0'
        LET g_lue.lue60   = 'N'
        LET g_lue.lue31   = 'N'
        
        CALL t310_i('a','a','')    
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lue.* TO NULL
           LET g_lue01_t = NULL           
           LET g_lue02_t = NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_lue.lue01) THEN    
           CONTINUE WHILE
        END IF        
         
        INSERT INTO lue_file VALUES(g_lue.*)                   
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lue.lue01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           CALL t310_bring()
           SELECT * INTO g_lue.* FROM lue_file
            WHERE lue01  = g_lue.lue01
              AND lue02  = g_lue.lue02
          #FUN-B90056 Add Begin ---
           LET g_rec_b1 = 0
           LET g_rec_b2 = 0
           LET g_rec_b3 = 0  
           CALL t310_b1_fill(" 1=1")
           CALL t310_b2_fill(" 1=1")
           CALL t310_b3_fill(" 1=1")
          #FUN-B90056 Add End -----
        END IF

       #FUN-B90056 Add Begin ---
        CALL t310_b()
       #FUN-B90056 Add End -----

        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION t310_bring()
DEFINE  l_sql       STRING
DEFINE  g_cnt_1     LIKE type_file.num10
DEFINE  g_luf       DYNAMIC ARRAY OF RECORD
          luf03     LIKE luf_file.luf03,
          luf04     LIKE luf_file.luf04
                    END RECORD,
        g_lug       DYNAMIC ARRAY OF RECORD
          lug03     LIKE lug_file.lug03,
          lug04     LIKE lug_file.lug04,
          lug05     LIKE lug_file.lug05,
          lug06     LIKE lug_file.lug06,
          lug07     LIKE lug_file.lug07          
                    END RECORD,
        g_luh       DYNAMIC ARRAY OF RECORD
          luhstore  LIKE luh_file.luhstore, #FUN-AB0096
          luhlegal  LIKE luh_file.luhlegal,
          luh04     LIKE luh_file.luh04,
          luh05     LIKE luh_file.luh05,
          luh06     LIKE luh_file.luh06,
          luh07     LIKE luh_file.luh07
                    END RECORD                           
       
       LET l_sql = "select lnf03,lnf04 from lnf_file",
                   " where lnf01 = '",g_lue.lue01,"'"
       PREPARE luf_pb FROM l_sql
       DECLARE luf_curs CURSOR FOR luf_pb
       
       LET l_sql = "select lng03,lng04,lng05,lng06,lng07 from lng_file",
                   " where lng01 = '",g_lue.lue01,"'"            
       PREPARE lug_pb FROM l_sql
       DECLARE lug_curs CURSOR FOR lug_pb
       
      #LET l_sql = "select lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07 from lnh_file", #FUN-B90056 Mark
       LET l_sql = "select lnhstore,lnhlegal,lnh07,lnh05,lnh06,lnh07 from lnh_file", #FUN-B90056 Add
                   " where lnh01 = '",g_lue.lue01,"'"            
       PREPARE luh_pb FROM l_sql
       DECLARE luh_curs CURSOR FOR luh_pb
       
       LET g_cnt_1 = 1 
       FOREACH luf_curs INTO g_luf[g_cnt_1].*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF  
         INSERT INTO luf_file VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,
                                     g_luf[g_cnt_1].luf03,g_luf[g_cnt_1].luf04)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('bring lnf_file:',SQLCA.SQLCODE,0)       
             EXIT FOREACH   
         END IF  
                 
         LET g_cnt_1 = g_cnt_1 + 1 
         IF  g_cnt_1 > g_max_rec THEN
            CALL cl_err('',9035,1)
            EXIT FOREACH 
         END IF                                      
       END FOREACH  
       
       LET g_cnt_1 = 1 
       FOREACH lug_curs INTO g_lug[g_cnt_1].*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF  
         INSERT INTO lug_file VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,
                                     g_lug[g_cnt_1].lug03,g_lug[g_cnt_1].lug04,
                                     g_lug[g_cnt_1].lug05,g_lug[g_cnt_1].lug06,
                                     g_lug[g_cnt_1].lug07)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('bring lng_file:',SQLCA.SQLCODE,0)       
             EXIT FOREACH   
         END IF  
                 
         LET g_cnt_1 = g_cnt_1 + 1 
         IF  g_cnt_1 > g_max_rec THEN
            CALL cl_err('',9035,1)
            EXIT FOREACH 
         END IF                                      
       END FOREACH 
       
       LET g_cnt_1 = 1 
       FOREACH luh_curs INTO g_luh[g_cnt_1].*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF  
         INSERT INTO luh_file (luh00,luh01,luh02,luhstore,luhlegal,luh04,luh05,luh06,luh07) #FUN-AB0096
                              VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,     
                                     g_luh[g_cnt_1].luhstore,g_luh[g_cnt_1].luhlegal,       #FUN-AB0096
                                     g_luh[g_cnt_1].luh04,
                                     g_luh[g_cnt_1].luh05,g_luh[g_cnt_1].luh06,
                                     g_luh[g_cnt_1].luh07)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('bring lnh_file:',SQLCA.SQLCODE,0)       
             EXIT FOREACH   
         END IF  
                 
         LET g_cnt_1 = g_cnt_1 + 1 
         IF  g_cnt_1 > g_max_rec THEN
            CALL cl_err('',9035,1)
            EXIT FOREACH 
         END IF                                      
       END FOREACH                   
END FUNCTION 
 
FUNCTION t310_copy()
DEFINE l_newno   LIKE lue_file.lue01
DEFINE l_oldno   LIKE lue_file.lue01
DEFINE l_lue02   LIKE lue_file.lue02
DEFINE l_luu     LIKE type_file.num5
DEFINE w_lue01   LIKE lue_file.lue01
DEFINE w_lue02   LIKE lue_file.lue02
DEFINE g_code    LIKE lue_file.lue04
 
    IF cl_null(g_lue.lue01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
     IF cl_null(g_lue.lue02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
     LET w_lue01  = g_lue.lue01
     LET w_lue02  = g_lue.lue02
   
    LET g_before_input_done = FALSE
    CALL t310_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lue01
 
        AFTER FIELD lue01 
          IF NOT cl_null(l_newno) THEN           
             CALL t310_check_lue01(l_newno) 
             IF g_success = 'N' THEN                                                                                  
                DISPLAY BY NAME g_lue.lue01                                                                                 
                NEXT FIELD lue01                                                                                            
              END IF
          ELSE 
          	 CALL cl_err(l_newno,'alm-062',1)
          	 NEXT FIELD lue01    
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
       
       ON ACTION controlp
          CASE  
           WHEN INFIELD(lue01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lne10"  
            LET g_qryparam.default1 = l_newno
            LET g_qryparam.default2 = l_lue02
            CALL cl_create_qry() RETURNING l_newno,l_lue02
            LET l_luu  =  l_lue02 + 1
            LET g_lue.lue02    =  l_luu
            DISPLAY l_newno,g_lue.lue02 TO lue01,lue02
            NEXT FIELD lue01 
         OTHERWISE 
          EXIT CASE
        END CASE   
         
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_lue.lue01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lue_file
     WHERE lue01 = g_lue.lue01
       AND lue02 = g_lue.lue02
      INTO TEMP x
    UPDATE x
        SET lue01=l_newno,
            lue02=g_lue.lue02,   
            lueuser=g_user, 
            luegrup=g_grup, 
            luemodu=NULL, 
            luedate=NULL,  
            luecrat=g_today,  
            lue34   = 'N',
            lue35   = '0',
            lue36   = 'N',
            lue37   = NULL,
            lue38   = NULL,
            lue55   = 'N',
            lue25   = NULL,
            lue26   = NULL,
            lue20   = NULL    
    INSERT INTO lue_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lue.lue01
       LET g_lue.lue01 = l_newno
       SELECT * INTO g_lue.*
         FROM lue_file
        WHERE lue01 = l_newno
          AND lue02 = g_lue.lue02
       CALL t310_u('c','')  
       UPDATE lue_file SET lue25 = g_lue.lue25,
                           lue26 = g_lue.lue26,
                           lue30 = g_lue.lue30
        WHERE lue01 = l_newno
          AND lue02 = g_lue.lue02         
       LET g_code = g_lue.lue04 
       #FUN-C30027---begin      
       #SELECT * INTO g_lue.*
       #  FROM lue_file    
       # WHERE lue01  = l_oldno
       #   AND lue02  = w_lue02
       #FUN-C30027---end
    END IF
    #LET g_lue.lue01 = l_oldno  #FUN-C30027
    #LET g_lue.lue02 = w_lue02  #FUN-C30027
    CALL t310_show()  
 
    CALL t310_c(w_lue01,w_lue02,l_newno,g_code)
END FUNCTION
 
FUNCTION t310_c(p_cmd,w_cmd,c_cmd,c_code)
  DEFINE g_sql   STRING
  DEFINE g_cnt   LIKE type_file.num5
  DEFINE c_cmd  LIKE lue_file.lue01
  DEFINE p_cmd    LIKE  lue_file.lue01
  DEFINE w_cmd   LIKE   lue_file.lue02
  DEFINE c_code LIKE lue_file.lue04
 
  DEFINE l_luf   DYNAMIC ARRAY OF RECORD           
             luf03   LIKE luf_file.luf03,
             luf04   LIKE luf_file.luf04       
                    END RECORD 
  DEFINE l_lug   DYNAMIC ARRAY OF RECORD
              lug03   LIKE lug_file.lug03,
              lug04   LIKE lug_file.lug04,
              lug05   LIKE lug_file.lug05,
              lug06   LIKE lug_file.lug06,
              lug07   LIKE lug_file.lug07
                 END RECORD 
  DEFINE l_luh   DYNAMIC ARRAY OF RECORD 
              luhstore LIKE luh_file.luhstore, #FUN-AB0096
              luh04   LIKE luh_file.luh04,
              luh05   LIKE luh_file.luh05,
              luh06   LIKE luh_file.luh06,
              luh07   LIKE luh_file.luh07
                 END RECORD   
 
                 
  LET g_sql  = "select luf03,luf04 from luf_file ",
               " where ",
               "  luf01 = '",p_cmd,"' ",
               " and luf02 = '",w_cmd,"' " 
    PREPARE c_1 FROM g_sql
    DECLARE c1_curs CURSOR FOR c_1
 
    CALL l_luf.clear()
    LET g_cnt = 1
    FOREACH c1_curs INTO l_luf[g_cnt].*  
    
       IF NOT cl_null(l_luf[g_cnt].luf03) THEN
          INSERT INTO luf_file(luf00,luf01,luf02,luf03,luf04)
          VALUES(c_code,c_cmd,g_lue.lue02,l_luf[g_cnt].luf03,l_luf[g_cnt].luf04) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH                         
   ############################
   LET g_sql  = "select lug03,lug04,lug05,lug06,lug07 from lug_file ",
               " where ",
               " lug01 = '",p_cmd,"' ",
               " and lug02 = '",w_cmd,"' " 
    PREPARE c_2 FROM g_sql
    DECLARE c2_curs CURSOR FOR c_2
 
    CALL l_lug.clear()
    LET g_cnt = 1
    FOREACH c2_curs INTO l_lug[g_cnt].*  
    
       IF NOT cl_null(l_lug[g_cnt].lug03) AND NOT cl_null(l_lug[g_cnt].lug04) THEN
          INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
          VALUES(c_code,c_cmd,g_lue.lue02,l_lug[g_cnt].lug03,l_lug[g_cnt].lug04,
                 l_lug[g_cnt].lug05,l_lug[g_cnt].lug06,l_lug[g_cnt].lug07) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH     
    #######################
     LET g_sql  = "select luhstore,luh04,luh05,luh06,luh07 from luh_file ", #FUN-AB0096
               " where ",
               "  luh01 = '",p_cmd,"' ",
               " and luh02 = '",w_cmd,"' " 
    PREPARE c_3 FROM g_sql
    DECLARE c3_curs CURSOR FOR c_3
 
    CALL l_luh.clear()
    LET g_cnt = 1
    FOREACH c3_curs INTO l_luh[g_cnt].*  
    
       IF NOT cl_null(l_luh[g_cnt].luhstore)  THEN #FUN-AB0096
          INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luh04,luh05,luh06,luh07) #FUN-AB0096
          VALUES(c_code,c_cmd,g_lue.lue02,l_luh[g_cnt].luhstore,l_luh[g_cnt].luh04,#FUN-AB0096
                 l_luh[g_cnt].luh05,l_luh[g_cnt].luh06,l_luh[g_cnt].luh07) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH                       
 
END FUNCTION 
 
FUNCTION update_i300()
DEFINE g_sql     STRING
DEFINE g_cnt     LIKE type_file.num5
DEFINE l_occpos  LIKE occ_file.occpos #FUN-B40071
 
 DEFINE l_luf   DYNAMIC ARRAY OF RECORD  
             luf03   LIKE luf_file.luf03,
             luf04   LIKE luf_file.luf04       
                    END RECORD 
  DEFINE l_lug   DYNAMIC ARRAY OF RECORD
              lug03   LIKE lug_file.lug03,
              lug04   LIKE lug_file.lug04,
              lug05   LIKE lug_file.lug05,
              lug06   LIKE lug_file.lug06,
              lug07   LIKE lug_file.lug07
                 END RECORD 
  DEFINE l_luh   DYNAMIC ARRAY OF RECORD 
              luhstore LIKE luh_file.luhstore, #FUN-AB0096
              luhlegal LIKE luh_file.luhlegal,
              luh04   LIKE luh_file.luh04,
              luh05   LIKE luh_file.luh05,
              luh06   LIKE luh_file.luh06,
              luh07   LIKE luh_file.luh07
                 END RECORD  
  DEFINE l_exit    LIKE type_file.num5    #FUN-A60064 

  BEGIN WORK             #No.FUN-A60064 Add
  LET g_success = 'Y'    #No.FUN-A60064 Add
  CALL s_showmsg_init()  #No.FUN-A60064 Add
 
  UPDATE lne_file
     SET lne02 = g_lue.lue02,lne03 = g_lue.lue03,lne04 = g_lue.lue04,lne05 = g_lue.lue05,
         lne06 = g_lue.lue06,lne07 = g_lue.lue07,lne08 = g_lue.lue08,lne09 = g_lue.lue09,
         lne10 = g_lue.lue10,lne12 = g_lue.lue12,lne13 = g_lue.lue13,lne14 = g_lue.lue14,
         lne15 = g_lue.lue15,lne16 = g_lue.lue16,lne17 = g_lue.lue17,lne18 = g_lue.lue18,
         lne19 = g_lue.lue19,lne20 = g_lue.lue20,lne21 = g_lue.lue21,lne22 = g_lue.lue22,
         lne23 = g_lue.lue23,lne24 = g_lue.lue24,lne25 = g_lue.lue25,lne26 = g_lue.lue26,
         lne27 = g_lue.lue27,lne28 = g_lue.lue28,lne29 = g_lue.lue29,lne30 = g_lue.lue30,
         lne31 = g_lue.lue31,lne32 = g_lue.lue32,lne33 = g_lue.lue33,lne34 = g_lue.lue34,
         lne35 = g_lue.lue35,lne36 = g_lue.lue36,lne37 = g_lue.lue37,lne38 = g_lue.lue38,
         lne39 = g_lue.lue39,lne40 = g_lue.lue40,lne41 = g_lue.lue41,lne42 = g_lue.lue42,
         lne43 = g_lue.lue43,lne44 = g_lue.lue44,lne45 = g_lue.lue45,lne46 = g_lue.lue46,
         lne47 = g_lue.lue47,lne48 = g_lue.lue48,lne49 = g_lue.lue49,lne50 = g_lue.lue50,
         lne51 = g_lue.lue51,lne52 = g_lue.lue52,lne53 = g_lue.lue53,lne54 = g_lue.lue54,
         lne56 = g_lue.lue57,lne57 = g_lue.lue58,lne55 = g_lue.lue56,lne58 = g_lue.lue59,
         lne59 = g_lue.lue60,
         lneuser = g_lue.lueuser,lnegrup = g_lue.luegrup,lnecrat = g_lue.luecrat,
         lnemodu = g_lue.luemodu,lnedate = g_lue.luedate,
         lne61 = g_lue.lue61,lne62 = g_lue.lue62,lne63 = g_lue.lue63,lne64 = g_lue.lue64,  #FUN-A80073 ---ADD---
         lne65 = g_lue.lue65,lne66 = g_lue.lue66                                           #FUN-A80073 ---ADD---        
     WHERE lne01 = g_lue.lue01   

  #-----MOD-A30099--------- 
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
    #CALL cl_err3("upd","lne_file",g_lue.lue01,"",SQLCA.sqlcode,"","",1) #No.FUN-A60064
     CALL s_errmsg('lue01',g_lue.lue01,'upd lne',SQLCA.sqlcode,1)        #No.FUN-A60064
     LET g_success = 'N'                                                 #No.FUN-A60064
  END IF
  #-----END MOD-A30099-----

  #FUN-B40071 --START--
  SELECT occpos INTO l_occpos FROM occ_file
    WHERE occ01 = g_lue.lue01 
  IF l_occpos <> '1' THEN
     LET l_occpos = '2' 
  ELSE
     LET l_occpos = '1' 
  END if
  #FUN-B40071 --END--
  
  ######UPDATE occ_file
   UPDATE occ_file
      SET occ02 = g_lue.lue05,
          occ03 = g_lue.lue62,             #FUN-A80073 ---ADD---
          occ06 = g_lue.lue63,             #FUN-A80073 ---ADD---
         #occ07 = g_lue.lue01,             #FUN-A80073 ---MARK--- 
          occ07 = g_lue.lue64,             #FUN-A80073 ---ADD---  
         #occ09 = g_lue.lue01,             #FUN-A80073 ---MARK---
          occ09 = g_lue.lue65,             #FUN-A80073 ---ADD---  
          occ11 = g_lue.lue56,             #FUN-AA0078 add
          occ18 = g_lue.lue06,
          occ231 = g_lue.lue49,
          occ246 = g_lue.lue04,
          occ67 = g_lue.lue57,
          occ55 = g_lue.lue66,             #FUN-A80073 ---ADD--- 
          occ62 = NULL,                    #FUN-A80073 ---ADD--- 
          occ71 = '2',                     #FUN-A80073 ---ADD--- 
          occ72 = '0',                     #FUN-A80073 ---ADD--- 
          occ73 = 'N',                     #FUN-A80073 ---ADD--- 
          occ930 = g_lue.lue61,            #FUN-A80073 ---ADD--- 
          occ1022 = g_lue.lue01,           #FUN-A80073 ---ADD---
          occ1027 = 'N',                   #FUN-A80073 ---ADD--- 
          occpos = l_occpos,               #FUN-A80073 ---ADD--- #FUN-B40071 
          occ41 = g_lue.lue40,
          occ42 = g_lue.lue58,
          occ45 = g_lue.lue42,
          occuser = g_lue.lueuser,
          occgrup = g_lue.luegrup,
          occmodu = g_lue.luemodu,
          occdate = g_lue.luedate 
    WHERE occ01 = g_lue.lue01 
  #-----MOD-A30099--------- 
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
    #CALL cl_err3("upd","occ_file",g_lue.lue01,"",SQLCA.sqlcode,"","",1) #No.FUN-A60064 
     CALL s_errmsg('lue01',g_lue.lue01,'upd occ',SQLCA.sqlcode,1)        #No.FUN-A60064 
     LET g_success = 'N'                                                 #No.FUN-A60064
  END IF
  #-----END MOD-A30099-----
 
  LET g_lue.lue55 = 'Y'   
  UPDATE lue_file
     SET lue55 = 'Y'
   WHERE lue01 = g_lue.lue01
     AND lue02 = g_lue.lue02  
  #-----MOD-A30099--------- 
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
  #  CALL cl_err3("upd","lue_file",g_lue.lue01,g_lue.lue02,SQLCA.sqlcode,"","",1) #No.FUN-A60064
     CALL s_errmsg('lue01',g_lue.lue01,'upd lue',SQLCA.sqlcode,1)        #No.FUN-A60064
     LET g_success = 'N'                                                 #No.FUN-A60064
  END IF
  #-----END MOD-A30099-----

#FUN-A60064 add begin
  LET l_exit = 0
  SELECT count(*) INTO l_exit FROM lnf_file
   WHERE lnf01 = g_lue.lue01
  IF l_exit > 0 THEN
#FUN-A60064 add end     
     ######UPDATE ACTION
     DELETE FROM lnf_file
      WHERE lnf01 = g_lue.lue01
     #-----MOD-A30099--------- 
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #  CALL cl_err3("del","lnf_file",g_lue.lue01,"",SQLCA.sqlcode,"","",1) #No.FUN-A60064
        CALL s_errmsg('lue01',g_lue.lue01,'del lnf',SQLCA.sqlcode,1)        #No.FUN-A60064
        LET g_success = 'N'                                                 #No.FUN-A60064
     END IF
     #-----END MOD-A30099-----
  END IF #FUN-A60064 add
      
   LET g_sql  = "select luf03,luf04 from luf_file ",
               " where",
               "  luf01 = '",g_lue.lue01,"' ",
               " and luf02 = '",g_lue.lue02,"' " 
    PREPARE c1 FROM g_sql
    DECLARE c1curs CURSOR FOR c1
 
    CALL l_luf.clear()
    LET g_cnt = 1
    FOREACH c1curs INTO l_luf[g_cnt].*  
    
       IF NOT cl_null(l_luf[g_cnt].luf03) THEN
          INSERT INTO lnf_file(lnf00,lnf01,lnf02,lnf03,lnf04)
          VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,l_luf[g_cnt].luf03,l_luf[g_cnt].luf04)
          #-----MOD-A30099---------
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          #  CALL cl_err3("ins","lnf_file",g_lue.lue01,l_luf[g_cnt].luf03,SQLCA.sqlcode,"","",1) #No.FUN-A60064
             CALL s_errmsg('lue01',g_lue.lue01,'ins lnf',SQLCA.sqlcode,1)        #No.FUN-A60064
             LET g_success = 'N'                                                 #No.FUN-A60064
             EXIT FOREACH
          END IF
          #-----END MOD-A30099-----
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH                        

#FUN-A60064 add begin
   LET l_exit = 0
   SELECT count(*) INTO l_exit FROM lng_file
    WHERE lng01 = g_lue.lue01
   IF l_exit > 0 THEN
#FUN-A60064 add end 
      ############################
      DELETE FROM lng_file
       WHERE lng01  = g_lue.lue01
      #-----MOD-A30099--------- 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      #  CALL cl_err3("del","lng_file",g_lue.lue01,"",SQLCA.sqlcode,"","",1) #No.FUN-A60064
         CALL s_errmsg('lue01',g_lue.lue01,'del lng',SQLCA.sqlcode,1)        #No.FUN-A60064
         LET g_success = 'N'                                                 #No.FUN-A60064
      END IF
      #-----END MOD-A30099-----
   END IF  #FUN-A60064 add
   LET g_sql  = "select lug03,lug04,lug05,lug06,lug07 from lug_file ",
               " where ",
               "  lug01 = '",g_lue.lue01,"' ",
               " and lug02 = '",g_lue.lue02,"' " 
    PREPARE c2 FROM g_sql
    DECLARE c2curs CURSOR FOR c2
 
    CALL l_lug.clear()
    LET g_cnt = 1
    FOREACH c2curs INTO l_lug[g_cnt].*  
    
       IF NOT cl_null(l_lug[g_cnt].lug03) AND NOT cl_null(l_lug[g_cnt].lug04) THEN
          INSERT INTO lng_file(lng00,lng01,lng02,lng03,lng04,lng05,lng06,lng07)
          VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,l_lug[g_cnt].lug03,l_lug[g_cnt].lug04,
                 l_lug[g_cnt].lug05,l_lug[g_cnt].lug06,l_lug[g_cnt].lug07) 
          #-----MOD-A30099---------
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          #  CALL cl_err3("ins","lng_file",g_lue.lue01,l_lug[g_cnt].lug03,SQLCA.sqlcode,"","",1) #No.FUN-A60064
             CALL s_errmsg('lue01',g_lue.lue01,'ins lng',SQLCA.sqlcode,1)        #No.FUN-A60064
             LET g_success = 'N'                                                 #No.FUN-A60064
             EXIT FOREACH
          END IF
          #-----END MOD-A30099-----
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH     
#FUN-A60064 add begin
    LET l_exit = 0
    SELECT count(*) INTO l_exit FROM lnh_file
     WHERE lnh01 = g_lue.lue01
    IF l_exit > 0 THEN
#FUN-A60064 add end
       #######################
       DELETE FROM lnh_file
        WHERE lnh01  = g_lue.lue01
       #-----MOD-A30099--------- 
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       #  CALL cl_err3("del","lnh_file",g_lue.lue01,"",SQLCA.sqlcode,"","",1) #No.FUN-A60064
          CALL s_errmsg('lue01',g_lue.lue01,'del lnh',SQLCA.sqlcode,1)        #No.FUN-A60064
          LET g_success = 'N'                                                 #No.FUN-A60064
       END IF
       #-----END MOD-A30099-----
     END IF  #FUN-A60064 add
     LET g_sql  = "select luhstore,luhlegal,luh04,luh05,luh06,luh07 from luh_file ", #FUN-AB0096
               " where ",
               "  luh01 = '",g_lue.lue01,"' ",
               " and luh02 = '",g_lue.lue02,"' " 
    PREPARE c3 FROM g_sql
    DECLARE c3curs CURSOR FOR c3
 
    CALL l_luh.clear()
    LET g_cnt = 1
    FOREACH c3curs INTO l_luh[g_cnt].*  
    
       IF NOT cl_null(l_luh[g_cnt].luhstore)  THEN #FUN-AB0096
          INSERT INTO lnh_file(lnh00,lnh01,lnh02,lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07)
          VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,l_luh[g_cnt].luhstore,l_luh[g_cnt].luhlegal, #FUN-AB0096
                 l_luh[g_cnt].luh04,
                 l_luh[g_cnt].luh05,l_luh[g_cnt].luh06,l_luh[g_cnt].luh07) 
          #-----MOD-A30099---------
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          #  CALL cl_err3("ins","lnh_file",g_lue.lue01,l_luh[g_cnt].luhplant,SQLCA.sqlcode,"","",1) #No.FUN-A60064
             CALL s_errmsg('lue01',g_lue.lue01,'ins lnh',SQLCA.sqlcode,1)        #No.FUN-A60064
             LET g_success = 'N'                                                 #No.FUN-A60064
             EXIT FOREACH
          END IF
          #-----END MOD-A30099-----
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH
   #No.FUN-A60064 -BEGIN-----
    CALL s_showmsg()
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
   #No.FUN-A60064 -END-------
END FUNCTION

#FUN-B90056 Add Begin ---
FUNCTION t310_cer_confirm()
   
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lue.* FROM lue_file WHERE lue01 = g_lue.lue01 AND lue02 = g_lue.lue02
   IF g_lue.lue60 = 'Y' THEN
      CALL cl_err('','alm-735',0)
      RETURN
   END IF 

   IF g_lue.lue02 = '0' THEN
      CALL cl_err('','alm-743',0)
      RETURN
   END IF

   LET g_success = 'Y'

   BEGIN WORK
   
   OPEN t310_cl USING g_lue.lue01,g_lue.lue02
   IF STATUS THEN
      CALL cl_err("open t310_cl:",STATUS,1)
      CLOSE t310_cl
      ROLLBACK WORK 
      RETURN
   END IF
   
   FETCH t310_cl INTO g_lue.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF 

   IF NOT cl_confirm('alm-734') THEN
      RETURN
   ELSE   
      UPDATE lue_file SET lue60 = 'Y'
       WHERE lue01 = g_lue.lue01 AND lue02 = g_lue.lue02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_lue.lue01,SQLCA.sqlcode,0)
         LET g_success = 'N'
      END IF
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT * INTO g_lue.* FROM lue_file WHERE lue01 = g_lue.lue01 AND lue02 = g_lue.lue02
   CALL t310_show()
   CLOSE t310_cl
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t310_upd_image()
DEFINE l_lue01_image   STRING

   OPEN WINDOW t310_w1 WITH FORM "alm/42f/almt310_a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almt310_a")

   LET g_doc.column1 = "lue01"
   LET g_doc.value1 = g_lue.lue01,"|",g_lue.lue02
   CALL cl_get_fld_doc("lue01")

   MENU ""
      ON ACTION upd_image
          IF g_lue.lue02 = '0' THEN
             CALL cl_err('','alm-743',0)
          ELSE
             IF g_lue.lue36 = 'Y' THEN
                CALL cl_err('','alm-027',1)
             ELSE
                LET g_doc.column1 = "lue01"
                LET g_doc.value1 = g_lue.lue01,"|",g_lue.lue02
                CALL cl_fld_doc("lue01")
             END IF
          END IF

      ON ACTION help
          CALL cl_show_help()

      ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU

      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about
          CALL cl_about()

      ON ACTION close
          LET INT_FLAG=FALSE
          LET g_action_choice = "exit"
         EXIT MENU
   END MENU
   CLOSE WINDOW t310_w1
END FUNCTION
#FUN-B90056 Add ENd -----

#FUN-B90056 Add Begin ---
FUNCTION t310_b()
DEFINE
       l_ac1_t         LIKE type_file.num5,
       l_ac2_t         LIKE type_file.num5,
       l_ac3_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
DEFINE l_lue36         LIKE lue_file.lue36
DEFINE l_tqa02         LIKE tqa_file.tqa02
DEFINE l_tqa03         LIKE tqa_file.tqa03
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
DEFINE l_geo02         LIKE geo_file.geo02
DEFINE l_geoacti       LIKE geo_file.geoacti
DEFINE l_rtz28         LIKE rtz_file.rtz28
DEFINE l_rtz13         LIKE rtz_file.rtz13

   IF s_shut(0) THEN RETURN END IF

   SELECT lue36 INTO l_lue36 FROM lue_file
    WHERE lue01 = g_lue.lue01
      AND lue02 = g_lue.lue02
   IF (l_lue36 = 'Y' OR l_lue36 = 'X') THEN
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL
       RETURN
   END IF

   CALL cl_opmsg('b')
   LET g_action_choice = ""

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT lug03,'',lug04,lug05,lug06,lug07",
                      "  FROM lug_file WHERE  ",
                      "  lug01= '",g_lue.lue01,"' and lug02 = '",g_lue.lue02,"' and lug03 = ? and lug04 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT luf03,'',luf04,''",
                      "  FROM luf_file WHERE  " ,
                      "    luf01= '",g_lue.lue01,"' " ,
                      "   and luf02 = '",g_lue.lue02,"'",
                      "   and luf03 = ? " ,
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT luhstore,'',luhlegal,'',luh04,luh05,luh06,luh07",
                      "  FROM luh_file WHERE  ",
                      "  luh01= '",g_lue.lue01,"' and luh02 = '",g_lue.lue02,"' and luhstore = ?  ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR


   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT ARRAY g_lug FROM s_lug.*
        ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

          BEFORE INPUT
             IF g_rec_b1 != 0 THEN
                CALL fgl_set_arr_curr(l_ac1)
             END IF

          BEFORE ROW
             LET p_cmd=''
             LET l_ac1 = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()

             IF g_rec_b1>=l_ac1 THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                CALL t3102_set_entry(p_cmd)
                CALL t3102_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                LET g_lug_t.* = g_lug[l_ac1].*
                OPEN t3102_bcl USING g_lug_t.lug03,g_lug_t.lug04
                IF STATUS THEN
                   CALL cl_err("OPEN t3102_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t3102_bcl INTO g_lug[l_ac1].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_lug_t.lug03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL t310_lug03('d')
                   END IF
                END IF
                CALL cl_show_fld_cont()
             END IF

          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             LET g_before_input_done = FALSE
             CALL t3102_set_entry(p_cmd)
             CALL t3102_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             INITIALIZE g_lug[l_ac1].* TO NULL
             LET g_lug_t.* = g_lug[l_ac1].*
             CALL cl_show_fld_cont()
             NEXT FIELD lug03

          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE t3102_bcl
                CANCEL INSERT
             END IF
            INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
            VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_lug[l_ac1].lug03,g_lug[l_ac1].lug04,
                   g_lug[l_ac1].lug05,g_lug[l_ac1].lug06,g_lug[l_ac1].lug07)
             
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","lug_file",g_lug[l_ac1].lug03,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b1=g_rec_b1+1
                DISPLAY g_rec_b1 TO FORMONLY.cn3
                COMMIT WORK
             END IF
                   
          AFTER FIELD lug03           
             IF NOT cl_null(g_lug[l_ac1].lug03) THEN
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lug[l_ac1].lug03 <> g_lug_t.lug03) THEN
                   IF NOT cl_null(g_lug[l_ac1].lug04) THEN
                      LET l_n = 0
                     #FUN-B90056 Add&Mark Begin ---
                     #SELECT COUNT(*) INTO l_n FROM lug_file
                     # WHERE lug01 = g_lue.lue01
                     #   AND lug02 = g_lue.lue02
                     #   AND lug03 = g_lug[l_ac1].lug03
                     #   AND lug04 = g_lug[l_ac1].lug04
                      SELECT COUNT(*) INTO l_n FROM lng_file
                       WHERE lng03 = g_lug[l_ac1].lug03
                         AND lng04 = g_lug[l_ac1].lug04
                         AND lng01 <> g_lue.lue01
                     #FUN-B90056 Add&Mark End -----
                      IF l_n > 0 THEN
                         CALL cl_err('','alm-151',0)
                         DISPLAY g_lug_t.lug03 TO lug03
                         NEXT FIELD lug03
                      END IF
                   END IF
                   CALL t310_lug03('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_lug[l_ac1].lug03 = g_lug_t.lug03
                      NEXT FIELD lug03
                   END IF
                END IF
             END IF   
                      
          AFTER FIELD lug04
             IF NOT cl_null(g_lug[l_ac1].lug04) THEN
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lug[l_ac1].lug04 <> g_lug_t.lug04) THEN
                   IF NOT cl_null(g_lug[l_ac1].lug03) THEN
                      LET l_n = 0
                     #FUN-B90056 Add&Mark Begin ---
                     #SELECT COUNT(*) INTO l_n FROM lug_file
                     # WHERE lug01 = g_lue.lue01
                     #   AND lug02 = g_lue.lue02
                     #   AND lug03 = g_lug[l_ac1].lug03
                     #   AND lug04 = g_lug[l_ac1].lug04
                      SELECT COUNT(*) INTO l_n FROM lng_file
                       WHERE lng03 = g_lug[l_ac1].lug03
                         AND lng04 = g_lug[l_ac1].lug04
                         AND lng01 <> g_lue.lue01
                     #FUN-B90056 Add&Mark End ----- 
                      IF l_n > 0 THEN 
                         CALL cl_err('','alm-151',0)
                         LET g_lug[l_ac1].lug04 = g_lug_t.lug04
                         NEXT FIELD lug04
                      END IF
                   END IF
                END IF
             END IF   
             
          AFTER FIELD lug06
             IF NOT cl_null(g_lug[l_ac1].lug06) THEN
                IF cl_null(g_lug[l_ac1].lug07) THEN
                   CALL cl_err('','alm-153',0)
                   NEXT FIELD lug07
                ELSE
                   IF g_lug[l_ac1].lug06 > g_lug[l_ac1].lug07 THEN
                      CALL cl_err('','alm-152',0)
                      NEXT FIELD lug06
                   END IF
                END IF
             ELSE
                IF NOT cl_null(g_lug[l_ac1].lug07) THEN
                   CALL cl_err('','alm-154',0)
                   NEXT FIELD lug06
                END IF
             END IF

          AFTER FIELD lug07
             IF NOT cl_null(g_lug[l_ac1].lug07) THEN
                IF cl_null(g_lug[l_ac1].lug06) THEN
                   CALL cl_err('','alm-154',0)
                   NEXT FIELD lug06
                ELSE
                   IF g_lug[l_ac1].lug07 < g_lug[l_ac1].lug06 THEN
                      CALL cl_err('','alm-155',0)
                      NEXT FIELD lug07
                   END IF
                END IF
             ELSE
                IF NOT cl_null(g_lug[l_ac1].lug06) THEN
                   CALL cl_err('','alm-153',0)
                   NEXT FIELD lug07
                END IF
             END IF

          BEFORE DELETE
             IF (g_lug_t.lug03 IS NOT NULL) AND (g_lug_t.lug04 IS NOT NULL) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL           
                LET g_doc.column1 = "lug03"          
                LET g_doc.value1 = g_lug[l_ac1].lug03
                CALL cl_del_doc()                    
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE 
                END IF
                DELETE FROM lug_file WHERE lug03 = g_lug_t.lug03
                                       AND lug04 = g_lug_t.lug04
                                       AND lug01 = g_lue.lue01
                                       AND lug02 = g_lue.lue02
                      
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","lug_file",g_lug_t.lug03,"",SQLCA.sqlcode,"","",1)
                   EXIT DIALOG
                END IF 
                LET g_rec_b1=g_rec_b1-1
                DISPLAY g_rec_b1 TO FORMONLY.cn3
                COMMIT WORK
             END IF
              
          ON ROW CHANGE
             IF INT_FLAG THEN                 #新增程式段
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_lug[l_ac1].* = g_lug_t.*
                CLOSE t3102_bcl
                ROLLBACK WORK 
                EXIT DIALOG
             END IF
              
             IF l_lock_sw="Y" THEN
                CALL cl_err(g_lug[l_ac1].lug03,-263,0)
                LET g_lug[l_ac1].* = g_lug_t.*
             ELSE  
                UPDATE lug_file SET lug00=g_lue.lue04,
                                    lug03=g_lug[l_ac1].lug03,
                                    lug04=g_lug[l_ac1].lug04,
                                    lug05=g_lug[l_ac1].lug05,
                                    lug06=g_lug[l_ac1].lug06,
                                    lug07=g_lug[l_ac1].lug07
                 WHERE lug03 = g_lug_t.lug03
                   AND lug04 = g_lug_t.lug04
                   AND lug01 = g_lue.lue01
                   AND lug02 = g_lue.lue02
                    
                IF SQLCA.sqlcode THEN                                       
                   CALL cl_err3("upd","lug_file",g_lug_t.lug03,"",SQLCA.sqlcode,"","",1)
                   LET g_lug[l_ac1].* = g_lug_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF

          AFTER ROW
             LET l_ac1 = ARR_CURR()            # 新增
             LET l_ac1_t = l_ac1                # 新增

             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_lug[l_ac1].* = g_lug_t.*
                ELSE
                   CALL g_lug.deleteElement(l_ac1)
                END IF
                CLOSE t3102_bcl            # 新增
                ROLLBACK WORK         # 新增
                EXIT DIALOG
             END IF

             CLOSE t3102_bcl            # 新增
             COMMIT WORK

          ON ACTION controlp
             CASE
                WHEN INFIELD(lug03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_tqa"
                     LET g_qryparam.arg1 = '24'
                     LET g_qryparam.default1 = g_lug[l_ac1].lug03
                     CALL cl_create_qry() RETURNING g_lug[l_ac1].lug03
                     DISPLAY g_lug[l_ac1].lug03 TO lug03
                     NEXT FIELD lug03

             END CASE

          ON ACTION accept
             ACCEPT DIALOG

          ON ACTION cancel
             IF p_cmd = 'a' THEN
                CALL g_lug.deleteElement(l_ac1)
             END IF
             EXIT DIALOG

          ON ACTION CONTROLO                        #沿用所有欄位
             IF INFIELD(lug03) AND l_ac1 > 1 THEN
                LET g_lug[l_ac1].* = g_lug[l_ac1-1].*
                NEXT FIELD lug03
             END IF

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      END INPUT

      INPUT ARRAY g_luf FROM s_luf.*
        ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

          BEFORE INPUT
             IF g_rec_b2 != 0 THEN
                CALL fgl_set_arr_curr(l_ac2)
             END IF

          BEFORE ROW
             LET p_cmd=''
             LET l_ac2 = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()

             IF g_rec_b2>=l_ac2 THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                CALL t3101_set_entry(p_cmd)
                CALL t3101_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                LET g_luf_t.* = g_luf[l_ac2].*
                OPEN t3101_bcl USING g_luf_t.luf03
                IF STATUS THEN
                   CALL cl_err("OPEN t310_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t3101_bcl INTO g_luf[l_ac2].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_luf_t.luf03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT tqa02 INTO l_tqa02 FROM tqa_file
                       WHERE tqa01 = g_luf[l_ac2].luf03
                         AND tqa03 = '2'
                         AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                         AND tqaacti = 'Y'
                      LET g_luf[l_ac2].tqa02_2 = l_tqa02
                     #TQC-C40051 mark START 
                     #SELECT geo02 INTO l_geo02 FROM geo_file
                     # WHERE geo01 = g_luf[l_ac2].luf04
                     #   AND geoacti  = 'Y'
                     #TQC-C40051 mark END
                     #TQC-C40051 add START
                      SELECT oqw02 INTO l_geo02 FROM oqw_file
                       WHERE oqw01 = g_luf[l_ac2].luf04
                         AND oqwacti  = 'Y'
                     #TQC-C40051 add END
                      LET g_luf[l_ac2].geo02_2 = l_geo02
                   END IF
                END IF
                CALL cl_show_fld_cont()
             END IF 
                
          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'                   
             LET g_before_input_done = FALSE      
             CALL t3101_set_entry(p_cmd)
             CALL t3101_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE
             INITIALIZE g_luf[l_ac2].* TO NULL
             LET g_luf_t.* = g_luf[l_ac2].*        
             CALL cl_show_fld_cont()    
             NEXT FIELD luf03
              
          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE t3101_bcl 
                CANCEL INSERT
             END IF
             INSERT INTO luf_file(luf00,luf01,luf02,luf03,luf04)
             VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_luf[l_ac2].luf03,g_luf[l_ac2].luf04)

             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","luf_file",g_luf[l_ac2].luf03,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b2=g_rec_b2+1
                DISPLAY g_rec_b2 TO FORMONLY.cn4
                COMMIT WORK
             END IF

          AFTER FIELD luf03
             IF NOT cl_null(g_luf[l_ac2].luf03) THEN
                IF g_luf[l_ac2].luf03 != g_luf_t.luf03 OR
                   g_luf_t.luf03 IS NULL THEN
                   LET l_n = 0
                   SELECT count(*) INTO l_n FROM tqa_file
                    WHERE tqa01 = g_luf[l_ac2].luf03
                     AND tqa03 = '2'
                   IF l_n < 1 THEN
                      CALL cl_err('','alm1002',0)                  #NO.FUN-A70063
                      LET g_luf[l_ac2].luf03 = g_luf_t.luf03
                      NEXT FIELD luf03
                   ELSE
                      LET l_n = 0
                      SELECT count(*) INTO l_n FROM tqa_file
                      WHERE tqa01 = g_luf[l_ac2].luf03
                        AND tqa03 = '2'
                        AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                         OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                      IF l_n < 1 THEN
                         CALL cl_err('','alm1004',0)  
                         LET g_luf[l_ac2].luf03 = g_luf_t.luf03
                         NEXT FIELD luf03
                      ELSE
                         SELECT tqaacti INTO l_tqaacti FROM tqa_file
                          WHERE tqa01 = g_luf[l_ac2].luf03
                            AND tqa03 = '2'
                            AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                         IF l_tqaacti != 'Y' THEN
                            CALL cl_err('','alm-139',0)
                            LET g_luf[l_ac2].luf03 = g_luf_t.luf03
                            NEXT FIELD luf03   
                         ELSE
                             LET l_n = 0
                             SELECT COUNT(*) INTO l_n FROM luf_file
                              WHERE luf01 = g_lue.lue01
                                AND luf02 = g_lue.lue02     
                                AND luf03 = g_luf[l_ac2].luf03
                             IF l_n > 0 THEN 
                                CALL cl_err('','alm-167',0)
                                LET g_luf[l_ac2].luf03 = g_luf_t.luf03
                                DISPLAY BY NAME g_luf[l_ac2].luf03
                                NEXT FIELD luf03
                             ELSE
                                SELECT tqa02 INTO l_tqa02 FROM tqa_file
                                 WHERE tqa01 = g_luf[l_ac2].luf03
                                   AND tqa03 = '2' AND tqaacti = 'Y'
                                   AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                    OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                                LET g_luf[l_ac2].tqa02_2 = l_tqa02
                             END IF
                         END IF
                      END IF
                   END IF
                END IF
             END IF

         AFTER FIELD luf04
             IF NOT cl_null(g_luf[l_ac2].luf04) THEN
                IF g_luf[l_ac2].luf04 != g_luf_t.luf04 OR
                   g_luf_t.luf04 IS NULL THEN
                   LET l_n = 0
                  #TQC-C40051 mark START
                  #SELECT count(*) INTO l_n FROM geo_file
                  # WHERE geo01 = g_luf[l_ac2].luf04
                  #TQC-C40051 mark END
                  #TQC-C40051 add START
                   SELECT count(*) INTO l_n FROM oqw_file
                    WHERE oqw01 = g_luf[l_ac2].luf04
                  #TQC-C40051 add END
                   IF l_n < 1 THEN
                      CALL cl_err('','alm-124',0)
                      LET g_luf[l_ac2].luf04 = g_luf_t.luf04
                      NEXT FIELD luf04
                   ELSE
                     #TQC-C40051 mark START
                     #SELECT geoacti INTO l_geoacti FROM geo_file
                     # WHERE geo01 = g_luf[l_ac2].luf04
                     #TQC-C40051 mark END
                     #TQC-C40051 add START
                      SELECT oqwacti INTO l_geoacti FROM oqw_file
                       WHERE oqw01 = g_luf[l_ac2].luf04
                     #TQC-C40051 add END
                      IF l_geoacti != 'Y' THEN
                         CALL cl_err('','alm-100',0)
                         LET g_luf[l_ac2].luf04 = g_luf_t.luf04
                         NEXT FIELD luf04
                      ELSE
                        #TQC-C40051 mark START
                        #SELECT geo02 INTO l_geo02 FROM geo_file
                        # WHERE geo01 = g_luf[l_ac2].luf04
                        #TQC-C40051 mark END
                        #TQC-C40051 add START
                         SELECT oqw02 INTO l_geo02 FROM oqw_file
                          WHERE oqw01 = g_luf[l_ac2].luf04
                        #TQC-C40051 add END
                         LET g_luf[l_ac2].geo02_2 = l_geo02
                      END IF
                   END IF
                END IF
             END IF

          BEFORE DELETE
             IF g_luf_t.luf03 IS NOT NULL THEN
                IF NOT cl_delete() THEN   
                   CANCEL DELETE          
                END IF                     
                INITIALIZE g_doc.* TO NULL           
                LET g_doc.column1 = "luf03"          
                LET g_doc.value1 = g_luf[l_ac2].luf03
                CALL cl_del_doc()                    
                IF l_lock_sw = "Y" THEN  
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF 
                DELETE FROM luf_file WHERE luf01 = g_lue.lue01
                                       AND luf02 = g_lue.lue02
                                       AND luf03 = g_luf_t.luf03
                          
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","luf_file",g_luf_t.luf03,"",SQLCA.sqlcode,"","",1)
                   EXIT DIALOG
                END IF 
                LET g_rec_b2=g_rec_b2-1
                DISPLAY g_rec_b2 TO FORMONLY.cn4
                COMMIT WORK 
             END IF   
                      
          ON ROW CHANGE
             IF INT_FLAG THEN                 #新增程式段
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_luf[l_ac2].* = g_luf_t.* 
                CLOSE t3101_bcl
                ROLLBACK WORK
                EXIT DIALOG
             END IF     
                             
             IF l_lock_sw="Y" THEN
                CALL cl_err(g_luf[l_ac2].luf03,-263,0) 
                LET g_luf[l_ac2].* = g_luf_t.* 
             ELSE       
                UPDATE luf_file SET luf04=g_luf[l_ac2].luf04
                 WHERE luf03 = g_luf_t.luf03
                   AND luf01 = g_lue.lue01
                   AND luf02 = g_lue.lue02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","luf_file",g_luf_t.luf03,"",SQLCA.sqlcode,"","",1)
                   LET g_luf[l_ac2].* = g_luf_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF

          AFTER ROW
             LET l_ac2 = ARR_CURR()            # 新增
             LET l_ac2_t = l_ac2                # 新增

             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_luf[l_ac2].* = g_luf_t.*
                ELSE
                   CALL g_luf.deleteElement(l_ac2)
                END IF
                CLOSE t3101_bcl            # 新增
                ROLLBACK WORK         # 新增
                EXIT DIALOG
             END IF

             CLOSE t3101_bcl            # 新增
             COMMIT WORK

          ON ACTION controlp
             CASE
                WHEN INFIELD(luf03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_tqap1"                           #NO.FUN-A70063
                    LET g_qryparam.default1 = g_luf[l_ac2].luf03
                    CALL cl_create_qry() RETURNING g_luf[l_ac2].luf03
                    DISPLAY g_luf[l_ac2].luf03 TO luf03
                    NEXT FIELD luf03

                WHEN INFIELD(luf04)
                    CALL cl_init_qry_var()                                               
                   #LET g_qryparam.form ="q_geo4"   #TQC-C40051 mark
                    LET g_qryparam.form = "q_oqw"   #TQC-C40051 add
                    LET g_qryparam.default1 = g_luf[l_ac2].luf04
                    CALL cl_create_qry() RETURNING g_luf[l_ac2].luf04
                    DISPLAY g_luf[l_ac2].luf04 TO luf04
                    NEXT FIELD luf04
                END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_luf.deleteElement(l_ac2)
            END IF
            EXIT DIALOG

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(luf03) AND l_ac2 > 1 THEN
               LET g_luf[l_ac2].* = g_luf[l_ac2-1].*
               NEXT FIELD luf03
            END IF

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      END INPUT

      INPUT ARRAY g_luh FROM s_luh.*
        ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW="FALSE",APPEND ROW=l_allow_insert)

          BEFORE INPUT    
             IF g_rec_b3 != 0 THEN
                CALL fgl_set_arr_curr(l_ac3)
             END IF       
          
          BEFORE ROW
             LET p_cmd='' 
             LET l_ac3 = ARR_CURR()
             LET l_lock_sw = 'N'           
             LET l_n  = ARR_COUNT()
             LET g_luh[l_ac3].luh06 = 'N'
              
             IF g_rec_b3>=l_ac3 THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                CALL t3103_set_entry(p_cmd) 
                CALL t3103_set_no_entry(p_cmd)
           
                LET g_before_input_done = TRUE
                LET g_luh_t.* = g_luh[l_ac3].*
                OPEN t3103_bcl USING g_luh_t.luhstore
                IF STATUS THEN
                   CALL cl_err("OPEN t3103_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t3103_bcl INTO g_luh[l_ac3].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_luh_t.luhstore,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   ################################
                   SELECT rtz13 INTO l_rtz13 FROM rtz_file       #FUN-A80148
                    WHERE rtz01  = g_luh[l_ac3].luhstore
                   LET g_luh[l_ac3].rtz13_2 = l_rtz13   
                   SELECT azt02 INTO g_luh[l_ac3].azt02 FROM azt_file
                    WHERE azt01 = g_luh[l_ac3].luhlegal
                  ########################
                END IF
                CALL cl_show_fld_cont()     
             END IF

          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             LET g_before_input_done = FALSE
             CALL t3103_set_entry(p_cmd)
             CALL t3103_set_no_entry(p_cmd)

             LET g_before_input_done = TRUE
             INITIALIZE g_luh[l_ac3].* TO NULL
             LET g_luh_t.* = g_luh[l_ac3].*
             LET g_luh[l_ac3].luh04 = '0'
             LET g_luh[l_ac3].luh05 = '1'
             LET g_luh[l_ac3].luh06 = 'Y'
             LET g_luh[l_ac3].luh07 = '1'
             CALL cl_show_fld_cont()
             NEXT FIELD luhstore

          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE t3103_bcl
                CANCEL INSERT
             END IF
             INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luh04,luh05,luh06,luh07,luhlegal)
             VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_luh[l_ac3].luhstore,g_luh[l_ac3].luh04,
                    g_luh[l_ac3].luh05,g_luh[l_ac3].luh06,g_luh[l_ac3].luh07,g_luh[l_ac3].luhlegal)

             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","luh_file",g_luh[l_ac3].luhstore,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K' 
                LET g_rec_b3=g_rec_b3+1
                DISPLAY g_rec_b3 TO FORMONLY.cn5
                COMMIT WORK
             END IF
             
          AFTER FIELD luhstore               
             IF NOT cl_null(g_luh[l_ac3].luhstore) THEN
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_luh[l_ac3].luhstore <> g_luh_t.luhstore) THEN  
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM rtz_file
                    WHERE  rtz01 = g_luh[l_ac3].luhstore
                   IF l_n < 1 THEN 
                     CALL cl_err('','alm-077',0)
                     LET g_luh[l_ac3].luhstore = g_luh_t.luhstore
                     DISPLAY BY NAME g_luh[l_ac3].luhstore
                     NEXT FIELD luhstore 
                   ELSE
                      SELECT rtz28 INTO l_rtz28 FROM rtz_file           
                       WHERE  rtz01 = g_luh[l_ac3].luhstore
                      IF l_rtz28 != 'Y' THEN 
                         CALL cl_err('','alm-002',0)
                         LET g_luh[l_ac3].luhstore = g_luh_t.luhstore
                         DISPLAY BY NAME g_luh[l_ac3].luhstore
                         NEXT FIELD luhstore 
                      ELSE
                         LET l_n = 0 
                         SELECT COUNT(luhstore) INTO l_n FROM luh_file
                          WHERE  luh01 = g_lue.lue01
                            AND  luh02 = g_lue.lue02
                            AND  luhstore = g_luh[l_ac3].luhstore
                         IF l_n > 0 THEN
                            CALL cl_err('','alm-172',0)
                            NEXT FIELD luhstore
                         ELSE
                            SELECT rtz13 INTO l_rtz13 FROM rtz_file
                             WHERE rtz01  = g_luh[l_ac3].luhstore
                            SELECT azw02 INTO g_luh[l_ac3].luhlegal FROM azw_file
                             WHERE azw01 = g_luh[l_ac3].luhstore
                            SELECT azt02 INTO g_luh[l_ac3].azt02 FROM azt_file
                             WHERE azt01 = g_luh[l_ac3].luhlegal
                            LET g_luh[l_ac3].rtz13_2 = l_rtz13
                         END IF
                      END IF
                   END IF
                END IF
             END IF

          AFTER FIELD luh04
             IF NOT cl_null(g_luh[l_ac3].luh04) THEN
                IF g_luh[l_ac3].luh06 = 'N' THEN
                  LET g_luh[l_ac3].luh07 = g_luh[l_ac3].luh04
                END IF
             END IF

          AFTER FIELD luh05
             IF NOT cl_null(g_luh[l_ac3].luh05) THEN
                IF g_luh[l_ac3].luh06 = 'Y' THEN
                   LET  g_luh[l_ac3].luh07 = g_luh[l_ac3].luh05
                END IF
             END IF

         #FUN-B90056 Add Begin ---
          ON CHANGE luh05
             IF NOT cl_null(g_luh[l_ac3].luh05) THEN
                LET  g_luh[l_ac3].luh07 = g_luh[l_ac3].luh05
             END IF
         #FUN-B90056 Add End -----

          AFTER FIELD luh06
             IF g_luh[l_ac3].luh06 = 'Y' THEN
                 LET g_luh[l_ac3].luh07 = g_luh[l_ac3].luh05
             ELSE
                IF g_luh[l_ac3].luh06 = 'N' THEN
                   LET g_luh[l_ac3].luh07 = g_luh[l_ac3].luh04
                END IF
             END IF

          BEFORE DELETE
             IF g_luh_t.luhstore IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                   #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "luhstore"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_luh[l_ac3].luhstore      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN  
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF      
                DELETE FROM luh_file WHERE luhstore = g_luh_t.luhstore
                                       AND luh01 = g_lue.lue01
                                       AND luh02 = g_lue.lue02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","luh_file",g_luh_t.luhstore,"",SQLCA.sqlcode,"","",1)
                   EXIT DIALOG
                END IF
                LET g_rec_b3=g_rec_b3-1
                DISPLAY g_rec_b3 TO FORMONLY.cn5
                COMMIT WORK
             END IF
                
          ON ROW CHANGE
             IF INT_FLAG THEN                 #新增程式段
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_luh[l_ac3].* = g_luh_t.*
                CLOSE t3103_bcl
                ROLLBACK WORK
                EXIT DIALOG
             END IF
         
             IF l_lock_sw="Y" THEN
                CALL cl_err(g_luh[l_ac3].luhstore,-263,0)
                LET g_luh[l_ac3].* = g_luh_t.*
             ELSE
                UPDATE luh_file SET luhstore=g_luh[l_ac3].luhstore,
                                    luhlegal=g_luh[l_ac3].luhlegal,
                                    luh04=g_luh[l_ac3].luh04,
                                    luh05=g_luh[l_ac3].luh05,
                                    luh06=g_luh[l_ac3].luh06,
                                    luh07=g_luh[l_ac3].luh07
                 WHERE luhstore = g_luh_t.luhstore
                   AND luh01 = g_lue.lue01
                   AND luh02 = g_lue.lue02
                   
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","luh_file",g_luh_t.luhstore,"",SQLCA.sqlcode,"","",1)
                   LET g_luh[l_ac3].* = g_luh_t.*   
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF

          AFTER ROW
             LET l_ac3 = ARR_CURR()            # 新增
             LET l_ac3_t = l_ac3                # 新增

             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_luh[l_ac3].* = g_luh_t.*
                ELSE
                   CALL g_luh.deleteElement(l_ac3)
                END IF
                CLOSE t3103_bcl            # 新增
                ROLLBACK WORK              # 新增
                EXIT DIALOG
             END IF

             CLOSE t3103_bcl            # 新增
             COMMIT WORK

          ON ACTION controlp
             CASE
               WHEN INFIELD(luhstore)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rtz"
                  LET g_qryparam.default1 = g_luh[l_ac3].luhstore
                  LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_luh[l_ac3].luhstore
                  DISPLAY g_luh[l_ac3].luhstore TO luhstore
                  NEXT FIELD luhstore
               OTHERWISE
                  EXIT CASE
               END CASE  

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_luh.deleteElement(l_ac3)
            END IF 
            EXIT DIALOG

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(luhstore) AND l_ac3 > 1 THEN
               LET g_luh[l_ac3].* = g_luh[l_ac3-1].*
               NEXT FIELD luhstore
            END IF

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      END INPUT

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()     
                
      ON ACTION help
         CALL cl_show_help()

   END DIALOG

   CLOSE t3102_bcl
   CLOSE t3101_bcl
   CLOSE t3103_bcl
   COMMIT WORK
          
END FUNCTION 
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t310_b1_fill(p_wc1)
DEFINE   p_wc1           LIKE type_file.chr1000
DEFINE   l_n             LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM lug_file
    WHERE lug01 = g_lue.lue01
      AND lug02 = g_lue.lue02
      AND lug03 IS NOT NULL
      AND lug04 IS NOT NULL
   IF cl_null(p_wc1) THEN LET p_wc1 = " 1=1" END IF
   IF l_n > 0 THEN
      LET g_sql ="SELECT lug03,'',lug04,lug05,lug06,lug07",
                 " FROM lug_file ",
                 " WHERE ", p_wc1 CLIPPED,
                 " and lug01 = '",g_lue.lue01,"'",
                 " and lug02 = '",g_lue.lue02,"'",
                 " ORDER BY lug03"
      PREPARE t3102_pb FROM g_sql
      DECLARE sel_lug_curs CURSOR FOR t3102_pb

      CALL g_lug.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH sel_lug_curs INTO g_lug[g_cnt].*
          IF STATUS THEN
             CALL cl_err('foreach:',STATUS,1)
             EXIT FOREACH
          END IF
          SELECT tqa02 INTO g_lug[g_cnt].tqa02_3
           FROM tqa_file
          WHERE tqa01 = g_lug[g_cnt].lug03 AND tqa03 = '24'
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH
      CALL g_lug.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b1 = g_cnt-1
      DISPLAY g_rec_b1 TO FORMONLY.cn3
      LET g_cnt = 0
   ELSE
      LET g_sql = "SELECT lng03,'',lng04,lng05,lng06,lng07",
                  " FROM lng_file ",
                  " WHERE lng01 = '",g_lue.lue01,"'",
                  " and lng03 is not null ",
                  " and lng04 is not null ",
                  " ORDER BY lng03"
      PREPARE t3102_pb_1 FROM g_sql
      DECLARE lug_curs_1 CURSOR FOR t3102_pb_1

      CALL g_lug.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH lug_curs_1 INTO g_lug[g_cnt].*
          IF STATUS THEN
             CALL cl_err('foreach:',STATUS,1)
             EXIT FOREACH
          END IF
          ###############################
          INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
              VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_lug[g_cnt].lug03,g_lug[g_cnt].lug04,
                      g_lug[g_cnt].lug05,g_lug[g_cnt].lug06,g_lug[g_cnt].lug07)
          ##############################
          SELECT tqa02 INTO g_lug[g_cnt].tqa02_3
           FROM tqa_file
          WHERE tqa01 = g_lug[g_cnt].lug03 AND tqa03 = '24'
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH
      CALL g_lug.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b1 = g_cnt-1
      DISPLAY g_rec_b1 TO FORMONLY.cn3
      LET g_cnt = 0
   END IF
END FUNCTION

FUNCTION t310_b2_fill(p_wc2)
DEFINE   p_wc2           LIKE type_file.chr1000
DEFINE   l_tqa02         LIKE tqa_file.tqa02            #NO.FUN-A70063
DEFINE   l_geo02         LIKE geo_file.geo02
DEFINE   l_n             LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM luf_file
    WHERE luf01 = g_lue.lue01
      AND luf02 = g_lue.lue02
      AND luf03 IS NOT NULL
   IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
   IF l_n > 0 THEN
      LET g_sql ="SELECT luf03,'',luf04,'' ",
                 " FROM luf_file ",
                 " WHERE ", p_wc2 CLIPPED,
                 " and luf01 = '",g_lue.lue01,"'",
                 " and luf02 = '",g_lue.lue02,"'",
                 " ORDER BY luf03"
      PREPARE t3101_pb FROM g_sql
      DECLARE sel_luf_curs CURSOR FOR t3101_pb

      CALL g_luf.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH sel_luf_curs INTO g_luf[g_cnt].*   #單身 ARRAY 填充
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         SELECT tqa02 INTO l_tqa02 FROM tqa_file
          WHERE tqa01 = g_luf[g_cnt].luf03
            AND tqa03 = '2'
            AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
            AND tqaacti = 'Y'
         LET g_luf[g_cnt].tqa02_2 = l_tqa02
        #TQC-C40051 mark START
        #SELECT geo02 INTO l_geo02 FROM geo_file
        # WHERE geo01 = g_luf[g_cnt].luf04
        #   AND geoacti  = 'Y'
        #TQC-C40051 mark END
        #TQC-C40051 add START
         SELECT oqw02 INTO l_geo02 FROM oqw_file
          WHERE oqw01 = g_luf[g_cnt].luf04
            AND oqwacti  = 'Y'
        #TQC-C40051 add END
         LET g_luf[g_cnt].geo02_2 = l_geo02
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_luf.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b2 = g_cnt-1
      DISPLAY g_rec_b2 TO FORMONLY.cn4
      LET g_cnt = 0
   ELSE
      LET g_sql = "SELECT lnf03,'',lnf04,'' ",
                  " FROM lnf_file ",
                  " WHERE lnf01 = '",g_lue.lue01,"'",
                  " and lnf03 is not null ",
                  " ORDER BY lnf03"
      PREPARE t3101_pb_1 FROM g_sql
      DECLARE luf_curs_1 CURSOR FOR t3101_pb_1

      CALL g_luf.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH luf_curs_1 INTO g_luf[g_cnt].*   #單身 ARRAY 填充
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         SELECT tqa02 INTO l_tqa02 FROM tqa_file
          WHERE tqa01 = g_luf[g_cnt].luf03
            AND tqa03 = '2'
            AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
            AND tqaacti = 'Y'
         LET g_luf[g_cnt].tqa02_2 = l_tqa02
        #TQC-C40051 mark START 
        #SELECT geo02 INTO l_geo02 FROM geo_file
        # WHERE geo01 = g_luf[g_cnt].luf04
        #   AND geoacti  = 'Y'
        #TQC-C40051 mark START
        #TQC-C40051 add START
         SELECT oqw02 INTO l_geo02 FROM oqw_file
          WHERE oqw01 = g_luf[g_cnt].luf04
            AND oqwacti  = 'Y'
        #TQC-C40051 add END
         LET g_luf[g_cnt].geo02_2 = l_geo02
         INSERT INTO luf_file(luf00,luf01,luf02,luf03,luf04)
                VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_luf[g_cnt].luf03,g_luf[g_cnt].luf04)
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_luf.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b2 = g_cnt-1
      DISPLAY g_rec_b2 TO FORMONLY.cn4
      LET g_cnt = 0
   END IF  
END FUNCTION

FUNCTION t310_b3_fill(p_wc3)
DEFINE   p_wc3           LIKE type_file.chr1000
DEFINE   l_rtz13         LIKE rtz_file.rtz13
DEFINE   l_n             LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM luh_file
    WHERE luh01 = g_lue.lue01
      AND luh02 = g_lue.lue02
      AND luhstore IS NOT NULL

   IF cl_null(p_wc3) THEN LET p_wc3 = " 1=1" END IF
   IF l_n > 0 THEN
      LET g_sql ="SELECT luhstore,'',luhlegal,'',luh04,luh05,luh06,luh07",
                 " FROM luh_file ",
                 " WHERE ", p_wc3 CLIPPED,
                 " and luh01 = '",g_lue.lue01,"'",
                 " and luh02 = '",g_lue.lue02,"'",
                 " AND luhstore IN ",g_auth," ",  #No.FUN-A10060
                 " ORDER BY luhstore"
      PREPARE t3103_pb FROM g_sql
      DECLARE sel_luh_curs CURSOR FOR t3103_pb

      CALL g_luh.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH sel_luh_curs INTO g_luh[g_cnt].*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         SELECT rtz13 INTO l_rtz13 FROM rtz_file
          WHERE rtz01  = g_luh[g_cnt].luhstore
         LET g_luh[g_cnt].rtz13_2 = l_rtz13

         SELECT azt02 INTO g_luh[g_cnt].azt02 FROM azt_file
          WHERE azt01 = g_luh[g_cnt].luhlegal
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_luh.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b3 = g_cnt-1
      DISPLAY g_rec_b3 TO FORMONLY.cn5
      LET g_cnt = 0
   ELSE
     #LET g_sql = "SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07", #FUN-B90056 Mark
      LET g_sql = "SELECT lnhstore,'',lnhlegal,'',lnh07,lnh05,lnh06,lnh07", #FUN-B90056 Add
                  " FROM lnh_file ",
                  " WHERE lnh01 = '",g_lue.lue01,"'",
                  " and lnhstore is not NULL",
                  " ORDER BY lnhstore"
      PREPARE t3103_pb_1 FROM g_sql
      DECLARE luh_curs_1 CURSOR FOR t3103_pb_1

      CALL g_luh.clear()
      LET g_cnt = 1
      MESSAGE "Searching!"
      FOREACH luh_curs_1 INTO g_luh[g_cnt].*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         SELECT rtz13 INTO l_rtz13 FROM rtz_file
            WHERE rtz01      = g_luh[g_cnt].luhstore
           LET g_luh[g_cnt].rtz13_2 = l_rtz13

         SELECT azt02 INTO g_luh[g_cnt].azt02 FROM azt_file
          WHERE azt01 = g_luh[g_cnt].luhlegal
        ########################
         INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luh04,luh05,luh06,luh07,luhlegal)
            VALUES(g_lue.lue04,g_lue.lue01,g_lue.lue02,g_luh[g_cnt].luhstore,g_luh[g_cnt].luh04,
                  g_luh[g_cnt].luh05,g_luh[g_cnt].luh06,g_luh[g_cnt].luh07,g_luh[g_cnt].luhlegal)
        ##################

         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_luh.deleteElement(g_cnt)
      MESSAGE ""
      LET g_rec_b3 = g_cnt-1
      DISPLAY g_rec_b3 TO FORMONLY.cn5
      LET g_cnt = 0
   END IF
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t310_lug03(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_tqaacti LIKE tqa_file.tqaacti

   LET g_errno = ''
   SELECT tqa02,tqaacti INTO g_lug[l_ac1].tqa02_3,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lug[l_ac1].lug03 AND tqa03 = '24'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-740'
                               LET g_lug[l_ac1].tqa02_3 = NULL
      WHEN l_tqaacti = 'N'     LET g_errno = 'alm-741'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t310_set_lue03_entry()

   IF g_aza.aza113 = 'Y' THEN
      CALL cl_set_comp_entry('lue03',TRUE)
      CALL cl_set_comp_required('lue03',TRUE)
      CALL cl_err('','alm-655',0)
   ELSE
      CALL cl_set_comp_required('lue03',FALSE)
      CALL cl_set_comp_entry('lue03',FALSE)
   END IF
END FUNCTION 
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t3102_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lug03,lug04",TRUE)
   END IF

END FUNCTION

FUNCTION t3102_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lug03,lug04",FALSE)
   END IF

END FUNCTION

FUNCTION t3101_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("luf03",TRUE)
   END IF

END FUNCTION

FUNCTION t3101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("luf03",FALSE)
   END IF

END FUNCTION


FUNCTION t3103_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("luhstore",TRUE)
   END IF

END FUNCTION

FUNCTION t3103_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("luhstore",FALSE)
   END IF

END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION t310_copy_image()
DEFINE l_gca01   LIKE gca_file.gca01
DEFINE l_gca01_1 LIKE gca_file.gca01
DEFINE l_gca07   LIKE gca_file.gca07
DEFINE l_gca08   LIKE gca_file.gca08
DEFINE l_gca09   LIKE gca_file.gca09
DEFINE l_gca10   LIKE gca_file.gca10
DEFINE ls_docNum STRING
DEFINE ls_time   STRING

   DROP TABLE x
   DROP TABLE y
   LET l_gca01 = "lne01=",g_lue.lue01
   LET l_gca01_1 = "lue01=",g_lue.lue01,"|",g_lue.lue02
   SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
    WHERE gca01 =l_gca01
   SELECT * FROM gca_file WHERE gca01 =l_gca01 INTO TEMP x
   SELECT * FROM gcb_file
    WHERE gcb01 = l_gca07
      AND gcb02 = l_gca08
      AND gcb03 = l_gca09
      AND gcb04 = l_gca10
     INTO TEMP y
   LET ls_time = TIME
   LET ls_docNum = "FLD-",
                    FGL_GETPID() USING "<<<<<<<<<<", "-",
                    TODAY USING "YYYYMMDD", "-",
                    ls_time.subString(1,2), ls_time.subString(4,5),ls_time.subString(7,8)
   LET l_gca07 =ls_docNum
   UPDATE x SET gca01 =l_gca01_1,
                gca07 =l_gca07,
                gca09 ='lue01',
                gca11 ='Y',
                gca12 =g_user,
                gca13 =g_grup,
                gca14 =g_today
   INSERT INTO gca_file SELECT * FROM x
   UPDATE y SET gcb01 =l_gca07,
                gcb03 ='lue01',
                gcb13 =g_user,
                gcb14 =g_grup,
                gcb15 =g_today
   INSERT INTO gcb_file SELECT * FROM y
  
END FUNCTION 

FUNCTION t310_change_image()
DEFINE l_gca01   LIKE gca_file.gca01
DEFINE l_gca01_1 LIKE gca_file.gca01
DEFINE l_gca07   LIKE gca_file.gca07
DEFINE l_gca08   LIKE gca_file.gca08
DEFINE l_gca09   LIKE gca_file.gca09
DEFINE l_gca10   LIKE gca_file.gca10
DEFINE ls_docNum STRING
DEFINE ls_time   STRING

  DROP TABLE x
  DROP TABLE y

  LET l_gca01 = "lne01=",g_lue.lue01
  SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
   WHERE gca01 =l_gca01
  DELETE FROM gca_file WHERE gca01 = l_gca01
  DELETE FROM gcb_file WHERE gcb01 = l_gca07
                         AND gcb02 = l_gca08
                         AND gcb03 = l_gca09
                         AND gcb04 = l_gca10

  INITIALIZE l_gca07,l_gca08,l_gca09,l_gca10 TO NULL
  LET l_gca01_1 = "lue01=",g_lue.lue01,"|",g_lue.lue02
  SELECT * FROM gca_file WHERE gca01 =l_gca01_1 INTO TEMP x
  SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
   WHERE gca01 =l_gca01_1
  SELECT * FROM gcb_file
   WHERE gcb01 = l_gca07
     AND gcb02 = l_gca08
     AND gcb03 = l_gca09
     AND gcb04 = l_gca10
    INTO TEMP y
  LET ls_time = TIME
  LET ls_docNum = "FLD-",
                   FGL_GETPID() USING "<<<<<<<<<<", "-",
                   TODAY USING "YYYYMMDD", "-",
                   ls_time.subString(1,2), ls_time.subString(4,5),ls_time.subString(7,8)
  LET l_gca07 =ls_docNum
  UPDATE x SET gca01 =l_gca01,
               gca07 =l_gca07,
               gca09 ='lne01',
               gca11 ='Y',
               gca12 =g_user,
               gca13 =g_grup,
               gca14 =g_today
  INSERT INTO gca_file SELECT * FROM x
  UPDATE y SET gcb01 =l_gca07,
               gcb03 ='lne01',
               gcb13 =g_user,
               gcb14 =g_grup,
               gcb15 =g_today
  INSERT INTO gcb_file SELECT * FROM y
END FUNCTION
#FUN-B90056 Add End -----

#No.FUN-960134 
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
 
 
 

