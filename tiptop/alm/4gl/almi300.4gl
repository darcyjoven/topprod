# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: almi300.4gl
# Descriptions...: 正式商戶維護作業 
# Date & Author..: NO:FUN-870010 08/07/29 By lilingyu 
# Modify.........: No:FUN-960134 09/07/10 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No:TQC-A10178 10/01/31 By shiwuying lne55檢查
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在INSERT后加sqlcode判斷
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A70063 10/07/13 By chenying azf02 = '3' 抓取品牌代碼改抓 tqa_file.tqa03 = '2';
#                                                     欄位 azf01 改抓 tqa01, 欄位 azf03 改抓 tqa02
# Modify.........: No:FUN-A70063 10/07/14 By chenying q_azfp1替換成q_tqap1 
# Modify.........: No:FUN-A80073 10/08/19 By wangxin 新增所屬營運中心、商戶客戶類別、商戶客戶性質、
#                                                    商戶收款客戶、慣用語言欄位
#                                                    確認時需一併將新增的欄位寫入客戶基本資料檔(occ_file)中.
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-AA0078 10/10/26 By wangxin 程式修正
# Modify.........: NO:FUN-A80117 10/11/10 By wangxin 程式修正
# Modify.........: NO:FUN-AB0096 10/11/24 By wangxin 將程式中, luhplant 改成 luhstore
# Modify.........: NO:TQC-AB0232 10/12/02 By huangtao
# Modify.........: NO:TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B90056 11/09/07 By baogc 招商歐亞達回收，部份邏輯的新增與修改
# Modify.........: No:FUN-B90121 12/01/13 By baogc BUG修改

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30027 12/03/01 by fanbj 拿掉主品牌重複控管，僅提示重複，可以繼續錄入
# Modify.........: No:FUN-C40029 12/04/11 by pauline 增加取消確認證件功能
# Modify.........: No:TQC-C40051 12/04/13 by pauline "產地" 欄位的開窗及欄位檢查,改成使用axmi365 oqw_file 的資料
# Modify.........: No:MOD-C40194 12/05/16 by Vampire 增加lne63=2'才卡alm-h07
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60062 12/06/25 by fanbj 增加傳參
# Modify.........: No:FUN-C60062 12/07/12 By yangxf 新增列印功能
# Modify.........: No:MOD-C70217 12/07/23 by Vampire 新增、修改時改CALL q_nmt(anmi080全國銀行檔)
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C60062 12/11/27 By xumeimei 修改打印传值问题
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:MOD-D30126 13/03/14 By Sakura 加上統一編號(lne55)欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_lne       RECORD    LIKE lne_file.*,  
         g_lne_t     RECORD    LIKE lne_file.*,					
         g_lne_o     RECORD    LIKE lne_file.*,    
         g_lne01_t             LIKE lne_file.lne01,
         g_lne03_t             LIKE lne_file.lne03
         
DEFINE g_lne03                 LIKE lne_file.lne03             
DEFINE g_wc                    STRING 
DEFINE g_wc1                   STRING    #FUN-B90056 ADD
DEFINE g_wc2                   STRING    #FUN-B90056 ADD
DEFINE g_wc3                   STRING    #FUN-B90056 ADD
DEFINE g_wc4                   STRING    #FUN-C60062 add
DEFINE g_wc5                   STRING    #FUN-C60062 add
DEFINE g_wc6                   STRING    #FUN-C60062 add
DEFINE g_wc7                   STRING    #FUN-C60062 add
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
DEFINE g_date                  LIKE lne_file.lnedate
DEFINE g_modu                  LIKE lne_file.lnemodu
DEFINE g_flag2                 LIKE type_file.chr1      #FUN-A80073 ---ADD---
#FUN-B90056 Add Begin ---
DEFINE l_ac1                   LIKE type_file.num5
DEFINE l_ac2                   LIKE type_file.num5
DEFINE l_ac3                   LIKE type_file.num5
DEFINE g_rec_b1                LIKE type_file.num5
DEFINE g_rec_b2                LIKE type_file.num5
DEFINE g_rec_b3                LIKE type_file.num5
DEFINE g_flag_b                LIKE type_file.chr1
DEFINE g_lng                   DYNAMIC ARRAY OF RECORD
                      lng03    LIKE lng_file.lng03,
                      tqa02_3  LIKE tqa_file.tqa02,
                      lng04    LIKE lng_file.lng04,
                      lng05    LIKE lng_file.lng05,
                      lng06    LIKE lng_file.lng06,
                      lng07    LIKE lng_file.lng07
                               END RECORD
DEFINE g_lng_t                 RECORD
                      lng03    LIKE lng_file.lng03,
                      tqa02_3  LIKE tqa_file.tqa02,
                      lng04    LIKE lng_file.lng04,
                      lng05    LIKE lng_file.lng05,
                      lng06    LIKE lng_file.lng06,
                      lng07    LIKE lng_file.lng07
                               END RECORD
DEFINE g_lnf                   DYNAMIC ARRAY OF RECORD
                      lnf03    LIKE lnf_file.lnf03,
                      tqa02_2  LIKE tqa_file.tqa02,
                      lnf04    LIKE lnf_file.lnf04,
                      geo02_2  LIKE geo_file.geo02
                               END RECORD
DEFINE g_lnf_t                 RECORD
                      lnf03    LIKE lnf_file.lnf03,
                      tqa02_2  LIKE tqa_file.tqa02,
                      lnf04    LIKE lnf_file.lnf04,
                      geo02_2  LIKE geo_file.geo02
                               END RECORD
DEFINE g_lnh                   DYNAMIC ARRAY OF RECORD
                      lnhstore LIKE lnh_file.lnhstore,
                      rtz13_2  LIKE rtz_file.rtz13,
                      lnhlegal LIKE lnh_file.lnhlegal,
                      azt02    LIKE azt_file.azt02,
                      lnh04    LIKE lnh_file.lnh04,
                      lnh05    LIKE lnh_file.lnh05,
                      lnh06    LIKE lnh_file.lnh06,
                      lnh07    LIKE lnh_file.lnh07
                               END RECORD
DEFINE g_lnh_t                 RECORD
                      lnhstore LIKE lnh_file.lnhstore,
                      rtz13_2  LIKE rtz_file.rtz13,
                      lnhlegal LIKE lnh_file.lnhlegal,
                      azt02    LIKE azt_file.azt02,
                      lnh04    LIKE lnh_file.lnh04,
                      lnh05    LIKE lnh_file.lnh05,
                      lnh06    LIKE lnh_file.lnh06,
                      lnh07    LIKE lnh_file.lnh07
                               END RECORD
#FUN-B90056 Add End -----
DEFINE g_argv1                 LIKE lnt_file.lnt01      #FUN-C60062 add
      
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          
   
   LET g_argv1=ARG_VAL(1)                               #FUN-C60062 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_forupd_sql = "SELECT * FROM lne_file WHERE lne01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i300_w WITH FORM "alm/42f/almi300"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   

   #FUN-C60062--start add-----------------
   IF NOT cl_null(g_argv1) THEN
      CALL i300_q()
   END IF
   #FUN-C60062--end add-------------------

##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lne34,lne35",FALSE)
##-TQC-B30101 ADD--END-------
   CALL cl_set_combo_lang("lne66") #Add By shi
 
  #FUN-B90056 Add Begin ---
   CALL cl_set_comp_visible("lne31,lne32,lne33",FALSE)
  #FUN-B90056 Add End -----

   LET g_action_choice = ""
   CALL i300_menu()
 
   CLOSE WINDOW i300_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i300_curs()
 
    CLEAR FORM    
    CALL g_lng.clear()  #FUN-B90056 ADD
    CALL g_lnf.clear()  #FUN-B90056 ADD
    CALL g_lnh.clear()  #FUN-B90056 ADD

    #FUN-C60062--start add----------------------------
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " lne01 = '",g_argv1,"'"
       LET g_wc1 = " 1=1" 
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
    ELSE
    #FUN-C60062--end add------------------------------
       
       DIALOG ATTRIBUTE(UNBUFFERED) #FUN-B90056 ADD
          CONSTRUCT BY NAME g_wc ON  
                           #lne01,lne02,lne03,lne04,lne05,lne06,lne07,                         #FUN-B90056 MARK
                            lne01,lne67,lne02,lne03,lne04,lne05,lne06,lne07,                   #FUN-B90056 ADD
                            lne61,lne62,                          #FUN-A80073 ---ADD---
                           #lne08,lne09,lne10,lne12,lne13,lne14,lne15,lne16,lne17,lne18,       #FUN-B90056 MARK
                            lne08,lne68,lne09,lne10,lne12,lne13,lne14,lne15,lne16,lne17,lne18, #FUN-B90056 ADD
                           #lne19,lne20,lne21,lne22,lne23,lne24,lne27,lne28,lne29,lne26,       #FUN-B90056 MARK
                            lne19,lne20,lne21,lne22,lne28,lne23,lne24,lne29,                   #FUN-B90056 ADD
                           #lne25,lne30,lne55,lne31,lne32,lne33,lne34,lne35,lne36,lne37,       #FUN-B90056 MARK
                            lne55,                                                             #MOD-D30126 add
                            lne32,lne33,lne31,lne59,lne34,lne35,lne36,lne37,                   #FUN-B90056 ADD
                           #lne38,lne59,lne39,lne40,lne41,lne42,lne56,lne57,lne43,lne44,       #FUN-B90056 MARK
                            lne38,lne39,lne40,lne41,lne42,lne56,lne57,lne43,lne44,             #FUN-B90056 ADD
                            lne45,lne46,lne47,lne48,lne49,lne58,lne50,lne51,lne52,lne53,
                            lne63,lne64,lne66,                    #FUN-A80073 ---ADD---
                            lne54,lneuser,lnegrup,lneoriu,lneorig,lnecrat,lnemodu,lnedate  #No:FUN-9B0136
                            
            BEFORE CONSTRUCT
              CALL cl_qbe_init()
              
            BEFORE FIELD lne66
              CALL cl_set_combo_lang("lne66")
              
              ON ACTION controlp
                 CASE
                    WHEN INFIELD(lne01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne1"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne01
                       NEXT FIELD lne01                     
                   
                   WHEN INFIELD(lne03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne2"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne03
                       NEXT FIELD lne03  
                           
                   WHEN INFIELD(lne04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne3"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne04
                       NEXT FIELD lne04      
                   
                   WHEN INFIELD(lne08)
                       CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_lne4"              #FUN-A70063
                       LET g_qryparam.form = "q_lne08"              #FUN-A70063
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne08
                       NEXT FIELD lne08      
                    
                   WHEN INFIELD(lne09)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne5"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne09
                       NEXT FIELD lne09           
                   
                    WHEN INFIELD(lne40)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne7"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne40
                       NEXT FIELD lne40
                    
                    WHEN INFIELD(lne42)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne8"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne42
                       NEXT FIELD lne42
                    
                     WHEN INFIELD(lne50)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne9"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne50
                       NEXT FIELD lne50                
                  
                     WHEN INFIELD(lne56)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne56"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne56
                       NEXT FIELD lne56                
 
                     WHEN INFIELD(lne57)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne57"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne57
                       NEXT FIELD lne57                
                    
                    ###FUN-A80073 START ###
                    WHEN INFIELD(lne61)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne61"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne61
                       NEXT FIELD lne61   
                       
                    WHEN INFIELD(lne62)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne62"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne62
                       NEXT FIELD lne62
                       
                    WHEN INFIELD(lne64)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne64"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne64
                       NEXT FIELD lne64      
                    ###FUN-A80073 END ###
                   #FUN-B90056 Add Begin ---
                    WHEN INFIELD(lne67)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne67"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne67
                       NEXT FIELD lne67
                    WHEN INFIELD(lne68)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lne68"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lne68
                       NEXT FIELD lne68
                   #FUN-B90056 Add End -----
                  OTHERWISE
                  EXIT CASE
                 END CASE
         #FUN-B90056 Add Begin ---
          END CONSTRUCT

          CONSTRUCT g_wc1 ON lng03,lng04,lng05,lng06,lng07
                        FROM s_lng[1].lng03,s_lng[1].lng04,s_lng[1].lng05,s_lng[1].lng06,
                             s_lng[1].lng07
                          
             BEFORE CONSTRUCT
                CALL cl_qbe_init()

             ON ACTION CONTROLP
                CASE
                  WHEN INFIELD(lng03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_lng03"
                      LET g_qryparam.state='c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lng03
                      NEXT FIELD lng03

                END CASE

          END CONSTRUCT

          CONSTRUCT g_wc2 ON lnf03,lnf04 FROM s_lnf[1].lnf03,s_lnf[1].lnf04

             BEFORE CONSTRUCT
                CALL cl_qbe_init()

             ON ACTION CONTROLP
                CASE
                  WHEN INFIELD(lnf03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_lnf01_1"
                      LET g_qryparam.state='c'
                     #FUN-B90121 Mark Begin ---
                     #LET g_qryparam.arg1 = g_lne.lne01
                     #LET g_qryparam.arg2 = g_lne.lne02
                     #FUN-B90121 Mark End -----
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lnf03
                      NEXT FIELD lnf03

                   WHEN INFIELD(lnf04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_lnf02"
                      LET g_qryparam.state='c'
                      LET g_qryparam.arg1 = g_lne.lne01
                      LET g_qryparam.arg2 = g_lne.lne02
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lnf04
                      NEXT FIELD lnf04

                 END CASE
          END CONSTRUCT

          CONSTRUCT g_wc3 ON lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07
                        FROM s_lnh[1].lnhstore,s_lnh[1].lnhlegal,
                             s_lnh[1].lnh04,s_lnh[1].lnh05,s_lnh[1].lnh06,
                             s_lnh[1].lnh07

             BEFORE CONSTRUCT
                CALL cl_qbe_init()

             ON ACTION controlp
                CASE
                   WHEN INFIELD(lnhstore)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_lnhstore"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.arg1 = g_lne.lne01
                      LET g_qryparam.arg2 = '0'
                      LET g_qryparam.where = " lnhstore IN ",g_auth," "
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lnhstore
                      NEXT FIELD lnhstore
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
    END IF                #FUN-C60062 add

    IF INT_FLAG THEN
       RETURN
    END IF
   
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lneuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND lnegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lnegrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lneuser', 'lnegrup')
    #End:FUN-980030
 
   #FUN-B90056 Add&Mark Begin ---
   #LET g_sql = "SELECT lne01 FROM lne_file ",
   #            " WHERE ",g_wc CLIPPED,
   #            " ORDER BY lne01"

    IF g_wc3 = " 1=1" THEN
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lne01 FROM lne_file ",
                         " WHERE ",g_wc CLIPPED,
                         " ORDER BY lne01"
          ELSE
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lng_file ",
                         " WHERE lne01 = lng01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         " ORDER BY lne01"
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lnf_file ",
                         " WHERE lne01 = lnf01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                         " ORDER BY lne01"
          ELSE
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lng_file,lnf_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnf01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         "   AND ",g_wc2 CLIPPED,
                         " ORDER BY lne01"
          END IF
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lnh_file ",
                         " WHERE lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lne01"
          ELSE
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lng_file,lnh_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         "   AND ",g_wc3 CLIPPED,
                         " ORDER BY lne01"
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lnf_file,lnh_file ",
                         " WHERE lne01 = lnf01 AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lne01"
          ELSE
             LET g_sql = "SELECT UNIQUE lne01 ",
                         "  FROM lne_file,lng_file,lnf_file,lnh_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnf01 ",
                         "   AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         "   AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lne01"
          END IF
       END IF
    END IF
   #FUN-B90056 Add&Mark End -----
 
    PREPARE i300_prepare FROM g_sql
    DECLARE i300_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i300_prepare
 
   #FUN-B90056 Add&Mark Begin ---
   #LET g_sql = "SELECT COUNT(*) FROM lne_file WHERE ",g_wc CLIPPED
   
    IF g_wc3 = " 1=1" THEN
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(*) FROM lne_file ",
                         " WHERE ",g_wc CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lng_file ",
                         " WHERE lne01 = lng01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lnf_file ",
                         " WHERE lne01 = lnf01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lng_file,lnf_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnf01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
          END IF
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lnh_file ",
                         " WHERE lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lng_file,lnh_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc3 CLIPPED
          END IF
       ELSE
          IF g_wc1 = " 1=1" THEN
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lnf_file,lnh_file ",
                         " WHERE lne01 = lnf01 AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
          ELSE
             LET g_sql = "SELECT COUNT(DISTINCT lne01) ",
                         "  FROM lne_file,lng_file,lnf_file,lnh_file ",
                         " WHERE lne01 = lng01 AND lne01 = lnf01 ",
                         "   AND lne01 = lnh01 AND lnhstore IN ",g_auth,
                         "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                         "   AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
          END IF
       END IF
    END IF
   #FUN-B90056 Add&Mark End -----
    PREPARE i300_precount FROM g_sql
    DECLARE i300_count CURSOR FOR i300_precount
END FUNCTION
 
FUNCTION i300_menu()
   DEFINE l_msg        LIKE type_file.chr1000  
   DEFINE l_count      LIKE type_file.num5
   DEFINE g_body       LIKE type_file.chr1
   
   #FUN-B90056 Add&Mark Begin ---
   #MENU ""
   #    BEFORE MENU
   #       CALL cl_navigator_setting(g_curs_index,g_row_count)
    WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
   #    ON ACTION insert
   #       LET g_action_choice="insert"
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i300_a()
           END IF
 
   #    ON ACTION query
   #       LET g_action_choice="query"
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i300_q()
           END IF
 
   #    ON ACTION next
   #       IF g_curs_index < g_row_count THEN
   #          CALL i300_fetch('N')
   #       END IF
 
   #    ON ACTION previous
   #       CALL i300_fetch('P')
 
   #    ON ACTION modify
   #       LET g_action_choice="modify"
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i300_u('w','')
           END IF   
           
   #    ON ACTION delete
   #       LET g_action_choice="delete"
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i300_r()
           END IF
 
   #    ON ACTION reproduce
   #       LET g_action_choice="reproduce"
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i300_copy()
           END IF    
           
   #    ON ACTION confirm
   #       LET g_action_choice="confirm"
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i300_confirm()
           END IF   
           CALL i300_pic()
                   
           
   #    ON ACTION void
   #       LET g_action_choice = "void"
        WHEN "void"
           IF cl_chk_act_auth() THEN 
              CALL i300_v(1)
           END IF    
           CALL i300_pic()
        #FUN-D20039 ----------STA
        WHEN "undo_void"
           IF cl_chk_act_auth() THEN
              CALL i300_v(2)
           END IF 
           CALL i300_pic()
        #FUN-D20039 ----------END


   #FUN-B90056 Add&Mark End -----
        
 #       ON ACTION qianhe
 #          LET g_action_choice = "qianhe"   
 #          IF cl_chk_act_auth() THEN 
 #             CALL i300_qianhe()
 #          END IF 
 #          CALL i300_pic()
  
   #FUN-B90056 Add&Mark Begin ---
   #     ON ACTION brand
   #       LET g_action_choice = "brand"                                                     
   #       IF cl_chk_act_auth() THEN                                                       
   #        IF NOT cl_null(g_lne.lne01) THEN                                                                  
   #          LET l_msg = "almi3001  '",g_lne.lne04 CLIPPED,"'  '",g_lne.lne01,"' '",g_lne.lne02,"'"
   #          CALL cl_cmdrun_wait(l_msg)                                                        
   #        ELSE                                                                
   #          CALL cl_err('',-400,1)                                                           
   #        END IF                                                         
   #       END IF                    
                     
   #    ON ACTION business
   #       LET g_action_choice = "business"                                                  
   #    WHEN "business"
   #       IF cl_chk_act_auth() THEN                                                         
   #          IF NOT cl_null(g_lne.lne01) THEN                     
   #             LET l_msg = "almi3002  '",g_lne.lne04 CLIPPED,"'  '",g_lne.lne01,"'  "
   #             CALL cl_cmdrun_wait(l_msg)                                                       
   #          ELSE                                                                                
   #            CALL cl_err('',-400,1)                                                          
   #          END IF                                                                       
   #       END IF                
         
   #    ON ACTION sta
   #       LET g_action_choice = "sta" 
   #    WHEN "sta"
   #       IF cl_chk_act_auth() THEN 
   #          IF NOT cl_null(g_lne.lne01) THEN                                           
   #             LET l_msg = "almi3003  '",g_lne.lne04 CLIPPED,"'  '",g_lne.lne01,"'  "
   #             CALL cl_cmdrun_wait(l_msg)                                                          
   #          ELSE                                                                                       
   #             CALL cl_err('',-400,1)                                                      
   #          END IF        
   #       END IF 
        
   #    ON ACTION Maintenance
   #       LET g_action_choice = "Maintenance"
   #       IF cl_chk_act_auth() THEN
   #          IF g_lne.lne59 = 'Y' THEN
   #             CALL cl_err('','alm-660',1)
   #          ELSE
   #             CALL i300_u('u','M')             #維護四證
   #          END IF
   #       END IF
           
   #    ON ACTION Review
   #       LET g_action_choice = "Review"
   #       IF cl_chk_act_auth() THEN 
   #         IF g_lne.lne59 = 'Y' THEN
   #           CALL cl_err('','alm-659',1)
   #         ELSE
   #          IF g_lne.lne36 = 'Y' THEN 
   #             IF g_lne.lne26 IS NULL THEN
   #                CALL cl_err('','alm-661',1)
   #             ELSE
   #                IF NOT cl_confirm('alm-658') THEN
   #                ELSE
   #                  LET g_lne.lne59 = 'Y'
   #                  UPDATE lne_file 
   #                     SET lne59 = 'Y'
   #                   WHERE lne01 = g_lne.lne01    
   #                 #No.TQC-A30075 -BEGIN-----
   #                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
   #                     CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
   #                  END IF
   #                 #No.TQC-A30075 -END-------
   #                  CALL i300_show()              #顯示確認四證結果于畫面上
   #                END IF
   #            END IF
   #          ELSE
   #             CALL cl_err('','alm-657',1)
   #          END IF
   #         END IF
   #       END IF
 
   #    ON ACTION help
   #       CALL cl_show_help()
 
   #    ON ACTION exit
   #       LET g_action_choice = "exit"
   #       EXIT MENU
 
   #    ON ACTION jump
   #       CALL i300_fetch('/')
 
   #    ON ACTION first
   #       CALL i300_fetch('F')
 
   #    ON ACTION last
   #       CALL i300_fetch('L')
 
   #    ON ACTION controlg
        WHEN "controlg"
           CALL cl_cmdask()
 
   #    ON ACTION locale
   #       CALL cl_dynamic_locale()
   #       CALL cl_show_fld_cont() 
   #       CALL i300_pic() 
   #       
   #    ON IDLE g_idle_seconds
   #       CALL cl_on_idle()
   #       CONTINUE MENU
 
   #    ON ACTION about 
   #       CALL cl_about() 
 
   #    ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
   #       LET INT_FLAG = FALSE 
   #       LET g_action_choice = "exit"
   #       EXIT MENU
        WHEN "exit"
           EXIT WHILE
 
   #    ON ACTION related_document 
   #       LET g_action_choice="related_document"
        WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lne.lne01) THEN
                 LET g_doc.column1 = "lne01"
                 LET g_doc.value1 = g_lne.lne01
                 CALL cl_doc()
              END IF
           END IF

        WHEN "detail"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lne.lne01) THEN
                 CALL i300_b()
              ELSE
                 CALL cl_err('','-400',1)
                 RETURN
              END IF
           END IF

#FUN-C60062 add begin ---
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i300_out()
            END IF
#FUN-C60062 add end ----

        WHEN "cer_confirm"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lne.lne01) THEN
                 IF g_lne.lne59 = 'N'  THEN  #FUN-C40029 add
                    CALL i300_cer_confirm()      #若證件未確認,則進行證件確認
                #FUN-C40029 add START
                 ELSE
                    CALL i300_cer_unconfirm()    #若證件已確認,則進行證件取消確認
                 END IF
                #FUN-C40029 add END
              ELSE
                 CALL cl_err('','-400',1)
                 RETURN
              END IF
           END IF

        WHEN "upd_image"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lne.lne01) THEN
                 CALL i300_upd_image()
              ELSE
                 CALL cl_err('','-400',1)
                 RETURN
              END IF
           END IF

      END CASE
    END WHILE
   #END MENU
    CLOSE i300_cs
   #FUN-B90056 Add&Mark End -----
END FUNCTION

#FUN-B90056 Add Begin ---
FUNCTION i300_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lng TO s_lng.* ATTRIBUTE(COUNT=g_rec_b1)
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

      DISPLAY ARRAY g_lnf TO s_lnf.* ATTRIBUTE(COUNT=g_rec_b2)
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


      DISPLAY ARRAY g_lnh TO s_lnh.* ATTRIBUTE(COUNT=g_rec_b3)
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
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG
         
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION reproduce
         LET g_action_choice = "reproduce"
         EXIT DIALOG

      ON ACTION upd_image
         LET g_action_choice = "upd_image"
         EXIT DIALOG

#FUN-C60062 add begin---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
#FUN-C60062 add end ----

      ON ACTION cer_confirm
         LET g_action_choice = "cer_confirm"
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG

      ON ACTION void
         LET g_action_choice = "void"
         EXIT DIALOG
      #FUN-D20039 --------------sta
      ON ACTION undo_void
         LET g_action_choice = "undo_void"
         EXIT DIALOG
      #FUN-D20039 --------------end
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
    
FUNCTION i300_a()
DEFINE l_str STRING #FUN-B90056 Add
 
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_lne.*    LIKE lne_file.*       
    INITIALIZE g_lne_t.*  LIKE lne_file.*
    INITIALIZE g_lne_o.*  LIKE lne_file.*     
   #FUN-B90056 Add Begin ---
    CALL g_lng.clear()
    CALL g_lnf.clear()
    CALL g_lnh.clear()
    LET g_wc1 = NULL
    LET g_wc2 = NULL
    LET g_wc3 = NULL
   #FUN-B90056 Add End -----
   
     LET g_lne01_t = NULL
     LET g_wc = NULL
     CALL cl_opmsg('a')     

     WHILE TRUE
        LET g_lne.lneuser = g_user
        LET g_lne.lneoriu = g_user #FUN-980030
        LET g_lne.lneorig = g_grup #FUN-980030
        LET g_lne.lnegrup = g_grup  
        LET g_lne.lnecrat = g_today
        LET g_lne.lne02   = '0'
        LET g_lne.lne24   = 0
        LET g_lne.lne29   = 0
        LET g_lne.lne32   = 0
        LET g_lne.lne33   = 0
        LET g_lne.lne34   = 'N'
        LET g_lne.lne35   = '0'
        LET g_lne.lne36   = 'N'        
        LET g_lne.lne31   = 'N'
        LET g_lne.lne59   = 'N'
        LET g_lne.lne27   = ' '  #FUN-B90056 ADD
             
        CALL i300_i('a','a','')    
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lne.* TO NULL
           LET g_lne01_t = NULL           
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF

       #FUN-B90056 Add Begin ---
        IF g_aza.aza112 = 'Y' THEN
           CALL s_auno(g_lne.lne01,'B','' ) RETURNING g_lne.lne01,l_str
          #FUN-B90121 Add Begin ---
           IF g_lne.lne63 = '1' THEN
              LET g_lne.lne64 = g_lne.lne01
              DISPLAY BY NAME g_lne.lne64
              DISPLAY g_lne.lne05 TO FORMONLY.lne64_n
           END IF
          #FUN-B90121 Add End -----
        END IF
       #FUN-B90056 Add End -----
        IF cl_null(g_lne.lne01) THEN    
           CONTINUE WHILE
        END IF        
        DISPLAY BY NAME g_lne.lne01 #FUN-B90056 Add
        
        INSERT INTO lne_file VALUES(g_lne.*)                   
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lne.lne01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           CALL i300_bring()
           SELECT * INTO g_lne.* FROM lne_file
            WHERE lne01 = g_lne.lne01
          #FUN-B90056 Add Begin ---
           LET g_rec_b1 = 0
           LET g_rec_b2 = 0
           LET g_rec_b3 = 0
           CALL i300_b1_fill(" 1=1")
           CALL i300_b2_fill(" 1=1")
           CALL i300_b3_fill(" 1=1")
          #FUN-B90056 Add End -----
        END IF

       #FUN-B90056 Add Begin ---
        CALL i300_b()
       #FUN-B90056 Add End -----

        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION i300_bring()
DEFINE  l_sql       STRING
DEFINE   g_cnt_1    LIKE type_file.num10
DEFINE   g_lnc      DYNAMIC ARRAY OF RECORD
           lnc02    LIKE lnc_file.lnc02,
           lnc03    LIKE lnc_file.lnc03
                    END RECORD 
DEFINE   g_lnd      DYNAMIC ARRAY OF RECORD
           lnd02    LIKE lnd_file.lnd02,
           lnd03    LIKE lnd_file.lnd03,
           lnd04    LIKE lnd_file.lnd04,
           lnd05    LIKE lnd_file.lnd05,
           lnd06    LIKE lnd_file.lnd06
                    END RECORD 
#FUN-B90056 Add Begin ---
DEFINE   g_lnh      DYNAMIC ARRAY OF RECORD
           lnhstore LIKE lnh_file.lnhstore
                    END RECORD
DEFINE   l_azw02    LIKE azw_file.azw02
#FUN-B90056 Add End -----
  
     LET l_sql = "select lnc02,lnc03 from lnc_file",
                 " where lnc01 = '",g_lne.lne03,"'"
     PREPARE lnc_pb FROM l_sql
     DECLARE lnc_curs CURSOR FOR lnc_pb 
     
     LET l_sql = "select lnd02,lnd03,lnd04,lnd05,lnd06 from lnd_file",
                 " where lnd01 = '",g_lne.lne03,"'"
     PREPARE lnd_pb FROM l_sql
     DECLARE lnd_curs CURSOR FOR lnd_pb            
     
     CALL g_lnc.clear()
     CALL g_lnd.clear()
     
     LET g_cnt_1 = 1
     FOREACH lnc_curs INTO g_lnc[g_cnt_1].*
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH 
        END IF     
        INSERT INTO lnf_file VALUES(g_lne.lne04,g_lne.lne01,0,
                         g_lnc[g_cnt_1].lnc02,g_lnc[g_cnt_1].lnc03)
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
     FOREACH lnd_curs INTO g_lnd[g_cnt_1].*
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH 
        END IF     
        INSERT INTO lng_file VALUES(g_lne.lne04,g_lne.lne01,0,
                         g_lnd[g_cnt_1].lnd02,g_lnd[g_cnt_1].lnd03,
                         g_lnd[g_cnt_1].lnd04,g_lnd[g_cnt_1].lnd05,
                         g_lnd[g_cnt_1].lnd06)
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

    #FUN-B90056 Add Begin ---
     LET l_sql = "SELECT rtz01 FROM rtz_file WHERE rtz01 IN ",g_auth
     PREPARE sel_rtz_pre FROM l_sql
     DECLARE sel_rtz_cs CURSOR FOR sel_rtz_pre

     CALL g_lnh.clear()
     LET g_cnt = 1

     FOREACH sel_rtz_cs INTO g_lnh[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = g_lnh[g_cnt].lnhstore

        INSERT INTO lnh_file(lnh00,lnh01,lnh02,lnh03,lnh04,lnh05,lnh06,lnh07,lnhlegal,lnhstore)
           VALUES(g_lne.lne04,g_lne.lne01,0,'','0','1','Y','1',l_azw02,g_lnh[g_cnt].lnhstore)

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
    #FUN-B90056 Add End -----

END FUNCTION 
 
FUNCTION i300_i(p_cmd,w_cmd,m_cmd)
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  w_cmd      LIKE type_file.chr1
DEFINE  m_cmd      LIKE type_file.chr1
DEFINE  l_cnt      LIKE type_file.num5 
DEFINE  l_gec02    LIKE gec_file.gec02
DEFINE  l_gec04    LIKE gec_file.gec04
DEFINE  l_gec07    LIKE gec_file.gec07 
DEFINE  l_gecacti  LIKE gec_file.gecacti
DEFINE  l_oag02    LIKE oag_file.oag02
#DEFINE  l_nma02    LIKE nma_file.nma02   #MOD-C70217 mark
#DEFINE  l_nmaacti  LIKE nma_file.nmaacti #MOD-C70217 mark
DEFINE  l_nmt02    LIKE nma_file.nma02   #MOD-C70217 add
DEFINE  l_nmtacti  LIKE nma_file.nmaacti #MOD-C70217 add
DEFINE  l_count    LIKE type_file.num5 
DEFINE  l_ool02    LIKE ool_file.ool02
DEFINE  l_azi02    LIKE azi_file.azi02
DEFINE  l_aziacti  LIKE azi_file.aziacti
DEFINE  l_lne05    LIKE lne_file.lne05    #FUN-A80073 ---ADD---
DEFINE  l_oca02    LIKE oca_file.oca02    #FUN-A80073 ---ADD---
DEFINE  l_lne64_n  LIKE occ_file.occ02    #FUN-A80073 ---ADD---
DEFINE  l_occ02    LIKE occ_file.occ02    #FUN-A80073 ---ADD---
 
   DISPLAY BY NAME  g_lne.lne03,g_lne.lne34,g_lne.lne35,g_lne.lne36,g_lne.lne37,g_lne.lne38,
                    g_lne.lne31,g_lne.lne59,g_lne.lne02,
                    g_lne.lneuser,g_lne.lnegrup,g_lne.lnecrat,g_lne.lnemodu,g_lne.lnedate,g_lne.lneoriu,g_lne.lneorig                    
   LET g_lne03_t = g_lne.lne03
              
  #INPUT BY NAME  g_lne.lne01,g_lne.lne03,g_lne.lne04,g_lne.lne05,g_lne.lne06,g_lne.lne07,             #FUN-B90056 MARK
   INPUT BY NAME  g_lne.lne01,g_lne.lne67,g_lne.lne03,g_lne.lne04,g_lne.lne05,g_lne.lne06,g_lne.lne07, #FUN-B90056 ADD
                  g_lne.lne61,g_lne.lne62,                          #FUN-A80073 ---ADD---
                 #g_lne.lne08,g_lne.lne09,g_lne.lne10,g_lne.lne12,g_lne.lne13,g_lne.lne14,             #FUN-B90056 MARK
                  g_lne.lne08,g_lne.lne68,g_lne.lne09,g_lne.lne10,g_lne.lne12,g_lne.lne13,g_lne.lne14, #FUN-B90056 ADD
                  g_lne.lne15,g_lne.lne16,g_lne.lne17,g_lne.lne18,g_lne.lne19,g_lne.lne20,
                 #g_lne.lne21,g_lne.lne22,g_lne.lne23,g_lne.lne24,g_lne.lne27,g_lne.lne28,             #FUN-B90056 MARK
                  g_lne.lne21,g_lne.lne22,g_lne.lne28,g_lne.lne23,g_lne.lne24,                         #FUN-B90056 ADD
                 #g_lne.lne29,g_lne.lne26,g_lne.lne25,g_lne.lne30,g_lne.lne55,g_lne.lne39,             #FUN-B90056 MARK
                  g_lne.lne55,                                                                         #MOD-D30126 add
                  g_lne.lne29,g_lne.lne39,                                                             #FUN-B90056 ADD
                  g_lne.lne40,g_lne.lne41,g_lne.lne42,g_lne.lne56,g_lne.lne57,g_lne.lne43,
                  g_lne.lne44,g_lne.lne45,g_lne.lne46,g_lne.lne47,g_lne.lne48,g_lne.lne49,
                  g_lne.lne58,g_lne.lne50,g_lne.lne52,g_lne.lne53,
                  g_lne.lne63,g_lne.lne64,g_lne.lne66,              #FUN-A80073 ---ADD---
                  g_lne.lne54
                    
    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          IF m_cmd = 'M' THEN
             CALL cl_set_comp_entry("lne01,lne02,lne05,lne12,lne13,lne14,lne15,lne17,
                                    #lne03,lne04,lne06,lne07,lne08,lne9,lne10,lne16,  #FUN-B90056 MARK
                                     lne04,lne06,lne07,lne08,lne9,lne10,lne16,        #FUN-B90056 ADD
                                    #lne18,lne23,lne24,lne27,lne28,lne29,lne40,lne42, #FUN-B90056 MARK
                                     lne18,lne23,lne24,lne28,lne29,lne40,lne42,       #FUN-B90056 ADD
                                     lne41,lne43,lne44,lne45,lne56,lne57,lne09,
                                     lne19,lne20,lne21,lne22,
                                     lne31,lne32,lne33,lne34,lne35,lne36,
                                     lne37,lne38,lne39,
                                     lne46,lne47,lne48,lne49,lne50,lne51,lne52,
                                     lne53,lne61,lne62,lne63,lne64,lne66,   #FUN-A80117 add
                                     lne53,lne54,lne58",FALSE)
          ELSE
             CALL cl_set_comp_entry("lne01,lne05,lne12,lne13,lne14,lne15,lne17,
                                    #lne03,lne04,lne06,lne07,lne08,lne9,lne10,lne16,  #FUN-B90056 MARK
                                     lne04,lne06,lne07,lne08,lne9,lne10,lne16,        #FUN-B90056 ADD
                                    #lne18,lne23,lne24,lne27,lne28,lne29,lne40,lne42, #FUN-B90056 MARK
                                     lne18,lne23,lne24,lne28,lne29,lne40,lne42,       #FUN-B90056 ADD
                                     lne41,lne43,lne44,lne45,lne56,lne57,lne09,
                                     lne19,lne20,lne21,lne22,lne39,
                                     lne46,lne47,lne48,lne49,lne50,lne52,
                                     lne53,lne54,lne58",TRUE)
          END IF
          CALL i300_set_entry(p_cmd)        
          CALL i300_set_no_entry(p_cmd)      
         #FUN-B90056 Add Begin ---
          IF g_aza.aza112 = 'Y' THEN
             CALL cl_set_comp_entry("lne01",FALSE)
             CALL cl_set_comp_required("lne01",FALSE)
          ELSE
             CALL cl_set_comp_entry("lne01",TRUE)
             CALL cl_set_comp_required("lne01",TRUE)
          END IF
         #FUN-B90056 Add End -----
          CALL cl_set_comp_required("lne58",TRUE)
          CALL i300_set_lne03()   #FUN-B90056 ADD
          LET g_before_input_done = TRUE
          
      BEFORE FIELD lne66                              #FUN-A80073 ---ADD---
         CALL cl_set_combo_lang("lne66")              #FUN-A80073 ---ADD---
        
      AFTER FIELD lne01 
          IF NOT cl_null(g_lne.lne01) THEN
            IF (p_cmd = 'a' AND w_cmd = 'a') OR 
               (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne01 != g_lne_t.lne01) THEN
               CALL i300_check_lne01(g_lne.lne01) 
               IF g_success = 'N' THEN                  
                  LET g_lne.lne01 = g_lne_t.lne01                            
                  DISPLAY BY NAME g_lne.lne01                            
                  NEXT FIELD lne01                                        
               END IF
           END IF                
          END IF           
 
      AFTER FIELD lne03
          LET g_lne03 = NULL 
          IF NOT cl_null(g_lne.lne03) THEN 
       #      IF (p_cmd = 'a' AND w_cmd = 'a') OR                                                      #TQC-AB0232  mark
              IF (p_cmd = 'a' AND w_cmd = 'a' AND (g_lne.lne03 != g_lne03_t OR g_lne03_t IS NULL)) OR   #TQC-AB0232
             #  (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne03 != g_lne_t.lne03) OR 
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne03 != g_lne03_t) OR
                (p_cmd = 'u' AND w_cmd = 'h') THEN
                CALL i300_check_lne03(g_lne.lne03)
                IF g_success = 'N' THEN                                                             
                  DISPLAY BY NAME g_lne.lne03                                                
                  NEXT FIELD lne03 
                ELSE
                   LET g_lne03_t = g_lne.lne03                                                     #TQC-AB0232
                   CALL i300_xxx()             	                 	         
               END IF
             END IF   
          END IF       
 
       AFTER FIELD lne04
          IF NOT cl_null(g_lne.lne04) THEN 
             IF (p_cmd = 'a' AND w_cmd = 'a') OR
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne04 != g_lne_t.lne04) OR
                (p_cmd = 'u' AND w_cmd = 'h')  THEN
                CALL i300_check_lne04(g_lne.lne04)
                IF g_success = 'N' THEN                            
                   LET g_lne.lne04 = g_lne_t.lne04                          
                   DISPLAY BY NAME g_lne.lne04                                              
                   NEXT FIELD lne04 
                ELSE
                   CALL i300_xxx_lne04(g_lne.lne04)                 	                       
               END IF
             END IF 
           ELSE
              DISPLAY '' TO FORMONLY.rtz13  
          END IF        
     ###FUN-A80073 ### START ###
     AFTER FIELD lne61 
        IF NOT cl_null(g_lne.lne61) THEN 
           SELECT COUNT(*) INTO l_count FROM azp_file
            WHERE azp01  = g_lne.lne61
           IF l_count = 0 THEN
             CALL cl_err('','aap-025',0)
             LET g_lne.lne61 = g_lne_t.lne61                          
             DISPLAY BY NAME g_lne.lne61                                              
             NEXT FIELD lne61 
           END IF
           CALL i300_xxx_lne61(g_lne.lne61)     
        ELSE
         	DISPLAY '' TO FORMONLY.lne61_n     
        END IF 
           
     AFTER FIELD lne62 
        IF NOT cl_null(g_lne.lne62) THEN
                SELECT oca02 INTO l_oca02 FROM oca_file  
                 WHERE oca01 = g_lne.lne62
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oca_file",g_lne.lne62,"",STATUS,"","select oca",1)  
                  NEXT FIELD lne62
               END IF
               CALL s_field_chk(g_lne.lne62,'4',g_plant,'lne62') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_lne.lne62,'aoo-043',1)
                  LET g_lne.lne62 = g_lne_t.lne62
                  DISPLAY BY NAME g_lne.lne62
                  NEXT FIELD lne62
               END IF
               DISPLAY l_oca02 TO FORMONLY.lne62_n  
            ELSE                               
               DISPLAY ' ' TO FORMONLY.lne62_n   
            END IF    
                    
     ON CHANGE lne63               #FUN-AA0078 
        CASE g_lne.lne63
           WHEN '1'
              DISPLAY '' TO FORMONLY.lne64_n
              LET g_lne.lne64 = g_lne.lne01
              LET g_lne.lne65 = g_lne.lne01
              DISPLAY BY NAME g_lne.lne64
              DISPLAY g_lne.lne05 TO FORMONLY.lne64_n
              CALL cl_set_comp_entry("lne64",FALSE)
           WHEN '2'
              LET g_lne.lne64 = ''
              DISPLAY BY NAME g_lne.lne64
              DISPLAY '' TO FORMONLY.lne64_n
              LET g_lne.lne65 = g_lne.lne01
              CALL cl_set_comp_entry("lne64",TRUE)     
              #CALL i300_xxx_lne64(g_lne.lne64)
        END CASE          

     
     AFTER FIELD lne64
        #FUN-AA0078 add  ----------begin---------
        IF cl_null(g_lne.lne64) THEN
           NEXT FIELD lne64
        END IF
        #FUN-AA0078 add  ----------end---------
        IF NOT cl_null(g_lne.lne64) THEN
           #IF g_lne.lne64 = g_lne.lne01 THEN                      #MOD-C40194 mark
           IF g_lne.lne64 = g_lne.lne01 AND g_lne.lne63 = '2' THEN #MOD-C40194 add
              CALL cl_err('','alm-h07',1)
              NEXT FIELD lne64
           ELSE    
              SELECT COUNT(*) INTO l_count FROM occ_file WHERE occ06 IN ('1','3') AND occacti = 'Y' AND occ01 = g_lne.lne64
              IF l_count > 0 THEN
                 SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_lne.lne64
                 DISPLAY l_occ02 TO FORMONLY.lne64_n
              ELSE
                 CALL cl_err(g_lne.lne64,'alm-h06',1)
                 LET g_lne.lne64 = ''
                 DISPLAY BY NAME g_lne.lne64
                 DISPLAY '' TO FORMONLY.lne64_n
                 NEXT FIELD lne64
              END IF 	
           END IF          
        ELSE
           DISPLAY '' TO FORMONLY.lne64_n	        
        END IF     
     ###FUN-A80073 ### END ###
     AFTER FIELD lne08
         IF NOT cl_null(g_lne.lne08) THEN   
               CALL i300_xxx_lne08(g_lne.lne08)
               IF g_success = 'N' THEN 
                  LET g_lne.lne08 = g_lne_t.lne08
                  DISPLAY BY NAME g_lne.lne08
                  NEXT FIELD lne08
               ELSE
                  CALL i300_xxx_lne081(g_lne.lne08)  
               END IF 
            #No.TQC-A10178 -BEGIN-----
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lne.lne08 != g_lne_t.lne08) THEN
                SELECT COUNT(*) INTO l_count FROM lne_file
                #WHERE lne08 = p_cmd                 #FUN-B90056 MARK
                 WHERE lne08 = g_lne.lne08           #FUN-B90056 ADD
                IF l_count > 0 THEN
                   CALL cl_err('','alm-705',0)
                   #NEXT FIELD lne08        #TQC-C30027 mark
                END IF
             END IF
            #No.TQC-A10178 -END-------
          ELSE
             DISPLAY '' TO FORMONLY.tqa02              #FUN-A70063
            #FUN-B90056 Add Begin ---
             LET g_lne.lne68 = NULL
             DISPLAY BY NAME g_lne.lne68
             DISPLAY '' TO FORMONLY.lne68_desc
            #FUN-B90056 Add End -----
          END IF  
     
     AFTER FIELD lne09
         IF NOT cl_null(g_lne.lne09) THEN   
               CALL i300_xxx_lne09(g_lne.lne09)
               IF g_success = 'N' THEN 
                   LET g_lne.lne09 = g_lne_t.lne09
                   DISPLAY BY NAME g_lne.lne09
                   NEXT FIELD lne09
               ELSE
                	  CALL i300_xxx_lne091(g_lne.lne09)   
               END IF  
         ELSE
          	DISPLAY '' TO FORMONLY.geo02     
         END IF  
      
        AFTER FIELD lne24 
         IF NOT cl_null(g_lne.lne24) THEN
            IF g_lne.lne24 < 0 THEN 
               CALL cl_err('','alm-236',1)
               NEXT FIELD lne24 
            END IF 
         END IF 
        
       AFTER FIELD lne29 
         IF NOT cl_null(g_lne.lne29) THEN
            IF g_lne.lne29 < 0 THEN 
               CALL cl_err('','alm-241',1)
               NEXT FIELD lne29 
            END IF 
         END IF     
            
    #FUN-B90056 Mark Begin ---
    #AFTER FIELD lne25
    #    IF NOT cl_null(g_lne.lne25) AND NOT cl_null(g_lne.lne30) AND NOT cl_null(g_lne.lne55) THEN
    #      IF (p_cmd = 'a' AND w_cmd = 'a') OR 
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne25 != g_lne_t.lne25) OR
    #         (p_cmd = 'u' AND w_cmd = 'h') OR 
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne25 IS NULL) THEN  
    #         LET l_cnt = 0 
    #         SELECT COUNT(*) INTO l_cnt FROM lne_file
    #          WHERE lne25 = g_lne.lne25
    #            AND lne30 = g_lne.lne30
    #            AND lne55 = g_lne.lne55
    #         IF l_cnt > 0 THEN 
    #           CALL cl_err('','alm-140',0)
    #           NEXT FIELD lne25
    #        END IF   
    #      END IF   
    #    END IF      
   
    #AFTER FIELD lne30
    #    IF NOT cl_null(g_lne.lne30) AND NOT cl_null(g_lne.lne25) AND NOT cl_null(g_lne.lne55) THEN
    #      IF (p_cmd = 'a' AND w_cmd = 'a') OR 
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne30 != g_lne_t.lne30) OR
    #         (p_cmd = 'u' AND w_cmd = 'h') OR 
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne30 IS NULL) THEN  
    #         LET l_cnt = 0 
    #         SELECT COUNT(*) INTO l_cnt FROM lne_file
    #          WHERE lne25 = g_lne.lne25
    #            AND lne30 = g_lne.lne30
    #            AND lne55 = g_lne.lne55 
    #         IF l_cnt > 0 THEN 
    #           CALL cl_err('','alm-140',0)
    #           NEXT FIELD lne30
    #        END IF   
    #      END IF   
    #    END IF              
   
    #MOD-D30126 remark---START
    AFTER FIELD lne55
     ###FUN-A80073 START ###
     IF NOT cl_null(g_lne.lne55) THEN 
             SELECT COUNT(*) INTO l_cnt FROM lne_file
              WHERE lne55 = g_lne.lne55
             IF l_cnt > 0 THEN 
               CALL cl_err('','alm-h03',0)
             END IF 
     END IF        
     ###FUN-A80073 END ###
     IF NOT cl_null(g_lne.lne55) AND NOT cl_null(g_lne.lne25) AND NOT cl_null(g_lne.lne30) THEN
          IF (p_cmd = 'a' AND w_cmd = 'a') OR 
             (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne55 != g_lne_t.lne55) OR
             (p_cmd = 'u' AND w_cmd = 'h') OR 
             (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne55 IS NULL) THEN  
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM lne_file
              WHERE lne25 = g_lne.lne25
                AND lne30 = g_lne.lne30
                AND lne55 = g_lne.lne55
             IF l_cnt > 0 THEN 
               CALL cl_err('','alm-140',0)
               NEXT FIELD lne55
             END IF 
               
           END IF   
     END IF              
    #MOD-D30126 remark---END
    #  
    # AFTER FIELD lne26
    #   IF NOT cl_null(g_lne.lne26) THEN 
    #      IF (p_cmd = 'a' AND w_cmd = 'a') OR 
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne26 != g_lne_t.lne26) OR 
    #         (p_cmd = 'u' AND w_cmd = 'h') OR
    #         (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne26 IS NULL) THEN 
    #          SELECT COUNT(*) INTO l_count FROM lne_file
    #           WHERE lne26 = g_lne.lne26
    #          IF l_count > 0 THEN 
    #             CALL cl_err('','alm-625',1)
    #             NEXT FIELD lne26
    #          END IF   
    #       END IF
    #   END IF 	
    #FUN-B90056 Mark End -----
        
     AFTER FIELD lne40
        IF NOT cl_null(g_lne.lne40) THEN 
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM gec_file
            WHERE gec01 = g_lne.lne40
              AND gec011 = '2'
           IF l_cnt < 1 THEN 
              CALL cl_err('','alm-141',0)                 
              DISPLAY BY NAME g_lne.lne40
              NEXT FIELD lne40
           ELSE
              SELECT gecacti INTO l_gecacti FROM gec_file
               WHERE gec01 = g_lne.lne40
                 AND gec011 = '2'
              IF l_gecacti != 'Y' THEN 
                 CALL cl_err('','alm-142',0)                   
                 DISPLAY BY NAME g_lne.lne40
                 NEXT FIELD lne40   
              ELSE
              	  DISPLAY '' TO FORMONLY.gec02
              	  DISPLAY '' TO FORMONLY.gec04 
              	  DISPLAY '' TO FORMONLY.gec07 
              	  SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 
              	    FROM gec_file
              	   WHERE gec01 = g_lne.lne40
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
 
     AFTER FIELD lne42
        IF NOT cl_null(g_lne.lne42) THEN 
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM oag_file
            WHERE oag01 = g_lne.lne42
           IF l_cnt < 1 THEN 
              CALL cl_err('','alm-143',0)
              LET g_lne.lne42 = g_lne_t.lne42
              DISPLAY BY NAME g_lne.lne42
              NEXT FIELD lne42
           ELSE
              DISPLAY '' TO FORMONLY.oag02
              SELECT oag02 INTO l_oag02 FROM oag_file
               WHERE oag01 = g_lne.lne42
              DISPLAY l_oag02 TO FORMONLY.oag02    
           END IF   
        ELSE
           DISPLAY '' TO FORMONLY.oag02    
        END IF  
          
 
     AFTER FIELD lne56                                                 
        IF NOT cl_null(g_lne.lne56) THEN                                                      
           LET l_count = 0                                   
           SELECT ool02 INTO l_ool02 FROM ool_file
            WHERE ool01 = g_lne.lne56                                 
           IF STATUS = 100 THEN
               CALL cl_err('','alm-145',0)                        
               DISPLAY BY NAME g_lne.lne56                                    
               NEXT FIELD lne56                                                        
           END IF
           DISPLAY l_ool02 TO FORMONLY.ool02
        END IF                             
 
     AFTER FIELD lne57                                                   
        IF NOT cl_null(g_lne.lne57) THEN              
           LET l_count = 0                                                              
           SELECT azi02,aziacti INTO l_azi02,l_aziacti FROM azi_file
            WHERE azi01 = g_lne.lne57                                                 
           IF STATUS = 100 THEN
              CALL cl_err('','alm-146',0)                                   
              LET g_lne.lne57 = g_lne_t.lne57                                       
              DISPLAY BY NAME g_lne.lne57                                                
              NEXT FIELD lne57                                            
           ELSE
              IF l_aziacti <> 'Y' THEN
                 CALL cl_err('','alm-089',0)                                               
                 LET g_lne.lne57 = g_lne_t.lne57                                         
                 DISPLAY BY NAME g_lne.lne57                                  
                 NEXT FIELD lne57                             
              END IF
              DISPLAY l_azi02 TO FORMONLY.azi02
           END IF
        END IF
 
     AFTER FIELD lne50
        IF NOT cl_null(g_lne.lne50) THEN 
           LET l_cnt = 0 
           #MOD-C70217 mark start -----
           #SELECT COUNT(*) INTO l_cnt FROM nma_file
           # WHERE nma01 = g_lne.lne50
           #MOD-C70217 mark end   -----
           #MOD-C70217 add start -----
           SELECT COUNT(*) INTO l_cnt FROM nmt_file
            WHERE nmt01 = g_lne.lne50
           #MOD-C70217 add end   -----
           IF l_cnt < 1 THEN 
              CALL cl_err('','alm-144',0)
              LET g_lne.lne50 = g_lne_t.lne50
              DISPLAY BY NAME g_lne.lne50
              NEXT FIELD lne50
           ELSE
              #MOD-C70217 mark start -----
              #SELECT nmaacti INTO l_nmaacti FROM nma_file
              # WHERE nma01 = g_lne.lne50
              #IF l_nmaacti != 'Y' THEN 
              #MOD-C70217 mark end   -----
              #MOD-C70217 add start -----
               SELECT nmtacti INTO l_nmtacti FROM nmt_file
                WHERE nmt01 = g_lne.lne50
               IF l_nmtacti != 'Y' THEN
              #MOD-C70217 add end   -----
                 CALL cl_err('','alm-004',0)
                 LET g_lne.lne50 = g_lne_t.lne50
                 DISPLAY BY NAME g_lne.lne50
                 NEXT FIELD lne50
              ELSE
              #MOD-C70217 add start -----
              #   SELECT nma02 INTO l_nma02 FROM nma_file
              #    WHERE nma01 = g_lne.lne50
              #   LET g_lne.lne51 = l_nma02
              #   DISPLAY l_nma02 TO lne51    
              #MOD-C70217 add end   -----
              #MOD-C70217 add start -----
                  SELECT nmt02 INTO l_nmt02 FROM nmt_file
                     WHERE nmt01 = g_lne.lne50
                  LET g_lne.lne51 = l_nmt02
                  DISPLAY l_nmt02 TO lne51
              #MOD-C70217 add end   -----
              END IF   
           END IF     
        END IF  

    #FUN-B90056 Add Begin ---
     AFTER FIELD lne67
        IF NOT cl_null(g_lne.lne67) THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lne.lne67 <> g_lne_t.lne67) THEN
              CALL i300_lne67('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lne.lne67 = g_lne_t.lne67
                 DISPLAY BY NAME g_lne.lne67
                 NEXT FIELD lne67
              END IF
           END IF
        END IF
    #FUN-B90056 Add End -----
       
     
            
         
     AFTER INPUT        
        LET g_lne.lneuser = s_get_data_owner("lne_file") #FUN-C10039
        LET g_lne.lnegrup = s_get_data_group("lne_file") #FUN-C10039
        IF INT_FLAG THEN
           LET m_cmd = NULL
           LET g_lne03 = ''
           EXIT INPUT
        ELSE    
        ###################
        LET m_cmd = NULL
        
        IF NOT cl_null(g_lne.lne25) OR NOT cl_null(g_lne.lne26) OR  
           NOT cl_null(g_lne.lne30) OR NOT cl_null(g_lne.lne55) THEN 
           IF cl_null(g_lne.lne26) OR cl_null(g_lne.lne25) OR
              cl_null(g_lne.lne30) OR cl_null(g_lne.lne55) THEN
              CALL cl_err('','alm-656',1)
              NEXT FIELD lne26
           ELSE
              IF NOT cl_null(g_lne.lne26) THEN
                 IF (p_cmd = 'a' AND w_cmd = 'a') OR 
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne26 != g_lne_t.lne26) OR 
                    (p_cmd = 'u' AND w_cmd = 'h') OR 
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne26 IS NULL) THEN 
                    SELECT COUNT(*) INTO l_count FROM lne_file
                     WHERE lne26 = g_lne.lne26
                    IF l_count > 0 THEN 
                       CALL cl_err('','alm-625',1)
                       NEXT FIELD lne26
                    END IF   
                 END IF
              END IF
              IF NOT cl_null(g_lne.lne25) AND NOT cl_null(g_lne.lne30) AND NOT cl_null(g_lne.lne55) THEN
                 IF (p_cmd = 'a' AND w_cmd = 'a') OR 
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne25 != g_lne_t.lne25) OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne30 != g_lne_t.lne30) OR
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne.lne55 != g_lne_t.lne55) OR
                    (p_cmd = 'u' AND w_cmd = 'h') OR 
                    (p_cmd = 'u' AND w_cmd = 'u' AND g_lne_t.lne25 IS NULL) THEN  
                     LET l_cnt = 0 
                     SELECT COUNT(*) INTO l_cnt FROM lne_file
                      WHERE lne25 = g_lne.lne25
                        AND lne30 = g_lne.lne30
                        AND lne55 = g_lne.lne55 
                     IF l_cnt > 0 THEN 
                        CALL cl_err('','alm-140',0)
                        NEXT FIELD lne25
                     END IF   
                 END IF
              END IF
           END IF    
        END IF     
        
       	 ###########################          
           IF NOT cl_null(g_lne.lne08) THEN 
              IF g_lne.lne36 = 'N' THEN       #FUN-A80117 add 
                 CALL i300_xxx_lne08(g_lne.lne08)
                 IF g_success = 'N' THEN 
                    DISPLAY BY NAME g_lne.lne08
                   NEXT FIELD lne08
                 ELSE
             	     CALL i300_xxx_lne081(g_lne.lne08)   
                END IF    
              END IF                          #FUN-A80117 add   
           END IF     
           
           IF NOT cl_null(g_lne.lne09) THEN 
              IF g_lne.lne36 = 'N' THEN       #FUN-A80117 add 
                 CALL i300_xxx_lne09(g_lne.lne09)
                 IF g_success = 'N' THEN 
                    DISPLAY BY NAME g_lne.lne09
                    NEXT FIELD lne09
                 ELSE
             	     CALL i300_xxx_lne091(g_lne.lne09)   
                 END IF  
              END IF                          #FUN-A80117 add     
            END IF  
            
            SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 
              FROM gec_file
             WHERE gec01 = g_lne.lne40
               AND gec011 = '2'
               AND gecacti = 'Y'
            DISPLAY l_gec02 TO FORMONLY.gec02     
            DISPLAY l_gec04 TO FORMONLY.gec04 
            DISPLAY l_gec07 TO FORMONLY.gec07  
         END IF      
      
     ON ACTION CONTROLP
        CASE       
          WHEN INFIELD(lne03)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lnb"  
            LET g_qryparam.default1 = g_lne.lne03
            CALL cl_create_qry() RETURNING g_lne.lne03
            DISPLAY BY NAME g_lne.lne03
            NEXT FIELD lne03
            
         WHEN INFIELD(lne04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rtz28"  
            LET g_qryparam.default1 = g_lne.lne04
            CALL cl_create_qry() RETURNING g_lne.lne04
            DISPLAY BY NAME g_lne.lne04
            NEXT FIELD lne04
            
          WHEN INFIELD(lne08)
            CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_azfp1"              #FUN-A70063
            LET g_qryparam.form = "q_tqap1"              #FUN-A70063
            LET g_qryparam.default1 = g_lne.lne08         
            CALL cl_create_qry() RETURNING g_lne.lne08
            DISPLAY BY NAME g_lne.lne08
            NEXT FIELD lne08   
          
           WHEN INFIELD(lne09)
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_geo"   #TQC-C40051 mark 
            LET g_qryparam.form ="q_oqw"   #TQC-C40051 add
            LET g_qryparam.default1 = g_lne.lne09
            CALL cl_create_qry() RETURNING g_lne.lne09
            DISPLAY BY NAME g_lne.lne09
            NEXT FIELD lne09
          
           WHEN INFIELD(lne40)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gec9"  
            LET g_qryparam.default1 = g_lne.lne40           
            CALL cl_create_qry() RETURNING g_lne.lne40
            DISPLAY BY NAME g_lne.lne40
            NEXT FIELD lne40 
          
           WHEN INFIELD(lne42)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oag"  
            LET g_qryparam.default1 = g_lne.lne42
            CALL cl_create_qry() RETURNING g_lne.lne42
            DISPLAY BY NAME g_lne.lne42
            NEXT FIELD lne42
          
           WHEN INFIELD(lne50)
            CALL cl_init_qry_var()
            #LET g_qryparam.form = "q_nma" #MOD-C70217 mark 
            LET g_qryparam.form = "q_nmt"  #MOD-C70217 add
            LET g_qryparam.default1 = g_lne.lne50
            CALL cl_create_qry() RETURNING g_lne.lne50
            DISPLAY BY NAME g_lne.lne50
            NEXT FIELD lne50
            
           WHEN INFIELD(lne56)                                                                                              
            CALL cl_init_qry_var()                                                                                          
            LET g_qryparam.form ="q_ool"                                                                                    
            LET g_qryparam.default1 = g_lne.lne56                                                                           
            CALL cl_create_qry() RETURNING g_lne.lne56                                                                      
            DISPLAY BY NAME g_lne.lne56                                                                                     
            NEXT FIELD lne56  
 
          WHEN INFIELD(lne57)                                                                                               
            CALL cl_init_qry_var()                                                                                          
            LET g_qryparam.form = "q_azi"                                                                                   
            LET g_qryparam.default1 = g_lne.lne57                                                      
            CALL cl_create_qry() RETURNING g_lne.lne57                                                        
            DISPLAY BY NAME g_lne.lne57                                                       
            NEXT FIELD lne57    
            
          ###FUN-A80073 START ###
          WHEN INFIELD(lne61)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azp"
             LET g_qryparam.default1 = g_lne.lne61
             CALL cl_create_qry() RETURNING g_lne.lne61
             DISPLAY BY NAME g_lne.lne61
             NEXT FIELD lne61   
             
          WHEN INFIELD(lne62)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_oca"
             LET g_qryparam.default1 = g_lne.lne62
             CALL cl_create_qry() RETURNING g_lne.lne62
             DISPLAY BY NAME g_lne.lne62
             NEXT FIELD lne62  
             
          WHEN INFIELD(lne64)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_occ02_2"
             LET g_qryparam.default1 = g_lne.lne64
             CALL cl_create_qry() RETURNING g_lne.lne64,l_lne64_n
             DISPLAY BY NAME g_lne.lne64
             DISPLAY l_lne64_n TO FORMONLY.lne64_n
             NEXT FIELD lne64         
          ###FUN-A80073 END ###  

         #FUN-B90056 Add Begin ---
          WHEN INFIELD(lne67)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = '33'
             LET g_qryparam.default1 = g_lne.lne67
             CALL cl_create_qry() RETURNING g_lne.lne67
             DISPLAY BY NAME g_lne.lne67
             CALL i300_lne67('d')
             NEXT FIELD lne67
         #FUN-B90056 Add End -----

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
 
FUNCTION i300_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lne.* TO NULL
    INITIALIZE g_lne_t.* TO NULL
    INITIALIZE g_lne_o.* TO NULL
    
    LET g_lne01_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cn2
    
    CALL i300_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lne.* TO NULL
      #FUN-B90056 Add Begin ---
       LET g_rec_b1 = 0
       LET g_rec_b2 = 0
       LET g_rec_b3 = 0
       LET g_wc1 = NULL
       LET g_wc2 = NULL
       LET g_wc3 = NULL
      #FUN-B90056 Add End -----
       LET g_lne01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN i300_count
    FETCH i300_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    OPEN i300_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
       INITIALIZE g_lne.* TO NULL
       LET g_lne01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL i300_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i300_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     i300_cs INTO g_lne.lne01
        WHEN 'P' FETCH PREVIOUS i300_cs INTO g_lne.lne01
        WHEN 'F' FETCH FIRST    i300_cs INTO g_lne.lne01
        WHEN 'L' FETCH LAST     i300_cs INTO g_lne.lne01
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
            FETCH ABSOLUTE g_jump i300_cs INTO g_lne.lne01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
       INITIALIZE g_lne.* TO NULL
       LET g_lne01_t = NULL
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
 
    SELECT * INTO g_lne.* FROM lne_file  
     WHERE lne01 = g_lne.lne01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lne.lneuser 
       LET g_data_group = g_lne.lnegrup
       CALL i300_show() 
    END IF
END FUNCTION
 
FUNCTION i300_show()
    LET g_lne_t.* = g_lne.*
    LET g_lne_o.* = g_lne.*
    DISPLAY BY NAME g_lne.lne01,g_lne.lne02,g_lne.lne03,g_lne.lne04,g_lne.lne05, g_lne.lneoriu,g_lne.lneorig,
                    g_lne.lne06,g_lne.lne07,g_lne.lne08,g_lne.lne09,g_lne.lne10,
                    g_lne.lne12,g_lne.lne13,g_lne.lne14,g_lne.lne15,g_lne.lne16,
                    g_lne.lne17,g_lne.lne18,g_lne.lne19,g_lne.lne20,g_lne.lne21,
                   #g_lne.lne22,g_lne.lne23,g_lne.lne24,g_lne.lne27,g_lne.lne28,  #FUN-B90056 MARK
                    g_lne.lne22,g_lne.lne23,g_lne.lne24,g_lne.lne28,              #FUN-B90056 ADD
                   #g_lne.lne29,g_lne.lne26,g_lne.lne25,g_lne.lne30,g_lne.lne55,  #FUN-B90056 MARK
                    g_lne.lne55,                                                  #MOD-D30126 add
                    g_lne.lne29,g_lne.lne67,g_lne.lne68,                          #FUN-B90056 ADD
                    g_lne.lne31,g_lne.lne32,g_lne.lne33,g_lne.lne34,g_lne.lne35,
                    g_lne.lne36,g_lne.lne37,g_lne.lne38,g_lne.lne39,g_lne.lne40,
                    g_lne.lne41,g_lne.lne42,g_lne.lne43,g_lne.lne56,g_lne.lne57,
                    g_lne.lne44,g_lne.lne45,g_lne.lne46,g_lne.lne47,g_lne.lne48,
                    g_lne.lne49,g_lne.lne50,g_lne.lne51,g_lne.lne52,g_lne.lne53,
                    g_lne.lne54,g_lne.lne58,g_lne.lne59,
                    g_lne.lneuser,g_lne.lnegrup,g_lne.lnecrat,g_lne.lnemodu,
                    g_lne.lnedate,
                    g_lne.lne61,g_lne.lne62,g_lne.lne63,g_lne.lne64,g_lne.lne66  #FUN-A80073 ---ADD---
              
    CALL cl_show_fld_cont()  
    CALL i300_pic()
    CALL i300_xxx_lne04(g_lne.lne04)
    CALL i300_xxx_show()

    CALL i300_lne67('d')      #FUN-B90056 ADD

    CALL i300_b1_fill(g_wc1)  #FUN-B90056 ADD
    CALL i300_b2_fill(g_wc2)  #FUN-B90056 ADD
    CALL i300_b3_fill(g_wc3)  #FUN-B90056 ADD
END FUNCTION
 
FUNCTION i300_xxx_show()
#DEFINE  l_azf03    LIKE azf_file.azf03  #FUN-A70063 mark 
 DEFINE  l_tqa02    LIKE tqa_file.tqa02  #FUN-A70063  
 DEFINE  l_geo02    LIKE geo_file.geo02
 DEFINE  l_gec02    LIKE gec_file.gec02
 DEFINE  l_gec04    LIKE gec_file.gec04 
 DEFINE  l_gec07    LIKE gec_file.gec07 
 DEFINE  l_oag02    LIKE oag_file.oag02
 DEFINE  l_ool02    LIKE ool_file.ool02
 DEFINE  l_azi02    LIKE azi_file.azi02
 DEFINE  l_azp02    LIKE azp_file.azp02 #FUN-A80073 ---ADD---
 DEFINE  l_oca02    LIKE oca_file.oca02 #FUN-A80073 ---ADD---
 DEFINE  l_occ02    LIKE occ_file.occ02 #FUN-A80073 ---ADD---

 
 
#DISPLAY '' TO FORMONLY.azf03            #FUN-A70063 mark 
 DISPLAY '' TO FORMONLY.tqa02            #FUN-A70063
 DISPLAY '' TO FORMONLY.geo02
 DISPLAY '' TO FORMONLY.gec02
 DISPLAY '' TO FORMONLY.gec04 
 DISPLAY '' TO FORMONLY.gec07 
 DISPLAY '' TO FORMONLY.oag02
 DISPLAY '' TO FORMONLY.lne61_n #FUN-A80073 ---ADD---
 DISPLAY '' TO FORMONLY.lne62_n #FUN-A80073 ---ADD---
 DISPLAY '' TO FORMONLY.lne64_n #FUN-A80073 ---ADD---
  
#FUN-A70063--begin--
#IF NOT cl_null(g_lne.lne08) THEN 
#   SELECT azf03 INTO l_azf03 FROM azf_file
#    WHERE azf01 = g_lne.lne08
#      AND azf02 = '3'
#      AND azfacti = 'Y'
#   DISPLAY l_azf03 TO FORMONLY.azf03   
#END IF  
#FUN-A70063--end-- 

#FUN-A70063--begin--
 IF NOT cl_null(g_lne.lne08) THEN 
    SELECT tqa02 INTO l_tqa02 FROM tqa_file 
     WHERE tqa03 = '2'
       AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
       AND tqa01 = g_lne.lne08
       AND tqaacti = 'Y'
    DISPLAY l_tqa02 TO FORMONLY.tqa02
 END IF  
#FUN-A70063--end--

#FUN-B90056 Add Begin ---
 IF NOT cl_null(g_lne.lne68) THEN
    LET l_tqa02 = NULL
    SELECT tqa02 INTO l_tqa02 FROM tqa_file 
     WHERE tqa03 = '32'
       AND tqa01 = g_lne.lne68
    DISPLAY l_tqa02 TO FORMONLY.lne68_desc
 ELSE
    IF NOT cl_null(g_lne.lne08) THEN
       SELECT tqa09 INTO g_lne.lne68 FROM tqa_file WHERE tqa01 = g_lne.lne08 AND tqa03 = '2' AND tqaacti = 'Y'
       LET l_tqa02 = NULL
       SELECT tqa02 INTO l_tqa02 FROM tqa_file
        WHERE tqa03 = '32' AND tqa01 = g_lne.lne68
       DISPLAY l_tqa02 TO FORMONLY.lne68_desc
       DISPLAY BY NAME g_lne.lne68
    END IF
 END IF
#FUN-B90056 Add End -----
 
 IF NOT cl_null(g_lne.lne09) THEN 
   #SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
   # WHERE geo01 = g_lne.lne09               #TQC-C40051 mark
    SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
     WHERE oqw01 = g_lne.lne09               #TQC-C40051 add 
       AND oqwacti = 'Y'
     DISPLAY l_geo02 TO FORMONLY.geo02  
 END IF 
 
 IF NOT cl_null(g_lne.lne40) THEN 
    SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
     WHERE gec01 = g_lne.lne40
       AND gecacti = 'Y'
       AND gec011  = '2'
     DISPLAY l_gec02 TO FORMONLY.gec02  
     DISPLAY l_gec04 TO FORMONLY.gec04 
     DISPLAY l_gec07 TO FORMONLY.gec07 
 END IF 
 
 IF NOT cl_null(g_lne.lne42) THEN 
    SELECT oag02 INTO l_oag02 FROM oag_file
     WHERE oag01 = g_lne.lne42
    DISPLAY l_oag02 TO FORMONLY.oag02 
 END IF  
 
   IF NOT cl_null(g_lne.lne56) THEN
      SELECT ool02 INTO l_ool02 FROM ool_file
       WHERE ool01 = g_lne.lne56
      DISPLAY l_ool02 TO FORMONLY.ool02
   END IF
 
   IF NOT cl_null(g_lne.lne57) THEN
      SELECT azi02 INTO l_azi02 FROM azi_file
       WHERE azi01 = g_lne.lne57
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
   
   ###FUN-A80073 START ###
   IF NOT cl_null(g_lne.lne61) THEN 
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_lne.lne61
     DISPLAY l_azp02 TO FORMONLY.lne61_n  
   END IF
   
   IF NOT cl_null(g_lne.lne62) THEN 
    SELECT oca02 INTO l_oca02 FROM oca_file
     WHERE oca01 = g_lne.lne62
     DISPLAY l_oca02 TO FORMONLY.lne62_n  
   END IF
 
   IF NOT cl_null(g_lne.lne64) THEN 
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_lne.lne64 
     AND occacti = 'Y' 
     DISPLAY l_occ02 TO FORMONLY.lne64_n  
   END IF
   ###FUN-A80073 END ###
END FUNCTION 
 
FUNCTION i300_u(p_w,w_cmd)
 DEFINE   p_w         LIKE type_file.chr1
 DEFINE   w_cmd       LIKE type_file.chr1
 DEFINE   l_n         LIKE type_file.num5
 DEFINE   l_change    LIKE lne_file.lne03
  
    LET l_change = g_lne.lne03
 
    IF cl_null(g_lne.lne01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF       
        
    SELECT * INTO g_lne.* FROM lne_file 
      WHERE lne01 = g_lne.lne01
  
   IF w_cmd = 'M' THEN
   ELSE
      IF g_lne.lne36 = 'Y' THEN
         CALL cl_err(g_lne.lne01,'alm-027',1)
         RETURN
      END IF    
   END IF
 
   IF g_lne.lne36 = 'X' THEN
      CALL cl_err(g_lne.lne01,'alm-134',1)
     RETURN
   END IF    
   
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lne01_t = g_lne.lne01
    BEGIN WORK
 
    OPEN i300_cl USING g_lne.lne01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:",STATUS,1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_lne.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lne.lne01,SQLCA.sqlcode,1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
     ###############
     LET g_date = g_lne.lnedate
     LET g_modu = g_lne.lnemodu
     ############### 
    IF p_w != 'c' THEN 
        LET g_lne.lnemodu = g_user  
        LET g_lne.lnedate = g_today 
    ELSE
    	LET g_lne.lnemodu = NULL
      LET g_lne.lnedate = NULL  
    END IF  	    
    
    CALL i300_show()                 
    WHILE TRUE
        IF p_w != 'c' THEN 
          CALL i300_i('u','u',w_cmd)        
        ELSE
        	LET g_lne.lne03 = ''
        	LET g_lne.lne25 = ''
        	LET g_lne.lne26 = ''
        	let g_lne.lne30 = ''
        	DISPLAY BY NAME g_lne.lne03,g_lne.lne25,
        	                g_lne.lne26,g_lne.lne30
        	CALL i300_i('u','h','')
        END IF  	  
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_lne_t.lnedate = g_date
           LET g_lne_t.lnemodu = g_modu
           LET g_lne_t.lne03 = g_lne.lne03
           LET g_lne_t.lne25 = g_lne.lne25
           LET g_lne_t.lne26 = g_lne.lne26
           LET g_lne_t.lne30 = g_lne.lne30
           LET g_lne.*=g_lne_t.*
           CALL i300_show()     
           CALL cl_err('',9001,0)        
           EXIT WHILE           
        END IF
 
       UPDATE lne_file SET lne_file.* = g_lne.* 
         WHERE lne01 = g_lne01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        ELSE
           IF g_aza.aza113 = 'Y' THEN
              IF g_lne.lne03 != l_change OR (l_change IS NULL AND g_lne.lne03 IS NOT NULL)
                 OR (l_change IS NOT NULL AND g_lne.lne03 IS NULL) THEN
                 DELETE FROM lnf_file WHERE lnf01 = g_lne.lne01
                                        AND lnf02 = '0'
                 DELETE FROM lng_file WHERE lng01 = g_lne.lne01
                                        AND lng02 = '0'
                #FUN-B90056 Add Begin ---
                 DELETE FROM lnh_file WHERE lnh01 = g_lne.lne01
                                        AND lnh02 = '0'
                #FUN-B90056 Add End -----
                 CALL i300_bring()
                #FUN-B90056 Add Begin ---
                 CALL i300_b1_fill(" 1=1")
                 CALL i300_b2_fill(" 1=1")
                 CALL i300_b3_fill(" 1=1")
                #FUN-B90056 Add End -----
                 LET l_change = NULL
              END IF
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_r()
DEFINE l_gca01   LIKE gca_file.gca01 #FUN-B90056 Add
DEFINE l_gca07   LIKE gca_file.gca07 #FUN-B90056 Add
DEFINE l_gca08   LIKE gca_file.gca08 #FUN-B90056 Add
DEFINE l_gca09   LIKE gca_file.gca09 #FUN-B90056 Add
DEFINE l_gca10   LIKE gca_file.gca10 #FUN-B90056 Add
 
    IF cl_null(g_lne.lne01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_lne.lne36 = 'Y' THEN 
       CALL cl_err(g_lne.lne01,'alm-028',1)
       RETURN
     END IF
     
    IF g_lne.lne36 = 'X' THEN 
       CALL cl_err(g_lne.lne01,'alm-134',1)
       RETURN
     END IF
     
    BEGIN WORK
 
    OPEN i300_cl USING g_lne.lne01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:",STATUS,0)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_lne.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i300_show()
   #IF cl_delete() THEN   #FUN-B90056 Mark
    IF cl_delh(0,0) THEN  #FUN-B90056 Add
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lne01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lne.lne01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      #FUN-B90056 Add Begin ---
       LET l_gca01 = "lne01=",g_lne.lne01
       SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
        WHERE gca01 =l_gca01
       DELETE FROM gca_file WHERE gca01 = l_gca01
       DELETE FROM gcb_file WHERE gcb01 = l_gca07
                              AND gcb02 = l_gca08
                              AND gcb03 = l_gca09
                              AND gcb04 = l_gca10
      #FUN-B90056 Add End -----
       DELETE FROM lne_file  WHERE lne01  = g_lne.lne01
       DELETE FROM lnf_file  WHERE lnf01  = g_lne.lne01
       DELETE FROM lng_file  WHERE lng01  = g_lne.lne01
       DELETE FROM lnh_file  WHERE lnh01  = g_lne.lne01 #FUN-B90056 ADD
       CLEAR FORM
      #FUN-B90056 Add Begin ---
       CALL g_lng.clear()
       CALL g_lnf.clear()
       CALL g_lnh.clear()
      #FUN-B90056 Add End -----
       OPEN i300_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i300_cs
          CLOSE i300_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       FETCH i300_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i300_cs
          CLOSE i300_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cn2
       OPEN i300_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i300_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i300_fetch('/')
       END IF
    END IF
    CLOSE i300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_copy()
DEFINE l_newno   LIKE lne_file.lne01
DEFINE l_oldno   LIKE lne_file.lne01
DEFINE g_code    LIKE lne_file.lne04
 
    IF cl_null(g_lne.lne01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i300_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lne01
 
        AFTER FIELD lne01 
          IF NOT cl_null(l_newno) THEN           
             CALL i300_check_lne01(l_newno) 
             IF g_success = 'N' THEN                                                                                        
                LET g_lne.lne01 = g_lne_t.lne01                                                                             
                DISPLAY BY NAME g_lne.lne01                                                                                 
                NEXT FIELD lne01                                                                                            
              END IF
          ELSE 
          	 CALL cl_err(l_newno,'alm-055',1)
          	 NEXT FIELD lne01    
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT    
          END IF   
       
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
       DISPLAY BY NAME g_lne.lne01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lne_file
     WHERE lne01=g_lne.lne01
      INTO TEMP x
    UPDATE x
        SET lne01=l_newno,   
            lneuser=g_user, 
            lnegrup=g_grup, 
            lnemodu=NULL, 
            lnedate=NULL,  
            lnecrat=g_today,  
            lne02   = '0',
            lne34   = 'N',
            lne35   = '0',
            lne36   = 'N',
            lne37   = NULL,
            lne38   = NULL,
            lne25   = NULL,
            lne30   = NULL,
            lne55   = NULL,
            lne59   = 'N',
            lne26   = NULL    
    INSERT INTO lne_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lne.lne01
       LET g_lne.lne01 = l_newno
       SELECT lne_file.* INTO g_lne.*
         FROM lne_file
         WHERE lne01  = l_newno
       CALL i300_u('c','')  
       UPDATE lne_file SET lne25 = g_lne.lne25,
                           lne03 = g_lne.lne03,
                           lne26 = g_lne.lne26,
                           lne30 = g_lne.lne30,
                           lne55 = g_lne.lne55
        WHERE lne01 = l_newno
       LET g_code = g_lne.lne04
       #FUN-C30027---begin
       #SELECT lne_file.* INTO g_lne.*
       #  FROM lne_file
       #  WHERE lne01 = l_oldno
       #FUN-C30027---end
    END IF
    #LET g_lne.lne01 = l_oldno  #FUN-C30027
    CALL i300_show()
    CALL i300_c(g_lne.lne01,l_newno,g_code)
END FUNCTION
 
FUNCTION i300_c(p_cmd,w_cmd,c_code)
  DEFINE g_sql    STRING
  DEFINE g_cnt    LIKE type_file.num5
  DEFINE p_cmd    LIKE  lne_file.lne01
  DEFINE w_cmd    LIKE lne_file.lne01
  DEFINE c_code    LIKE lne_file.lne04
  
  DEFINE l_lnf   DYNAMIC ARRAY OF RECORD           
             lnf02   LIKE lnf_file.lnf02,
             lnf03   LIKE lnf_file.lnf03,
             lnf04   LIKE lnf_file.lnf04       
                    END RECORD 
  DEFINE l_lng   DYNAMIC ARRAY OF RECORD
              lng02   LIKE lng_file.lng02,
              lng03   LIKE lng_file.lng03,
              lng04   LIKE lng_file.lng04,
              lng05   LIKE lng_file.lng05,
              lng06   LIKE lng_file.lng06,
              lng07   LIKE lng_file.lng07
                 END RECORD 
  DEFINE l_lnh   DYNAMIC ARRAY OF RECORD 
              lnh02   LIKE lnh_file.lnh02,
              lnhstore   LIKE lnh_file.lnhstore,
              lnh04   LIKE lnh_file.lnh04,
              lnh05   LIKE lnh_file.lnh05,
              lnh06   LIKE lnh_file.lnh06,
              lnh07   LIKE lnh_file.lnh07
                 END RECORD   
                 
   LET g_sql  = "select lnf02,lnf03,lnf04 from lnf_file ",
               " where ",
               " lnf01 = '",p_cmd,"' "              
    PREPARE c_1 FROM g_sql
    DECLARE c1_curs CURSOR FOR c_1
 
    CALL l_lnf.clear()
    LET g_cnt = 1
    FOREACH c1_curs INTO l_lnf[g_cnt].*  
    
       IF NOT cl_null(l_lnf[g_cnt].lnf03) THEN
          INSERT INTO lnf_file(lnf00,lnf01,lnf02,lnf03,lnf04)
          VALUES(c_code,w_cmd,l_lnf[g_cnt].lnf02,l_lnf[g_cnt].lnf03,l_lnf[g_cnt].lnf04) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH                         
   ############################
   LET g_sql  = "select lng02,lng03,lng04,lng05,lng06,lng07 from lng_file ",
               " where ",
               " lng01 = '",p_cmd,"' "               
    PREPARE c_2 FROM g_sql
    DECLARE c2_curs CURSOR FOR c_2
 
    CALL l_lng.clear()
    LET g_cnt = 1
    FOREACH c2_curs INTO l_lng[g_cnt].*  
    
       IF NOT cl_null(l_lng[g_cnt].lng03) AND NOT cl_null(l_lng[g_cnt].lng04) THEN
          INSERT INTO lng_file(lng00,lng01,lng02,lng03,lng04,lng05,lng06,lng07)
          VALUES(c_code,w_cmd,l_lng[g_cnt].lng02,l_lng[g_cnt].lng03,l_lng[g_cnt].lng04,
                 l_lng[g_cnt].lng05,l_lng[g_cnt].lng06,l_lng[g_cnt].lng07) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH     
    #######################
     LET g_sql  = "select lnh02,lnhstore,lnh04,lnh05,lnh06,lnh07 from lnh_file ",
               " where ",
               " lnh01 = '",p_cmd,"' " 
    PREPARE c_3 FROM g_sql
    DECLARE c3_curs CURSOR FOR c_3
 
    CALL l_lnh.clear()
    LET g_cnt = 1
    FOREACH c3_curs INTO l_lnh[g_cnt].*  
    
       IF NOT cl_null(l_lnh[g_cnt].lnhstore)  THEN
          INSERT INTO lnh_file(lnh00,lnh01,lnh02,lnhstore,lnh04,lnh05,lnh06,lnh07)
          VALUES(c_code,w_cmd,l_lnh[g_cnt].lnh02,l_lnh[g_cnt].lnhstore,l_lnh[g_cnt].lnh04,
                 l_lnh[g_cnt].lnh05,'N',l_lnh[g_cnt].lnh07) 
       ELSE
       	 EXIT FOREACH    
       END IF                         
       
       LET g_cnt = g_cnt + 1       
    END FOREACH                     
 
END FUNCTION 
 
FUNCTION i300_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lne01",TRUE)
   END IF
  
END FUNCTION
 
FUNCTION i300_xxx()  
  DEFINE l_lnb03    LIKE lnb_file.lnb03,
         l_lnb05    LIKE lnb_file.lnb05,
         l_lnb06    LIKE lnb_file.lnb06,
         l_lnb07    LIKE lnb_file.lnb07,
         l_lnb08    LIKE lnb_file.lnb08,
         l_lnb09    LIKE lnb_file.lnb09,
         l_lnb10    LIKE lnb_file.lnb10,        
         l_lnb12    LIKE lnb_file.lnb12,
         l_lnb13    LIKE lnb_file.lnb13,
         l_lnb14    LIKE lnb_file.lnb14,
         l_lnb15    LIKE lnb_file.lnb15,
         l_lnb16    LIKE lnb_file.lnb16,
         l_lnb17    LIKE lnb_file.lnb17,
         l_lnb18    LIKE lnb_file.lnb18,
         l_lnb19    LIKE lnb_file.lnb19,
         l_lnb20    LIKE lnb_file.lnb20,
         l_lnb21    LIKE lnb_file.lnb21,
         l_lnb22    LIKE lnb_file.lnb22,
         l_lnb23    LIKE lnb_file.lnb23,
         l_lnb24    LIKE lnb_file.lnb24,
         l_lnb25    LIKE lnb_file.lnb25,
         l_lnb26    LIKE lnb_file.lnb26,
         l_lnb27    LIKE lnb_file.lnb27,
         l_lnb28    LIKE lnb_file.lnb28,
         l_lnb29    LIKE lnb_file.lnb29,
         l_lnb30    LIKE lnb_file.lnb30,
         l_lnb37    LIKE lnb_file.lnb37,
         l_lnb38    LIKE lnb_file.lnb38,
         l_lnb39    LIKE lnb_file.lnb39,
         l_lnb40    LIKE lnb_file.lnb40,
         l_lnb41    LIKE lnb_file.lnb41,
         l_lnb42    LIKE lnb_file.lnb42,
         l_lnb43    LIKE lnb_file.lnb43,
         l_lnb44    LIKE lnb_file.lnb44,
         l_lnb45    LIKE lnb_file.lnb45,
         l_lnb46    LIKE lnb_file.lnb46,
         l_lnb47    LIKE lnb_file.lnb47,
         l_lnb48    LIKE lnb_file.lnb48,
         l_lnb49    LIKE lnb_file.lnb49,
         l_lnb50    LIKE lnb_file.lnb50,
         l_lnb51    LIKE lnb_file.lnb51,
         l_lnb52    LIKE lnb_file.lnb52,
         l_lnb53    LIKE lnb_file.lnb53         
                         
   
  IF NOT cl_null(g_lne.lne03) THEN  
     
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
     WHERE lnb01 = g_lne.lne03     
    
     IF g_lne.lne03 = g_lne03 THEN 
        LET l_lnb03     = g_lne.lne04
        LET l_lnb05     = g_lne.lne05
        LET l_lnb06     = g_lne.lne06
        LET l_lnb07     = g_lne.lne07
        LET l_lnb08     = g_lne.lne08
        LET l_lnb09     = g_lne.lne09
        LET l_lnb10     = g_lne.lne10       
        LET l_lnb12     = g_lne.lne12
        LET l_lnb13     = g_lne.lne13
        LET l_lnb14     = g_lne.lne14
        LET l_lnb15     = g_lne.lne15
        LET l_lnb16     = g_lne.lne16
        LET l_lnb17     = g_lne.lne17
        LET l_lnb18     = g_lne.lne18
        LET l_lnb19     = g_lne.lne19
        LET l_lnb20     = g_lne.lne20
        LET l_lnb21     = g_lne.lne21
        LET l_lnb22     = g_lne.lne22                        
        LET l_lnb23     = g_lne.lne23
        LET l_lnb24     = g_lne.lne24
        LET l_lnb25     = g_lne.lne25
        LET l_lnb26     = g_lne.lne26
        LET l_lnb27     = g_lne.lne27
        LET l_lnb28     = g_lne.lne28
        LET l_lnb29     = g_lne.lne29
        LET l_lnb30     = g_lne.lne30 
        LET l_lnb37     = g_lne.lne40 
        LET l_lnb38     = g_lne.lne41 
        LET l_lnb39     = g_lne.lne42 
        LET l_lnb40     = g_lne.lne43 
        LET l_lnb41     = g_lne.lne44 
        LET l_lnb42     = g_lne.lne45 
        LET l_lnb43     = g_lne.lne46 
        LET l_lnb44     = g_lne.lne47 
        LET l_lnb45     = g_lne.lne48 
        LET l_lnb46     = g_lne.lne49 
        LET l_lnb47     = g_lne.lne50 
        LET l_lnb48     = g_lne.lne51 
        LET l_lnb49     = g_lne.lne52 
        LET l_lnb50     = g_lne.lne53 
        LET l_lnb51     = g_lne.lne54 
        LET l_lnb52     = g_lne.lne56 
        LET l_lnb53     = g_lne.lne57
        LET g_lne.lne04 = l_lnb03
        LET g_lne.lne05 = l_lnb05
        LET g_lne.lne06 = l_lnb06
        LET g_lne.lne07 = l_lnb07
        LET g_lne.lne08 = l_lnb08
        LET g_lne.lne09 = l_lnb09
        LET g_lne.lne10 = l_lnb10      
        LET g_lne.lne12 = l_lnb12
        LET g_lne.lne13 = l_lnb13
        LET g_lne.lne14 = l_lnb14
        LET g_lne.lne15 = l_lnb15
        LET g_lne.lne16 = l_lnb16
        LET g_lne.lne17 = l_lnb17 
        LET g_lne.lne18 = l_lnb18
        LET g_lne.lne19 = l_lnb19
        LET g_lne.lne20 = l_lnb20
        LET g_lne.lne21 = l_lnb21
        LET g_lne.lne22 = l_lnb22                        
        LET g_lne.lne23 = l_lnb23
        LET g_lne.lne24 = l_lnb24 
        LET g_lne.lne25 = l_lnb25
        LET g_lne.lne26 = l_lnb26
        LET g_lne.lne27 = l_lnb27
        LET g_lne.lne28 = l_lnb28
        LET g_lne.lne29 = l_lnb29 
        LET g_lne.lne30 = l_lnb30 
        LET g_lne.lne40 = l_lnb37 
        LET g_lne.lne41 = l_lnb38 
        LET g_lne.lne42 = l_lnb39 
        LET g_lne.lne43 = l_lnb40 
        LET g_lne.lne44 = l_lnb41 
        LET g_lne.lne45 = l_lnb42 
        LET g_lne.lne46 = l_lnb43 
        LET g_lne.lne47 = l_lnb44 
        LET g_lne.lne48 = l_lnb45 
        LET g_lne.lne49 = l_lnb46 
        LET g_lne.lne50 = l_lnb47 
        LET g_lne.lne51 = l_lnb48 
        LET g_lne.lne52 = l_lnb49 
        LET g_lne.lne53 = l_lnb50 
        LET g_lne.lne54 = l_lnb51 
        LET g_lne.lne56 = l_lnb52
        LET g_lne.lne57 = l_lnb53
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
        LET g_lne.lne04 = l_lnb03
        LET g_lne.lne05 = l_lnb05
        LET g_lne.lne06 = l_lnb06
        LET g_lne.lne07 = l_lnb07
        LET g_lne.lne08 = l_lnb08
        LET g_lne.lne09 = l_lnb09
        LET g_lne.lne10 = l_lnb10      
        LET g_lne.lne12 = l_lnb12
        LET g_lne.lne13 = l_lnb13
        LET g_lne.lne14 = l_lnb14
        LET g_lne.lne15 = l_lnb15
        LET g_lne.lne16 = l_lnb16
        LET g_lne.lne17 = l_lnb17 
        LET g_lne.lne18 = l_lnb18
        LET g_lne.lne19 = l_lnb19
        LET g_lne.lne20 = l_lnb20
        LET g_lne.lne21 = l_lnb21
        LET g_lne.lne22 = l_lnb22                        
        LET g_lne.lne23 = l_lnb23
        LET g_lne.lne24 = l_lnb24 
        LET g_lne.lne25 = l_lnb25
        LET g_lne.lne26 = l_lnb26
        LET g_lne.lne27 = l_lnb27
        LET g_lne.lne28 = l_lnb28
        LET g_lne.lne29 = l_lnb29 
        LET g_lne.lne30 = l_lnb30
        LET g_lne.lne40 = l_lnb37  
        LET g_lne.lne41 = l_lnb38  
        LET g_lne.lne42 = l_lnb39 
        LET g_lne.lne43 = l_lnb40 
        LET g_lne.lne44 = l_lnb41 
        LET g_lne.lne45 = l_lnb42 
        LET g_lne.lne46 = l_lnb43 
        LET g_lne.lne47 = l_lnb44 
        LET g_lne.lne48 = l_lnb45 
        LET g_lne.lne49 = l_lnb46 
        LET g_lne.lne50 = l_lnb47 
        LET g_lne.lne51 = l_lnb48 
        LET g_lne.lne52 = l_lnb49 
        LET g_lne.lne53 = l_lnb50 
        LET g_lne.lne54 = l_lnb51 
        LET g_lne.lne56 = l_lnb52
        LET g_lne.lne57 = l_lnb53
     END IF
   DISPLAY l_lnb03,l_lnb05,l_lnb06,l_lnb07,l_lnb08,l_lnb09,l_lnb10,l_lnb12,
           l_lnb13,l_lnb14,l_lnb15,l_lnb16,l_lnb17,l_lnb18,l_lnb19,l_lnb20,
          #l_lnb21,l_lnb22,l_lnb23,l_lnb24,l_lnb25,l_lnb26,l_lnb27,l_lnb28,   #FUN-B90056 MARK
           l_lnb21,l_lnb22,l_lnb23,l_lnb24,l_lnb28,                           #FUN-B90056 ADD
          #l_lnb29,l_lnb30,l_lnb37,l_lnb38,l_lnb39,l_lnb40,l_lnb41,l_lnb42,   #FUN-B90056 MARK
           l_lnb29,l_lnb37,l_lnb38,l_lnb39,l_lnb40,l_lnb41,l_lnb42,           #FUN-B90056 ADD
           l_lnb43,l_lnb44,l_lnb45,l_lnb46,l_lnb47,l_lnb48,l_lnb49,l_lnb50,
           l_lnb51,l_lnb52,l_lnb53  
        TO lne04,lne05,lne06,lne07,lne08,lne09,lne10,lne12,lne13,lne14,lne15,
          #lne16,lne17,lne18,lne19,lne20,lne21,lne22,lne23,lne24,lne25,lne26, #FUN-B90056 MARK
           lne16,lne17,lne18,lne19,lne20,lne21,lne22,lne23,lne24,             #FUN-B90056 ADD
          #lne27,lne28,lne29,lne30,lne40,lne41,lne42,lne43,lne44,lne45,lne46, #FUN-B90056 MARK
           lne28,lne29,lne40,lne41,lne42,lne43,lne44,lne45,lne46,             #FUN-B90056 ADD
           lne47,lne48,lne49,lne50,lne51,lne52,lne53,lne54,lne56,lne57          
 
       LET g_lne03 = g_lne.lne03
       CALL i300_xxx_lne04(g_lne.lne04)                                                             
       CALL i300_xxx_show()      
 
  END IF 
END FUNCTION
 
###FUN-A80073 START ###
FUNCTION i300_xxx_lne61(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne61
  DEFINE l_azp02        LIKE azp_file.azp02
 
   IF NOT cl_null(p_cmd) THEN 
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = p_cmd
     DISPLAY l_azp02  TO FORMONLY.lne61_n       
   ELSE
      DISPLAY '' TO FORMONLY.lne61_n
   END IF  
END FUNCTION

#FUNCTION i300_xxx_lne62(p_cmd)
#  DEFINE p_cmd          LIKE lne_file.lne62
#  DEFINE l_oca02        LIKE oca_file.oca02
# 
#   IF NOT cl_null(p_cmd) THEN 
#      SELECT oca02 INTO l_oca02 FROM oca_file
#       WHERE oca01 = p_cmd
#     DISPLAY l_oca02  TO FORMONLY.lne62_n       
#   ELSE
#      DISPLAY '' TO FORMONLY.lne62_n
#   END IF  
#END FUNCTION

FUNCTION i300_xxx_lne64(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne64
  DEFINE l_count        LIKE type_file.num5
  DEFINE l_occ02        LIKE occ_file.occ02
   IF NOT cl_null(p_cmd) THEN
      SELECT COUNT(*) INTO l_count FROM occ_file WHERE occ06 IN ('1','3') AND occacti = 'Y' 
                                                 AND occ01 = p_cmd
      IF l_count > 0 THEN
         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = p_cmd
         DISPLAY l_occ02 TO FORMONLY.lne64_n
      ELSE
      	 CALL cl_err(g_lne.lne64,'alm-h06',1)
   	     DISPLAY '' TO FORMONLY.lne64
      END IF 	          
   ELSE
      DISPLAY '' TO FORMONLY.lne64_n
   END IF  
END FUNCTION
###FUN-A80073 END ### 
 
FUNCTION i300_xxx_lne04(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne04
  DEFINE l_rtz13        LIKE rtz_file.rtz13   #FUN-A80148 add
 
   IF NOT cl_null(p_cmd) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01  = p_cmd
     DISPLAY l_rtz13  TO FORMONLY.rtz13       
   ELSE
      DISPLAY '' TO FORMONLY.rtz13
   END IF  
END FUNCTION 
 
FUNCTION i300_xxx_lne05(p_cmd)
DEFINE p_cmd          LIKE lne_file.lne05
DEFINE l_count        LIKE type_file.num5
 
  SELECT COUNT(lne05) INTO l_count FROM lne_file
    WHERE lne05 = p_cmd
  IF l_count > 0 THEN 
     CALL cl_err('','alm-138',1)
     LET g_success = 'N'
  ELSE
  	 LET g_success = 'Y'
  END IF       
END FUNCTION 
 
FUNCTION i300_xxx_lne08(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne08
  DEFINE l_count        LIKE type_file.num5

#FUN-A70063--begin-- 
  DEFINE l_tqaacti      LIKE tqa_file.tqaacti
  DEFINE l_tqa03        LIKE tqa_file.tqa03
#FUN-A70063--end-- 

#FUN-A70063--begin-- 
# SELECT COUNT(*) INTO l_count FROM azf_file
#  WHERE azf01 = p_cmd
#    AND azf02 = '3'
#  IF l_count < 1 THEN 
#    CALL cl_err('','alm-121',0)
#    LET g_success = 'N'
# ELSE
#    SELECT azfacti INTO l_azfacti FROM azf_file
#     WHERE azf01 = p_cmd
#       AND azf02 = '3'
#    IF l_azfacti != 'Y' THEN
#       CALL cl_err('','alm-139',0)
#       LET g_success = 'N'
#    ELSE
#       LET g_success = 'Y'
#    END IF
# END IF  	       
#FUN-A70063--end-- 

#FUN-A70063--begin--
   SELECT COUNT(*) INTO l_count FROM tqa_file 
    WHERE tqa03 = '2' 
      AND tqa01 = p_cmd
   IF l_count < 1 THEN
      CALL cl_err('','alm1002',0)
      LET g_success = 'N'
   ELSE
      SELECT COUNT(*) INTO l_count FROM tqa_file 
       WHERE tqa03 = '2'
        AND  tqa01 = p_cmd
        AND  ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
       IF l_count < 1 THEN 
          CALL cl_err('','alm1004',0)
           LET g_success = 'N'
       ELSE
          SELECT tqaacti INTO l_tqaacti FROM tqa_file
             WHERE tqa03 = '2'
               AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                    OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
               AND tqa01 = p_cmd
          IF l_tqaacti != 'Y' THEN
             CALL cl_err('','alm-139',0)
             LET g_success = 'N'
          ELSE
             LET g_success = 'Y'
          END IF
       END IF
   END IF
#FUN-A70063--end-- 

#No.TQC-A10178 -BEGIN-----
#No.FUN-9B0136 BEGIN -----
# SELECT COUNT(*) INTO l_count FROM lne_file
#  WHERE lne08 = p_cmd
# IF l_count > 0 THEN
#    CALL cl_err('','alm-705',0)
#    LET g_success = 'N'
# END IF
#No.FUN-9B0136 END -------
#No.TQC-A10178 -END-------
END FUNCTION 
 
FUNCTION i300_xxx_lne081(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne08
# DEFINE l_azf03        LIKE azf_file.azf03   #FUN-A70063
  DEFINE l_tqa02        LIKE tqa_file.tqa02   #FUN-A70063 add  

#FUN-A70063--begin-- 
# SELECT azf03 INTO l_azf03 FROM azf_file
#  WHERE azf01 = p_cmd
#    AND azf02 = '3'
#  DISPLAY l_azf03 TO FORMONLY.azf03 	           
#FUN-A70063--end-- 


#FUN-A70063--begin-- 
   SELECT tqa02 INTO l_tqa02 FROM tqa_file 
    WHERE tqa03 = '2' 
      AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
      AND tqa01 = p_cmd
   DISPLAY l_tqa02 TO FORMONLY.tqa02
#FUN-A70063--end-- 
#FUN-B90056 Add Begin ---
   LET l_tqa02 = NULL
   SELECT tqa09 INTO g_lne.lne68 FROM tqa_file WHERE tqa01 = p_cmd AND tqa03 = '2'
   SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lne.lne68 AND tqa03 = '32'
   DISPLAY BY NAME g_lne.lne68
   DISPLAY l_tqa02 TO FORMONLY.lne68_desc
#FUN-B90056 Add End -----
END FUNCTION 
 
FUNCTION i300_xxx_lne09(p_cmd)
DEFINE p_cmd          LIKE lne_file.lne09
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
    #SELECT geoacti INTO l_geoacti FROM geo_file   #TQC-C40051 mark 
    # WHERE geo01 = p_cmd                          #TQC-C40051 mark
     SELECT oqwacti INTO l_geoacti FROM oqw_file   #TQC-C40051 add 
      WHERE oqw01 = p_cmd                          #TQC-C40051 add 
      IF l_geoacti != 'Y' THEN 
         CALL cl_err('','alm-100',0)
         LET g_success = 'N'
      ELSE
      	 LET g_success = 'Y'
      END IF  	    
  END IF  	     	            
END FUNCTION 
 
FUNCTION i300_xxx_lne091(p_cmd)
  DEFINE p_cmd          LIKE lne_file.lne09
  DEFINE l_geo02        LIKE geo_file.geo02
 
 #SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
 # WHERE geo01 = p_cmd                     #TQC-C40051 mark
  SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
   WHERE oqw01 = p_cmd                     #TQC-C40051 add
  DISPLAY l_geo02 TO FORMONLY.geo02     
END FUNCTION 
 
FUNCTION i300_check_lne01(p_cmd)
 DEFINE p_cmd    LIKE lne_file.lne01 
 DEFINE l_count  LIKE type_file.num5
   SELECT COUNT(lne01) INTO l_count FROM lne_file
    WHERE lne01 = p_cmd
   IF l_count > 0 THEN
      CALL cl_err('','alm-056',0)
      LET g_success = 'N'
      RETURN             #FUN-A80073 ---ADD---
   ELSE
      LET g_success = 'Y'
   END IF 
   
   SELECT COUNT(*) INTO l_count FROM occ_file
    WHERE occ01  = p_cmd
   IF l_count > 0 THEN
      CALL cl_err('','alm-547',0)
      LET g_success = 'N'
      RETURN              #FUN-A80073 ---ADD---
   ELSE
      LET g_success = 'Y'
   END IF
   
   ###FUN-A80073 START ###
   SELECT COUNT(*) INTO l_count FROM occa_file
    WHERE occa01  = p_cmd
   IF l_count > 0 THEN
      CALL cl_err('','alm-549',0)
      LET g_success = 'N'   
      RETURN    
   ELSE
      LET g_success = 'Y'
      RETURN         
   END IF
   ###FUN-A80073 END ###  
END FUNCTION 
 
FUNCTION i300_check_lne03(p_cmd)
 DEFINE p_cmd      LIKE lne_file.lne03 
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
 	    WHERE lne03       = p_cmd
 	   IF l_count  > 0 THEN
 	      CALL cl_err('','alm-187',0)
 	      LET g_success = 'N'
 	   ELSE  
         SELECT lnb33 INTO l_lnb33 FROM lnb_file
           WHERE lnb01      = p_cmd
         IF l_lnb33 != 'Y' THEN 
            CALL cl_err('','alm-120',0) 
            LET g_success = 'N'
         ELSE
    	     LET g_success = 'Y' 
        END IF  	 
     END IF    
 END IF 
END FUNCTION 
 
FUNCTION i300_check_lne04(p_cmd)
 DEFINE p_cmd      LIKE lne_file.lne04 
 DEFINE l_count    LIKE type_file.num5
 DEFINE l_rtz28    LIKE rtz_file.rtz28   #FUN-A80148 add
 
 SELECT COUNT(*) INTO l_count FROM rtz_file
  WHERE rtz01 = p_cmd
  
 IF l_count < 1 THEN
    CALL cl_err('','alm-077',0)
    LET g_success = 'N'
 ELSE
    SELECT rtz28 INTO l_rtz28 FROM rtz_file
     WHERE rtz01  = p_cmd
     IF l_rtz28 != 'Y' THEN 
       CALL cl_err('','alm-002',0)
       LET g_success = 'N'
     ELSE
     	 LET g_success = 'Y'
     END IF   
 END IF 
END FUNCTION 

#FUN-B90056 Add Begin ---
FUNCTION i300_lne67(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_tqa02   LIKE tqa_file.tqa02
DEFINE l_tqaacti LIKE tqa_file.tqaacti

   LET g_errno = ''
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lne.lne67 AND tqa03 = '33'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-738'
                               LET l_tqa02 = NULL
      WHEN l_tqaacti = 'N'     LET g_errno = 'alm-739'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_tqa02 TO FORMONLY.lne67_desc
   END IF
END FUNCTION
#FUN-B90056 Add End -----
 
FUNCTION i300_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("lne01",FALSE)        
  END IF           

END FUNCTION        
 
FUNCTION i300_confirm()
 DEFINE l_lne37         LIKE lne_file.lne37 
 DEFINE l_lne38         LIKE lne_file.lne38   
 DEFINE l_count         LIKE type_file.num5          
 DEFINE g_lnf        DYNAMIC ARRAY OF RECORD
         lnf02          LIKE lnf_file.lnf02,
         lnf03          LIKE lnf_file.lnf03,
         lnf04          LIKE lnf_file.lnf04
                     END RECORD
 DEFINE g_lng        DYNAMIC ARRAY OF RECORD
         lng02          LIKE lng_file.lng02,
         lng03          LIKE lng_file.lng03,
         lng04          LIKE lng_file.lng04,
         lng05          LIKE lng_file.lng05,
         lng06          LIKE lng_file.lng06,
         lng07          LIKE lng_file.lng07
                     END RECORD
 DEFINE g_lnh        DYNAMIC ARRAY OF RECORD
         lnh02          LIKE lnh_file.lnh02,
         lnhstore       LIKE lnh_file.lnhstore,
         lnhlegal       LIKE lnh_file.lnhlegal,
         lnh04          LIKE lnh_file.lnh04,
         lnh05          LIKE lnh_file.lnh05,
         lnh06          LIKE lnh_file.lnh06,
         lnh07          LIKE lnh_file.lnh07          
                     END RECORD 
 DEFINE  l_cnt          LIKE type_file.num5 
 DEFINE  l_sql          STRING
   
   IF cl_null(g_lne.lne01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ---------------- add ----------------- begin
   IF g_lne.lne36 = 'Y' THEN
      CALL cl_err(g_lne.lne01,'alm-005',1)
      RETURN
   END IF

   IF g_lne.lne36 = 'X' THEN
      CALL cl_err(g_lne.lne01,'alm-134',1)
      RETURN
   END IF
   IF g_lne.lne59 <> 'Y' THEN
      CALL cl_err('','alm1252',0) #請先確認證件
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN   
      RETURN
   END IF
   SELECT * INTO g_lne.* FROM lne_file 
    WHERE lne01 = g_lne.lne01
   IF cl_null(g_lne.lne01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ---------------- add ----------------- end
   IF g_lne.lne36 = 'Y' THEN
      CALL cl_err(g_lne.lne01,'alm-005',1)
      RETURN
   END IF
   
   IF g_lne.lne36 = 'X' THEN
      CALL cl_err(g_lne.lne01,'alm-134',1)
      RETURN
   END IF
#  SELECT * INTO g_lne.* FROM lne_file  #CHI-C30107 mark
#   WHERE lne01 = g_lne.lne01           #CHI-C30107 mark

  #FUN-B90056 Add Begin ---
   IF g_lne.lne59 <> 'Y' THEN
      CALL cl_err('','alm1252',0) #請先確認證件
      RETURN
   END IF
  #FUN-B90056 Add End -----
   
   LET l_lne37 = g_lne.lne37
   LET l_lne38 = g_lne.lne38 
   
   SELECT count(*) INTO l_count FROM occ_file
    WHERE occ01  = g_lne.lne01
#     AND occ246 = g_lne.plant_code
   IF l_count > 0 THEN
      #CALL cl_err('',-239,0)               #FUN-A80073 mark
      CALL cl_err(g_lne.lne01,'alm-h05',1)  #FUN-A80073 add
      RETURN
   END IF
   
   LET g_success = 'Y'

   BEGIN WORK 
   OPEN i300_cl USING g_lne.lne01
   IF STATUS THEN 
      CALL cl_err("open i300_cl:",STATUS,1)
      CLOSE i300_cl
      ROLLBACK WORK 
      RETURN 
   END IF 
    
   FETCH i300_cl INTO g_lne.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN 
   END IF    
  
   #IF NOT cl_confirm("alm-006") THEN   #CHI-C30107 mark
   #   RETURN                           #CHI-C30107 mark
   #ELSE                                #CHI-C30107 mark
      LET g_lne.lne36 = 'Y'
      LET g_lne.lne37 = g_user
      LET g_lne.lne38 = g_today 
        
      UPDATE lne_file
         SET lne36 = g_lne.lne36,
             lne37 = g_lne.lne37,
             lne38 = g_lne.lne38 
       WHERE lne01 = g_lne.lne01
       
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lne:',SQLCA.SQLCODE,0)
      #  LET g_lne.lne36 = "N"
      #  LET g_lne.lne37 = l_lne37
      #  LET g_lne.lne38 = l_lne38     
      #
      #  DISPLAY BY NAME g_lne.lne36,g_lne.lne37,g_lne.lne38
      #  RETURN
         LET g_success = 'N'
      ELSE       
      ##############################################
         INSERT INTO occ_file(occ01,occ02,occ06,occ07,occ08,occ11, #MOD-D30126 add occ11
                              occ09,occ18,occ231,occ246,occ67,
                              occ41,occ42,occ45,occuser,occgrup,
                              occmodu,occdate,occacti,occ1004,occ37,
                              occ56,occ57,occ31,occ65,occ40,occoriu,occorig,
                              occ03,occ55,occ62,occ71,occ72,occ73,occ930,occ1022,occ1027,occpos)#FUN-A80073 ---ADD---
        #VALUES(g_lne.lne01,g_lne.lne05,'1',g_lne.lne01,,'1',   #FUN-A80073 ---MARK--- 
        #       g_lne.lne01,g_lne.lne06,g_lne.lne49,g_lne.lne04,g_lne.lne56,  #FUN-A80073 ---MARK---                   
         VALUES(g_lne.lne01,g_lne.lne05,g_lne.lne63,g_lne.lne64,'1',g_lne.lne55,   #FUN-A80073 ---ADD--- #MOD-D30126 add lne55
                g_lne.lne65,g_lne.lne06,g_lne.lne49,g_lne.lne04,g_lne.lne56,  #FUN-A80073 ---ADD---
                g_lne.lne40,g_lne.lne57,g_lne.lne42,g_lne.lneuser,g_lne.lnegrup,
                g_lne.lnemodu,g_lne.lnedate,'Y','1','N',
                'N','N','N','N','Y', g_user, g_grup,     #No.FUN-980030 10/01/04  insert columns oriu, orig
                g_lne.lne62,g_lne.lne66,NULL,'2','0','N',g_lne.lne61,g_lne.lne01,'N','1')#FUN-A80073 ---ADD--- #FUN-B40071
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('ins_occ',SQLCA.SQLCODE,0)
            LET g_success = 'N'
         ELSE 
        #No.TQC-A30075 -END-------
            INSERT INTO lue_file(lue01,lue02,lue03,lue04,lue05,lue06,lue07,lue08,lue09,lue10,
                                 lue12,lue13,lue14,lue15,lue16,lue17,lue18,lue19,lue20,lue21,lue22,lue23,
                                 lue24,lue25,lue26,lue27,lue28,lue29,lue30,lue31,lue32,lue33,lue34,lue35,
                                 lue36,lue37,lue38,lue39,lue40,lue41,lue42,lue43,lue44,lue45,lue46,lue47,
                                 lue48,lue49,lue50,lue51,lue52,lue53,lue54,lue57,lue58,lueuser,luecrat,luemodu,
                                 luegrup,luedate,lue59,lue56,lue55,lueoriu,lueorig
                                 ,lue61,lue62,lue63,lue64,lue65,lue66,lue60)#FUN-A80073 ---ADD---  #FUN-B90056 ADD lue60
            VALUES(g_lne.lne01,g_lne.lne02,g_lne.lne03,
                   g_lne.lne04,g_lne.lne05,g_lne.lne06,g_lne.lne07,g_lne.lne08,g_lne.lne09,g_lne.lne10,
                   g_lne.lne12,g_lne.lne13,g_lne.lne14,g_lne.lne15,g_lne.lne16,g_lne.lne17,g_lne.lne18,
                   g_lne.lne19,g_lne.lne20,g_lne.lne21,g_lne.lne22,g_lne.lne23,g_lne.lne24,g_lne.lne25,
                   g_lne.lne26,g_lne.lne27,g_lne.lne28,g_lne.lne29,g_lne.lne30,g_lne.lne31,g_lne.lne32,
                   g_lne.lne33,g_lne.lne34,g_lne.lne35,g_lne.lne36,g_lne.lne37,g_lne.lne38,g_lne.lne39,
                   g_lne.lne40,g_lne.lne41,g_lne.lne42,g_lne.lne43,g_lne.lne44,g_lne.lne45,g_lne.lne46,
                   g_lne.lne47,g_lne.lne48,g_lne.lne49,g_lne.lne50,g_lne.lne51,g_lne.lne52,g_lne.lne53,
                   g_lne.lne54,g_lne.lne56,g_lne.lne57,g_lne.lneuser,g_lne.lnecrat,g_lne.lnemodu,
                   g_lne.lnegrup,g_lne.lnedate,g_lne.lne58,g_lne.lne55,'N', g_user, g_grup 	      #No.FUN-980030 10/01/04  insert columns oriu, orig
                   ,g_lne.lne61,g_lne.lne62,g_lne.lne63,g_lne.lne64,g_lne.lne65,g_lne.lne66,g_lne.lne59)#FUN-A80073 ---ADD---  #FUN-B90056 ADD g_lne.lne59
           #No.TQC-A30075 -BEGIN-----
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('ins_lue',SQLCA.SQLCODE,0)
               LET g_success = 'N'
            END IF
           #No.TQC-A30075 -END-------
         END IF
         #####################       
         LET l_sql = "SELECT lnf02,lnf03,lnf04 FROM lnf_file",
                     " WHERE lnf01 ='",g_lne.lne01,"'"
         PREPARE lnf_pb FROM l_sql
         DECLARE lnf_cs CURSOR FOR lnf_pb
         LET l_cnt = 1 
         FOREACH lnf_cs INTO g_lnf[l_cnt].*                                             
            IF STATUS THEN                                                             
               CALL cl_err('foreach:',STATUS,1)                                                
               EXIT FOREACH                                                       
            END IF                                                               
            IF g_lnf[l_cnt].lnf02 IS NOT NULL AND g_lnf[l_cnt].lnf03 IS NOT NULL THEN
               INSERT INTO luf_file(luf00,luf01,luf02,luf03,luf04)
               VALUES(g_lne.lne04,g_lne.lne01,g_lnf[l_cnt].lnf02,
                      g_lnf[l_cnt].lnf03,g_lnf[l_cnt].lnf04)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err('ins_lue',SQLCA.SQLCODE,0)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
              
            LET l_cnt = l_cnt + 1                                                        
            IF l_cnt > g_max_rec THEN                                                     
               CALL cl_err( '', 9035, 0 )                                                          
               EXIT FOREACH                                                                        
            END IF                                                                               
         END FOREACH       
         ##########################################
         LET l_sql = "SELECT lng02,lng03,lng04,lng05,lng06,lng07 FROM lng_file",
                     " WHERE lng01 ='",g_lne.lne01,"'"
         PREPARE lng_pb FROM l_sql
         DECLARE lng_cs CURSOR FOR lng_pb
         LET l_cnt = 1 
         FOREACH lng_cs INTO g_lng[l_cnt].*                                             
            IF STATUS THEN                                                             
               CALL cl_err('foreach:',STATUS,1)                                                
               EXIT FOREACH                                                       
            END IF                                                               
            IF g_lng[l_cnt].lng02 IS NOT NULL AND g_lng[l_cnt].lng03 IS NOT NULL AND
               g_lng[l_cnt].lng04 IS NOT NULL THEN
               INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
               VALUES(g_lne.lne04,g_lne.lne01,g_lng[l_cnt].lng02,g_lng[l_cnt].lng03,
                      g_lng[l_cnt].lng04,g_lng[l_cnt].lng05,g_lng[l_cnt].lng06,
                      g_lng[l_cnt].lng07)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err('ins_lue',SQLCA.SQLCODE,0)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
              
            LET l_cnt = l_cnt + 1                                                        
            IF l_cnt > g_max_rec THEN                                                     
               CALL cl_err( '', 9035, 0 )                                                          
               EXIT FOREACH                                                                        
            END IF                                                                               
         END FOREACH       
         ##############################################     
         LET l_sql = "SELECT lnh02,lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07 FROM lnh_file",
                     " WHERE lnh01 ='",g_lne.lne01,"'"
         PREPARE lnh_pb FROM l_sql
         DECLARE lnh_cs CURSOR FOR lnh_pb
         LET l_cnt = 1 
         FOREACH lnh_cs INTO g_lnh[l_cnt].*                                             
            IF STATUS THEN                                                             
               CALL cl_err('foreach:',STATUS,1)                                                
               EXIT FOREACH                                                       
            END IF                                                               
            IF g_lnh[l_cnt].lnh02 IS NOT NULL AND g_lnh[l_cnt].lnhstore IS NOT NULL THEN
               INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luhlegal,luh04,luh05,luh06,luh07)  #FUN-AB0096 luhplant改為luhstore
               VALUES(g_lne.lne04,g_lne.lne01,g_lnh[l_cnt].lnh02,g_lnh[l_cnt].lnhstore,g_lnh[l_cnt].lnhlegal,
                      g_lnh[l_cnt].lnh04,g_lnh[l_cnt].lnh05,g_lnh[l_cnt].lnh06,
                      g_lnh[l_cnt].lnh07)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err('ins_lue',SQLCA.SQLCODE,0)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
              
            LET l_cnt = l_cnt + 1                                                        
            IF l_cnt > g_max_rec THEN                                                     
               CALL cl_err( '', 9035, 0 )                                                          
               EXIT FOREACH                                                                        
            END IF                                                                               
         END FOREACH       
         ################################################
         DISPLAY BY NAME g_lne.lne36,g_lne.lne37,g_lne.lne38     
      END IF
#  END IF     #CHI-C30107 mark
   CLOSE i300_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      LET g_lne.lne36 = "N"
      LET g_lne.lne37 = l_lne37
      LET g_lne.lne38 = l_lne38
   END IF
   CALL i300_show()
END FUNCTION
 
FUNCTION i300_pic()
   CASE g_lne.lne36
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void    = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
END FUNCTION
 
FUNCTION i300_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF cl_null(g_lne.lne01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lne.* FROM lne_file
     WHERE lne01 = g_lne.lne01
 
   #FUN-D20039 ----------sta
   IF p_type = 1 THEN
      IF g_lne.lne36='X' THEN RETURN END IF
   ELSE
      IF g_lne.lne36<>'X' THEN RETURN END IF
   END IF
   #FUN-D20039 ----------end
   IF g_lne.lne36 = 'Y' THEN
      CALL cl_err(g_lne.lne01,'9023',0)
      RETURN
   END IF

     BEGIN WORK
    OPEN i300_cl USING g_lne.lne01
    
    IF STATUS THEN 
       CALL cl_err("open i300_cl:",STATUS,1)
       CLOSE i300_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH i300_cl INTO g_lne.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN 
    END IF      
    
    IF g_lne.lne36 != 'Y' THEN
      IF g_lne.lne36 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lne.lne36 = 'N'
            LET g_lne.lnemodu = g_user
            LET g_lne.lnedate = g_today 
            UPDATE lne_file
               SET lne36 = g_lne.lne36,
                   lnemodu = g_lne.lnemodu,
                   lnedate = g_lne.lnedate
             WHERE lne01 = g_lne.lne01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lne:',SQLCA.SQLCODE,0)
               LET g_lne.lne36 = "X"
               DISPLAY BY NAME g_lne.lne36
               RETURN
            ELSE
            	  DISPLAY BY NAME g_lne.lne36,g_lne.lnemodu,g_lne.lnedate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lne.lne36 = 'X'
            LET g_lne.lnemodu = g_user
            LET g_lne.lnedate = g_today  
            UPDATE lne_file
               SET lne36 = g_lne.lne36,
                   lnemodu = g_lne.lnemodu,
                   lnedate = g_lne.lnedate
             WHERE lne01 = g_lne.lne01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lne:',SQLCA.SQLCODE,0)
               LET g_lne.lne36 = "N"
               DISPLAY BY NAME g_lne.lne36
               RETURN
            ELSE            
               DISPLAY BY NAME g_lne.lne36,g_lne.lnemodu,g_lne.lnedate
            END IF
         END IF
      END IF
   END IF
  CLOSE i300_cl
  COMMIT WORK  
END FUNCTION 

#FUN-B90056 Add Begin ---
FUNCTION i300_cer_confirm()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lne.lne01) THEN CALL cl_err('',-400,1) RETURN END IF
   SELECT * INTO g_lne.* FROM lne_file WHERE lne01 = g_lne.lne01
   IF g_lne.lne59 = 'Y' THEN
      CALL cl_err('','alm-735',0)
      RETURN
   END IF

  #FUN-B90056 Mark Begin ---
  #IF g_lne.lne36 <> 'Y' THEN
  #   CALL cl_err('','alm-736',0)
  #   RETURN
  #END IF
  #FUN-B90056 Mark End -----

   LET g_success = 'Y'

   BEGIN WORK

   OPEN i300_cl USING g_lne.lne01
   IF STATUS THEN
      CALL cl_err("open i300_cl:",STATUS,1)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i300_cl INTO g_lne.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-734') THEN
      RETURN
   ELSE
      UPDATE lne_file SET lne59 = 'Y'
       WHERE lne01 = g_lne.lne01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
         LET g_success = 'N'
      END IF
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT * INTO g_lne.* FROM lne_file WHERE lne01 = g_lne.lne01
   CALL i300_show()
   CLOSE i300_cl
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_upd_image()
DEFINE l_lne01_image   STRING

   OPEN WINDOW i300_w1 WITH FORM "alm/42f/almi300_a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almi300_a")

   LET g_doc.column1 = "lne01"
   LET g_doc.value1 = g_lne.lne01
   CALL cl_get_fld_doc("lne01") 

   MENU ""
      ON ACTION upd_image
          IF g_lne.lne59 = 'Y' THEN
             CALL cl_err('','alm-742',0)
          ELSE
             LET g_doc.column1 = "lne01"
             LET g_doc.value1 = g_lne.lne01
             CALL cl_fld_doc("lne01")
          END IF

      ON ACTION help
          CALL cl_show_help()

      ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU

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
   CLOSE WINDOW i300_w1
END FUNCTION
#FUN-B90056 Add ENd -----

#FUN-B90056 Add Begin ---
FUNCTION i300_b()
DEFINE l_ac1_t         LIKE type_file.num5,
       l_ac2_t         LIKE type_file.num5,
       l_ac3_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
DEFINE l_lne36         LIKE lne_file.lne36
DEFINE l_tqa02         LIKE tqa_file.tqa02
DEFINE l_tqa03         LIKE tqa_file.tqa03
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
DEFINE l_geo02         LIKE geo_file.geo02
DEFINE l_geoacti       LIKE geo_file.geoacti
DEFINE l_rtz28         LIKE rtz_file.rtz28
DEFINE l_rtz13         LIKE rtz_file.rtz13
               
   IF s_shut(0) THEN RETURN END IF

   SELECT lne36 INTO l_lne36 FROM lne_file
     WHERE lne01 = g_lne.lne01
   IF (l_lne36 = 'Y' OR l_lne36 = 'X') THEN
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL
       RETURN
   END IF     
            
   CALL cl_opmsg('b')
   LET g_action_choice = ""
            
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
                  
   LET g_forupd_sql = "SELECT lng03,'',lng04,lng05,lng06,lng07",
                      "  FROM lng_file WHERE  ",
                      "  lng01= '",g_lne.lne01,"' and lng03 = ? and lng04 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl_1 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT lnf03,'',lnf04,''",
                      "  FROM lnf_file WHERE  " ,
                      "   lnf01= '",g_lne.lne01,"' " ,
                      "   and lnf03 = ? " ,
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl_2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07",
                      "  FROM lnh_file WHERE  ",
                      "  lnh01= '",g_lne.lne01,"' and lnhstore = ?  ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl_3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
              
   DIALOG ATTRIBUTE(UNBUFFERED)

      INPUT ARRAY g_lng FROM s_lng.*
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
               CALL i300_set_entry_b1(p_cmd)
               CALL i300_set_no_entry_b1(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lng_t.* = g_lng[l_ac1].*
               OPEN i300_bcl_1 USING g_lng_t.lng03,g_lng_t.lng04
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i300_bcl_1 INTO g_lng[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lng_t.lng03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i300_lng03('d')
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i300_set_entry_b1(p_cmd)
            CALL i300_set_no_entry_b1(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_lng[l_ac1].* TO NULL
            LET g_lng_t.* = g_lng[l_ac1].*
            CALL cl_show_fld_cont()
            NEXT FIELD lng03

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i300_bcl_1
               CANCEL INSERT
            END IF
            INSERT INTO lng_file(lng00,lng01,lng02,lng03,lng04,lng05,lng06,lng07)
            VALUES(g_lne.lne04,g_lne.lne01,'0',g_lng[l_ac1].lng03,g_lng[l_ac1].lng04,
                   g_lng[l_ac1].lng05,g_lng[l_ac1].lng06,g_lng[l_ac1].lng07)
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lng_file",g_lng[l_ac1].lng03,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cn3
               COMMIT WORK
            END IF
                  
         AFTER FIELD lng03           
            IF NOT cl_null(g_lng[l_ac1].lng03) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lng[l_ac1].lng03 <> g_lng_t.lng03) THEN
                  IF NOT cl_null(g_lng[l_ac1].lng04) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM lng_file
                     #WHERE lng01 = g_lne.lne01 #FUN-B90056 Mark
                       #AND lng03 = g_lng[l_ac1].lng03 #FUN-B90056 Mark
                      WHERE lng03 = g_lng[l_ac1].lng03 #FUN-B90056 Add
                        AND lng04 = g_lng[l_ac1].lng04
                     IF l_n > 0 THEN
                        CALL cl_err('','alm-151',0)
                        DISPLAY g_lng_t.lng03 TO lng03
                        NEXT FIELD lng03
                     END IF
                  END IF
                  CALL i300_lng03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lng[l_ac1].lng03 = g_lng_t.lng03
                     NEXT FIELD lng03
                  END IF
               END IF
            END IF   
                     
         AFTER FIELD lng04
            IF NOT cl_null(g_lng[l_ac1].lng04) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lng[l_ac1].lng04 <> g_lng_t.lng04) THEN 
                  IF NOT cl_null(g_lng[l_ac1].lng03) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM lng_file
                     #WHERE lng01 = g_lne.lne01 #FUN-B90056 Mark
                       #AND lng03 = g_lng[l_ac1].lng03 #FUN-B90056 Mark
                      WHERE lng03 = g_lng[l_ac1].lng03 #FUN-B90056 Add
                        AND lng04 = g_lng[l_ac1].lng04
                     IF l_n > 0 THEN 
                        CALL cl_err('','alm-151',0)
                        DISPLAY g_lng_t.lng03 TO lng03
                        NEXT FIELD lng04
                     END IF   
                  END IF
               END IF
            END IF
            
         AFTER FIELD lng06
            IF NOT cl_null(g_lng[l_ac1].lng06) THEN
               IF cl_null(g_lng[l_ac1].lng07) THEN
                  CALL cl_err('','alm-153',0)
                  NEXT FIELD lng07
               ELSE
                  IF g_lng[l_ac1].lng06 > g_lng[l_ac1].lng07 THEN
                     CALL cl_err('','alm-152',0)
                     NEXT FIELD lng06
                  END IF
               END IF
            ELSE
               IF NOT cl_null(g_lng[l_ac1].lng07) THEN
                  CALL cl_err('','alm-154',0)
                  NEXT FIELD lng06
               END IF
            END IF

         AFTER FIELD lng07
             IF NOT cl_null(g_lng[l_ac1].lng07) THEN
                IF cl_null(g_lng[l_ac1].lng06) THEN
                   CALL cl_err('','alm-154',0)
                   NEXT FIELD lng06
                ELSE
                   IF g_lng[l_ac1].lng07 < g_lng[l_ac1].lng06 THEN
                      CALL cl_err('','alm-155',0)
                      NEXT FIELD lng07
                   END IF
                END IF
             ELSE
                IF NOT cl_null(g_lng[l_ac1].lng06) THEN
                   CALL cl_err('','alm-153',0)
                   NEXT FIELD lng07
                END IF
             END IF


         BEFORE DELETE
            IF (g_lng_t.lng03 IS NOT NULL) AND (g_lng_t.lng04 IS NOT NULL) THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL 
               LET g_doc.column1 = "lng03" 
               LET g_doc.value1 = g_lng[l_ac1].lng03
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lng_file WHERE lng03 = g_lng_t.lng03
                                      AND lng04 = g_lng_t.lng04
                                      AND lng01 = g_lne.lne01
                          
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lng_file",g_lng_t.lng03,"",SQLCA.sqlcode,"","",1)
                  EXIT DIALOG
               END IF 
               LET g_rec_b1=g_rec_b1-1
               DISPLAY g_rec_b1 TO FORMONLY.cn3
               COMMIT WORK
            END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lng[l_ac1].* = g_lng_t.*
               CLOSE i300_bcl_1
               ROLLBACK WORK 
               EXIT DIALOG
            END IF   
                
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lng[l_ac1].lng03,-263,0)
               LET g_lng[l_ac1].* = g_lng_t.*
            ELSE     
               UPDATE lng_file SET lng00 = g_lne.lne04,
                                   lng03 = g_lng[l_ac1].lng03,
                                   lng04 = g_lng[l_ac1].lng04,
                                   lng05 = g_lng[l_ac1].lng05,
                                   lng06 = g_lng[l_ac1].lng06,
                                   lng07 = g_lng[l_ac1].lng07
                WHERE lng03 = g_lng_t.lng03
                  AND lng04 = g_lng_t.lng04
                  AND lng01 = g_lne.lne01
                  
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lng_file",g_lng_t.lng03,"",SQLCA.sqlcode,"","",1)
                  LET g_lng[l_ac1].* = g_lng_t.*                            
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac1 = ARR_CURR()
            LET l_ac1_t = l_ac1
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_lng[l_ac1].* = g_lng_t.*
               ELSE
                  CALL g_lng.deleteElement(l_ac1)
               END IF
               CLOSE i300_bcl_1
               ROLLBACK WORK 
               EXIT DIALOG
            END IF
            CLOSE i300_bcl_1
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(lng03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_tqa"
                    LET g_qryparam.arg1 = '24'
                    LET g_qryparam.default1 = g_lng[l_ac1].lng03
                    CALL cl_create_qry() RETURNING g_lng[l_ac1].lng03
                    DISPLAY g_lng[l_ac1].lng03 TO lng03
                    NEXT FIELD lng03

            END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_lng.deleteElement(l_ac1)
            END IF
            EXIT DIALOG

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(lng03) AND l_ac1 > 1 THEN
               LET g_lng[l_ac1].* = g_lng[l_ac1-1].*
               NEXT FIELD lng03
            END IF

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      END INPUT

      INPUT ARRAY g_lnf FROM s_lnf.*
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
               CALL i300_set_entry_b2(p_cmd)
               CALL i300_set_no_entry_b2(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lnf_t.* = g_lnf[l_ac2].*
               OPEN i300_bcl_2 USING g_lnf_t.lnf03
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i300_bcl_2 INTO g_lnf[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnf_t.lnf03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT tqa02 INTO l_tqa02 FROM tqa_file
                      WHERE tqa01 = g_lnf[l_ac2].lnf03
                        AND tqa03 = '2'
                        AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                         OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                        AND tqaacti = 'Y'
                     LET g_lnf[l_ac2].tqa02_2 = l_tqa02
                    #SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
                    # WHERE geo01 = g_lnf[l_ac2].lnf04        #TQC-C40051 mark 
                     SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
                      WHERE oqw01 = g_lnf[l_ac2].lnf04        #TQC-C40051 add 
                       AND oqwacti  = 'Y'
                     LET g_lnf[l_ac2].geo02_2 = l_geo02
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF 
               
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'                    
            LET g_before_input_done = FALSE 
            CALL i300_set_entry_b2(p_cmd)          
            CALL i300_set_no_entry_b2(p_cmd)
            LET g_before_input_done = TRUE                
            INITIALIZE g_lnf[l_ac2].* TO NULL
            LET g_lnf_t.* = g_lnf[l_ac2].*
            CALL cl_show_fld_cont()    
            NEXT FIELD lnf03
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i300_bcl_2
               CANCEL INSERT
            END IF
            INSERT INTO lnf_file(lnf00,lnf01,lnf02,lnf03,lnf04)
            VALUES(g_lne.lne04,g_lne.lne01,'0',g_lnf[l_ac2].lnf03,g_lnf[l_ac2].lnf04)
              
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnf_file",g_lnf[l_ac2].lnf03,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn4
               COMMIT WORK
            END IF

         AFTER FIELD lnf03
            IF NOT cl_null(g_lnf[l_ac2].lnf03) THEN
               IF g_lnf[l_ac2].lnf03 != g_lnf_t.lnf03 OR
                  g_lnf_t.lnf03 IS NULL THEN
                  LET l_n = 0
                  SELECT count(*) INTO l_n FROM tqa_file
                   WHERE tqa01 = g_lnf[l_ac2].lnf03
                    AND tqa03 = '2'
                  IF l_n < 1 THEN
                     CALL cl_err('','alm1002',0)
                     LET g_lnf[l_ac2].lnf03 = g_lnf_t.lnf03
                     NEXT FIELD lnf03
                  ELSE
                     LET l_n = 0
                     SELECT count(*) INTO l_n FROM tqa_file
                      WHERE tqa01 = g_lnf[l_ac2].lnf03
                        AND tqa03 = '2'
                        AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                         OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                     IF l_n < 1 THEN
                        CALL cl_err('','alm1004',0)    #FUN-A70063 alm-123->alm1004
                        LET g_lnf[l_ac2].lnf03 = g_lnf_t.lnf03
                        NEXT FIELD lnf03
                     ELSE
                        SELECT tqaacti INTO l_tqaacti FROM tqa_file
                         WHERE tqa01 = g_lnf[l_ac2].lnf03
                           AND tqa03 = '2'
                           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                            OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                        IF l_tqaacti != 'Y' THEN
                           CALL cl_err('','alm-139',0)
                           LET g_lnf[l_ac2].lnf03 = g_lnf_t.lnf03
                           NEXT FIELD lnf03   
                        ELSE
                           LET l_n = 0
                           SELECT COUNT(*) INTO l_n FROM lnf_file
                            WHERE lnf01   = g_lne.lne01       
                              AND lnf03   = g_lnf[l_ac2].lnf03
                           IF l_n > 0 THEN 
                              CALL cl_err('','alm-167',0)
                              LET g_lnf[l_ac2].lnf03 = g_lnf_t.lnf03
                              DISPLAY BY NAME g_lnf[l_ac2].lnf03
                              NEXT FIELD lnf03
                           ELSE
                              SELECT tqa02 INTO l_tqa02 FROM tqa_file
                               WHERE tqa01 = g_lnf[l_ac2].lnf03
                                 AND tqa03 = '2'
                                 AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                  OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                              LET g_lnf[l_ac2].tqa02_2 = l_tqa02
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF

         AFTER FIELD lnf04
            IF NOT cl_null(g_lnf[l_ac2].lnf04) THEN
               IF g_lnf[l_ac2].lnf04 != g_lnf_t.lnf04 OR
                  g_lnf_t.lnf04 IS NULL THEN
                  LET l_n = 0
                 #SELECT count(*) INTO l_n FROM geo_file  #TQC-C40051 mark
                 # WHERE geo01 = g_lnf[l_ac2].lnf04       #TQC-C40051 mark
                  SELECT count(*) INTO l_n FROM oqw_file  #TQC-C40051 add 
                   WHERE oqw01 = g_lnf[l_ac2].lnf04       #TQC-C40051 add 
                  IF l_n < 1 THEN
                     CALL cl_err('','alm-124',0)
                     LET g_lnf[l_ac2].lnf04 = g_lnf_t.lnf04
                     NEXT FIELD lnf04
                  ELSE
                    #SELECT geoacti INTO l_geoacti FROM geo_file   #TQC-C40051 mark
                    # WHERE geo01 = g_lnf[l_ac2].lnf04             #TQC-C40051 mark
                     SELECT oqwacti INTO l_geoacti FROM oqw_file   #TQC-C40051 add 
                      WHERE oqw01 = g_lnf[l_ac2].lnf04             #TQC-C40051 add 
                     IF l_geoacti != 'Y' THEN
                        CALL cl_err('','alm-100',0)
                        LET g_lnf[l_ac2].lnf04 = g_lnf_t.lnf04
                        NEXT FIELD lnf04
                     ELSE
                       #SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
                       # WHERE geo01 = g_lnf[l_ac2].lnf04        #TQC-C40051 mark
                        SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
                         WHERE oqw01 = g_lnf[l_ac2].lnf04        #TQC-C40051 add 
                        LET g_lnf[l_ac2].geo02_2 = l_geo02
                     END IF
                  END IF
               END IF
            END IF

         BEFORE DELETE
            IF g_lnf_t.lnf03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lnf03" 
               LET g_doc.value1 = g_lnf[l_ac2].lnf03
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN  
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF 
               DELETE FROM lnf_file WHERE lnf01 = g_lne.lne01
                                      AND lnf03 = g_lnf_t.lnf03

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lnf_file",g_lnf_t.lnf03,"",SQLCA.sqlcode,"","",1)
                  EXIT DIALOG
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn4
               COMMIT WORK
            END IF
                     
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lnf[l_ac2].* = g_lnf_t.*
               CLOSE i300_bcl_2
               ROLLBACK WORK
               EXIT DIALOG  
            END IF        
                       
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lnf[l_ac2].lnf03,-263,0)
               LET g_lnf[l_ac2].* = g_lnf_t.*
            ELSE             
               UPDATE lnf_file SET lnf04=g_lnf[l_ac2].lnf04
                WHERE lnf03 = g_lnf_t.lnf03
                  AND lnf01 = g_lne.lne01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lnf_file",g_lnf_t.lnf03,"",SQLCA.sqlcode,"","",1)
                  LET g_lnf[l_ac2].* = g_lnf_t.*
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
                  LET g_lnf[l_ac2].* = g_lnf_t.*
               ELSE
                  CALL g_lnf.deleteElement(l_ac2)
               END IF
               CLOSE i300_bcl_2
               ROLLBACK WORK 
               EXIT DIALOG
            END IF

            CLOSE i300_bcl_2   
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(lnf03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_tqap3"
                    LET g_qryparam.arg1 = g_lne.lne01
                    LET g_qryparam.default1 = g_lnf[l_ac2].lnf03
                    CALL cl_create_qry() RETURNING g_lnf[l_ac2].lnf03
                    DISPLAY g_lnf[l_ac2].lnf03 TO lnf03
                    NEXT FIELD lnf03

               WHEN INFIELD(lnf04)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_geo"   #TQC-C40051 mark
                    LET g_qryparam.form ="q_oqw"   #TQC-C40051 add
                    LET g_qryparam.default1 = g_lnf[l_ac2].lnf04
                    CALL cl_create_qry() RETURNING g_lnf[l_ac2].lnf04
                    DISPLAY g_lnf[l_ac2].lnf04 TO lnf04
                    NEXT FIELD lnf04
            END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_lnf.deleteElement(l_ac2)
            END IF
            EXIT DIALOG

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(lnf03) AND l_ac2 > 1 THEN
               LET g_lnf[l_ac2].* = g_lnf[l_ac2-1].*
               NEXT FIELD lnf03
            END IF

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      END INPUT

      INPUT ARRAY g_lnh FROM s_lnh.*
         ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b3 != 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            LET g_lnh[l_ac3].lnh06 = 'N'

            IF g_rec_b3 >= l_ac3 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL i300_set_entry_b3(p_cmd)
               CALL i300_set_no_entry_b3(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lnh_t.* = g_lnh[l_ac3].*
               OPEN i300_bcl_3 USING g_lnh_t.lnhstore
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i300_bcl_3 INTO g_lnh[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnh_t.lnhstore,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT rtz13 INTO l_rtz13 FROM rtz_file
                   WHERE rtz01 = g_lnh[l_ac3].lnhstore
                  LET g_lnh[l_ac3].rtz13_2 = l_rtz13
                  SELECT azt02 INTO g_lnh[l_ac3].azt02 FROM azt_file
                   WHERE azt01 = g_lnh[l_ac3].lnhlegal
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'       
            LET g_before_input_done = FALSE
            CALL i300_set_entry_b3(p_cmd)
            CALL i300_set_no_entry_b3(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_lnh[l_ac3].* TO NULL
            LET g_lnh_t.* = g_lnh[l_ac3].*
            LET g_lnh[l_ac3].lnh04 = '0'
            LET g_lnh[l_ac3].lnh05 = '1'
            LET g_lnh[l_ac3].lnh06 = 'Y'
            LET g_lnh[l_ac3].lnh07 = '1'
            DISPLAY BY NAME g_lnh[l_ac3].lnh06
           #LET g_lnh[l_ac3].lnhstore = g_plant
           #SELECT rtz13 INTO g_lnh[l_ac3].rtz13_2 FROM rtz_file
           # WHERE rtz01 = g_lnh[l_ac3].lnhstore
           #SELECT azw02 INTO g_lnh[l_ac3].lnhlegal FROM azw_file
           # WHERE azw01 = g_lnh[l_ac3].lnhstore
           #SELECT azt02 INTO g_lnh[l_ac3].azt02 FROM azt_file
           # WHERE azt01 = g_lnh[l_ac3].lnhlegal  
            CALL cl_show_fld_cont()
            NEXT FIELD lnhstore
                  
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i300_bcl_3
               CANCEL INSERT   
            END IF   
            INSERT INTO lnh_file(lnh00,lnh01,lnh02,lnhstore,lnh04,lnh05,lnh06,lnh07,lnhlegal)
            VALUES(g_plant,g_lne.lne01,'0',g_lnh[l_ac3].lnhstore,g_lnh[l_ac3].lnh04,
                   g_lnh[l_ac3].lnh05,g_lnh[l_ac3].lnh06,g_lnh[l_ac3].lnh07,g_lnh[l_ac3].lnhlegal)
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnh_file",g_lnh[l_ac3].lnhstore,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b3 = g_rec_b3 + 1
               DISPLAY g_rec_b3 TO FORMONLY.cn5
               COMMIT WORK
            END IF

         AFTER FIELD lnhstore
            IF NOT cl_null(g_lnh[l_ac3].lnhstore) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lnh[l_ac3].lnhstore <> g_lnh_t.lnhstore) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n 
                    FROM lnh_file 
                   WHERE lnhstore = g_lnh[l_ac3].lnhstore AND lnh01 = g_lne.lne01
                  IF l_n > 0 THEN 
                     CALL cl_err('','alm-172',0)
                     NEXT FIELD lnhstore
                  END IF
                  CALL i300_lnhstore()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lnhstore
                  END IF
               END IF       
            END IF
           
         AFTER FIELD lnh04
            IF NOT cl_null(g_lnh[l_ac3].lnh04) THEN
               IF g_lnh[l_ac3].lnh06 = 'N' THEN
                 LET g_lnh[l_ac3].lnh07 = g_lnh[l_ac3].lnh04
               END IF
            END IF 
                     
         AFTER FIELD lnh05
            IF NOT cl_null(g_lnh[l_ac3].lnh05) THEN 
               IF g_lnh[l_ac3].lnh06 = 'Y' THEN
                  LET  g_lnh[l_ac3].lnh07 = g_lnh[l_ac3].lnh05
               END IF
            END IF    

         ON CHANGE lnh05
            IF NOT cl_null(g_lnh[l_ac3].lnh05) THEN
               LET  g_lnh[l_ac3].lnh07 = g_lnh[l_ac3].lnh05
            END IF
                        
         BEFORE FIELD lnh06 
            IF g_rec_b3 = 0 THEN 
               CALL cl_err('','alm-414',1)
               RETURN       
            END IF       
                               
         AFTER FIELD lnh06     
            IF g_lnh[l_ac3].lnh06 = 'Y' THEN     
               LET g_lnh[l_ac3].lnh07 = g_lnh[l_ac3].lnh05
            ELSE             
               IF g_lnh[l_ac3].lnh06 = 'N' THEN 
                  LET g_lnh[l_ac3].lnh07 = g_lnh[l_ac3].lnh04
               END IF      
            END IF           
                                
         BEFORE DELETE                      
            IF g_lnh_t.lnhstore IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF      
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lnhstore"
               LET g_doc.value1 = g_lnh[l_ac3].lnhstore
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lnh_file WHERE lnhstore = g_lnh_t.lnhstore
                                      AND lnh01 = g_lne.lne01

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lnh_file",g_lnh_t.lnhstore,"",SQLCA.sqlcode,"","",1)
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
               LET g_lnh[l_ac3].* = g_lnh_t.*
               CLOSE i300_bcl_3
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lnh[l_ac3].lnhstore,-263,0)
               LET g_lnh[l_ac3].* = g_lnh_t.*
            ELSE
               UPDATE lnh_file SET lnhstore=g_lnh[l_ac3].lnhstore,
                                   lnhlegal=g_lnh[l_ac3].lnhlegal,
                                   lnh04=g_lnh[l_ac3].lnh04,
                                   lnh05=g_lnh[l_ac3].lnh05,
                                   lnh06=g_lnh[l_ac3].lnh06,
                                   lnh07=g_lnh[l_ac3].lnh07
                WHERE lnhstore = g_lnh_t.lnhstore
                  AND lnh01 = g_lne.lne01

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lnh_file",g_lnh_t.lnhstore,"",SQLCA.sqlcode,"","",1)
                  LET g_lnh[l_ac3].* = g_lnh_t.*             
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
                  LET g_lnh[l_ac3].* = g_lnh_t.*
               ELSE
                  CALL g_lnh.deleteElement(l_ac3)
               END IF
               CLOSE i300_bcl_3 
               ROLLBACK WORK  
               EXIT DIALOG
            END IF 
               
            CLOSE i300_bcl_3    
            COMMIT WORK
               
         ON ACTION controlp                      
           CASE                      
             WHEN INFIELD(lnhstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz11"
               LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
               LET g_qryparam.default1 = g_lnh[l_ac3].lnhstore
               CALL cl_create_qry() RETURNING g_lnh[l_ac3].lnhstore
               DISPLAY g_lnh[l_ac3].lnhstore TO lnhstore
               NEXT FIELD lnhstore
             OTHERWISE
              EXIT CASE
            END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_lnh.deleteElement(l_ac3)
            END IF
            EXIT DIALOG

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(lnhstore) AND l_ac3 > 1 THEN
               LET g_lnh[l_ac3].* = g_lnh[l_ac3-1].*
               NEXT FIELD lnhstore 
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
          
   CLOSE i300_bcl_1
   CLOSE i300_bcl_2
   CLOSE i300_bcl_3
   COMMIT WORK
          
END FUNCTION 
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_lng03(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_tqaacti LIKE tqa_file.tqaacti

   LET g_errno = ''
   SELECT tqa02,tqaacti INTO g_lng[l_ac1].tqa02_3,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lng[l_ac1].lng03 AND tqa03 = '24'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-740'
                               LET g_lng[l_ac1].tqa02_3 = NULL
      WHEN l_tqaacti = 'N'     LET g_errno = 'alm-741'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_lnhstore()
DEFINE l_rtz28  LIKE rtz_file.rtz28
DEFINE l_sql    STRING
DEFINE l_n      LIKE type_file.num5

   SELECT rtz28 INTO l_rtz28 FROM rtz_file WHERE rtz01 = g_lnh[l_ac3].lnhstore
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-077'
      WHEN l_rtz28 <> 'Y'      LET g_errno = 'alm-002'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM azw_file ",
                  " WHERE azw01 = '",g_lnh[l_ac3].lnhstore,"' AND azw01 IN ",g_auth
      PREPARE sel_azw_pre FROM l_sql
      EXECUTE sel_azw_pre INTO l_n
      IF l_n = 0 THEN LET g_errno = 'alm-737' END IF
      IF cl_null(g_errno) THEN
         SELECT azw02 INTO g_lnh[l_ac3].lnhlegal FROM azw_file
          WHERE azw01 = g_lnh[l_ac3].lnhstore
         SELECT azt02 INTO g_lnh[l_ac3].azt02 FROM azt_file
          WHERE azt01 = g_lnh[l_ac3].lnhlegal
         SELECT rtz13 INTO g_lnh[l_ac3].rtz13_2 FROM rtz_file
          WHERE rtz01 = g_lnh[l_ac3].lnhstore
      END IF
   END IF
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_b1_fill(p_wc1)
 DEFINE   p_wc1           LIKE type_file.chr1000

    IF cl_null(p_wc1) THEN LET p_wc1 = " 1=1" END IF
    LET g_sql ="SELECT lng03,'',lng04,lng05,lng06,lng07",
               " FROM lng_file ",
               " WHERE ", p_wc1 CLIPPED,
               " and lng01 = '",g_lne.lne01,"'",
               " ORDER BY lng03"
    PREPARE i300_lng_pb FROM g_sql
    DECLARE sel_lng_curs CURSOR FOR i300_lng_pb

    CALL g_lng.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH sel_lng_curs INTO g_lng[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT tqa02 INTO g_lng[g_cnt].tqa02_3  
          FROM tqa_file 
         WHERE tqa01 = g_lng[g_cnt].lng03 AND tqa03 = '24'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lng.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn3
    LET g_cnt = 0

END FUNCTION

FUNCTION i300_b2_fill(p_wc2)
 DEFINE   p_wc2           LIKE type_file.chr1000
 DEFINE   l_tqa02         LIKE tqa_file.tqa02
 DEFINE   l_geo02         LIKE geo_file.geo02

    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
    LET g_sql ="SELECT lnf03,'',lnf04,'' ",
               " FROM lnf_file ",
               " WHERE ", p_wc2 CLIPPED,
               " and lnf01 = '",g_lne.lne01,"'",
               " and lnf02 = '",g_lne.lne02,"'",
               " ORDER BY lnf03"
    PREPARE i300_lnf_pb FROM g_sql
    DECLARE sel_lnf_curs CURSOR FOR i300_lnf_pb

    CALL g_lnf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH sel_lnf_curs INTO g_lnf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT tqa02 INTO l_tqa02 FROM tqa_file
         WHERE tqa01 = g_lnf[g_cnt].lnf03
           AND tqa03 = '2'
           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                 OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
           AND tqaacti = 'Y'
        LET g_lnf[g_cnt].tqa02_2 = l_tqa02

       #SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
       # WHERE geo01 = g_lnf[g_cnt].lnf04        #TQC-C40051 mark
        SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
         WHERE oqw01 = g_lnf[g_cnt].lnf04        #TQC-C40051 add
           AND oqwacti  = 'Y'
        LET g_lnf[g_cnt].geo02_2 = l_geo02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
    LET g_cnt = 0

END FUNCTION

FUNCTION i300_b3_fill(p_wc3)
 DEFINE   p_wc3           LIKE type_file.chr1000
 DEFINE   l_rtz13         LIKE rtz_file.rtz13

    IF cl_null(p_wc3) THEN LET p_wc3 = " 1=1" END IF
    LET g_sql ="SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07",
               " FROM lnh_file ",
               " WHERE ", p_wc3 CLIPPED,
               " and lnh01 = '",g_lne.lne01,"'",
               "  AND lnhstore IN ",g_auth," ",
               " ORDER BY lnhstore"
    PREPARE i300_lnh_pb FROM g_sql
    DECLARE sel_lnh_curs CURSOR FOR i300_lnh_pb

    CALL g_lnh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH sel_lnh_curs INTO g_lnh[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT rtz13 INTO g_lnh[g_cnt].rtz13_2 FROM rtz_file
         WHERE rtz01 = g_lnh[g_cnt].lnhstore

        SELECT azt02 INTO g_lnh[g_cnt].azt02 FROM azt_file
         WHERE azt01 = g_lnh[g_cnt].lnhlegal
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt - 1
    DISPLAY g_rec_b3 TO FORMONLY.cn5
    LET g_cnt = 0

END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_set_lne03()

   IF g_aza.aza113 = 'Y' THEN
      CALL cl_set_comp_entry('lne03',TRUE)
      CALL cl_set_comp_required('lne03',TRUE)
      CALL cl_err('','alm-655',0)
   ELSE
      CALL cl_set_comp_required('lne03',FALSE)
      CALL cl_set_comp_entry('lne03',FALSE)
   END IF
END FUNCTION
#FUN-B90056 Add End -----

#FUN-B90056 Add Begin ---
FUNCTION i300_set_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lng03,lng04",TRUE)
   END IF

END FUNCTION

FUNCTION i300_set_no_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lng03,lng04",FALSE)
   END IF

END FUNCTION

FUNCTION i300_set_entry_b2(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lnf03",TRUE)
   END IF

END FUNCTION

FUNCTION i300_set_no_entry_b2(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lnf03",FALSE)
   END IF
END FUNCTION

FUNCTION i300_set_entry_b3(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lnhstore",TRUE)
   END IF

END FUNCTION

FUNCTION i300_set_no_entry_b3(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lnhstore",FALSE)
   END IF

END FUNCTION
#FUN-B90056 Add End -----
 
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 

#FUN-C40029 add START
FUNCTION i300_cer_unconfirm()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lne.lne01) THEN CALL cl_err('',-400,1) RETURN END IF
   SELECT * INTO g_lne.* FROM lne_file WHERE lne01 = g_lne.lne01
   IF g_lne.lne59 = 'N' THEN
      CALL cl_err('','alm-h23',0)
      RETURN
   END IF

   LET g_success = 'Y'

   BEGIN WORK

   OPEN i300_cl USING g_lne.lne01
   IF STATUS THEN
      CALL cl_err("open i300_cl:",STATUS,1)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i300_cl INTO g_lne.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm('alm-h24') THEN
      RETURN
   ELSE
      UPDATE lne_file SET lne59 = 'N'
       WHERE lne01 = g_lne.lne01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_lne.lne01,SQLCA.sqlcode,0)
         LET g_success = 'N'
      END IF
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT * INTO g_lne.* FROM lne_file WHERE lne01 = g_lne.lne01
   CALL i300_show()
   CLOSE i300_cl
END FUNCTION

#FUN-C60062 add begin --
FUNCTION i300_out()
   DEFINE l_cmd LIKE type_file.chr1000
   CALL cl_wait()
   LET g_wc4 =  cl_replace_str(g_wc,"'","\'")
   LET g_wc5 =  cl_replace_str(g_wc1,"'","\'")
   LET g_wc6 =  cl_replace_str(g_wc2,"'","\'")
   LET g_wc7 =  cl_replace_str(g_wc3,"'","\'")
   LET l_cmd='almg300 "',g_wc4,'" "',g_lang CLIPPED,'" "',g_today,'" Y "',g_wc5,'" "',g_wc6,'" "',g_wc7,'" '
   CALL cl_cmdrun(l_cmd)
   ERROR ''
END FUNCTION

#FUN-C60062 add end-----
#FUN-C40029 add END

