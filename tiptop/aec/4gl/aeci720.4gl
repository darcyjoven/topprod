# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci720.4gl
# Descriptions...: 產品工藝變更維護作業
# Date & Author..: 07/10/22 By jan
# Modify.........: No.FUN-810014 08/02/01 By arman 行業別的修改
# Modify.........: No.FUN-7B0018 08/02/17 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modufy.........: No.FUN-870124 08/07/25 By jan 服飾作業功能完善
# Modufy.........: No.FUN-8A0136 08/10/30 By arman  
# Modufy.........: No.FUN-8A0142 08/10/30 By arman  
# Modify.........: No.TQC-910003 09/01/03 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-920186 09/03/17 By lala  理由碼sgt03必須為工藝原因
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950190 09/05/25 By Pengu 新增作業編號時，應強制要輸入轉出與轉入單位
# Modify.........: No.TQC-970233 09/07/23 By lilingyu 單頭隨工單編號帶出來的產品料號的品名有誤
# Modify.........: No.TQC-970238 09/07/23 By lilingyu 新增時,進入新轉入單位sgu38,新轉出單位sgu39時,管控有誤
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0071 09/10/22 By wujie     5.2轉用標準sql語法
# Modify.........: No:MOD-980266 09/11/12 By sabrina 變更發出的訊息錯誤
# Modify.........: No:MOD-980267 09/11/12 By sabrina 刪除第一到製程序時未將良品轉入移轉至下一站
# Modify.........: No:MOD-9B0182 09/11/26 By lilingyu 資料變更時,變更作業編號,對應的作業說明沒有更新到ecm_file制程追蹤檔
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.MOD-A30038 10/03/09 By liuxqa update sgt06中錯誤段處理不應該有return.
# Modify.........: No:MOD-A60094 10/06/14 By Sarah sgu03='1' or '3'時都要計算轉換率
# Modify.........: No.FUN-A60080 10/07/05 By destiny 画面增加工艺段，工艺序字段
# Modify.........: No:MOD-A70124 10/07/15 By Sarah 應該以作業代號帶出作業名稱寫入ecm45　
# Modify.........: No.TQC-AC0093 10/12/13 By vealxu 1.製程段和製程式沒提供開窗 (應該要撈ecm_file)
#                                                   2.上述兩個欄位應該放在"變更方式"的後面
#                                                   3.先打製程段號再打製程式會檢查不過
# Modify.........: No:TQC-AC0374 10/12/30 By jan 從抓製程料號
# Modify.........: No:FUN-B10056 11/02/16 By jan 新增下製程段號欄位及處理
# Modify.........: No:FUN-B20078 11/03/04 By jan 製程段號改從ecr_file檢查
# Modify.........: No:MOD-B30035 11/03/07 By 輸入完作業編號及工作站時應判斷是否存在系統裡
# Modify.........: No:FUN-B30019 11/03/09 By lixh1 欄位調整
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50178 11/05/30 By lixh1 增加'委外廠商(ecm67)'的變更功能
# Modify.........: No.FUN-A70095 11/06/10 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改 
# Modify.........: No.CHI-B80096 11/09/02 By xianghui 對組成用量(ecm62)/底數(63)/ecm66(關鍵報工點否)的預設值處理
# Modify.........: No.FUN-B90141 11/11/09 By jason 檢查'單位轉換分子/單位轉換分母'需等於單位轉換率
# Modify.........: No.FUN-BB0085 11/12/07 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BC0119 12/01/16 By bart 增加列印報表

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30626 12/03/13 By xujing 修改錯誤訊息asfi115為aec-070
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No.MOD-C80002 12/08/01 By suncx 已經產生委外採購的工藝應該不可刪除和變更
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C70022 12/11/12 By bart 1.已報工不可在前面插入新製程，只能於後面新增
#                                                 2.新增製程序時，將下一個製程之良品轉入量移至此製程，刪除製程序時反之
# Modify.........: No.CHI-C80041 12/12/28 By bart 排除作廢
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sgt      RECORD LIKE sgt_file.*,
    g_sgt_t    RECORD LIKE sgt_file.*,
    g_sgt_o    RECORD LIKE sgt_file.*,
    g_sgt01_t  LIKE sgt_file.sgt01,
    g_sgt02_t  LIKE sgt_file.sgt02,
    g_ecb03_t  LIKE ecb_file.ecb03,
    l_eci01    LIKE eci_file.eci01,
    g_wc,g_wc2,g_sql   string,                     
    g_sgu           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgu012          LIKE sgu_file.sgu012,  #NO.FUN-A60080
        sgu014          LIKE sgu_file.sgu014,  #FUN-B10056
        sgu04           LIKE sgu_file.sgu04,
        sgu03           LIKE sgu_file.sgu03,
        sgu015          LIKE sgu_file.sgu015,  #FUN-B10056
        sgu05           LIKE sgu_file.sgu05,
        sgu06           LIKE sgu_file.sgu06,
        sgu07           LIKE sgu_file.sgu07,
        sgu08           LIKE sgu_file.sgu08,
        sgu10           LIKE sgu_file.sgu10,
        sgu11           LIKE sgu_file.sgu11,
        sgu12           LIKE sgu_file.sgu12,
        sgu13           LIKE sgu_file.sgu13,
        sgu14           LIKE sgu_file.sgu14,
        sgu53           LIKE sgu_file.sgu53,  #FUN-B50178
        sgu15           LIKE sgu_file.sgu15,
        sgu16           LIKE sgu_file.sgu16,
        sgu17           LIKE sgu_file.sgu17,
        sgu18           LIKE sgu_file.sgu18,
      # sgu19           LIKE sgu_file.sgu19, #FUN-B30019
        sgu20           LIKE sgu_file.sgu20,
      # sgu21           LIKE sgu_file.sgu21, #FUN-B30019
#FUN-B30019 ---------------Begin------------------------
        sgu43           LIKE sgu_file.sgu43,   
        sgu44           LIKE sgu_file.sgu44,
        sgu45           LIKE sgu_file.sgu45,
        sgu46           LIKE sgu_file.sgu46,
        sgu47           LIKE sgu_file.sgu47,
#FUN-B30019 ---------------End--------------------------        
        sgu22           LIKE sgu_file.sgu22,
        sgu23           LIKE sgu_file.sgu23,
        sguislk01       LIKE sgui_file.sguislk01,
        sguislk02       LIKE sgui_file.sguislk02,
        sguislk03       LIKE sgui_file.sguislk03,
        sguislk04       LIKE sgui_file.sguislk04,
        sgu016          LIKE sgu_file.sgu016,  #FUN-B10056
        sgu24           LIKE sgu_file.sgu24,
        sgu25           LIKE sgu_file.sgu25,
        sgu26           LIKE sgu_file.sgu26,
        sgu27           LIKE sgu_file.sgu27,
        sgu29           LIKE sgu_file.sgu29,
        sgu30           LIKE sgu_file.sgu30,
        sgu31           LIKE sgu_file.sgu31,
        sgu32           LIKE sgu_file.sgu32,
        sgu33           LIKE sgu_file.sgu33,
        sgu54           LIKE sgu_file.sgu54,  #FUN-B50178
        sgu34           LIKE sgu_file.sgu34,
        sgu35           LIKE sgu_file.sgu35,
        sgu36           LIKE sgu_file.sgu36,
        sgu37           LIKE sgu_file.sgu37,
      # sgu38           LIKE sgu_file.sgu38,  #FUN-B30019
        sgu39           LIKE sgu_file.sgu39,
      # sgu40           LIKE sgu_file.sgu40,  #FUN-B30019
#FUN-B30019 -----------------Begin-----------------------
        sgu48           LIKE sgu_file.sgu48,
        sgu49           LIKE sgu_file.sgu49,
        sgu50           LIKE sgu_file.sgu50,
        sgu51           LIKE sgu_file.sgu51,
        sgu52           LIKE sgu_file.sgu52,
#FUN-B30019 -----------------End-------------------------
        sgu41           LIKE sgu_file.sgu41,
        sgu42           LIKE sgu_file.sgu42,
        sguislk05       LIKE sgui_file.sguislk05,
        sguislk06       LIKE sgui_file.sguislk06,
        sguislk07       LIKE sgui_file.sguislk07,
        sguislk08       LIKE sgui_file.sguislk08
                    END RECORD,
    g_sgu_t         RECORD                 #程式變數 (舊值)
        sgu012          LIKE sgu_file.sgu012,  #NO.FUN-A60080    
        sgu014          LIKE sgu_file.sgu014,  #FUN-B10056
        sgu04           LIKE sgu_file.sgu04,
        sgu03           LIKE sgu_file.sgu03,
        sgu015          LIKE sgu_file.sgu015,  #FUN-B10056
        sgu05           LIKE sgu_file.sgu05,
        sgu06           LIKE sgu_file.sgu06,
        sgu07           LIKE sgu_file.sgu07,
        sgu08           LIKE sgu_file.sgu08,
        sgu10           LIKE sgu_file.sgu10,
        sgu11           LIKE sgu_file.sgu11,
        sgu12           LIKE sgu_file.sgu12,
        sgu13           LIKE sgu_file.sgu13,
        sgu14           LIKE sgu_file.sgu14,
        sgu53           LIKE sgu_file.sgu53, #FUN-B50178 
        sgu15           LIKE sgu_file.sgu15,
        sgu16           LIKE sgu_file.sgu16,
        sgu17           LIKE sgu_file.sgu17,
        sgu18           LIKE sgu_file.sgu18,
    #   sgu19           LIKE sgu_file.sgu19, #FUN-B30019
        sgu20           LIKE sgu_file.sgu20,
    #   sgu21           LIKE sgu_file.sgu21, #FUN-B30019
#FUN-B30019 ---------------Begin------------------------
        sgu43           LIKE sgu_file.sgu43,
        sgu44           LIKE sgu_file.sgu44,
        sgu45           LIKE sgu_file.sgu45,
        sgu46           LIKE sgu_file.sgu46,
        sgu47           LIKE sgu_file.sgu47,
#FUN-B30019 ---------------End--------------------------
        sgu22           LIKE sgu_file.sgu22,
        sgu23           LIKE sgu_file.sgu23,
        sguislk01       LIKE sgui_file.sguislk01,
        sguislk02       LIKE sgui_file.sguislk02,
        sguislk03       LIKE sgui_file.sguislk03,
        sguislk04       LIKE sgui_file.sguislk04,
        sgu016          LIKE sgu_file.sgu016,  #FUN-B10056
        sgu24           LIKE sgu_file.sgu24,
        sgu25           LIKE sgu_file.sgu25,
        sgu26           LIKE sgu_file.sgu26,
        sgu27           LIKE sgu_file.sgu27,
        sgu29           LIKE sgu_file.sgu29,
        sgu30           LIKE sgu_file.sgu30,
        sgu31           LIKE sgu_file.sgu31,
        sgu32           LIKE sgu_file.sgu32,
        sgu33           LIKE sgu_file.sgu33,
        sgu54           LIKE sgu_file.sgu54, #FUN-B50178
        sgu34           LIKE sgu_file.sgu34,
        sgu35           LIKE sgu_file.sgu35,
        sgu36           LIKE sgu_file.sgu36,
        sgu37           LIKE sgu_file.sgu37,
     #  sgu38           LIKE sgu_file.sgu38, #FUN-B30019
        sgu39           LIKE sgu_file.sgu39,
     #  sgu40           LIKE sgu_file.sgu40, #FUN-B30019
#FUN-B30019 -----------------Begin-----------------------
        sgu48           LIKE sgu_file.sgu48,
        sgu49           LIKE sgu_file.sgu49,
        sgu50           LIKE sgu_file.sgu50,
        sgu51           LIKE sgu_file.sgu51,
        sgu52           LIKE sgu_file.sgu52,
#FUN-B30019 -----------------End-------------------------
        sgu41           LIKE sgu_file.sgu41,
        sgu42           LIKE sgu_file.sgu42,
        sguislk05       LIKE sgui_file.sguislk05,
        sguislk06       LIKE sgui_file.sguislk06,
        sguislk07       LIKE sgui_file.sguislk07,
        sguislk08       LIKE sgui_file.sguislk08
                    END RECORD,
    g_sw            LIKE type_file.chr1,         
    p_row,p_col     LIKE type_file.num5,        
    g_rec_b         LIKE type_file.num5,         
    l_ac            LIKE type_file.num5         
 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5         
DEFINE g_cnt                 LIKE type_file.num10        
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_curs_index          LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num10      
DEFINE b_sgui                RECORD LIKE sgui_file.*      
DEFINE g_sql_tmp             STRING
DEFINE g_ecm65               LIKE ecm_file.ecm65     #FUN-B30019
DEFINE g_sgu39_t             LIKE sgu_file.sgu39     #FUN-BB0085
 
MAIN
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 1 LET p_col = 3
 
   OPEN WINDOW i720_w AT p_row,p_col WITH FORM "aec/42f/aeci720"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
                                                                                                             
       CALL cl_set_comp_visible("dummy20,dummy21,dummy22,dummy23,sguislk01,sguislk02,                                 sguislk03,sguislk04,sguislk05,sguislk06,sguislk07,sguislk08",FALSE)                                                              
   CALL cl_set_comp_entry("sgu014",FALSE)  #FUN-B10056
   #NO.FUN-A60080--begin
   IF g_sma.sma541='N' THEN 
      CALL cl_set_comp_visible("dummy1,sgu012,dummy2,sgu014,dummy3,sgu015,sgu016",FALSE)  #FUN-B10056
   END IF 
   #NO.FUN-A60080--end
   CALL i720()
 
   CLOSE WINDOW i720_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i720()
 
   INITIALIZE g_sgt.* TO NULL
   INITIALIZE g_sgt_t.* TO NULL
   INITIALIZE g_sgt_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM sgt_file WHERE sgt01 = ? AND sgt02 = ? FOR UPDATE "   #No.FUN-9A0071
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i720_cl CURSOR FROM g_forupd_sql
 
   CALL i720_menu()
 
END FUNCTION
 
FUNCTION i720_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_sgu.clear()
   CALL cl_set_head_visible("","YES")    
   CONSTRUCT BY NAME g_wc ON 
        sgt01, sgt07, sgt05,sgt06,sgt02,sgt08,sgt03,sgt04,
        sgtuser, sgtgrup, sgtmodu, sgtdate, sgtacti  
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgt01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecm8"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgt01
                   NEXT FIELD sgt01
              WHEN INFIELD(sgt03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_azf01a"   #FUN-920186
                   LET g_qryparam.arg1  = 'A'         #FUN-920186
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgt03
                   NEXT FIELD sgt03
              OTHERWISE EXIT CASE
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
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON sgu012,sgu014,sgu04,sgu03,sgu015,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13,sgu14,sgu53,sgu15,   #NO.FUN-A60080  add sgu012 #FUN-B10056  #FUN-B50178 add sgu53
#                     sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,  #FUN-B30019
                      sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45,        #FUN-B30019
                      sgu46,sgu47,sgu22,sgu23,                          #FUN-B30019 
                      sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30,sgu31,sgu32,sgu33,sgu54,sgu34,  #FUN-B10056   #FUN-B50178 add sgu54
#                     sgu35,sgu36,sgu37,sgu38,sgu39,sgu40,sgu41,sgu42   #FUN-B30019
                      sgu35,sgu36,sgu37,sgu39,sgu48,sgu49,sgu50,        #FUN-B30019
                      sgu51,sgu52,sgu41,sgu42                           #FUN-B30019
           FROM s_sgu[1].sgu012,s_sgu[1].sgu014,s_sgu[1].sgu04,s_sgu[1].sgu03,s_sgu[1].sgu015,s_sgu[1].sgu05,s_sgu[1].sgu06,   #NO.FUN-A60080  add sgu012#FUN-B10056
                s_sgu[1].sgu07,s_sgu[1].sgu08,s_sgu[1].sgu10,s_sgu[1].sgu11,s_sgu[1].sgu12,s_sgu[1].sgu13,s_sgu[1].sgu14,
                s_sgu[1].sgu53,       #FUN-B50178
#               s_sgu[1].sgu15,s_sgu[1].sgu16,s_sgu[1].sgu17,s_sgu[1].sgu18,s_sgu[1].sgu19,s_sgu[1].sgu20,
                s_sgu[1].sgu15,s_sgu[1].sgu16,s_sgu[1].sgu17,s_sgu[1].sgu18,s_sgu[1].sgu20,   #FUN-B30019
#               s_sgu[1].sgu21,s_sgu[1].sgu22,s_sgu[1].sgu23,       #FUN-B30019
                s_sgu[1].sgu43,s_sgu[1].sgu44,s_sgu[1].sgu45,       #FUN-B30019
                s_sgu[1].sgu46,s_sgu[1].sgu47,       #FUN-B30019   
                s_sgu[1].sgu22,s_sgu[1].sgu23,       #FUN-B30019
                s_sgu[1].sgu016,s_sgu[1].sgu24,s_sgu[1].sgu25,s_sgu[1].sgu26,s_sgu[1].sgu27,  #FUN-B10056
                s_sgu[1].sgu29,s_sgu[1].sgu30,s_sgu[1].sgu31,s_sgu[1].sgu32,s_sgu[1].sgu33,s_sgu[1].sgu54,s_sgu[1].sgu34,  #FUN-B50178 add sgu54
#               s_sgu[1].sgu35,s_sgu[1].sgu36,s_sgu[1].sgu37,s_sgu[1].sgu38,s_sgu[1].sgu39,s_sgu[1].sgu40,   #FUN-B30019
                s_sgu[1].sgu35,s_sgu[1].sgu36,s_sgu[1].sgu37,s_sgu[1].sgu39,         #FUN-B30019
                s_sgu[1].sgu48,s_sgu[1].sgu49,s_sgu[1].sgu50,  #FUN-B30019
                s_sgu[1].sgu51,s_sgu[1].sgu52,                 #FUN-B30019 
                s_sgu[1].sgu41,s_sgu[1].sgu42
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp                        #
           CASE
             #TQC-AC0093 --------add start--------
              WHEN INFIELD(sgu012)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecr"  #FUN-B20078
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu012
                   NEXT FIELD sgu012
  
             #FUN-B10056--begin--add-----
             WHEN INFIELD(sgu016)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecr"  #FUN-B20078
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu016
                   NEXT FIELD sgu016
             #FUN-B10056--end--add---------
             
             WHEN INFIELD(sgu04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecm03"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu04
                   NEXT FIELD sgu04
             #TQC-AC0093 --------add end------------ 
              WHEN INFIELD(sgu26)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_eci"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu26
                   NEXT FIELD sgu26
              WHEN INFIELD(sgu25)
                   CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu25
                   NEXT FIELD sgu25
              WHEN INFIELD(sgu24)
                   CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu24
                   NEXT FIELD sgu24
              WHEN INFIELD(sgu36)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu36
                   NEXT FIELD sgu36
              WHEN INFIELD(sgu37)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_sgg"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu37
                   NEXT FIELD sgu37
#FUN-B30019 ----------------Begin---------------------
#              WHEN INFIELD(sgu38)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.form = "q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO sgu38
#                   NEXT FIELD sgu38
#FUN-B30019 ----------------End-----------------------
              WHEN INFIELD(sgu39)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu39
                   NEXT FIELD sgu39
#FUN-B50178 ---------------Begin----------------
              WHEN INFIELD(sgu53)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu53
                   NEXT FIELD sgu53   
              WHEN INFIELD(sgu54)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgu54
                   NEXT FIELD sgu54
#FUN-B50178 ---------------End------------------
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
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgtuser', 'sgtgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT sgt01,sgt02 FROM sgt_file ",   #No.FUN-9A0071
                " WHERE ",g_wc CLIPPED, " ORDER BY sgt01,sgt02"
   ELSE
      LET g_sql="SELECT sgt01,sgt02",                  #No.FUN-9A0071
                "  FROM sgt_file,sgu_file ",
                " WHERE sgt01=sgu01 AND sgt02=sgu02",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY sgt01,sgt02"
   END IF
   PREPARE i720_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE i720_cs SCROLL CURSOR WITH HOLD FOR i720_prepare
 
   IF g_wc2=' 1=1' THEN                                                                                                            
       LET g_sql_tmp= "SELECT UNIQUE sgt01,sgt02 FROM sgt_file WHERE ",g_wc CLIPPED,
                      " INTO TEMP x" 
    ELSE
       LET g_sql_tmp= "SELECT UNIQUE sgt01,sgt02 FROM sgt_file,sgu_file",
                  " WHERE sgt01=sgu01 AND sgt02=sgu02",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "   INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i720_precount_x FROM g_sql_tmp
    EXECUTE i720_precount_x
    LET g_sql="SELECT COUNT(*) FROM x " 
   PREPARE i720_precount FROM g_sql
   DECLARE i720_count CURSOR FOR i720_precount
 
END FUNCTION
 
FUNCTION i720_menu()
DEFINE   l_wc   STRING     #FUN-BC0119

   WHILE TRUE
      CALL i720_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i720_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i720_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i720_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i720_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i720_copy() ROLLBACK WORK
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i720_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgu),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_sgt.sgt01 IS NOT NULL THEN
                LET g_doc.column1 = "sgt01"
                LET g_doc.column2 = "sgt02"
                LET g_doc.value1 = g_sgt.sgt01
                LET g_doc.value2 = g_sgt.sgt02
                CALL cl_doc()
             END IF 
          END IF
                                                                                             
        WHEN "confirm"                                                                                                           
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i720_confirm()
           END IF                                                                                                                   
                                                                                                                                    
        WHEN "notconfirm"                                                                                                        
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i720_notconfirm()
           END IF 
        
        WHEN "release"       
            IF cl_chk_act_auth() THEN
               CALL i720_g()
               CALL i720_show()  #FUN-B20078
            END IF   
         #FUN-BC0119 ----- begin-------
        WHEN "output"
            IF cl_null(g_sgt.sgt01) OR cl_null(g_sgt.sgt02) THEN
               CALL cl_err('','-400',1)
               LET g_action_choice=NULL
               RETURN
            END IF
            IF cl_chk_act_auth() THEN
               LET l_wc=' sgt01= "',g_sgt.sgt01,'" AND sgt02=',g_sgt.sgt02,' '
              #LET g_msg="aecr720 ", #FUN-C30085 mark
               LET g_msg="aecg720 ", #FUN-C30085 add
                         "'",g_today,"'",
                         " '",g_user,"'",
                         " '",g_lang,"'",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",l_wc,"'",
                         " 'N' ",
                         " '3'"
               CALL cl_cmdrun(g_msg)
            END IF  
        #FUN-BC0119 ----- end-------
      END CASE
   END WHILE
   CLOSE i720_cs
END FUNCTION
 
FUNCTION i720_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_sgu.clear()
    INITIALIZE g_sgt.* LIKE sgt_file.*
    LET g_sgt01_t = NULL
    LET g_sgt.sgt07 = 'N'
    LET g_sgt.sgt05 = g_today
    LET g_sgt.sgt08 = 'N'
    LET g_sgt.sgtacti = 'Y'
    LET g_sgt.sgtuser = g_user
    LET g_sgt.sgtoriu = g_user #FUN-980030
    LET g_sgt.sgtorig = g_grup #FUN-980030
    LET g_data_plant = g_plant #FUN-980030
    LET g_sgt.sgtgrup = g_grup
    LET g_sgt.sgtdate = TODAY
    LET g_sgt_t.* = g_sgt.*    #No.FUN-870124
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i720_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_sgu.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_sgt.sgt01) OR cl_null(g_sgt.sgt02)  THEN 
           CONTINUE WHILE
        END IF
        LET g_sgt.sgtplant = g_plant #FUN-980002
        LET g_sgt.sgtlegal = g_legal #FUN-980002
        INSERT INTO sgt_file VALUES(g_sgt.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","sgt_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1) 
           CONTINUE WHILE
        ELSE
           LET g_sgt_t.* = g_sgt.*               # 保存上筆資料
        END IF
 
        CALL g_sgu.clear()
        LET g_rec_b = 0
 
        CALL i720_b()
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i720_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1, 
        l_flag          LIKE type_file.chr1,  
        l_sfb103        LIKE sfb_file.sfb103,
        l_ecm03_par     LIKE ecm_file.ecm03_par,
        l_ima02         LIKE ima_file.ima02,
        l_azf09         LIKE azf_file.azf09,       #FUN-920186
        l_n             LIKE type_file.num5, 
        l_n1            LIKE type_file.num5
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    DISPLAY BY NAME g_sgt.sgt07,g_sgt.sgt05,g_sgt.sgt08,g_sgt.sgtuser,
                    g_sgt.sgtmodu,g_sgt.sgtgrup,g_sgt.sgtdate,g_sgt.sgtacti
    INPUT BY NAME g_sgt.sgtoriu,g_sgt.sgtorig,
        g_sgt.sgt01, g_sgt.sgt05, g_sgt.sgt03,g_sgt.sgt04,
        g_sgt.sgtuser,g_sgt.sgtgrup,g_sgt.sgtmodu,g_sgt.sgtdate,g_sgt.sgtacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i720_set_entry(p_cmd)
            CALL i720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD sgt01
            IF NOT cl_null(g_sgt.sgt01) THEN
               IF g_sgt_t.sgt01 IS NULL OR
                 (g_sgt.sgt01 != g_sgt_t.sgt01) THEN
                  CALL i720_sgt01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_sgt.sgt01,g_errno,0)
                     LET g_sgt.sgt01 = g_sgt_t.sgt01
                     DISPLAY BY NAME g_sgt.sgt01
                     NEXT FIELD sgt01
                  END IF
                  CALL i720_sgt01_1('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_sgt.sgt01,g_errno,0)
                     LET g_sgt.sgt01 = g_sgt_t.sgt01
                     DISPLAY BY NAME g_sgt.sgt01
                     NEXT FIELD sgt01
                  END IF
               SELECT count(*) INTO l_n
                 FROM ecm_file,sfb_file
                WHERE sfb01 = ecm01
                  AND sfb87 = 'Y'
                  AND sfb04 != '8'
                  AND sfb01 = g_sgt.sgt01
                IF l_n = 0 THEN
                   CALL cl_err('','aec-070',0) #MOD-C30626
                   NEXT FIELD sgt01
                END IF
                SELECT COUNT(*) INTO l_n1
                  FROM sgt_file
                 WHERE sgt01 = g_sgt.sgt01
                   AND sgt08 = 'N'
                 IF l_n1 > 0 THEN
                    CALL cl_err('','aec-106',0)
                    NEXT FIELD sgt01
                 END IF
                 SELECT sfb103 INTO l_sfb103
                   FROM sfb_file
                  WHERE sfb01 = g_sgt.sgt01
                  IF l_sfb103 IS NULL THEN
                     LET l_sfb103 = 0
                  END IF
                  LET g_sgt.sgt02 = l_sfb103 + 1
                  DISPLAY BY NAME g_sgt.sgt02
                END IF
            END IF
       
        AFTER FIELD sgt03
          IF NOT cl_null(g_sgt.sgt03) THEN
             LET l_n1 = 0 
             SELECT count(*) INTO l_n1
               FROM azf_file
              WHERE azf01 = g_sgt.sgt03
                AND azfacti = 'Y'
                AND azf02 ='2'
             IF l_n1 = 0 THEN
                CALL cl_err('','aec-070',0)  #MOD-C30626
                NEXT FIELD sgt03
             END IF
             SELECT azf09 INTO l_azf09
               FROM azf_file
              WHERE azf01 = g_sgt.sgt03
                AND azfacti = 'Y'
                AND azf02 ='2'
             IF l_azf09 != 'A' THEN
                CALL cl_err('','aoo-409',0)
                NEXT FIELD sgt03
             END IF
             SELECT azf03 INTO g_sgt.sgt04
               FROM azf_file
              WHERE azf01 = g_sgt.sgt03
                AND azfacti = 'Y'
                AND azf02 = '2'
             DISPLAY BY NAME g_sgt.sgt04
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_sgt.sgtuser = s_get_data_owner("sgt_file") #FUN-C10039
           LET g_sgt.sgtgrup = s_get_data_group("sgt_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgt01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecm8"
                   LET g_qryparam.default1 = g_sgt.sgt01
                   CALL cl_create_qry() RETURNING g_sgt.sgt01
                   DISPLAY BY NAME g_sgt.sgt01       
                   NEXT FIELD sgt01
              WHEN INFIELD(sgt03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf01a"   #FUN-920186
                   LET g_qryparam.arg1  = 'A'         #FUN-920186
                   LET g_qryparam.default1 = g_sgt.sgt03
                   CALL cl_create_qry() RETURNING g_sgt.sgt03
                   DISPLAY BY NAME g_sgt.sgt03      
                   NEXT FIELD sgt03
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i720_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sgt01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i720_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sgt01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sgt.* TO NULL              
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL g_sgu.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i720_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgu.clear()
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    OPEN i720_count
    FETCH i720_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i720_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgt.sgt01,SQLCA.sqlcode,0)
        INITIALIZE g_sgt.* TO NULL
    ELSE
        CALL i720_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i720_copy()
   DEFINE  l_newno         LIKE sgt_file.sgt01,
           l_oldno         LIKE sgt_file.sgt01,  
           l_newsgt02      LIKE sgt_file.sgt02,
           l_oldsgt02      LIKE sgt_file.sgt02,
           l_sfb103        LIKE sfb_file.sfb103,
           l_ecm03_par     LIKE ecm_file.ecm03_par,
           l_ima02         LIKE ima_file.ima02,
           l_n             LIKE type_file.num5,
           l_n1            LIKE type_file.num5,
           ef_date         LIKE type_file.dat,  
           ans_1           LIKE type_file.chr1, 
           ans_2,l_sdate   LIKE type_file.dat,  
           l_cnt           LIKE ecu_file.ecu02, 
           l_dir           LIKE type_file.chr1, 
           l_sql           STRING      #NO.FUN-910082 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_sgt.sgt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i720_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno  FROM sgt01
   
       AFTER FIELD sgt01
            IF NOT cl_null(l_newno) THEN
               CALL i720_sgt01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_newno,g_errno,0)
                  NEXT FIELD sgt01
               END IF
               CALL i720_sgt01_1('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_newno,g_errno,0)
                  NEXT FIELD sgt01
                END IF
               SELECT count(*) INTO l_n
                 FROM ecm_file,sfb_file
                WHERE sfb01 = ecm01
                  AND sfb87 = 'Y'
                  AND sfb04 != '8'
                  AND sfb01 = l_newno
                IF l_n = 0 THEN
                   CALL cl_err('','aec-070',0)  #MOD-C30626
                   NEXT FIELD sgt01
                END IF
                SELECT COUNT(*) INTO l_n1
                  FROM sgt_file
                 WHERE sgt01 = l_newno
                   AND sgt08 = 'N'
                 IF l_n1 > 0 THEN
                    CALL cl_err('','aec-106',0)
                    NEXT FIELD sgt01
                 END IF
                 SELECT sfb103 INTO l_sfb103
                   FROM sfb_file
                  WHERE sfb01 = l_newno
                  IF cl_null(l_sfb103) THEN LET l_sfb103=0 END IF    #No.FUN-870124
                  LET l_newsgt02 = l_sfb103 + 1
                  DISPLAY l_newsgt02 TO sgt02
            END IF
        
      
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgt01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecm8"
                   LET g_qryparam.default1 = l_newno
                   CALL cl_create_qry() RETURNING l_newno
                   DISPLAY l_newno TO sgt01       
                   NEXT FIELD sgt01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_sgt.sgt01
      DISPLAY BY NAME g_sgt.sgt02
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM sgt_file         #單頭複製
       WHERE sgt01=g_sgt.sgt01
         AND sgt02=g_sgt.sgt02
       INTO TEMP y
 
   UPDATE y
       SET sgt01=l_newno,    #新的鍵值
           sgt02=l_newsgt02,  #新的鍵值
           sgt07='N',         #No.FUN-870124
           sgt08='N',         #No.FUN-870124
           sgtuser=g_user,   #資料所有者
           sgtgrup=g_grup,   #資料所有者所屬群
           sgtmodu=NULL,     #資料修改日期
           sgtdate=g_today,  #資料建立日期
           sgtacti='Y'       #有效資料
 
   INSERT INTO sgt_file SELECT * FROM y
  
    IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sgt_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM sgu_file         #單身複製
       WHERE sgu01=g_sgt.sgt01
         AND sgu02=g_sgt.sgt02
       INTO TEMP x
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET sgu01=l_newno,
                sgu02=l_newsgt02
 
   INSERT INTO sgu_file
       SELECT * FROM x
   
  
    IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sgu_file","","",SQLCA.sqlcode,"","",1)    #FUN-B80046 ADD
      ROLLBACK WORK
   #  CALL cl_err3("ins","sgu_file","","",SQLCA.sqlcode,"","",1)    #FUN-B80046 
      RETURN
    ELSE
      COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_sgt.sgt01
   LET l_oldsgt02 = g_sgt.sgt02
   SELECT sgt_file.* INTO g_sgt.* FROM sgt_file WHERE sgt01 = l_newno AND sgt02=l_newsgt02    #No.FUN-9A0071
   CALL i720_u()
   CALL i720_b()
   #SELECT sgt_file.* INTO g_sgt.* FROM sgt_file WHERE sgt01 = l_oldno AND sgt02=l_oldsgt02     #No.FUN-9A0071 #FUN-C30027
   #CALL i720_show()  #FUN-C30027
 
END FUNCTION 
 
FUNCTION i720_fetch(p_flecu)
    DEFINE
        p_flecu         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    CASE p_flecu
        WHEN 'N' FETCH NEXT     i720_cs INTO g_sgt.sgt01,g_sgt.sgt02
        WHEN 'P' FETCH PREVIOUS i720_cs INTO g_sgt.sgt01,g_sgt.sgt02
        WHEN 'F' FETCH FIRST    i720_cs INTO g_sgt.sgt01,g_sgt.sgt02
        WHEN 'L' FETCH LAST     i720_cs INTO g_sgt.sgt01,g_sgt.sgt02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump i720_cs INTO g_sgt.sgt01,     #No.FUN-9A0071
                                                g_sgt.sgt02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgt.sgt01,SQLCA.sqlcode,0)
        INITIALIZE g_sgt.* TO NULL  
        RETURN
    ELSE
       CASE p_flecu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sgt.* FROM sgt_file       # 重讀DB,因TEMP有不被更新特性
       WHERE sgt01 = g_sgt.sgt01
         AND sgt02 = g_sgt.sgt02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","sgt_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1) 
    ELSE
        LET g_data_owner = g_sgt.sgtuser      #FUN-4C0034
        LET g_data_group = g_sgt.sgtgrup      #FUN-4C0034
        LET g_data_plant = g_sgt.sgtplant #FUN-980030
        CALL i720_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i720_show()
    LET g_sgt_t.* = g_sgt.*
    DISPLAY BY NAME g_sgt.sgtoriu,g_sgt.sgtorig,
        g_sgt.sgt01, g_sgt.sgt07, g_sgt.sgt05, g_sgt.sgt06,g_sgt.sgt02, g_sgt.sgt08, 
        g_sgt.sgt03, g_sgt.sgt04, g_sgt.sgtuser,g_sgt.sgtgrup,
        g_sgt.sgtmodu,g_sgt.sgtdate,g_sgt.sgtacti
 
    CALL i720_sgt01('d')
    CALL i720_sgt01_1('d')
    CALL i720_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i720_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sgt.sgt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_sgt.sgt07 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    IF g_sgt.sgtacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    BEGIN WORK
 
    OPEN i720_cl USING g_sgt.sgt01,g_sgt.sgt02    #No.FUN-9A0071
    IF STATUS THEN
       CALL cl_err("OPEN i720_cl:", STATUS, 1)
       CLOSE i720_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i720_cl INTO g_sgt.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
        CLOSE i720_cl ROLLBACK WORK RETURN
    END IF
 
    LET g_sgt01_t = g_sgt.sgt01
    LET g_sgt02_t = g_sgt.sgt02
    LET g_sgt_o.*=g_sgt.*
    LET g_sgt.sgtmodu = g_user
    LET g_sgt.sgtdate = g_today               #修改日期
    CALL i720_show()                          # 顯示最新資料
 
    WHILE TRUE
        CALL i720_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sgt.*=g_sgt_t.*
            CALL i720_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sgt_file SET sgt_file.* = g_sgt.*    # 更新DB
            WHERE sgt01 = g_sgt.sgt01
              AND sgt02 = g_sgt.sgt02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sgt_file",g_sgt01_t,g_sgt02_t,SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i720_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i720_r()
    DEFINE l_chr      LIKE type_file.chr1, 
           l_cnt      LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgt.sgt01)  THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF                                                                                                          
    IF g_sgt.sgt07 = 'Y' THEN                                                                                                       
       CALL cl_err('','mfg1005',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    BEGIN WORK
 
    OPEN i720_cl USING g_sgt.sgt01,g_sgt.sgt02    #No.FUN-9A0071
    IF STATUS THEN
       CALL cl_err("OPEN i720_cl:", STATUS, 1)
       CLOSE i720_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i720_cl INTO g_sgt.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock sgt:',SQLCA.sqlcode,0)
       CLOSE i720_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i720_show()
 
    IF cl_delh(15,21) THEN
        DELETE FROM sgt_file WHERE sgt01=g_sgt.sgt01 AND sgt02 = g_sgt.sgt02  #No.FUN-9A0071
        IF STATUS THEN 
        CALL cl_err3("del","sgt_file",g_sgt.sgt01,g_sgt.sgt02,STATUS,"","del sgt:",1)     
        RETURN END IF
 
        DELETE FROM sgu_file WHERE sgu01 = g_sgt.sgt01 AND sgu02 = g_sgt.sgt02 
        IF STATUS THEN 
           CALL cl_err3("del","sgu_file",g_sgt.sgt01,g_sgt.sgt02,STATUS,"","del sgu:",1)       
           RETURN
        END IF
        INITIALIZE g_sgt.* TO NULL
        CLEAR FORM
        CALL g_sgu.clear()
        OPEN i720_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i720_cs
           CLOSE i720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i720_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i720_cs
           CLOSE i720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i720_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i720_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i720_fetch('/')
        END IF
 
    END IF
    CLOSE i720_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i720_confirm()
DEFINE l_n    LIKE type_file.num5
    IF cl_null(g_sgt.sgt01) OR cl_null(g_sgt.sgt02) THEN      
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
#CHI-C30107 --------- add ----------- begin
    IF g_sgt.sgt07="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgt.sgtacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN RETURN END IF
    SELECT * INTO g_sgt.* FROM sgt_file WHERE sgt01 = g_sgt.sgt01
                                          AND sgt02 = g_sgt.sgt02
#CHI-C30107 --------- add ----------- end
    IF g_sgt.sgt07="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN                                                                                     
    END IF
    IF g_sgt.sgtacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1) 
       RETURN                                                                                    
    END IF  
    SELECT count(*) INTO l_n
      FROM sgt_file
     WHERE sgt01 = g_sgt.sgt01
       AND sgt02 != g_sgt.sgt02
       AND sgt08 = 'N'
     IF l_n > 0 THEN
        CALL cl_err('','aec-116',0)
        RETURN
     END IF
     #FUN-B90141 --START--
     IF NOT i720_chk_umf() THEN
        RETURN 
     END IF
     #FUN-B90141 --END-- 
    #FUN-B10056--begin--add----
    #資料確認前先進行製程段的檢查
    #檢查方法：1.將資料變更回ecm_file 2.調用aeci700"檢查製程段"的action 檢查製程段正確與否 3.不管是否正確將資料回滾(因為回寫ecm_file的動作應在變更發出時處理)
     IF g_sma.sma541 = 'Y' THEN
        BEGIN WORK
        LET g_success = 'Y'
        CALL i720_upd_ecm()
        IF g_success = 'Y' THEN
           CALL i700sub_chkbom(g_sgt.sgt01,'1')
           IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
        ELSE
           ROLLBACK WORK 
           RETURN
        END IF
        ROLLBACK WORK 
     END IF
    #FUN-B10056--end--add------
     
#   IF cl_confirm('aap-222') THEN       #CHI-C30107 mark
       BEGIN WORK                                                                                                              
       UPDATE sgt_file                                                                                                         
          SET sgt07="Y"                                                                                                       
        WHERE sgt01=g_sgt.sgt01
          AND sgt02=g_sgt.sgt02
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("upd","sgt_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","sgt07",1)                                            
            ROLLBACK WORK                                                                                                           
        ELSE                                                                                                                        
            COMMIT WORK                                                                                                             
            LET g_sgt.sgt07="Y"                                                                                                 
            DISPLAY BY NAME g_sgt.sgt07
        END IF
#   END IF           #CHI-C30107 mark
END FUNCTION
 
FUNCTION i720_notconfirm()
    IF cl_null(g_sgt.sgt01) OR cl_null(g_sgt.sgt02) THEN                                                                                                       
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF
    IF g_sgt.sgt07="N" OR g_sgt.sgtacti="N" THEN                                                                                  
        CALL cl_err("",'atm-365',1) 
        RETURN                                                                                                
    END IF
    IF g_sgt.sgt08='Y' THEN
       CALL cl_err('','aec-108',0)
       RETURN
    END IF
    IF cl_confirm('aap-224') THEN                                                                                                
       BEGIN WORK                                                                                                                 
       UPDATE sgt_file                                                                                                            
           SET sgt07="N"                                                                                                        
         WHERE sgt01=g_sgt.sgt01
           AND sgt02=g_sgt.sgt02
        IF SQLCA.sqlcode THEN                                                                                                         
          CALL cl_err3("upd","sgt_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","sgt07",1)                                               
          ROLLBACK WORK
        ELSE                                                                                                                          
          COMMIT WORK                                                                                                                
          LET g_sgt.sgt07="N"                                                                                                    
          DISPLAY BY NAME g_sgt.sgt07
        END IF
    END IF
END FUNCTION

FUNCTION  i720_sgt01(p_cmd)
DEFINE
    p_cmd              LIKE type_file.chr1,
    l_ecm03_par        LIKE ecm_file.ecm03_par,
    l_ecmacti          LIKE ecm_file.ecmacti
 
    LET g_errno = ' '
    SELECT DISTINCT ecm03_par INTO l_ecm03_par FROM ecm_file
     WHERE ecm01 = g_sgt.sgt01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-523'
                                   LET l_ecm03_par = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ecm03_par TO FORMONLY.sgt01_sfb05
    END IF
END FUNCTION
 
FUNCTION  i720_sgt01_1(p_cmd)
DEFINE
    p_cmd          LIKE type_file.chr1,
    l_ima02        LIKE ima_file.ima02,
    l_imaacti      LIKE ima_file.imaacti,
    l_ecm03_par    LIKE ecm_file.ecm03_par
 
    LET g_errno = ' '
    SELECT DISTINCT(ecm03_par) INTO l_ecm03_par
      FROM ecm_file
     WHERE ecm01 = g_sgt.sgt01
    SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
     WHERE ima01 = l_ecm03_par
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-523'
                                   LET l_ima02 = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.sgt01_sfb05_ima02      #TQC-970233
    END IF
 
END FUNCTION
 
FUNCTION i720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY #No.FUN-680073 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重復用    #No.FUN-680073 SMALLINT
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_n4            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否    #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態      #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否      #No.FUN-680073 SMALLINT
    l_max_ecm03     LIKE ecm_file.ecm03,
    l_allow_delete  LIKE type_file.num5          #可刪除否      #No.FUN-680073 SMALLINT
DEFINE  l_t         LIKE type_file.num5  #NO.FUN-A60080 
 
DEFINE l_ecd02      LIKE ecd_file.ecd02  #MOD-9B0182
DEFINE l_sfb05      LIKE sfb_file.sfb05,
       l_sfb06      LIKE sfb_file.sfb06,
       l_flag       LIKE type_file.chr21  #TQC-AC0093
DEFINE l_flag1      LIKE type_file.num5   #TQC-AC0374
DEFINE l_sum        LIKE ecm_file.ecm301  #FUN-B10056
DEFINE l_cnt        LIKE type_file.num5          #MOD-B30035 add
DEFINE l_sfb08      LIKE sfb_file.sfb08   #FUN-B30019
DEFINE l_err        STRING    #MOD-C80002
DEFINE l_next_ecm03  LIKE ecm_file.ecm03   #CHI-C70022
DEFINE l_next_ecm012 LIKE ecm_file.ecm012  #CHI-C70022

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgt.sgt01) THEN RETURN END IF
    IF cl_null(g_sgt.sgt02) THEN RETURN END IF
    IF g_sgt.sgt07='Y' THEN RETURN END IF   
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT sgu012,sgu014,sgu04,sgu03,sgu015,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13,",  #NO.FUN-A60080  add sgu012 #FUN-B10056
    #   "       sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,'',",      #FUN-B30019
        "       sgu14,sgu53,sgu15,sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45,sgu46,",   #FUN-B30019   #FUN-B50178 add sgu53
        "       sgu47,sgu22,sgu23,'',",                  #FUN-B30019
        "       '','','',sgu016,sgu24,sgu25,sgu26,sgu27,",  #FUN-B10056
    #   "       sgu29,sgu30,sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,",    #FUN-B30019
    #   "       sgu39,sgu40,sgu41,sgu42,'','','','' ",                            #FUN-B30019     
        "       sgu29,sgu30,sgu31,sgu32,sgu33,sgu54,sgu34,sgu35,sgu36,sgu37,",    #FUN-B30019  #FUN-B50178 add sgu54
        "       sgu39,sgu48,sgu49,sgu50,sgu51,sgu52,sgu41,sgu42,'','','','' ",    #FUN-B30019
        " FROM sgu_file ",
        "WHERE sgu01= ? AND sgu02= ? AND sgu04= ? AND sgu012= ? FOR UPDATE "  #NO.FUN-A60080  add sgu012
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sgu WITHOUT DEFAULTS FROM s_sgu.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i720_cl USING g_sgt.sgt01,g_sgt.sgt02    #No.FUN-9A0071
            IF STATUS THEN
               CALL cl_err("OPEN i720_cl_b:", STATUS, 1)
               CLOSE i720_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i720_cl INTO g_sgt.*               # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock sgt:',SQLCA.sqlcode,0)
                  CLOSE i720_cl ROLLBACK WORK RETURN              
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
 
                LET p_cmd='u'
                LET g_sgu_t.* = g_sgu[l_ac].*  #BACKUP
                LET g_sgu39_t = g_sgu[l_ac].sgu39  #FUN-BB0085
 
                OPEN i720_bcl USING g_sgt.sgt01,g_sgt.sgt02,g_sgu_t.sgu04,g_sgu_t.sgu012  #NO.FUN-A60080  add sgu012
                IF STATUS THEN
                   CALL cl_err("OPEN i720_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i720_bcl INTO g_sgu[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgu_t.sgu04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y" 
                   #FUN-B20078--begin--add----
                   ELSE
                     CALL cl_set_comp_entry("sgu014",TRUE)
                     LET l_t = 0
                     SELECT COUNT(*) INTO l_t FROM ecm_file WHERE ecm01=g_sgt.sgt01 AND ecm012=g_sgu[l_ac].sgu012
                     IF l_t > 0 THEN
                        CALL cl_set_comp_entry("sgu014",FALSE)
                     END IF
                     CALL i720_set_required()     #FUN-B30019
                     CALL i720_set_no_required()  #FUN-B30019
                    #FUN-B20078--end--add------
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
               #TQC-AC0093 ------add start-----------
                IF g_sma.sma541 = 'Y' THEN
                   NEXT FIELD sgu012
                ELSE
                   NEXT FIELD sgu04
              #TQC-AC0093 ------add end--------------
               END IF                     #TQC-AC0093
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgu[l_ac].* TO NULL      
            LET g_sgu_t.* = g_sgu[l_ac].*         #新輸入資料
            LET g_sgu39_t = NULL                  #FUN-BB0085
           #NO.FUN-A60080--begin
            IF g_sma.sma541='N' THEN 
               LET g_sgu[l_ac].sgu012=' '
            END IF 
           #NO.FUN-A60080--end
            CALL cl_show_fld_cont()     
           #TQC-AC0093 ------add start-----------
            IF g_sma.sma541 = 'Y' THEN
               NEXT FIELD sgu012
            ELSE
           #TQC-AC0093 ------add end--------------
               NEXT FIELD sgu04
            END IF                     #TQC-AC0093
   
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sgu[l_ac].sgu016 IS NULL THEN LET g_sgu[l_ac].sgu016=' ' END IF  #FUN-B10056
            INSERT INTO sgu_file(sgu01,sgu02,sgu04,sgu012,sgu03,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13,   #NO.FUN-A60080  add sgu012
                               # sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,      #FUN-B30019
                                 sgu14,sgu15,sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45,sgu46,      #FUN-B30019
                                 sgu47,sgu22,sgu23,                  #FUN-B30019 
                                 sgu24,sgu25,sgu26,sgu27,sgu29,
                               # sgu30,sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,   #FUN-B30019
                               # sgu40,sgu41,sgu42,sgu014,sgu015,sgu016,  #FUN-B10056           #FUN-B30019 
                                 sgu30,sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu39,         #FUN-B30019 
                                 sgu48,sgu49,sgu50,sgu51,sgu52,   #FUN-B30019
                                 sgu53,sgu54,           #FUN-B50178
                                 sgu41,sgu42,sgu014,sgu015,sgu016,                              #FUN-B30019
                                 sguplant,sgulegal) #FUN-980002
                          VALUES(g_sgt.sgt01,g_sgt.sgt02,g_sgu[l_ac].sgu04,g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu03,g_sgu[l_ac].sgu05,   #NO.FUN-A60080  add sgu012
                                 g_sgu[l_ac].sgu06,g_sgu[l_ac].sgu07,g_sgu[l_ac].sgu08,g_sgu[l_ac].sgu10,
                                 g_sgu[l_ac].sgu11,g_sgu[l_ac].sgu12,g_sgu[l_ac].sgu13,g_sgu[l_ac].sgu14,
                                 g_sgu[l_ac].sgu15,g_sgu[l_ac].sgu16,g_sgu[l_ac].sgu17,g_sgu[l_ac].sgu18,
                               # g_sgu[l_ac].sgu19,g_sgu[l_ac].sgu20,g_sgu[l_ac].sgu21,g_sgu[l_ac].sgu22,     #FUN-B30019
                                 g_sgu[l_ac].sgu20,g_sgu[l_ac].sgu43,g_sgu[l_ac].sgu44,g_sgu[l_ac].sgu45,     #FUN-B30019  
                                 g_sgu[l_ac].sgu46,g_sgu[l_ac].sgu47,g_sgu[l_ac].sgu22,                       #FUN-B30019   
                                 g_sgu[l_ac].sgu23,g_sgu[l_ac].sgu24,g_sgu[l_ac].sgu25,g_sgu[l_ac].sgu26,
                                 g_sgu[l_ac].sgu27,g_sgu[l_ac].sgu29,g_sgu[l_ac].sgu30,g_sgu[l_ac].sgu31,
                                 g_sgu[l_ac].sgu32,g_sgu[l_ac].sgu33,g_sgu[l_ac].sgu34,g_sgu[l_ac].sgu35,
                               # g_sgu[l_ac].sgu36,g_sgu[l_ac].sgu37,g_sgu[l_ac].sgu38,g_sgu[l_ac].sgu39,    #FUN-B30019
                               # g_sgu[l_ac].sgu40,g_sgu[l_ac].sgu41,g_sgu[l_ac].sgu42,                      #FUN-B30019
                                 g_sgu[l_ac].sgu36,g_sgu[l_ac].sgu37,g_sgu[l_ac].sgu39,                      #FUN-B30019 
                                 g_sgu[l_ac].sgu48,g_sgu[l_ac].sgu49,g_sgu[l_ac].sgu50, #FUN-B30019
                                 g_sgu[l_ac].sgu51,g_sgu[l_ac].sgu52,   #FUN-B30019
                                 g_sgu[l_ac].sgu53,g_sgu[l_ac].sgu54,   #FUN-B50178
                                 g_sgu[l_ac].sgu41,g_sgu[l_ac].sgu42,            #FUN-B30019
                                 g_sgu[l_ac].sgu014,g_sgu[l_ac].sgu015,g_sgu[l_ac].sgu016,  #FUN-B10056
                                 g_plant,g_legal     #FUN-980002
                                 )
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sgu_file",g_sgt.sgt01,g_sgt.sgt02,STATUS,"","ins sgu:",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
          BEFORE FIELD sgu012                     #FUN-B20078
            CALL cl_set_comp_entry("sgu014",TRUE) #FUN-B20078
  
          #NO.FUN-A60080--begin
          AFTER FIELD sgu012
            IF NOT cl_null(g_sgu[l_ac].sgu012) THEN 
              #TQC-AC0093 ---------------mod start---------
              #FUN-B10056--begin--mark---
              # SELECT sfb06 INTO l_sfb06 FROM sfb_file  #TQC-AC0347
              #  WHERE sfb01 = g_sgt.sgt01
              # CALL s_schdat_sel_ima571(g_sgt.sgt01) RETURNING l_flag1,l_sfb05  #TQC-AC0347
              # IF NOT cl_null(l_sfb05) AND NOT cl_null(l_sfb06) THEN
              #    SELECT count(*) INTO l_t FROM ecu_file
              #     WHERE ecu01 = l_sfb05 
              #       AND ecu02 = l_sfb06  
              #       AND ecu012 = g_sgu[l_ac].sgu012
              #    IF l_t = 0 THEN
              #       CALL cl_err('','abm-214',1)
              #       NEXT FIELD sgu012
              #    END IF
              # END IF 
              #FUN-B10056--emd--mark-----
              #FUN-B20078--begin--add----
               LET l_t = 0 
               SELECT COUNT(*) INTO l_t FROM ecr_file
                WHERE ecr01=g_sgu[l_ac].sgu012 AND ecracti='Y'
               IF l_t = 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu012,'abm-214',1)
                  NEXT FIELD sgu012
               END IF
               LET l_t = 0 
               SELECT COUNT(*) INTO l_t FROM ecm_file WHERE ecm01=g_sgt.sgt01 AND ecm012=g_sgu[l_ac].sgu012
               IF l_t > 0 THEN
                  LET g_sgu[l_ac].sgu014=''
                  CALL cl_set_comp_entry("sgu014",FALSE)
                  DECLARE ecm014_cs CURSOR FOR
                    SELECT DISTINCT ecm014 FROM ecm_file WHERE ecm01=g_sgt.sgt01 AND ecm012=g_sgu[l_ac].sgu012
                  FOREACH ecm014_cs INTO g_sgu[l_ac].sgu014
                    EXIT FOREACH
                  END FOREACH
               ELSE
                 IF cl_null(g_sgu[l_ac].sgu014) THEN
                    SELECT ecr02 INTO g_sgu[l_ac].sgu014 FROM ecr_file WHERE ecr01=g_sgu[l_ac].sgu012
                 END IF
               END IF
              #FUN-B20078--end--add------
               IF g_sgu[l_ac].sgu04 IS NOT NULL THEN
                  CALL cl_set_comp_entry("sgu03",TRUE)
                  CALL i720_sgu012_check(g_sgt.sgt01,g_sgu[l_ac].sgu04,g_sgu[l_ac].sgu012) RETURNING l_flag
                  IF l_flag = FALSE THEN
                     NEXT FIELD sgu012
                  END IF
               END IF 
              #SELECT count(*) INTO l_t FROM ecm_file
              # WHERE ecm01 = g_sgt.sgt01
              #   AND ecm03 = g_sgu[l_ac].sgu04 
              #IF l_t=0 THEN 
              #   CALL cl_err('','abm-214',1)
              #   NEXT FIELD sgu012
              #END IF 
              #TQC-AC0093 ---------------mod  start---------
              IF NOT i720_check_sgu04() THEN NEXT FIELD sgu04 END IF          #MOD-C80002 add 
            END IF 
          #NO.FUN-A60080--end
          
          AFTER FIELD sgu04
            CALL cl_set_comp_entry("sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30,sgu31,sgu32,sgu33,                                #    sgu34,sgu35,sgu36,sgu37,sgu38,sgu39.sgu41,sgu42,                                                 sgu34,sgu35,sgu36,sgu37,sgu39,sgu41,sgu42,                                                      sgu48,sgu49,sgu50,sgu51,sgu52,sgu54",TRUE)    #FUN-B30019  #FUN-B50178 add sgu54
            IF NOT cl_null(g_sgu[l_ac].sgu04) THEN
               #CHI-C70022---begin
               CALL s_schdat_next_ecm03(g_sgt.sgt01,g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04) RETURNING l_next_ecm012,l_next_ecm03
               SELECT count(*) INTO l_n
                 FROM shb_file
                WHERE shb05 = g_sgt.sgt01
                  AND shb06 = l_next_ecm03
                  AND shb012= l_next_ecm012
               #str----add by guanyao160811 20160811 0:03分 海洋要求禁掉
               #IF l_n > 0 THEN
               #   CALL cl_err('','aec-129',0)
               #   NEXT FIELD sgu04
               #END IF 
               #end----add by guanyao160811
               #CHI-C70022---end
               CALL cl_set_comp_entry("sgu03",TRUE)
              #TQC-AC0093 --------add start-----
               IF g_sgu[l_ac].sgu012 IS NOT NULL THEN
                  CALL i720_sgu012_check(g_sgt.sgt01,g_sgu[l_ac].sgu04,g_sgu[l_ac].sgu012) RETURNING l_flag
                  IF l_flag = FALSE THEN
                     NEXT FIELD sgu04
                  END IF 
               END IF  
            END IF
            IF g_sma.sma541 = 'N' THEN LET g_sgu[l_ac].sgu012 = ' ' END IF  #MOD-C80002 add 
            IF NOT i720_check_sgu04() THEN NEXT FIELD sgu04 END IF          #MOD-C80002 add 
              #TQC-AC0093 --------add end---------   
#TQC-AC0093 ------------------------mark start---------------------------------------------------------
#                 SELECT count(*) INTO l_n FROM ecm_file
#                  WHERE ecm01 = g_sgt.sgt01
#                    AND ecm03 = g_sgu[l_ac].sgu04
#                    AND ecm012= g_sgu[l_ac].sgu012   
#                 IF l_n = 0 THEN
#                    SELECT max(ecm03) INTO l_max_ecm03
#                      FROM ecm_file
#                     WHERE ecm01 = g_sgt.sgt01
#                       AND ecm012= g_sgu[l_ac].sgu012
#                       AND ecm03 < g_sgu[l_ac].sgu04  
#                    SELECT count(*) INTO l_n1
#                      FROM shb_file
#                     WHERE shb05 = g_sgt.sgt01
#                       AND shb06 = l_max_ecm03
#                       AND shb012= g_sgu[l_ac].sgu012 
#                    IF l_n1 > 0 THEN
#                       CALL cl_err('','aec-117',0)
#                       NEXT FIELD sgu04
#                    ELSE
#                       LET g_sgu[l_ac].sgu03 = '1'
#                       CALL cl_set_comp_entry("sgu03",FALSE)
#                       LET g_sgu[l_ac].sgu05 = " "
#                       LET g_sgu[l_ac].sgu06 = " "
#                       LET g_sgu[l_ac].sgu07 = " "
#                       LET g_sgu[l_ac].sgu08 = " "
#                       LET g_sgu[l_ac].sgu10 = " "
#                       LET g_sgu[l_ac].sgu11 = " "
#                       LET g_sgu[l_ac].sgu12 = " "
#                       LET g_sgu[l_ac].sgu13 = " "
#                       LET g_sgu[l_ac].sgu14 = " "
#                       LET g_sgu[l_ac].sgu15 = " "
#                       LET g_sgu[l_ac].sgu16 = " "
#                       LET g_sgu[l_ac].sgu17 = " "
#                       LET g_sgu[l_ac].sgu18 = " "
#                       LET g_sgu[l_ac].sgu19 = " "
#                       LET g_sgu[l_ac].sgu20 = " "
#                       LET g_sgu[l_ac].sgu21 = " "
#                       LET g_sgu[l_ac].sgu14 = " "
#                       LET g_sgu[l_ac].sgu15 = " "
#                       LET g_sgu[l_ac].sgu16 = " "
#                       LET g_sgu[l_ac].sgu17 = " "
#                       LET g_sgu[l_ac].sgu18 = " "
#                       LET g_sgu[l_ac].sgu19 = " "
#                       LET g_sgu[l_ac].sgu20 = " "
#                       LET g_sgu[l_ac].sgu21 = " "
#                       LET g_sgu[l_ac].sgu22 = " "
#                       LET g_sgu[l_ac].sgu23 = " "
#&ifdef SLK
#                       LET g_sgu[l_ac].sguislk01 = " "
#                       LET g_sgu[l_ac].sguislk02 = " "
#                       LET g_sgu[l_ac].sguislk03 = " "
#                       LET g_sgu[l_ac].sguislk04 = " "
#                       IF g_sgu_t.sgu04 IS NULL THEN
#                       LET g_sgu[l_ac].sguislk06 = 0
#                       LET g_sgu[l_ac].sguislk07 = 0
#                       LET g_sgu[l_ac].sguislk08 = 0
#                       END IF
#&endif
#                       IF g_sgu_t.sgu04 IS NULL THEN
#                       LET g_sgu[l_ac].sgu33 = 'N'
#                       LET g_sgu[l_ac].sgu34 = 'N'
#                       LET g_sgu[l_ac].sgu35 = 'N'
#                       LET g_sgu[l_ac].sgu27 = 0
#                       LET g_sgu[l_ac].sgu29 = 0
#                       LET g_sgu[l_ac].sgu30 = 0
#                       LET g_sgu[l_ac].sgu31 = 0
#                       LET g_sgu[l_ac].sgu32 = 0
#                       END IF
#                    END IF
#                 ELSE                   
#                    SELECT count(*) INTO l_n2
#                      FROM sgx_file
#                     WHERE sgx01 = g_sgt.sgt01
#                       AND sgx02 = g_sgu[l_ac].sgu04
#                       AND sgx09 = 'N'
#                    IF l_n1 > 0 THEN
#                       CALL cl_err('','aec-105',0)
#                       NEXT FIELD sgu04
#                    END IF
#                    IF s_industry('slk') THEN
#                       SELECT count(*) INTO l_n3 
#                         FROM sgl_file,sgk_file
#                        WHERE sgl04 = g_sgt.sgt01
#                          AND sgl06 = g_sgu[l_ac].sgu04
#                          AND sgl01 = sgk01
#                          AND sgkacti = 'Y'
#                          AND (sgl08 > 0 OR sgl09 > 0)
#                        IF l_n3 > 0 THEN
#                           CALL cl_err('','aec-118',0)
#                           NEXT FIELD sgu04
#                        END IF
#                    END IF
#                    SELECT count(*) INTO l_n4
#                      FROM shb_file
#                     WHERE shb05 = g_sgt.sgt01
#                       AND shb06 = g_sgu[l_ac].sgu04
#                       AND shbacti = 'Y'
#                     IF l_n4 > 0 THEN
#                        CALL cl_err('','aec-119',0)
#                        NEXT FIELD sgu04
#                     ELSE
#                       SELECT ecm04,ecm06,ecm05,ecm49,ecm14,ecm13,ecm16,ecm15,
#                              ecm52,ecm53,ecm54,ecm55,ecm56,ecm57,ecm58,ecm59,
#                              ecm50,ecm51
#&ifdef SLK
#                               ,ecmslk01,ecmslk02,ecmslk03,ecmslk04
#&endif
#                         INTO g_sgu[l_ac].sgu05,g_sgu[l_ac].sgu06,g_sgu[l_ac].sgu07,
#                              g_sgu[l_ac].sgu08,g_sgu[l_ac].sgu10,g_sgu[l_ac].sgu11,
#                              g_sgu[l_ac].sgu12,g_sgu[l_ac].sgu13,g_sgu[l_ac].sgu14,
#                              g_sgu[l_ac].sgu15,g_sgu[l_ac].sgu16,g_sgu[l_ac].sgu17,
#                              g_sgu[l_ac].sgu18,g_sgu[l_ac].sgu19,g_sgu[l_ac].sgu20,
#                              g_sgu[l_ac].sgu21,g_sgu[l_ac].sgu22,g_sgu[l_ac].sgu23 
#&ifdef SLK
#                             ,g_sgu[l_ac].sguislk01,g_sgu[l_ac].sguislk02,
#                              g_sgu[l_ac].sguislk03,g_sgu[l_ac].sguislk04
#&endif
#                         FROM ecm_file
#                        WHERE ecm01 = g_sgt.sgt01
#                          AND ecm03 = g_sgu[l_ac].sgu04
#                          AND ecm012= g_sgu[l_ac].sgu012
#                       DISPLAY BY NAME g_sgu[l_ac].sgu05
#                       DISPLAY BY NAME g_sgu[l_ac].sgu06
#                       DISPLAY BY NAME g_sgu[l_ac].sgu07
#                       DISPLAY BY NAME g_sgu[l_ac].sgu08
#                       DISPLAY BY NAME g_sgu[l_ac].sgu10
#                       DISPLAY BY NAME g_sgu[l_ac].sgu11
#                       DISPLAY BY NAME g_sgu[l_ac].sgu12
#                       DISPLAY BY NAME g_sgu[l_ac].sgu13
#                       DISPLAY BY NAME g_sgu[l_ac].sgu14
#                       DISPLAY BY NAME g_sgu[l_ac].sgu15
#                       DISPLAY BY NAME g_sgu[l_ac].sgu16
#                       DISPLAY BY NAME g_sgu[l_ac].sgu17
#                       DISPLAY BY NAME g_sgu[l_ac].sgu18
#                       DISPLAY BY NAME g_sgu[l_ac].sgu19
#                       DISPLAY BY NAME g_sgu[l_ac].sgu20
#                       DISPLAY BY NAME g_sgu[l_ac].sgu21
#                       DISPLAY BY NAME g_sgu[l_ac].sgu22
#                       DISPLAY BY NAME g_sgu[l_ac].sgu23
#&ifdef SLK
#                       DISPLAY BY NAME g_sgu[l_ac].sguislk01
#                       DISPLAY BY NAME g_sgu[l_ac].sguislk02
#                       DISPLAY BY NAME g_sgu[l_ac].sguislk03
#                       DISPLAY BY NAME g_sgu[l_ac].sguislk04
#                       IF g_sgu_t.sgu04 IS NULL THEN
#                       LET g_sgu[l_ac].sguislk06 = NULL
#                       LET g_sgu[l_ac].sguislk07 = NULL
#                       LET g_sgu[l_ac].sguislk08 = NULL
#                       END IF
#&endif
#                       IF g_sgu_t.sgu04 IS NULL THEN
#                       LET g_sgu[l_ac].sgu33 = NULL
#                       LET g_sgu[l_ac].sgu34 = NULL
#                       LET g_sgu[l_ac].sgu35 = NULL
#                       LET g_sgu[l_ac].sgu27 = NULL
#                       LET g_sgu[l_ac].sgu29 = NULL
#                       LET g_sgu[l_ac].sgu30 = NULL
#                       LET g_sgu[l_ac].sgu31 = NULL
#                       LET g_sgu[l_ac].sgu32 = NULL
#                       END IF
#                       IF g_sgu[l_ac].sgu03 IS NULL OR g_sgu[l_ac].sgu03 = '1' THEN
#                          LET g_sgu[l_ac].sgu03 = '3'
#                       END IF
#                     END IF
#                 END IF
#           END IF
#TQC-AC0093 --------------------------------------mark end---------------------------------------------     

       BEFORE FIELD sgu03
        CALL i720_set_sgu03()
        CALL i720_set_required()  #FUN-B30019

        
       AFTER FIELD sgu03
        CALL i720_set_sgu03a()
        IF g_sgu[l_ac].sgu03 = '2' THEN
           CALL cl_set_comp_entry("sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30,sgu31,sgu32,sgu33,                                   sgu34,sgu35,sgu36,sgu37,sgu39,sgu41,sgu42,                                                     sgu48,sgu49,sgu50,sgu51,sgu52,sgu54",FALSE)  #FUN-B30019   #FUN-B50178
         END IF
         IF g_sgu[l_ac].sgu03 = '1' OR g_sgu[l_ac].sgu03 = '3' THEN
            CALL cl_set_comp_entry("sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30,sgu31,sgu32,sgu33,                                    sgu34,sgu35,sgu36,sgu37,sgu39,sgu41,sgu42,                                                      sgu48,sgu49,sgu50,sgu51,sgu52,sgu54",TRUE)  #FUN-B30019  #FUN-B50178
        END IF
        CALL i720_set_no_required()  #FUN-B30019
       IF g_sgu[l_ac].sgu03 != g_sgu_t.sgu03 OR g_sgu_t.sgu03 IS NULL THEN
          IF g_sgu[l_ac].sgu03 = '2' THEN
           LET g_sgu[l_ac].sgu24 = " "
           LET g_sgu[l_ac].sgu25 = " "
           LET g_sgu[l_ac].sgu26 = " "
           LET g_sgu[l_ac].sgu27 = " "
           LET g_sgu[l_ac].sgu29 = " "
           LET g_sgu[l_ac].sgu30 = " "
           LET g_sgu[l_ac].sgu31 = " "
           LET g_sgu[l_ac].sgu32 = " "
           LET g_sgu[l_ac].sgu33 = " "
           LET g_sgu[l_ac].sgu34 = " "
           LET g_sgu[l_ac].sgu35 = " "
           LET g_sgu[l_ac].sgu36 = " "
           LET g_sgu[l_ac].sgu37 = " "
        #  LET g_sgu[l_ac].sgu38 = " "  #FUN-B30019
           LET g_sgu[l_ac].sgu39 = " "
        #  LET g_sgu[l_ac].sgu40 = " "  #FUN-B30019
           LET g_sgu[l_ac].sgu41 = " "
           LET g_sgu[l_ac].sgu42 = " " 
           LET g_sgu[l_ac].sgu016= " "  #FUN-B10056
           LET g_sgu[l_ac].sgu48= " "  #FUN-B30019
           LET g_sgu[l_ac].sgu49= " "  #FUN-B30019
           LET g_sgu[l_ac].sgu50= " "  #FUN-B30019
           LET g_sgu[l_ac].sgu51= " "  #FUN-B30019
           LET g_sgu[l_ac].sgu52= " "  #FUN-B30019
           LET g_sgu[l_ac].sgu54= " "  #FUN-B50178
            
         END IF
         IF g_sma.sma541 = 'N' THEN LET g_sgu[l_ac].sgu012 = ' ' END IF  #MOD-C80002 add 
         IF NOT i720_check_sgu04() THEN NEXT FIELD sgu04 END IF          #MOD-C80002 add 
        END IF 
        
        #FUN-B10056--begin--add---
        AFTER FIELD sgu016
          IF NOT cl_null(g_sgu[l_ac].sgu016) THEN
             IF g_sgu[l_ac].sgu016=g_sgu[l_ac].sgu012 THEN NEXT FIELD sgu016 END IF
             LET l_t = 0
             SELECT COUNT(*) INTO l_t FROM ecr_file WHERE ecr01=g_sgu[l_ac].sgu016 AND ecracti='Y'  #FUN-B20078
             IF l_n = 0 THEN
                CALL cl_err('','abm-214',1) NEXT FIELD sgu016
             END IF
             SELECT SUM(ecm301) INTO l_sum FROM ecm_file
              WHERE ecm01=g_sgt.sgt01 AND ecm012=g_sgu[l_ac].sgu016
             IF l_sum > 0 THEN
                CALL cl_err('','aec-081',1)
                NEXT FIELD sgu016
             END IF
          END IF
        #FUN-B10056--end--add-----
        
        AFTER FIELD sgu24
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu24 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu24
               END IF
            END IF
           #MOD-B30035---add---start---
            IF NOT cl_null(g_sgu[l_ac].sgu24) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ecd_file
                WHERE ecd01 = g_sgu[l_ac].sgu24
               IF l_cnt = 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu24,'mfg4009',0)
                  NEXT FIELD sgu24
               END IF
            END IF
           #MOD-B30035---add---end---
 
        AFTER FIELD sgu25
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu25 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu25
               END IF
            END IF
           #MOD-B30035---add---start---
            IF NOT cl_null(g_sgu[l_ac].sgu25) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM eca_file
                WHERE eca01 = g_sgu[l_ac].sgu25
               IF l_cnt = 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu25,'mfg4011',0)
                  NEXT FIELD sgu25
               END IF
            END IF
           #MOD-B30035---add---end---
 
        AFTER FIELD sgu26
            IF NOT cl_null(g_sgu[l_ac].sgu26) THEN
               SELECT eci01 INTO l_eci01 FROM eci_file
                WHERE eci01 =  g_sgu[l_ac].sgu26
               IF STATUS THEN
                  CALL cl_err3("sel","eci_file",g_sgu[l_ac].sgu26,"","aec-011","","",1) #FUN-660091
                  NEXT FIELD sgu26
               END IF
            END IF
 
        AFTER FIELD sgu27
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu27 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu27
               END IF
            END IF
            IF NOT cl_null(g_sgu[l_ac].sgu27) THEN
               IF g_sgu[l_ac].sgu27 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu27,'aec-992',0)     
                  NEXT FIELD sgu27
               END IF
            END IF
 
        AFTER FIELD sgu29
            IF NOT cl_null(g_sgu[l_ac].sgu29) THEN
               IF g_sgu[l_ac].sgu29 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu29,'aec-992',0)
                  NEXT FIELD sgu29
               END IF
            END IF
 
        AFTER FIELD sgu30
            IF NOT cl_null(g_sgu[l_ac].sgu30) THEN
               IF g_sgu[l_ac].sgu30 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu30,'aec-992',0)
                  NEXT FIELD sgu30
               END IF
            END IF
 
        AFTER FIELD sgu31
            IF NOT cl_null(g_sgu[l_ac].sgu31) THEN
               IF g_sgu[l_ac].sgu31 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu31,'aec-992',0)
                  NEXT FIELD sgu31
               END IF
            END IF
 
        AFTER FIELD sgu32
            IF NOT cl_null(g_sgu[l_ac].sgu32) THEN
               IF g_sgu[l_ac].sgu32 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu32,'aec-992',0)
                  NEXT FIELD sgu32
               END IF
            END IF
 
        AFTER FIELD sgu33
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu33 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu33
               END IF
            END IF
            IF NOT cl_null(g_sgu[l_ac].sgu33) THEN
               IF g_sgu[l_ac].sgu33 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgu33
               END IF
            END IF
 
        AFTER FIELD sgu34
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu34 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu34
               END IF
            END IF
            IF NOT cl_null(g_sgu[l_ac].sgu34) THEN
               IF g_sgu[l_ac].sgu34 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgu34
               END IF
            END IF
 
        BEFORE FIELD sgu35
            CALL i720_set_entry_b(p_cmd)
 
        AFTER FIELD sgu35
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu35 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu35
               END IF
            END IF
            IF NOT cl_null(g_sgu[l_ac].sgu35) THEN
               IF g_sgu[l_ac].sgu35 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgu35
               END IF
               IF g_sgu[l_ac].sgu35 ='N' THEN
                  LET g_sgu[l_ac].sgu36 = ' '
                  DISPLAY BY NAME g_sgu[l_ac].sgu36
               END IF
 
               CALL i720_set_no_entry_b(p_cmd)
 
            END IF
            
 
        AFTER FIELD sgu36
            IF NOT cl_null(g_sgu[l_ac].sgu36) THEN
               CALL i720_sgg(g_sgu[l_ac].sgu36)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgu[l_ac].sgu36=g_sgu_t.sgu36
                  DISPLAY BY NAME g_sgu[l_ac].sgu36
                  NEXT FIELD sgu36
               END IF
            END IF
 
        AFTER FIELD sgu37
            IF NOT cl_null(g_sgu[l_ac].sgu37) THEN
               CALL i720_sgg(g_sgu[l_ac].sgu37)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgu[l_ac].sgu37=g_sgu_t.sgu37
                  DISPLAY BY NAME g_sgu[l_ac].sgu37
                  NEXT FIELD sgu37
               END IF
            END IF
 
#FUN-B30019--begin--mark--------
#       AFTER FIELD sgu38
#          IF NOT cl_null(g_sgu[l_ac].sgu38) THEN
#              SELECT COUNT(*) INTO g_cnt FROM gfe_file
#               WHERE gfe01=g_sgu[l_ac].sgu38
#              IF g_cnt=0 THEN
#                 CALL cl_err(g_sgu[l_ac].sgu38,'mfg2605',0)
#                 NEXT FIELD sgu38
#              END IF
#           END IF    
#           IF g_sgu[l_ac].sgu03 = '1' THEN
#              IF g_sgu[l_ac].sgu38 IS NULL THEN
#                 CALL cl_err('','agl-154',0)
#                 NEXT FIELD sgu38
#              END IF
#           END IF     #No.FUN-870124 mark  #MOD-A60094 mark回復
#           IF g_sgu[l_ac].sgu03 = '1' OR g_sgu[l_ac].sgu03 = '3' THEN   #MOD-A60094 add
#              IF NOT cl_null(g_sgu[l_ac].sgu38) THEN  #TQC-970238 
#                 IF NOT cl_null(g_sgu[l_ac].sgu39) THEN  #TQC-970238
#                    IF g_sgu[l_ac].sgu38 = g_sgu[l_ac].sgu39 THEN
#                       LET g_sgu[l_ac].sgu40=1
#                    ELSE
#                       CALL s_umfchk(g_sgt.sgt01,g_sgu[l_ac].sgu39,g_sgu[l_ac].sgu38)
#                            RETURNING g_sw,g_sgu[l_ac].sgu40
#                       IF g_sw = '1' THEN
#                          CALL cl_err(g_sgu[l_ac].sgu39,'mfg1206',0)
#                          NEXT FIELD sgu39
#                       END IF
#                    END IF
#                 END IF
#                 DISPLAY BY NAME g_sgu[l_ac].sgu40
#              END IF
#           END IF   #No.FUN-870124 
#FUN-B30019--end--mark--------
 
        AFTER FIELD sgu39
            IF NOT cl_null(g_sgu[l_ac].sgu39) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_sgu[l_ac].sgu39
               IF g_cnt=0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu39,'mfg2605',0)
                  NEXT FIELD sgu39
               END IF  
            END IF    
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu39 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu39
               END IF
            END IF     #No.FUN-870124   #MOD-A60094 mark回復
            #FUN-BB0085--add-str---
            IF NOT i720_sgu50_check() THEN
               LET g_sgu39_t = g_sgu[l_ac].sgu39
               NEXT FIELD sgu50
            END IF  
            LET g_sgu39_t = g_sgu[l_ac].sgu39
            #FUN-BB0085--add-end---

#FUN-B30019--begin--mark-----
#           IF g_sgu[l_ac].sgu03 = '1' OR g_sgu[l_ac].sgu03 = '3' THEN   #MOD-A60094 add
#              IF NOT cl_null(g_sgu[l_ac].sgu39) THEN
#                 IF g_sgu[l_ac].sgu38 = g_sgu[l_ac].sgu39 THEN
#                    LET g_sgu[l_ac].sgu40=1
#                 ELSE
#                    CALL s_umfchk(g_sgt.sgt01,g_sgu[l_ac].sgu39,g_sgu[l_ac].sgu38)
#                         RETURNING g_sw,g_sgu[l_ac].sgu40
#                    IF g_sw = '1' THEN
#                       CALL cl_err(g_sgu[l_ac].sgu39,'mfg1206',0)
#                       NEXT FIELD sgu39
#                    END IF
#                 END IF
#                 DISPLAY BY NAME g_sgu[l_ac].sgu40
#              END IF
#           END IF     #No.FUN-870124
#FUN-B30019--end--mark----------------
        
        AFTER FIELD sgu41
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu41 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu41
               END IF
            END IF
                
        AFTER FIELD sgu42
            IF g_sgu[l_ac].sgu03 = '1' THEN
               IF g_sgu[l_ac].sgu42 IS NULL THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD sgu42
               END IF
            END IF
            IF g_sgu[l_ac].sgu42<g_sgu[l_ac].sgu41 THEN
               CALL cl_err('','aec-993',0)
               NEXT FIELD sgu42
            END IF
#FUN-B30019 ---------------------------Begin---------------------------
        AFTER FIELD sgu48
            IF NOT cl_null(g_sgu[l_ac].sgu48) THEN
               IF g_sgu[l_ac].sgu48<= 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu48,'axr-034',1)
                  NEXT FIELD sgu48 
               END IF
            END IF
        AFTER FIELD sgu49 
            IF NOT cl_null(g_sgu[l_ac].sgu49) THEN
               IF g_sgu[l_ac].sgu49 <= 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu49,'axr-034',1)
                  NEXT FIELD sgu49
               END IF
            END IF
        AFTER FIELD sgu50 
           IF NOT i720_sgu50_check() THEN NEXT FIELD sgu50 END IF    #FUN-BB0085
           #FUN-BB0085-mark-str---------------------------- 
           #IF NOT cl_null(g_sgu[l_ac].sgu50) THEN
           #   IF g_sgu[l_ac].sgu50 < 0 THEN
           #      CALL cl_err(g_sgu[l_ac].sgu50,'axm-179',1)
           #      NEXT FIELD sgu50
           #   END IF
           #END IF
           #FUN-BB0085-mark-end----------------------------
        AFTER FIELD sgu51
            IF NOT cl_null(g_sgu[l_ac].sgu51) THEN
               IF g_sgu[l_ac].sgu51 < 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu34,'axm-179',1)
                  NEXT FIELD sgu51
               END IF
            END IF
        AFTER FIELD sgu52
            IF NOT cl_null(g_sgu[l_ac].sgu52) THEN
               IF g_sgu[l_ac].sgu52 <= 0 THEN
                  CALL cl_err(g_sgu[l_ac].sgu52,'axr-034',1)
                  NEXT FIELD sgu52
               END IF
            END IF
#FUN-B30019 ---------------------------End-----------------------------
#FUN-B50178 ---------------------------Begin---------------------------
        AFTER FIELD sgu54
            IF NOT cl_null(g_sgu[l_ac].sgu54) THEN           
               CALL i720_sgu54()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sgu[l_ac].sgu54,g_errno,0)
                  NEXT FIELD sgu54
               END IF
            END IF
#FUN-B50178 ---------------------------END----------------------------- 
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgu_t.sgu04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM sgu_file
                 WHERE sgu01 = g_sgt.sgt01 
                   AND sgu02 = g_sgt.sgt02
                   AND sgu04 = g_sgu_t.sgu04
                   AND sgu012= g_sgu_t.sgu012 #NO.FUN-A60080
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sgu_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
                   
        ON ROW CHANGE
           IF g_sgu[l_ac].sgu03 != g_sgu_t.sgu03 THEN
              IF g_sgu[l_ac].sgu03 = 1 THEN
                 IF cl_null(g_sgu[l_ac].sgu24) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu24
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu25) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu25
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu33) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu33
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu34) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu34
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu35) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu35
                 END IF
#FUN-B30019 -------------------Begin--------------------
#                 IF cl_null(g_sgu[l_ac].sgu38) THEN
#                    CALL cl_err('','agl-154',0)
#                    NEXT FIELD sgu38
#                 END IF
#FUN-B30019 -------------------End----------------------
                 IF cl_null(g_sgu[l_ac].sgu39) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu39
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu41) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu41
                 END IF
                 IF cl_null(g_sgu[l_ac].sgu42) THEN
                    CALL cl_err('','agl-154',0)
                    NEXT FIELD sgu42
                 END IF
              END IF
           END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgu[l_ac].* = g_sgu_t.*
               CLOSE i720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgu[l_ac].sgu04,-263,1)
               LET g_sgu[l_ac].* = g_sgu_t.*
            ELSE
               UPDATE sgu_file SET sgu04=g_sgu[l_ac].sgu04,
                                   sgu012=g_sgu[l_ac].sgu012,  #NO.FUN-A60080  add sgu012
                                   sgu014=g_sgu[l_ac].sgu014,  #FUN-B10056
                                   sgu03=g_sgu[l_ac].sgu03,
                                   sgu015=g_sgu[l_ac].sgu015,  #FUN-B10056
                                   sgu016=g_sgu[l_ac].sgu016,  #FUN-B10056
                                   sgu05=g_sgu[l_ac].sgu05,
                                   sgu06=g_sgu[l_ac].sgu06,
                                   sgu07=g_sgu[l_ac].sgu07,
                                   sgu08=g_sgu[l_ac].sgu08,
                                   sgu10=g_sgu[l_ac].sgu10,
                                   sgu11=g_sgu[l_ac].sgu11,
                                   sgu12=g_sgu[l_ac].sgu12,
                                   sgu13=g_sgu[l_ac].sgu13,
                                   sgu14=g_sgu[l_ac].sgu14,
                                   sgu15=g_sgu[l_ac].sgu15,
                                   sgu16=g_sgu[l_ac].sgu16,
                                   sgu17=g_sgu[l_ac].sgu17,
                                   sgu18=g_sgu[l_ac].sgu18,
                               #   sgu19=g_sgu[l_ac].sgu19,     #FUN-B30019
                                   sgu20=g_sgu[l_ac].sgu20,
                               #   sgu21=g_sgu[l_ac].sgu21,     #FUN-B30019
#FUN-B30019 -------------------------Begin---------------------------------
                                   sgu43=g_sgu[l_ac].sgu43,
                                   sgu44=g_sgu[l_ac].sgu44,
                                   sgu45=g_sgu[l_ac].sgu45,
                                   sgu46=g_sgu[l_ac].sgu46,
                                   sgu47=g_sgu[l_ac].sgu47,
#FUN-B30019 -------------------------End-----------------------------------
                                   sgu22=g_sgu[l_ac].sgu22,
                                   sgu23=g_sgu[l_ac].sgu23,
                                   sgu24=g_sgu[l_ac].sgu24,
                                   sgu25=g_sgu[l_ac].sgu25,
                                   sgu26=g_sgu[l_ac].sgu26,
                                   sgu27=g_sgu[l_ac].sgu27,
                                   sgu29=g_sgu[l_ac].sgu29,
                                   sgu30=g_sgu[l_ac].sgu30,
                                   sgu31=g_sgu[l_ac].sgu31,
                                   sgu32=g_sgu[l_ac].sgu32,
                                   sgu33=g_sgu[l_ac].sgu33,
                                   sgu34=g_sgu[l_ac].sgu34,
                                   sgu35=g_sgu[l_ac].sgu35,
                                   sgu36=g_sgu[l_ac].sgu36,
                                   sgu37=g_sgu[l_ac].sgu37,
                               #   sgu38=g_sgu[l_ac].sgu38,     #FUN-B30019
                                   sgu39=g_sgu[l_ac].sgu39,
                               #   sgu40=g_sgu[l_ac].sgu40,     #FUN-B30019
#FUN-B30019 -----------------------------Begin-----------------------------
                                   sgu48=g_sgu[l_ac].sgu48,
                                   sgu49=g_sgu[l_ac].sgu49,
                                   sgu50=g_sgu[l_ac].sgu50,
                                   sgu51=g_sgu[l_ac].sgu51,
                                   sgu52=g_sgu[l_ac].sgu52,
#FUN-B30019 -----------------------------End-------------------------------
                                   sgu53=g_sgu[l_ac].sgu53, #FUN-B50178
                                   sgu54=g_sgu[l_ac].sgu54, #FUN-B50178
                                   sgu41=g_sgu[l_ac].sgu41,
                                   sgu42=g_sgu[l_ac].sgu42 
                WHERE sgu01=g_sgt.sgt01
                  AND sgu02=g_sgt.sgt02
                  AND sgu04=g_sgu_t.sgu04
                  AND sgu012=g_sgu_t.sgu012  #NO.FUN-A60080  add sgu012
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sgu_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1) 
                  LET g_sgu[l_ac].* = g_sgu_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
             END IF
             
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgu[l_ac].* = g_sgu_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgu.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               ROLLBACK WORK
               CLOSE i720_bcl
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
           #FUN-B30019--begin--mark-------
           #IF g_sgu[l_ac].sgu03 = '3' THEN
           #   IF g_sgu[l_ac].sgu24 != g_sgu[l_ac].sgu05 THEN
           #      SELECT ecd02 INTO l_ecd02 FROM ecd_file
           #       WHERE ecd01 = g_sgu[l_ac].sgu24
           #      UPDATE ecm_file SET ecm45 = l_ecd02
           #       WHERE ecm01 = g_sgt.sgt01
           #         AND ecm03 = g_sgu[l_ac].sgu04
           #         AND ecm012= g_sgu[l_ac].sgu012     #NO.FUN-A60080
           #         AND ecm04 = g_sgu[l_ac].sgu05
           #   END IF
           #END IF
           #IF g_sgu[l_ac].sgu03 = '1' THEN
           #   IF cl_null(g_sgu[l_ac].sgu38) THEN
           #      CALL cl_err('','agl-154',0)
           #      NEXT FIELD sgu38
           #   END IF
           #   IF cl_null(g_sgu[l_ac].sgu39) THEN
           #      CALL cl_err('','agl-154',0)
           #      NEXT FIELD sgu39
           #   END IF
           #END IF
           #FUN-B30019--end--mark------
            CLOSE i720_bcl
            COMMIT WORK
 
        ON ACTION controlp                        #
           CASE
             #TQC-AC0093 --------add start--------
              WHEN INFIELD(sgu012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecm012_1"
                   LET g_qryparam.arg1 = g_sgt.sgt01
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04
                   DISPLAY BY NAME g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04
                   NEXT FIELD sgu012

             WHEN INFIELD(sgu04)
                   IF g_sma.sma541 = 'Y' THEN       #TQC-AC0093 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ecm012_1"
                      LET g_qryparam.arg1 = g_sgt.sgt01 
                      CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04 
                      DISPLAY BY NAME g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04
                      NEXT FIELD sgu04
                  #TQC-AC0093--------add start-----------
                   ELSE                   
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ecm10"
                      LET g_qryparam.arg1 = g_sgt.sgt01
                      LET g_qryparam.where = " ecm012 IS NULL OR ecm012 = ' ' "
                      CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu04
                      DISPLAY BY NAME g_sgu[l_ac].sgu04
                      NEXT FIELD sgu04
                   END IF 
                  #TQC-AC0093 -------add end-----------

             #TQC-AC0093 --------add end------------
              WHEN INFIELD(sgu26)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu26
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu26
                   DISPLAY BY NAME g_sgu[l_ac].sgu26    
                   NEXT FIELD sgu26
              WHEN INFIELD(sgu25)
                   CALL q_eca(FALSE,TRUE,g_sgu[l_ac].sgu25)
                        RETURNING g_sgu[l_ac].sgu25
                   DISPLAY BY NAME  g_sgu[l_ac].sgu25    
                   NEXT FIELD sgu25
              WHEN INFIELD(sgu24)
                   CALL q_ecd(FALSE,TRUE,g_sgu[l_ac].sgu24)
                        RETURNING g_sgu[l_ac].sgu24
                    DISPLAY BY NAME g_sgu[l_ac].sgu24     
                    NEXT FIELD sgu24
              WHEN INFIELD(sgu36)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu36
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu36
                   DISPLAY BY NAME g_sgu[l_ac].sgu36      
                   NEXT FIELD sgu36
              WHEN INFIELD(sgu37)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu37
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu37
                   DISPLAY BY NAME g_sgu[l_ac].sgu37      
                   NEXT FIELD sgu37
#FUN-B30019 -------------------Begin-----------------------
#              WHEN INFIELD(sgu38)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gfe"
#                   LET g_qryparam.default1 = g_sgu[l_ac].sgu38
#                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu38
#                   DISPLAY BY NAME g_sgu[l_ac].sgu38        
#                   NEXT FIELD sgu38
#FUN-B30019 -------------------End-------------------------
              WHEN INFIELD(sgu39)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu39
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu39
                   DISPLAY BY NAME  g_sgu[l_ac].sgu39      
                   NEXT FIELD sgu39
              #FUN-B10056--begin--add---
              WHEN INFIELD(sgu016)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecr"  #FUN-B20078
                   LET g_qryparam.arg1 = g_sgt.sgt01
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu016
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu016
                   DISPLAY BY NAME  g_sgu[l_ac].sgu016  
                   NEXT FIELD sgu016
               #FUN-B10056--end--add-----
#FUN-B50178 --------------------Begin----------------------
              WHEN INFIELD(sgu53)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu53
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu53
                   DISPLAY BY NAME  g_sgu[l_ac].sgu53
                   NEXT FIELD sgu53
              WHEN INFIELD(sgu54)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc"
                   LET g_qryparam.default1 = g_sgu[l_ac].sgu54
                   CALL cl_create_qry() RETURNING g_sgu[l_ac].sgu54
                   DISPLAY BY NAME  g_sgu[l_ac].sgu54
                   NEXT FIELD sgu54
#FUN-B50178 --------------------End------------------------

           END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sgu04) AND l_ac > 1 THEN
               LET g_sgu[l_ac].* = g_sgu[l_ac-1].*
               NEXT FIELD sgu04
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
    
    UPDATE sgt_file SET sgtmodu=g_user,
                        sgtdate=TODAY
     WHERE sgt01=g_sgt.sgt01 AND sgt02=g_sgt.sgt02
 
    CLOSE i720_bcl
    COMMIT WORK
#   CALL i720_delall()   #CHI-C30002 mark
    CALL i720_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i720_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM sgt_file
          WHERE sgt01 = g_sgt.sgt01
            AND sgt02 = g_sgt.sgt02
         INITIALIZE g_sgt.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i720_delall()
 
# SELECT COUNT(*) INTO g_cnt FROM sgu_file
#  WHERE sgu01 = g_sgt.sgt01
#    AND sgu02 = g_sgt.sgt02
#
# IF g_cnt = 0 THEN
#    CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#    ERROR g_msg CLIPPED
#    DELETE FROM sgt_file 
#     WHERE sgt01 = g_sgt.sgt01
#       AND sgt02 = g_sgt.sgt02
# END IF
#
#END FUNCTION 
#CHI-C30002 -------- mark -------- end

FUNCTION i720_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("sgu36",TRUE)
    END IF        
 
    IF INFIELD(sgu35) THEN
       CALL cl_set_comp_entry("sgu36",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i720_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       IF g_sgu[l_ac].sgu35 ='N' THEN
          CALL cl_set_comp_entry("sgu36",FALSE)
       END IF
    END IF        
 
    IF INFIELD(sgu35) THEN
       IF g_sgu[l_ac].sgu35 ='N' THEN
          CALL cl_set_comp_entry("sgu36",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION  i720_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti
 
    LET g_errno = ' '
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file
     WHERE sgg01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i720_b_askkey()
DEFINE
    l_wc2           STRING     #NO.FUN-910082 
 
    CONSTRUCT g_wc2 ON sgu012,sgu014,sgu04,sgu03,sgu015,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13,   #NO.FUN-A60080  add sgu012 #FUN-B10056
                    #  sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,   #FUN-B30019
                       sgu14,sgu53,sgu15,sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45,sgu46,   #FUN-B30019  #FUN-B50178 add sgu53
                       sgu47,sgu22,sgu23,               #FUN-B30019
                       sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30,   #FUN-B10056
                    #  sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,sgu40,sgu41,  #FUN-B30019
                       sgu31,sgu32,sgu33,sgu54,sgu34,sgu35,sgu36,sgu37,sgu39,              #FUN-B30019  #FUN-B50178 add sgu54
                       sgu48,sgu49,sgu50,sgu51,sgu52,      #FUN-B30019
                       sgu41,sgu42
           FROM s_sgu[1].sgu012,s_sgu[1].sgu014,s_sgu[1].sgu04,s_sgu[1].sgu03,s_sgu[1].sgu015,s_sgu[l_ac].sgu05,  #NO.FUN-A60080  add sgu012 #FUN-B10056
                s_sgu[1].sgu06,s_sgu[1].sgu07,s_sgu[1].sgu08,
                s_sgu[1].sgu10,s_sgu[1].sgu11,s_sgu[1].sgu12,s_sgu[1].sgu13,s_sgu[1].sgu14,s_sgu[1].sgu53,s_sgu[1].sgu15,   #FUN-B50178 add sgu53
           #    s_sgu[1].sgu16,s_sgu[1].sgu17,s_sgu[1].sgu18,s_sgu[1].sgu19,s_sgu[1].sgu20,s_sgu[1].sgu21,  #FUN-B30019
                s_sgu[1].sgu16,s_sgu[1].sgu17,s_sgu[1].sgu18,s_sgu[1].sgu20,s_sgu[1].sgu43,s_sgu[1].sgu44,  #FUN-B30019
                s_sgu[1].sgu45,s_sgu[1].sgu46,s_sgu[1].sgu47,              #FUN-B30019
                s_sgu[1].sgu22,s_sgu[l_ac].sgu23,
                s_sgu[1].sgu016,s_sgu[1].sgu24,s_sgu[1].sgu25,s_sgu[1].sgu26,s_sgu[1].sgu27,   #FUN-B10056
                s_sgu[1].sgu29,s_sgu[1].sgu30,s_sgu[1].sgu31,s_sgu[1].sgu32,s_sgu[1].sgu33,_sgu[1].sgu54,s_sgu[1].sgu34,   #FUN-B50178 add sgu54
           #    s_sgu[1].sgu35,s_sgu[1].sgu36,s_sgu[1].sgu37,s_sgu[1].sgu38,s_sgu[1].sgu39,s_sgu[1].sgu40,   #FUN-B30019
                s_sgu[1].sgu35,s_sgu[1].sgu36,s_sgu[1].sgu37,s_sgu[1].sgu39,s_sgu[1].sgu48,s_sgu[1].sgu49,   #FUN-B30019                   
                s_sgu[1].sgu50,s_sgu[1].sgu51,s_sgu[1].sgu52,              #FUN-B30019
                s_sgu[1].sgu41,s_sgu[1].sgu42
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i720_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i720_b_fill(p_wc2)              #BODY FILL UP
DEFINE
     p_wc2       STRING    #No.FUN-910082    
 
     IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF   #FUN-B20078

    LET g_sql =
        "SELECT sgu012,sgu014,sgu04,sgu03,sgu015,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,", #NO.FUN-A60080  add sgu012 #FUN-B10056
    #   " sgu13,sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,",    #FUN-B30019   
        " sgu13,sgu14,sgu53,sgu15,sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45,sgu46,",    #FUN-B30019  #FUN-B50178 add sgu53
        " sgu47,sgu22,sgu23,",                #FUN-B30019
        " '','','','',sgu016,sgu24,sgu25,sgu26,sgu27,",     #FUN-B10056 
    #   " sgu29,sgu30,sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,",    #FUN-B30019
        " sgu29,sgu30,sgu31,sgu32,sgu33,sgu54,sgu34,sgu35,sgu36,sgu37,sgu39,",    #FUN-B30019  #FUN-B50178 add sgu54
    #  #" sgu40,sgu41,sgu42,'','','',''",     #FUN-B30019 
        " sgu48,sgu49,sgu50,sgu51,sgu52,",    #FUN-B30019         
        " sgu41,sgu42,'','','',''",           #FUN-B30019
        " FROM sgu_file",
        " WHERE sgu01 ='",g_sgt.sgt01,"'",
        "   AND sgu02 ='",g_sgt.sgt02,"'",
        "   AND ",p_wc2 CLIPPED,  #FUN-2B0078
        " ORDER BY 1"
    PREPARE i720_pb FROM g_sql
    DECLARE sgu_curs CURSOR FOR i720_pb
 
    CALL g_sgu.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgu_curs INTO g_sgu[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sgu.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgu TO s_sgu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
        END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
        END IF
	      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i720_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      #FUN-BC0119 ---begin---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-BC0119 ---end---
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
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
                                            
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         EXIT DISPLAY                                                                                        
 
      ON ACTION release  
         LET g_action_choice="release"  
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i720_g()
  DEFINE l_cmd         LIKE type_file.chr1000 
  DEFINE l_sfb02       LIKE sfb_file.sfb02
  DEFINE l_ecm03_par   LIKE ecm_file.ecm03_par
  DEFINE l_ecm03       LIKE ecm_file.ecm03
  DEFINE l_ecm301      LIKE ecm_file.ecm301
  DEFINE l_ecm45       LIKE ecm_file.ecm45   #MOD-A70124 add

  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_sgt.sgt01) THEN CALL cl_err('','-400',0) RETURN END IF  
  IF g_sgt.sgt07 = 'N' THEN CALL cl_err('','aap-717',0) RETURN END IF
  IF g_sgt.sgtacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF 
  IF g_sgt.sgt08 = 'Y' THEN CALL cl_err(g_sgt.sgt08,'abm-003',0) RETURN END IF
  IF NOT i720_chk_umf() THEN RETURN END IF   #FUN-B90141
  BEGIN WORK                                                                                                                      
                                                                                                                                    
    OPEN i720_cl USING g_sgt.sgt01,g_sgt.sgt02    #No.FUN-9A0071
    IF STATUS THEN                                                                                                                  
       CALL cl_err("OPEN i720_cl:", STATUS, 1)                                                                                      
       CLOSE i720_cl                                                                                                                
       ROLLBACK WORK                                                                                                                
       RETURN                                                                                                                       
    END IF                                                                                                                          
    FETCH i720_cl INTO g_sgt.*                                                                                                      
    IF SQLCA.sqlcode THEN                                                                                                           
       CALL cl_err(g_sgt.sgt01,SQLCA.sqlcode,0) RETURN                                                                              
    END IF                                                                                                                          
    CALL i720_show()                                                                                                                
    IF NOT cl_confirm('aec-055') THEN RETURN END IF    #No:MOD-980266 modify                                                                             
    LET g_sgt.sgt06=g_today                                                                                                         
    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_sgt.sgt06 WITHOUT DEFAULTS                                                                                      
                                                                                                                                    
      AFTER FIELD sgt06                                                                                                          
        IF cl_null(g_sgt.sgt06) THEN NEXT FIELD sgt06 END IF                                                                        
        IF g_sgt.sgt06 < g_sgt.sgt05 THEN
           CALL cl_err('','apm-055',0)
           NEXT FIELD sgt06
        END IF
                                                                                                                                    
      AFTER INPUT                                                                                                                   
        IF INT_FLAG THEN EXIT INPUT END IF                                                                                          
        IF cl_null(g_sgt.sgt06) THEN NEXT FIELD sgt06 END IF
 
      ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
                                                                                                                                    
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION help          #MOD-4C0121                                                                                           
         CALL cl_show_help()  #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION controlg      #MOD-4C0121                                                                                           
         CALL cl_cmdask()     #MOD-4C0121
 
      END INPUT
      IF INT_FLAG THEN                                                                                                                
         LET g_sgt.sgt06=NULL                                                                                                         
         DISPLAY BY NAME g_sgt.sgt06                                                                                                  
         LET INT_FLAG=0                                                                                                               
         ROLLBACK WORK                                                                                                                
         RETURN                                                                                                                       
      END IF                                                                                                                          
      
     LET g_success = 'Y'
#FUN-B10056--begin--mark-------------------
#以下程式段改寫到FUNCTION i720_upd_ecm()中去
#&ifndef STD
#       LET g_sql = 
#             " SELECT sug012,sgu04,sgu03,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13, ",  #NO.FUN-A60080  add sgu012
#             "       sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,sguislk01, ",
#             "       sguislk02,sguislk03,sguislk04,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30, ",
#             "       sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,sgu40,sgu41, ",
#             "       sgu42,sguislk05,sguislk06,sguislk07,sguislk08 ",
#             "  FROM sgu_file,sgui_file ",
#             " WHERE sgu01 = '",g_sgt.sgt01,"' ",
#             "   AND sgu02 = '",g_sgt.sgt02,"' ",
#             "   AND sgu01 = sgui01 ",
#             "   AND sgu02 = sgui02 ",
#             "   AND sgu04 = sgui04 "
#&else
#      LET g_sql = 
#             " SELECT sgu012,sgu04,sgu03,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13, ",  #NO.FUN-A60080  add sgu012
#             "       sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu21,sgu22,sgu23,'', ",
#             "       '','','',sgu24,sgu25,sgu26,sgu27,sgu29,sgu30, ",
#             "       sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,sgu40,sgu41, ",
#             "       sgu42,'','','','' ",
#             "  FROM sgu_file  ",
#             " WHERE sgu01 = '",g_sgt.sgt01,"' ",
#             "   AND sgu02 = '",g_sgt.sgt02,"' "
#&endif
#     DECLARE sgu_cury CURSOR FROM g_sql 
#     FOREACH sgu_cury INTO g_sgu[l_ac].*
#       CASE g_sgu[l_ac].sgu03
#         WHEN '1' 
#          SELECT DISTINCT sfb02 INTO l_sfb02
#            FROM sfb_file
#           WHERE sfb01 = g_sgt.sgt01
#          SELECT DISTINCT ecm03_par INTO l_ecm03_par
#            FROM ecm_file
#           WHERE ecm01 = g_sgt.sgt01
#         #str MOD-A70124 add
#          LET l_ecm45 = ''
#          SELECT ecd02 INTO l_ecm45 FROM ecd_file
#           WHERE ecd01 = g_sgu[l_ac].sgu24
#         #end MOD-A70124 add
#&ifdef SLK
#          INSERT INTO ecm_file(ecm01,ecm02,ecm03_par,ecm03,ecm04,ecm06,ecm05,ecm49,ecm14,ecm13,
#                               ecm16,ecm15,ecm52,ecm53,ecm54,ecm55,ecm56,ecm57,ecm58,
#                               ecm59,ecm50,ecm51,ecmslk01,ecmslk02,ecmslk03,ecmslk04,
#                               ecm12,ecm17,ecm18,ecm19,ecm20,ecm21,ecm22,ecm23,ecm24,#No.FUN-8A0142
#                               ecm291,ecm292,ecm301,ecm302,ecm303,            #No.FUN-8A0136
#                               ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm321,ecm322,ecm34,ecm35,   #No.FUN-8A0136
#                               ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm45) #FUN-980002  #NO.FUN-A60080  add sgu012  #MOD-A70124 add ecm45
#          VALUES(g_sgt.sgt01,l_sfb02,l_ecm03_par,g_sgu[l_ac].sgu04,
#                 g_sgu[l_ac].sgu24,g_sgu[l_ac].sgu25,g_sgu[l_ac].sgu26,g_sgu[l_ac].sgu27,
#                 g_sgu[l_ac].sgu29,g_sgu[l_ac].sgu30,g_sgu[l_ac].sgu31,g_sgu[l_ac].sgu32,
#                 g_sgu[l_ac].sgu33,g_sgu[l_ac].sgu34,g_sgu[l_ac].sgu35,g_sgu[l_ac].sgu36,
#                 g_sgu[l_ac].sgu37,g_sgu[l_ac].sgu38,g_sgu[l_ac].sgu39,g_sgu[l_ac].sgu40,
#                 g_sgu[l_ac].sgu41,g_sgu[l_ac].sgu42,g_sgu[l_ac].sguislk05,
#                 g_sgu[l_ac].sguislk06,g_sgu[l_ac].sguislk07,g_sgu[l_ac].sguislk08,
#                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,         #No.FUN-8A0136
#                 0,0,0,0,0,0,0,0,0,0,                 #No.FUN-8A0136
#                 g_plant,g_legal,g_user,g_grup,g_sgu[l_ac].sgu012,l_ecm45) #FUN-980002  #No.FUN-980030 10/01/04 insert columns oriu, orig  #NO.FUN-A60080 add sgu012  #MOD-A70124 add l_ecm45
#&else
#          INSERT INTO ecm_file(ecm01,ecm02,ecm03_par,ecm03,ecm04,ecm06,ecm05,ecm49,ecm14,ecm13,
#                               ecm16,ecm15,ecm52,ecm53,ecm54,ecm55,ecm56,ecm57,ecm58,
#                               ecm59,ecm50,ecm51,
#                               ecm12,ecm17,ecm18,ecm19,ecm20,ecm21,ecm22,ecm23,ecm24,       #No.FUN-8A0142
#                               ecm291,ecm292,ecm301,ecm302,ecm303,            #No.FUN-8A0136
#                               ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm321,ecm322,ecm34,ecm35,   #No.FUN-8A0136
#                               ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm45) #FUN-980002  #NO.FUN-A60080  add sgu012  #MOD-A70124 add ecm45
#          VALUES(g_sgt.sgt01,l_sfb02,l_ecm03_par,g_sgu[l_ac].sgu04,
#                 g_sgu[l_ac].sgu24,g_sgu[l_ac].sgu25,g_sgu[l_ac].sgu26,g_sgu[l_ac].sgu27,
#                 g_sgu[l_ac].sgu29,g_sgu[l_ac].sgu30,g_sgu[l_ac].sgu31,g_sgu[l_ac].sgu32,
#                 g_sgu[l_ac].sgu33,g_sgu[l_ac].sgu34,g_sgu[l_ac].sgu35,g_sgu[l_ac].sgu36,
#                 g_sgu[l_ac].sgu37,g_sgu[l_ac].sgu38,g_sgu[l_ac].sgu39,g_sgu[l_ac].sgu40,
#                 g_sgu[l_ac].sgu41,g_sgu[l_ac].sgu42,
#                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,        #No.FUN-8A0136
#                 0,0,0,0,0,0,0,0,0,0,       #No.FUN-8A0136
#                 g_plant,g_legal,g_user,g_grup,g_sgu[l_ac].sgu012,l_ecm45) #FUN-980002  #No.FUN-980030 10/01/04 insert columns oriu, orig #NO.FUN-A60080 add sgu012  #MOD-A70124 add l_ecm45
#&endif
#          IF SQLCA.sqlcode  THEN                                                                                                  
#             CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
#             LET g_success = 'N'                                                                                                      
#             EXIT FOREACH                                                                                                             
#          END IF
#         WHEN '2' 
#               #刪除時將良品轉入量移轉到下一站良品轉入量
#               LET l_ecm03 = NULL
#               SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file 
#                                 WHERE ecm01 = g_sgt.sgt01
#                                   AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                                   AND ecm03 > g_sgu[l_ac].sgu04
#              
#               IF NOT cl_null(l_ecm03) THEN
#                  SELECT ecm301 INTO l_ecm301 FROM ecm_file
#                    WHERE ecm01 = g_sgt.sgt01
#                      AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                      AND ecm03 = g_sgu[l_ac].sgu04
#
#                  IF cl_null(l_ecm301) THEN LET l_ecm301 = 0 END IF
#
#                  UPDATE ecm_file SET ecm301 = l_ecm301
#                    WHERE ecm01 = g_sgt.sgt01
#                      AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                      AND ecm03 = l_ecm03
#
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("upd","ecm301",g_sgt.sgt01,l_ecm03,SQLCA.sqlcode,"","",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#
#               DELETE FROM ecm_file
#                WHERE ecm01 = g_sgt.sgt01
#                  AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                  AND ecm03 = g_sgu[l_ac].sgu04
#               IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               DELETE FROM sgd_file
#                WHERE sgd00 = g_sgt.sgt01
#                  AND sgd012= g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                  AND sgd03 = g_sgu[l_ac].sgu04
#               IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","sgc_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF   
#         WHEN '3' 
#               IF NOT cl_null(g_sgu[l_ac].sgu24) THEN
#                 #str MOD-A70124 add
#                  LET l_ecm45 = ''
#                  SELECT ecd02 INTO l_ecm45 FROM ecd_file
#                   WHERE ecd01 = g_sgu[l_ac].sgu24
#                 #end MOD-A70124 add
#                  UPDATE ecm_file SET ecm04 = g_sgu[l_ac].sgu24,
#                                      ecm45 = l_ecm45       #MOD-A70124 add
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm04",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu25) THEN
#                  UPDATE ecm_file SET ecm06 = g_sgu[l_ac].sgu25
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm06",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu26) THEN
#                  UPDATE ecm_file SET ecm05 = g_sgu[l_ac].sgu26
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm05",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu27) THEN
#                  UPDATE ecm_file SET ecm49 = g_sgu[l_ac].sgu27
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm49",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu29) THEN
#                  UPDATE ecm_file SET ecm14 = g_sgu[l_ac].sgu29
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm14",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu30) THEN
#                  UPDATE ecm_file SET ecm13 = g_sgu[l_ac].sgu30
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm13",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu31) THEN
#                  UPDATE ecm_file SET ecm16 = g_sgu[l_ac].sgu31
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm16",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu32) THEN
#                  UPDATE ecm_file SET ecm15 = g_sgu[l_ac].sgu32
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm15",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu33) THEN
#                  UPDATE ecm_file SET ecm52 = g_sgu[l_ac].sgu33
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm52",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu34) THEN
#                  UPDATE ecm_file SET ecm53 = g_sgu[l_ac].sgu34
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm53",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu35) THEN
#                  UPDATE ecm_file SET ecm54 = g_sgu[l_ac].sgu35
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm54",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu36) THEN
#                  UPDATE ecm_file SET ecm55 = g_sgu[l_ac].sgu36
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm55",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu37) THEN
#                  UPDATE ecm_file SET ecm56 = g_sgu[l_ac].sgu37
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm56",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu38) THEN
#                  UPDATE ecm_file SET ecm57 = g_sgu[l_ac].sgu38
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm57",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu39) THEN
#                  UPDATE ecm_file SET ecm58 = g_sgu[l_ac].sgu39
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm58",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu40) THEN
#                  UPDATE ecm_file SET ecm59 = g_sgu[l_ac].sgu40
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm59",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu41) THEN
#                  UPDATE ecm_file SET ecm50 = g_sgu[l_ac].sgu41
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm50",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sgu42) THEN
#                  UPDATE ecm_file SET ecm51 = g_sgu[l_ac].sgu42
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm51",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#&ifdef SLK
#               IF NOT cl_null(g_sgu[l_ac].sguislk05) THEN
#                  UPDATE ecm_file SET ecmslk01 = g_sgu[l_ac].sguislk05
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecmslk01",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sguislk06) THEN
#                  UPDATE ecm_file SET ecmslk02 = g_sgu[l_ac].sguislk06
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecmslk02",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sguislk07) THEN
#                  UPDATE ecm_file SET ecmslk03 = g_sgu[l_ac].sguislk07
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecmslk03",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#               IF NOT cl_null(g_sgu[l_ac].sguislk08) THEN
#                  UPDATE ecm_file SET ecmslk04 = g_sgu[l_ac].sguislk08
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012=g_sgu[l_ac].sgu012  #NO.FUN-A60080
#                     AND ecm03 = g_sgu[l_ac].sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecmslk04",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#&endif
#       END CASE
#     LET l_ac=l_ac+1
#     END FOREACH
#FUN-B10056--end--mark---------------------
#FUN-B10056--begin--add-------
     CALL i720_upd_ecm()
     IF g_success = 'Y' THEN
        IF g_sma.sma541 = 'Y' THEN
           CALL i700sub_chkbom(g_sgt.sgt01,'1')
           IF g_success = 'Y' THEN
              CALL i700sub_ecm011(g_sgt.sgt01)
           END IF
        END IF
     END IF
     IF g_success = 'Y' THEN
#FUN-B10056--end--add-------
        UPDATE sfb_file SET sfb103 = g_sgt.sgt02
         WHERE sfb01 = g_sgt.sgt01
        IF SQLCA.sqlcode  THEN                                                                                                  
           CALL cl_err3("sql","sfb_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","up ecu",1)                                             
           LET g_success = 'N'
        END IF
        UPDATE sgt_file SET sgt06=g_sgt.sgt06,                                                                                          
                            sgt08='Y'       
                         WHERE sgt01=g_sgt.sgt01
                           AND sgt02=g_sgt.sgt02        
                                                                             
        IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
           LET g_sgt.sgt06=NULL                                                                                                         
           DISPLAY BY NAME g_sgt.sgt06                                                                                                  
           CALL cl_err3("upd","sgt_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","up sgt06",1)                                                  
           LET g_success = 'N'                                                                                                                
           #RETURN               #No.MOD-A30038 mark                                                                                                              
        END IF
    END IF  #FUN-B10056
 
    IF g_success = 'N' THEN                                                                                                         
       ROLLBACK WORK                                                                                                                
    ELSE                                                                                                                            
       COMMIT WORK  
    END IF
    SELECT sgt08 INTO g_sgt.sgt08
      FROM sgt_file
     WHERE sgt01=g_sgt.sgt01
       AND sgt02=g_sgt.sgt02
    DISPLAY BY NAME g_sgt.sgt06
    DISPLAY BY NAME g_sgt.sgt08
END FUNCTION                                                         

#FUN-B10056--begin--add---------
FUNCTION i720_upd_ecm()
DEFINE  l_sgu           RECORD    
        sgu012          LIKE sgu_file.sgu012, 
        sgu014          LIKE sgu_file.sgu014,
        sgu04           LIKE sgu_file.sgu04,
        sgu03           LIKE sgu_file.sgu03,
        a               LIKE sgu_file.sgu03,
        sgu015          LIKE sgu_file.sgu015, 
        sgu05           LIKE sgu_file.sgu05,
        sgu06           LIKE sgu_file.sgu06,
        sgu07           LIKE sgu_file.sgu07,
        sgu08           LIKE sgu_file.sgu08,
        sgu10           LIKE sgu_file.sgu10,
        sgu11           LIKE sgu_file.sgu11,
        sgu12           LIKE sgu_file.sgu12,
        sgu13           LIKE sgu_file.sgu13,
        sgu14           LIKE sgu_file.sgu14,
        sgu53           LIKE sgu_file.sgu53,  #FUN-B50178
        sgu15           LIKE sgu_file.sgu15,
        sgu16           LIKE sgu_file.sgu16,
        sgu17           LIKE sgu_file.sgu17,
        sgu18           LIKE sgu_file.sgu18,
     #  sgu19           LIKE sgu_file.sgu19,   #FUN-B30019
        sgu20           LIKE sgu_file.sgu20, 
     #  sgu21           LIKE sgu_file.sgu21,   #FUN-B30019
#FUN-B30019 ---------------------Begin------------------------
        sgu43           LIKE sgu_file.sgu43,
        sgu44           LIKE sgu_file.sgu44,
        sgu45           LIKE sgu_file.sgu45,
        sgu46           LIKE sgu_file.sgu46,
        sgu47           LIKE sgu_file.sgu47,
#FUN-B30019 ---------------------End--------------------------
        sgu22           LIKE sgu_file.sgu22,
        sgu23           LIKE sgu_file.sgu23,
        sguislk01       LIKE sgui_file.sguislk01,
        sguislk02       LIKE sgui_file.sguislk02,
        sguislk03       LIKE sgui_file.sguislk03,
        sguislk04       LIKE sgui_file.sguislk04,
        sgu016          LIKE sgu_file.sgu016,  #FUN-B10056
        sgu24           LIKE sgu_file.sgu24,
        sgu25           LIKE sgu_file.sgu25,
        sgu26           LIKE sgu_file.sgu26,
        sgu27           LIKE sgu_file.sgu27,
        sgu29           LIKE sgu_file.sgu29,
        sgu30           LIKE sgu_file.sgu30,
        sgu31           LIKE sgu_file.sgu31,
        sgu32           LIKE sgu_file.sgu32,
        sgu33           LIKE sgu_file.sgu33,
        sgu54           LIKE sgu_file.sgu54,  #FUN-B50178
        sgu34           LIKE sgu_file.sgu34,
        sgu35           LIKE sgu_file.sgu35,
        sgu36           LIKE sgu_file.sgu36,
        sgu37           LIKE sgu_file.sgu37,
     #  sgu38           LIKE sgu_file.sgu38,  #FUN-B30019
        sgu39           LIKE sgu_file.sgu39,
     #  sgu40           LIKE sgu_file.sgu40,  #FUN-B30019
#FUN-B30019 --------------------Begin-----------------------
        sgu48           LIKE sgu_file.sgu48,
        sgu49           LIKE sgu_file.sgu49,
        sgu50           LIKE sgu_file.sgu50,
        sgu51           LIKE sgu_file.sgu51,
        sgu52           LIKE sgu_file.sgu52,
#FUN-B30019 --------------------End-------------------------
        sgu41           LIKE sgu_file.sgu41,
        sgu42           LIKE sgu_file.sgu42,
        sguislk05       LIKE sgui_file.sguislk05,
        sguislk06       LIKE sgui_file.sguislk06,
        sguislk07       LIKE sgui_file.sguislk07,
        sguislk08       LIKE sgui_file.sguislk08
                    END RECORD
DEFINE l_ecm012         LIKE ecm_file.ecm012
DEFINE l_ecm03          LIKE ecm_file.ecm03
DEFINE l_ecm301         LIKE ecm_file.ecm301
DEFINE l_sfb02          LIKE sfb_file.sfb02
DEFINE l_ecm03_par      LIKE ecm_file.ecm03_par
DEFINE l_ecm45          LIKE ecm_file.ecm45
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_msg            STRING  
DEFINE l_sfb08          LIKE sfb_file.sfb08     #FUN-B30019
DEFINE l_ecm61          LIKE ecm_file.ecm61     #FUN-B30019
DEFINE l_next_ecm012    LIKE ecm_file.ecm012  #CHI-C70022
DEFINE l_next_ecm03     LIKE ecm_file.ecm03   #CHI-C70022

#sgu03='1':新增   sgu03='2':刪除   sgu03='3':修改
#以下SQL語句採用case when 寫法的目的是處理資料時，依新增/修改/刪除的順序來處理
#資料刪除時須將良品轉入量移轉到下一站良品轉入量，所以需要抓下一製程號，為了正確的抓取到下一製程號,故將刪除放最後處理
      LET g_sql = 
             " SELECT sgu012,sgu014,sgu04,sgu03,(case when (sgu03='3') then '2'",
             "       when (sgu03='1') then '1'",
             "       when (sgu03='2') then '3' end) as a,",
             "       sgu015,sgu05,sgu06,sgu07,sgu08,sgu10,sgu11,sgu12,sgu13, ", 
      #      "       sgu14,sgu15,sgu16,sgu17,sgu18,sgu19,sgu20,sgu43,sgu44,sgu45, ",      #FUN-B30019
             "       sgu14,sgu53,sgu15,sgu16,sgu17,sgu18,sgu20,sgu43,sgu44,sgu45, ",      #FUN-B30019   #FUN-B50178 add sgu53
             "       sgu46,sgu47,sgu22,sgu23,'', ",                                       #FUN-B30019
             "       '','','',sgu016,sgu24,sgu25,sgu26,sgu27,sgu29,sgu30, ",
      #      "       sgu31,sgu32,sgu33,sgu34,sgu35,sgu36,sgu37,sgu38,sgu39,sgu40,sgu41, ",  #FUN-B30019  
             "       sgu31,sgu32,sgu33,sgu54,sgu34,sgu35,sgu36,sgu37,sgu39,sgu48,sgu49,sgu50, ",  #FUN-B30019 #FUN-B50178
             "       sgu51,sgu52,sgu41, ",              #FUN-B30019   
             "       sgu42,'','','','' ",
             "  FROM sgu_file  ",
             " WHERE sgu01 = '",g_sgt.sgt01,"' ",
             "   AND sgu02 = '",g_sgt.sgt02,"' ",
             " ORDER BY a "
     DECLARE sgu_cury CURSOR FROM g_sql 
     FOREACH sgu_cury INTO l_sgu.*
#FUN-B30019 -------------------------------------Begin----------------------------------
        LET g_ecm65=0
        IF (NOT cl_null(l_sgu.sgu48) OR NOT cl_null(l_sgu.sgu49) OR NOT cl_null(l_sgu.sgu50)
            OR NOT cl_null(l_sgu.sgu51) OR NOT cl_null(l_sgu.sgu52)) THEN 
           SELECT sfb08 INTO l_sfb08 FROM sfb_file
            WHERE sfb01 = g_sgt.sgt01
           CALL cralc_eck_rate(g_sgt.sgt01,l_sgu.sgu04,l_sgu.sgu012,l_sfb08,l_sgu.sgu50,l_sgu.sgu51,
                               l_sgu.sgu52,l_sgu.sgu48/l_sgu.sgu49,1)
                RETURNING g_ecm65
        END IF
       LET g_ecm65 = s_digqty(g_ecm65,l_sgu.sgu39)    #FUN-BB0085 
#FUN-B30019 -------------------------------------End------------------------------------
       #FUN-BB0085-add-str--
       IF NOT cl_null(l_sgu.sgu39) AND NOT cl_null(l_sgu.sgu50) THEN 
          LET l_sgu.sgu50 = s_digqty(l_sgu.sgu45,l_sgu.sgu39)
       END IF 
       #FUN-BB0085-add-end--
       CASE l_sgu.sgu03
         WHEN '1' 
          SELECT DISTINCT sfb02 INTO l_sfb02
            FROM sfb_file
           WHERE sfb01 = g_sgt.sgt01
          SELECT DISTINCT ecm03_par INTO l_ecm03_par
            FROM ecm_file
           WHERE ecm01 = g_sgt.sgt01
          LET l_ecm45 = ''
          SELECT ecd02 INTO l_ecm45 FROM ecd_file
           WHERE ecd01 = l_sgu.sgu24
          LET l_ecm61 = 'N'     #FUN-B30019
          IF cl_null(l_sgu.sgu48) OR l_sgu.sgu48 = 0 THEN LET l_sgu.sgu48 = 1 END IF  #CHI-B80096
          IF cl_null(l_sgu.sgu49) OR l_sgu.sgu49 = 0 THEN LET l_sgu.sgu49 = 1 END IF  #CHI-B80096
          #CHI-C70022---begin
          CALL s_schdat_next_ecm03(g_sgt.sgt01,g_sgu[l_ac].sgu012,g_sgu[l_ac].sgu04) RETURNING l_next_ecm012,l_next_ecm03
          LET l_ecm301 = 0
          IF NOT cl_null(l_next_ecm03) OR NOT cl_null(l_next_ecm012) THEN 
             SELECT ecm301 INTO l_ecm301
               FROM ecm_file
              WHERE ecm01 = g_sgt.sgt01
                AND ecm012 = l_next_ecm012
                AND ecm03 = l_next_ecm03
             IF cl_null(l_ecm301) THEN LET l_ecm301 = 0 END IF 
          ELSE
             LET l_ecm301 = 0
          END IF 
          #CHI-C70022---end
          INSERT INTO ecm_file(ecm01,ecm02,ecm03_par,ecm03,ecm04,ecm06,ecm05,ecm49,ecm14,ecm13,
                               ecm16,ecm15,ecm52,ecm53,ecm54,ecm55,ecm56,ecm57,ecm58,
                               ecm59,ecm50,ecm51,
                               ecm12,ecm17,ecm18,ecm19,ecm20,ecm21,ecm22,ecm23,ecm24, 
                               ecm291,ecm292,ecm301,ecm302,ecm303, 
                               ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm321,ecm322,ecm34,ecm35,  
                      #        ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm45,ecm014,ecm015)               #FUN-B30019
                               ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm45,ecm014,ecm015,
                               ecm62,ecm63,ecm64,ecm61,ecm65,ecm66,ecm67)   #FUN-B30019   add ecm61,ecm65  #FUN-B50178 add ecm67 #TQC-B80022 add ecm66
          VALUES(g_sgt.sgt01,l_sfb02,l_ecm03_par,l_sgu.sgu04,
                 l_sgu.sgu24,l_sgu.sgu25,l_sgu.sgu26,l_sgu.sgu27,
                 l_sgu.sgu29,l_sgu.sgu30,l_sgu.sgu31,l_sgu.sgu32,
                 l_sgu.sgu33,l_sgu.sgu34,l_sgu.sgu35,l_sgu.sgu36,
                 l_sgu.sgu37,'',l_sgu.sgu39,'',    #FUN-B30019
                 l_sgu.sgu41,l_sgu.sgu42,
                 #l_sgu.sgu50,0,0,0,0,0,0,0,0,0,0,0,0,0,  #FUN-B30019 #CHI-C70022
                 l_sgu.sgu50,0,0,0,0,0,0,0,0,0,0,l_ecm301,0,0,  #CHI-C70022
                 0,0,0,0,0,0,0,0,l_sgu.sgu51,0,   #FUN-B30019  
          #      g_plant,g_legal,g_user,g_grup,l_sgu.sgu012,l_ecm45,l_sgu.sgu014,l_sgu.sgu016)  #FUN-B30019  
                 g_plant,g_legal,g_user,g_grup,l_sgu.sgu012,l_ecm45,l_sgu.sgu014,l_sgu.sgu016,
                 l_sgu.sgu48,l_sgu.sgu49,l_sgu.sgu52,l_ecm61,g_ecm65,'Y',l_sgu.sgu54)  #FUN-B30019  #FUN-B50178 add sgu54 #TQC-B80022 add 'Y'
          IF SQLCA.sqlcode  THEN                                                                                                  
             CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
             LET g_success = 'N'                                                                                                      
             EXIT FOREACH                                                                                                             
          END IF
          #CHI-C70022---begin
          IF NOT cl_null(l_next_ecm03) OR NOT cl_null(l_next_ecm012) THEN
             UPDATE ecm_file SET ecm301 = 0
              WHERE ecm01 = g_sgt.sgt01
                AND ecm012= l_next_ecm012
                AND ecm03 = l_next_ecm03
          END IF 
          #CHI-C70022---end 
         WHEN '2' 
               #刪除時將良品轉入量移轉到下一站良品轉入量
               LET l_ecm03 = NULL
               CALL s_schdat_next_ecm03(g_sgt.sgt01,l_sgu.sgu012,l_sgu.sgu04) RETURNING l_ecm012,l_ecm03
               IF NOT cl_null(l_ecm03) THEN
                  SELECT ecm301 INTO l_ecm301 FROM ecm_file
                    WHERE ecm01 = g_sgt.sgt01
                      AND ecm012=l_sgu.sgu012
                      AND ecm03 = l_sgu.sgu04

                  IF cl_null(l_ecm301) THEN LET l_ecm301 = 0 END IF

                  UPDATE ecm_file SET ecm301 = l_ecm301
                    WHERE ecm01 = g_sgt.sgt01
                      AND ecm012= l_ecm012
                      AND ecm03 = l_ecm03

                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("upd","ecm301",g_sgt.sgt01,l_ecm03,SQLCA.sqlcode,"","",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF

               DELETE FROM ecm_file
                WHERE ecm01 = g_sgt.sgt01
                  AND ecm012=l_sgu.sgu012  
                  AND ecm03 = l_sgu.sgu04
               IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               DELETE FROM sgd_file
                WHERE sgd00 = g_sgt.sgt01
                  AND sgd012= l_sgu.sgu012  
                  AND sgd03 = l_sgu.sgu04
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","sgc_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF   
               #FUN-B20078--begin--add---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01=g_sgt.sgt01 AND ecm012=l_sgu.sgu012
               IF l_cnt = 0 THEN
                  LET l_msg = l_sgu.sgu012,cl_getmsg('aec-067',g_lang),l_sgu.sgu012,cl_getmsg('aec-068',g_lang)
                  IF cl_confirm(l_msg) THEN
                     UPDATE ecm_file SET ecm015=' ' WHERE ecm01=g_sgt.sgt01 AND ecm015=l_sgu.sgu012
                  END IF
               END IF
               #FUN-B20078--end--add---
         WHEN '3' 
               IF NOT cl_null(l_sgu.sgu24) THEN
                  LET l_ecm45 = ''
                  SELECT ecd02 INTO l_ecm45 FROM ecd_file
                   WHERE ecd01 = l_sgu.sgu24
                  UPDATE ecm_file SET ecm04 = l_sgu.sgu24,
                                      ecm45 = l_ecm45   
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012 
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm04",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu25) THEN
                  UPDATE ecm_file SET ecm06 = l_sgu.sgu25
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm06",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu26) THEN
                  UPDATE ecm_file SET ecm05 = l_sgu.sgu26
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm05",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu27) THEN
                  UPDATE ecm_file SET ecm49 = l_sgu.sgu27
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm49",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu29) THEN
                  UPDATE ecm_file SET ecm14 = l_sgu.sgu29
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm14",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu30) THEN
                  UPDATE ecm_file SET ecm13 = l_sgu.sgu30
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm13",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu31) THEN
                  UPDATE ecm_file SET ecm16 = l_sgu.sgu31
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm16",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu32) THEN
                  UPDATE ecm_file SET ecm15 = l_sgu.sgu32
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm15",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu33) THEN
                  UPDATE ecm_file SET ecm52 = l_sgu.sgu33
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm52",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
            #FUN-B50178 ----------------Begin--------------------
               IF NOT cl_null(l_sgu.sgu54) THEN
                  UPDATE ecm_file SET ecm67 = l_sgu.sgu54
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012
                     AND ecm03 = l_sgu.sgu04                
                  IF SQLCA.sqlcode  THEN
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm67",1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
               END IF
            #FUN-B50178 ----------------End----------------------
               IF NOT cl_null(l_sgu.sgu34) THEN
                  UPDATE ecm_file SET ecm53 = l_sgu.sgu34
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm53",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu35) THEN
                  UPDATE ecm_file SET ecm54 = l_sgu.sgu35
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm54",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu36) THEN
                  UPDATE ecm_file SET ecm55 = l_sgu.sgu36
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm55",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu37) THEN
                  UPDATE ecm_file SET ecm56 = l_sgu.sgu37
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm56",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
#FUN-B30019 -------------------------Begin--------------------------------
#               IF NOT cl_null(l_sgu.sgu38) THEN
#                  UPDATE ecm_file SET ecm57 = l_sgu.sgu38
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012= l_sgu.sgu012  
#                     AND ecm03 = l_sgu.sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm57",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#FUN-B30019 -------------------------End----------------------------------
               IF NOT cl_null(l_sgu.sgu39) THEN
                  UPDATE ecm_file SET ecm58 = l_sgu.sgu39
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm58",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
#FUN-B30019 ------------------------Begin-------------------------------
#               IF NOT cl_null(l_sgu.sgu40) THEN
#                  UPDATE ecm_file SET ecm59 = l_sgu.sgu40
#                   WHERE ecm01 = g_sgt.sgt01
#                     AND ecm012= l_sgu.sgu012  
#                     AND ecm03 = l_sgu.sgu04
#                  IF SQLCA.sqlcode  THEN                                                                                                  
#                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm59",1)                                             
#                     LET g_success = 'N'                                                                                                      
#                     EXIT FOREACH                                                                                                             
#                  END IF
#               END IF
#FUN-B30019 ------------------------End---------------------------------
               IF NOT cl_null(l_sgu.sgu41) THEN
                  UPDATE ecm_file SET ecm50 = l_sgu.sgu41
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm50",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu42) THEN
                  UPDATE ecm_file SET ecm51 = l_sgu.sgu42
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm51",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu016) THEN
                  UPDATE ecm_file SET ecm015 = l_sgu.sgu016
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm016",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               #FUN-B30019--begin--add-----
               IF NOT cl_null(l_sgu.sgu48) THEN
                  UPDATE ecm_file SET ecm62 = l_sgu.sgu48
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm62",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu49) THEN
                  UPDATE ecm_file SET ecm63 = l_sgu.sgu49
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm63",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu50) THEN
                  UPDATE ecm_file SET ecm12 = l_sgu.sgu50
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm12",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu51) THEN
                  UPDATE ecm_file SET ecm34 = l_sgu.sgu51
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm34",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(l_sgu.sgu52) THEN
                  UPDATE ecm_file SET ecm64 = l_sgu.sgu52
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm64",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               IF NOT cl_null(g_ecm65) AND g_ecm65 <> 0 THEN
                  UPDATE ecm_file SET ecm65 = g_ecm65
                   WHERE ecm01 = g_sgt.sgt01
                     AND ecm012= l_sgu.sgu012  
                     AND ecm03 = l_sgu.sgu04
                  IF SQLCA.sqlcode  THEN                                                                                                  
                     CALL cl_err3("sql","ecm_file",g_sgt.sgt01,g_sgt.sgt02,SQLCA.sqlcode,"","ecm65",1)                                             
                     LET g_success = 'N'                                                                                                      
                     EXIT FOREACH                                                                                                             
                  END IF
               END IF
               #FUN-B30019--end--add-------
       END CASE
     END FOREACH
END FUNCTION
#FUN-B10056--end--add-----

FUNCTION i720_set_sgu03()
DEFINE lcbo_target ui.ComboBox                                                                                                   
DEFINE l_str2       STRING
DEFINE l_str3       STRING
DEFINE l_ze03 LIKE ze_file.ze03
 
   LET lcbo_target = ui.ComboBox.forName("sgu03")   
   CALL lcbo_target.RemoveItem("1") 
   CALL lcbo_target.RemoveItem("2") 
   CALL lcbo_target.RemoveItem("3") 
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-062'
     AND ze02=g_lang
   LET l_str2 = l_ze03
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-063'
     AND ze02=g_lang
   LET l_str3 = l_ze03
   CALL lcbo_target.AddItem("2",l_str2)
   CALL lcbo_target.AddItem("3",l_str3)
END FUNCTION        
 
FUNCTION i720_set_sgu03a()
   DEFINE lcbo_target ui.ComboBox
   DEFINE l_str1      STRING
   DEFINE l_str2       STRING
   DEFINE l_str3       STRING
   DEFINE l_ze03 LIKE ze_file.ze03

   LET lcbo_target = ui.ComboBox.forName("sgu03")
   CALL lcbo_target.RemoveItem("1") 
   CALL lcbo_target.RemoveItem("2") 
   CALL lcbo_target.RemoveItem("3") 

   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-115'
     AND ze02=g_lang
   LET l_str1=l_ze03
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-062'
     AND ze02=g_lang
   LET l_str2 = l_ze03
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-063'
     AND ze02=g_lang
   LET l_str3 = l_ze03
   
   CALL lcbo_target.AddItem("1",l_str1)
   CALL lcbo_target.AddItem("2",l_str2)
   CALL lcbo_target.AddItem("3",l_str3)
END FUNCTION

#TQC-AC0093 ----------add start--------
FUNCTION i720_sgu012_check(p_sgt01,p_sgu04,p_sgu012)
   DEFINE p_sgt01   LIKE sgt_file.sgt01,
          p_sgu04   LIKE sgu_file.sgu04,
          p_sgu012  LIKE sgu_file.sgu012
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_n1      LIKE type_file.num5
   DEFINE l_n2      LIKE type_file.num5
   DEFINE l_n3      LIKE type_file.num5
   DEFINE l_n4      LIKE type_file.num5
  #DEFINE l_max_ecm03      LIKE ecm_file.ecm03   #FUN-B10056
   DEFINE l_flag           LIKE type_file.chr21
   DEFINE l_pre_ecm012     LIKE ecm_file.ecm012  #FUN-B10056
   DEFINE l_pre_ecm03      LIKE ecm_file.ecm03   #FUN-B10056
  
   LET l_flag = TRUE
   SELECT count(*) INTO l_n FROM ecm_file
    WHERE ecm01 = p_sgt01
      AND ecm03 = p_sgu04
      AND ecm012= p_sgu012
   IF l_n = 0 THEN
     #FUN-B10056--begin--modify---
     #SELECT max(ecm03) INTO l_max_ecm03
     #  FROM ecm_file
     # WHERE ecm01 = p_sgt01
     #   AND ecm012= p_sgu012
     #   AND ecm03 < p_sgu04
      CALL s_schdat_previous_ecm03(p_sgt01,p_sgu012,p_sgu04) RETURNING l_pre_ecm012,l_pre_ecm03  #取得上製程段號,上製程序
     #FUN-B10056--end--modify-----
      LET l_n1 = 0  #FUN-B10056
      SELECT count(*) INTO l_n1
        FROM shb_file
       WHERE shb05 = p_sgt01
         AND shb06 = l_pre_ecm03
         AND shb012= l_pre_ecm012
         AND shbconf = 'Y'    #FUN-A70095
      IF l_n1 > 0 THEN
         CALL cl_err('','aec-117',0)
         RETURN FALSE 
      ELSE
         LET g_sgu[l_ac].sgu03 = '1'
         CALL cl_set_comp_entry("sgu03",FALSE)
         CALL i720_set_no_required()  #FUN-B30019
         LET g_sgu[l_ac].sgu015= " "  #FUN-B10056
         LET g_sgu[l_ac].sgu05 = " "
         LET g_sgu[l_ac].sgu06 = " "
         LET g_sgu[l_ac].sgu07 = " "
         LET g_sgu[l_ac].sgu08 = " "
         LET g_sgu[l_ac].sgu10 = " "
         LET g_sgu[l_ac].sgu11 = " "
         LET g_sgu[l_ac].sgu12 = " "
         LET g_sgu[l_ac].sgu13 = " "
         LET g_sgu[l_ac].sgu14 = " "
         LET g_sgu[l_ac].sgu15 = " "
         LET g_sgu[l_ac].sgu16 = " "
         LET g_sgu[l_ac].sgu17 = " "
         LET g_sgu[l_ac].sgu18 = " "
     #   LET g_sgu[l_ac].sgu19 = " "    #FUN-B30019
         LET g_sgu[l_ac].sgu20 = " "
     #   LET g_sgu[l_ac].sgu21 = " "    #FUN-B30019
         LET g_sgu[l_ac].sgu14 = " "
         LET g_sgu[l_ac].sgu15 = " "
         LET g_sgu[l_ac].sgu16 = " "
         LET g_sgu[l_ac].sgu17 = " "
         LET g_sgu[l_ac].sgu18 = " "
     #   LET g_sgu[l_ac].sgu19 = " "     #FUN-B30019
         LET g_sgu[l_ac].sgu20 = " "
     #   LET g_sgu[l_ac].sgu21 = " "     #FUN-B30019
         LET g_sgu[l_ac].sgu22 = " "
         LET g_sgu[l_ac].sgu23 = " "
         IF g_sgu_t.sgu04 IS NULL THEN
            LET g_sgu[l_ac].sgu33 = 'N'
            LET g_sgu[l_ac].sgu34 = 'N'
            LET g_sgu[l_ac].sgu35 = 'N'
            LET g_sgu[l_ac].sgu27 = 0
            LET g_sgu[l_ac].sgu29 = 0
            LET g_sgu[l_ac].sgu30 = 0
            LET g_sgu[l_ac].sgu31 = 0
            LET g_sgu[l_ac].sgu32 = 0
#FUN-B30019 ------------------Begin---------------
            LET g_sgu[l_ac].sgu48 = 1
            LET g_sgu[l_ac].sgu49 = 1
            LET g_sgu[l_ac].sgu50 = 0
            LET g_sgu[l_ac].sgu51 = 0
            LET g_sgu[l_ac].sgu52 = 1
#FUN-B30019 ------------------End-----------------
            LET g_sgu[l_ac].sgu53 = " "   #FUN-B50178
            LET g_sgu[l_ac].sgu54 = " "   #FUN-B50178     
         END IF
      END IF
   ELSE
      SELECT count(*) INTO l_n2
        FROM sgx_file
       WHERE sgx01 = p_sgt01
         AND sgx02 = p_sgu04
         AND sgx09 = 'N'
         AND sgx012 = p_sgu012
      IF l_n1 > 0 THEN
         CALL cl_err('','aec-105',0)
         RETURN FALSE
      END IF
      IF s_industry('slk') THEN
         SELECT count(*) INTO l_n3
           FROM sgl_file,sgk_file
          WHERE sgl04 = p_sgt01
            AND sgl06 = p_sgu04
            AND sgl01 = sgk01
            AND sgl012 = p_sgu012
            AND sgkacti = 'Y'
            AND (sgl08 > 0 OR sgl09 > 0)
            AND sgk07 <> 'X'  #CHI-C80041
          IF l_n3 > 0 THEN
             CALL cl_err('','aec-118',0)
             RETURN FALSE
          END IF
      END IF
      LET l_n4 = 0  #FUN-B10056
      SELECT count(*) INTO l_n4
        FROM shb_file
       WHERE shb05 = p_sgt01
         AND shb06 = p_sgu04
         AND shbacti = 'Y'
         AND shb012 = p_sgu012
         AND shbconf = 'Y'   #FUN-A70095   
       #str----mark by guanyao160811  160811 0:07海洋要求注释
       #IF l_n4 > 0 THEN
       #   CALL cl_err('','aec-119',0)
       #   RETURN FALSE
       #ELSE
       #end----mark by guanyao160811
         SELECT ecm04,ecm06,ecm05,ecm49,ecm14,ecm13,ecm16,ecm15,
         #      ecm52,ecm53,ecm54,ecm55,ecm56,ecm57,ecm58,ecm59,    #FUN-B30019
                ecm52,ecm53,ecm54,ecm55,ecm56,ecm58,                #FUN-B30019 
                ecm50,ecm51,ecm015  #FUN-B10056
               ,ecm62,ecm63,ecm12,ecm34,ecm64        #FUN-B30019 
               ,ecm67          #FUN-B50178    
      INTO g_sgu[l_ac].sgu05,g_sgu[l_ac].sgu06,g_sgu[l_ac].sgu07,
           g_sgu[l_ac].sgu08,g_sgu[l_ac].sgu10,g_sgu[l_ac].sgu11,
           g_sgu[l_ac].sgu12,g_sgu[l_ac].sgu13,g_sgu[l_ac].sgu14,
           g_sgu[l_ac].sgu15,g_sgu[l_ac].sgu16,g_sgu[l_ac].sgu17,
#          g_sgu[l_ac].sgu18,g_sgu[l_ac].sgu19,g_sgu[l_ac].sgu20,    #FUN-B30019
           g_sgu[l_ac].sgu18,g_sgu[l_ac].sgu20,                      #FUN-B30019
#          g_sgu[l_ac].sgu21,g_sgu[l_ac].sgu22,g_sgu[l_ac].sgu23,    #FUN-B30019
           g_sgu[l_ac].sgu22,g_sgu[l_ac].sgu23,                      #FUN-B30019
           g_sgu[l_ac].sgu015   #FUN-B10056
          ,g_sgu[l_ac].sgu43,g_sgu[l_ac].sgu44,g_sgu[l_ac].sgu45,    #FUN-B30019
           g_sgu[l_ac].sgu46,g_sgu[l_ac].sgu47                       #FUN-B30019
          ,g_sgu[l_ac].sgu53      #FUN-B50178 
           FROM ecm_file
          WHERE ecm01 = p_sgt01
            AND ecm03 = p_sgu04
            AND ecm012= p_sgu012
         DISPLAY BY NAME g_sgu[l_ac].sgu05
         DISPLAY BY NAME g_sgu[l_ac].sgu06
         DISPLAY BY NAME g_sgu[l_ac].sgu07
         DISPLAY BY NAME g_sgu[l_ac].sgu08
         DISPLAY BY NAME g_sgu[l_ac].sgu10
         DISPLAY BY NAME g_sgu[l_ac].sgu11
         DISPLAY BY NAME g_sgu[l_ac].sgu12
         DISPLAY BY NAME g_sgu[l_ac].sgu13
         DISPLAY BY NAME g_sgu[l_ac].sgu14
         DISPLAY BY NAME g_sgu[l_ac].sgu15
         DISPLAY BY NAME g_sgu[l_ac].sgu16
         DISPLAY BY NAME g_sgu[l_ac].sgu17
         DISPLAY BY NAME g_sgu[l_ac].sgu18
      #  DISPLAY BY NAME g_sgu[l_ac].sgu19    #FUN-B30019
         DISPLAY BY NAME g_sgu[l_ac].sgu20
      #  DISPLAY BY NAME g_sgu[l_ac].sgu21    #FUN-B30019
#FUN-B30019 -----------------Begin-----------------------
         DISPLAY BY NAME g_sgu[l_ac].sgu43
         DISPLAY BY NAME g_sgu[l_ac].sgu44
         DISPLAY BY NAME g_sgu[l_ac].sgu45
         DISPLAY BY NAME g_sgu[l_ac].sgu46
         DISPLAY BY NAME g_sgu[l_ac].sgu47
#FUN-B30019 -----------------End-------------------------
         DISPLAY BY NAME g_sgu[l_ac].sgu53   #FUN-B50178
         DISPLAY BY NAME g_sgu[l_ac].sgu22
         DISPLAY BY NAME g_sgu[l_ac].sgu23
         DISPLAY BY NAME g_sgu[l_ac].sgu015
         IF g_sgu_t.sgu04 IS NULL THEN
            LET g_sgu[l_ac].sgu33 = NULL
            LET g_sgu[l_ac].sgu34 = NULL
            LET g_sgu[l_ac].sgu35 = NULL
            LET g_sgu[l_ac].sgu27 = NULL
            LET g_sgu[l_ac].sgu29 = NULL
            LET g_sgu[l_ac].sgu30 = NULL
            LET g_sgu[l_ac].sgu31 = NULL
            LET g_sgu[l_ac].sgu32 = NULL
#FUN-B30019 ------------------Begin-----------------------------
            LET g_sgu[l_ac].sgu48 = NULL
            LET g_sgu[l_ac].sgu49 = NULL
            LET g_sgu[l_ac].sgu50 = NULL
            LET g_sgu[l_ac].sgu51 = NULL
            LET g_sgu[l_ac].sgu52 = NULL
#FUN-B30019 ------------------End-------------------------------
         END IF
         IF g_sgu[l_ac].sgu03 IS NULL OR g_sgu[l_ac].sgu03 = '1' THEN
            LET g_sgu[l_ac].sgu03 = '3'
         END IF
       #END IF  #mark by guanyao160811
   END IF
   RETURN l_flag

END FUNCTION
#TQC-AC0093 ---------add end-------------

#FUN-B30019--begin--add----
FUNCTION i720_set_required()
   CALL cl_set_comp_required("sgu24,sgu25,sgu33,sgu34,sgu35,sgu39,sgu41,sgu42,sgu48,sgu49,sgu50,sgu51,sgu52",FALSE)
END FUNCTION
 
FUNCTION i720_set_no_required()

 IF NOT cl_null(g_sgu[l_ac].sgu03) THEN
    IF g_sgu[l_ac].sgu03='1' THEN
       CALL cl_set_comp_required("sgu24,sgu25,sgu33,sgu34,sgu35,sgu39,sgu41,sgu42,sgu48,sgu49,sgu50,sgu51,sgu52",TRUE)
    END IF
 END IF
END FUNCTION
#FUN-B30019--end--add----
#FUN-B50178 -----------Begin----------------
FUNCTION i720_sgu54()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05

   LET g_errno=' '
   SELECT pmcacti,pmc05
     INTO l_pmcacti,l_pmc05
     FROM pmc_file
    WHERE pmc01=g_sgu[l_ac].sgu54
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
        WHEN l_pmc05='3'        LET g_errno='aap-033'
   END CASE
END FUNCTION
#FUN-B50178 -----------End------------------
#FUN-B90141 --START--
#單位轉換率檢查
FUNCTION i720_chk_umf()
DEFINE l_sql     STRING
DEFINE l_sgu04   LIKE sgu_file.sgu04
DEFINE l_sgu20   LIKE sgu_file.sgu20
DEFINE l_sgu43   LIKE sgu_file.sgu43
DEFINE l_sgu44   LIKE sgu_file.sgu44  
DEFINE l_sgu39   LIKE sgu_file.sgu39
DEFINE l_sgu48   LIKE sgu_file.sgu48
DEFINE l_sgu49   LIKE sgu_file.sgu49  
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_fac     LIKE type_file.num26_10
DEFINE l_fac2    LIKE type_file.num26_10
DEFINE l_ima55   LIKE ima_file.ima55
DEFINE l_sfb05   LIKE sfb_file.sfb05
DEFINE l_showmsg STRING

   LET g_success = 'Y'

   CALL s_showmsg_init()

   SELECT sfb05 INTO l_sfb05 FROM sfb_file LEFT JOIN sgt_file 
                              ON sfb01 = sgt01 WHERE sfb01 = g_sgt.sgt01  
   
   SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=l_sfb05 

   LET l_sql = "SELECT sgu04,sgu20,sgu43,sgu44,sgu39,sgu48,sgu49",
                " FROM sgu_file" ,
                " WHERE sgu01 = '",g_sgt.sgt01,"' ",
             "   AND sgu02 = '",g_sgt.sgt02,"' "
   DECLARE sgu_cs1 CURSOR FROM l_sql 
   FOREACH sgu_cs1 INTO l_sgu04,l_sgu20,l_sgu43,l_sgu44,l_sgu39,l_sgu48,l_sgu49
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('sgs05',l_sgu04,'FOREACH sgu_cs1',SQLCA.sqlcode,1)         
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF    
      
      #若無變更帶舊值
      IF cl_null(l_sgu39) THEN LET l_sgu39 = l_sgu20 END IF
      IF cl_null(l_sgu48) THEN LET l_sgu48 = l_sgu43 END IF 
      IF cl_null(l_sgu49) THEN LET l_sgu49 = l_sgu44 END IF
      
      LET l_showmsg = l_sgu04 CLIPPED  , '/', l_sgu39 CLIPPED,
                       '/', l_sgu48 CLIPPED, '/', l_sgu49 CLIPPED
      
      CALL s_umfchk(l_sfb05,l_sgu39,l_ima55)
                            RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL s_errmsg('sgu04,sgu39,sgu48,sgu49',l_showmsg,'s_umfchk',"abm-731",1)
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF
      LET l_fac2 = l_sgu49 / l_sgu48
      IF l_fac != l_fac2 THEN 
         CALL s_errmsg('sgu04,sgu39,sgu48,sgu49',l_showmsg,' ',"aec-069",1)
         LET g_success = 'N'         
         CONTINUE FOREACH 
      END IF    
   END FOREACH 

   IF g_success = 'N' THEN 
      CALL s_showmsg()
      RETURN FALSE 
   END IF 
   RETURN TRUE   
END FUNCTION 
#FUN-B90141 --END--

#FUN-BB0085-add-str-------
FUNCTION i720_sgu50_check() 
   IF NOT cl_null(g_sgu[l_ac].sgu50) THEN 
      IF NOT cl_null(g_sgu[l_ac].sgu39) THEN 
         LET g_sgu[l_ac].sgu50 = s_digqty(g_sgu[l_ac].sgu50,g_sgu[l_ac].sgu39)
      ELSE
         LET g_sgu[l_ac].sgu50 = s_digqty(g_sgu[l_ac].sgu50,g_sgu[l_ac].sgu20)
      END IF
      DISPLAY BY NAME g_sgu[l_ac].sgu50
   END IF

   IF NOT cl_null(g_sgu[l_ac].sgu50) THEN
      IF g_sgu[l_ac].sgu50 < 0 THEN
         CALL cl_err(g_sgu[l_ac].sgu50,'axm-179',1)
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085-add-end-------

#MOD-C80002 add begin--------------------------------
#檢查變更的工藝是否已經產生委外採購單，如已經產生，則不能變更
FUNCTION i720_check_sgu04()
DEFINE l_pmn43  LIKE pmn_file.pmn43,
       l_shy06  LIKE shy_file.shy06,
       l_sgu04  LIKE sgu_file.sgu04
   IF NOT cl_null(g_sgu[l_ac].sgu04) THEN 
      IF g_sgu[l_ac].sgu03 MATCHES '[23]' THEN
         LET l_pmn43 = NULL
         LET l_shy06 = NULL
         SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
          WHERE pmn41 = g_sgt.sgt01
            AND pmn012= g_sgu[l_ac].sgu012 
         SELECT MAX(shy06) INTO l_shy06
           FROM shy_file,shx_file
          WHERE shx01 = shy01
            AND shx07<>'Y'
            AND shy03 = g_sgt.sgt01
         IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
         IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
         IF l_pmn43 > l_shy06 THEN
            LET l_sgu04 = l_pmn43
         ELSE
            LET l_sgu04 = l_shy06
         END IF
         IF l_sgu04 >= g_sgu[l_ac].sgu04 THEN
            CALL cl_err('','aec-094',1)
            RETURN FALSE
         END IF
      END IF
   END IF 
   RETURN TRUE
END FUNCTION 
#MOD-C80002 add end----------------------------------
#No.FUN-9C0077 程式精簡

