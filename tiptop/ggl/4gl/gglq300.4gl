# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: gglq300.4gl
# Descriptions...: 總分類帳
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-850030 08/05/26 By Carrier 報表查詢化 copy from gglr300
# Modify.........: No.FUN-850030 08/07/28 By dxfwo   新增程序從21區移植到31區
# Modify.........: No.FUN-8A0028 08/10/07 By Carrier 串查時,detail到月份
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930163 09/04/08 By elva 新增僅貨幣性科目選項
# Modify.........: No.MOD-940388 09/04/29 By wujie 字串連接%前要加轉義符\
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30106 10/03/30 By wujie 科目增加开窗功能
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No.TQC-B20174 11/02/24 By yinhy gglq301傳參錯誤
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位  
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-BC0075 11/12/08 By wujie  tm.u与gglq301同步                  
# Modify.........: No.FUN-C70061 12/07/13 By minpp 增加条件“分页显示”,单身增加科目编号，名称
# Modify.........: No.TQC-C90014 12/09/04 By lujh 輸入qbe後點擊【退出】應只退出查詢界面，不應將整個作業都退出.
# Modify.........: No.FUN-C80102 12/09/12 By chenying 報表改善
# Modify.........: No.TQC-CC0122 12/12/26 By yangtt 添加LET tm.a= ARG_VAL(24)
#                                         By chenying 串查明細時添加年度yy串查
# Modify.........: No.FUN-D10072 13/01/23 By chenying gglq301單據狀態調整，故gglq300串查相應調整
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示

DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
DEFINE tm              RECORD
                       wc        STRING,
                       wc1       STRING,   #FUN-C80102
                       wc2       STRING,   #FUN-C80102
                       t         LIKE type_file.chr1,
                       u         LIKE type_file.chr1,
                       s         LIKE type_file.chr1,
                       x         LIKE type_file.chr1,
                       e         LIKE type_file.chr1,
                       h         LIKE type_file.chr1, #TQC-930163 
                       y         LIKE type_file.num5,
                       more      LIKE type_file.chr1
                      ,a         LIKE type_file.chr1   #分页显示 #FUN-C70061
                      ,b         LIKE type_file.chr1   #FUN-C80102
                       END RECORD,
       yy,m1,m2        LIKE type_file.num10,
       y1,mm           LIKE type_file.num10,
       bookno          LIKE aaa_file.aaa01,
       l_flag          LIKE type_file.chr1
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE l_table         STRING
DEFINE g_str           STRING
DEFINE g_sql           STRING
DEFINE g_rec_b         LIKE type_file.num10
DEFINE g_aah01         LIKE aah_file.aah01
DEFINE g_aag02         LIKE aag_file.aag02
DEFINE g_aah           DYNAMIC ARRAY OF RECORD
                      #aah01_1    LIKE aah_file.aah01,        #FUN-C70061  #FUN-C80102
                      #aag02_1    LIKE aag_file.aag02,        #FUN-C70061  #FUN-C80102
                       aah01      LIKE aah_file.aah01,        #FUN-C80102
                       aag02      LIKE aag_file.aag02,        #FUN-C80102
                       mm         LIKE type_file.num5,
                       dd         LIKE type_file.num5,
                       memo       LIKE abb_file.abb04,
                       aah04      LIKE aah_file.aah04,
                       aah05      LIKE aah_file.aah05,
                       dc         LIKE type_file.chr10,
                       bal        LIKE abb_file.abb07
                       END RECORD
DEFINE g_pr            RECORD
                       aah01      LIKE aah_file.aah01,
                       aag02      LIKE aag_file.aag02,
                       type       LIKE type_file.chr1,
                       mm         LIKE type_file.num5,
                       dd         LIKE type_file.num5,
                       memo       LIKE abb_file.abb04,
                       aah04      LIKE aah_file.aah04,
                       aah05      LIKE aah_file.aah05,
                       dc         LIKE type_file.chr10,
                       bal        LIKE abb_file.abb07
                       END RECORD
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_msg1          LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE mi_no_ask       LIKE type_file.num5
DEFINE l_ac            LIKE type_file.num5
 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET bookno     = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc      = ARG_VAL(8)
   LET tm.wc    = cl_replace_str(tm.wc, "\\\"", "'") #FUN-C70061 add 
   LET tm.t       = ARG_VAL(9)
   LET tm.u       = ARG_VAL(10)
   LET tm.s       = ARG_VAL(11)
   LET tm.x       = ARG_VAL(12)
   LET tm.e       = ARG_VAL(13)
   LET tm.y       = ARG_VAL(14)
   LET yy         = ARG_VAL(15)
   LET m1         = ARG_VAL(16)
   LET m2         = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)
   LET tm.h       = ARG_VAL(22) #TQC-930163 
   LET tm.a       = ARG_VAL(23) #FUN-C70061 add
   LET tm.b       = ARG_VAL(24) #TQC-CC0122 add
 
   CALL q300_out_1()
   IF bookno IS  NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
 
   OPEN WINDOW q300_w AT 5,10
        WITH FORM "ggl/42f/gglq300" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()

   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL gglq300_tm()
      ELSE
           LET tm.wc1 = " 1=1" #FUN-C80102
           CALL gglq300()
           CALL gglq300_t()
   END IF
 
   CALL q300_menu()
   DROP TABLE gglq300_tmp;
   CLOSE WINDOW q300_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q300_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q300_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq300_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q300_out_2()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               LET l_ac =  ARR_CURR()  #FUN-C80102
               CALL q300_drill_detail(l_ac)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aah),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_aah01 IS NOT NULL THEN
                  LET g_doc.column1 = "aah01"
                  LET g_doc.value1 = g_aah01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq300_tm()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_cmd            LIKE type_file.chr1000
   DEFINE li_chk_bookno    LIKE type_file.num5      #FUN-B20010
   
   CALL s_dsmark(bookno)
   CLEAR FORM #清除畫面 #FUN-C80102
   CALL g_aah.clear()  #FUN-C80102
#FUN-C80102--mark--str---
#  LET p_row = 4 LET p_col = 20
#  OPEN WINDOW gglq300_w1 AT p_row,p_col
#       WITH FORM "ggl/42f/gglq300_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
#  CALL cl_ui_locale("gglq300_1")
#FUN-C80102--mark--end---
 
   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL
   LET yy       = y1
   LET m1       = mm
   LET m2       = mm
  #LET tm.t     = 'N'  #FUN-C80102
   LET tm.t     = 'Y'  #FUN-C80102
  #LET tm.u     = 'N'  #FUN-C80102
   LET tm.u     = '2'  #FUN-C80102
  #LET tm.x     = 'N'  #FUN-C80102
   LET tm.x     = 'Y'  #FUN-C80102
   LET tm.e     = 'N'
   LET tm.b     = 'N'  #FUN-C80102
   CALL cl_set_comp_visible("b",FALSE) #TQC-DC0064
   LET tm.h     = 'Y' #TQC-930163 
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET bookno=g_aza.aza81 
   LET tm.a = 'N'    #FUN-C70061 
   WHILE TRUE
   #FUN-B20055--begin
      #No.FUN-B20010  --Begin
       DISPLAY BY NAME bookno
#      INPUT BY NAME bookno WITHOUT DEFAULTS 
# 
#         BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#         
#         AFTER FIELD bookno
#            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
#            CALL s_check_bookno(bookno,g_user,g_plant)
#                 RETURNING li_chk_bookno
#            IF (NOT li_chk_bookno) THEN
#               NEXT FIELD bookno
#            END IF
#            SELECT * FROM aaa_file WHERE aaa01 = bookno
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
#               NEXT FIELD bookno
#            END IF
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(bookno)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_aaa'
#                  LET g_qryparam.default1 =bookno
#                  CALL cl_create_qry() RETURNING bookno
#                  DISPLAY BY NAME bookno
#                  NEXT FIELD bookno
#            END CASE
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#         ON ACTION about
#            CALL cl_about()
# 
#         ON ACTION help
#            CALL cl_show_help()
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
# 
#      END INPUT
#      #No.FUN-B20010  --End
#      CONSTRUCT BY NAME tm.wc ON aag01
# 
#         BEFORE CONSTRUCT
#             CALL cl_qbe_init()
##No.FUN-A30106 --begin                                                          
#         ON ACTION CONTROLP                                                     
#            CASE                                                                
#                WHEN INFIELD(aag01)                                             
#                  CALL cl_init_qry_var()                                        
#                  LET g_qryparam.state= "c"                                     
#                  LET g_qryparam.form = "q_aag"   
#                  LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                              
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
#                  DISPLAY g_qryparam.multiret TO aag01                          
#                  NEXT FIELD aag01                                              
#               OTHERWISE                                                        
#                  EXIT CASE                                                     
#            END CASE                                                            
##No.FUN-A30106 --end  
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            CALL cl_show_fld_cont()
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION about
#            CALL cl_about()
# 
#         ON ACTION help
#            CALL cl_show_help()
# 
#         ON ACTION controlg
#            CALL cl_cmdask()
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#      END CONSTRUCT
# 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
##FUN-A40009 --begin
##        LET INT_FLAG = 0
##        CLOSE WINDOW gglq300_w1
##        EXIT PROGRAM
##     END IF
#      ELSE
##FUN-A40009 --end
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
# 
#      DISPLAY BY NAME tm.t,tm.u,tm.x,tm.e,tm.h,tm.more #TQC-930163 
# 
#      #INPUT BY NAME bookno,yy,m1,m2,tm.t,tm.u,tm.x,tm.e,tm.h,tm.y,tm.more WITHOUT DEFAULTS  #TQC-930163  #FUN-B20010 mark
#      INPUT BY NAME yy,m1,m2,tm.t,tm.u,tm.x,tm.e,tm.h,tm.y,tm.more WITHOUT DEFAULTS  #FUN-B20010 
# 
#         BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#         AFTER FIELD yy
#            IF yy IS NULL THEN
#               NEXT FIELD yy
#            END IF
# 
#         AFTER FIELD m1
#            IF NOT cl_null(m1) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                 WHERE azm01 = yy
#               IF g_azm.azm02 = 1 THEN
#                  IF m1 > 12 OR m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               ELSE
#                  IF m1 > 13 OR m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               END IF
#            END IF
# 
#         AFTER FIELD m2
#            IF NOT cl_null(m2) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                 WHERE azm01 = yy
#               IF g_azm.azm02 = 1 THEN
#                  IF m2 > 12 OR m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               ELSE
#                  IF m2 > 13 OR m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               END IF
#            END IF
#            IF m2 IS NULL OR m2 < m1 THEN
#               NEXT FIELD m2
#            END IF
# 
#         AFTER FIELD t
#            IF tm.t NOT MATCHES "[YN]" THEN
#               NEXT FIELD t
#            END IF
# 
#         AFTER FIELD u
#            IF tm.u NOT MATCHES "[YN]" THEN
#               NEXT FIELD u
#            END IF
# 
#         AFTER FIELD x
#            IF tm.x NOT MATCHES "[YN]" THEN
#               NEXT FIELD x
#            END IF
# 
#         AFTER FIELD more
#            IF tm.more = 'Y' THEN
#               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                              g_bgjob,g_time,g_prtway,g_copies)
#                    RETURNING g_pdate,g_towhom,g_rlang,
#                              g_bgjob,g_time,g_prtway,g_copies
#            END IF
# 
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#        #No.FUN-B20010  --Begin
#        #ON ACTION CONTROLP
#        #   CASE
#        #      WHEN INFIELD(bookno)
#        #         CALL cl_init_qry_var()
#        #         LET g_qryparam.form = 'q_aaa'
#        #         LET g_qryparam.default1 =bookno
#        #         CALL cl_create_qry() RETURNING bookno
#        #         DISPLAY BY NAME bookno
#        #         NEXT FIELD bookno
#        #   END CASE
#        #No.FUN-B20010  --End
#        
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#         ON ACTION about
#            CALL cl_about()
# 
#         ON ACTION help
#            CALL cl_show_help()
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
# 
#      END INPUT
      
     #DISPLAY BY NAME tm.t,tm.u,tm.x,tm.e,tm.h,tm.a,tm.more   #FUN-C70061 ADD--a #FUN-C80102 
      DISPLAY BY NAME tm.u,tm.e,tm.h,tm.a,tm.b           #FUN-C70061 ADD--a #FUN-C80102 del t,x 
      DIALOG ATTRIBUTES(UNBUFFERED)
      
      INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         AFTER FIELD bookno
            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF
            
       END INPUT      

#FUN-C80102--mark--str--
#     CONSTRUCT BY NAME tm.wc ON aag01
#
#        #BEFORE CONSTRUCT
#        #    CALL cl_qbe_init()
#            
#     END CONSTRUCT        
#FUN-C80102--mark--str--

     #INPUT BY NAME yy,m1,m2,tm.t,tm.u,tm.x,tm.e,tm.h,tm.a,tm.y,tm.more   #FUN-C70061 ADD--a  #FUN-C80102
      INPUT BY NAME yy,m1,m2,tm.a,tm.e,tm.h,tm.y,tm.u,tm.b           #FUN-C70061 ADD--a  #FUN-C80102 del t ,x add b
      ATTRIBUTE(WITHOUT DEFAULTS=TRUE) 
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD yy
            IF yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD m1
            IF NOT cl_null(m1) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = yy
               IF g_azm.azm02 = 1 THEN
                  IF m1 > 12 OR m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               ELSE
                  IF m1 > 13 OR m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               END IF
            END IF
 
         AFTER FIELD m2
            IF NOT cl_null(m2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = yy
               IF g_azm.azm02 = 1 THEN
                  IF m2 > 12 OR m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               ELSE
                  IF m2 > 13 OR m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               END IF
            END IF
            IF m2 IS NULL OR m2 < m1 THEN
               NEXT FIELD m2
            END IF
         #TQC-DC0064--add--str--
         ON CHANGE u
            IF tm.u='2' THEN
               LET tm.b='N'
               CALL cl_set_comp_visible("b",FALSE)
            ELSE
               CALL cl_set_comp_visible("b",TRUE)
            END IF
         #TQC-DC0064--add--end
  
#FUN-C80102---mark---str---- 
#        AFTER FIELD t
#           IF tm.t NOT MATCHES "[YN]" THEN
#              NEXT FIELD t
#           END IF
 
#        AFTER FIELD u
#           IF tm.u NOT MATCHES "[YN]" THEN
#              NEXT FIELD u
#           END IF
#FUN-C80102---mark---end---- 
 
#FUN-C80102---mark---str---- 
#        AFTER FIELD x
#           IF tm.x NOT MATCHES "[YN]" THEN
#              NEXT FIELD x
#           END IF
#FUN-C80102---mark---end---- 

#FUN-C80102---mark---str---- 
#        AFTER FIELD more
#           IF tm.more = 'Y' THEN
#              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                             g_bgjob,g_time,g_prtway,g_copies)
#                   RETURNING g_pdate,g_towhom,g_rlang,
#                             g_bgjob,g_time,g_prtway,g_copies
#           END IF
#FUN-C80102---mark---end---- 
         
         #FUN-C70061--ADD---STR
          AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES'[YN]' THEN 
               NEXT FIELD a
            END IF   
          #FUN-C70061--ADD---END    
      END INPUT            
     
#FUN-C80102---add--str--
#     CONSTRUCT tm.wc ON aah01,aah04,aah05
#                 FROM s_aah[1].aah01,s_aah[1].aah04,s_aah[1].aah05
#        BEFORE CONSTRUCT
#          CALL cl_qbe_init()
#     END CONSTRUCT

      CONSTRUCT tm.wc ON aah01 FROM s_aah[1].aah01
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
      END CONSTRUCT
      CONSTRUCT tm.wc1 ON aah04,aah05
                  FROM s_aah[1].aah04,s_aah[1].aah05
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
      END CONSTRUCT 
#FUN-C80102---add--end--

 
      BEFORE DIALOG 
         CALL cl_qbe_init() 
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 =bookno
                  CALL cl_create_qry() RETURNING bookno
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno

#FUN-C80102--add--str--
          WHEN INFIELD(aah01)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aah01
               NEXT FIELD aah01
#FUN-C80102--add--end--
                  
#FUN-C80102---mark---str---
#               WHEN INFIELD(aag01)                                             
#                 CALL cl_init_qry_var()                                        
#                 LET g_qryparam.state= "c"                                     
#                 LET g_qryparam.form = "q_aag"   
#                 LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add                              
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret            
#                 DISPLAY g_qryparam.multiret TO aag01                          
#                 NEXT FIELD aag01                            
#FUN-C80102---mark---end---
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about
            CALL cl_about()

#FUN-C80102--add---str--
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG
#FUN-C80102--add---end--
 
         ON ACTION help
            CALL cl_show_help()
  
         ON ACTION qbe_save
            CALL cl_qbe_save()
#FUN-C80102--mark--str--                                                            
#        ON ACTION locale
#           LET g_action_choice = "locale"
#           CALL cl_show_fld_cont()
#           #EXIT CONSTRUCT
#FUN-C80102--mark--end--                                                            

 
         ON ACTION controlg
            CALL cl_cmdask()
  
         ON ACTION qbe_select
            CALL cl_qbe_select()
           
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION accept
            #No.TQC-B30147 --Begin
#FUN-C80102--mark--str--
#           IF cl_null(tm.wc) AND tm.wc = ' 1=1' THEN
#              CALL cl_err('','9046',0)
#              NEXT FIELD  aag01
#           END IF
#FUN-C80102--mark--str--
            #No.TQC-B30147 --End
            EXIT DIALOG 
            
         ON ACTION cancel 
            LET INT_FLAG = 1
            EXIT DIALOG         
      END DIALOG 
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
        #CLOSE WINDOW gglq300_w1   #FUN-C80102 mark 
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211    #TQC-C90014  mark
        #EXIT PROGRAM          #TQC-C90014  mark
         RETURN                #TQC-C90014  add
      END IF  
      IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF   #No.FUN-C80102  Add
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF      
#FUN-C80102--mark--str--
#     IF tm.wc = ' 1=1' THEN     
#        CALL cl_err('','9046',0)
#        CONTINUE WHILE
#     END IF      
#FUN-C80102--mark-end--
#FUN-B20055--end 
      SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = bdate
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='gglq300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglq300','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",bookno     CLIPPED,"' ",
                        " '",g_pdate    CLIPPED,"'",
                        " '",g_towhom   CLIPPED,"'",
                        " '",g_rlang    CLIPPED,"'",
                        " '",g_bgjob    CLIPPED,"'",
                        " '",g_prtway   CLIPPED,"'",
                        " '",g_copies   CLIPPED,"'",
                        " '",tm.wc      CLIPPED,"'",
                        " '",tm.t       CLIPPED,"'",
                        " '",tm.u       CLIPPED,"'",
                        " '",tm.s       CLIPPED,"'",
                        " '",tm.x       CLIPPED,"'",
                        " '",tm.y       CLIPPED,"'",
                        " '",yy         CLIPPED,"'",
                        " '",m1         CLIPPED,"'",
                        " '",m2         CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('gglq300',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW gglq300_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM

      END IF
      #END IF             #No.FUN-A40009
 
      CALL cl_wait()

      CALL gglq300()
 
      ERROR ""
      EXIT WHILE
   END WHILE
 
#  CLOSE WINDOW gglq300_w1   #FUN-C80102
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
   CALL gglq300_t()
 
END FUNCTION

{
#FUN-C80102--add--str--
FUNCTION q300_b_askkey()

   CONSTRUCT tm.wc ON aah01,aah04,aah05
                  FROM s_aah[1].aah01,s_aah[1].aah04,s_aah[1].aah05
   BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aah01)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"   #FUN-B20010 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aah01
               NEXT FIELD aah01 
       END CASE
    END CONSTRUCT
END FUNCTION
#FUN-C80102--add--end--
} 

FUNCTION gglq300()
   DEFINE l_name        LIKE type_file.chr20,
          #l_sql         LIKE type_file.chr1000,
          #l_sql1        LIKE type_file.chr1000,
          l_sql         STRING,      #NO.FUN-910082
          l_sql1        STRING,      #NO.FUN-910082
          l_chr         LIKE type_file.chr1,
          l_za05        LIKE type_file.chr1000,
          l_bal         LIKE aah_file.aah04,
          l_aah041      LIKE aah_file.aah04,
          l_aah051      LIKE aah_file.aah05,
          sr1           RECORD
                        aag01 LIKE aag_file.aag01,
                        aag02 LIKE aag_file.aag02,
                        aag13 LIKE aag_file.aag13,
                        aag07 LIKE aag_file.aag07,
                        aag24 LIKE aag_file.aag24
                        END RECORD,
          sr            RECORD
                        aah00 LIKE aah_file.aah00,
                        aah01 LIKE aah_file.aah01,
                        aah02 LIKE aah_file.aah02,
                        aah03 LIKE aah_file.aah03,
                        aah04 LIKE aah_file.aah04,
                        aah05 LIKE aah_file.aah05,
                        aag02 LIKE aag_file.aag02,
                        aag13 LIKE aag_file.aag13
                        END RECORD
   DEFINE s_aah04    LIKE aah_file.aah04
   DEFINE s_aah05    LIKE aah_file.aah05
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_date     LIKE type_file.dat
   DEFINE l_date1    LIKE type_file.dat
   DEFINE l_dd       LIKE type_file.num5
   DEFINE l_aag01    LIKE aag_file.aag01   #FUN-C80102
  
   CALL gglq300_table()
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = bookno
      AND aaf02 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030


   LET tm.wc  = cl_replace_str(tm.wc,"aah01","aag01")   #FUN-C80102 
   LET l_sql1= "SELECT aag01,aag02,aag13,aag07,aag24 ",
               "  FROM aag_file ",   
#              " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               " WHERE aag03 ='2' ",
               "   AND aag00 ='", bookno,"' ",  
               "   AND ",tm.wc CLIPPED    
     #TQC-930163 --begin
     IF tm.h = 'Y' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND aag09 = 'Y' "
     END IF
     #TQC-930163 --end
 
   PREPARE gglq300_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gglq300_curs2 CURSOR FOR gglq300_prepare2

  
      LET g_sql = " SELECT SUM(abb07) FROM aba_file,abb_file ",
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",bookno,"'",
                  "    AND abb03 LIKE ? ",
                  "    AND abb06 = ? ",
                  "    AND aba03 = ",yy,
                  "    AND aba04 BETWEEN ? AND ? "    #FUN-C80102 del , 
                 #"    AND aba19 = 'Y' AND abapost = 'N' "  #FUN-C80102
#FUN-C80102--add--str--- 
     IF tm.b = 'Y' THEN
        IF tm.u = '1' THEN
           LET g_sql = g_sql CLIPPED," AND ( aba19 = 'N' OR (aba19 = 'Y' AND abapost = 'N')) "
        ELSE
           LET g_sql = g_sql CLIPPED," AND aba19 = 'N' "
        END IF
     END IF
     IF tm.b = 'N' THEN
        IF tm.u = '1' THEN
           LET g_sql = g_sql CLIPPED," AND aba19 = 'Y' AND abapost = 'N' "
        ELSE
           LET g_sql = g_sql CLIPPED," AND aba19 = '1' "  #當tm.b為N且tm.u為2時，此sql不處理
        END IF
     END IF
#FUN-C80102--add--end--- 

   PREPARE q300_abb_p FROM g_sql
   DECLARE q300_abb_cs CURSOR FOR q300_abb_p
 
#  #FUN-C80102--add--str-- 
#  LET l_sql = "SELECT DISTINCT aag01 ",
#              " FROM aah_file LEFT OUTER JOIN aag_file ON aah00 = aag00 AND aah01 = aag01 ",
#              " WHERE aag03 ='2' ",
#              "   AND aag00 ='", bookno,"' ",
#              "   AND ",tm.wc CLIPPED
#  PREPARE gglq300_pre FROM l_sql
#  IF STATUS != 0 THEN
#     CALL cl_err('pre:',STATUS,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF
#  DECLARE gglq300_cur CURSOR FOR gglq300_pre
#  FOREACH gglq300_cur INTO l_aag01 
#     OPEN gglq300_curs2 USING l_aag01    
#  #FUN-C80102--add--end-- 
      FOREACH gglq300_curs2 INTO sr1.* 
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
      IF sr1.aag24 IS NULL THEN
         LET sr1.aag24 = 99
      END IF
 
      IF NOT cl_null(tm.y) THEN
         IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      #LET g_cnt = 0               #FUN-C70061
      LET l_flag='N'
 
      LET sr.aah01=sr1.aag01
      LET sr.aag02=sr1.aag02
      IF tm.e ='Y' THEN
         LET sr.aag02=sr1.aag13
      END IF
 
      CALL q300_f(sr1.aag01,m1,m2) RETURNING l_bal,l_aah041,l_aah051
      IF l_aah041 = 0 AND l_aah051 = 0 AND l_bal = 0 THEN
         IF tm.t = 'Y' THEN
            CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
            INSERT INTO gglq300_tmp VALUES(sr.aah01,sr.aag02,'1',0,0,g_msg,0,0,'',0)
         END IF
      ELSE
         CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
         CALL cl_getmsg('ggl-211',g_lang) RETURNING g_msg1
         IF l_bal < 0 THEN
            LET l_bal = l_bal * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING g_msg1
         ELSE
            IF l_bal = 0 THEN
               CALL cl_getmsg('ggl-210',g_lang) RETURNING g_msg1
            END IF
         END IF
         INSERT INTO gglq300_tmp VALUES(sr.aah01,sr.aag02,'1',0,0,g_msg,0,0,g_msg1,l_bal)
         FOR l_i = m1 TO m2
             LET sr.aah04 = 0
             LET sr.aah05 = 0
             CALL q300_bal_aah(sr1.aag01,l_i) RETURNING l_bal,sr.aah04,sr.aah05
             CALL q300_y_aah(sr1.aag01,l_i) RETURNING s_aah04,s_aah05
             CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
             LET l_dd = DAY(l_date1)
             CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
             CALL cl_getmsg('ggl-211',g_lang) RETURNING g_msg1
             IF l_bal < 0 THEN
                LET l_bal = l_bal * -1
                CALL cl_getmsg('ggl-212',g_lang) RETURNING g_msg1
             ELSE
                IF l_bal = 0 THEN
                   CALL cl_getmsg('ggl-210',g_lang) RETURNING g_msg1
                END IF
             END IF
             INSERT INTO gglq300_tmp VALUES(sr.aah01,sr.aag02,'2',l_i,l_dd,g_msg,
                                            sr.aah04,sr.aah05,g_msg1,l_bal)
 
             CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
             INSERT INTO gglq300_tmp VALUES(sr.aah01,sr.aag02,'3',l_i,l_dd,g_msg,
                                            s_aah04,s_aah05,g_msg1,l_bal)
         END FOR
      END IF
   END FOREACH
#  CLOSE gglq300_curs2  #FUN-C80102 
#  END FOREACH  #FUN-C80102
 
END FUNCTION
 
FUNCTION gglq300_cs()

   #FUN-C70061--ADD---STR
    IF tm.a='N' THEN
        LET g_sql = "SELECT '','' FROM gglq300_tmp ",
                    " ORDER BY aah01"
    ELSE
   #FUN-C70061--ADD---END
     LET g_sql = "SELECT UNIQUE aah01,aag02 FROM gglq300_tmp ",
                 " ORDER BY aah01 "
    END IF        #FUN-C70061  
     PREPARE gglq300_ps FROM g_sql
     DECLARE gglq300_curs SCROLL CURSOR WITH HOLD FOR gglq300_ps
    
    #FUN-C70061--ADD--STR
     IF tm.a='N' THEN
        OPEN gglq300_curs
        IF SQLCA.sqlcode THEN
           CALL cl_err('OPEN gglq300_curs',SQLCA.sqlcode,0)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM
        ELSE
           LET g_row_count=1
           DISPLAY g_row_count TO FORMONLY.cnt
           CALL gglq300_fetch('F')
        END IF
     ELSE
   #FUN-C70061--ADD--END   
     LET g_sql = "SELECT UNIQUE aah01,aag02 FROM gglq300_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq300_ps1 FROM g_sql
     EXECUTE gglq300_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq300_ps2 FROM g_sql
     DECLARE gglq300_cnt CURSOR FOR gglq300_ps2
 
     OPEN gglq300_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq300_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq300_cnt
        FETCH gglq300_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq300_fetch('F')
     END IF
   END IF
END FUNCTION
 
FUNCTION gglq300_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq300_curs INTO g_aah01,g_aag02
      WHEN 'P' FETCH PREVIOUS gglq300_curs INTO g_aah01,g_aag02
      WHEN 'F' FETCH FIRST    gglq300_curs INTO g_aah01,g_aag02
      WHEN 'L' FETCH LAST     gglq300_curs INTO g_aah01,g_aag02
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump gglq300_curs INTO g_aah01,g_aag02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aah01,SQLCA.sqlcode,0)
      INITIALIZE g_aah01 TO NULL
      INITIALIZE g_aag02 TO NULL
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
 
   CALL gglq300_show()
END FUNCTION
 
FUNCTION gglq300_show()
 
#  DISPLAY g_aah01 TO aah01    #FUN-C80102
#  DISPLAY g_aag02 TO aag02    #FUN-C80102
   DISPLAY bookno TO bookno    #FUN-C80102
   DISPLAY yy TO yy
   DISPLAY m1 TO m1            #FUN-C80102  
   DISPLAY m2 TO m2            #FUN-C80102
   DISPLAY tm.u TO u           #FUN-C80102
   DISPLAY tm.e TO e           #FUN-C80102
   DISPLAY tm.h TO h           #FUN-C80102
   DISPLAY tm.a TO a           #FUN-C80102
   DISPLAY tm.y TO y           #FUN-C80102
   DISPLAY tm.b TO b           #FUN-C80102
 
   CALL gglq300_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq300_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
  
  LET tm.wc  = cl_replace_str(tm.wc,"aag01","aah01")  #FUN-C80102
  #FUN-C70061---ADD---STR
  IF tm.a='N' THEN
     LET g_sql = "SELECT aah01,'',mm,dd,memo,aah04,aah05,dc,bal,type",
                 " FROM gglq300_tmp",
                 " WHERE ", tm.wc CLIPPED,   #FUN-C80102 
                 "   AND ", tm.wc1 CLIPPED,  #FUN-C80102
                 " ORDER BY aah01,mm,type,dd" 
  ELSE  
  #FUN-C70061---ADD---END
   #LET g_sql = "SELECT mm,dd,memo,aah04,aah05,dc,bal,type",           #FUN-C70061
    #LET g_sql = "SELECT '','',mm,dd,memo,aah04,aah05,dc,bal,type",  #FUN-C70061  #FUN-C80102
     LET g_sql = "SELECT aah01,'',mm,dd,memo,aah04,aah05,dc,bal,type",  #FUN-C70061  #FUN-C80102
               " FROM gglq300_tmp",
               " WHERE aah01 ='",g_aah01,"'",
               "   AND ", tm.wc CLIPPED,   #FUN-C80102 
               "   AND ", tm.wc1 CLIPPED,  #FUN-C80102
               " ORDER BY mm,type,dd "
  END IF    #FUN-C70061
   PREPARE gglq300_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq300_pb
 
   CALL g_aah.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH abb_curs INTO g_aah[g_cnt].*,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aah[g_cnt].aah04 = cl_numfor(g_aah[g_cnt].aah04,20,g_azi04)
      LET g_aah[g_cnt].aah05 = cl_numfor(g_aah[g_cnt].aah05,20,g_azi04)
      LET g_aah[g_cnt].bal = cl_numfor(g_aah[g_cnt].bal,20,g_azi04)
      
      #FUN-C70061---ADD---STR
     #SELECT aag02 INTO g_aah[g_cnt].aag02_1 FROM aag_file  #FUN-C80102
      SELECT aag02 INTO g_aah[g_cnt].aag02 FROM aag_file    #FUN-C80102
      #WHERE aag01 = g_aah[g_cnt].aah01_1   #FUN-C80102
       WHERE aag01 = g_aah[g_cnt].aah01     #FUN-C80102
      #FUN-C70061---ADD---END
      
      IF l_type = '1' THEN
         LET g_aah[g_cnt].mm = NULL
         LET g_aah[g_cnt].dd = NULL
         LET g_aah[g_cnt].aah04 = NULL
         LET g_aah[g_cnt].aah05 = NULL
      #  LET g_aah[g_cnt].dc  = NULL
      END IF
      IF l_type = '3' THEN
         LET g_aah[g_cnt].mm = NULL
         LET g_aah[g_cnt].dd = NULL
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_aah.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
#本年合計借/貸
FUNCTION q300_y_aah(p_aah01,p_aah03)
  DEFINE p_aah01      LIKE aah_file.aah01
  DEFINE p_aah03      LIKE aah_file.aah03
  DEFINE l_aah04      LIKE aah_file.aah04
  DEFINE l_aah05      LIKE aah_file.aah05
  DEFINE l_aag01_str  LIKE type_file.chr50
  DEFINE l_d          LIKE aah_file.aah04
  DEFINE l_c          LIKE aah_file.aah04
 
     LET l_aag01_str = p_aah01 CLIPPED,'\%'    #No.MOD-940388
 
     LET l_aah04 = 0   LET l_aah05 = 0
     SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05 FROM aah_file
      WHERE aah00 = bookno
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 <= p_aah03
        AND aah03 > 0
 
     IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
     IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
 
     LET l_d = 0     LET l_c = 0
    #IF tm.u = 'Y' THEN  #FUN-C80102
        OPEN q300_abb_cs USING l_aag01_str,'1','1',p_aah03
        FETCH q300_abb_cs INTO l_d
        IF cl_null(l_d) THEN LET l_d = 0 END IF
        CLOSE q300_abb_cs
        OPEN q300_abb_cs USING l_aag01_str,'2','1',p_aah03
        FETCH q300_abb_cs INTO l_c
        CLOSE q300_abb_cs
        IF cl_null(l_c) THEN LET l_c = 0 END IF
    #END IF             #FUN-C80102
     LET l_aah04 = l_aah04 + l_d
     LET l_aah05 = l_aah05 + l_c
 
     RETURN l_aah04,l_aah05
END FUNCTION
 
#本期借/貸 本期期末余額
FUNCTION q300_bal_aah(p_aah01,p_aah03)
  DEFINE p_aah01      LIKE aah_file.aah01
  DEFINE p_aah03      LIKE aah_file.aah03
  DEFINE l_bal        LIKE aah_file.aah04
  DEFINE l_aah04      LIKE aah_file.aah04
  DEFINE l_aah05      LIKE aah_file.aah05
  DEFINE l_aag01_str  LIKE type_file.chr50
  DEFINE l_d          LIKE aah_file.aah04
  DEFINE l_c          LIKE aah_file.aah04
 
     LET l_aag01_str = p_aah01 CLIPPED,'\%'    #No.MOD-940388
 
     LET l_bal = 0  LET l_aah04 = 0  LET l_aah05 = 0
 
     SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
      WHERE aah00 = bookno
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 <= p_aah03
 
     IF cl_null(l_bal) THEN LET l_bal = 0 END IF
 
     LET l_d = 0     LET l_c = 0
    #IF tm.u = 'Y' THEN  #FUN-C80102
        OPEN q300_abb_cs USING l_aag01_str,'1','1',p_aah03
        FETCH q300_abb_cs INTO l_d
        IF cl_null(l_d) THEN LET l_d = 0 END IF
        CLOSE q300_abb_cs
        OPEN q300_abb_cs USING l_aag01_str,'2','1',p_aah03
        FETCH q300_abb_cs INTO l_c
        CLOSE q300_abb_cs
        IF cl_null(l_c) THEN LET l_c = 0 END IF
    #END IF             #FUN-C80102
     LET l_bal = l_bal + l_d - l_c
 
     SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05 FROM aah_file
      WHERE aah00 = bookno
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 = p_aah03
 
     IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
     IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
     LET l_d = 0     LET l_c = 0
    #IF tm.u = 'Y' THEN  #FUN-C80102
        OPEN q300_abb_cs USING l_aag01_str,'1',p_aah03,p_aah03
        FETCH q300_abb_cs INTO l_d
        IF cl_null(l_d) THEN LET l_d = 0 END IF
        CLOSE q300_abb_cs
        OPEN q300_abb_cs USING l_aag01_str,'2',p_aah03,p_aah03
        FETCH q300_abb_cs INTO l_c
        CLOSE q300_abb_cs
        IF cl_null(l_c) THEN LET l_c = 0 END IF
    #END IF             #FUN-C80102
     LET l_aah04 = l_aah04 + l_d
     LET l_aah05 = l_aah05 + l_c
 
     RETURN l_bal,l_aah04,l_aah05
END FUNCTION
 
FUNCTION q300_f(p_aah01,p_aah03_1,p_aah03_2)
   DEFINE p_aah01      LIKE aah_file.aah01
   DEFINE p_aah03_1    LIKE aah_file.aah03
   DEFINE p_aah03_2    LIKE aah_file.aah03
   DEFINE l_bal        LIKE aah_file.aah04
   DEFINE l_aah04      LIKE aah_file.aah04
   DEFINE l_aah05      LIKE aah_file.aah05
   DEFINE l_aag01_str  LIKE type_file.chr50
   DEFINE l_d          LIKE aah_file.aah04
   DEFINE l_c          LIKE aah_file.aah04
   DEFINE l_aah03      LIKE aah_file.aah03
 
      LET l_aag01_str = p_aah01 CLIPPED,'\%'    #No.MOD-940388
 
      LET l_bal = 0  LET l_aah04 = 0  LET l_aah05 = 0
 
      #期初
      SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
       WHERE aah00 = bookno
         AND aah01 = p_aah01
         AND aah02 = yy
         AND aah03 < p_aah03_1
 
      IF cl_null(l_bal) THEN LET l_bal = 0 END IF
 
      LET l_d = 0     LET l_c = 0
      LET l_aah03 = p_aah03_1 - 1
     #IF tm.u = 'Y' THEN  #FUN-C80102
         OPEN q300_abb_cs USING l_aag01_str,'1','1',l_aah03
         FETCH q300_abb_cs INTO l_d
         IF cl_null(l_d) THEN LET l_d = 0 END IF
         CLOSE q300_abb_cs
         OPEN q300_abb_cs USING l_aag01_str,'2','1',l_aah03
         FETCH q300_abb_cs INTO l_c
         CLOSE q300_abb_cs
         IF cl_null(l_c) THEN LET l_c = 0 END IF
     #END IF              #FUN-C80102 
      LET l_bal = l_bal + l_d - l_c
 
      #期間
      SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05 FROM aah_file
       WHERE aah00 = bookno
         AND aah01 = p_aah01
         AND aah02 = yy
         AND aah03 >= p_aah03_1
         AND aah03 <= p_aah03_2
 
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
 
      LET l_d = 0     LET l_c = 0
     #IF tm.u = 'Y' THEN  #FUN-C80102
         OPEN q300_abb_cs USING l_aag01_str,'1',p_aah03_1,p_aah03_2
         FETCH q300_abb_cs INTO l_d
         IF cl_null(l_d) THEN LET l_d = 0 END IF
         CLOSE q300_abb_cs
         OPEN q300_abb_cs USING l_aag01_str,'2',p_aah03_1,p_aah03_2
         FETCH q300_abb_cs INTO l_c
         CLOSE q300_abb_cs
         IF cl_null(l_c) THEN LET l_c = 0 END IF
     #END IF              #FUN-C80102  
      LET l_aah04 = l_aah04 + l_d
      LET l_aah05 = l_aah05 + l_c
 
      RETURN l_bal,l_aah04,l_aah05
END FUNCTION
 
FUNCTION q300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aah TO s_aah.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A40009 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
#No.FUN-A40009 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL gglq300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL gglq300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION gglq300_table()
     DROP TABLE gglq300_tmp;
     CREATE TEMP TABLE gglq300_tmp(
                    aah01       LIKE aah_file.aah01,
#                   aag02       LIKE aag_file.aag02,
                    aag02       LIKE type_file.chr1000,     #No.MOD-940388
                    type        LIKE type_file.chr1,
                    mm          LIKE aah_file.aah03,
                    dd          LIKE aah_file.aah03,
                    memo        LIKE type_file.chr50,
                    aah04       LIKE aah_file.aah04,
                    aah05       LIKE aah_file.aah05,
                    dc          LIKE type_file.chr10,
                    bal         LIKE aah_file.aah04);
END FUNCTION
 
FUNCTION q300_out_1()
 
   LET g_sql = " aah01.aah_file.aah01,",
               " aag02.aag_file.aag02,",
               " type.type_file.chr1,",
               " mm.aah_file.aah03,",
               " dd.aah_file.aah03,",
               " memo.type_file.chr50,",
               " aah04.aah_file.aah04,",
               " aah05.aah_file.aah05,",
               " dc.type_file.chr10,",
               " bal.aah_file.aah04 "
 
   LET l_table = cl_prt_temptable('gglq300',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION q300_out_2()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_ted02            LIKE ted_file.ted02
 
   CALL cl_del_data(l_table)
 
   LET l_aag01 = NULL
   LET l_ted02 = NULL
   DECLARE gglq300_tmp_curs CURSOR FOR
    SELECT * FROM gglq300_tmp
     ORDER BY aah01,mm,type,dd
   FOREACH gglq300_tmp_curs INTO g_pr.*
      EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",g_azi04
   IF tm.a='Y' THEN                                        #FUN-C70061
      CALL cl_prt_cs3('gglq300','gglq300',g_sql,g_str)
   ELSE                                                    #FUN-C70061
      CALL cl_prt_cs3('gglq300','gglq300_1',g_sql,g_str)   #FUN-C70061
   END IF                
 
END FUNCTION
 
FUNCTION q300_drill_detail(p_ac)
   DEFINE 
          #l_wc    LIKE type_file.chr50
          l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_k     LIKE type_file.chr1
   DEFINE p_ac            LIKE type_file.num5  #FUN-C80102
#FUN-C80102--mark--str-- 
#  IF tm.a='Y'  THEN                          #FUN-C70061           
#     IF g_aah01 IS NULL THEN RETURN END IF
#     LET l_wc = 'aag01 like "',g_aah01,'%"'
#  ELSE                                       #FUN-C70061
#FUN-C80102--mark--str-- 
    #IF cl_null(g_aah[l_ac].aah01_1) THEN RETURN END IF            #FUN-C70061  #FUN-C80102
    #LET l_wc = 'aag01 like "',g_aah[l_ac].aah01_1,'%"'    #FUN-C80102 
     IF cl_null(g_aah[p_ac].aah01) THEN RETURN END IF            #FUN-C70061  #FUN-C80102
     LET l_wc = 'aea05 like "',g_aah[p_ac].aah01,'%"'    #FUN-C80102 
#  END IF    #FUN-C70061  #FUN-C80102
   #No.FUN-8A0028  --Begin
   #CALL s_azn01(yy,m2) RETURNING l_bdate,l_edate
   #LET l_bdate = MDY(m1,1,yy)
   IF p_ac > 0 AND NOT cl_null(g_aah[p_ac].mm) THEN              #FUN-C80102 l_ac->p_ac
      CALL s_azn01(yy,g_aah[p_ac].mm) RETURNING l_bdate,l_edate  #FUN-C80102 l_ac->p_ac
   ELSE
      RETURN
   END IF
   #No.FUN-8A0028  --End
#  IF tm.u = '2' THEN LET l_k = '2' END IF  #FUN-C80102 Y->2  #FUN-C80102
#  IF tm.u = '1' THEN LET l_k = '3' END IF  #FUN-C80102 N->1  #FUN-C80102
#  IF tm.u = '1' THEN LET l_k = '2' END IF  #FUN-C80102  #FUN-D10072
#  IF tm.u = '2' THEN LET l_k = '3' END IF  #FUN-C80102  #FUN-D10072
  #LET g_msg = "gglq301 '",bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' ' 1=1' 'N' 'Y' 'N' '",tm.e,"' '' '",l_k,"' '",l_bdate,"' '",l_edate,"' '' '' '' ''"
  # LET g_msg = "gglq301 '",bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' ' 1=1' 'N' 'Y' 'N' '",tm.e,"' '' '",l_k,"' '",l_bdate,"' '",l_edate,"' '' '' '' '' 'N' '",tm.h,"'"
#FUN-D10072 --mark  
#No.MOD-BC0075 --begin 
# #IF tm.u ='Y' THEN  #FUN-C80102
#  IF tm.u ='2' THEN  #FUN-C80102 
#     LET g_msg = "gglq301 '",bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.t,"' '",tm.x,"' 'N' '' 'N' '",tm.e,"' '",tm.h,"' '",tm.y,"' '3' '' '' '' '' '",tm.a,"' '",yy,"'"  #TQC-B20174    #FUN-C70061 add tm.a 1->3 #TQC-CC0122 add yy
#  ELSE 
#     LET g_msg = "gglq301 '",bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.t,"' '",tm.x,"' 'N' '' 'N' '",tm.e,"' '",tm.h,"' '",tm.y,"' '2' '' '' '' '' '",tm.a,"' '",yy,"'"  #TQC-B20174    #FUN-C70061 add tm.a 3->2  #TQC-CC0122 add yy
#  END IF   
#No.MOD-BC0075 --end    
#FUN-D10072 --mark  
#FUN-D10072 --add
    LET g_msg = "gglq301 '",bookno,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.t,"' '",tm.x,"' 'N' '' 'N' '",tm.e,"' '",tm.h,"' '",tm.y,"' '",tm.u,"' '' '' '' '' '",tm.a,"' '",yy,"' '",tm.b,"' "
#FUN-D10072 --add
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION gglq300_t()
#FUN-C80102---mark--str--
{
#No:FUN-C70061 --add--str
   IF tm.a = 'Y' THEN
     #CALL cl_set_comp_visible("aah01_1,aag02_1",FALSE) #FUN-C80102 
     #CALL cl_set_comp_visible("aah01,aag02",TRUE)      #FUN-C80102
      CALL cl_set_comp_visible("aah01,aag02",FALSE)     #FUN-C80102
      CALL cl_set_comp_visible("aah01_1,aag02_1",TRUE)  #FUN-C80102
   ELSE 
     #CALL cl_set_comp_visible("aah01_1,aag02_1",TRUE)  #FUN-C80102
     #CALL cl_set_comp_visible("aah01,aag02",FALSE)     #FUN-C80102
      CALL cl_set_comp_visible("aah01,aag02",TRUE)      #FUN-C80102
      CALL cl_set_comp_visible("aah01_1,aag02_1",FALSE) #FUN-C80102
   END IF 
#No:FUN-C70061 --add--end
}
#FUN-C80102---mark--end--

   LET g_aah01 = NULL
   LET g_aag02 = NULL
   CLEAR FORM
   CALL g_aah.clear()
   CALL gglq300_cs()
 
END FUNCTION
