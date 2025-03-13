# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi560.4gl
# Descriptions...: 會員基本資料維護作業
# Date & Author..: NO.FUN-960058 08/09/02 By  destiny
# Modify.........: No.FUN-960058 09/06/12 by destiny從歐尚超市移植到標准版
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960081 09/10/22 by dxfwo 栏位的添加与删除 
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No:MOD-A30222 10/03/30 By Smapmin 卡種名稱沒有顯示出來
# Modify.........: No:FUN-A60075 10/06/25 By sunchenxu 新增列印功能
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lpkpos已傳POS否
# Modify.........: No.MOD-AC0212 10/12/18 BY suncx 新增修改時 證件號碼不可以開窗否,輸入格式管控
# Modify.........: No.FUN-B30202 11/04/07 By huangtao 新增會員地址開窗維護和銷售明細查詢 
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:FUN-B80194 11/09/23 By pauline 新增生日月份欄位
# Modify.........: No.FUN-B70075 11/10/26 By nanbing 更新已傳POS否的狀態
# Modify.........: No.FUN-BC0058 11/12/20 By yangxf 原會員分類碼別以不同檔案區分存放,改以同一檔案不同類別區分.
# Modify.........: No.FUN-BC0079 11/12/22 By yuhuabao 加入出生年度/出生月份/出生日期及"紀念日維護" Action
# Modify.........: No:FUN-B90118 12/01/05 By pauline 判斷證件號碼是否為必要欄位,新增自定欄位頁籤,積分異動查詢  
# Modify.........: No:FUN-BC0134 12/01/05 By pauline 新增資料清單Page,以及匯出簡訊傳輸ACTION 
# Modify.........: No:MOD-C30152 12/03/09 By nanbing 輸入lpk03,檢查其證件號,若已存在,提示訊息,但不控卡.
# Modify.........: No:CHI-C30021 12/03/10 By nanbing 使用會員自動編號功能BUG更改
# Modify.........: No:FUN-C50013 12/05/04 By pauline 性別欄位可以為null
# Modify.........: No:FUN-C50090 12/07/10 By yangxf 添加客户编号栏位及相关逻辑
# Modify.........: No:FUN-CA0103 12/10/26 By xumeimei 添加设置密码,重置密码按钮
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C60032 12/06/28 by Lori 紀念日增加判斷lpc05
# Modify.........: No:CHI-C70001 12/07/06 By Elise 畫面檔拿掉"確"圖示
# Modify.........: No:MOD-C80165 12/09/17 By jt_chen 修正FUN-B70075,在FUNCTION i560_u中FUN-B70075加的程式段(更新lpkpos的地方)增加判斷IF g_aza.aza88 = 'Y' THEN才執行
# Modify.........: No:CHI-CC0030 12/12/24 By pauline 將修改會員地址功能改為action呈現
# Modify.........: No:FUN-CC0135 12/12/26 By xumeimei 添加会员是否升等否栏位
# Modify.........: No:TQC-D30037 13/03/13 By SunLM 已有发卡资料的会员不能删除
# Modify.........: No:FUN-D30055 13/03/19 By Sakura 1.會員自動編碼重覆,將取號改到insert前取號
#                                                   2.lpk01 4fd檔不勾選notnull,required、程式段自動控制lpk01欄位notnull,required的值
#                                                   3.新增時單頭"證件種類",預設值給 "2.其他"
#                                                   4.新增aooi010參數判斷是否需走編碼原則,且編碼前先檢查是否已有維護編碼基本資料
#                                                   5.走自動編碼原則時,lpk01設為noentry
# Modify.........: No:FUN-C30180 13/04/08 By Sakura 加入參數使用會員升等/降等否(rcj16)判斷異動會員等級(lpk10)是否可修改


IMPORT os    #FUN-BC0134 add 



DATABASE ds
#No.FUN-960058--begin 
GLOBALS "../../config/top.global"
#No.FUN-960081 


DEFINE g_lpk         RECORD LIKE lpk_file.*,     
       g_lpk_t       RECORD LIKE lpk_file.*,    
       g_lpk_o       RECORD LIKE lpk_file.*,   
       g_lpk01_t     LIKE lpk_file.lpk01,           
       g_lpj         DYNAMIC ARRAY OF RECORD    
          lpj02      LIKE lpj_file.lpj02, 
          lph02      LIKE lph_file.lph02,
          lpj03      LIKE lpj_file.lpj03,
          lpj26      LIKE lpj_file.lpj26,      #FUN-CA0103 add
          lpj04      LIKE lpj_file.lpj04,
          lpj17      LIKE lpj_file.lpj17,
          lpj05      LIKE lpj_file.lpj05,
          lpj09      LIKE lpj_file.lpj09,
          lpj16      LIKE lpj_file.lpj16,
          lpj06      LIKE lpj_file.lpj06,
          lpj08      LIKE lpj_file.lpj08,
          lpj07      LIKE lpj_file.lpj07,
          lpj15      LIKE lpj_file.lpj15,
          lpj11      LIKE lpj_file.lpj11,
          lpj12      LIKE lpj_file.lpj12,
          lpj13      LIKE lpj_file.lpj13,
          lpj14      LIKE lpj_file.lpj14,
          lpj25      LIKE lpj_file.lpj25, 
          lpjpos     LIKE lpj_file.lpjpos       #FUN-A30030 ADD
                     END RECORD,
       g_lpj_t       RECORD      
          lpj02      LIKE lpj_file.lpj02, 
          lph02      LIKE lph_file.lph02,
          lpj03      LIKE lpj_file.lpj03,
          lpj26      LIKE lpj_file.lpj26,      #FUN-CA0103 add
          lpj04      LIKE lpj_file.lpj04,
          lpj17      LIKE lpj_file.lpj17,
          lpj05      LIKE lpj_file.lpj05,
          lpj09      LIKE lpj_file.lpj09,
          lpj16      LIKE lpj_file.lpj16,
          lpj06      LIKE lpj_file.lpj06,
          lpj08      LIKE lpj_file.lpj08,
          lpj07      LIKE lpj_file.lpj07,
          lpj15      LIKE lpj_file.lpj15,
          lpj11      LIKE lpj_file.lpj11,
          lpj12      LIKE lpj_file.lpj12,
          lpj13      LIKE lpj_file.lpj13,
          lpj14      LIKE lpj_file.lpj14,
          lpj25      LIKE lpj_file.lpj25,
          lpjpos     LIKE lpj_file.lpjpos       #FUN-A30030 ADD   
                     END RECORD,              
        g_lpj_o      RECORD         
          lpj02      LIKE lpj_file.lpj02, 
          lph02      LIKE lph_file.lph02,
          lpj03      LIKE lpj_file.lpj03,
          lpj26      LIKE lpj_file.lpj26,      #FUN-CA0103 add
          lpj04      LIKE lpj_file.lpj04,
          lpj17      LIKE lpj_file.lpj17,
          lpj05      LIKE lpj_file.lpj05,
          lpj09      LIKE lpj_file.lpj09,
          lpj16      LIKE lpj_file.lpj16,
          lpj06      LIKE lpj_file.lpj06,
          lpj08      LIKE lpj_file.lpj08,
          lpj07      LIKE lpj_file.lpj07,
          lpj15      LIKE lpj_file.lpj15,
          lpj11      LIKE lpj_file.lpj11,
          lpj12      LIKE lpj_file.lpj12,
          lpj13      LIKE lpj_file.lpj13,
          lpj14      LIKE lpj_file.lpj14,
          lpj25      LIKE lpj_file.lpj25,
          lpjpos     LIKE lpj_file.lpjpos       #FUN-A30030 ADD     
                     END RECORD,       
       g_sql         STRING,                      
       g_wc          STRING,                       
       g_wc2         STRING,                     
       g_rec_b       LIKE type_file.num5,        
       l_ac          LIKE type_file.num5           
#FUN-BC0079 -----add----- begin
DEFINE g_lpa         DYNAMIC ARRAY OF RECORD
          lpa02      LIKE lpa_file.lpa02,
          lpc02      LIKE lpc_file.lpc02,
          lpa03      LIKE lpa_file.lpa03,
          lpaacti    LIKE lpa_file.lpaacti
                     END RECORD,
       g_lpa_t       RECORD
          lpa02      LIKE lpa_file.lpa02,
          lpc02      LIKE lpc_file.lpc02,
          lpa03      LIKE lpa_file.lpa03,
          lpaacti    LIKE lpa_file.lpaacti
                     END RECORD,
       g_rec_b2      LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_rcj04       LIKE rcj_file.rcj04
DEFINE g_rcj16       LIKE rcj_file.rcj16 #FUN-C30180
#FUN-BC0079 -----add----- end
DEFINE g_forupd_sql        STRING                 
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE g_no_ask           LIKE type_file.num5  
DEFINE g_void              LIKE type_file.chr1
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_argv1             LIKE lpk_file.lpk01   #FUN-B90118 add
DEFINE g_argv2             LIKE type_file.chr1   #FUN-B90118 add
#FUN-BC0134 add START
DEFINE g_lpk_1     DYNAMIC ARRAY OF RECORD
           lpk01_1         LIKE lpk_file.lpk01,
           lpk04_1         LIKE lpk_file.lpk04,
           lpk05_1         LIKE lpk_file.lpk05,
           lpk06_1         LIKE lpk_file.lpk06,
           lpk10_1         LIKE lpk_file.lpk10,
           lpk13_1         LIKE lpk_file.lpk13,
           lpk18_1         LIKE lpk_file.lpk18
                   END RECORD
DEFINE g_phone    DYNAMIC ARRAY OF RECORD
           phone           STRING
                   END RECORD
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE l_ac1               LIKE type_file.num5
DEFINE g_i3                LIKE type_file.num5
DEFINE g_phone_num         STRING
DEFINE g_inTransaction     LIKE type_file.num5   #CHI-C30021 #是否要做事務開始關閉的指標
#FUN-BC0134 add END

#CHI-C30021 MARK STA---
#MAIN 
#   OPTIONS                               
#        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
#   DEFER INTERRUPT              
 
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF

#   LET g_argv1 = ARG_VAL(1)   #會員代號   #FUN-B90118 add
#   LET g_argv2 = ARG_VAL(2)   #flag       #FUN-B90118 add
 
#   WHENEVER ERROR CALL cl_err_msg_log
 
#   IF (NOT cl_setup("ALM")) THEN
#      EXIT PROGRAM
#   END IF 
  
#   CALL cl_used(g_prog,g_time,1) RETURNING g_time
#CHI-C30021 MARK END ---
#CHI-C30021 ADD STA ---
FUNCTION i560(p_argv1,p_argv2,p_inTransaction)
DEFINE p_argv1             LIKE lpk_file.lpk01   
DEFINE p_argv2             LIKE type_file.chr1  
DEFINE p_inTransaction     LIKE type_file.num5
   WHENEVER ERROR CONTINUE  
   LET g_inTransaction = p_inTransaction 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
#CHI-C30021 ADD END ---
 
#FUN-BC0079 -----add----- begin
   SELECT rcj04,rcj16 INTO g_rcj04,g_rcj16 FROM rcj_file #FUN-C30180 add rch16
    WHERE rcj00 = '0'
#FUN-BC0079 -----add----- end
   LET g_forupd_sql = "SELECT * FROM lpk_file WHERE lpk01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i560_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i560_w WITH FORM "alm/42f/almi560"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 


  #FUN-A30030 ADD------------------------- 
   IF g_aza.aza88='Y' THEN
      CALL cl_set_comp_visible('lpjpos,lpkpos',TRUE)               #FUN-A80022 add lpkpos by vealxu
   ELSE
      CALL cl_set_comp_visible('lpjpos,lpkpos',FALSE)              #FUN-A80022 add lpkpos by vealxu
   END IF 
  #FUN-A30030 END------------------------
   CALL cl_ui_init()  
   CALL cl_set_comp_visible('lpk051,lpk052,lpk053',FALSE)   #FUN-B80194 add #FUN-BC0079 add lpk052 lpk053

#FUN-B90118 add START-------------------------
   IF NOT (cl_null(g_argv1)) AND (g_argv2 <> 'Y' OR cl_null(g_argv2)) THEN
      CALL i560_a()
   END IF
   IF NOT (cl_null(g_argv1)) AND g_argv2 = 'Y'  THEN                      
      CALL i560_q()
   END IF
   IF cl_null(g_argv1) AND g_argv2 = 'N' THEN
      CALL i560_a()
   END IF
  #    LET g_argv1 = '' #CHI-C30021 mark 
  #    LET g_argv2 = '' #CHI-C30021 mark
#FUN-B90118 add END---------------------------

   CALL i560_menu()
   
   CLOSE WINDOW i560_w
   #CHI-C30021 add STAR---
   IF cl_null(p_argv1) AND p_argv2 = 'N' THEN
      RETURN g_lpk.lpk01
   END IF 
   #CHI-C30021 add END---
END FUNCTION  #CHI-C30021 add  
 

   
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time #CHI-C30021 MARK
 
#END MAIN #CHI-C30021 MARK

 
FUNCTION i560_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_lpj.clear()  
   #CHI-C30021 STA
   IF NOT cl_null(g_argv1)THEN
      LET g_wc = "lpk01 = '",g_argv1,"'" 
      LET g_wc2 = " 1=1"
   ELSE
   #CHI-C30021 END
      CALL cl_set_head_visible("","YES")  
      CALL cl_set_comp_visible('lpk051,lpk052,lpk053',TRUE)    #FUN-B80194 add #FUN-BC0079 add lpk052 lpk053
      INITIALIZE g_lpk.* TO NULL     
      CONSTRUCT BY NAME g_wc ON lpk01,lpk02,lpk03,lpk04,lpk05,lpk051,lpk052,lpk053,lpk06,lpk07,lpk08,lpk09,lpk10,              #FUN-B80194 add lpk051 #FUN-BC0079 add lpk052 lpk053
                                lpk11,lpk12,lpk13,lpk14,lpk15,lpk16,lpk17,lpk18,lpk19,lpkpos,lpk20,lpk21,lpkuser,     #FUN-A80022 add lpkpos by vealxu #FUN-C50090 add lpk20 #FUN-CC0135 add lpk21
#                               lpkgrup,lpkmodu,lpkdate,lpkacti,lpkcrat,lpkorig,lpkoriu,     #No.FUN-9B0136  #FUN-C50090 mark
                                lpkgrup,lpkoriu,lpkorig,lpkmodu,lpkdate,lpkacti,lpkcrat,     #FUN-C50090 add 
#FUN-B90118 add START-----------------------------------------
                                lpkud01,lpkud02,lpkud03,lpkud04,lpkud05,
                                lpkud06,lpkud07,lpkud08,lpkud09,lpkud10,
                                lpkud11,lpkud12,lpkud13,lpkud14,lpkud15
#FUN-B90118 add END------------------------------------------  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()       
         
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpk01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk01
                  NEXT FIELD lpk01           
      
               WHEN INFIELD(lpk03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk03
                  NEXT FIELD lpk03  
                
               WHEN INFIELD(lpk08) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk08
                  NEXT FIELD lpk08   
                       
               WHEN INFIELD(lpk09) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk09"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk09
                  NEXT FIELD lpk09 
                  
               WHEN INFIELD(lpk10) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk10
                  
               WHEN INFIELD(lpk11) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk11                  
                  NEXT FIELD lpk11  
                  
               WHEN INFIELD(lpk12) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk12  
                  
               WHEN INFIELD(lpk13) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk13
                  
               WHEN INFIELD(lpk14) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk14"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk14                                                                                 

#FUN-C50090 add begin ---
               WHEN INFIELD(lpk20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpk20"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk20
#FUN-C50090 add end ---

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
      
        
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
      END CONSTRUCT
      
      IF INT_FLAG THEN
         CALL cl_set_comp_visible('lpk051,lpk052,lpk053',FALSE)   #FUN-B80194 add #FUN-BC0079 add lpk052 lpk053
         RETURN
      END IF
  
   
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                         
   #      LET g_wc = g_wc clipped," AND lpkuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                 
   #      LET g_wc = g_wc clipped," AND lpkgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    
   #      LET g_wc = g_wc clipped," AND lpkgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpkuser', 'lpkgrup')
   #End:FUN-980030
 
 
      CONSTRUCT g_wc2 ON lpj02,lph02,lpj03,lpj26,lpj04,lpj17,lpj05,lpj09,lpj16,lpj06,lpj08,lpj07,lpj15,  #FUN-CA0103 add lpj26
                         lpj11,lpj12,lpj13,lpj14,lpj25,lpjpos                                 #FUN-A30030 ADD
              FROM s_lpj[1].lpj02,s_lpj[1].lph02,s_lpj[1].lpj03,s_lpj[1].lpj26,s_lpj[1].lpj04,s_lpj[1].lpj17,s_lpj[1].lpj05,  #FUN-CA0103 add lpj26
                   s_lpj[1].lpj09,s_lpj[1].lpj16,s_lpj[1].lpj06,s_lpj[1].lpj08,s_lpj[1].lpj07,
                   s_lpj[1].lpj15,s_lpj[1].lpj11,s_lpj[1].lpj12,s_lpj[1].lpj13,
                   s_lpj[1].lpj14,s_lpj[1].lpj25,s_lpj[1].lpjpos                             #FUN-A30030 ADD               
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_lpj02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpj02
                  NEXT FIELD lpj02
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
    
        
         ON ACTION qbe_save
            CALL cl_qbe_save()
         
      END CONSTRUCT
   
      IF INT_FLAG THEN
         CALL cl_set_comp_visible('lpk051,lpk052,lpk053',FALSE)   #FUN-B80194 add #FUN-BC0079 add lpk052 lpk053
         RETURN
      END IF
  
   END IF #CHI-C30021 add
   LET g_wc2 = g_wc2 CLIPPED
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lpk01 FROM lpk_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY lpk01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lpk01 ",
                  "  FROM lpk_file, lpj_file ",
                  " WHERE lpk01 = lpj01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lpk01"
   END IF
 
   PREPARE i560_prepare FROM g_sql
   DECLARE i560_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i560_prepare

   DECLARE i560_list_cur CURSOR FOR i560_prepare   #FUN-BC0134 add
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lpk_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lpk01) FROM lpk_file,lpj_file WHERE ",
                "lpk01 = lpj01 and ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i560_precount FROM g_sql
   DECLARE i560_count CURSOR FOR i560_precount
   CALL cl_set_comp_visible('lpk051,lpk052,lpk053',FALSE)   #FUN-B80194 add #FUN-BC0079 add lpk052 lpk053
 
END FUNCTION
 
FUNCTION i560_menu()                      
DEFINE l_msg        LIKE type_file.chr1000
DEFINE l_lph46      LIKE lph_file.lph46 

   WHILE TRUE
      CALL i560_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i560_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i560_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i560_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i560_u('u')
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i560_x()
            END IF
         # FUN-A60075 begin      
         WHEN "output"
            CALL i560_out()

         # FUN-A60075 end   
 
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL i560_copy()
#            END IF 
                                                
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpj),'','')
            END IF

#FUN-B30202 ------------STA
         WHEN "sales_detail"
              IF cl_chk_act_auth() THEN
                 CALL i560_sales()
              END IF
#FUN-B30202 ------------END

#FUN-BC0079 -----add------ begin
         WHEN "commemoration_day"
            IF cl_chk_act_auth() THEN
               CALL i560_commemorate()
            END IF
#FUN-BC0079 -----add------ end
 
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lpk.lpk01 IS NOT NULL THEN
                 LET g_doc.column1 = "lpk01"
                 LET g_doc.value1 = g_lpk.lpk01
                 CALL cl_doc()
               END IF
         END IF  
#FUN-B90118 add START-----------------------------------------
         WHEN "point_trans"
              IF cl_chk_act_auth() THEN
                 CALL i560_trans() 
              END IF
#FUN-B90118 add END------------------------------------------
       
#FUN-BC0134 add START
         WHEN "ex_phone_num"
              IF cl_chk_act_auth() THEN
                 CALL i560_phone()
              END IF
#FUN-BC0134 add END
#FUN-CA0103----------add------str
         WHEN "passwd"
            IF cl_chk_act_auth() THEN
               IF g_rec_b > 0 THEN
                  SELECT lph46 INTO l_lph46
                    FROM lph_file
                   WHERE lph01 = g_lpj[l_ac].lpj02
                  IF l_lph46 <> 'Y' THEN
                     CALL cl_err('','alm1385',0)
                  ELSE
                     CALL si621_set('1','2',g_lpj[l_ac].lpj03,NULL,'2',FALSE)
                     CALL i560_b_fill(" 1=1")
                  END IF
               END IF
            END IF
         WHEN "resetpasswd"
            IF cl_chk_act_auth() THEN
               IF g_rec_b > 0 THEN
                  SELECT lph46 INTO l_lph46
                    FROM lph_file
                   WHERE lph01 = g_lpj[l_ac].lpj02
                  IF l_lph46 <> 'Y' THEN
                     CALL cl_err('','alm1385',0)
                  ELSE
                     CALL si621_set('2','2',g_lpj[l_ac].lpj03,NULL,'2',FALSE)
                     CALL i560_b_fill(" 1=1")
                  END IF
               END IF
            END IF
#FUN-CA0103----------add------end
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i560_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-BC0134 add
  #DISPLAY ARRAY g_lpj TO s_lpj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   DISPLAY ARRAY g_lpj TO s_lpj.* ATTRIBUTE(COUNT=g_rec_b)  #FUN-BC0134 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #CHI-C30021 STA---
         IF (cl_null(g_argv1) AND g_argv2 ='N') 
            OR( NOT cl_null(g_argv1) AND cl_null(g_argv2)) THEN 
            CALL DIALOG.setActionActive( "insert", 0 )
            CALL DIALOG.setActionActive( "query", 0 )
            CALL DIALOG.setActionActive( "invalid", 0 )
            CALL DIALOG.setActionActive( "output", 0 )
            CALL DIALOG.setActionActive( "exporttoexcel", 0 )
         END IF   
         #CHI-C30021 STA--- 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  

#FUN-BC0134 mark START 
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
#
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#
#     ON ACTION delete
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#
#     ON ACTION modify
#        LET g_action_choice="modify"
#        EXIT DISPLAY   
#                               
#     ON ACTION first
#        CALL i560_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        CALL fgl_set_arr_curr(1)
#        ACCEPT DISPLAY  
#
#     ON ACTION previous
#        CALL i560_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        CALL fgl_set_arr_curr(1)
#        ACCEPT DISPLAY 
#
#     ON ACTION jump
#        CALL i560_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        CALL fgl_set_arr_curr(1)
#        ACCEPT DISPLAY   
#
#     ON ACTION next
#        CALL i560_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        CALL fgl_set_arr_curr(1)
#        ACCEPT DISPLAY   
#
#     ON ACTION last
#        CALL i560_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        CALL fgl_set_arr_curr(1)
#        ACCEPT DISPLAY   
#
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
#     # FUN-A60075 begin   
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#     # FUN-A60075 end
#
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
#
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY     
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()          
#      
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
#
#     ON ACTION cancel
#        LET INT_FLAG=FALSE         
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about       
#        CALL cl_about()    

#FUN-B90118 add START-----------------------------------------
#     ON ACTION point_trans
#        LET g_action_choice="point_trans"
#        EXIT DISPLAY
#FUN-B90118 add END------------------------------------------
#
#     ON ACTION exporttoexcel     
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#    
#     AFTER DISPLAY
#        CONTINUE DISPLAY    

#FUN-B30202 ------------STA
#     ON ACTION sales_detail 
#        LET g_action_choice="sales_detail"          
#        EXIT DISPLAY 
#FUN-B30202 ------------END

#FUN-BC0079 -----add----- begin
#     ON ACTION commemoration_day
#        LET g_action_choice="commemoration_day"
#        EXIT DISPLAY
#FUN-BC0079 -----add----- end

#     ON ACTION related_document              
#        LET g_action_choice="related_document"          
#        EXIT DISPLAY 
#FUN-BC0134 mark END         

   END DISPLAY

#FUN-BC0134 add START
      DISPLAY ARRAY g_lpk_1 TO s_lpk_1.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #CHI-C30021 STA---
            IF (cl_null(g_argv1) AND g_argv2 ='N') 
              OR ( NOT cl_null(g_argv1) AND cl_null(g_argv2)) THEN 
               CALL DIALOG.setActionActive( "insert", 0 )
               CALL DIALOG.setActionActive( "query", 0 )
               CALL DIALOG.setActionActive( "invalid", 0 )
               CALL DIALOG.setActionActive( "output", 0 )
               CALL DIALOG.setActionActive( "exporttoexcel", 0 )
            END IF 
            #CHI-C30021 STA--- 
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         CALL i560_fetch('/')
         CALL ui.interface.refresh()       
         EXIT DIALOG

      END DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG 

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG 

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG 

      ON ACTION first
         CALL i560_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL i560_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL i560_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION next
         CALL i560_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION last
         CALL i560_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 
      # FUN-A60075 begin
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG 
      # FUN-A60075 end

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG  

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()

#FUN-B90118 add START-----------------------------------------
      ON ACTION point_trans
         LET g_action_choice="point_trans"
         EXIT DIALOG 
#FUN-B90118 add END------------------------------------------

#FUN-BC0134 add START
      ON ACTION ex_phone_num
         LET g_action_choice="ex_phone_num"
         EXIT DIALOG

#FUN-BC0134 add END

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 


#FUN-B30202 ------------STA
      ON ACTION sales_detail
         LET g_action_choice="sales_detail"
         EXIT DIALOG 
#FUN-B30202 ------------END

#FUN-BC0079 -----add----- begin
      ON ACTION commemoration_day
         LET g_action_choice="commemoration_day"
         EXIT DIALOG 
#FUN-BC0079 -----add----- end

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
  
#FUN-CA0103-----add-----str 
      ON ACTION passwd
         LET g_action_choice="passwd"
         EXIT DIALOG
      ON ACTION resetpasswd
         LET g_action_choice="resetpasswd"
         EXIT DIALOG
#FUN-CA0103-----add-----end
   END DIALOG
#FUN-BC0134 add END

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i560_bp_refresh()
  DISPLAY ARRAY g_lpj TO s_lpj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i560_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
   DEFINE l_name      LIKE ima_file.ima02         #FUN-B30202 add
   DEFINE l_cnt       LIKE type_file.num10        #FUN-D30055 add
   DEFINE l_cnt1      LIKE type_file.num10        #FUN-D30055 add

#FUN-BC0079 -----add----- begin for 判斷會員生日代碼(rcj04)參數是否有設定
   IF cl_null(g_rcj04) THEN
      CALL cl_err('','alm1455',1)
      RETURN
   END IF  
#FUN-BC0079 -----add----- end 
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL g_lpj.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lpk.* LIKE lpk_file.*         
   LET g_lpk01_t = NULL
 
   LET g_lpk_t.* = g_lpk.*
   LET g_lpk_o.* = g_lpk.*
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lpk.lpk21 = 'Y'      #FUN-CC0135 add
      LET g_lpk.lpkuser=g_user
      LET g_lpk.lpkoriu = g_user #FUN-980030
      LET g_lpk.lpkorig = g_grup #FUN-980030
      LET g_lpk.lpkcrat=g_today
      LET g_lpk.lpkgrup=g_grup
      LET g_lpk.lpkacti='Y'              #資料有效
      LET g_lpk.lpk02 = '2'    #證件種類2.其他 #FUN-D30055 add
#FUN-C50090 add begin ---
      SELECT rtz06 INTO g_lpk.lpk20      #带出arti200中散客编号
        FROM rtz_file
       WHERE rtz01 = g_plant
      IF NOT cl_null(g_lpk.lpk20) THEN
         CALL i560_lpk20('d')
      END IF
#FUN-C50090 add end -----
      #LET g_lpk.lpkpos = 'N'             #FUN-A80022 add by vealxu
      LET g_lpk.lpkpos = '1' #NO.FUN-B40071
#FUN-D30055---mark---START
#     # IF cl_null(g_argv1) AND g_argv2 = 'N' THEN  #FUN-B90118 add  #CHI-C30021 MARK
#      IF cl_null(g_argv1) AND (g_argv2 = 'N' OR cl_null(g_argv2)) THEN  #CHI-C30021 add
##FUN-B30202 ------------STA
#         IF g_aza.aza109 = 'Y' THEN
#            IF cl_null(g_lpk.lpk01) THEN
#               CALL s_auno(g_lpk.lpk01,'8','') RETURNING g_lpk.lpk01,l_name  
#            END IF
#         END IF
##FUN-B30202 ------------END 
#      END IF   #FUN-B90118 add
#FUN-D30055---mark-----END

#FUN-D30055---add---START
      IF g_aza.aza109 = 'Y' THEN
         SELECT count(*) INTO l_cnt FROM geh_file WHERE geh04='8' AND gehacti='Y' 
         SELECT count(*) INTO l_cnt1 FROM geh_file,gei_file,gef_file
          WHERE geh01 = gei03
            AND gei01= gef01
            AND geh04='8'
            AND gehacti='Y'
         IF l_cnt<=0 OR l_cnt1<=0 THEN
            CALL cl_err("","alm-a04",0)
            RETURN 
         END IF
      END IF 
#FUN-D30055---add-----END
      CALL i560_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                  
         INITIALIZE g_lpk.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF cl_null(g_lpk.lpk01) THEN    
         CONTINUE WHILE
      END IF
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         BEGIN WORK
      END IF   #CHI-C30021 add
     #FUN-C50013 add START
      IF cl_null(g_lpk.lpk06) THEN
         LET g_lpk.lpk06 = ''
      END IF
     #FUN-C50013 add END 
      INSERT INTO lpk_file VALUES (g_lpk.*)    
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK       # FUN-B80060---回滾放在報錯後---
         CALL cl_err3("ins","lpk_file",g_lpk.lpk01,"",SQLCA.sqlcode,"","",1) 
         IF NOT g_inTransaction THEN #CHI-C30021 add 
            ROLLBACK WORK        # FUN-B80060--add--
         END IF   #CHI-C30021 add    
         CONTINUE WHILE
      ELSE
#FUN-BC0079 -----add----- begin for 自動新增一筆資料至會員紀念日檔
         INSERT INTO lpa_file(lpa01,lpa02,lpa03,lpa04,lpa05,lpa06,
                              lpaacti,lpauser,lpagrup,lpaoriu,lpaorig)
         VALUES(g_lpk.lpk01,g_rcj04,g_lpk.lpk05,g_lpk.lpk051,g_lpk.lpk052,
                g_lpk.lpk053,g_lpk.lpkacti,g_lpk.lpkuser,g_lpk.lpkgrup,
                g_lpk.lpkoriu,g_lpk.lpkorig)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lpa_file",g_lpk.lpk01,"",SQLCA.sqlcode,"","",1)
            IF NOT g_inTransaction THEN #CHI-C30021 add 
               ROLLBACK WORK
            END IF   #CHI-C30021 add       
            CONTINUE WHILE
         ELSE
#FUN-BC0079 -----add----- end
            IF NOT g_inTransaction THEN #CHI-C30021 add
               COMMIT WORK
            END IF   #CHI-C30021 add
         END IF      #FUN-BC0079 add
      END IF
 
      SELECT lpk01 INTO g_lpk.lpk01 FROM lpk_file
       WHERE lpk01 = g_lpk.lpk01
      LET g_lpk01_t = g_lpk.lpk01        #保留舊值
      LET g_lpk_t.* = g_lpk.*
      LET g_lpk_o.* = g_lpk.*
      CALL g_lpj.clear()
 
      LET g_rec_b = 0  
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i560_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    l_n1        LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_rtz13     LIKE rtz_file.rtz13   #FUN-A80148
DEFINE    l_rtz28     LIKE rtz_file.rtz28   #FUN-A80148
DEFINE    l_lph24     LIKE lph_file.lph24
DEFINE    l_lph03     LIKE lph_file.lph03 
DEFINE    l_lmf03     LIKE lmf_file.lmf03
DEFINE    l_lmf04     LIKE lmf_file.lmf04
DEFINE    i           LIKE type_file.num5   #MOD-AC0212
DEFINE    l_lpk19     STRING                #MOD-AC0212
DEFINE    l_cnt       LIKE type_file.num5   #FUN-B90118 add
DEFINE    l_n2        LIKE type_file.num10  #MOD-C30152 add 
DEFINE    l_name      LIKE ima_file.ima02   #FUN-D30055 add 
DEFINE    l_lpj07     LIKE lpj_file.lpj07   #FUN-C30180 add 
DEFINE    l_lpj15     LIKE lpj_file.lpj15   #FUN-C30180 add 
   IF s_shut(0) THEN
      RETURN
   END IF
#FUN-D30055---add---START 
   IF g_aza.aza109 = 'Y' THEN
      IF p_cmd = 'a' THEN
         CALL i560_set_attr("lpk01",FALSE)
         CALL cl_set_comp_entry("lpk01", FALSE)
      END IF    
   END IF
#FUN-D30055---add-----END

   DISPLAY BY NAME  g_lpk.lpkuser,g_lpk.lpkmodu,g_lpk.lpkgrup,g_lpk.lpkdate,
                    g_lpk.lpkacti,g_lpk.lpkcrat, g_lpk.lpkpos,g_lpk.lpk20,g_lpk.lpk21   #FUN-B70075加 lpkpos 欄位      #FUN-C50090 add lpk20栏位  #FUN-CC0135 add lpk21欄位
  
   INPUT BY NAME g_lpk.lpk01,g_lpk.lpk02,g_lpk.lpk03,g_lpk.lpk04,g_lpk.lpk05, g_lpk.lpkoriu,g_lpk.lpkorig,
                 g_lpk.lpk06,g_lpk.lpk07,g_lpk.lpk08,g_lpk.lpk09,g_lpk.lpk10,
                 g_lpk.lpk11,g_lpk.lpk12,g_lpk.lpk13,g_lpk.lpk14,g_lpk.lpk15, 
                 g_lpk.lpk16,g_lpk.lpk17,g_lpk.lpk18,g_lpk.lpk19,g_lpk.lpk20,g_lpk.lpk21   #FUN-C50090 add lpk20欄位   #FUN-CC0135 add lpk21欄位
#FUN-B90118 add START-----------------------------------------
                ,g_lpk.lpkud01,g_lpk.lpkud02,g_lpk.lpkud03,g_lpk.lpkud04,
                 g_lpk.lpkud05,g_lpk.lpkud06,g_lpk.lpkud07,g_lpk.lpkud08,
                 g_lpk.lpkud09,g_lpk.lpkud10,g_lpk.lpkud11,g_lpk.lpkud12,
                 g_lpk.lpkud13,g_lpk.lpkud14,g_lpk.lpkud15
#FUN-B90118 add END------------------------------------------
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
        #CALL i560_set_entry(p_cmd) #FUN-D30055 mark
         CALL i560_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         #LET g_lpk.lpkpos = 'N'     #FUN-A80022 add 已傳POS否      
         #NO.FUN-B40071 --START--
         #LET g_lpk.lpkpos = 'N'
         #FUN-B70075 Begin Mark------
         #IF g_lpk.lpkpos <> '1' THEN
         #   LET g_lpk.lpkpos = '2' 
         #END IF 
         #FUN-B70075  End Mark-------
         #NO.FUN-B40071 --START--
#FUN-B90118 add
         IF p_cmd = 'a' THEN  #CHI-C30021 add
            IF cl_null(g_argv2) AND NOT cl_null(g_argv1) THEN
               SELECT COUNT(*) INTO l_cnt FROM lpk_file WHERE lpk01 = g_argv1
               IF l_cnt > 0 THEN
                  CALL cl_err3("ins","lpk_file",g_argv1,"",'-239',"","",1)
               END IF
            END IF      
            IF NOT cl_null(g_argv1) AND cl_null(g_argv2)  AND l_cnt = 0 THEN  
               CALL cl_set_comp_entry("lpk01", FALSE)
               LET g_lpk.lpk01 = g_argv1
               DISPLAY BY NAME g_lpk.lpk01
            END IF
         END IF    #CHI-C30021 add
         
#FUN-B90118 add
         #CHI-C30021 STA---#不可以更改lpk01
         IF p_cmd = 'u' AND NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
            CALL cl_set_comp_entry("lpk01", FALSE)
         END IF 
         #CHI-C30021 END ---
        #CHI-CC0030 add START
         IF g_aza.aza26 <> '0' THEN
            CALL cl_set_act_visible("mem_addr", FALSE)
         END IF
        #CHI-CC0030 add END

    AFTER FIELD lpk01
        IF g_aza.aza109 = 'N' THEN  #FUN-D30055 add
           IF NOT cl_null(g_lpk.lpk01) THEN                                                                                          
              IF p_cmd = "a" OR                                                                                                      
                 (p_cmd="u" AND g_lpk.lpk01 != g_lpk_t.lpk01) THEN                                                                       
                  SELECT count(*) INTO l_n FROM lpk_file 
                    WHERE lpk01=g_lpk.lpk01      
                 IF l_n>0 THEN 
                    CALL cl_err('','-239',1)                                                                            
                    LET g_lpk.lpk01 = g_lpk_t.lpk01                                                                                 
                    DISPLAY BY NAME g_lpk.lpk01                                                                                     
                    NEXT FIELD lpk01
                 END IF                                                                                                                                                                          
              END IF   
           END IF 
        END IF     #FUN-D30055 add

#FUN-B90118 add START
      AFTER FIELD lpk02
         IF g_lpk.lpk02 <> '2' THEN
            CALL cl_set_comp_required("lpk03",TRUE)
         ELSE
            CALL cl_set_comp_required("lpk03",FALSE)
         END IF
       ON CHANGE lpk02
         IF g_lpk.lpk02 <> '2' THEN
            CALL cl_set_comp_required("lpk03",TRUE)
         ELSE
            CALL cl_set_comp_required("lpk03",FALSE)
         END IF
#FUN-B90118 add END

#FUN-B80194 add START
      AFTER FIELD lpk05
          IF NOT cl_null(g_lpk.lpk05) THEN
             LET g_lpk.lpk051 = YEAR(g_lpk.lpk05)   #FUN-BC0079 modify MONTH->YEAR
             LET g_lpk.lpk052 = MONTH(g_lpk.lpk05)  #FUN-BC0079 add
             LET g_lpk.lpk053 = DAY(g_lpk.lpk05)    #FUN-BC0079 add
          END IF

#FUN-B80194 add END

#FUN-B30202 -----------STA
      AFTER FIELD lpk03
         IF g_aza.aza26 = '0' AND  g_lpk.lpk02 = '0' THEN
            IF NOT cl_null(g_lpk.lpk03) THEN
               IF NOT s_chkidn(g_lpk.lpk03) THEN
                  CALL cl_err('','alm-860',0)
                  NEXT FIELD lpk03
               END IF
            END IF 
         END IF
#FUN-B30202 -----------END          
#MOD-C30152 STA---
         IF NOT cl_null(g_lpk.lpk03) THEN
            SELECT COUNT(*) INTO l_n2 FROM lpk_file
             WHERE lpk03 = g_lpk.lpk03
            IF l_n2 > 0 THEN
               CALL cl_err('','alm1600',0)
            END IF 
         END IF
#MOD-C30152 END---         
      AFTER FIELD lpk08   
          IF NOT cl_null(g_lpk.lpk08) THEN 
#            CALL i560_lpk08(p_cmd)            #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk08,'d',1)  #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk08 = g_lpk_t.lpk08
                NEXT FIELD lpk08
             END IF 
          ELSE 
#          	 DISPLAY '' TO lpa02          #FUN-BC0058 mark
                 DISPLAY '' TO lpc02          #FUN-BC0058 add
          END IF 
          
      AFTER FIELD lpk09   
          IF NOT cl_null(g_lpk.lpk09) THEN 
#            CALL i560_lpk09(p_cmd)            #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk09,'d',5)  #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk09 = g_lpk_t.lpk09
                NEXT FIELD lpk09
             END IF 
          ELSE 
#          	 DISPLAY '' TO lpe02          #FUN-BC0058 mark
                 DISPLAY '' TO lpc02_1        #FUN-BC0058 add
          END IF   
             
      AFTER FIELD lpk10   
          IF NOT cl_null(g_lpk.lpk10) THEN 
#            CALL i560_lpk10(p_cmd)             #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk10,'d',6) #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk10 = g_lpk_t.lpk10
                NEXT FIELD lpk10
             END IF 
#FUN-C30180---add---START 
             IF p_cmd = 'u' AND g_rcj16 = 'Y' AND g_lpk.lpk10 <> g_lpk_t.lpk10 THEN
                SELECT SUM(lpj07),SUM(lpj15) INTO l_lpj07,l_lpj15 FROM lpj_file WHERE lpj01 = g_lpk.lpk01
                IF l_lpj07 > 0 OR l_lpj15 > 0  THEN
                   CALL cl_err('','alm-a05',0)
                   LET g_lpk.lpk10 = g_lpk_t.lpk10
                   DISPLAY BY NAME g_lpk.lpk10
                   NEXT FIELD lpk10 
                END IF   
             END IF
#FUN-C30180---add-----END
          ELSE 
#          	 DISPLAY '' TO lpf02          #FUN-BC0058 mark
                 DISPLAY '' TO lpc02_2        #FUN-BC0058 add
          END IF   
          
      AFTER FIELD lpk11   
          IF NOT cl_null(g_lpk.lpk11) THEN 
#            CALL i560_lpk11(p_cmd)             #FUN-BC0058 mark
             CALL i560_lpk11(g_lpk.lpk11,'d')   #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk11 = g_lpk_t.lpk11
                NEXT FIELD lpk11
             END IF 
          ELSE
#          	 DISPLAY '' TO lpc02           #FUN-BC0058 mark
          	 DISPLAY '' TO lpc03           
                 DISPLAY '' TO lpc04           #FUN-BC0058 add 
          END IF       
          
      AFTER FIELD lpk12   
          IF NOT cl_null(g_lpk.lpk12) THEN 
#            CALL i560_lpk12(p_cmd)              #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk12,'d',4)  #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk12 = g_lpk_t.lpk12
                NEXT FIELD lpk12
             END IF 
          ELSE 
#          	 DISPLAY '' TO lpd02           #FUN-BC0058 mark
                 DISPLAY '' TO lpc02_3         #FUN-BC0058 add
          END IF 
          
      AFTER FIELD lpk13   
          IF NOT cl_null(g_lpk.lpk13) THEN 
#            CALL i560_lpk13(p_cmd)              #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk13,'d',7)  #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk13 = g_lpk_t.lpk13
                NEXT FIELD lpk13
             END IF 
          ELSE
#         	 DISPLAY '' TO lpg02           #FUN-BC0058 mark
                 DISPLAY '' TO lpc02_4         #FUN-BC0058 add
          END IF 
          
      AFTER FIELD lpk14   
          IF NOT cl_null(g_lpk.lpk14) THEN 
#            CALL i560_lpk14(p_cmd)              #FUN-BC0058 mark
             CALL i560_lpc02(g_lpk.lpk14,'d',2)  #FUN-BC0058 add
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lpk.lpk14 = g_lpk_t.lpk14
                NEXT FIELD lpk14
             END IF 
          ELSE 
#          	 DISPLAY '' TO lpb02            #FUN-BC0058 mark
                 DISPLAY '' TO lpc02_5          #FUN-BC0058 add
          END IF    

#FUN-B30202 -----------STA
    #CHI-CC0030 mark START
    #BEFORE FIELD lpk15
    #    IF g_aza.aza26 = '0' THEN
    #       CALL i560_lpk15()
    #    END IF
    #CHI-CC0030 mark END
#FUN-B30202 -----------END
      #MOD-AC0212 add --begin---------------------
      AFTER FIELD lpk19
         IF NOT cl_null(g_lpk.lpk19) THEN
            LET l_lpk19 = g_lpk.lpk19
            LET i = l_lpk19.getindexof('@',1)
            IF i = 0 THEN
               LET g_lpk.lpk19 = g_lpk_t.lpk19
               CALL cl_err('','sub-005',1)
               NEXT FIELD lpk19
            END IF
         END IF
      #MOD-AC0212 add ---end----------------------  

#FUN-C50090 add begin ---
      AFTER FIELD lpk20
         IF NOT cl_null(g_lpk.lpk20) THEN
            CALL i560_lpk20(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lpk.lpk20 = g_lpk_t.lpk20
               NEXT FIELD lpk20
            END IF
         END IF
#FUN-C50090 add end -----

#FUN-B90118 add START------------
      AFTER INPUT
         LET g_lpk.lpkuser = s_get_data_owner("lpk_file") #FUN-C10039
         LET g_lpk.lpkgrup = s_get_data_group("lpk_file") #FUN-C10039
        # LET g_argv1 = ''   #CHI-C30021 MARK
        # LET g_argv2 = ''   #CHI-C30021 MARK
         IF INT_FLAG THEN
            EXIT INPUT 
         END IF
#FUN-D30055---add---START
         IF g_aza.aza109 = 'Y' AND g_action_choice = "insert" THEN #流通會員代號自動編碼
            WHILE TRUE
            IF cl_null(g_lpk.lpk01) THEN
               CALL s_auno(g_lpk.lpk01,'8','') RETURNING g_lpk.lpk01,l_name
               DISPLAY BY NAME g_lpk.lpk01
            END IF
            IF NOT cl_null(g_lpk.lpk01) THEN EXIT WHILE END IF
            END WHILE
            IF NOT cl_null(g_lpk.lpk01) THEN
               IF p_cmd = "a" OR
                  (p_cmd="u" AND g_lpk.lpk01 != g_lpk_t.lpk01) THEN
                  SELECT count(*) INTO l_n FROM lpk_file
                   WHERE lpk01=g_lpk.lpk01
                  IF l_n>0 THEN
                     CALL cl_err('','-239',1)
                     LET g_lpk.lpk01 = g_lpk_t.lpk01
                     DISPLAY BY NAME g_lpk.lpk01
                     CALL s_auno(g_lpk.lpk01,'8','') RETURNING g_lpk.lpk01,l_name
                  END IF
               END IF
            END IF
         END IF
#FUN-D30055---add-----END
         IF (g_lpk.lpk02 <> 2 ) THEN
            IF cl_null(g_lpk.lpk03) THEN
               CALL cl_err('','alm-h09',0)
               NEXT FIELD lpk03
            END IF
         END IF                

#FUN-B90118 add END--------------
                                                 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE           
            WHEN INFIELD(lpk08) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpa"         #FUN-BC0058  mark
               LET g_qryparam.form ="q_lpc01_1"     #FUN-BC0058 
               LET g_qryparam.arg1 = '1'            #FUN-BC0058
               LET g_qryparam.default1 = g_lpk.lpk08
               CALL cl_create_qry() RETURNING g_lpk.lpk08
               DISPLAY BY NAME g_lpk.lpk08             
               NEXT FIELD lpk08 
               
            WHEN INFIELD(lpk09) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpe"       #FUN-BC0058 MARK
               LET g_qryparam.form ="q_lpc01_1"   #FUN-BC0058
               LET g_qryparam.arg1 = '5'          #FUN-BC0058
               LET g_qryparam.default1 = g_lpk.lpk09
               CALL cl_create_qry() RETURNING g_lpk.lpk09
               DISPLAY BY NAME g_lpk.lpk09          
               NEXT FIELD lpk09      
 
            WHEN INFIELD(lpk10) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpf"       #FUN-BC0058 MARK 
               LET g_qryparam.form ="q_lpc01_1"   #FUN-BC0058
                LET g_qryparam.arg1 = '6'         #FUN-BC0058     
               LET g_qryparam.default1 = g_lpk.lpk10
               CALL cl_create_qry() RETURNING g_lpk.lpk10
               DISPLAY BY NAME g_lpk.lpk10          
               NEXT FIELD lpk10 
                    
            WHEN INFIELD(lpk11) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpc"
               LET g_qryparam.default1 = g_lpk.lpk11
               CALL cl_create_qry() RETURNING g_lpk.lpk11
               DISPLAY BY NAME g_lpk.lpk11          
               NEXT FIELD lpk11      
 
            WHEN INFIELD(lpk12) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpd"        #FUN-BC0058 MARK
               LET g_qryparam.form = "q_lpc01_1"   #FUN-BC0058 
               LET g_qryparam.arg1 = '4'           #FUN-BC0058
               LET g_qryparam.default1 = g_lpk.lpk12
               CALL cl_create_qry() RETURNING g_lpk.lpk12
               DISPLAY BY NAME g_lpk.lpk12          
               NEXT FIELD lpk12      
 
            WHEN INFIELD(lpk13) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpg"       #FUN-BC0058 MARK
               LET g_qryparam.form ="q_lpc01_1"   #FUN-BC0058
               LET g_qryparam.arg1 = '7'          #FUN-BC0058
               LET g_qryparam.default1 = g_lpk.lpk13
               CALL cl_create_qry() RETURNING g_lpk.lpk13
               DISPLAY BY NAME g_lpk.lpk13          
               NEXT FIELD lpk13   
 
            WHEN INFIELD(lpk14) 
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_lpb"        #FUN-BC0058 MARK 
               LET g_qryparam.form ="q_lpc01_1"    #FUN-BC0058
               LET g_qryparam.arg1 = '2'           #FUN-BC0058
               LET g_qryparam.default1 = g_lpk.lpk14
               CALL cl_create_qry() RETURNING g_lpk.lpk14
               DISPLAY BY NAME g_lpk.lpk14          
               NEXT FIELD lpk14   
                              
#FUN-C50090 add begin ---
            WHEN INFIELD(lpk20)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ02"
               LET g_qryparam.default1 = g_lpk.lpk20
               CALL cl_create_qry() RETURNING g_lpk.lpk20
               DISPLAY BY NAME g_lpk.lpk20
               CALL i560_lpk20('d')
               NEXT FIELD lpk20
#FUN-C50090 add END -----
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  

     #CHI-CC0030 add START
      ON ACTION mem_addr
         CALL i560_lpk15()
     #CHI-CC0030 add END
 
   END INPUT

#FUN-D30055---add---START
   IF g_aza.aza109 = 'Y' THEN
      IF p_cmd = 'a' THEN
         CALL i560_set_attr("lpk01",TRUE)
      END IF
   END IF 
#FUN-D30055---add-----END
 
END FUNCTION

#FUN-BC0058 mark begin ---
#FUNCTION i560_lpk08(p_cmd)
#   DEFINE l_lpa02   LIKE lpa_file.lpa02
#   DEFINE l_lpa03   LIKE lpa_file.lpa03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpa02,lpa03
#     INTO l_lpa02,l_lpa03
#     FROM lpa_file
#    WHERE lpa01 = g_lpk.lpk08
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-278'
#                               LET l_lpa02 = NULL
#        WHEN l_lpa03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd' THEN
#      DISPLAY l_lpa02 TO lpa02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk09(p_cmd)
#   DEFINE l_lpe02   LIKE lpe_file.lpe02
#   DEFINE l_lpe03   LIKE lpe_file.lpe03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpe02,lpe03
#     INTO l_lpe02,l_lpe03
#     FROM lpe_file
#    WHERE lpe01 = g_lpk.lpk09
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-279'
#                               LET l_lpe02 = NULL
#        WHEN l_lpe03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd' THEN
#      DISPLAY l_lpe02 TO lpe02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk10(p_cmd)
#   DEFINE l_lpf02   LIKE lpf_file.lpf02
#   DEFINE l_lpf05   LIKE lpf_file.lpf05
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpf02,lpf05
#     INTO l_lpf02,l_lpf05
#     FROM lpf_file
#    WHERE lpf01 = g_lpk.lpk10
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-279'
#                               LET l_lpf02 = NULL
#        WHEN l_lpf05='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd' THEN
#      DISPLAY l_lpf02 TO lpf02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk11(p_cmd)
#   DEFINE l_lpc02   LIKE lpc_file.lpc02
#   DEFINE l_lpc03   LIKE lpc_file.lpc03
#   DEFINE l_lpc04   LIKE lpc_file.lpc04
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpc02,lpc03,lpc04
#     INTO l_lpc02,l_lpc03,l_lpc04
#     FROM lpc_file
#    WHERE lpc01 = g_lpk.lpk11
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-280'
#                               LET l_lpc02=''
#                               LET l_lpc03=''
#        WHEN l_lpc04='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END CASE
#   IF cl_null(g_errno) OR p_cmd= 'd' THEN
#      DISPLAY l_lpc02 TO lpc02
#      DISPLAY l_lpc03 TO lpc03
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk12(p_cmd)
#   DEFINE l_lpd02   LIKE lpd_file.lpd02
#   DEFINE l_lpd03   LIKE lpd_file.lpd03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpd02,lpd03
#     INTO l_lpd02,l_lpd03
#     FROM lpd_file
#    WHERE lpd01 = g_lpk.lpk12
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-281'
#                               LET l_lpd02 = NULL
#        WHEN l_lpd03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd'  then
#      DISPLAY l_lpd02 TO lpd02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk13(p_cmd)
#   DEFINE l_lpg02   LIKE lpg_file.lpg02
#   DEFINE l_lpg03   LIKE lpg_file.lpg03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpg02,lpg03
#     INTO l_lpg02,l_lpg03
#     FROM lpg_file
#    WHERE lpg01 = g_lpk.lpk13
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-282'
#                               LET l_lpg02 = NULL
#        WHEN l_lpg03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd'  then
#      DISPLAY l_lpg02 TO lpg02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk14(p_cmd)
#   DEFINE l_lpb02   LIKE lpb_file.lpb02
#   DEFINE l_lpb03   LIKE lpb_file.lpb03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpb02,lpb03
#     INTO l_lpb02,l_lpb03
#     FROM lpb_file
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpg02,lpg03
#     INTO l_lpg02,l_lpg03
#     FROM lpg_file
#    WHERE lpg01 = g_lpk.lpk13
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-282'
#                               LET l_lpg02 = NULL
#        WHEN l_lpg03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd'  then
#      DISPLAY l_lpg02 TO lpg02
#   END IF
#END FUNCTION
#
#FUNCTION i560_lpk14(p_cmd)
#   DEFINE l_lpb02   LIKE lpb_file.lpb02
#   DEFINE l_lpb03   LIKE lpb_file.lpb03
#   DEFINE p_cmd     LIKE type_file.chr1
#
#   LET g_errno=''
#
#   SELECT lpb02,lpb03
#     INTO l_lpb02,l_lpb03
#     FROM lpb_file
#    WHERE lpb01 = g_lpk.lpk14
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-283'
#                               LET l_lpb02 = NULL
#        WHEN l_lpb03='N'       LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END case
#   IF cl_null(g_errno) OR p_cmd= 'd'  then
#      DISPLAY l_lpb02 TO lpb02
#   END IF
#END FUNCTION 
#FUN-BC0058 mark end ----
#FUN-BC0058 add begin ---
FUNCTION i560_lpc02(p_no,p_cmd,p_num)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_no      LIKE lpc_file.lpc01
   DEFINE l_lpcacti LIKE lpc_file.lpcacti
   DEFINE l_lpc02   LIKE lpc_file.lpc02
   DEFINE p_num     LIKE type_file.num5
   LET g_errno=''
   SELECT lpc02,lpcacti
     INTO l_lpc02,l_lpcacti
     FROM lpc_file
    WHERE lpc01 = p_no
      AND lpc00 = p_num
   CASE WHEN SQLCA.sqlcode=100 CASE p_num 
                                   WHEN '1'
                                       LET g_errno='alm-278'
                                   WHEN '5'
                                       LET g_errno='alm-279'
                                   WHEN '6'
                                       LET g_errno='alm1578'
                                   WHEN '4'
                                       LET g_errno='alm-281'
                                   WHEN '7'
                                       LET g_errno='alm-282'
                                   WHEN '2'
                                       LET g_errno='alm-283'
                               END CASE 
                               LET l_lpc02 = NULL
        WHEN l_lpcacti='N'     LET g_errno='9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END case
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      CASE  p_num
         WHEN '1'
            DISPLAY l_lpc02 TO lpc02
         WHEN '5'
            DISPLAY l_lpc02 TO lpc02_1
         WHEN '6'
            DISPLAY l_lpc02 TO lpc02_2     
         WHEN '4'
            DISPLAY l_lpc02 TO lpc02_3
         WHEN '7'
            DISPLAY l_lpc02 TO lpc02_4
         WHEN '2'
            DISPLAY l_lpc02 TO lpc02_5 
      END CASE  
   END IF
END FUNCTION
FUNCTION i560_lpk11(p_no,p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_no      LIKE lpc_file.lpc01
   DEFINE l_lpcacti LIKE lpc_file.lpcacti
   DEFINE l_lpc03   LIKE lpc_file.lpc03
   DEFINE l_lpc04   LIKE lpc_file.lpc04
   LET g_errno=''
   SELECT lpc03,lpc04,lpcacti
     INTO l_lpc03,l_lpc04,l_lpcacti
     FROM lpc_file
    WHERE lpc01 = p_no
      AND lpc00 = 3
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-280'
                               LET l_lpc03 = NULL
                               LET l_lpc04 = NULL
        WHEN l_lpcacti='N'     LET g_errno='9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END case
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      DISPLAY l_lpc03 TO lpc03
      DISPLAY l_lpc04 TO lpc04                
   END IF
END FUNCTION
#FUN-BC0058 add end ----

#FUN-B30202 ------------STA
FUNCTION i560_lpk15()
DEFINE l_lva  RECORD 
              lva01   LIKE type_file.chr300,
              lva02   LIKE lva_file.lva02,
              lva03   LIKE lva_file.lva03,
              lva04   LIKE lva_file.lva04,
              lva05   LIKE lva_file.lva05
              END RECORD
DEFINE l_lva_t RECORD 
              lva01   LIKE type_file.chr300,
              lva02   LIKE lva_file.lva02,
              lva03   LIKE lva_file.lva03,
              lva04   LIKE lva_file.lva04,
              lva05   LIKE lva_file.lva05
               END RECORD
               
DEFINE l_lpk15_t LIKE lpk_file.lpk15
DEFINE l_lpk16_t LIKE lpk_file.lpk16
DEFINE lva04_1  LIKE type_file.chr300
DEFINE cb2 ui.ComboBox
DEFINE cb3 ui.ComboBox
DEFINE cb4 ui.ComboBox
DEFINE cb1 ui.ComboBox
DEFINE l_n LIKE type_file.num5
DEFINE l_sql STRING
DEFINE l_lva02 LIKE lva_file.lva02
DEFINE l_lva03 LIKE lva_file.lva03
DEFINE l_lva04 LIKE lva_file.lva04
DEFINE l_lva01 LIKE type_file.chr300
DEFINE l_s   STRING


    OPEN WINDOW i560_1_w WITH FORM "alm/42f/almi560_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_locale("almi560_1")
    LET cb2 = ui.ComboBox.forName("lva02")
    LET cb3 = ui.ComboBox.forName("lva03")
    LET cb4 = ui.ComboBox.forName("lva04")
    LET cb1 = ui.ComboBox.forName("lva01")
    DECLARE cur_lva02 CURSOR FOR SELECT DISTINCT lva02 FROM lva_file ORDER BY lva02
    CALL cb2.clear()
    FOREACH cur_lva02 INTO l_lva02
       CALL cb2.addItem(l_lva02,'')
    END FOREACH
   
    IF NOT cl_null(g_lpk.lpk16) THEN
       LET l_sql = " SELECT lva01||' '||lva05,lva02,lva03,lva04,lva05 FROM lva_file WHERE lva01 ='",g_lpk.lpk16,"'"
       PREPARE i560_1_prepare FROM l_sql
       DECLARE i560_1_cs SCROLL CURSOR WITH HOLD FOR i560_1_prepare
       OPEN i560_1_cs 
       FETCH FIRST i560_1_cs INTO l_lva.*
       
       DECLARE cur_lva03 CURSOR FOR SELECT DISTINCT lva03 FROM lva_file 
                                     WHERE lva02 = l_lva.lva02
                                     ORDER BY lva03
       CALL cb3.clear()
       FOREACH cur_lva03 INTO l_lva03
          CALL cb3.addItem(l_lva03,'')
       END FOREACH
       DECLARE cur_lva04 CURSOR FOR SELECT DISTINCT lva04 FROM lva_file 
                                     WHERE lva02 = l_lva.lva02
                                       AND lva03 = l_lva.lva03
                                       ORDER BY lva04
       CALL cb4.clear()
       FOREACH cur_lva04 INTO l_lva04
          CALL cb4.addItem(l_lva04,'')
       END FOREACH
       DECLARE cur_lva01 CURSOR FOR SELECT lva01||' '||lva05 FROM lva_file 
                                     WHERE lva02 = l_lva.lva02
                                       AND lva03 = l_lva.lva03
                                       AND lva04 = l_lva.lva04
                                       ORDER BY lva01,lva05
       CALL cb1.clear()
       FOREACH cur_lva01 INTO l_lva01
          CALL cb1.addItem(l_lva01,'')
       END FOREACH 
       
    END IF
    DISPLAY BY NAME l_lva.lva02,l_lva.lva03,l_lva.lva04,l_lva.lva01
    LET l_lpk15_t = g_lpk.lpk15
    LET l_lpk16_t = g_lpk.lpk16
    LET l_lva_t.* = l_lva.*
    
    INPUT BY NAME l_lva.lva02,l_lva.lva03,l_lva.lva04,l_lva.lva01,lva04_1 WITHOUT DEFAULTS
      BEFORE INPUT    

      ON CHANGE lva02
         CALL cb1.clear()
         CALL cb4.clear()
         CALL cb3.clear()
         LET l_lva.lva03 = ''
         LET l_lva.lva04 = ''
         LET l_lva.lva01 = ''
         DECLARE cur_lva03_1 CURSOR FOR SELECT DISTINCT lva03 FROM lva_file 
                                         WHERE lva02 = l_lva.lva02
                                         ORDER BY lva03
             
         FOREACH cur_lva03_1 INTO l_lva03
            CALL cb3.addItem(l_lva03,'')
         END FOREACH

         
      ON CHANGE lva03
          CALL cb1.clear()
          CALL cb4.clear()
          LET l_lva.lva04 = ''
          LET l_lva.lva01 = '' 
          DECLARE cur_lva04_1 CURSOR FOR SELECT DISTINCT lva04 FROM lva_file 
                                          WHERE lva02 = l_lva.lva02
                                            AND lva03 = l_lva.lva03
                                          ORDER BY lva04
          FOREACH cur_lva04_1 INTO l_lva04
              CALL cb4.addItem(l_lva04,'')
          END FOREACH
          
      ON CHANGE lva04
          CALL cb1.clear()
          LET l_lva.lva01 = ''
          DECLARE cur_lva01_1 CURSOR FOR SELECT lva01||' '||lva05 FROM lva_file 
                                          WHERE lva02 = l_lva.lva02
                                            AND lva03 = l_lva.lva03
                                            AND lva04 = l_lva.lva04
                                          ORDER BY lva01,lva05         
          FOREACH cur_lva01_1 INTO l_lva01
              CALL cb1.addItem(l_lva01,'')
          END FOREACH
        
     
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()
      
            
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0
       LET g_lpk.lpk15 = l_lpk15_t 
       LET g_lpk.lpk16 = l_lpk16_t 
       CALL cl_err('',9001,0)
    ELSE
       LET g_lpk.lpk15 = l_lva.lva02,l_lva.lva03,l_lva.lva04,lva04_1
       LET l_s = l_lva.lva01
       LET l_n = l_s.getIndexOf(' ',1)
       LET g_lpk.lpk16 = l_s.subString(1,l_n-1)
    END IF
    CLOSE WINDOW i560_1_w
    
END FUNCTION

#FUN-C50090 add begin ---
FUNCTION i560_lpk20(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_occacti LIKE occ_file.occacti
   LET g_errno = ''
   SELECT occ02,occacti INTO l_occ02,l_occacti
     FROM occ_file
    WHERE occ01 = g_lpk.lpk20
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1625'
                               LET l_occ02 = ''
      WHEN l_occacti <> 'Y'    LET g_errno = 'alm1626'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_occ02 TO occ02
   END IF
END FUNCTION
#FUN-C50090 add end -----

FUNCTION i560_sales()
   DEFINE l_cmd           LIKE type_file.chr1000
   IF l_ac IS NULL OR l_ac < 1 THEN
      RETURN
   END IF
   LET l_cmd = ' almq500 "',g_lpj[l_ac].lpj03,'"'
   CALL cl_cmdrun(l_cmd)
END FUNCTION
#FUN-B30202 ------------END 

#FUN-BC0079 -----add----- begin
FUNCTION i560_commemorate()
   IF g_lpk.lpk01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   OPEN WINDOW i560_day_w WITH FORM "alm/42f/almi560_day"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almi560_day")
   CALL i560_day_show()
   CALL i560_day_menu()
   CLOSE WINDOW i560_day_w 
END FUNCTION

FUNCTION i560_day_menu()
   WHILE TRUE
      CALL i560_day_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL i560_day_b()

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            LET INT_FLAG = 0
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i560_day_bp(p_ud)
   DEFINE p_ud  LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = ""

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_lpa TO s_lpa.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
      BEFORE ROW
         LET l_ac2 = ARR_CURR()  #存放当前单身停留指针至共享变量l_ac
         CALL cl_show_fld_cont()  #单身数据comment变更

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE          
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about() 


      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO") 
      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
FUNCTION i560_day_show()
   DISPLAY g_lpk.lpk01,g_lpk.lpk04,g_lpk.lpk03,g_lpk.lpk17,g_lpk.lpk18
        TO FORMONLY.lpk01_a,FORMONLY.lpk04_a,FORMONLY.lpk03_a,
           FORMONLY.lpk17_a,FORMONLY.lpk18_a
   CALL i560_day_b_fill()
END FUNCTION

FUNCTION i560_day_b_fill()
DEFINE  l_sql  STRING
   LET l_sql = "SELECT lpa02,'',lpa03,lpaacti FROM lpa_file ",
               " WHERE lpa01 = '",g_lpk.lpk01,"'",
               " ORDER BY lpa02"
   PREPARE lpa_pre FROM l_sql
   DECLARE lpa_curs CURSOR FOR lpa_pre
   CALL g_lpa.clear()
   LET g_cnt = 1
   FOREACH lpa_curs INTO g_lpa[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT lpc02 INTO g_lpa[g_cnt].lpc02
        FROM lpc_file
       WHERE lpc00 = '8' AND lpc01 = g_lpa[g_cnt].lpa02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH      
   CALL g_lpa.deleteElement(g_cnt)  

   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cnt_a
   LET g_cnt = 0
END FUNCTION

FUNCTION i560_day_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_year          LIKE lpa_file.lpa04,
          l_month         LIKE lpa_file.lpa05,
          l_day           LIKE lpa_file.lpa06

   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT lpa02,'',lpa03,lpaacti FROM lpa_file ",
                      " WHERE lpa01 = ? AND lpa02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i560_day_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_lpa WITHOUT DEFAULTS FROM s_lpa.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF NOT g_inTransaction THEN #CHI-C30021 add
            BEGIN WORK
         END IF   #CHI-C30021 add
         IF g_rec_b2 >= l_ac2 THEN
            LET p_cmd = 'u'
            LET g_lpa_t.* = g_lpa[l_ac2].*
            OPEN i560_day_bcl USING g_lpk.lpk01,g_lpa_t.lpa02
            IF STATUS THEN
               CALL cl_err("OPEN i560_day_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i560_day_bcl INTO g_lpa[l_ac2].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lpa_t.lpa02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i560_day_lpa02()
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_lpa[l_ac2].* TO NULL
         LET g_lpa[l_ac2].lpaacti = 'Y'
         LET g_lpa_t.* = g_lpa[l_ac2].*
         CALL cl_show_fld_cont()
         NEXT FIELD lpa02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lpa_file(lpa01,lpa02,lpa03,lpa04,lpa05,lpa06,
                              lpaacti,lpauser,lpagrup,lpaoriu,lpaorig)
         VALUES(g_lpk.lpk01,g_lpa[l_ac2].lpa02,g_lpa[l_ac2].lpa03,l_year,l_month,l_day,
                g_lpa[l_ac2].lpaacti,g_user,g_grup,g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lpa_file",g_lpk.lpk01,g_lpa[l_ac2].lpa02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            IF NOT g_inTransaction THEN #CHI-C30021 add
               COMMIT WORK
            END IF   #CHI-C30021 add
            LET g_rec_b2=g_rec_b2+1
            DISPLAY g_rec_b2 TO FORMONLY.cnt_a
         END IF

      AFTER FIELD lpa02
         IF NOT cl_null(g_lpa[l_ac2].lpa02) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' 
               AND g_lpa[l_ac2].lpa02 != g_lpa_t.lpa02) THEN
               IF g_lpa_t.lpa02 = g_rcj04 THEN
                  CALL cl_err('','alm1483',0)
                  LET g_lpa[l_ac2].lpa02 = g_lpa_t.lpa02
                  NEXT FIELD lpa02
               END IF
               SELECT COUNT(*) INTO l_n FROM lpa_file
                WHERE lpa01 = g_lpk.lpk01
                  AND lpa02 = g_lpa[l_ac2].lpa02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lpa[l_ac2].lpa02 = g_lpa_t.lpa02
                  NEXT FIELD lpa02
               END IF
               CALL i560_day_lpa02()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lpa[l_ac2].lpa02 = g_lpa_t.lpa02
                  NEXT FIELD lpa02
               END IF
            END IF
         END IF    

      AFTER FIELD lpa03
         IF NOT cl_null(g_lpa[l_ac2].lpa03) THEN
            IF g_lpa[l_ac2].lpa03 > g_today THEN
               CALL cl_err('','alm1462',0)
               LET g_lpa[l_ac2].lpa03 = g_lpa_t.lpa03
               NEXT FIELD lpa03
            END IF
            LET l_year  = YEAR(g_lpa[l_ac2].lpa03)
            LET l_month = MONTH(g_lpa[l_ac2].lpa03)
            LET l_day   = DAY(g_lpa[l_ac2].lpa03)
         END IF

      ON CHANGE lpa03
         IF g_lpa_t.lpa02 = g_rcj04 THEN
            CALL cl_err('','alm1483',0)
            LET g_lpa[l_ac2].lpa03 = g_lpa_t.lpa03
            NEXT FIELD lpa03
         END IF

      ON CHANGE lpaacti
         IF g_lpa_t.lpa02 = g_rcj04 THEN
            CALL cl_err('','alm1483',0)
            LET g_lpa[l_ac2].lpaacti = g_lpa_t.lpaacti
            NEXT FIELD lpaacti
         END IF

      BEFORE DELETE
         IF g_lpa_t.lpa02 IS NOT NULL THEN
            IF g_lpa_t.lpa02 = g_rcj04 THEN
               CALL cl_err('','alm1483',0)
               CANCEL DELETE
            END IF  
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM lpa_file
             WHERE lpa01 = g_lpk.lpk01
               AND lpa02 = g_lpa_t.lpa02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","lpa_file",g_lpk.lpk01,g_lpa_t.lpa02,SQLCA.sqlcode,"","",1)
               IF NOT g_inTransaction THEN #CHI-C30021 add 
                  ROLLBACK WORK
               END IF   #CHI-C30021 add      
               CANCEL DELETE
            END IF
            LET g_rec_b2=g_rec_b2-1
            DISPLAY g_rec_b2 TO FORMONLY.cnt_a
         END IF
         IF NOT g_inTransaction THEN #CHI-C30021 add
            COMMIT WORK
         END IF   #CHI-C30021 add

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lpa[l_ac2].* = g_lpa_t.*
            CLOSE i560_day_bcl
            IF NOT g_inTransaction THEN #CHI-C30021 add 
               ROLLBACK WORK
            END IF   #CHI-C30021 add      
            EXIT INPUT
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            LET g_lpa[l_ac2].* = g_lpa_t.*
         ELSE
            UPDATE lpa_file SET lpa02   = g_lpa[l_ac2].lpa02,
                                lpa03   = g_lpa[l_ac2].lpa03,
                                lpa04   = l_year,
                                lpa05   = l_month,
                                lpa06   = l_day,
                                lpaacti = g_lpa[l_ac2].lpaacti,
                                lpamodu = g_user,
                                lpadate = g_today
             WHERE lpa01 = g_lpk.lpk01
               AND lpa02 = g_lpa_t.lpa02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lpa_file",g_lpk.lpk01,g_lpa_t.lpa02,SQLCA.sqlcode,"","",1)
               LET g_lpa[l_ac2].* = g_lpa_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               IF NOT g_inTransaction THEN #CHI-C30021 add
                  COMMIT WORK
               END IF   #CHI-C30021 add
            END IF
         END IF

      AFTER ROW
         LET l_ac2 = ARR_CURR()
         LET l_ac_t = l_ac2
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'a' THEN
               CALL g_lpa.deleteElement(l_ac2)
            END IF
            IF p_cmd = 'u' THEN
               LET g_lpa[l_ac2].* = g_lpa_t.*
            END IF
            CLOSE i560_day_bcl
            IF NOT g_inTransaction THEN #CHI-C30021 add 
               ROLLBACK WORK
            END IF   #CHI-C30021 add      
            EXIT INPUT
         END IF
         CLOSE i560_day_bcl
         IF NOT g_inTransaction THEN #CHI-C30021 add
            COMMIT WORK
         END IF   #CHI-C30021 add

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(lpa02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rcj04"
                 LET g_qryparam.default1 = g_lpa[l_ac2].lpa02
                 CALL cl_create_qry() RETURNING g_lpa[l_ac2].lpa02
                 CALL i560_day_lpa02()
                 DISPLAY BY NAME g_lpa[l_ac2].lpa02
                 NEXT FIELD lpa02
              OTHERWISE EXIT CASE
           END CASE
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()  
 
      ON ACTION controls                              
         CALL cl_set_head_visible("","AUTO")       
   END INPUT
   CLOSE i560_day_bcl
   IF NOT g_inTransaction THEN #CHI-C30021 add
      COMMIT WORK
   END IF   #CHI-C30021 add
END FUNCTION

FUNCTION i560_day_lpa02()
DEFINE   l_lpc02   LIKE lpc_file.lpc02,
         l_lpcacti   LIKE lpc_file.lpcacti,
         l_lpc05     LIKE lpc_file.lpc05 #FUN-C60032 add

   LET g_errno = ''

   SELECT lpc02,lpcacti,lpc05 INTO l_lpc02,l_lpcacti,l_lpc05 FROM lpc_file   #FUN-C60032 add lpc05
    WHERE lpc00 = '8'
      AND lpc01 = g_lpa[l_ac2].lpa02
   CASE
      WHEN SQLCA.sqlcode = 100
         LET  g_errno = '1306'
      WHEN l_lpcacti = 'N'
         LET  g_errno = 'art1026'
      WHEN l_lpc05 = 'N'                #FUN-C60032 add
         LET g_errno = 'alm1628'      #FUN-C60032 add
   END CASE
   IF cl_null(g_errno) THEN
      LET g_lpa[l_ac2].lpc02 = l_lpc02
      DISPLAY l_lpc02 TO lpc02
   END IF
END FUNCTION
#FUN-BC0079 -----add----- end

FUNCTION i560_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lpj.clear()
   DISPLAY ' ' TO FORMONLY.cnt   
#CHI-C30021 MARK STA
   #FUN-B90118 add  
#   IF NOT cl_null(g_argv1)THEN
#      LET g_wc = "lpk01 = '",g_argv1,"'" 
#      LET g_wc2 = " 1=1"
#   ELSE 
#FUN-B90118 add  
      CALL i560_cs()
#   END IF               #FUN-B90118 add
#CHI-C30021 MARK  END
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lpk.* TO NULL
      RETURN
   END IF
 
   OPEN i560_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lpk.* TO NULL
   ELSE
      OPEN i560_count
      FETCH i560_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i560_fetch('F')                  # 讀出TEMP第一筆並顯示
      CALL i560_list_fill()  #FUN-BC0134 add
   END IF
   CALL cl_set_comp_visible('lpk051,lpk052,lpk053',FALSE)   #FUN-B80194 add #FUN-BC0079 add lpk052,lpk053

END FUNCTION
 
FUNCTION i560_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i560_cs INTO g_lpk.lpk01
      WHEN 'P' FETCH PREVIOUS i560_cs INTO g_lpk.lpk01
      WHEN 'F' FETCH FIRST    i560_cs INTO g_lpk.lpk01
      WHEN 'L' FETCH LAST     i560_cs INTO g_lpk.lpk01
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
            FETCH ABSOLUTE g_jump i560_cs INTO g_lpk.lpk01
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpk.lpk01,SQLCA.sqlcode,0)
      INITIALIZE g_lpk.* TO NULL              
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
      DISPLAY g_curs_index TO FORMONLY.idx   
   END IF
 
   SELECT * INTO g_lpk.* FROM lpk_file WHERE lpk01 = g_lpk.lpk01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lpk_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lpk.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lpk.lpkuser        
   LET g_data_group = g_lpk.lpkgrup     
   CALL i560_show()
 
END FUNCTION
 
FUNCTION i560_show()
 
   LET g_lpk_t.* = g_lpk.*                
   LET g_lpk_o.* = g_lpk.*                
   DISPLAY BY NAME g_lpk.lpk01,g_lpk.lpk02,g_lpk.lpk03,g_lpk.lpk04,g_lpk.lpk05,g_lpk.lpk06, g_lpk.lpkoriu,g_lpk.lpkorig,
                   g_lpk.lpk07,g_lpk.lpk08,g_lpk.lpk09,g_lpk.lpk10,g_lpk.lpk11,g_lpk.lpk12,
                   g_lpk.lpk13,g_lpk.lpk14,g_lpk.lpk15,g_lpk.lpk16,g_lpk.lpk17,g_lpk.lpk18,
                   g_lpk.lpk19,g_lpk.lpkpos,g_lpk.lpk20,g_lpk.lpk21,    #FUN-A80022 add lpkpos by vealxu   #FUN-C50090 add lpk20   #FUN-CC0135 add lpk21
                   g_lpk.lpkuser,g_lpk.lpkgrup,g_lpk.lpkmodu,g_lpk.lpkdate,
                   g_lpk.lpkacti,g_lpk.lpkcrat 
#FUN-B90118 add START-----------------------------------------
                   ,g_lpk.lpkud01,g_lpk.lpkud02,g_lpk.lpkud03,g_lpk.lpkud04,
                   g_lpk.lpkud05,g_lpk.lpkud06,g_lpk.lpkud07,g_lpk.lpkud08,
                   g_lpk.lpkud09,g_lpk.lpkud10,g_lpk.lpkud11,g_lpk.lpkud12,
                   g_lpk.lpkud13,g_lpk.lpkud14,g_lpk.lpkud15
#FUN-B90118 add END------------------------------------------
#FUN-BC0058 mark begin ---
#   CALL i560_lpk08('d') 
#   CALL i560_lpk09('d')
#   CALL i560_lpk10('d')
#   CALL i560_lpk11('d')
#   CALL i560_lpk12('d') 
#   CALL i560_lpk13('d')
#   CALL i560_lpk14('d')
#FUN-BC0058 mark end -----
   CALL i560_lpc02(g_lpk.lpk08,'d',1)   #FUN-BC0058 add 
   CALL i560_lpc02(g_lpk.lpk09,'d',5)   #FUN-BC0058 add 
   CALL i560_lpc02(g_lpk.lpk10,'d',6)   #FUN-BC0058 add 
   CALL i560_lpk11(g_lpk.lpk11,'d')     #FUN-BC0058 add 
   CALL i560_lpc02(g_lpk.lpk12,'d',4)   #FUN-BC0058 add 
   CALL i560_lpc02(g_lpk.lpk13,'d',7)   #FUN-BC0058 add 
   CALL i560_lpc02(g_lpk.lpk14,'d',2)   #FUN-BC0058 add 
   CALL i560_lpk20('d')                 #FUN-C50090 add
           
   CALL i560_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()    
  #CALL cl_set_field_pic("N","","","","N",g_lpk.lpkacti) #No.FUN-9B0136 By shiwuying  #CHI-C70001 mark
END FUNCTION

 
FUNCTION i560_u(p_w)
DEFINE p_w        LIKE type_file.chr1 
DEFINE l_n        LIKE type_file.num5
DEFINE l_lpkpos   LIKE lpk_file.lpkpos   #FUN-B70075 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpk.lpk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_lpk.* FROM lpk_file
    WHERE lpk01=g_lpk.lpk01
 
   IF g_lpk.lpkacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpk.lpk01,'alm-069',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lpk01_t = g_lpk.lpk01
   #FUN-B70075  Begin--------------
    IF g_aza.aza88 = 'Y' THEN
       LET g_lpk_t.* = g_lpk.*
       LET l_lpkpos = g_lpk.lpkpos
       UPDATE lpk_file SET lpkpos = '4'
        WHERE lpk01 = g_lpk_t.lpk01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","lpk_file",g_lpk_t.lpk01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       LET g_lpk.lpkpos = '4'
       DISPLAY BY NAME g_lpk.lpkpos
    END IF
   #FUN-B70075  End ---------------   
   IF NOT g_inTransaction THEN #CHI-C30021 add 
      BEGIN WORK
   END IF   #CHI-C30021 add 
 
   OPEN i560_cl USING g_lpk01_t
   IF STATUS THEN
      CALL cl_err("OPEN i560_cl:", STATUS, 1)
      CLOSE i560_cl
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
      RETURN
   END IF
 
   FETCH i560_cl INTO g_lpk.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpk.lpk01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i560_cl
       IF NOT g_inTransaction THEN #CHI-C30021 add 
          ROLLBACK WORK
       END IF   #CHI-C30021 add      
       RETURN
   END IF
 
   CALL i560_show()
 
   WHILE TRUE
      LET g_lpk01_t = g_lpk.lpk01
      LET g_lpk_o.* = g_lpk.*
      IF p_w !='c' THEN 
         LET g_lpk.lpkmodu=g_user
         LET g_lpk.lpkdate=g_today
      END IF 
      
      CALL i560_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lpk.*=g_lpk_t.*
        #FUN-B70075  Begin ---------
         IF g_aza.aza88 = 'Y' THEN   #MOD-C80165 add
            LET g_lpk.lpkpos = l_lpkpos
            UPDATE lpk_file SET lpkpos = g_lpk.lpkpos
             WHERE lpk01 = g_lpk_t.lpk01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lpk_file",g_lpk_t.lpk01,"",SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
            DISPLAY BY NAME g_lpk.lpkpos
         END IF   #MOD-C80165 add
        #FUN-B70075 End ------------         
         CALL i560_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lpk.lpk01 != g_lpk01_t THEN            # 更改單號
         UPDATE lpj_file SET lpj01 = g_lpk.lpk01
          WHERE lpj01 = g_lpk01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lpj_file",g_lpk01_t,"",SQLCA.sqlcode,"","pmx",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      #FUN-A80022 add by vealxu --------------start--------
      #FUN-B70075 Begin ---------
      #IF g_aza.aza88 = 'Y' AND g_lpk.* != g_lpk_t.* THEN    #有更动
      IF g_aza.aza88 = 'Y' THEN 
      #FUN-B70075 End -------  
        #NO.FUN-B40071 --START--
         #LET g_lpk.lpkpos = 'N'
        #FUN-B70075 Begin -----
         #IF g_lpk.lpkpos <> '1' THEN
         #  LET g_lpk.lpkpos = '2'
         #END IF
         IF l_lpkpos <> '1' THEN
            LET g_lpk.lpkpos = '2'
         ELSE 
            LET g_lpk.lpkpos = '1'
         END IF
        #FUN-B70075 End -------
        #NO.FUN-B40071 --END--         
         DISPLAY g_lpk.lpkpos TO lpkpos  
      END IF 
#FUN-BC0079 -----add----- begin
      UPDATE lpa_file SET lpa01 = g_lpk.lpk01,
                          lpa03 = g_lpk.lpk05,
                          lpa04 = g_lpk.lpk051,
                          lpa05 = g_lpk.lpk052,
                          lpa06 = g_lpk.lpk053
       WHERE lpa01 = g_lpk01_t
         AND lpa02 = g_rcj04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lpa_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
#FUN-BC0079 -----add----- end

      #FUN-A80022 -----------add end -----------------------
      UPDATE lpk_file SET lpk_file.* = g_lpk.*
       WHERE lpk01 = g_lpk01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lpk_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i560_cl
   
   IF NOT g_inTransaction THEN #CHI-C30021 add 
      COMMIT WORK
   END IF   #CHI-C30021 add 
   CALL i560_b_fill("1=1")
   CALL i560_list_fill()  #FUN-BC0134 add
   CALL i560_bp_refresh()
 
END FUNCTION
 
FUNCTION i560_x()
DEFINE l_n      LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpk.lpk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF NOT g_inTransaction THEN #CHI-C30021 add 
      BEGIN WORK
   END IF   #CHI-C30021 add 
 
   OPEN i560_cl USING g_lpk.lpk01
   IF STATUS THEN
      CALL cl_err("OPEN i560_cl:", STATUS, 1)
      CLOSE i560_cl
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
      RETURN
   END IF
 
   FETCH i560_cl INTO g_lpk.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpk.lpk01,SQLCA.sqlcode,0)          #資料被他人LOCK
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i560_show()
 
   IF cl_exp(0,0,g_lpk.lpkacti) THEN                   #確認一下
      LET g_chr=g_lpk.lpkacti
      IF g_lpk.lpkacti='Y' THEN
         LET g_lpk.lpkacti='N'
         LET g_lpk.lpkmodu = g_user
      ELSE
         LET g_lpk.lpkacti='Y'
         LET g_lpk.lpkmodu = g_user
      END IF
 
      UPDATE lpk_file SET lpkacti=g_lpk.lpkacti,
                          lpkmodu=g_lpk.lpkmodu,
                          lpkpos ='2',           #No.FUN-A80022 By shi #NO.FUN-B40071
                          lpkdate=g_today                          
       WHERE lpk01=g_lpk.lpk01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lpk_file",g_lpk.lpk01,"",SQLCA.sqlcode,"","",1) 
         LET g_lpk.lpkacti=g_chr
      END IF
   END IF
 
   CLOSE i560_cl
 
   IF g_success = 'Y' THEN
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         COMMIT WORK
      END IF   #CHI-C30021 add 
   ELSE
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
   END IF
 
   SELECT lpkacti,lpkmodu,lpkdate,lpkpos                         #FUN-A80022 By shi
     INTO g_lpk.lpkacti,g_lpk.lpkmodu,g_lpk.lpkdate,g_lpk.lpkpos #FUN-A80022 By shi
     FROM lpk_file
    WHERE lpk01=g_lpk.lpk01
   DISPLAY BY NAME g_lpk.lpkmodu,g_lpk.lpkdate,g_lpk.lpkacti,g_lpk.lpkpos #FUN-A80022 By shi
  #CALL cl_set_field_pic("N","","","","N",g_lpk.lpkacti)  #No.FUN-9B0136 By shiwuying  #CHI-C70001 mark
   CALL i560_list_fill()  #FUN-BC0134 add
 
END FUNCTION
 
FUNCTION i560_r()
DEFINE   l_n   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpk.lpk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
     
   IF g_lpk.lpkacti = 'N' THEN 
      CALL cl_err(g_lpk.lpk01,'alm-147',1)
      RETURN 
   END IF
   #TQC-D30037 add begin------
   SELECT COUNT(*) INTO l_n FROM lpj_file 
    WHERE lpj01=g_lpk.lpk01
   IF l_n > 0 THEN 
      CALL cl_err(g_lpk.lpk01,'alm2009',1)
      RETURN 
   END IF     
   #TQC-D30037 add end--------  
   #FUN-A80022 -----------------add start-----------------   
   IF g_aza.aza88  = 'Y' THEN
   #NO.FUN-B40071 --START--
   #   IF g_lpk.lpkacti = 'Y' THEN
   #      CALL cl_err("",'art-648',0) 
   #      RETURN 
   #   END IF 
   #   IF g_lpk.lpkacti = 'N' THEN
   #      IF g_lpk.lpkpos = 'N' THEN
   #         CALL cl_err("",'art-648',0)
   #         RETURN 
   #      END IF  
   #   END IF
       IF NOT ((g_lpk.lpkpos='3' AND g_lpk.lpkacti='N') 
                     OR (g_lpk.lpkpos='1'))  THEN                  
          CALL cl_err('','apc-139',0)            
          RETURN
       END IF     
   END IF
   #NO.FUN-B40071 --END-- 
   #FUN-A80022 ----------------add end by vealxu ---------------  
  
   SELECT * INTO g_lpk.* FROM lpk_file
    WHERE lpk01=g_lpk.lpk01
   
   IF NOT g_inTransaction THEN #CHI-C30021 add 
      BEGIN WORK
   END IF   #CHI-C30021 add 
 
   OPEN i560_cl USING g_lpk.lpk01
   IF STATUS THEN
      CALL cl_err("OPEN i560_cl:", STATUS, 1)
      CLOSE i560_cl
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
      RETURN
   END IF
 
   FETCH i560_cl INTO g_lpk.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpk.lpk01,SQLCA.sqlcode,0)          #資料被他人LOCK
      IF NOT g_inTransaction THEN #CHI-C30021 add 
         ROLLBACK WORK
      END IF   #CHI-C30021 add      
      RETURN
   END IF
 
   CALL i560_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lpk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lpk.lpk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lpk_file WHERE lpk01 = g_lpk.lpk01 
      DELETE FROM lpj_file WHERE lpj01 = g_lpk.lpk01 
      DELETE FROM lpa_file WHERE lpa01 = g_lpk.lpk01  #FUN-BC0079 add
      CLEAR FORM
      CALL g_lpj.clear()
      OPEN i560_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i560_cs
         CLOSE i560_count
         IF NOT g_inTransaction THEN #CHI-C30021 add 
            COMMIT WORK
         END IF   #CHI-C30021 add 
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i560_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i560_cs
         CLOSE i560_count
         INITIALIZE g_lpk.* TO NULL   #FUN-BC0079 add
         IF NOT g_inTransaction THEN #CHI-C30021 add
            COMMIT WORK
         END IF   #CHI-C30021 add 
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i560_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i560_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL i560_fetch('/')
      END IF
   END IF
   CALL i560_list_fill()  #FUN-BC0134 add 
   CLOSE i560_cl
   IF NOT g_inTransaction THEN #CHI-C30021 add 
      COMMIT WORK
   END IF   #CHI-C30021 add 
END FUNCTION
 
FUNCTION i560_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5
DEFINE  l_lph02  LIKE lph_file.lph02
 
    LET g_sql = "SELECT lpj02,'',lpj03,lpj26,lpj04,lpj17,lpj05,lpj09,lpj16,lpj06,lpj08,lpj07,lpj15, ",     #FUN-CA0103 add lpj26
                "       lpj11,lpj12,lpj13,lpj14,lpj25,lpjpos from lpj_file",           #FUN-A30030 ADD
                " WHERE lpj01 ='",g_lpk.lpk01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lpj02 "
  
   DISPLAY g_sql
 
   PREPARE i560_pb FROM g_sql
   DECLARE lpj_cs CURSOR FOR i560_pb
 
   CALL g_lpj.clear()
   LET g_cnt = 1
 
   FOREACH lpj_cs INTO g_lpj[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT lph02 INTO g_lpj[g_cnt].lph02 FROM lph_file WHERE lph01=g_lpj[g_cnt].lpj02 
#      SELECT azf03 INTO g_lpj[g_cnt].azf03 FROM azf_file WHERE azf01=g_lpj[g_cnt].lpj14 
#         AND azf02='4'   #MOD-A30222 mark
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lpj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
#FUNCTION i560_copy()
#   DEFINE l_newno     LIKE lpk_file.lpk01,
#          l_oldno     LIKE lpk_file.lpk01
#   DEFINE li_result   LIKE type_file.num5
#   DEFINE l_n         LIKE type_file.num5 
#
#   IF s_shut(0) THEN RETURN END IF
#
#   IF g_lpk.lpk01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   LET g_before_input_done = FALSE
#   CALL i560_set_entry('a')
#
#   CALL cl_set_head_visible("","YES")         
#   INPUT l_newno FROM lpk01   
#       BEFORE INPUT
#          CALL cl_set_docno_format("lpk01")
#        
#       AFTER FIELD lpk01            
#           IF NOT cl_null(l_newno) THEN                                                                                  
#              SELECT count(*) INTO l_n FROM lpk_file 
#               WHERE lpk01=l_newno      
#              IF l_n>0 THEN 
#                 CALL cl_err('','-239',1)   
#                 LET g_lpk.lpk01 = g_lpk_t.lpk01   
#                 DISPLAY BY NAME g_lpk.lpk01     
#                 NEXT FIELD lpk01
#              END IF                                                                                              
#            END IF   
#
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
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
# 
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      DISPLAY BY NAME g_lpk.lpk01      
#      ROLLBACK WORK
#     
#      RETURN
#   END IF
#
#   BEGIN WORK 
#   
#   DROP TABLE y
#
#   SELECT * FROM lpk_file         #單頭複製
#       WHERE lpk01=g_lpk.lpk01
#       INTO TEMP y
#
#   UPDATE y
#       SET lpk01=l_newno,    #新的鍵值
#           lpkuser=g_user,   #資料所有者
#           lpkmodu=NULL,
#           lpkcrat=g_today,
#           lpkdate=NULL, 
#           lpkgrup=g_grup,   #資料所有者所屬群
#           lpkacti='Y'       #有效資料
# #          lpk09 ='N', 
# #          lpk10 =NULL,
# #          lpk11 =NULL,
# #          lpk13 =0
#
#   INSERT INTO lpk_file SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","lpk_file","","",SQLCA.sqlcode,"","",1)  
#      ROLLBACK WORK
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF
# 
##   DROP TABLE x
##
##   SELECT * FROM lpj_file         #單身複製
##       WHERE lpj01=g_lpk.lpk01
##        INTO TEMP x
##   IF SQLCA.sqlcode THEN
##      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
##      RETURN
##   END IF
##
##   UPDATE x SET lpj01=l_newno
##
##   INSERT INTO lpj_file
##       SELECT * FROM x
##   IF SQLCA.sqlcode THEN
##      ROLLBACK WORK
##      CALL cl_err3("ins","lpj_file","","",SQLCA.sqlcode,"","",1) 
##      RETURN
##   ELSE
##       COMMIT WORK
##   END IF
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#   LET l_oldno = g_lpk.lpk01
#   SELECT lpk01,lpk_file.* INTO g_lpk_lpk01,g_lpk.* FROM lpk_file WHERE lpk01 = l_newno
#   CALL i560_u('c')
##   CALL i560_b('c')
#   SELECT lpk01,lpk_file.* INTO g_lpk_lpk01,g_lpk.* FROM lpk_file WHERE lpk01 = l_oldno
#   CALL i560_show()
#
#END FUNCTION
 
FUNCTION i560_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lpk01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i560_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lpk01",FALSE)
    END IF
 
END FUNCTION
 
#FUNCTION i560_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1   
#
#     IF p_cmd = 'a' THEN                                                                                
#      CALL cl_set_comp_entry("lpj02,lpj03,lpj04",TRUE)                                                                                          
#     END IF   
#
#END FUNCTION
#
#FUNCTION i560_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1  
#
#
#  IF p_cmd = 'u' THEN                                                               
#      CALL cl_set_comp_entry("lpj02,lpj03,lpj04",FALSE)                                                                                         
#  END IF  
#
#END FUNCTION                                                                           
#No.FUN-960058--end 
#No.FUN-A60075--begin sunchenxu
FUNCTION i560_out()
   DEFINE l_cmd        LIKE type_file.chr1000, 
          l_wc,l_wc2   LIKE type_file.chr1000, 
          l_prtway     LIKE type_file.chr1     
 
      CALL cl_wait()
      
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
       WHERE zz01 = 'artr130'
      IF NOT cl_null(g_lpk.lpk01) THEN                                                                              
         LET l_wc=g_wc                                                                                                        
      END IF                                                                                                                          
      IF l_wc IS NULL THEN                                                                                                            
         CALL cl_err('','9057',0)                                                                                                     
         RETURN                                                                                                                       
      END IF 
      LET l_cmd = 'artr130',
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                   " '",l_wc CLIPPED,"' "
      CALL cl_cmdrun(l_cmd)
 
      ERROR ' '
END FUNCTION
#No.FUN-A60075--end sunchenxu

#FUN-B90118 add START-----------------------------------------
FUNCTION i560_trans()
   DEFINE l_cmd           LIKE type_file.chr1000
   IF l_ac IS NULL OR l_ac < 1 THEN
      RETURN
   END IF
   IF l_ac > 0 AND cl_null(g_lpj[l_ac].lpj03) THEN
      RETURN
   END IF
   LET l_cmd = ' almq618 "',g_lpj[l_ac].lpj03,'"'
   CALL cl_cmdrun(l_cmd CLIPPED)
END FUNCTION
#FUN-B90118 add END------------------------------------------
#FUN-BC0134 add START
FUNCTION i560_list_fill()
  DEFINE l_lpk01         LIKE lpk_file.lpk01
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_str           STRING
  DEFINE l_i2            LIKE type_file.num5
  DEFINE l_i3            LIKE type_file.num5
    CALL g_lpk_1.clear()
    CALL g_phone.clear()
    LET g_phone_num = ''
    LET l_i = 1
    LET l_i2 = 1
    LET l_i3 = 1
    LET g_i3 = 1 
    FOREACH i560_list_cur INTO l_lpk01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT lpk01, lpk04, lpk05, lpk06, lpk10, lpk13, lpk18 
         INTO g_lpk_1[l_i].*
         FROM lpk_file 
        WHERE lpk01=l_lpk01
       IF NOT cl_null(g_lpk_1[l_i].lpk18_1 ) THEN
          IF cl_null(l_str) THEN
             LET l_str = g_lpk_1[l_i].lpk18_1
          ELSE
             LET l_str = l_str CLIPPED,",",g_lpk_1[l_i].lpk18_1 CLIPPED
          END IF
          LET l_i2 = l_i2 + 1 
          LET g_phone[l_i3].phone = l_str
          IF l_i2 > 200 THEN
             LET l_str= ' '
             LET l_i2 = 1
             LET l_i3 = l_i3 + 1
          END IF 
       END IF
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    IF l_i3 > 0 THEN
      LET g_i3 = l_i3
    END IF
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_lpk_1 TO s_lpk_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION i560_phone()
DEFINE i          LIKE type_file.num5
DEFINE l_name     LIKE type_file.chr20   
DEFINE l_source,l_target,l_status   STRING 
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE unix_path       STRING,
       window_path     STRING
DEFINE l_channel       base.Channel
DEFINE l_cmd           STRING

   OPEN WINDOW i560_2_w WITH FORM "alm/42f/almi560_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   INPUT BY NAME l_name ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED) 
      
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      
   END INPUT

   CLOSE WINDOW i560_2_w

   IF cl_null(l_name) THEN RETURN END IF
 
   FOR i = 1 TO g_i3
      IF cl_null(g_phone[i].phone ) THEN CONTINUE FOR END IF
      IF i  = 1 THEN
         LET g_phone_num = g_phone[i].phone
      ELSE
         LET g_phone_num = g_phone_num ,"\r\n", g_phone[i].phone
      END IF
   END FOR

   LET l_name = l_name CLIPPED,".txt" 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_name,"a" )
   CALL l_channel.setDelimiter("")
   CALL l_channel.write(g_phone_num)
   CALL l_channel.close()

   LET unix_path = "$TEMPDIR/",l_name
   LET window_path = "c:\\tiptop\\",l_name 

   LET status = cl_download_file(unix_path, window_path) 
   IF status then
      CALL cl_err(l_name,"amd-020",1)
      DISPLAY "Download OK!!"
   ELSE
      CALL cl_err(l_name,"amd-021",1)
      DISPLAY "Download fail!!"
   END IF

   LET l_cmd = "rm ",l_name CLIPPED," 2>/dev/null"
   RUN l_cmd
    
END FUNCTION 

#FUN-BC0134 add END 

#FUN-D30055---add---START
FUNCTION i560_set_attr(ps_fields,p_flag)
  DEFINE   ps_fields          STRING
  DEFINE   p_flag             SMALLINT
  DEFINE   lst_fields         base.StringTokenizer,
           ls_field_name      STRING
  DEFINE   lnode_root         om.DomNode
  DEFINE   llst_items         om.NodeList
  DEFINE   li_i               INTEGER
  DEFINE   lnode_item         om.DomNode
  DEFINE   lnode_child        om.DomNode
  DEFINE   ls_item_name       STRING

  IF (ps_fields IS NULL) THEN
     RETURN
  END IF

  LET ps_fields = ps_fields.toLowerCase()

  LET lst_fields = base.StringTokenizer.create(ps_fields, ",")

  LET lnode_root = ui.Interface.getRootNode()
  LET llst_items = lnode_root.selectByPath("//Form//*")

  WHILE lst_fields.hasMoreTokens()
    LET ls_field_name = lst_fields.nextToken()
    LET ls_field_name = ls_field_name.trim()

    IF (ls_field_name.getLength() > 0) THEN
       FOR li_i = 1 TO llst_items.getLength()
           LET lnode_item = llst_items.item(li_i)
           LET ls_item_name = lnode_item.getAttribute("colName")
           IF (ls_item_name IS NULL) THEN
              LET ls_item_name = lnode_item.getAttribute("name")
              IF (ls_item_name IS NULL) THEN
                 CONTINUE FOR
              END IF
           END IF
           IF (ls_item_name.equals(ls_field_name)) THEN
              LET lnode_child = lnode_item.getFirstChild()
              IF p_flag THEN
                 CALL lnode_item.setAttribute("required","1")
                 CALL lnode_item.setAttribute("notNull","1")
              ELSE
                 CALL lnode_item.setAttribute("required","0")
                 CALL lnode_item.setAttribute("notNull","0")
              END IF
              EXIT FOR
           END IF
       END FOR
    END IF
  END WHILE
END FUNCTION 
#FUN-D30055---add-----END


