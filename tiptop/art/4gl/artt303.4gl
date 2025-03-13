# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt303.4gl
# Descriptions...: 組合促銷單
# Date & Author..: NO.FUN-A60044 10/06/24 By Cockroach 
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-A80104 10/08/19 By lixia資料類型改為varchar2(2)
# Modify.........: No.TQC-A80132 10/08/24 By houlia 單身數量控管不能小於等於零，同時正確複製rag06
# Modify.........: No.TQC-A80161 10/08/30 By houlia 將l_time1、l_time2的類型調整為number
# Modify.........: No.TQC-A80158 10/08/30 By houlia 取消作廢功能
# Modify.........: No.FUN-A80104 10/09/21 By lixia 增加臨時表創建刪除函數
# Modify.........: No.FUN-A80104 10/10/08 By lixia 發佈時增加對換贈資料的處理
# Modify.........: No.TQC-A90027 10/10/13 By houlia 修改特賣價報錯信息
# Modify.........: No.TQC-A90023 10/10/15 By houlia 單身一參與方式選2.可選時不需要檢查數量是否>0
# Modify.........: No.TQC-A90025 10/10/15 By houlia rae27=N時，促銷實現方式，換贈方式，換贈類型，最多可選數量也需顯示出來 no entry即可
# Modify.........: No:TQC-AA0109 10/10/20 By lixia sql修正
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0033 10/11/08 By wangxin 促銷BUG調整
# Modify.........: No.FUN-AB0093 10/11/24 By huangtao 增加發佈日期和發佈時間
# Modify.........: No.TQC-AB0338 10/11/29 By Cockroach 系统联测，bug修改
# Modify.........: No.FUN-AB0101 10/12/06 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號，否則抓ima_file
# Modify.........: No.TQC-AC0193 10/12/15 By wangxin 根據促銷方式，控管相應欄位的值
# Modify.........: No.MOD-AC0172 10/12/18 By suncx 會員等級促銷BUG調整
# Modify.........: No.TQC-A80160 10/12/21 By houlia rae15欄位名稱同時顯示
# Modify.........: No:TQC-AC0326 10/12/22 By wangxin 促銷302/303/304規格調整，發布時間調整，
#                                                    畫面原來的發布時間mark掉，新增欄位在生效營運中心按鈕中顯示，
#                                                    并添加取消確認按鈕(未發布可取消審核)
# Modify.........: No:TQC-B10082 11/01/11 By zhangll 修改更新非空栏位为空问题
# Modify.........: No:TQC-B10129 11/01/13 By zhangll 更新取消审核显示问题
# Modify.........: No:TQC-B10131 11/01/13 By zhangll 取消审核where条件修正
# Modify.........: No:FUN-B30012 11/03/08 By baogc 換贈信息修改
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60071 11/06/14 By baogc 新增過單身一時回寫單頭組合總量，新增審核時判斷組合數量是否滿足組合總量的要求
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-BB0058 11/11/16 By pauline GP5.3 artt303 組合促銷單促銷功能優化
# Modify.........: No.FUN-C10008 12/01/04 By pauline GP5.3 artt302 一般促銷單促銷功能優化調整
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20106 12/02/10 By pauline GP5.3 刪除錯誤處理
# Modify.........: No.TQC-C20336 12/02/21 By pauline 刪除錯誤處理
# Modify.........: No:FUN-C30151 12/03/20 By pauline 促銷時段增加CONTROLO 功能
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80118 12/08/22 By yangxf 在時段設定中下條件，會查詢出所有的資料，且時段設定單身為空
# Modify.........: No:FUN-CB0034 12/11/27 By pauline 當勾選會員專享時,將rae15特賣價給預設值0
# Modify.........: No.MOD-CC0219 13/01/05 By SunLM artt302,artt303,artt304範圍設置單身，編碼類型為產品時，錄入時代碼可以開窗多選形式進行錄入
# Modify.........: No.FUN-CC0129 13/01/07 By SunLM artt302,artt303,artt304新增複製功能
# Modify.........: No:MOD-CC0144 13/01/25 By Carrier "组合总量"不空时,单身的"参与方式"可entry
# Modify.........: No.MOD-CA0199 13/02/01 By Elise 調整FUNCTION t303_rae10_entry中用g_rae_o給值的欄位,增加判斷null時給0
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/18 by chenjing 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rae         RECORD LIKE rae_file.*,
       g_rae_t       RECORD LIKE rae_file.*,
       g_rae_o       RECORD LIKE rae_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_raf         DYNAMIC ARRAY OF RECORD
           raf03          LIKE raf_file.raf03,
           raf04          LIKE raf_file.raf04,
           raf05          LIKE raf_file.raf05,
           rafacti        LIKE raf_file.rafacti
                     END RECORD,
       g_raf_t       RECORD
           raf03          LIKE raf_file.raf03,
           raf04          LIKE raf_file.raf04,
           raf05          LIKE raf_file.raf05,
           rafacti        LIKE raf_file.rafacti
                     END RECORD,
       g_raf_o       RECORD 
           raf03          LIKE raf_file.raf03,
           raf04          LIKE raf_file.raf04,
           raf05          LIKE raf_file.raf05,
           rafacti        LIKE raf_file.rafacti
                     END RECORD,
       g_rag         DYNAMIC ARRAY OF RECORD
           rag03          LIKE rag_file.rag03,
           rag04          LIKE rag_file.rag04,
           rag05          LIKE rag_file.rag05,
           rag05_desc     LIKE type_file.chr100,
           rag06          LIKE rag_file.rag06,
           rag06_desc     LIKE gfe_file.gfe02,
           ragacti        LIKE rag_file.ragacti
                     END RECORD,
       g_rag_t       RECORD
           rag03          LIKE rag_file.rag03,
           rag04          LIKE rag_file.rag04,
           rag05          LIKE rag_file.rag05,
           rag05_desc     LIKE type_file.chr100,
           rag06          LIKE rag_file.rag06,
           rag06_desc     LIKE gfe_file.gfe02,
           ragacti        LIKE rag_file.ragacti
                     END RECORD,
       g_rag_o       RECORD
           rag03          LIKE rag_file.rag03,
           rag04          LIKE rag_file.rag04,
           rag05          LIKE rag_file.rag05,
           rag05_desc     LIKE type_file.chr100,
           rag06          LIKE rag_file.rag06,
           rag06_desc     LIKE gfe_file.gfe02,
           ragacti        LIKE rag_file.ragacti
                     END RECORD,
       g_temp        DYNAMIC ARRAY OF RECORD
           temp01         LIKE type_file.chr1,
           temp02         LIKE rwf_file.rwf04,
           temp03         LIKE rwf_file.rwf03,
           temp04         LIKE rwf_file.rwf21,
           temp05         LIKE rwf_file.rwf22,
           temp06         LIKE rwf_file.rwf11,
           temp07         LIKE rwf_file.rwf19,
           temp08         LIKE rwf_file.rwf16,
           temp09         LIKE rwf_file.rwf12,
           temp10         LIKE rwg_file.rwg06,
           temp11         LIKE rwg_file.rwg11,
           temp12         LIKE rwk_file.rwk08,
           temp13         LIKE rwk_file.rwk09,
           temp14         LIKE rwk_file.rwk08
                     END RECORD,
       g_temp2       DYNAMIC ARRAY OF RECORD
           temp101         LIKE rwg_file.rwg04,
           temp102         LIKE rwg_file.rwg05,
           temp103         LIKE rwg_file.rwg06,
           temp104         LIKE ima_file.ima02,
           temp105         LIKE rwg_file.rwg09,
           temp106         LIKE rwg_file.rwg11
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_wc3         STRING,                 #FUN-BB0058 add
       g_rec_b       LIKE type_file.num5,
       g_rec_b2      LIKE type_file.num5,    #FUN-BB0058 add
       l_ac1         LIKE type_file.num5,   
       l_ac3         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE rae_file.rae01
DEFINE g_argv2             LIKE rae_file.rae02
DEFINE g_argv3             LIKE rae_file.raeplant
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b3            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_member            LIKE type_file.chr1

DEFINE l_azp02             LIKE azp_file.azp02 
DEFINE g_rtz05             LIKE rtz_file.rtz05  #價格策略
DEFINE g_rtz04             LIKE rtz_file.rtz04  #FUN-AB0101 
#FUN-BB0058 add START
DEFINE
       g_rak         DYNAMIC ARRAY OF RECORD
           rak05          LIKE rak_file.rak05,
           rak06          LIKE rak_file.rak06,
           rak07          LIKE rak_file.rak07,
           rak08          LIKE rak_file.rak08,
           rak09          LIKE rak_file.rak09,
           rak10          LIKE rak_file.rak10,
           rak11          LIKE rak_file.rak11,
           rakacti        LIKE rak_file.rakacti
                     END RECORD,
       g_rak_t       RECORD
           rak05          LIKE rak_file.rak05,
           rak06          LIKE rak_file.rak06,
           rak07          LIKE rak_file.rak07,
           rak08          LIKE rak_file.rak08,
           rak09          LIKE rak_file.rak09,
           rak10          LIKE rak_file.rak10,
           rak11          LIKE rak_file.rak11,
           rakacti        LIKE rak_file.rakacti
                     END RECORD,
       g_rak_o       RECORD
           rak05          LIKE rak_file.rak05,
           rak06          LIKE rak_file.rak06,
           rak07          LIKE rak_file.rak07,
           rak08          LIKE rak_file.rak08,
           rak09          LIKE rak_file.rak09,
           rak10          LIKE rak_file.rak10,
           rak11          LIKE rak_file.rak11,
           rakacti        LIKE rak_file.rakacti
                     END RECORD
DEFINE g_raq         RECORD
           raq05          LIKE raq_file.raq05,
           raq06          LIKE raq_file.raq06,
           raq07          LIKE raq_file.raq07 
                     END RECORD
#FUN-BB0058 add END 
DEFINE g_multi_ima01       STRING    #MOD-CC0219 add
DEFINE g_b_flag            LIKE type_file.chr1   #FUN-D30033  add


MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM rae_file WHERE rae01 = ? AND rae02 = ? AND raeplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t303_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t303_w AT p_row,p_col WITH FORM "art/42f/artt303"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
#  CALL cl_set_comp_visible("rae28",FALSE)   #FUN-B30012 MARK
   CALL cl_set_comp_visible("rae30",FALSE)   #FUN-B30012 ADD
   CALL cl_set_comp_visible("rae13,rae14,rae24,rae25",FALSE)   #FUN-BB0058 add
   LET g_rae.rae01=g_plant
   DISPLAY BY NAME g_rae.rae01 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_plant
   DISPLAY l_azp02 TO rae01_desc
   SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant
   SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01 = g_plant

   IF NOT cl_null(g_argv1) THEN
      CALL t303_q()
   END IF

   CALL cl_set_comp_required("rak11",FALSE)   #FUN-BB0058 add   
   CALL t303_menu()
   CLOSE WINDOW t303_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t303_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_raf.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rae01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED," rae02 = '",g_argv2,"'"
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc CLIPPED," raeplant = '",g_argv3,"'"
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rae.* TO NULL
#FUN-BB0058 mark START
#     CONSTRUCT BY NAME g_wc ON rae01,rae02,rae03,raeplant,rae04,rae05,rae06,rae07,rae10,  
#                                rae11,rae12,rae13,rae14,rae15,rae16,rae17,rae18,rae19,rae20,
#                           #    rae21,raemksg,rae900,raeconf,raecond,raecont,raeconu,raepos,rae22,      #FUN-AB0093  mark
#                                #rae21,raemksg,rae900,raeconf,raecond,raecont,raeconu,rae901,rae902,raepos,rae22,      #FUN-AB0093  add   #TQC-AB0338 mark
#                                rae21,raeconf,raecond,raecont,raeconu,#rae901,rae902, #TQC-AC0326 mark
#                                raepos,rae22,   #TQC-AB0338 add 
#                                rae23,rae24,rae25,rae26,
#                                rae27,rae28,rae29,rae30,rae31,
#                                raeuser,raegrup,raeoriu,raemodu,raedate,raeorig,raeacti,raecrat
#FUN-BB0058 mark END
#FUN-BB0058 add START
      CONSTRUCT BY NAME g_wc ON rae01,rae02,rae03,raeplant,rae10,                           
                                rae12,rae11,rae26,rae27,rae23,rae13,rae14,rae24,rae25,
                                rae15,rae16,rae17,rae18,rae19,rae20,
                                rae21,raeconf,raecond,raecont,raeconu,
                                raepos,rae22,   
                                raeuser,raegrup,raeoriu,raemodu,raedate,raeorig,raeacti,raecrat,
                                raq05, raq06, raq07
#FUN-BB0058 add END 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rae01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rae01
                  NEXT FIELD rae01
      
               WHEN INFIELD(rae02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rae02
                  NEXT FIELD rae02
      
               WHEN INFIELD(rae03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rae03
                  NEXT FIELD rae03
      
               WHEN INFIELD(raeconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_raeconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO raeconu                                                                              
                  NEXT FIELD raeconu
               WHEN INFIELD(raeplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_raeplant"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO raeplant                                                                              
                  NEXT FIELD raeplant
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('raeuser', 'raegrup')
 
      DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-BB0058 add

#FUN-BB0058 add START
          CONSTRUCT g_wc3 ON rak05,rak06,rak07,rak08,rak09,rak10,rak11,rakacti
                 FROM s_rak[1].rak05,s_rak[1].rak06,s_rak[1].rak07,s_rak[1].rak08,
                      s_rak[1].rak09, s_rak[1].rak10, s_rak[1].rak11, s_rak[1].rakacti

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
          END CONSTRUCT
#FUN-BB0058 add END

         CONSTRUCT g_wc1 ON raf03,raf04,raf05,rafacti
                    FROM s_raf[1].raf03,s_raf[1].raf04,s_raf[1].raf05,s_raf[1].rafacti
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
#FUN-BB0058 mark START
#            ON IDLE g_idle_seconds
#               CALL cl_on_idle()
#               CONTINUE CONSTRUCT
#    
#            ON ACTION about
#               CALL cl_about()
#    
#            ON ACTION HELP
#               CALL cl_show_help()
#    
#            ON ACTION controlg
#               CALL cl_cmdask()
#    
#            ON ACTION qbe_save
#               CALL cl_qbe_save()
#FUN-BB0058 mark END 
         END CONSTRUCT
#FUN-BB0058 mark START   
#       IF INT_FLAG THEN
#          RETURN
#       END IF 
#FUN-BB0058 mark END

          CONSTRUCT g_wc2 ON rag03,rag04,rag05,rag06,ragacti
                 FROM s_rag[1].rag03,s_rag[1].rag04,
                      s_rag[1].rag05,s_rag[1].rag06, s_rag[1].ragacti
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(rag05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_rag05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rag05
                     NEXT FIELD rag05
                  WHEN INFIELD(rag06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_rag06"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rag06
                     NEXT FIELD rag06 
               END CASE
#FUN-BB0058 mark START 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#    
#         ON ACTION about
#            CALL cl_about()
#    
#         ON ACTION HELP
#            CALL cl_show_help()
#    
#         ON ACTION controlg
#            CALL cl_cmdask()
#    
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#FUN-BB0058 mark END
          END CONSTRUCT     

#FUN-BB0058 add START
          ON ACTION ACCEPT
             ACCEPT DIALOG

          ON ACTION cancel
             LET INT_FLAG = 1
             EXIT DIALOG

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG

          ON ACTION about
             CALL cl_about()

          ON ACTION help
             CALL cl_show_help()

          ON ACTION controlg
             CALL cl_cmdask()

          ON ACTION qbe_save
             CALL cl_qbe_save()

       END DIALOG
#FUN-BB0058 add END
       IF INT_FLAG THEN 
          RETURN
       END IF

    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc  = g_wc  CLIPPED
    LET g_wc3 = g_wc3 CLIPPED  #FUN-BB0058 add

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF
   #FUN-BB0058 add START
    IF cl_null(g_wc3) THEN
       LET g_wc3=" 1=1"
    END IF
   #FUN-BB0058 add END 
    
#modify by TQC-AA0109----STR----  
#    LET g_sql = "SELECT DISTINCT rae01,rae02,raeplant ",
#                "  FROM (rae_file LEFT OUTER JOIN raf_file ",
#                "       ON (rae01=raf01 AND rae02=raf02 AND raeplant=rafplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN rag_file ON ( rae01=rag01 AND rae02=rag02 ",
#                "     AND raeplant=ragplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rae01,rae02,raeplant"
     LET g_sql = "SELECT DISTINCT rae01,rae02,raeplant ",
               "  FROM rae_file LEFT OUTER JOIN raf_file ",
               "       ON (rae01=raf01 AND rae02=raf02 AND raeplant=rafplant ) ",
               "    LEFT OUTER JOIN rag_file ON ( rae01=rag01 AND rae02=rag02 ",
               "     AND raeplant=ragplant ) ",
               "    LEFT OUTER JOIN raq_file ON ( rae01=raq01 AND rae02=raq02 ",  #FUN-BB0058 add
               "     AND raeplant=raqplant )  ",  #FUN-BB0058 add
               #TQC-C80118 add begin ---
               "    LEFT OUTER JOIN rak_file ON ( rae01=rak01 AND rae02=rak02 ",
               "     AND raeplant=rakplant ) ",
               #TQC-C80118 add end -----
               "  WHERE ", g_wc CLIPPED," AND ",g_wc1," AND ",g_wc2,
               "    AND ", g_wc3 CLIPPED,        #TQC-C80118 add
               " ORDER BY rae01,rae02,raeplant"

#modify by TQC-AA0109----end----  
   PREPARE t303_prepare FROM g_sql
   DECLARE t303_cs
       SCROLL CURSOR WITH HOLD FOR t303_prepare
#modify by TQC-AA0109----STR----  
#   LET g_sql = "SELECT COUNT(DISTINCT rae01||rae02||raeplant) ",
#                "  FROM (rae_file LEFT OUTER JOIN raf_file ",
#                "       ON (rae01=raf01 AND rae02=raf02 AND raeplant=rafplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN rag_file ON ( rae01=rag01 AND rae02=rag02 ",
#                "     AND raeplant=ragplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rae01"
     LET g_sql = "SELECT COUNT(DISTINCT rae01||rae02||raeplant) ",
                "  FROM rae_file LEFT OUTER JOIN raf_file ",
                "       ON (rae01=raf01 AND rae02=raf02 AND raeplant=rafplant ) ",
                "    LEFT OUTER JOIN rag_file ON ( rae01=rag01 AND rae02=rag02 ",
                "     AND raeplant=ragplant ) ",
                "    LEFT OUTER JOIN raq_file ON ( rae01=raq01 AND rae02=raq02 ",  #FUN-BB0058 add
                "     AND raeplant=raqplant ) ",  #FUN-BB0058 add
                #TQC-C80118 add begin ---
                "    LEFT OUTER JOIN rak_file ON ( rae01=rak01 AND rae02=rak02 ",
                "     AND raeplant=rakplant ) ",
                #TQC-C80118 add end -----
                "  WHERE ", g_wc CLIPPED," AND ",g_wc1," AND ",g_wc2,
                "    AND ", g_wc3 CLIPPED,        #TQC-C80118 add
                " ORDER BY rae01"

#modify by TQC-AA0109----end----  
   PREPARE t303_precount FROM g_sql
   DECLARE t303_count CURSOR FOR t303_precount
 
END FUNCTION
 
FUNCTION t303_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t303_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t303_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t303_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t303_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t303_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t303_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t303_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            #FUN-BB0058 mark START
            #   IF g_flag_b = '1' THEN
            #      CALL t303_b1()
            #   ELSE
            #      CALL t303_b2()
            #   END IF
            #FUN-BB0058 mark END
               CALL t303_b()  #FUN-BB0058 add
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t303_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "organization" #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rae.rae02) THEN
                  CALl t302_1(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "Memberlevel"    #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rae.rae02) THEN
#                 CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10)   #FUN-BB0058 mark
               #FUN-BB0058 add START   
                  IF g_rae.rae12 <> '0' THEN
                     CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10,g_rae.rae12)  
                  END IF
               #FUN-BB0058 add END
              ELSE
                 CALL cl_err('',-400,0)
              END IF
            END IF

         WHEN "gift"         #換贈資料
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rae.rae02) THEN
                  CALL t303_gift(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t303_yes()
            END IF
 
         #TQC-AC0326 add ----------begin-----------         
         WHEN "undo_confirm"           
            IF cl_chk_act_auth() THEN         
               CALL t303_w()       
            END IF 
         #TQC-AC0326 add -----------end------------
#TQC-A80158 --begin
#       WHEN "void"
#           IF cl_chk_act_auth() THEN
#              CALL t303_void()
#           END IF
#TQC-A80158 --end

        WHEN "issuance"              #發布
           IF cl_chk_act_auth() THEN
              CALL t303_iss()
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_raf),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rae.rae02 IS NOT NULL THEN
                 LET g_doc.column1 = "rae02"
                 LET g_doc.value1 = g_rae.rae02
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t303_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
#FUN-BB0058 add START
      DISPLAY ARRAY g_rak TO s_rak.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
 
      END DISPLAY 

#FUN-BB0058 add END
      DISPLAY ARRAY g_raf TO s_raf.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '3'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0058 mark START 
#        ON ACTION insert
#           LET g_action_choice="insert"
#           EXIT DIALOG
#
#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG
#
#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG
#
#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG
#
#        ON ACTION first
#           CALL t303_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t303_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t303_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t303_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t303_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG
#
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
#
#        ON ACTION detail
#           LET g_action_choice="detail"
#           LET g_flag_b = '1'
#           LET l_ac = 1
#           EXIT DIALOG
#
#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG
#
#        ON ACTION help
#           LET g_action_choice="help"
#           EXIT DIALOG

#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()
#
#        ON ACTION exit
#           LET g_action_choice="exit"
#           EXIT DIALOG
#     
#        ON ACTION organization                #生效機構
#           LET g_action_choice =  "organization" 
#           EXIT DIALOG

#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

#        ON ACTION gift
#           LET g_action_choice="gift"
#           EXIT DIALOG

#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG

#        #TQC-AC0326 add ----------begin-----------    
#        ON ACTION undo_confirm     
#           LET g_action_choice="undo_confirm"   
#           EXIT DIALOG   
#        #TQC-AC0326 add -----------end------------ 
#TQC-A80158 --begin
#        ON ACTION void
#           LET g_action_choice="void"
#           EXIT DIALOG
#TQC-A80158 --end

#        ON ACTION issuance                    #發布      
#           LET g_action_choice = "issuance"  
#           EXIT DIALOG
#                                                                                                                                   
#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG
#
#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '1'
#           LET l_ac = ARR_CURR()
#           EXIT DIALOG
#
#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG
#
#        ON ACTION about 
#           CALL cl_about()
#
#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG
#
#        AFTER DISPLAY
#           CONTINUE DIALOG
#
#        ON ACTION controls       
#           CALL cl_set_head_visible("","AUTO")
#
#        ON ACTION related_document
#           LET g_action_choice="related_document"          
#           EXIT DIALOG
#FUN-BB0058 mark END
      END DISPLAY 
    
      DISPLAY ARRAY g_rag TO s_rag.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '1'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0058 mark START 
#        ON ACTION insert
#           LET g_action_choice="insert"
#           EXIT DIALOG
#
#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG
#
#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG
#
#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG
#
#        ON ACTION first
#           CALL t303_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t303_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t303_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t303_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t303_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG
#
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
#
#        ON ACTION detail
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac1 = 1
#           EXIT DIALOG
#
#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG
#
#        ON ACTION help
#           LET g_action_choice="help"
#           EXIT DIALOG
#
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()
#
#        ON ACTION exit
#           LET g_action_choice="exit"
#           EXIT DIALOG
#     
#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG
#
#TQC-A80158 --begin
#        ON ACTION void
#           LET g_action_choice="void"
#           EXIT DIALOG
#TQC-A80158 --end 

#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

#        ON ACTION issuance                    #發布      
#           LET g_action_choice = "issuance"  
#           EXIT DIALOG
#         
#        ON ACTION gift
#           LET g_action_choice="gift"
#           EXIT DIALOG
#                                                                                                                                   
#        ON ACTION organization                #生效機構
#           LET g_action_choice =  "organization" 
#           EXIT DIALOG

#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG
#
#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac1 = ARR_CURR()
#           EXIT DIALOG
#
#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG
#
#        ON ACTION about 
#           CALL cl_about()
#
#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG
#
#        ON ACTION controls       
#           CALL cl_set_head_visible("","AUTO")
#
#        ON ACTION related_document
#           LET g_action_choice="related_document"          
#           EXIT DIALOG
#FUN-BB0058 mark END
      END DISPLAY
#FUN-BB0058 add START
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
            CALL t303_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t303_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t303_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t303_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t303_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
 
         ON ACTION organization                #生效機構
            LET g_action_choice =  "organization"
            EXIT DIALOG
 
         ON ACTION Memberlevel                 #會員促銷
            LET g_action_choice="Memberlevel"
            EXIT DIALOG
 
         ON ACTION gift
            LET g_action_choice="gift"
            EXIT DIALOG
 
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
 
         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG
 
         ON ACTION issuance                    #發布
            LET g_action_choice = "issuance"
            EXIT DIALOG
 
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
            EXIT DIALOG
         ON ACTION reproduce  #FUN-CC0129 add
            LET g_action_choice="reproduce"
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
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
 
         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG
#FUN-BB0058 add END 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t303_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_raf.clear()
   CALL g_rag.clear()    #TQC-AC0193 add
   CALL g_rak.clear()    #FUN-BB0058 add
   DISPLAY ' ' TO FORMONLY.cnt
 
#  CALL cl_set_comp_visible("rae28,rae29,rae30,rae31",TRUE)  #FUN-B30012 MARK
   CALL cl_set_comp_visible("rae28,rae29,rae31",TRUE)        #FUN-B30012 ADD
   CALL cl_set_comp_visible("rae15,rae16,rae17",TRUE)

   CALL t303_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rae.* TO NULL
      RETURN
   END IF
 
   OPEN t303_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rae.* TO NULL
   ELSE
      OPEN t303_count
      FETCH t303_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t303_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t303_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t303_cs INTO g_rae.rae01,g_rae.rae02,g_rae.raeplant
      WHEN 'P' FETCH PREVIOUS t303_cs INTO g_rae.rae01,g_rae.rae02,g_rae.raeplant
      WHEN 'F' FETCH FIRST    t303_cs INTO g_rae.rae01,g_rae.rae02,g_rae.raeplant
      WHEN 'L' FETCH LAST     t303_cs INTO g_rae.rae01,g_rae.rae02,g_rae.raeplant
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t303_cs INTO g_rae.rae01,g_rae.rae02,g_rae.raeplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
      INITIALIZE g_rae.* TO NULL
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
 
   SELECT * INTO g_rae.* FROM rae_file 
       WHERE rae02 = g_rae.rae02 AND rae01 = g_rae.rae01
         AND raeplant = g_rae.raeplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rae_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rae.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rae.raeuser
   LET g_data_group = g_rae.raegrup
   LET g_data_plant = g_rae.raeplant #TQC-A10128 ADD
 
   CALL t303_show()
 
END FUNCTION
 
FUNCTION t303_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE l_raa03   LIKE raa_file.raa03 
 
   LET g_rae_t.* = g_rae.*
   LET g_rae_o.* = g_rae.*
#FUN-BB0058 mark START
#   DISPLAY BY NAME g_rae.rae01,g_rae.rae02,g_rae.rae03,  
#                   g_rae.rae04,g_rae.rae05,g_rae.rae06,g_rae.rae07,  
#                   g_rae.rae10,
#                   g_rae.rae11,g_rae.rae12,g_rae.rae13,  
#                   g_rae.rae14,g_rae.rae15,g_rae.rae16,g_rae.rae17,
#                   g_rae.rae18,g_rae.rae19,g_rae.rae20,
#                   g_rae.rae21,g_rae.rae22,g_rae.rae23,  
#                   g_rae.rae24,g_rae.rae25,g_rae.rae26,g_rae.rae27,
#                   g_rae.rae28,g_rae.rae29,g_rae.rae30,g_rae.rae31,
#                   g_rae.raeplant,g_rae.raeconf,g_rae.raecond,g_rae.raecont,
#              #     g_rae.raeconu,g_rae.rae900,g_rae.raemksg,                           #FUN-AB0093  mark
#                   #g_rae.raeconu,g_rae.rae901,g_rae.rae902,g_rae.rae900,g_rae.raemksg,  #FUN-AB0093  add  #TQC-AB0338 mark
#                   g_rae.raeconu,#g_rae.rae901,g_rae.rae902,  #TQC-AB0338 add #TQC-AC0326 mark
#                   g_rae.raeoriu,g_rae.raeorig,g_rae.raeuser,
#                   g_rae.raemodu,g_rae.raeacti,g_rae.raegrup,
#                   g_rae.raedate,g_rae.raecrat,g_rae.raepos
#FUN-BB0058 mark END
#FUN-BB0058 add START
   DISPLAY BY NAME g_rae.rae01,g_rae.rae02,g_rae.rae03,
                   g_rae.rae10,
                   g_rae.rae11,g_rae.rae12,g_rae.rae13,
                   g_rae.rae14,g_rae.rae15,g_rae.rae16,g_rae.rae17,
                   g_rae.rae18,g_rae.rae19,g_rae.rae20,
                   g_rae.rae21,g_rae.rae22,g_rae.rae23,
                   g_rae.rae24,g_rae.rae25,g_rae.rae26,g_rae.rae27,
                   g_rae.raeplant,g_rae.raeconf,g_rae.raecond,g_rae.raecont,
                   g_rae.raeconu,
                   g_rae.raeoriu,g_rae.raeorig,g_rae.raeuser,
                   g_rae.raemodu,g_rae.raeacti,g_rae.raegrup,
                   g_rae.raedate,g_rae.raecrat,g_rae.raepos
#FUN-BB0058 add END 
   IF g_rae.raeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rae.raeconf,"","","",g_chr,"")                                                                           
  #CALL cl_flow_notify(g_rae.rae01,'V') 

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rae.rae01
   DISPLAY l_azp02 TO FORMONLY.rae01_desc
   SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rae.rae01 AND raa02 = g_rae.rae03
   DISPLAY l_raa03 TO FORMONLY.rae03_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rae.raeconu
   DISPLAY l_gen02 TO FORMONLY.raeconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rae.raeplant
   DISPLAY l_azp02 TO FORMONLY.raeplant_desc

#FUN-BB0058 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file 
      WHERE raq01 = g_rae.rae01 AND raq02 = g_rae.rae02 
        AND raq03 = '2' AND raqplant = g_rae.raeplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
#FUN-BB0058 add END


#  CALL cl_set_comp_visible("rae28,rae29,rae30,rae31",g_rae.rae27='Y')    #TQC-A90025   --mark
   CALL cl_set_comp_visible("rae15,rae16,rae17",g_rae.rae11='N')
   CALL cl_set_act_visible("gift",g_rae.rae27='Y')
   CALL t303_b1_fill(g_wc1)
   CALL t303_b2_fill(g_wc2)
   CALL t303_b3_fill(g_wc3)  #FUN-BB0058 add
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t303_b1_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT raf03,raf04,raf05,rafacti ", 
               "  FROM raf_file",
               " WHERE raf02 = '",g_rae.rae02,"' AND raf01 ='",g_rae.rae01,"' ",
               "   AND rafplant = '",g_rae.raeplant,"'"
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY raf03 "
 
   DISPLAY g_sql
 
   PREPARE t303_pb FROM g_sql
   DECLARE raf_cs CURSOR FOR t303_pb
 
   CALL g_raf.clear()
   LET g_cnt = 1
 
   FOREACH raf_cs INTO g_raf[g_cnt].*
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
   CALL g_raf.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t303_b2_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rag03,rag04,rag05,'',rag06,'',ragacti",
               "  FROM rag_file",
               " WHERE rag02 = '",g_rae.rae02,"' AND rag01 ='",g_rae.rae01,"' ",
               "   AND ragplant = '",g_rae.raeplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rag03 "
 
   DISPLAY g_sql
 
   PREPARE t303_pb1 FROM g_sql
   DECLARE rag_cs CURSOR FOR t303_pb1
 
   CALL g_rag.clear()
   LET g_cnt = 1
 
   FOREACH rag_cs INTO g_rag[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gfe02 INTO g_rag[g_cnt].rag06_desc FROM gfe_file
           WHERE gfe01 = g_rag[g_cnt].rag06

       CALL t303_rag05('d',g_cnt)
      #CALL t303_rag06('d')

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rag.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t303_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_raf.clear() 
   CALL g_rag.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rae.* LIKE rae_file.*
   LET g_rae_t.* = g_rae.*
   LET g_rae_o.* = g_rae.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rae.rae01 = g_plant
    #  LET g_rae.rae04 = g_today        #促銷開始日期  #FUN-BB0058 mark 
    #  LET g_rae.rae05 = g_today        #促銷結束日期  #FUN-BB0058 mark
    #  LET g_rae.rae06 = '00:00:00'     #促銷開始時間  #FUN-BB0058 mark
    #  LET g_rae.rae07 = '23:59:59'     #促銷結束時間  #FUN-BB0058 mark
      LET g_rae.rae10 = '1'

      LET g_rae.rae08 = 'N'   #no use
      LET g_rae.rae09 = 'N'   #no use

      LET g_rae.rae11 = 'N'
     #LET g_rae.rae12 = 'N'  #FUN-BB0058 mark 
      LET g_rae.rae12 = '0'  #FUN-BB0058 add
      LET g_rae.rae13 = 'N'
      LET g_rae.rae14 = 'Y'
      LET g_rae.rae15 = 0          #特賣價
     #LET g_rae.rae16 = 0          #折扣率%  
      LET g_rae.rae17 = 0          #折讓額
      LET g_rae.rae18 = 0          #會員特賣價
     #LET g_rae.rae19 = 0          #會員折扣率%
      LET g_rae.rae20 = 0          #會員折讓額      

      LET g_rae.rae900   = '0'
      LET g_rae.raepos   = '1' #NO.FUN-B40071
      LET g_rae.raeconf  = 'N'
      LET g_rae.raemksg  = 'N'

      LET g_rae.rae23 = 'N'
      LET g_rae.rae24 = 'N'
      LET g_rae.rae25 = 'N'
      LET g_rae.rae26 = 'N'

      LET g_rae.rae27 = 'N'  
     # LET g_rae.rae28 = '1'  #FUN-BB0058 mark
     # LET g_rae.rae29 = '1'  #FUN-BB0058 mark
     # LET g_rae.rae30 = '1'  #FUN-BB0058 mark
     # LET g_rae.rae31 = 1    #FUN-BB0058 mark

      LET g_rae.raeacti  ='Y'
      LET g_rae.raeuser  = g_user
      LET g_rae.raeoriu  = g_user  
      LET g_rae.raeorig  = g_grup  
      LET g_rae.raegrup  = g_grup
      LET g_rae.raecrat  = g_today
      LET g_rae.raeplant = g_plant
      LET g_rae.raelegal = g_legal
      LET g_data_plant   = g_plant 

      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rae.rae01
      DISPLAY l_azp02 TO rae01_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rae.raeplant
      DISPLAY l_azp02 TO raeplant_desc

      CALL t303_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rae.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rae.rae02) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rae.rae02,g_today,"A8","rae_file","rae02","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rae.rae02,g_today,"A8","rae_file","rae02","","","") #FUN-A70130 mod
         RETURNING li_result,g_rae.rae02 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rae.rae02
    #FUN-BB0058 add START 
      IF cl_null(g_rae.rae28) THEN LET g_rae.rae28 = ' ' END IF
      IF cl_null(g_rae.rae29) THEN LET g_rae.rae29 = ' ' END IF
      IF cl_null(g_rae.rae30) THEN LET g_rae.rae30 = ' ' END IF
      IF cl_null(g_rae.rae31) THEN LET g_rae.rae31 = ' ' END IF
    #FUN-BB0058 add END
      IF cl_null(g_rae.rae15) THEN LET g_rae.rae15 = 0 END IF   #FUN-CB0034 add
      INSERT INTO rae_file VALUES (g_rae.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rae_file",g_rae.rae02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK           #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         # FUN-B80085增加空白行

         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
                      VALUES (g_rae.rae01,g_rae.rae02,'2',g_rae.rae01,'N','Y',g_rae.raeplant,g_legal)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","raq_file",g_rae.rae01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK         #FUN-B80085--add--
            CONTINUE WHILE
         ELSE 
            COMMIT WORK
            CALL cl_flow_notify(g_rae.rae02,'I')
         END IF
      END IF
 
      SELECT * INTO g_rae.* FROM rae_file
       WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
         AND raeplant = g_rae.raeplant  
      LET g_rae_t.* = g_rae.*
      LET g_rae_o.* = g_rae.*     

      CALL cl_set_act_visible("gift",g_rae.rae27='Y')
      IF g_rae.rae12 <> '0' THEN
          CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10,g_rae.rae12)
      END IF
      CALl t302_1(g_rae.rae01,g_rae.rae02,'2',
                  g_rae.raeplant,g_rae.raeconf) 
      CALL g_raf.clear()
      CALL g_rag.clear()
      CALL g_rak.clear()   #FUN-BB0058 add
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0  #FUN-BB0058 add
   #   CALL t303_b1()  #FUN-BB0058 mark
   #   CALL t303_b2()  #FUN-BB0058 mark
      CALL t303_b()    #FUN-BB0058 add
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t303_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5

DEFINE l_price    LIKE rae_file.rae15
DEFINE l_discount LIKE rae_file.rae16
DEFINE l_date     LIKE rae_file.rae04
#TQC-A80161 --begin
#DEFINE l_time1    LIKE rae_file.rae06
#DEFINE l_time2    LIKE rae_file.rae06
DEFINE l_time1    LIKE type_file.num5
DEFINE l_time2    LIKE type_file.num5
#TQC-A80161 --end
DEFINE l_docno     LIKE rae_file.rae02  #FUN-BB0058 add
DEFINE l_cnt       LIKE type_file.num5  #FUN-BB0058 add
   IF s_shut(0) THEN
      RETURN
   END IF
#FUN-BB0058 mark START 
#   DISPLAY BY NAME g_rae.rae01,g_rae.rae02,g_rae.rae03,g_rae.rae04,g_rae.rae05,   
#                   g_rae.rae06,g_rae.rae07,g_rae.rae10,                           
#                   g_rae.rae11,g_rae.rae12,g_rae.rae13,g_rae.rae14,g_rae.rae15,
#                   g_rae.rae16,g_rae.rae17,g_rae.rae18,g_rae.rae19,g_rae.rae20,
#                   g_rae.rae21,g_rae.rae22,g_rae.rae23,g_rae.rae24,g_rae.rae25,
#                   g_rae.rae26,  g_rae.rae27,g_rae.rae28,g_rae.rae29,g_rae.rae30, 
#                   g_rae.rae31,g_rae.raepos,
#                   #g_rae.raeplant,g_rae.raeconf,g_rae.raemksg,g_rae.rae900,   #TQC-AB0338 mark
#                   g_rae.raeplant,g_rae.raeconf,    #TQC-AB0338 add
#                   g_rae.raeuser,g_rae.raemodu,g_rae.raegrup,g_rae.raedate,
#                   g_rae.raeacti,g_rae.raecrat,g_rae.raeoriu,g_rae.raeorig
#FUN-BB0058 mark END
#FUN-BB0058 add START
   DISPLAY BY NAME g_rae.rae01,g_rae.rae02,g_rae.rae03,    
                   g_rae.rae10,                           
                   g_rae.rae11,g_rae.rae12,g_rae.rae13,g_rae.rae14,g_rae.rae15,
                   g_rae.rae16,g_rae.rae17,g_rae.rae18,g_rae.rae19,g_rae.rae20,
                   g_rae.rae21,g_rae.rae22,g_rae.rae23,g_rae.rae24,g_rae.rae25,
                   g_rae.rae26, g_rae.raepos, 
                   g_rae.raeplant,g_rae.raeconf,  
                   g_rae.raeuser,g_rae.raemodu,g_rae.raegrup,g_rae.raedate,
                   g_rae.raeacti,g_rae.raecrat,g_rae.raeoriu,g_rae.raeorig
#FUN-BB0058 add END 
   CALL cl_set_head_visible("","YES")
#FUN-BB0058 mark START
#   INPUT BY NAME g_rae.rae02 ,g_rae.rae03,g_rae.rae04,g_rae.rae05,   
#                 g_rae.rae06,g_rae.rae07,g_rae.rae10,                
#                 g_rae.rae11,g_rae.rae12,g_rae.rae13,g_rae.rae14,g_rae.rae15,
#                 g_rae.rae16,g_rae.rae17,g_rae.rae18,g_rae.rae19,g_rae.rae20,
#                #g_rae.rae21,g_rae.raemksg,g_rae.rae22, #TQC-AB0338 MARK
#                 g_rae.rae21,g_rae.rae22,               #TQC-AB0338 Add
#                 g_rae.rae23,g_rae.rae24,g_rae.rae25,g_rae.rae26
#                 g_rae.rae27,g_rae.rae28,g_rae.rae29,g_rae.rae30,g_rae.rae31 
#FUN-BB0058 mark END
#FUN-BB0058 add START
   INPUT BY NAME g_rae.rae02 ,g_rae.rae03,    
                 g_rae.rae10,                 
                 g_rae.rae11,g_rae.rae12,g_rae.rae13,g_rae.rae14,g_rae.rae15,
                 g_rae.rae16,g_rae.rae17,g_rae.rae18,g_rae.rae19,g_rae.rae20,
                 g_rae.rae21,g_rae.rae22,               
                 g_rae.rae23,g_rae.rae24,g_rae.rae25,g_rae.rae26,g_rae.rae27
#FUN-BB0058 add END
      WITHOUT DEFAULTS 

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t303_set_entry(p_cmd)
         CALL t303_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rae02")
         CALL t303_rae10_entry(g_rae.rae10)
#        CALL cl_set_comp_entry("rae31",g_rae.rae30<>'1')                       #FUN-B30012 MARK
#        CALL cl_set_comp_visible("rae28,rae29,rae30,rae31",g_rae.rae27='Y')    #TQC-A90025 --mark
#FUN-BB0058 mark START
##TQC-A90025 --add
#         IF g_rae.rae27='Y' THEN
#            CALL cl_set_comp_entry("rae28,rae29,rae30,rae31",TRUE)
#          ELSE
#            CALL cl_set_comp_entry("rae28,rae29,rae30,rae31",FALSE)
#         END IF
##TQC-A90025 --end
#FUN-BB0058 mark END
         CALL cl_set_comp_visible("rae15,rae16,rae17",g_rae.rae11='N')
          
      AFTER FIELD rae02  #促銷單號
         IF NOT cl_null(g_rae.rae02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rae.rae02 <> g_rae_t.rae02) THEN     
#              CALL s_check_no("axm",g_rae.rae02,g_rae_t.rae02,"A8","rae_file","rae01,rae02,raeplant","")  #FUN-A70130 mark
               CALL s_check_no("art",g_rae.rae02,g_rae_t.rae02,"A8","rae_file","rae01,rae02,raeplant","")  #FUN-A70130 mod
                    RETURNING li_result,g_rae.rae02
               IF (NOT li_result) THEN                                                            
                  LET g_rae.rae02=g_rae_t.rae02                                                                 
                  NEXT FIELD rae02                                                                                     
               END IF
              #TQC-AB0161 ADD------- 抓取單據是否做簽核，因g_rae.rae02會多"_"所以用substr取前三碼--------
               LET l_docno = g_rae.rae02
               LET l_docno = l_docno[1,3]
               #SELECT oayapr INTO g_rae.raemksg FROM oay_file   #TQC-AB0338 mark
               # WHERE oayslip = l_docno                         
               #DISPLAY BY NAME g_rae.raemksg
              #TQC-AB0161 ADD-------------------------
            END IF
         END IF

      AFTER FIELD rae03  #活動代碼
         IF NOT cl_null(g_rae.rae03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                   
               g_rae.rae03 != g_rae_o.rae03 OR cl_null(g_rae_o.rae03)) THEN               
               CALL t303_rae03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rae03:',g_errno,0)
                  LET g_rae.rae03 = g_rae_t.rae03
                  DISPLAY BY NAME g_rae.rae03
                  NEXT FIELD rae03
               END IF
            END IF
         ELSE
            LET g_rae_o.rae03 = ''
            CLEAR rae03_desc           
         END IF
         
       #FUN-AB0033 mark ------------start-----------------
       #AFTER FIELD rae04,rae05  #開始,結束日期
       #    LET l_date = FGL_DIALOG_GETBUFFER()
       #    IF p_cmd='a' OR (p_cmd='u' AND 
       #             (DATE(l_date)<>g_rae_t.rae04 OR DATE(l_date)<>g_rae_t.rae05)) THEN       
       #            #(DATE(l_date)<>g_rae_t.rae04 AND DATE(l_date)<>g_rae_t.rae05)) THEN       
       #          IF INFIELD(rae04) THEN
       #             IF NOT cl_null(g_rae.rae05) THEN
       #                IF DATE(l_date)>g_rae.rae05 THEN
       #                   CALL cl_err('','art-201',0)
       #                   NEXT FIELD rae04
       #                END IF
       #             END IF
       #          END IF
       #          IF INFIELD(rae05) THEN
       #             IF NOT cl_null(g_rae.rae04) THEN
       #                IF DATE(l_date)<g_rae.rae04 THEN
       #                   CALL cl_err('','art-201',0)
       #                   NEXT FIELD rae05
       #                END IF
       #             END IF
       #          END IF 
       #   END IF
       #FUN-AB0033 mark -------------end------------------   
    #FUN-BB0058 mark START
    #   AFTER FIELD rae06  #開始時間
    #    IF NOT cl_null(g_rae.rae06) THEN
    #       IF p_cmd = "a" OR                    
    #              (p_cmd = "u" AND g_rae.rae06<>g_rae_t.rae06) THEN 
    #          CALL t303_chktime(g_rae.rae06) RETURNING l_time1
    #          IF NOT cl_null(g_errno) THEN
    #              CALL cl_err('',g_errno,0)
    #              NEXT FIELD rae06
    #          ELSE
    #            IF NOT cl_null(g_rae.rae07) THEN
    #               CALL t303_chktime(g_rae.rae07) RETURNING l_time2
    #               IF l_time1>=l_time2 THEN
    #                  CALL cl_err('','art-207',0)
    #                  NEXT FIELD rae06   
    #               END IF
    #            END IF
    #          END IF
    #        END IF
    #    END IF
    #    
    #  AFTER FIELD rae07  #結束時間
    #    IF NOT cl_null(g_rae.rae07) THEN
    #       IF p_cmd = "a" OR                    
    #              (p_cmd = "u" AND g_rae.rae07<>g_rae_t.rae07) THEN 
    #           CALL t303_chktime(g_rae.rae07) RETURNING l_time2
    #           IF NOT cl_null(g_errno) THEN
    #              CALL cl_err('',g_errno,0)
    #              NEXT FIELD rae07
    #           ELSE
    #              IF NOT cl_null(g_rae.rae06) THEN
    #                 CALL t303_chktime(g_rae.rae06) RETURNING l_time1
    #                 IF l_time1>=l_time2 THEN
    #                    CALL cl_err('','art-207',0)
    #                    NEXT FIELD rae07
    #                 END IF
    #              END IF
    #           END IF
    #       END IF
    #    END IF
    #FUN-BB0058 mark END
      AFTER FIELD rae10
         IF NOT cl_null(g_rae.rae10) THEN
            IF g_rae_o.rae10 IS NULL OR
               (g_rae.rae10 != g_rae_o.rae10 ) THEN
               IF g_rae.rae10 NOT MATCHES '[123]' THEN
                  LET g_rae.rae10= g_rae_o.rae10
                  NEXT FIELD rae10
               ELSE
                  CALL t303_rae10_entry(g_rae.rae10)
               END IF
            END IF
         END IF
     
      ON CHANGE rae10
         IF NOT cl_null(g_rae.rae10) THEN
            CALL t303_chkrap()  #FUN-C10008 add
            CALL t303_rae10_entry(g_rae.rae10)
            DISPLAY BY NAME g_rae.rae15,g_rae.rae16,g_rae.rae17,g_rae.rae18,g_rae.rae19,g_rae.rae20    #TQC-AC0193 add
         END IF

      ON CHANGE rae11
         IF NOT cl_null(g_rae.rae11) THEN
            CALL cl_set_comp_visible("rae15,rae16,rae17",g_rae.rae11='N')
         END IF

      ON CHANGE rae12
         IF NOT cl_null(g_rae.rae12) THEN
            CALL t303_rae10_entry(g_rae.rae10)
           LET l_cnt =  0
           SELECT COUNT(*) INTO l_cnt FROM rap_file
              WHERE rap01 = g_rae.rae01 
                AND rap02 = g_rae.rae02
                AND rap03 = '2'
                AND rapplant = g_rae.raeplant
          #此會員促銷方式已經有設定資料,是否將設定資料刪除
           IF l_cnt > 0 THEN
              IF NOT cl_confirm('art-756') THEN
                 LET g_rae.rae12 = g_rae_t.rae12
                 DISPLAY BY NAME g_rae.rae12
              ELSE
                 DELETE FROM rap_file
                   WHERE rap01 = g_rae.rae01
                     AND rap02 = g_rae.rae02
                     AND rap03 = '2'
                     AND rapplant = g_rae.raeplant
              END IF
           END IF
         END IF
#FUN-BB0058 mark START
#      BEFORE FIELD rae05,rae06,rae07,rae10,rae11
#         IF NOT cl_null(g_rae.rae10) THEN
#            CALL t303_rae10_entry(g_rae.rae10)
#         END IF
#FUN-BB0058 mark END
#FUN-BB0058 add START
      BEFORE FIELD rae10,rae11
         IF NOT cl_null(g_rae.rae10) THEN
            CALL t303_rae10_entry(g_rae.rae10)
         END IF
#FUN-BB0058 add END

      AFTER FIELD rae15,rae18    #特賣價
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
         #  CALL cl_err('','art-180',0)    #TQC-A90027   mark
            CALL cl_err('','art-683',0)    #TQC-A90027   add
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rae.rae15,g_rae.rae18
         END IF

      AFTER FIELD rae16,rae19   #折扣率
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rae.rae16,g_rae.rae19
           END IF

      AFTER FIELD rae17,rae20    #折讓額
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-653',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rae.rae17,g_rae.rae20
         END IF

       AFTER FIELD rae21  #組合數量
         IF NOT cl_null(g_rae.rae21) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rae.rae21<>g_rae_t.rae21) THEN 
                IF g_rae.rae21<0 THEN          #number(20,6)
                   CALL cl_err('','aem-042',0)
              #IF g_rae.rae21<=0 THEN          #number(5,0)
              #   CALL cl_err('','art-658',0)
                  NEXT FIELD rae21
               END IF
               CALL t303_rae21_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rae.rae21,g_errno,0)
                  NEXT FIELD rae21
               END IF
            END IF
         END IF
#FUN-BB0058 mark START
#      ON CHANGE rae27
##TQC-A90025 --modify
##        IF NOT cl_null(g_rae.rae27) THEN
##           CALL cl_set_comp_visible("rae28,rae29,rae30,rae31",g_rae.rae27='Y')
##        END IF
#         IF g_rae.rae27 = 'Y' THEN
#            CALL cl_set_comp_entry("rae28,rae29,rae30,rae31",TRUE)
#         ELSE
#            CALL cl_set_comp_entry("rae28,rae29,rae30,rae31",FALSE)
#         END IF
#TQC-A90025  --end
#FUN-BB0058 mark END
#FUN-B30012 MARK--BEGIN--
#     ON CHANGE rae30
#        IF NOT cl_null(g_rae.rae30) THEN
#           IF g_rae.rae30='1' THEN
#              LET g_rae.rae31=1
#              CALL cl_set_comp_entry("rae31",FALSE)
#              DISPLAY BY NAME g_rae.rae31
#           ELSE 
#              LET g_rae.rae31=2
#              CALL cl_set_comp_entry("rae31",TRUE)
#              DISPLAY BY NAME g_rae.rae31
#           END IF
#        END IF
#     BEFORE FIELD rae31
#        IF NOT cl_null(g_rae.rae30) THEN
#           IF g_rae.rae30='1' THEN
#              LET g_rae.rae31=1
#              CALL cl_set_comp_entry("rae31",FALSE)
#              DISPLAY BY NAME g_rae.rae31
#           ELSE
#              LET g_rae.rae31=2
#              CALL cl_set_comp_entry("rae31",TRUE)
#              DISPLAY BY NAME g_rae.rae31
#           END IF
#        END IF
#FUN-B30012 MARK--END----
#FUN-BB0058 mark START
#       AFTER FIELD rae31
#          IF NOT cl_null(g_rae.rae31) THEN
##            IF g_rae.rae31<=1 THEN        #FUN-B30012  MARK
#             IF g_rae.rae31 < 1 THEN       #FUN-B30012  ADD
##               CALL cl_err('','art-659',0)  #FUN-B30012  MARK
#                CALL cl_err('','alm-808',0)  #FUN-B30012  ADD
#                NEXT FIELD rae31
#             END IF
#          END IF 
#FUN-BB0058 mark END
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rae02)                                                                                                      
              LET g_t1=s_get_doc_no(g_rae.rae02)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A8','art') RETURNING g_t1           #FUN-A70130                                                         
              LET g_rae.rae02 = g_t1                                                                                                
              DISPLAY BY NAME g_rae.rae02                                                                                           
              NEXT FIELD rae02
            WHEN INFIELD(rae03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_raa02"
               LET g_qryparam.arg1 =g_plant
               LET g_qryparam.default1 = g_rae.rae03
               CALL cl_create_qry() RETURNING g_rae.rae03
               DISPLAY BY NAME g_rae.rae03
               CALL t303_rae03('d')
               NEXT FIELD rae03
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
      #FUN-AB0033 add ----------------start-------------------
      AFTER INPUT
         LET g_rae.raeuser = s_get_data_owner("rae_file") #FUN-C10039
         LET g_rae.raegrup = s_get_data_group("rae_file") #FUN-C10039
           IF NOT cl_null(g_rae.rae04) AND NOT cl_null(g_rae.rae05) THEN
              IF g_rae.rae04 > g_rae.rae05 THEN
                 CALL cl_err('','art-201',0)
                 NEXT FIELD rae04
              END IF
           END IF
      #FUN-AB0033 add -----------------end--------------------
   END INPUT
 
END FUNCTION

FUNCTION t303_rae03(p_cmd)
DEFINE l_raa03        LIKE raa_file.raa03 
DEFINE l_raaacti      LIKE raa_file.raaacti
DEFINE l_raaconf      LIKE raa_file.raaconf 
DEFINE p_cmd          LIKE type_file.chr1

   SELECT raa03,raaacti,raaconf INTO l_raa03,l_raaacti,l_raaconf FROM raa_file
    WHERE raa01 = g_rae.rae01 AND raa02 = g_rae.rae03

  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196' 
                              LET l_raa03=NULL 
     WHEN l_raaacti='N'       LET g_errno='9028'    
     WHEN l_raaconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_raa03 TO FORMONLY.rae03_desc
  END IF
#FUN-BB0058 mark START
#  IF p_cmd='a' THEN
#     SELECT raa05,raa06 INTO g_rae.rae04,g_rae.rae05
#       FROM raa_file
#      WHERE raa01=g_rae.rae01 AND raa02=g_rae.rae03
#     DISPLAY BY NAME g_rae.rae04,g_rae.rae05
#  END IF
#FUN-BB0058 mark END
END FUNCTION

FUNCTION t303_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rae.rae02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rae.* FROM rae_file 
      WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
        AND raeplant = g_rae.raeplant
   IF g_rae.raeacti ='N' THEN
      CALL cl_err(g_rae.rae02,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rae.raeconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rae.raeconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   #TQC-AC0326 add ---------begin----------
   IF g_rae.rae01 <> g_rae.raeplant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
   #TQC-AC0326 add ----------end-----------
   
   CALL t303_temptable("1")   #FUN-A80104
      
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t303_cl:", STATUS, 1)
      CLOSE t303_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t303_cl INTO g_rae.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rae.rae02,SQLCA.sqlcode,0)
       CLOSE t303_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t303_show()
 
   WHILE TRUE
      LET g_rae_o.* = g_rae.*
      LET g_rae.raemodu=g_user
      LET g_rae.raedate=g_today
 
      CALL t303_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rae.*=g_rae_t.*
         CALL t303_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE rae_file SET rae_file.* = g_rae.*
         WHERE rae02 = g_rae.rae02 AND rae01 = g_rae.rae01  
           AND raeplant = g_rae.raeplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rae_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
  #FUN-BB0058 mark START
  #    IF g_rae.rae04<>g_rae_o.rae04 OR
  #       g_rae.rae05<>g_rae_o.rae05 OR
  #       g_rae.rae06<>g_rae_o.rae06 OR
  #       g_rae.rae07<>g_rae_o.rae07 THEN    
  #       CALL t303_total_check()
  #       IF NOT cl_null(g_errno) THEN
  #          CONTINUE WHILE
  #       END IF
  #    END IF
  #FUN-BB0058 mark END
      EXIT WHILE
   END WHILE
 
   CLOSE t303_cl
   COMMIT WORK
   
#FUN-BB0058 add START
   IF g_rae.rae12 <> 0 THEN
      IF g_rae_t.rae12 <> g_rae.rae12 OR 
         (g_rae_t.rae10 <> g_rae.rae10)THEN  #FUN-C10008 add
         CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10,g_rae.rae12)
      END IF
   END IF
#FUN-BB0058 add END

   CALL t303_temptable("2")   #FUN-A80104

   CALL cl_flow_notify(g_rae.rae02,'U')
 
   CALL cl_set_act_visible("gift",g_rae.rae27='Y')
   CALL t303_b1_fill("1=1")
   CALL t303_b2_fill("1=1")
   CALL t303_b3_fill(" 1=1")  #FUN-BB0058 add
END FUNCTION
 

FUNCTION t303_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_raf05_n  LIKE type_file.num5
#FUN-C10008 add START
DEFINE l_sql      STRING
DEFINE l_n        LIKE type_file.num5
DEFINE l_rar04    LIKE rar_file.rar04
DEFINE l_rar05    LIKE rar_file.rar05
#FUN-C10008 add END
   IF g_rae.rae02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 --------------- add -------------- begin
   IF g_rae.raeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rae.raeconf = 'X' THEN CALL cl_err(g_rae.rae01,'9024',0) RETURN END IF
   IF g_rae.raeacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF 
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 --------------- add -------------- end
   SELECT * INTO g_rae.* FROM rae_file 
      WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
        AND raeplant = g_rae.raeplant

   IF g_rae.raeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rae.raeconf = 'X' THEN CALL cl_err(g_rae.rae01,'9024',0) RETURN END IF 
   IF g_rae.raeacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM raf_file
    WHERE raf02 = g_rae.rae02 AND raf01=g_rae.rae01
      AND rafplant = g_rae.raeplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

#-TQC-B60071 - ADD - BEGIN -----------------------
   LET l_raf05_n = 0
   LET l_cnt = 0
   SELECT SUM(raf05) INTO l_raf05_n FROM raf_file 
    WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02 
      AND rafplant = g_rae.raeplant AND rafacti = 'Y'
   SELECT COUNT(*) INTO l_cnt FROM raf_file
    WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
      AND rafplant = g_rae.raeplant AND rafacti = 'Y'
      AND raf04 = '2'
   IF (l_raf05_n > g_rae.rae21) OR (l_raf05_n < g_rae.rae21 AND l_cnt = 0) OR (l_raf05_n = g_rae.rae21 AND l_cnt > 0) THEN
      CALL cl_err('','art-728',0)
      RETURN
   END IF
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM raf_file
    WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
      AND rafplant = g_rae.raeplant AND rafacti = 'Y'
      AND raf03 NOT IN (SELECT rag03 FROM rag_file 
                         WHERE rag01 = g_rae.rae01 AND rag02 = g_rae.rae02
                           AND ragplant = g_rae.raeplant AND ragacti = 'Y')
   IF l_cnt > 0 THEN
      CALL cl_err('','art-730',0)
      RETURN
   END IF
#-TQC-B60071 - ADD -  END  -----------------------
#FUN-BB0058 add START
  #促銷時段未維護資料 不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rak_file
       WHERE rak01 = g_rae.rae01 AND rak02 = g_rae.rae02
         AND rakacti = 'Y' AND rakplant = g_rae.raeplant
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      CALL cl_err('','art-751',0)
      RETURN
   END IF
  #範圍未維護資料 不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rag_file
       WHERE rag01 = g_rae.rae01 AND rag02 = g_rae.rae02
         AND ragacti = 'Y' AND ragplant = g_rae.raeplant
         AND rag03 IN (SELECT raf03 FROM raf_file
                           WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
                           AND rafacti = 'Y' AND rafplant = g_rae.raeplant) 
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      CALL cl_err('','art-752',0)
      RETURN
   END IF
   #設定會員促銷方式,但卻未設定會員促銷方式
   IF g_rae.rae12 <> '0' THEN
      LET l_cnt = 0  
      SELECT COUNT(*) INTO l_cnt FROM rap_file
         WHERE rap01  = g_rae.rae01 AND rap02 = g_rae.rae02
           AND rap03 = '2'
           AND rap09 = g_rae.rae12 
      IF l_cnt < 1 THEN
         CALL cl_err('','art-782',0) 
         RETURN
      END IF
   END IF
  #未維護生效營運中心  不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM raq_file
       WHERE raq01 = g_rae.rae01 AND raq02 = g_rae.rae02
       AND raq03 = '2' AND raqplant = g_rae.raeplant
       AND raqacti = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','art-755',0)
      RETURN
   END IF
  #勾選參予換贈,但未維護換贈資料,不允許確認
   LET l_cnt = 0 
   IF g_rae.rae27 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM rar_file
         WHERE rar01 = g_rae.rae01 AND rar02 = g_rae.rae02 
           AND rar03 = '2' AND rarplant = g_rae.raeplant 
      IF l_cnt < 1 THEN 
         CALL cl_err('','art-783',0)
         RETURN
      END IF
   END IF
#FUN-BB0058 add END
#FUN-C10008 add START
  #換贈存在未維護換贈代碼的換贈項次,不允許確認
   LET l_cnt = 0
   IF g_rae.rae27 = 'Y' THEN
      LET l_sql = " SELECT rar05 FROM rar_file ",
                  "   WHERE rar01 = '",g_rae.rae01,"'",
                  "     AND rar02 = '",g_rae.rae02,"'",
                  "     AND rar03 = 2",
                  "     AND rarplant = '",g_rae.raeplant,"'"
      PREPARE t303_rar FROM l_sql
      DECLARE rar08_cs CURSOR FOR t303_rar
      FOREACH rar08_cs INTO l_rar05
         SELECT COUNT(*) INTO l_n FROM ras_file
           WHERE ras01 = g_rae.rae01 AND ras02 = g_rae.rae02 
             AND ras03 = 2 AND rasplant = g_rae.raeplant
             AND ras05 = l_rar05
         IF l_n < 1 THEN
            CALL cl_err('','art-799',0)
            RETURN
         END IF  
      END FOREACH      
   END IF
#FUN-C10008 add END
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t303_cl:", STATUS, 1)
      CLOSE t303_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t303_cl INTO g_rae.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rae.rae02,SQLCA.sqlcode,0)
      CLOSE t303_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rae_file SET raeconf='Y',
                       raecond=g_today, 
                       raecont=g_time, 
                       raeconu=g_user
     WHERE  rae02 = g_rae.rae02 AND rae01=g_rae.rae01
       AND raeplant = g_rae.raeplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rae.raeconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rae.rae02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rae.* FROM rae_file 
      WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01 
        AND raeplant = g_rae.raeplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rae.raeconu
   DISPLAY BY NAME g_rae.raeconf                                                                                         
   DISPLAY BY NAME g_rae.raecond                                                                                         
   DISPLAY BY NAME g_rae.raecont                                                                                         
   DISPLAY BY NAME g_rae.raeconu
   DISPLAY l_gen02 TO FORMONLY.raeconu_desc
    #CKP
   IF g_rae.raeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rae.raeconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rae.rae02,'V')
END FUNCTION
 
#TQC-A80158 --mark
#FUNCTION t303_void()
#DEFINE l_n LIKE type_file.num5
#
#  IF s_shut(0) THEN RETURN END IF
#  SELECT * INTO g_rae.* FROM rae_file 
#     WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
#       AND raeplant = g_rae.raeplant
#  IF g_rae.rae02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#  IF g_rae.raeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#  IF g_rae.raeacti = 'N' THEN CALL cl_err(g_rae.rae02,'art-142',0) RETURN END IF
#  IF g_rae.raeconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF
#  BEGIN WORK
#
#  OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
#  IF STATUS THEN
#     CALL cl_err("OPEN t303_cl:", STATUS, 1)
#     CLOSE t303_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FETCH t303_cl INTO g_rae.*
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_rae.rae02,SQLCA.sqlcode,0)
#     CLOSE t303_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  IF cl_void(0,0,g_rae.raeconf) THEN
#     LET g_chr = g_rae.raeconf
#     IF g_rae.raeconf = 'N' THEN
#        LET g_rae.raeconf = 'X'
#     ELSE
#        LET g_rae.raeconf = 'N'
#     END IF
#
#     UPDATE rae_file SET raeconf=g_rae.raeconf,
#                         raemodu=g_user,
#                         raedate=g_today
#      WHERE rae01 = g_rae.rae01  AND rae02 = g_rae.rae02
#        AND raeplant = g_rae.raeplant  
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err3("upd","rae_file",g_rae.rae01,"",SQLCA.sqlcode,"","up raeconf",1)
#         LET g_rae.raeconf = g_chr
#         ROLLBACK WORK
#         RETURN
#      END IF
#  END IF
#
#  CLOSE t303_cl
#  COMMIT WORK
#
#  SELECT * INTO g_rae.* FROM rae_file WHERE rae01=g_rae.rae01 AND rae02 = g_rae.rae02 AND raeplant = g_rae.raeplant 
#  DISPLAY BY NAME g_rae.raeconf                                                                                        
#  DISPLAY BY NAME g_rae.raemodu                                                                                        
#  DISPLAY BY NAME g_rae.raedate
#   #CKP
#  IF g_rae.raeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#  CALL cl_set_field_pic(g_rae.raeconf,"","","",g_chr,"")
#
#  CALL cl_flow_notify(g_rae.rae01,'V')
#END FUNCTION
#TQC-A80158 --end

FUNCTION t303_bp_refresh()
#  DISPLAY ARRAY g_raf TO s_raf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#     BEFORE DISPLAY
#        CALL SET_COUNT(g_rec_b+1)
#        CALL fgl_set_arr_curr(g_rec_b+1)
#        CALL cl_show_fld_cont()
#        EXIT DISPLAY
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#  END DISPLAY
 
END FUNCTION

  
FUNCTION t303_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rae.rae02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rae.raeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rae.raeconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
   IF STATUS THEN
      CALL cl_err("OPEN t303_cl:", STATUS, 1)
      CLOSE t303_cl
      RETURN
   END IF
 
   FETCH t303_cl INTO g_rae.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t303_show()
 
   
   IF cl_exp(0,0,g_rae.raeacti) THEN
      LET g_chr=g_rae.raeacti
      IF g_rae.raeacti='Y' THEN
         LET g_rae.raeacti='N'
      ELSE
         LET g_rae.raeacti='Y'
      END IF
 
      UPDATE rae_file SET raeacti=g_rae.raeacti,
                          raemodu=g_user,
                          raedate=g_today
       WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
         AND raeplant = g_rae.raeplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rae_file",g_rae.rae01,"",SQLCA.sqlcode,"","",1) 
         LET g_rae.raeacti=g_chr
      END IF
   END IF
 
   CLOSE t303_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rae.rae01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT raeacti,raemodu,raedate
     INTO g_rae.raeacti,g_rae.raemodu,g_rae.raedate FROM rae_file
    WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
      AND raeplant = g_rae.raeplant

   DISPLAY BY NAME g_rae.raeacti,g_rae.raemodu,g_rae.raedate
 
END FUNCTION
 
FUNCTION t303_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rae.rae02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rae.* FROM rae_file
     WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
      AND raeplant = g_rae.raeplant
 
   IF g_rae.raeconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rae.raeconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rae.raeacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
  
   BEGIN WORK
 
   OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
   IF STATUS THEN
      CALL cl_err("OPEN t303_cl:", STATUS, 1)
      CLOSE t303_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t303_cl INTO g_rae.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t303_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rae01"      
       LET g_doc.value1 = g_rae.rae01    
       CALL cl_del_doc()              
      DELETE FROM rae_file WHERE rae02 = g_rae.rae02 AND rae01 = g_rae.rae01
                             AND raeplant = g_rae.raeplant
      DELETE FROM raf_file WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
                             AND rafplant = g_rae.raeplant 
      DELETE FROM rag_file WHERE rag02 = g_rae.rae02 AND rag01 = g_rae.rae01
                             AND ragplant = g_rae.raeplant
      DELETE FROM raq_file WHERE raq02 = g_rae.rae02 AND raq01 = g_rae.rae01
                             AND raqplant = g_rae.raeplant AND raq03='2'
      DELETE FROM rap_file WHERE rap02 = g_rae.rae02 AND rap01 = g_rae.rae01
                             AND rapplant = g_rae.raeplant AND rap03='2'
      DELETE FROM rar_file WHERE rar02 = g_rae.rae02 AND rar01 = g_rae.rae01
                             AND rarplant = g_rae.raeplant AND rar03='2'
      DELETE FROM ras_file WHERE ras02 = g_rae.rae02 AND ras01 = g_rae.rae01
                             AND rasplant = g_rae.raeplant AND ras03='2'
      DELETE FROM rak_file WHERE rak01 = g_rae.rae01 AND rak02 = g_rae.rae02   #FUN-C10008 add 
                             AND rakplant = g_rae.raeplant  AND rak03 = '2'    #FUN-C10008 add

      CLEAR FORM
      CALL g_raf.clear() 
      CALL g_rag.clear()
      CALL g_rak.clear()  #FUN-C10008 add 

      OPEN t303_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t303_cs
         CLOSE t303_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t303_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t303_cs
         CLOSE t303_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t303_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t303_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t303_fetch('/')
      END IF
   END IF
 
   CLOSE t303_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rae.rae01,'D')
END FUNCTION

#FUN-BB0058 add START
FUNCTION t303_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_azp03   LIKE azp_file.azp03
DEFINE l_line    LIKE type_file.num5
DEFINE l_sql1    STRING
DEFINE l_bamt    LIKE type_file.num5
DEFINE l_rxx04   LIKE rxx_file.rxx04
DEFINE l_raf05_n LIKE type_file.num5 
DEFINE l_ac2     LIKE type_file.num5
DEFINE l_ac2_t   LIKE type_file.num5
DEFINE l_ac1_t   LIKE type_file.num5
DEFINE l_rak05   LIKE rak_file.rak05
DEFINE l_time1   LIKE type_file.num5
DEFINE l_time2   LIKE type_file.num5
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE l_raepos  LIKE rae_file.raepos
DEFINE l_flag           LIKE type_file.chr1    #FUN-D30033
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rae.rae02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rae.* FROM rae_file
     WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
       AND raeplant = g_rae.raeplant
 
    IF g_rae.raeacti ='N' THEN
       CALL cl_err(g_rae.rae01||g_rae.rae02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rae.raeconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rae.raeconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF

    IF g_rae.rae01 <> g_rae.raeplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT raf03,raf04,raf05,rafacti ",
                       "  FROM raf_file ",
                       " WHERE raf01 = ? AND raf02=? AND raf03=? AND rafplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t303_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_forupd_sql = "SELECT rag03,rag04,rag05,'',rag06,'',ragacti", 
                       "  FROM rag_file ",
                       " WHERE rag01=? AND rag02=? AND rag03=? AND rag04=? ",
                       "   AND rag05=? AND rag06=? AND ragplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t3031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT rak05,rak06,rak07,rak08,rak09, ",
                      " rak10,rak11,rakacti ",
                      "  FROM rak_file ",
                      " WHERE rak01=? AND rak02=? AND rak03='2' AND rakplant = ? AND rak05 = ? ",
                      " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3032_bcl CURSOR FROM g_forupd_sql

    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    IF g_rec_b1 > 0 THEN LET l_ac1 = 1 END IF     #FUN-D30033 add
    IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF     #FUN-D30033 add
    IF g_rec_b  > 0 THEN LET l_ac  = 1 END IF     #FUN-D30033 add

    DIALOG ATTRIBUTES(UNBUFFERED)

       INPUT ARRAY g_rak FROM s_rak.*
             ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)
    
           BEFORE INPUT
              IF g_rec_b2 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac)
              END IF
              LET g_b_flag = '2'   #FUN-D30033 add
    
           BEFORE ROW
              LET l_ac2 = ARR_CURR()
              LET p_cmd = ''
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              CALL t303_set_entry_rak(l_ac2) 
               LET l_flag = '2'               #FUN-D30033
    
              BEGIN WORK
    
              OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
              IF STATUS THEN
                 CALL cl_err("OPEN t303_cl:", STATUS, 1)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF
            #TQC-C20106 add START
              FETCH t303_cl INTO g_rae.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF
            #TQC-C20106 add END
              IF g_rec_b2 >= l_ac2 THEN
                 LET p_cmd='u'
                 LET g_rak_t.* = g_rak[l_ac2].*  #BACKUP
                 LET g_rak_o.* = g_rak[l_ac2].*  #BACKUP
                 OPEN t3032_bcl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant,g_rak[l_ac2].rak05
                 IF STATUS THEN
                    CALL cl_err("OPEN t3032_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t3032_bcl INTO g_rak[l_ac2].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rak_t.rak05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
              END IF
    
           BEFORE INSERT
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              INITIALIZE g_rak[l_ac2].* TO NULL
              LET g_rak[l_ac2].rakacti = 'Y'
              CALL cl_show_fld_cont()
              LET g_rak[l_ac2].rak08 = '00:00:00'     #促銷開始時間
              LET g_rak[l_ac2].rak09 = '23:59:59'     #促銷結束時間
              IF NOT cl_null(g_rae.rae03) THEN
                 SELECT raa05,raa06 INTO g_rak[l_ac2].rak06,g_rak[l_ac2].rak07
                   FROM raa_file
                 WHERE raa01=g_rae.rae01 AND raa02=g_rae.rae03
              END IF
              IF cl_null(g_rak[l_ac2].rak06) THEN
                 LET g_rak[l_ac2].rak06 = g_today        #促銷開始日期
              END IF
              IF cl_null(g_rak[l_ac2].rak07) THEN
                 LET g_rak[l_ac2].rak07 = g_today        #促銷結束日期
              END IF
              SELECT MAX(rak05) INTO g_rak[l_ac2].rak05 FROM rak_file
                   WHERE rak01 = g_rae.rae01
                     AND rak02 = g_rae.rae02
                     AND rak03 = '2'
              IF cl_null(g_rak[l_ac2].rak05) OR g_rak[l_ac2].rak05 = 0 THEN
                 LET g_rak[l_ac2].rak05 = 1
              ELSE
                 LET g_rak[l_ac2].rak05 = g_rak[l_ac2].rak05 + 1
              END IF
              DISPLAY BY NAME g_rak[l_ac2].rak05
              LET g_rak_t.* = g_rak[l_ac2].*
              LET g_rak_o.* = g_rak[l_ac2].*
              NEXT FIELD rak05
    
           AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
    
              SELECT MAX(rak05) INTO l_rak05 FROM rak_file
                   WHERE rak01 = g_rae.rae01
                     AND rak02 = g_rae.rae02
                     AND rak03 = '2'
              IF cl_null(l_rak05) OR l_rak05 = 0 THEN
                 LET l_rak05 = 1
              ELSE
                 LET l_rak05 = l_rak05 + 1
              END IF
              IF cl_null(g_rak[l_ac2].rak11) THEN
                 LET g_rak[l_ac2].rak11 = ' '
              END IF    
              INSERT INTO rak_file(rak01,rak02,rak03,rak04,rak05,rak06,
                                   rak07,rak08,rak09,rak10,rak11,rakacti,
                                   rakcrdate,raklegal,rakplant,
                                   rakpos)
              VALUES(g_rae.rae01,g_rae.rae02,
                     '2',0,
                     g_rak[l_ac2].rak05,g_rak[l_ac2].rak06,
                     g_rak[l_ac2].rak07,g_rak[l_ac2].rak08,
                     g_rak[l_ac2].rak09,g_rak[l_ac2].rak10,
                     g_rak[l_ac2].rak11,g_rak[l_ac2].rakacti,
                     g_today,g_rae.raelegal,g_rae.raeplant,'1')
    
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rak_file",g_rae.rae01,g_rak[l_ac2].rak05,SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 CALL t303_update_pos()
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET g_rec_b2=g_rec_b2+1
              END IF
              
           AFTER FIELD rak05
              IF NOT cl_null(g_rak[l_ac2].rak05) THEN
                 LET l_cnt = 0
                 IF g_rak_t.rak05 <> g_rak[l_ac2].rak05 OR 
                   cl_null(g_rak_t.rak05) THEN 
                    SELECT COUNT(*) INTO l_cnt FROM rak_file
                       WHERE rak01 = g_rae.rae01 AND rak02 = g_rae.rae02
                         AND rak03 = '2' AND rak05 = g_rak[l_ac2].rak05
                    IF l_cnt > 0 AND NOT cl_null(l_cnt) THEN
                       CALL cl_err('','art-780',0)  
                       NEXT FIELD rak05
                    END IF
                 END IF
              END IF 
    
           AFTER FIELD rak06
              IF NOT cl_null(g_rak[l_ac2].rak06) THEN
                 IF NOT cl_null(g_rak[l_ac2].rak07) THEN
                    IF g_rak[l_ac2].rak06 > g_rak[l_ac2].rak07 THEN
                       CALL cl_err('','art-201',0)
                       NEXT FIELD rak06
                    END IF
                 END IF
              END IF
    
           AFTER FIELD rak07
              IF NOT cl_null(g_rak[l_ac2].rak07) THEN
                 IF NOT cl_null(g_rak[l_ac2].rak06) THEN
                    IF g_rak[l_ac2].rak06 > g_rak[l_ac2].rak07 THEN
                       CALL cl_err('','art-201',0)
                       NEXT FIELD rak07
                    END IF
                 END IF
              END IF
    
          AFTER FIELD rak08  #開始時間
            IF NOT cl_null(g_rak[l_ac2].rak08) THEN
               IF p_cmd = "a" OR
                      (p_cmd = "u" AND g_rak[l_ac2].rak08<>g_rak_t.rak08) THEN
                  CALL t303_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rak08
                  ELSE
                    IF NOT cl_null(g_rak[l_ac2].rak09) THEN
                       CALL t303_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
                       IF l_time1>=l_time2 THEN
                         CALL cl_err('','art-207',0)
                          NEXT FIELD rak09
                       END IF
                    END IF
                  END IF
               END IF
            END IF
    
          AFTER FIELD rak09  #結束時間
            IF NOT cl_null(g_rak[l_ac2].rak09) THEN
               IF p_cmd = "a" OR
                      (p_cmd = "u" AND g_rak[l_ac2].rak09<>g_rak_t.rak09) THEN
                   CALL t303_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                      NEXT FIELD rak09
                   ELSE
                     IF NOT cl_null(g_rak[l_ac2].rak08) THEN
                         CALL t303_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
                        IF l_time1>=l_time2 THEN
                            CALL cl_err('','art-207',0)
                            NEXT FIELD rak08
                         END IF
                      END IF
                   END IF
               END IF
            END IF
    
           ON CHANGE rak10 
              CALL t303_set_entry_rak(l_ac2)
    
           ON CHANGE rak11
              CALL t303_set_entry_rak(l_ac2)
    
           AFTER ROW
              LET l_ac2 = ARR_CURR()
              LET l_ac2_t = l_ac2
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_rak[l_ac2].* = g_rak_t.*
                 END IF
                 CLOSE t3032_bcl
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF
    
              IF NOT cl_null(g_rak[l_ac2].rak06) AND NOT cl_null(g_rak[l_ac2].rak07) THEN
                 IF g_rak[l_ac2].rak07<g_rak[l_ac2].rak06 THEN
                    CALL cl_err('','art-201',0)
                    NEXT FIELD rak07
                 END IF
              END IF
              CLOSE t3032_bcl
              COMMIT WORK
    
          BEFORE DELETE 
             IF g_rak_t.rak05 > 0 AND NOT cl_null(g_rak_t.rak05) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rak_file
                 WHERE rak02 = g_rae.rae02 AND rak01 = g_rae.rae01
                   AND rak03 = '2' 
                   AND rak05 = g_rak[l_ac2].rak05
                   AND rakplant = g_rae.raeplant
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rak_file",g_rae.rae01,g_rak_t.rak05,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF p_cmd = 'u' THEN
                   LET g_rec_b2 = g_rec_b2 - 1
                END IF
               #TQC-C20106 add START
                IF g_rec_b2 < l_ac2 THEN
                   CALL g_rak.deleteElement(l_ac2)
                END IF
               #TQC-C20106 add END
             END IF
             COMMIT WORK
    
          ON ROW CHANGE      
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0    
                LET g_rak[l_ac2].* = g_rak_t.*
                CLOSE t3032_bcl       
                ROLLBACK WORK   
                EXIT DIALOG  
             END IF
             IF cl_null(g_rak[l_ac2].rak11) THEN 
                LET g_rak[l_ac2].rak11 = ' '
             END IF
             IF l_lock_sw = 'Y' THEN                  
                CALL cl_err(g_rak[l_ac2].rak05,-263,1)
                LET g_rak[l_ac2].* = g_rak_t.*                   
             ELSE                                
                UPDATE rak_file SET 
                                    rak06 = g_rak[l_ac2].rak06,
                                    rak07 = g_rak[l_ac2].rak07,
                                    rak08 = g_rak[l_ac2].rak08,
                                    rak09 = g_rak[l_ac2].rak09,
                                    rak10 = g_rak[l_ac2].rak10,
                                    rak11 = g_rak[l_ac2].rak11,
                                    rakacti = g_rak[l_ac2].rakacti
                 WHERE rak02 = g_rae.rae02 AND rak01 = g_rae.rae01
                   AND rak03 = '2'  
                   AND rak05 = g_rak_t.rak05  AND rakplant = g_rae.raeplant
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","rak_file",g_rae.rae01,g_rak_t.rak05,SQLCA.sqlcode,"","",1)
                   LET g_rak[l_ac2].* = g_rak_t.*
                ELSE
                   CALL t303_update_pos()
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
       END INPUT

       INPUT ARRAY g_raf FROM s_raf.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)

           BEFORE INPUT
              DISPLAY "BEFORE INPUT!"
              IF g_rec_b != 0 THEN
                 CALL fgl_set_arr_curr(l_ac)
              END IF
              LET g_b_flag = '3'   #FUN-D30033 add

           BEFORE ROW
              LET l_ac = ARR_CURR()
              LET p_cmd = ''
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              LET l_flag = '3'               #FUN-D30033

              BEGIN WORK

              OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
              IF STATUS THEN
                 CALL cl_err("OPEN t303_cl:", STATUS, 1)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF

              FETCH t303_cl INTO g_rae.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF

              IF g_rec_b >= l_ac THEN
                 LET p_cmd='u'
                 LET g_raf_t.* = g_raf[l_ac].*  #BACKUP
                 LET g_raf_o.* = g_raf[l_ac].*  #BACKUP
                 IF p_cmd='u' THEN
                    CALL cl_set_comp_entry("raf03",FALSE)
                 ELSE
                    CALL cl_set_comp_entry("raf03",TRUE)
                 END IF
                 OPEN t303_bcl USING g_rae.rae01,g_rae.rae02,g_raf_t.raf03,g_rae.raeplant
                 IF STATUS THEN
                    CALL cl_err("OPEN t303_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t303_bcl INTO g_raf[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_raf_t.raf03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
                 #No.MOD-CC0144 --Begin
                 IF NOT cl_null(g_rae.rae21) THEN
                    CALL cl_set_comp_entry("raf04",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("raf04",FALSE)
                 END IF
                 #No.MOD-CC0144 --End
              END IF
              CALL t303_raf05_entry(g_raf[l_ac].raf04) 

           BEFORE INSERT
              DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              INITIALIZE g_raf[l_ac].* TO NULL
              LET g_raf[l_ac].raf04 = '1'      #參與方式 1:必選 2:可選
              LET g_raf[l_ac].raf05 = 0        #數量
              LET g_raf[l_ac].rafacti = 'Y'

              LET g_raf_t.* = g_raf[l_ac].*
              LET g_raf_o.* = g_raf[l_ac].*
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("raf03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("raf03",TRUE)
              END IF
              IF NOT cl_null(g_rae.rae21) THEN
                 CALL cl_set_comp_entry("raf04",TRUE)
              ELSE
                 CALL cl_set_comp_entry("raf04",FALSE)
              END IF
              CALL cl_set_comp_entry('raf05',TRUE)
              CALL t303_raf05_entry(g_raf[l_ac].raf04)
              CALL cl_show_fld_cont()
              NEXT FIELD raf03

           AFTER INSERT
              DISPLAY "AFTER INSERT!"
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
                 IF g_raf[l_ac].raf04='1' THEN    #TQC-A90023   --add
                    IF g_raf[l_ac].raf05 <= 0 THEN
                       CALL cl_err('','aem-042',0)
                       NEXT FIELD raf05
                    END IF    #TQC-A90023 --add
                 END IF

              INSERT INTO raf_file(raf01,raf02,raf03,raf04,raf05,rafacti,rafplant,raflegal)
              VALUES(g_rae.rae01,g_rae.rae02,
                     g_raf[l_ac].raf03,g_raf[l_ac].raf04,
                     g_raf[l_ac].raf05,g_raf[l_ac].rafacti,
                     g_rae.raeplant,g_rae.raelegal)

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","raf_file",g_rae.rae02,g_raf[l_ac].raf03,SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 IF p_cmd='u' THEN
                    CALL t303_upd_log()
                 END IF
                 COMMIT WORK
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF

           BEFORE FIELD raf03
              IF g_raf[l_ac].raf03 IS NULL OR g_raf[l_ac].raf03 = 0 THEN
                 SELECT max(raf03)+1
                   INTO g_raf[l_ac].raf03
                   FROM raf_file
                  WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
                    AND rafplant = g_rae.raeplant
                 IF g_raf[l_ac].raf03 IS NULL THEN
                    LET g_raf[l_ac].raf03 = 1
                 END IF
              END IF

           AFTER FIELD raf03
              IF NOT cl_null(g_raf[l_ac].raf03) THEN
                 IF g_raf[l_ac].raf03 != g_raf_t.raf03
                    OR g_raf_t.raf03 IS NULL THEN
                    SELECT count(*)
                      INTO l_n
                      FROM raf_file
                     WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
                       AND raf03 = g_raf[l_ac].raf03 AND rafplant = g_rae.raeplant
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_raf[l_ac].raf03 = g_raf_t.raf03
                       NEXT FIELD raf02
                    END IF
                 END IF
              END IF
             #FUN-C10008 add START
              IF NOT cl_null(g_raf[l_ac].raf05) THEN
                 IF g_raf_o.raf05=0 OR
                    (g_raf[l_ac].raf05 != g_raf_o.raf05 ) THEN
                    CALL t303_raf05_check(g_raf[l_ac].raf05)
                    IF NOT cl_null(g_errno) THEN
                       NEXT FIELD raf04
                    ELSE
                       DISPLAY BY NAME g_raf[l_ac].raf05
                    END IF
                 END IF
              END IF
             #FUN-C10008 add END

         BEFORE FIELD raf04
            IF NOT cl_null(g_rae.rae21) AND g_rae.rae21<>0 THEN
               CALL cl_set_comp_entry("raf04",TRUE)
            ELSE
               LET g_raf[l_ac].raf04='1'
               CALL cl_set_comp_entry("raf04",FALSE)
            END IF

         AFTER FIELD raf04
            IF NOT cl_null(g_raf[l_ac].raf04) THEN
               IF g_raf_o.raf04 IS NULL OR
                  (g_raf[l_ac].raf04 != g_raf_o.raf04 ) THEN
                  IF g_raf[l_ac].raf04 NOT MATCHES '[12]' THEN
                     LET g_raf[l_ac].raf04= g_raf_o.raf04
                     NEXT FIELD raf04
                  ELSE
                     IF NOT cl_null(g_rae.rae21) AND g_rae.rae21 > 0 THEN
                        LET l_raf05_n = 0
                        SELECT SUM(raf05) INTO l_raf05_n FROM raf_file
                         WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
                           AND rafplant = g_rae.raeplant AND rafacti = 'Y'
                        IF l_raf05_n = g_rae.rae21 AND g_raf[l_ac].raf04 = '2' THEN
                           CALL cl_err('','art-729',0)
                           NEXT FIELD raf04
                        END IF
                     END IF
                     CALL t303_raf05_entry(g_raf[l_ac].raf04)
                  END IF
               END IF
            END IF
           #FUN-C10008 add START
            IF NOT cl_null(g_raf[l_ac].raf05) THEN
               IF g_raf_o.raf05=0 OR
                  (g_raf[l_ac].raf05 != g_raf_o.raf05 ) THEN
                  CALL t303_raf05_check(g_raf[l_ac].raf05)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('raf05',g_errno,0)
                     LET g_raf[l_ac].raf05= g_raf_o.raf05
                     NEXT FIELD raf05
                  ELSE
                     DISPLAY BY NAME g_raf[l_ac].raf05
                  END IF
               END IF
            END IF
           #FUN-C10008 add END

         ON CHANGE raf04
            IF NOT cl_null(g_raf[l_ac].raf04) THEN
               IF NOT cl_null(g_rae.rae21) AND g_rae.rae21 > 0 THEN
                  LET l_raf05_n = 0
                  SELECT SUM(raf05) INTO l_raf05_n FROM raf_file
                   WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
                     AND rafplant = g_rae.raeplant AND rafacti = 'Y'
                  IF l_raf05_n = g_rae.rae21 AND g_raf[l_ac].raf04 = '2' THEN
                     CALL cl_err('','art-729',0)
                     NEXT FIELD raf04
                  END IF
               END IF
               CALL t303_raf05_entry(g_raf[l_ac].raf04)
            END IF

         BEFORE FIELD raf05
            IF NOT cl_null(g_raf[l_ac].raf04) THEN
               CALL t303_raf05_entry(g_raf[l_ac].raf04)
            END IF

         AFTER FIELD raf05  
            IF NOT cl_null(g_raf[l_ac].raf05) THEN
               IF g_raf_o.raf05=0 OR
                  (g_raf[l_ac].raf05 != g_raf_o.raf05 ) THEN
                  CALL t303_raf05_check(g_raf[l_ac].raf05)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('raf05',g_errno,0)
                     LET g_raf[l_ac].raf05= g_raf_o.raf05
                     NEXT FIELD raf05
                  ELSE
                     DISPLAY BY NAME g_raf[l_ac].raf05
                  END IF
               END IF
            END IF

           BEFORE DELETE
              IF g_raf_t.raf03 > 0 AND g_raf_t.raf03 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 SELECT COUNT(*) INTO l_n FROM rag_file
                  WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
                    AND rag03=g_raf_t.raf03 AND ragplant=g_rae.raeplant
                 IF l_n>0 THEN
                    CALL cl_err(g_raf_t.raf03,'art-664',0)
                    CANCEL DELETE
                 ELSE
                    SELECT COUNT(*) INTO l_n FROM rap_file
                     WHERE rap01=g_rae.rae01 AND rap02=g_rae.rae02 AND rap03='2'
                       AND rap03=g_raf_t.raf03 AND rapplant=g_rae.raeplant
                    IF l_n>0 THEN
                       CALL cl_err(g_raf_t.raf03,'art-665',0)
                       CANCEL DELETE
                    END IF
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM raf_file
                  WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
                    AND raf03 = g_raf_t.raf03  AND rafplant = g_rae.raeplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","raf_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                    # FUN-B80085增加空白行

                  	 DELETE FROM rag_file
                  	  WHERE rag01 = g_rae.rae01   AND rag02 = g_rae.rae02
                       AND rag03 = g_raf_t.raf03 AND ragplant = g_rae.raeplant
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","rag_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    ELSE 
                       CALL g_raf.deleteelement(l_ac)
                    END IF
                 END IF
                 CALL t303_upd_log()
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
              COMMIT WORK
 
           ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_raf[l_ac].* = g_raf_t.*
                 CLOSE t303_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
              IF cl_null(g_raf[l_ac].raf04) THEN
                 NEXT FIELD raf04
              END IF

              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_raf[l_ac].raf03,-263,1)
                 LET g_raf[l_ac].* = g_raf_t.*
              ELSE
                 UPDATE raf_file SET raf04  =g_raf[l_ac].raf04,
                                     raf05  =g_raf[l_ac].raf05,
                                     rafacti=g_raf[l_ac].rafacti
                  WHERE raf02 = g_rae.rae02 AND raf01=g_rae.rae01
                    AND raf03=g_raf_t.raf03 AND rafplant = g_rae.raeplant
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","raf_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1)
                    LET g_raf[l_ac].* = g_raf_t.*
                 ELSE
                    MESSAGE 'UPDATE raf_file O.K'
                    CALL t303_upd_log()
                    COMMIT WORK
                 END IF
              END IF

           AFTER ROW
              DISPLAY  "AFTER ROW!!"
              LET l_ac = ARR_CURR()
              LET l_ac_t = l_ac
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_raf[l_ac].* = g_raf_t.*
                 END IF
                 CLOSE t303_bcl
                 ROLLBACK WORK
                 EXIT DIALOG  

              ELSE
                 IF g_raf[l_ac].raf04='1' THEN   #TQC-A90023 --ADD
                   IF g_raf[l_ac].raf05 <= 0 THEN
                      CALL cl_err('','aem-042',0)
                      NEXT FIELD raf05
                   END IF
                 END IF
              END IF

              CLOSE t303_bcl
              COMMIT WORK

           AFTER INPUT
              IF NOT cl_null(g_rae.rae02) THEN
              ELSE
                 CALL cl_err('',-400,0)
              END IF

              CALL t303_upd_rae21()

       END INPUT

       INPUT ARRAY g_rag FROM s_rag.*
             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)

           BEFORE INPUT
              DISPLAY "BEFORE INPUT!"
              IF g_rec_b1 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac1)
              END IF
              LET g_b_flag = '1'   #FUN-D30033 add


           BEFORE ROW
              LET l_ac1 = ARR_CURR()
              LET p_cmd = ''
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              LET l_flag = '1'               #FUN-D30033

              BEGIN WORK

              OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
              IF STATUS THEN
                 CALL cl_err("OPEN t303_cl:", STATUS, 1)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF

              FETCH t303_cl INTO g_rae.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
                 CLOSE t303_cl
                 ROLLBACK WORK
                 RETURN
              END IF

              IF g_rec_b1 >= l_ac1 THEN
                 LET p_cmd='u'
                 LET g_rag_t.* = g_rag[l_ac1].*  #BACKUP
                 LET g_rag_o.* = g_rag[l_ac1].*  #BACKUP
                 IF cl_null(g_rag_t.rag06) THEN
                    LET g_rag_t.rag06 = ' '
                 END IF
                 OPEN t3031_bcl USING g_rae.rae01,g_rae.rae02,g_rag_t.rag03,g_rag_t.rag04,
                                      g_rag_t.rag05,g_rag_t.rag06,g_rae.raeplant
                 IF STATUS THEN
                    CALL cl_err("OPEN t3031_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t3031_bcl INTO g_rag[l_ac1].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rag_t.rag03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                    CALL t303_rag05('d',l_ac1)
                    CALL t303_rag06('d')
                 END IF
             END IF

           BEFORE INSERT
              DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              INITIALIZE g_rag[l_ac1].* TO NULL
              LET g_rag[l_ac1].rag04 = '01'     #FUN-A80104
              LET g_rag[l_ac1].ragacti = 'Y'            #Body default
             #LET g_rag_t.* = g_rag[l_ac1].*  #TQC-C20336 mark
             #LET g_rag_o.* = g_rag[l_ac1].*  #TQC-C20336 mark
              IF cl_null(g_rag[l_ac1].rag06) THEN
                 LET g_rag[l_ac1].rag06 = ' '
              END IF
              CALL cl_show_fld_cont()
              IF l_ac1 = 1 THEN 
                 SELECT MIN(raf03) INTO g_rag[l_ac1].rag03 FROM raf_file
                    WHERE raf01=g_rae.rae01 AND raf02=g_rae.rae02 AND rafplant=g_rae.raeplant
              ELSE 
                 LET g_rag[l_ac1].rag03 = g_rag[l_ac1-1].rag03
              END IF
              DISPLAY BY NAME g_rag[l_ac1].rag03
             #TQC-C20336 add START
              LET g_rag_t.* = g_rag[l_ac1].*
              LET g_rag_o.* = g_rag[l_ac1].*
             #TQC-C20336 add END
              NEXT FIELD rag03

           AFTER INSERT
              DISPLAY "AFTER INSERT!"
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
              IF cl_null(g_rag[l_ac1].rag06) THEN
                 LET g_rag[l_ac1].rag06 = ' '
              END IF
              IF cl_null(g_rag[l_ac1].rag06_desc) THEN
                 LET g_rag[l_ac1].rag06_desc = ' '
              END IF
              SELECT COUNT(*) INTO l_n FROM rag_file
               WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
                 AND ragplant=g_rae.raeplant
                 AND rag03=g_rag[l_ac1].rag03
                 AND rag04=g_rag[l_ac1].rag04
                 AND rag05=g_rag[l_ac1].rag05
                 AND rag06=g_rag[l_ac1].rag06
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_rag[l_ac1].* = g_rag_t.*
                 NEXT FIELD rag03
              END IF
              INSERT INTO rag_file(rag01,rag02,rag03,rag04,rag05,rag06,
                                   ragacti,ragplant,raglegal)
              VALUES(g_rae.rae01,g_rae.rae02,
                     g_rag[l_ac1].rag03,g_rag[l_ac1].rag04,
                     g_rag[l_ac1].rag05,g_rag[l_ac1].rag06,
                     g_rag[l_ac1].ragacti,
                     g_rae.raeplant,g_rae.raelegal)

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rag_file",g_rae.rae01,g_rag[l_ac1].rag03,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL INSERT
              ELSE
                 CALL s_showmsg_init()
                 LET g_errno=' '
                 IF NOT cl_null(g_errno) THEN
                    LET g_rag[l_ac1].* = g_rag_t.*
                    ROLLBACK WORK
                    NEXT FIELD PREVIOUS
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    LET g_rec_b1=g_rec_b1+1
                    DISPLAY g_rec_b1 TO FORMONLY.cn2
                 END IF
              END IF


         AFTER FIELD rag03
            IF NOT cl_null(g_rag[l_ac1].rag03) THEN
               IF g_rag_o.rag03 IS NULL OR
                  (g_rag[l_ac1].rag03 != g_rag_o.rag03 ) THEN
                  CALL t303_rag03()    #檢查其有效性
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rag[l_ac1].rag03,g_errno,0)
                     LET g_rag[l_ac1].rag03 = g_rag_o.rag03
                     NEXT FIELD rag03
                  END IF
               END IF
            END IF

         AFTER FIELD rag04
            IF NOT cl_null(g_rag[l_ac1].rag04) THEN
               IF g_rag_o.rag04 IS NULL OR
                  (g_rag[l_ac1].rag04 != g_rag_o.rag04 ) THEN
                  CALL t303_rag04()
               END IF
            END IF

         ON CHANGE rag04
            IF NOT cl_null(g_rag[l_ac1].rag04) THEN
               CALL t303_rag04()

               LET g_rag[l_ac1].rag05=NULL
               LET g_rag[l_ac1].rag05_desc=NULL
               LET g_rag[l_ac1].rag06=NULL
               LET g_rag[l_ac1].rag06_desc=NULL
               DISPLAY BY NAME g_rag[l_ac1].rag05,g_rag[l_ac1].rag05_desc
               DISPLAY BY NAME g_rag[l_ac1].rag06,g_rag[l_ac1].rag06_desc
            END IF

         BEFORE FIELD rag05,rag06
            IF NOT cl_null(g_rag[l_ac1].rag04) THEN
               CALL t303_rag04()
            END IF

         AFTER FIELD rag05
            IF NOT cl_null(g_rag[l_ac1].rag05) THEN
               IF g_rag[l_ac1].rag04 = '01' THEN #FUN-AB0033 add
                  IF NOT s_chk_item_no(g_rag[l_ac1].rag05,"") THEN
                     CALL cl_err('',g_errno,1)
                     LET g_rag[l_ac1].rag05= g_rag_t.rag05
                     NEXT FIELD rag05
                  END IF
               END IF
               IF g_rag_o.rag05 IS NULL OR
                  (g_rag[l_ac1].rag05 != g_rag_o.rag05 ) THEN
                  CALL t303_rag05('a',l_ac1)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rag[l_ac1].rag05,g_errno,0)
                     LET g_rag[l_ac1].rag05 = g_rag_o.rag05
                     NEXT FIELD rag05
                  END IF
               END IF
             #FUN-BB0058 add START
               LET l_n = 0
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rag_t.rag05 <> g_rag[l_ac1].rag05) THEN
                  SELECT COUNT(*) INTO l_n FROM rag_file
                     WHERE rag02 = g_rae.rae02 AND rag01=g_rae.rae01
                       AND rag03 = g_rag[l_ac1].rag03
                       AND rag04 = g_rag[l_ac1].rag04
                       AND ragplant = g_rae.raeplant
                       AND rag05 = g_rag[l_ac1].rag05
                  IF l_n > 0 THEN 
                     CALL cl_err('','art-779',0)
                     NEXT FIELD rag05
                  END IF
                END IF
             #FUN-BB0058 add END
            END IF

         AFTER FIELD rag06
            IF NOT cl_null(g_rag[l_ac1].rag06) THEN
               IF g_rag_o.rag06 IS NULL OR
                  (g_rag[l_ac1].rag06 != g_rag_o.rag06 ) THEN
                  CALL t303_rag06('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rag[l_ac1].rag06,g_errno,0)
                     LET g_rag[l_ac1].rag06 = g_rag_o.rag06
                     NEXT FIELD rag06
                  END IF
               END IF
            END IF

           BEFORE DELETE
              DISPLAY "BEFORE DELETE"
              IF g_rag_t.rag03 > 0 AND g_rag_t.rag03 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM rag_file
                  WHERE rag02 = g_rae.rae02 AND rag01 = g_rae.rae01
                    AND rag03 = g_rag_t.rag03 AND rag04 = g_rag_t.rag04
                    AND rag05 = g_rag_t.rag05 AND rag06 = g_rag_t.rag06
                    AND ragplant = g_rae.raeplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rag_file",g_rae.rae02,g_rag_t.rag03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 LET g_rec_b1=g_rec_b1-1
                 DISPLAY g_rec_b1 TO FORMONLY.cn2
              END IF
             #TQC-C20336 add START
              IF g_rec_b1 < l_ac1 THEN
                 CALL g_rag.deleteElement(l_ac1)
              END IF
             #TQC-C20336 add END
              COMMIT WORK

           ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_rag[l_ac1].* = g_rag_t.*
                 CLOSE t3031_bcl
                 ROLLBACK WORK
                 EXIT DIALOG  
              END IF

              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_rag[l_ac1].rag03,-263,1)
                 LET g_rag[l_ac1].* = g_rag_t.*
              ELSE
                 #Add No:TQC-B10082
                 IF cl_null(g_rag[l_ac1].rag06) THEN
                    LET g_rag[l_ac1].rag06 = ' '
                 END IF
                 #End Add No:TQC-B10082
                 IF g_rag[l_ac1].rag03<>g_rag_t.rag03 OR
                    g_rag[l_ac1].rag04<>g_rag_t.rag04 OR
                    g_rag[l_ac1].rag05<>g_rag_t.rag05 OR
                    g_rag[l_ac1].rag06<>g_rag_t.rag06 THEN

                    SELECT COUNT(*) INTO l_n FROM rag_file
                     WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
                       AND ragplant=g_rae.raeplant
                       AND rag03=g_rag_t.rag03
                       AND rag04=g_rag_t.rag04
                       AND rag05=g_rag_t.rag05
                       AND rag06=g_rag_t.rag06
                    IF l_n=0 THEN
                       INSERT INTO rag_file(rag01,rag02,rag03,rag04,rag05,rag06,
                                            ragacti,ragplant,raglegal)
                       VALUES(g_rae.rae01,g_rae.rae02,
                              g_rag[l_ac1].rag03,g_rag[l_ac1].rag04,
                              g_rag[l_ac1].rag05,g_rag[l_ac1].rag06,
                              g_rag[l_ac1].ragacti,
                              g_rae.raeplant,g_rae.raelegal)

                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("ins","rag_file",g_rae.rae01,g_rag[l_ac1].rag03,SQLCA.sqlcode,"","",1)
                          LET g_rag[l_ac1].* = g_rag_t.*
                          ROLLBACK WORK
                       ELSE
                          CALL s_showmsg_init()
                          LET g_errno=' '
                          IF NOT cl_null(g_errno) THEN
                             LET g_rag[l_ac1].* = g_rag_t.*
                             ROLLBACK WORK
                             NEXT FIELD PREVIOUS
                          ELSE
                             MESSAGE 'UPDATE O.K'
                             COMMIT WORK
                             LET g_rec_b1=g_rec_b1+1
                             DISPLAY g_rec_b1 TO FORMONLY.cn2
                          END IF
                       END IF
                    ELSE
                       SELECT COUNT(*) INTO l_n FROM rag_file
                        WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
                          AND ragplant=g_rae.raeplant
                          AND rag03=g_rag[l_ac1].rag03
                          AND rag04=g_rag[l_ac1].rag04
                          AND rag05=g_rag[l_ac1].rag05
                          AND rag06=g_rag[l_ac1].rag06
                       IF l_n>0 THEN
                          CALL cl_err('',-239,0)
                         #LET g_rag[l_ac1].* = g_rag_t.*
                          NEXT FIELD rag03
                       END IF
                       UPDATE rag_file SET rag03=g_rag[l_ac1].rag03,
                                           rag04=g_rag[l_ac1].rag04,
                                           rag05=g_rag[l_ac1].rag05,
                                           rag06=g_rag[l_ac1].rag06,
                                           ragacti=g_rag[l_ac1].ragacti
                        WHERE rag02 = g_rae.rae02 AND rag01=g_rae.rae01
                          AND rag03 = g_rag_t.rag03 AND rag04 = g_rag_t.rag04
                          AND rag05 = g_rag_t.rag05 AND rag06 = g_rag_t.rag06
                          AND ragplant = g_rae.raeplant
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("upd","rag_file",g_rae.rae02,g_rag_t.rag03,SQLCA.sqlcode,"","",1)
                          LET g_rag[l_ac1].* = g_rag_t.*
                          ROLLBACK WORK
                       ELSE
                          CALL s_showmsg_init()
                          LET g_errno=' '
                          IF NOT cl_null(g_errno) THEN
                             LET g_rag[l_ac1].* = g_rag_t.*
                             ROLLBACK WORK
                             NEXT FIELD PREVIOUS
                          ELSE
                             MESSAGE 'UPDATE O.K'
                             COMMIT WORK
                          END IF
                       END IF
                    END IF
                 END IF
              END IF

           AFTER ROW
              DISPLAY  "AFTER ROW!!"
              LET l_ac1 = ARR_CURR()
              LET l_ac1_t = l_ac1
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_rag[l_ac1].* = g_rag_t.*
                 END IF
                 CLOSE t3031_bcl
                 ROLLBACK WORK
                 EXIT DIALOG  
              END IF
              CLOSE t3031_bcl
              COMMIT WORK

       END INPUT

      #FUN-D30033--add---begin---
      BEFORE DIALOG
         CASE g_b_flag
            WHEN '1' NEXT FIELD rag03
            WHEN '2' NEXT FIELD rak05
            WHEN '3' NEXT FIELD raf03
         END CASE
      #FUN-D30033--add---end---
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
      #FUN-D30033--add--str--
         IF l_flag = '1' THEN
            IF p_cmd = 'a' THEN
               CALL g_rag.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac1 = l_ac1_t
               END IF
            END IF
            CLOSE t3031_bcl
            ROLLBACK WORK
         END IF
         IF l_flag = '2' THEN
            IF p_cmd = 'a' THEN
               CALL g_rak.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac2 = l_ac2_t
               END IF
            END IF
            CLOSE t3032_bcl
            ROLLBACK WORK
         END IF
         IF l_flag = '3' THEN
            IF p_cmd = 'a' THEN
               CALL g_raf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t303_bcl
            ROLLBACK WORK
         END IF
      #FUN-D30033--add--end--
         EXIT DIALOG

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
              CALL cl_cmdask()

      ON ACTION CONTROLO
         IF INFIELD(raf03) AND l_ac > 1 THEN
               LET g_raf[l_ac].* = g_raf[l_ac-1].*
               LET g_raf[l_ac].raf03 = g_rec_b + 1
               NEXT FIELD raf04
         END IF
        #FUN-C30151 add START
         IF INFIELD(rak05) AND l_ac2 > 1 THEN
            LET g_rak[l_ac2].* = g_rak[l_ac2-1].*
            NEXT FIELD rak05
         END IF
        #FUN-C30151 add END

       ON ACTION controlp
          CASE
              WHEN INFIELD(rag05)
                  CALL cl_init_qry_var()
                  CASE g_rag[l_ac1].rag04
                     WHEN '01'
                 # ------------------ add -------------------- begin #add by #MOD-CC0219 add 12/12/19
                      IF p_cmd = 'a' AND NOT cl_null(g_rag[l_ac1].rag03)      
                                     AND NOT cl_null(g_rag[l_ac1].rag04) THEN 
                         CALL q_sel_ima(TRUE, "q_ima_1","",g_rag[l_ac1].rag05,"","","","","",'' )
                         RETURNING g_multi_ima01
                         IF NOT cl_null(g_multi_ima01) THEN
                            CALL t303_multi_ima01()
                            IF g_success = 'N' THEN
                               NEXT FIELD rag05
                            END IF
                            CALL t303_b2_fill(' 1=1')
                            CALL t303_b()
                            EXIT DIALOG
                         END IF
                      ELSE
                 # ------------------ add -------------------- end by #MOD-CC0219 add 12/12/19                     
                           CALL q_sel_ima(FALSE, "q_ima_1","",g_rag[l_ac1].rag05,"","","","","",'' )
                             RETURNING g_rag[l_ac1].rag05
                      END IF #MOD-CC0219       
                     WHEN '02'
                        LET g_qryparam.form ="q_oba01"
                     WHEN '03'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '1'
                     WHEN '04'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '2'
                     WHEN '05'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '3'
                     WHEN '06'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '4'
                     WHEN '07'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '5'
                     WHEN '08'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '6'
                     WHEN '09'
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '27'
                  END CASE
                  IF g_rag[l_ac1].rag04 != '01' THEN
                     LET g_qryparam.default1 = g_rag[l_ac1].rag05
                     CALL cl_create_qry() RETURNING g_rag[l_ac1].rag05
                  END IF
                  CALL t303_rag05('d',l_ac1)
                  NEXT FIELD rag05
               WHEN INFIELD(rag06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe02"
                  SELECT DISTINCT ima25
                       INTO l_ima25
                      FROM ima_file
                     WHERE ima01=g_rag[l_ac1].rag05
                  LET g_qryparam.arg1 = l_ima25
                  LET g_qryparam.default1 = g_rag[l_ac1].rag06
                  CALL cl_create_qry() RETURNING g_rag[l_ac1].rag06
                  CALL t303_rag06('d')
                  NEXT FIELD rag06
               OTHERWISE EXIT CASE
             END CASE

    END DIALOG
    CLOSE t303_bcl
    CLOSE t3031_bcl
    CLOSE t3032_bcl 
    COMMIT WORK
    CALL t303_delall()
    CALL t303_b1_fill(g_wc1)
    CALL t303_b2_fill(g_wc2)
    CALL t303_b3_fill(g_wc3)

END FUNCTION
#FUN-BB0058 add END 
#FUN-BB0058 mark START
#FUNCTION t303_b1()
#DEFINE
#   l_ac_t          LIKE type_file.num5,
#   l_n             LIKE type_file.num5,
#   l_n1            LIKE type_file.num5,
#   l_n2            LIKE type_file.num5,
#   l_n3            LIKE type_file.num5,
#   l_cnt           LIKE type_file.num5,
#   l_lock_sw       LIKE type_file.chr1,
#   p_cmd           LIKE type_file.chr1,
#   l_misc          LIKE gef_file.gef01,
#   l_allow_insert  LIKE type_file.num5,
#   l_allow_delete  LIKE type_file.num5,
#   l_pmc05         LIKE pmc_file.pmc05,
#   l_pmc30         LIKE pmc_file.pmc30
#
#DEFINE l_ima02    LIKE ima_file.ima02,
#      l_ima44    LIKE ima_file.ima44,
#      l_ima021   LIKE ima_file.ima021,
#      l_imaacti  LIKE ima_file.imaacti
#DEFINE  l_s      LIKE type_file.chr1000 
#DEFINE  l_m      LIKE type_file.chr1000 
#DEFINE  i        LIKE type_file.num5
#DEFINE  l_s1     LIKE type_file.chr1000 
#DEFINE  l_m1     LIKE type_file.chr1000 
#DEFINE l_rtz04   LIKE rtz_file.rtz04
#DEFINE l_azp03   LIKE azp_file.azp03
#DEFINE l_line    LIKE type_file.num5
#DEFINE l_sql1    STRING
#DEFINE l_bamt    LIKE type_file.num5
#DEFINE l_rxx04   LIKE rxx_file.rxx04
#DEFINE l_raf05_n LIKE type_file.num5    #TQC-B60071 ADD
# 
#   LET g_action_choice = ""
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_rae.rae02 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * INTO g_rae.* FROM rae_file
#    WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
#      AND raeplant = g_rae.raeplant
#
#   IF g_rae.raeacti ='N' THEN
#      CALL cl_err(g_rae.rae01||g_rae.rae02,'mfg1000',0)
#      RETURN
#   END IF
#   
#   IF g_rae.raeconf = 'Y' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   IF g_rae.raeconf = 'X' THEN                                                                                             
#      CALL cl_err('','art-025',0)                                                                                          
#      RETURN                                                                                                               
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rae.rae01 <> g_rae.raeplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   CALL cl_opmsg('b')
#  #CALL s_showmsg_init()
#
#   LET g_forupd_sql = "SELECT raf03,raf04,raf05,rafacti ",
#                      "  FROM raf_file ",
#                      " WHERE raf01 = ? AND raf02=? AND raf03=? AND rafplant = ? ",
#                      " FOR UPDATE   "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t303_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#   LET l_line = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#
#   INPUT ARRAY g_raf WITHOUT DEFAULTS FROM s_raf.*
#         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#                   APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#          DISPLAY "BEFORE INPUT!"
#          IF g_rec_b != 0 THEN
#             CALL fgl_set_arr_curr(l_ac)
#          END IF
#
#       BEFORE ROW
#          DISPLAY "BEFORE ROW!"
#          LET p_cmd = ''
#          LET l_ac = ARR_CURR()
#          LET l_lock_sw = 'N'            #DEFAULT
#          LET l_n  = ARR_COUNT()
#
#          BEGIN WORK
#
#          OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t303_cl:", STATUS, 1)
#             CLOSE t303_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          FETCH t303_cl INTO g_rae.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
#             CLOSE t303_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b >= l_ac THEN
#             LET p_cmd='u'
#             LET g_raf_t.* = g_raf[l_ac].*  #BACKUP
#             LET g_raf_o.* = g_raf[l_ac].*  #BACKUP
#             IF p_cmd='u' THEN
#                CALL cl_set_comp_entry("raf03",FALSE)
#             ELSE
#                CALL cl_set_comp_entry("raf03",TRUE)
#             END IF   
#             OPEN t303_bcl USING g_rae.rae01,g_rae.rae02,g_raf_t.raf03,g_rae.raeplant
#             IF STATUS THEN
#                CALL cl_err("OPEN t303_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#                FETCH t303_bcl INTO g_raf[l_ac].*
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_raf_t.raf03,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#             END IF
#          END IF 
#          CALL t303_raf05_entry(g_raf[l_ac].raf04)

#       BEFORE INSERT
#          DISPLAY "BEFORE INSERT!"
#          LET l_n = ARR_COUNT()
#          LET p_cmd='a'
#          INITIALIZE g_raf[l_ac].* TO NULL
#          LET g_raf[l_ac].raf04 = '1'      #參與方式 1:必選 2:可選
#          LET g_raf[l_ac].raf05 = 0        #數量
#          LET g_raf[l_ac].rafacti = 'Y'    

#          LET g_raf_t.* = g_raf[l_ac].*
#          LET g_raf_o.* = g_raf[l_ac].*
#          IF p_cmd='u' THEN  
#             CALL cl_set_comp_entry("raf03",FALSE)
#          ELSE
#             CALL cl_set_comp_entry("raf03",TRUE)
#          END IF   
#          #TQC-AC0193 add begin-----------
#          IF NOT cl_null(g_rae.rae21) THEN
#             CALL cl_set_comp_entry("raf04",TRUE)
#          ELSE
#             CALL cl_set_comp_entry("raf04",FALSE)         
#          END IF
#          #TQC-AC0193 add end-------------
#          CALL cl_set_comp_entry('raf05',TRUE)    
#          CALL t303_raf05_entry(g_raf[l_ac].raf04)
#          CALL cl_show_fld_cont()
#          NEXT FIELD raf03
#
#       AFTER INSERT
#          DISPLAY "AFTER INSERT!"
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             CANCEL INSERT
#          END IF
#TQC-A80132 --add
#             IF g_raf[l_ac].raf04='1' THEN    #TQC-A90023   --add
#                IF g_raf[l_ac].raf05 <= 0 THEN
#                   CALL cl_err('','aem-042',0)
#                   NEXT FIELD raf05
#                END IF    #TQC-A90023 --add
#             END IF
#TQC-A80132 --end
#          
#          INSERT INTO raf_file(raf01,raf02,raf03,raf04,raf05,rafacti,rafplant,raflegal)   
#          VALUES(g_rae.rae01,g_rae.rae02,
#                 g_raf[l_ac].raf03,g_raf[l_ac].raf04,
#                 g_raf[l_ac].raf05,g_raf[l_ac].rafacti,
#                 g_rae.raeplant,g_rae.raelegal)   
#                
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err3("ins","raf_file",g_rae.rae02,g_raf[l_ac].raf03,SQLCA.sqlcode,"","",1)
#             CANCEL INSERT
#          ELSE
#             MESSAGE 'INSERT O.K'
#             IF p_cmd='u' THEN
#                CALL t303_upd_log()
#             END IF
#             COMMIT WORK
#             LET g_rec_b=g_rec_b+1
#             DISPLAY g_rec_b TO FORMONLY.cn2
#          END IF
#
#       BEFORE FIELD raf03
#          IF g_raf[l_ac].raf03 IS NULL OR g_raf[l_ac].raf03 = 0 THEN
#             SELECT max(raf03)+1
#               INTO g_raf[l_ac].raf03
#               FROM raf_file
#              WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
#                AND rafplant = g_rae.raeplant
#             IF g_raf[l_ac].raf03 IS NULL THEN
#                LET g_raf[l_ac].raf03 = 1
#             END IF
#          END IF
#
#       AFTER FIELD raf03
#          IF NOT cl_null(g_raf[l_ac].raf03) THEN
#             IF g_raf[l_ac].raf03 != g_raf_t.raf03
#                OR g_raf_t.raf03 IS NULL THEN
#                SELECT count(*)
#                  INTO l_n
#                  FROM raf_file
#                 WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
#                   AND raf03 = g_raf[l_ac].raf03 AND rafplant = g_rae.raeplant
#                IF l_n > 0 THEN
#                   CALL cl_err('',-239,0)
#                   LET g_raf[l_ac].raf03 = g_raf_t.raf03
#                   NEXT FIELD raf02
#                END IF
#             END IF
#          END IF
#
#     BEFORE FIELD raf04
#        IF NOT cl_null(g_rae.rae21) AND g_rae.rae21<>0 THEN
#           CALL cl_set_comp_entry("raf04",TRUE)
#        ELSE
#           LET g_raf[l_ac].raf04='1'
#           CALL cl_set_comp_entry("raf04",FALSE)
#        END IF

#     AFTER FIELD raf04
#        IF NOT cl_null(g_raf[l_ac].raf04) THEN
#           IF g_raf_o.raf04 IS NULL OR
#              (g_raf[l_ac].raf04 != g_raf_o.raf04 ) THEN
#              IF g_raf[l_ac].raf04 NOT MATCHES '[12]' THEN
#                 LET g_raf[l_ac].raf04= g_raf_o.raf04
#                 NEXT FIELD raf04
#              ELSE
#        #TQC-B60071 ADD BEGIN ---------------------------
#                 IF NOT cl_null(g_rae.rae21) AND g_rae.rae21 > 0 THEN
#                    LET l_raf05_n = 0
#                    SELECT SUM(raf05) INTO l_raf05_n FROM raf_file 
#                     WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
#                       AND rafplant = g_rae.raeplant AND rafacti = 'Y'
#                    IF l_raf05_n = g_rae.rae21 AND g_raf[l_ac].raf04 = '2' THEN
#                       CALL cl_err('','art-729',0)
#                       NEXT FIELD raf04
#                    END IF
#                 END IF
#        #TQC-B60071 ADD  END  ---------------------------
#                 CALL t303_raf05_entry(g_raf[l_ac].raf04)
#              END IF
#           END IF
#        END IF

#     ON CHANGE raf04
#        IF NOT cl_null(g_raf[l_ac].raf04) THEN
#  #TQC-B60071 ADD BEGIN ---------------------------
#           IF NOT cl_null(g_rae.rae21) AND g_rae.rae21 > 0 THEN
#              LET l_raf05_n = 0
#              SELECT SUM(raf05) INTO l_raf05_n FROM raf_file 
#               WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
#                 AND rafplant = g_rae.raeplant AND rafacti = 'Y'
#              IF l_raf05_n = g_rae.rae21 AND g_raf[l_ac].raf04 = '2' THEN
#                 CALL cl_err('','art-729',0)
#                 NEXT FIELD raf04
#              END IF
#           END IF
#  #TQC-B60071 ADD  END  ---------------------------
#           CALL t303_raf05_entry(g_raf[l_ac].raf04)
#        END IF         

#     BEFORE FIELD raf05
#        IF NOT cl_null(g_raf[l_ac].raf04) THEN
#           CALL t303_raf05_entry(g_raf[l_ac].raf04)
#        END IF

#     AFTER FIELD raf05      
#        IF NOT cl_null(g_raf[l_ac].raf05) THEN
#           IF g_raf_o.raf05=0 OR
#              (g_raf[l_ac].raf05 != g_raf_o.raf05 ) THEN
#              CALL t303_raf05_check(g_raf[l_ac].raf05)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('raf05',g_errno,0)
#                 LET g_raf[l_ac].raf05= g_raf_o.raf05
#                 NEXT FIELD raf05
#              ELSE
#                 DISPLAY BY NAME g_raf[l_ac].raf05
#              END IF 
#           END IF 
#        END IF 


#       
#       BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_raf_t.raf03 > 0 AND g_raf_t.raf03 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             SELECT COUNT(*) INTO l_n FROM rag_file
#              WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
#                AND rag03=g_raf_t.raf03 AND ragplant=g_rae.raeplant
#             IF l_n>0 THEN
#                CALL cl_err(g_raf_t.raf03,'art-664',0) 
#                CANCEL DELETE
#             ELSE
#                SELECT COUNT(*) INTO l_n FROM rap_file
#                 WHERE rap01=g_rae.rae01 AND rap02=g_rae.rae02 AND rap03='2'
#                   AND rap03=g_raf_t.raf03 AND rapplant=g_rae.raeplant
#                IF l_n>0 THEN
#                   CALL cl_err(g_raf_t.raf03,'art-665',0)
#                   CANCEL DELETE
#                END IF  
#             END IF  
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM raf_file
#              WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
#                AND raf03 = g_raf_t.raf03  AND rafplant = g_rae.raeplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","raf_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1) 
#                ROLLBACK WORK
#                CANCEL DELETE
#             ELSE
#                # FUN-B80085增加空白行  

#              	 DELETE FROM rag_file 
#              	  WHERE rag01 = g_rae.rae01   AND rag02 = g_rae.rae02
#                   AND rag03 = g_raf_t.raf03 AND ragplant = g_rae.raeplant
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err3("del","rag_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1) 
#                   ROLLBACK WORK
#                   CANCEL DELETE
#                END IF 
#             END IF
#             CALL t303_upd_log() 
#             LET g_rec_b=g_rec_b-1
#             DISPLAY g_rec_b TO FORMONLY.cn2
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_raf[l_ac].* = g_raf_t.*
#             CLOSE t303_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_raf[l_ac].raf04) THEN
#             NEXT FIELD raf04
#          END IF
#             
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_raf[l_ac].raf03,-263,1)
#             LET g_raf[l_ac].* = g_raf_t.*
#          ELSE
#             UPDATE raf_file SET raf04  =g_raf[l_ac].raf04,
#                                 raf05  =g_raf[l_ac].raf05,
#                                 rafacti=g_raf[l_ac].rafacti
#              WHERE raf02 = g_rae.rae02 AND raf01=g_rae.rae01
#                AND raf03=g_raf_t.raf03 AND rafplant = g_rae.raeplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","raf_file",g_rae.rae02,g_raf_t.raf03,SQLCA.sqlcode,"","",1) 
#                LET g_raf[l_ac].* = g_raf_t.*
#             ELSE
#                MESSAGE 'UPDATE raf_file O.K'
#                CALL t303_upd_log() 
#                COMMIT WORK
#             END IF
#          END IF
#
#       AFTER ROW
#          DISPLAY  "AFTER ROW!!"
#          LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_raf[l_ac].* = g_raf_t.*
#             END IF
#             CLOSE t303_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#TQC-A80132 --add
#          ELSE
#             IF g_raf[l_ac].raf04='1' THEN   #TQC-A90023 --ADD
#               IF g_raf[l_ac].raf05 <= 0 THEN
#                  CALL cl_err('','aem-042',0)
#                  NEXT FIELD raf05
#               END IF
#             END IF #TQC-A90023 --ADD
#TQC-A80132 --end
#          END IF
#         #CALL t303_repeat(g_raf[l_ac].raf03)  #check
#          CLOSE t303_bcl
#          COMMIT WORK

#       #MOD-AC0172 add --begin---------------------------
#       AFTER INPUT
#          IF NOT cl_null(g_rae.rae02) THEN
#             IF g_rae.rae12 = 'Y' THEN
#                 CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10)   #FUN-BB0058 mark
#               CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10,'')  #FUN-BB0058 add
#             END IF
#          ELSE
#             CALL cl_err('',-400,0)
#          END IF
#       #MOD-AC0172 add ---end----------------------------
#       #TQC-B60071 ADD -- BEGIN ---------------------------
#          CALL t303_upd_rae21()
#       #TQC-B60071 ADD --  END  ---------------------------

#     #MOD-AC0172 mark begin-------------------
#     #ON ACTION Memberlevel    #會員等級促銷
#     #  #IF cl_chk_act_auth() THEN
#     #  IF NOT cl_null(g_rae.rae02) THEN
#     #     CALl t302_2(g_rae.rae01,g_rae.rae02,'2',g_rae.raeplant,g_rae.raeconf,g_rae.rae10)
#     #  ELSE
#     #     CALL cl_err('',-400,0)
#     #  END IF
#     #  #END IF
#     #MOD-AC0172 mark  end-------------------

#     ON ACTION CONTROLO
#        IF INFIELD(raf03) AND l_ac > 1 THEN
#           LET g_raf[l_ac].* = g_raf[l_ac-1].*
#           LET g_raf[l_ac].raf03 = g_rec_b + 1
#           NEXT FIELD raf04
#        END IF
#
#     ON ACTION CONTROLR
#        CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION HELP
#        CALL cl_show_help()
#
#     ON ACTION controls         
#        CALL cl_set_head_visible("","AUTO")
#           
#   END INPUT
#   
#   CLOSE t303_bcl
#   COMMIT WORK
#  #CALL s_showmsg()
#   CALL t303_delall()
#
#END FUNCTION
#FUN-BB0058 mark END
FUNCTION t303_upd_log()
   LET g_rae.raemodu = g_user
   LET g_rae.raedate = g_today
   UPDATE rae_file SET raemodu = g_rae.raemodu,
                       raedate = g_rae.raedate
    WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
      AND raeplant = g_rae.raeplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rae_file",g_rae.raemodu,g_rae.raedate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rae.raemodu,g_rae.raedate
   MESSAGE 'UPDATE rae_file O.K.'
END FUNCTION

FUNCTION t303_chktime(p_time)  #check 時間格式
DEFINE p_time LIKE type_file.chr5
DEFINE l_hour LIKE type_file.num5
DEFINE l_min  LIKE type_file.num5
 
      LET g_errno=''
      IF p_time[1,1] MATCHES '[012]' AND
         p_time[2,2] MATCHES '[0123456789]' AND
         p_time[3,3] =':' AND
         p_time[4,4] MATCHES '[012345]' AND 
         p_time[5,5] MATCHES '[0123456789]' THEN
         IF p_time[1,2]<'00' OR p_time[1,2]>='24' OR
            p_time[4,5]<'00' OR p_time[4,5]>='60' THEN
            LET g_errno='art-209' 
         END IF
      ELSE
         LET g_errno='art-209'
      END IF
      IF cl_null(g_errno) THEN         
         LET l_hour=p_time[1,2]
         LET l_min = p_time[4,5]
         RETURN l_hour*60+l_min
      ELSE
         RETURN NULL
      END IF
END FUNCTION


FUNCTION t303_raf05_check(p_raf05)
DEFINE p_raf05    LIKE raf_file.raf05
DEFINE l_sum      LIKE raf_file.raf05

   LET g_errno=' '
   IF g_raf[l_ac].raf04='1' THEN
      IF p_raf05<=0 THEN
         LET g_errno='aem-042'
         RETURN
      END IF
   END IF
   IF NOT cl_null(g_rae.rae21) AND g_rae.rae21<>0 THEN
      IF p_raf05>g_rae.rae21 THEN
         LET g_errno='art-657'
         RETURN
      ELSE
         SELECT SUM(raf05) INTO l_sum FROM raf_file
          WHERE raf01 = g_rae.rae01
            AND raf02 = g_rae.rae02
            AND rafplant = g_rae.raeplant 
            AND rafacti  = 'Y'
         LET l_sum=l_sum+p_raf05-g_raf_o.raf05
         IF g_rae.rae21<l_sum THEN
            LET g_errno='art-657'
            RETURN
         END IF
      END IF
   END IF 


END FUNCTION

FUNCTION t303_rae21_check()
DEFINE l_sum      LIKE rae_file.rae21

   LET g_errno=' '
   IF NOT cl_null(g_rae.rae21) AND g_rae.rae21<>0 THEN
      SELECT SUM(raf05) INTO l_sum FROM raf_file
       WHERE raf01 = g_rae.rae01
         AND raf02 = g_rae.rae02
         AND rafplant = g_rae.raeplant 
         AND rafacti  = 'Y'
      IF g_rae.rae21<l_sum THEN
         LET g_errno='art-657'
         RETURN
      END IF
   END IF 


END FUNCTION


FUNCTION t303_raf05_entry(p_raf04)
DEFINE p_raf04    LIKE raf_file.raf04   

   IF p_raf04='1' THEN
      CALL cl_set_comp_entry("raf05",TRUE)
      CALL cl_set_comp_required("raf05",TRUE)
      LET g_raf[l_ac].raf05=g_raf_o.raf05
      DISPLAY BY NAME g_raf[l_ac].raf05
   ELSE 
      CALL cl_set_comp_entry("raf05",FALSE)   
     #mark START
     #LET g_raf[l_ac].raf05=0
     #DISPLAY BY NAME g_raf[l_ac].raf05
     #mark END
   END IF

END FUNCTION

FUNCTION t303_rae10_entry(p_rae10)
DEFINE p_rae10    LIKE rae_file.rae10   

   CASE p_rae10
      WHEN '1'
         CALL cl_set_comp_visible("rae15",TRUE)      #TQC-A80160
         CALL cl_set_comp_entry("rae15",TRUE)
         CALL cl_set_comp_entry("rae16",FALSE)
         CALL cl_set_comp_entry("rae17",FALSE)
         CALL cl_set_comp_required("rae15",TRUE)
         LET g_rae.rae15 = g_rae_o.rae15  #特賣價
         #MOD-CA0199 add start -----
         IF cl_null(g_rae.rae15) THEN
            LET g_rae.rae15 = 0
         END IF
         #MOD-CA0199 add end   -----
         LET g_rae.rae17 = 0              #折讓額
         #TQC-AC0193 add begin-------------------
         LET g_rae.rae16 = 0 
         LET g_rae.rae17 = 0
         #TQC-AC0193 add end----------------------
      WHEN '2'
         CALL cl_set_comp_entry("rae15",FALSE)
         CALL cl_set_comp_entry("rae16",TRUE)
         CALL cl_set_comp_entry("rae17",FALSE)
         CALL cl_set_comp_required("rae16",TRUE)
         LET g_rae.rae15 = 0              #特賣價
         LET g_rae.rae17 = 0              #折讓額
         #TQC-AC0193 add begin-------------------
         LET g_rae.rae15 = 0
         LET g_rae.rae17 = 0
         #TQC-AC0193 add end----------------------
      WHEN '3'
         CALL cl_set_comp_entry("rae15",FALSE)
         CALL cl_set_comp_entry("rae16",FALSE)
         CALL cl_set_comp_entry("rae17",TRUE)
         CALL cl_set_comp_required("rae17",TRUE)
         LET g_rae.rae15 = 0              #特賣價
         LET g_rae.rae17 = g_rae_o.rae17  #折讓額
         #MOD-CA0199 add start -----
         IF cl_null(g_rae.rae17) THEN
            LET g_rae.rae17 = 0
         END IF
         #MOD-CA0199 add end   -----
         #TQC-AC0193 add begin-------------------
         LET g_rae.rae15 = 0
         LET g_rae.rae16 = 0
         #TQC-AC0193 add end----------------------
      OTHERWISE
         CALL cl_set_comp_entry("rae15",TRUE)
         CALL cl_set_comp_entry("rae16",TRUE)
         CALL cl_set_comp_entry("rae17",TRUE)
         CALL cl_set_comp_required("rae15",TRUE)
         CALL cl_set_comp_required("rae16",TRUE)
         CALL cl_set_comp_required("rae17",TRUE)
         LET g_rae.rae15 = g_rae_o.rae15  #特賣價
         LET g_rae.rae17 = g_rae_o.rae17  #折讓額
         #MOD-CA0199 add start -----
         IF cl_null(g_rae.rae15) THEN
            LET g_rae.rae15 = 0
         END IF
         IF cl_null(g_rae.rae17) THEN
            LET g_rae.rae17 = 0
         END IF
         #MOD-CA0199 add end   -----
   END CASE
    
  #IF g_rae.rae12='Y' THEN   #FUN-BB0059 mark
   IF g_rae.rae12 <> '0' THEN  #FUN-BB0059 add
      CALL cl_set_comp_entry("rae18,rae19,rae20",FALSE)
      LET g_rae.rae18 = 0              #會員特賣價 
      LET g_rae.rae19 = 0              #FUN-C10008 add 
      LET g_rae.rae20 = 0              #會員折讓額      
      DISPLAY BY NAME g_rae.rae18, g_rae.rae19,g_rae.rae20  #FUN-C10008 add
   ELSE
      CASE p_rae10
         WHEN '1'
            CALL cl_set_comp_entry("rae18",TRUE)
            CALL cl_set_comp_entry("rae19",FALSE)
            CALL cl_set_comp_entry("rae20",FALSE)
            CALL cl_set_comp_required("rae18",TRUE)
            LET g_rae.rae18 = g_rae_o.rae18  #會員特賣價
            LET g_rae.rae20 = 0              #會員折讓額      
            #TQC-AC0193 add begin-------------------
            LET g_rae.rae19 = 0
            LET g_rae.rae20 = 0
            #TQC-AC0193 add end----------------------
         WHEN '2'
            CALL cl_set_comp_entry("rae18",FALSE)
            CALL cl_set_comp_entry("rae19",TRUE)
            CALL cl_set_comp_entry("rae20",FALSE)
            CALL cl_set_comp_required("rae19",TRUE)
            LET g_rae.rae18 = 0              #會員特賣價
            LET g_rae.rae20 = 0              #會員折讓額      
            #TQC-AC0193 add begin-------------------
            LET g_rae.rae18 = 0
            LET g_rae.rae20 = 0
            #TQC-AC0193 add end----------------------
         WHEN '3'
            CALL cl_set_comp_entry("rae18",FALSE)
            CALL cl_set_comp_entry("rae19",FALSE)
            CALL cl_set_comp_entry("rae20",TRUE)
            CALL cl_set_comp_required("rae20",TRUE)
            LET g_rae.rae18 = 0              #會員特賣價
            LET g_rae.rae20 = g_rae_o.rae20  #會員折讓額      
            #TQC-AC0193 add begin-------------------
            LET g_rae.rae19 = 0
            LET g_rae.rae18 = 0
            #TQC-AC0193 add end----------------------
         OTHERWISE
            CALL cl_set_comp_entry("rae18",TRUE)
            CALL cl_set_comp_entry("rae19",TRUE)
            CALL cl_set_comp_entry("rae20",TRUE)
            CALL cl_set_comp_required("rae18",TRUE)
            CALL cl_set_comp_required("rae19",TRUE)
            CALL cl_set_comp_required("rae20",TRUE)
            LET g_rae.rae18 = g_rae_o.rae18  #會員特賣價
            LET g_rae.rae20 = g_rae_o.rae20  #會員折讓額      
      END CASE
   END IF

           
END FUNCTION

FUNCTION t303_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM raf_file
    WHERE raf02 = g_rae.rae02 AND raf01 = g_rae.rae01
      AND rafplant = g_rae.raeplant
  #FUN-C10008 add START
   IF g_cnt > 0 THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM rak_file
    WHERE rak01 = g_rae.rae01 AND rak02 = g_rae.rae02
      AND rakplant = g_rae.raeplant
      AND rak03 = '2'
   IF g_cnt > 0 THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM rag_file
    WHERE rag01 = g_rae.rae01 AND rag02 = g_rae.rae02
      AND ragplant = g_rae.raeplant 
   IF g_cnt > 0 THEN RETURN END IF
  #FUN-C10008 add END 
  #IF g_cnt = 0 THEN  #FUN-C10008 mark
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rae_file WHERE rae01 = g_rae.rae01 AND rae02=g_rae.rae02 AND raeplant=g_rae.raeplant
      DELETE FROM raq_file WHERE raq01 = g_rae.rae01 AND raq02=g_rae.rae02 
                             AND raq03='2' AND raqplant=g_rae.raeplant
      DELETE FROM rak_file WHERE rak01 = g_rae.rae01  AND rak02 = g_rae.rae02 AND rakplant = g_rae.raeplant  #FUN-BB0058 add
                             AND rak03 = '2'                                                                 #FUN-BB0058 add 
      DELETE FROM rap_file WHERE rap01 = g_rae.rae01 AND rap02 = g_rae.rae02 AND rapplant = g_rae.raeplant   #FUN-BB0058 add
      CALL g_raf.clear()
      CALL g_rak.clear()   #FUN-BB0058 add
      CALL g_rag.clear()   #FUN-BB0058 add
  #END IF  #FUN-C10008 mark
END FUNCTION

#FUN-BB0058 mark START
#FUNCTION t303_b2()
#DEFINE
#   l_ac1_t         LIKE type_file.num5,
#   l_cnt           LIKE type_file.num5,
#   l_n             LIKE type_file.num5,
#   l_lock_sw       LIKE type_file.chr1,
#   p_cmd           LIKE type_file.chr1,
#   l_allow_insert  LIKE type_file.num5,
#   l_allow_delete  LIKE type_file.num5
#DEFINE l_ima25      LIKE ima_file.ima25
#
#   LET g_action_choice = ""
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_rae.rae02 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * INTO g_rae.* FROM rae_file
#    WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
#      AND raeplant = g_rae.raeplant
#
#   IF g_rae.raeacti ='N' THEN
#      CALL cl_err(g_rae.rae01,'mfg1000',0)
#      RETURN
#   END IF
#   
#   IF g_rae.raeconf = 'Y' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   IF g_rae.raeconf = 'X' THEN                                                                                             
#      CALL cl_err('','art-025',0)                                                                                          
#      RETURN                                                                                                               
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rae.rae01 <> g_rae.raeplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   CALL t303_temptable("1")  #FUN-A80104

#   CALL cl_opmsg('b')
#  #CALL s_showmsg_init()

#  #CALL cl_set_comp_visible("rag11,rag12",FALSE)
# 
#   LET g_forupd_sql = "SELECT rag03,rag04,rag05,'',rag06,'',ragacti", 
#                      "  FROM rag_file ",
#                      " WHERE rag01=? AND rag02=? AND rag03=? AND rag04=? ",
#                      "   AND rag05=? AND rag06=? AND ragplant = ? ",
#                      " FOR UPDATE   "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t3031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#
#   INPUT ARRAY g_rag WITHOUT DEFAULTS FROM s_rag.*
#         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#                   APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#          DISPLAY "BEFORE INPUT!"
#          IF g_rec_b1 != 0 THEN
#             CALL fgl_set_arr_curr(l_ac1)
#          END IF
#
#       BEFORE ROW
#          DISPLAY "BEFORE ROW!"
#          LET p_cmd = ''
#          LET l_ac1 = ARR_CURR()
#          LET l_lock_sw = 'N'            #DEFAULT
#          LET l_n  = ARR_COUNT()
#         #CALL t303_rag04_chk()
#
#          BEGIN WORK
#
#          OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t303_cl:", STATUS, 1)
#             CLOSE t303_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          FETCH t303_cl INTO g_rae.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rae.rae01,SQLCA.sqlcode,0)
#             CLOSE t303_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b1 >= l_ac1 THEN
#             LET p_cmd='u'
#             LET g_rag_t.* = g_rag[l_ac1].*  #BACKUP
#             LET g_rag_o.* = g_rag[l_ac1].*  #BACKUP
#             OPEN t3031_bcl USING g_rae.rae01,g_rae.rae02,g_rag_t.rag03,g_rag_t.rag04,
#                                  g_rag_t.rag05,g_rag_t.rag06,g_rae.raeplant
#             IF STATUS THEN
#                CALL cl_err("OPEN t3031_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#                FETCH t3031_bcl INTO g_rag[l_ac1].*
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rag_t.rag03,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#                CALL t303_rag05('d',l_ac1)
#                CALL t303_rag06('d')
#             END IF
#         END IF 
#          
#       BEFORE INSERT
#          DISPLAY "BEFORE INSERT!"
#          LET l_n = ARR_COUNT()
#          LET p_cmd='a'
#          INITIALIZE g_rag[l_ac1].* TO NULL
#         #SELECT MIN(raf03) INTO g_rag[l_ac1].rag03 FROM raf_file
#         # WHERE raf01=g_rae.rae01 AND raf02=g_rae.rae02 AND rafplant=g_rae.raeplant

#          #LET g_rag[l_ac1].rag04 = '1'            #Body default
#          LET g_rag[l_ac1].rag04 = '01'     #FUN-A80104
#          LET g_rag[l_ac1].ragacti = 'Y'            #Body default
#          LET g_rag_t.* = g_rag[l_ac1].*
#          LET g_rag_o.* = g_rag[l_ac1].*

#TQC-A80132 --add
#          IF cl_null(g_rag[l_ac1].rag06) THEN
#             LET g_rag[l_ac1].rag06 = ' '
#          END IF
#TQC-A80132 --end

#          CALL cl_show_fld_cont()
#          NEXT FIELD rag03
#
#       AFTER INSERT
#          DISPLAY "AFTER INSERT!"
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             CANCEL INSERT
#          END IF
#          #FUN-AB0033 add -------------start--------------
#          IF cl_null(g_rag[l_ac1].rag06) THEN
#             LET g_rag[l_ac1].rag06 = ' '  
#          END IF          
#          IF cl_null(g_rag[l_ac1].rag06_desc) THEN
#             LET g_rag[l_ac1].rag06_desc = ' '   
#          END IF   
#          #FUN-AB0033 add --------------end---------------
#          SELECT COUNT(*) INTO l_n FROM rag_file
#           WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
#             AND ragplant=g_rae.raeplant
#             AND rag03=g_rag[l_ac1].rag03 
#             AND rag04=g_rag[l_ac1].rag04 
#             AND rag05=g_rag[l_ac1].rag05 
#             AND rag06=g_rag[l_ac1].rag06
#          IF l_n>0 THEN 
#             CALL cl_err('',-239,0)
#             LET g_rag[l_ac1].* = g_rag_t.*
#             NEXT FIELD rag03
#          END IF
#          INSERT INTO rag_file(rag01,rag02,rag03,rag04,rag05,rag06,
#                               ragacti,ragplant,raglegal)   
#          VALUES(g_rae.rae01,g_rae.rae02,
#                 g_rag[l_ac1].rag03,g_rag[l_ac1].rag04,
#                 g_rag[l_ac1].rag05,g_rag[l_ac1].rag06,
#                 g_rag[l_ac1].ragacti,
#                 g_rae.raeplant,g_rae.raelegal)   
#                
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err3("ins","rag_file",g_rae.rae01,g_rag[l_ac1].rag03,SQLCA.sqlcode,"","",1)
#             ROLLBACK WORK
#             CANCEL INSERT
#          ELSE
#             CALL s_showmsg_init()
#             LET g_errno=' '
#             #CALL t303_repeat(g_rag[l_ac1].rag03)  #check #FUN-AB0033 mark
#             #CALL s_showmsg() #FUN-AB0033 mark
#             IF NOT cl_null(g_errno) THEN
#                LET g_rag[l_ac1].* = g_rag_t.*
#                ROLLBACK WORK
#                NEXT FIELD PREVIOUS
#             ELSE
#                MESSAGE 'UPDATE O.K'
#                COMMIT WORK
#                LET g_rec_b1=g_rec_b1+1
#                DISPLAY g_rec_b1 TO FORMONLY.cn2
#             END IF
#          END IF
#
#
#     AFTER FIELD rag03
#        IF NOT cl_null(g_rag[l_ac1].rag03) THEN
#           IF g_rag_o.rag03 IS NULL OR
#              (g_rag[l_ac1].rag03 != g_rag_o.rag03 ) THEN
#              CALL t303_rag03()    #檢查其有效性          
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rag[l_ac1].rag03,g_errno,0)
#                 LET g_rag[l_ac1].rag03 = g_rag_o.rag03
#                 NEXT FIELD rag03
#              END IF
#           END IF  
#        END IF 

#    #BEFORE FIELD rag04
#    #   IF NOT cl_null(g_rag[l_ac1].rag03) THEN
#    #      CALL t303_rag04_chk()
#    #   END IF

#     AFTER FIELD rag04
#        IF NOT cl_null(g_rag[l_ac1].rag04) THEN
#           IF g_rag_o.rag04 IS NULL OR
#              (g_rag[l_ac1].rag04 != g_rag_o.rag04 ) THEN
#              CALL t303_rag04() 
#              #FUN-AB0033 mark --------------start-----------------
#              #IF NOT cl_null(g_errno) THEN
#              #   CALL cl_err(g_rag[l_ac1].rag04,g_errno,0)
#              #   LET g_rag[l_ac1].rag04 = g_rag_o.rag04
#              #   NEXT FIELD rag04
#              #END IF
#              #FUN-AB0033 mark --------------start-----------------
#           END IF  
#        END IF  

#     ON CHANGE rag04
#        IF NOT cl_null(g_rag[l_ac1].rag04) THEN
#           CALL t303_rag04()   

#           LET g_rag[l_ac1].rag05=NULL
#           LET g_rag[l_ac1].rag05_desc=NULL
#           LET g_rag[l_ac1].rag06=NULL
#           LET g_rag[l_ac1].rag06_desc=NULL
#           DISPLAY BY NAME g_rag[l_ac1].rag05,g_rag[l_ac1].rag05_desc
#           DISPLAY BY NAME g_rag[l_ac1].rag06,g_rag[l_ac1].rag06_desc
#        END IF
# 
#     BEFORE FIELD rag05,rag06
#        IF NOT cl_null(g_rag[l_ac1].rag04) THEN
#           CALL t303_rag04()   
#          #IF g_rag[l_ac1].rag04='1' THEN
#          #   CALL cl_set_comp_entry("rag06",TRUE)
#          #   CALL cl_set_comp_required("rag06",TRUE)
#          #ELSE
#          #   CALL cl_set_comp_entry("rag06",FALSE)
#          #END IF
#        END IF

#     AFTER FIELD rag05
#        IF NOT cl_null(g_rag[l_ac1].rag05) THEN
#           IF g_rag[l_ac1].rag04 = '01' THEN #FUN-AB0033 add
#              #FUN-AA0059 ---------------------start--------------------
#              IF NOT s_chk_item_no(g_rag[l_ac1].rag05,"") THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_rag[l_ac1].rag05= g_rag_t.rag05
#                 NEXT FIELD rag05
#              END IF
#              #FUN-AA0059 ---------------------end----------------------
#           END IF #FUN-AB0033 add   
#           IF g_rag_o.rag05 IS NULL OR
#              (g_rag[l_ac1].rag05 != g_rag_o.rag05 ) THEN
#              CALL t303_rag05('a',l_ac1) 
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rag[l_ac1].rag05,g_errno,0)
#                 LET g_rag[l_ac1].rag05 = g_rag_o.rag05
#                 NEXT FIELD rag05
#              END IF
#           END IF  
#        END IF  

#     AFTER FIELD rag06
#        IF NOT cl_null(g_rag[l_ac1].rag06) THEN
#           IF g_rag_o.rag06 IS NULL OR
#              (g_rag[l_ac1].rag06 != g_rag_o.rag06 ) THEN
#              CALL t303_rag06('a')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rag[l_ac1].rag06,g_errno,0)
#                 LET g_rag[l_ac1].rag06 = g_rag_o.rag06
#                 NEXT FIELD rag06
#              END IF
#           END IF  
#        END IF
#       
#       
#
#       BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_rag_t.rag03 > 0 AND g_rag_t.rag03 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rag_file
#              WHERE rag02 = g_rae.rae02 AND rag01 = g_rae.rae01
#                AND rag03 = g_rag_t.rag03 AND rag04 = g_rag_t.rag04 
#                AND rag05 = g_rag_t.rag05 AND rag06 = g_rag_t.rag06 
#                AND ragplant = g_rae.raeplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rag_file",g_rae.rae02,g_rag_t.rag03,SQLCA.sqlcode,"","",1)
#                ROLLBACK WORK
#                CANCEL DELETE
#             END IF
#             LET g_rec_b1=g_rec_b1-1
#             DISPLAY g_rec_b1 TO FORMONLY.cn2
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rag[l_ac1].* = g_rag_t.*
#             CLOSE t3031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF

#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rag[l_ac1].rag03,-263,1)
#             LET g_rag[l_ac1].* = g_rag_t.*
#          ELSE
#             #Add No:TQC-B10082
#             IF cl_null(g_rag[l_ac1].rag06) THEN
#                LET g_rag[l_ac1].rag06 = ' '  
#             END IF          
#             #End Add No:TQC-B10082
#             IF g_rag[l_ac1].rag03<>g_rag_t.rag03 OR
#                g_rag[l_ac1].rag04<>g_rag_t.rag04 OR
#                g_rag[l_ac1].rag05<>g_rag_t.rag05 OR
#                g_rag[l_ac1].rag06<>g_rag_t.rag06 THEN

#                SELECT COUNT(*) INTO l_n FROM rag_file
#                 WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
#                   AND ragplant=g_rae.raeplant
#                   AND rag03=g_rag_t.rag03 
#                   AND rag04=g_rag_t.rag04 
#                   AND rag05=g_rag_t.rag05 
#                   AND rag06=g_rag_t.rag06
#                IF l_n=0 THEN 
#                   INSERT INTO rag_file(rag01,rag02,rag03,rag04,rag05,rag06,
#                                        ragacti,ragplant,raglegal)   
#                   VALUES(g_rae.rae01,g_rae.rae02,
#                          g_rag[l_ac1].rag03,g_rag[l_ac1].rag04,
#                          g_rag[l_ac1].rag05,g_rag[l_ac1].rag06,
#                          g_rag[l_ac1].ragacti,
#                          g_rae.raeplant,g_rae.raelegal)   
#                         
#                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                      CALL cl_err3("ins","rag_file",g_rae.rae01,g_rag[l_ac1].rag03,SQLCA.sqlcode,"","",1)
#                      LET g_rag[l_ac1].* = g_rag_t.*
#                      ROLLBACK WORK
#                     #NEXT FIELD PREVIOUS
#                   ELSE
#                      CALL s_showmsg_init()
#                      LET g_errno=' '
#                      #CALL t303_repeat(g_rag[l_ac1].rag03)  #check #FUN-AB0033 mark
#                      #CALL s_showmsg() #FUN-AB0033 mark
#                      IF NOT cl_null(g_errno) THEN
#                         LET g_rag[l_ac1].* = g_rag_t.*
#                         ROLLBACK WORK
#                         NEXT FIELD PREVIOUS
#                      ELSE
#                         MESSAGE 'UPDATE O.K'
#                         COMMIT WORK
#                         LET g_rec_b1=g_rec_b1+1
#                         DISPLAY g_rec_b1 TO FORMONLY.cn2
#                      END IF
#                   END IF
#                ELSE 
#                   SELECT COUNT(*) INTO l_n FROM rag_file
#                    WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
#                      AND ragplant=g_rae.raeplant
#                      AND rag03=g_rag[l_ac1].rag03 
#                      AND rag04=g_rag[l_ac1].rag04 
#                      AND rag05=g_rag[l_ac1].rag05 
#                      AND rag06=g_rag[l_ac1].rag06
#                   IF l_n>0 THEN 
#                      CALL cl_err('',-239,0)
#                     #LET g_rag[l_ac1].* = g_rag_t.*
#                      NEXT FIELD rag03
#                   END IF
#                   UPDATE rag_file SET rag03=g_rag[l_ac1].rag03,
#                                       rag04=g_rag[l_ac1].rag04,
#                                       rag05=g_rag[l_ac1].rag05,
#                                       rag06=g_rag[l_ac1].rag06,
#                                       ragacti=g_rag[l_ac1].ragacti
#                    WHERE rag02 = g_rae.rae02 AND rag01=g_rae.rae01
#                      AND rag03 = g_rag_t.rag03 AND rag04 = g_rag_t.rag04 
#                      AND rag05 = g_rag_t.rag05 AND rag06 = g_rag_t.rag06 
#                      AND ragplant = g_rae.raeplant
#                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                      CALL cl_err3("upd","rag_file",g_rae.rae02,g_rag_t.rag03,SQLCA.sqlcode,"","",1) 
#                      LET g_rag[l_ac1].* = g_rag_t.*
#                      ROLLBACK WORK 
#                   ELSE
#                      CALL s_showmsg_init()
#                      LET g_errno=' '
#                      #CALL t303_repeat(g_rag[l_ac1].rag03)  #check #FUN-AB0033 mark
#                      #CALL s_showmsg() #FUN-AB0033 mark
#                      IF NOT cl_null(g_errno) THEN
#                         LET g_rag[l_ac1].* = g_rag_t.*
#                         ROLLBACK WORK 
#                         NEXT FIELD PREVIOUS
#                      ELSE
#                         MESSAGE 'UPDATE O.K'
#                         COMMIT WORK
#                      END IF
#                   END IF
#                END IF
#             END IF
#          END IF
#
#       AFTER ROW
#          DISPLAY  "AFTER ROW!!"
#          LET l_ac1 = ARR_CURR()
#          LET l_ac1_t = l_ac1
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_rag[l_ac1].* = g_rag_t.*
#             END IF
#             CLOSE t3031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#         #CALL t303_repeat(g_rag[l_ac1].rag03)  #check
#          CLOSE t3031_bcl
#          COMMIT WORK
#
#       ON ACTION CONTROLO
#          IF INFIELD(rag03) AND l_ac1 > 1 THEN
#             LET g_rag[l_ac1].* = g_rag[l_ac1-1].*
#             NEXT FIELD rag03
#          END IF
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#
#       ON ACTION controlp
#          CASE
#             WHEN INFIELD(rag05)
#                CALL cl_init_qry_var()
#                CASE g_rag[l_ac1].rag04
#                   #WHEN '1'
#                   WHEN '01'    #FUN-A80104
#                    # IF cl_null(g_rtz05) THEN             #FUN-AB0101 mark
#FUN-AA0059---------mod------------str----------------- 
#                         #LET g_qryparam.form="q_ima"
#                         #LET g_qryparam.form="q_ima_1"     #TQC-AA0109
#                         CALL q_sel_ima(FALSE, "q_ima_1","",g_rag[l_ac1].rag05,"","","","","",'' ) 
#                           RETURNING g_rag[l_ac1].rag05  
#FUN-AA0059---------mod------------end-----------------
#                  #   ELSE                                  #FUN-AB0101 mark
#                  #      LET g_qryparam.form = "q_rtg03_1"  #FUN-AB0101 mark
#                  #      LET g_qryparam.arg1 = g_rtz05      #FUN-AB0101 mark
#                  #   END IF                                #FUN-AB0101 mark
#                   #WHEN '2'
#                   WHEN '02'    #FUN-A80104
#                      LET g_qryparam.form ="q_oba01"
#                   #WHEN '3'
#                   WHEN '03'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '1'
#                   #WHEN '4'
#                   WHEN '04'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '2'
#                   #WHEN '5'
#                   WHEN '05'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '3'
#                   #WHEN '6'
#                   WHEN '06'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '4'
#                   #WHEN '7'
#                   WHEN '07'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '5'
#                   #WHEN '8'
#                   WHEN '08'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '6'
#                   #WHEN '9'
#                   WHEN '09'    #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '27'
#                END CASE
#              # IF g_rag[l_ac1].rag04 != '01' OR (g_rag[l_ac1].rag04 = '01' AND NOT cl_null(g_rtz05)) THEN #FUN-AA0059    #FUN-AB0101 mark
#                IF g_rag[l_ac1].rag04 != '01' THEN                            #FUN-AB0101
#                   LET g_qryparam.default1 = g_rag[l_ac1].rag05
#                   CALL cl_create_qry() RETURNING g_rag[l_ac1].rag05
#                END IF                                                                                     #FUN-AA0059
#                CALL t303_rag05('d',l_ac1)
#                NEXT FIELD rag05
#             WHEN INFIELD(rag06)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_gfe02"
#                SELECT DISTINCT ima25
#                  INTO l_ima25
#                  FROM ima_file
#                 WHERE ima01=g_rag[l_ac1].rag05
#                LET g_qryparam.arg1 = l_ima25
#                LET g_qryparam.default1 = g_rag[l_ac1].rag06
#                CALL cl_create_qry() RETURNING g_rag[l_ac1].rag06
#                CALL t303_rag06('d')
#                NEXT FIELD rag06
#             OTHERWISE EXIT CASE
#           END CASE
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION HELP
#        CALL cl_show_help()
#
#     ON ACTION controls         
#        CALL cl_set_head_visible("","AUTO")
#   END INPUT
#   
#    
#   CALL t303_upd_log() 
#   
#   CLOSE t3031_bcl
#   COMMIT WORK
#  #CALL s_showmsg()
#   CALL t303_temptable("2")  #FUN-A80104
#
#END FUNCTION
#FUN-BB0058 mark END
FUNCTION t303_rag04_chk() 

#  IF g_rae.rae10='1' THEN
#     CALL cl_set_comp_entry("rag04",FALSE)
#  ELSE
#     CALL cl_set_comp_entry("rag04",TRUE)
#  END IF
END FUNCTION

FUNCTION t303_rag03() 
DEFINE l_n     LIKE type_file.num5
DEFINE l_rafacti     LIKE raf_file.rafacti

   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM raf_file
    WHERE raf03 = g_rag[l_ac1].rag03 AND raf01=g_rae.rae01
      AND raf02 = g_rae.rae02  AND rafplant=g_rae.raeplant
      AND rafacti='Y'

   IF l_n<1 THEN  
      LET g_errno = 'art-654'     #當前組別不在第一單身中
   END IF
END FUNCTION



FUNCTION t303_rag04()

   #IF g_rag[l_ac1].rag04='1' THEN
   IF g_rag[l_ac1].rag04='01' THEN      #FUN-A80104
      CALL cl_set_comp_entry("rag06",TRUE)
      CALL cl_set_comp_required("rag06",TRUE)
   ELSE
      CALL cl_set_comp_entry("rag06",FALSE)
   END IF
END FUNCTION

FUNCTION t303_rag05(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cnt       LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 

DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '
   CASE g_rag[p_cnt].rag04
      #WHEN '1'
      WHEN '01'    #FUN-A80104
       # IF cl_null(g_rtz05) THEN     #FUN-AB0101 mark
         IF cl_null(g_rtz04) THEN     #FUN-AB0101
         SELECT DISTINCT ima02,ima25,imaacti
           INTO l_ima02,l_ima25,l_imaacti
           FROM ima_file
          WHERE ima01=g_rag[p_cnt].rag05  
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_ima02=NULL
            WHEN l_imaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
         ELSE
            SELECT DISTINCT ima02,ima25,rte07
              INTO l_ima02,l_ima25,l_imaacti
              FROM ima_file,rte_file
             WHERE ima01 = rte03 AND ima01=g_rag[p_cnt].rag05
               AND rte01 = g_rtz04                        #FUN-AB0101
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                        LET l_ima02=NULL
               WHEN l_imaacti='N'       LET g_errno='9028'
               OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
            END CASE      
         END IF
      #WHEN '2'
      WHEN '02'    #FUN-A80104
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rag[p_cnt].rag05 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'    #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '4'
      WHEN '04'    #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'   #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '6'
      WHEN '06'    #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'    #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '8'
      WHEN '08'     #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'    #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rag[p_cnt].rag05 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rag[p_cnt].rag04
         #WHEN '1'
         WHEN '01'    #FUN-A80104
            LET g_rag[p_cnt].rag05_desc = l_ima02
            IF cl_null(g_rag[p_cnt].rag06) THEN
               LET g_rag[p_cnt].rag06 = l_ima25
            END IF
            SELECT gfe02 INTO g_rag[p_cnt].rag06_desc FROM gfe_file
             WHERE gfe01=g_rag[p_cnt].rag06 AND gfeacti='Y'
         #WHEN '2'
         WHEN '02'   #FUN-A80104
            LET g_rag[p_cnt].rag06 = ''
            LET g_rag[p_cnt].rag06_desc = ''
            LET g_rag[p_cnt].rag05_desc = l_oba02
         #WHEN '9'
         WHEN '09'    #FUN-A80104
            LET g_rag[p_cnt].rag06 = ''
            LET g_rag[p_cnt].rag06_desc = ''
            LET g_rag[p_cnt].rag05_desc = l_tqa02 CLIPPED,":"
            LET l_tqa02 = l_tqa05
            LET g_rag[p_cnt].rag05_desc = g_rag[p_cnt].rag05_desc CLIPPED,l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rag[p_cnt].rag05_desc = g_rag[p_cnt].rag05_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rag[p_cnt].rag06 = ''
            LET g_rag[p_cnt].rag06_desc = ''
            LET g_rag[p_cnt].rag05_desc = l_tqa02
      END CASE
            DISPLAY BY NAME g_rag[p_cnt].rag05_desc,g_rag[p_cnt].rag06,g_rag[p_cnt].rag06_desc
   END IF

END FUNCTION

FUNCTION t303_rag06(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti

DEFINE l_ima25     LIKE ima_file.ima25
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   #IF g_rag[l_ac1].rag04<>'1' THEN
   IF g_rag[l_ac1].rag04<>'01' THEN    #FUN-A80104
      RETURN
   END IF
   IF cl_null(g_rag[l_ac1].rag05) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rag[l_ac1].rag05

      CALL s_umfchk(g_rag[l_ac1].rag05,l_ima25,g_rag[l_ac1].rag06)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF

   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_rag[l_ac1].rag06 AND gfeacti = 'Y'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rag[l_ac1].rag06_desc=l_gfe02
      DISPLAY BY NAME g_rag[l_ac1].rag06_desc
   END IF    
END FUNCTION 
 

#FUNCTION t303_copy()
#   DEFINE l_newno     LIKE rae_file.rae02,
#          l_oldno     LIKE rae_file.rae02,
#          li_result   LIKE type_file.num5,
#          l_n         LIKE type_file.num5
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   IF g_rae.rae02 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   LET g_before_input_done = FALSE
#   CALL t303_set_entry('a')
# 
#   CALL cl_set_head_visible("","YES")
#   INPUT l_newno FROM rae01
#       BEFORE INPUT
#         CALL cl_set_docno_format("rae01")
#         
#       AFTER FIELD rae01
#          IF l_newno IS NULL THEN
#             NEXT FIELD rae01
#          ELSE 
#      	     CALL s_check_no("art",l_newno,"","9","rae_file","rae01","")                                                           
#                RETURNING li_result,l_newno                                                                                        
#             IF (NOT li_result) THEN                                                                                               
#                NEXT FIELD rae01                                                                                                   
#             END IF                                                                                                                
#             BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("axm",l_newno,g_today,"","rae_file","rae01",g_plant,"","")                                           
#                RETURNING li_result,l_newno  
#             IF (NOT li_result) THEN                                                                                               
#                ROLLBACK WORK                                                                                                      
#                NEXT FIELD rae01                                                                                                   
#             ELSE                                                                                                                  
#                COMMIT WORK                                                                                                        
#             END IF
#          END IF
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(rae01)                                                                                                      
#              LET g_t1=s_get_doc_no(g_rae.rae01)                                                                                    
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1                                                                 
#              LET l_newno = g_t1                                                                                                
#              DISPLAY l_newno TO rae01                                                                                           
#              NEXT FIELD rae01
#         END CASE 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#     ON ACTION about
#        CALL cl_about()
# 
#     ON ACTION HELP
#        CALL cl_show_help()
# 
#     ON ACTION controlg
#        CALL cl_cmdask()
# 
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      DISPLAY BY NAME g_rae.rae01
#      ROLLBACK WORK
#      RETURN
#   END IF
#   BEGIN WORK
# 
#   DROP TABLE y
# 
#   SELECT * FROM rae_file
#       WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
#         AND raeplant = g_rae.raeplant
#       INTO TEMP y
# 
#   UPDATE y
#       SET rae01=l_newno,
#           raeplant=g_plant, 
#           raelegal=g_legal,
#           raeconf = 'N',
#           raecond = NULL,
#           raeconu = NULL,
#           raeuser=g_user,
#           raegrup=g_grup,
#           raemodu=NULL,
#           raedate=g_today,
#           raeacti='Y',
#           raecrat=g_today ,
#           raeoriu = g_user,
#           raeorig = g_grup
#           
#   INSERT INTO rae_file SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rae_file","","",SQLCA.sqlcode,"","",1)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   DROP TABLE x
# 
#   SELECT * FROM raf_file
#       WHERE raf02 = g_rae.rae02 AND raf01=g_rae.rae01 
#         AND rafplant = g_rae.raeplant
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE x SET raf01=l_newno,
#                rafplant = g_plant,
#                raflegal = g_legal 
# 
#   INSERT INTO raf_file
#       SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","raf_file","","",SQLCA.sqlcode,"","",1) 
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF 
#    
#   DROP TABLE z
# 
#   SELECT * FROM rag_file
#       WHERE rag02 = g_rae.rae02 AND rag01=g_rae.rae01 
#         AND ragplant = g_rae.raeplant
#       INTO TEMP z
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE z SET rag01=l_newno,
#                ragplant = g_plant,
#                raglegal = g_legal 
# 
#   INSERT INTO rag_file
#       SELECT * FROM z   
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","rag_file","","",SQLCA.sqlcode,"","",1)  
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF    
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#   LET l_oldno = g_rae.rae01
#   SELECT rae_file.* INTO g_rae.* FROM rae_file 
#      WHERE rae02=g_rae.rae02 AND rae01 = l_newno
#        AND raeplant = g_rae.raeplant
#   CALL t303_u()
#   CALL t303_b1()
#   SELECT rae_file.* INTO g_rae.* FROM rae_file 
#       WHERE rae02=g_rae.rae02 AND rae01 = l_oldno 
#         AND raeplant = g_rae.raeplant
#
#   CALL t303_show()
# 
#END FUNCTION
 
FUNCTION t303_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
#    IF g_wc IS NULL AND g_rae.rae01 IS NOT NULL THEN
#       LET g_wc = "rae01='",g_rae.rae01,"'"
#    END IF        
#     
#    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#                                                                                                                  
#    IF g_wc2 IS NULL THEN                                                                                                           
#       LET g_wc2 = ' 1=1'                                                                                                     
#    END IF                                                                                                                   
#                                                                                                                                    
#    LET l_cmd='p_query "artt303" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t303_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rae02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t303_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rae02",FALSE)
   END IF
 
END FUNCTION

FUNCTION t303_iss() 
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_dbs   LIKE azp_file.azp03   
DEFINE l_sql   STRING
DEFINE l_raq04 LIKE raq_file.raq04
DEFINE l_rtz11 LIKE rtz_file.rtz11
DEFINE l_raelegal LIKE rae_file.raelegal
DEFINE l_today  LIKE type_file.dat         #FUN-AB0093 
DEFINE l_time   LIKE type_file.chr8        #FUN-AB0093

  
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rae.rae02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rae.* FROM rae_file 
      WHERE rae02 = g_rae.rae02 AND rae01=g_rae.rae01
        AND raeplant = g_rae.raeplant
   
   IF g_rae.rae01<>g_rae.raeplant THEN
      CALL cl_err('','art-663',0)
      RETURN
   END IF      

   IF g_rae.raeacti ='N' THEN
      CALL cl_err(g_rae.rae01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rae.raeconf = 'N' THEN
      CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
      RETURN
   END IF

   IF g_rae.raeconf = 'X' THEN
      CALL cl_err('','art-661',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file
    WHERE raq01=g_rae.rae01 AND raq02=g_rae.rae02 AND raqplant=g_rae.raeplant
      AND raq03='2' AND raqacti='Y' AND raq05='N'
   IF l_cnt=0 THEN
      CALL cl_err('','art-662',0)
      RETURN
   END IF


   DROP TABLE rae_temp
   SELECT * FROM rae_file WHERE 1 = 0 INTO TEMP rae_temp
   DROP TABLE raf_temp
   SELECT * FROM raf_file WHERE 1 = 0 INTO TEMP raf_temp
   DROP TABLE rag_temp
   SELECT * FROM rag_file WHERE 1 = 0 INTO TEMP rag_temp
   DROP TABLE raq_temp
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp  
   DROP TABLE rap_temp
   SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp 
#add by lixia----start----
   DROP TABLE rar_temp
   SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp  
   DROP TABLE ras_temp
   SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp
#add by lixia----end----   
#FUN-BB0058 add START
   DROP TABLE rak_temp
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp
#FUN-BB0058 add END
   BEGIN WORK
   LET g_success = 'Y'
   LET g_time = TIME
  
   OPEN t303_cl USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
   IF STATUS THEN
      CALL cl_err("OPEN t303_cl:", STATUS, 1)
      CLOSE t303_cl
      ROLLBACK WORK
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file
    WHERE raq01 = g_rae.rae01 AND raq02 = g_rae.rae02
      AND raq03 = '2' AND raqplant = g_rae.raeplant
   IF l_cnt = 0 THEN
      CALL cl_err('','art-545',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM raf_file
    WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
      AND rafplant = g_rae.raeplant 
   IF l_cnt = 0 THEN
      CALL cl_err('','art-548',0)
      RETURN
   END IF
   IF NOT cl_confirm('art-660') THEN 
       RETURN
   END IF     
   
   CALL s_showmsg_init()
 
   

  #LET l_sql="SELECT raq04 FROM raq_file ",  #FUN-BB0058 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",  #FUN-BB0058 add
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='2' AND raqacti='Y' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rae.rae01,g_rae.rae02,g_rae.raeplant
                  INTO l_raq04  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach raq_cs:',SQLCA.sqlcode,1)                         
      END IF   
      IF g_rae.raeplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rae.raeplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
      LET g_plant_new = l_raq04
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04
      
      DELETE FROM rae_temp
      DELETE FROM raf_temp
      DELETE FROM rag_temp  
      DELETE FROM raq_temp
      DELETE FROM rap_temp
#add by lixia----start----
      DELETE FROM rar_temp
      DELETE FROM ras_temp
#add by lixia----end----  
      DELETE FROM rak_temp   #FUN-BB0058 add 
      LET l_today =  g_today         #FUN-AB0093
      LET l_time  =  g_time          #FUN-AB0093
      IF g_rae.raeplant = l_raq04 THEN #與當前機構相同則不拋
#TQC-AC0326 mark ------------------------begin------------------------       
##FUN-AB0093 ------------------STA
#         UPDATE rae_file SET rae901 = l_today,
#                             rae902 = l_time
#          WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
#            AND raeplant = g_rae.raeplant
#         IF SQLCA.sqlcode THEN
#             CALL cl_err3("upd","rae_file",g_rae.rae02,"",STATUS,"","",1)
#             CONTINUE FOREACH 
#         ELSE
#            SELECT rae901,rae902 INTO g_rae.rae901,g_rae.rae902
#              FROM rae_file 
#             WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
#               AND raeplant = g_rae.raeplant
#         END IF
##FUN-AB0093 ------------------END
#TQC-AC0326 mark -------------------------end------------------------- 
         UPDATE raq_file SET raq05='Y',raq06=l_today,raq07 = l_time   #TQC-AC0326 add raq06,raq07 
          WHERE raq01=g_rae.rae01 AND raq02=g_rae.rae02
            AND raq03='2' AND raq04=l_raq04 AND raqplant=g_rae.raeplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rae.rae01,"",STATUS,"","",1) 
            LET g_success = 'N'
         END IF
         #DISPLAY BY NAME g_rae.rae901               #FUN-AB0093  #TQC-AC0326 mark
         #DISPLAY BY NAME g_rae.rae902               #FUN-AB0093  #TQC-AC0326 mark
      ELSE
        #IF l_rtz11='N' THEN
            UPDATE raq_file SET raq05='Y',raq06=l_today,raq07 = l_time   #TQC-AC0326 add raq06,raq07 
             WHERE raq01=g_rae.rae01 AND raq02=g_rae.rae02
               AND raq03='2' AND raq04=l_raq04 AND raqplant=g_rae.raeplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","raq_file",g_rae.rae01,"",STATUS,"","",1) 
               LET g_success = 'N'
            END IF
        #END IF
      #將數據放入臨時表中處理
         SELECT azw02 INTO l_raelegal FROM azw_file
          WHERE azw01 = l_raq04 AND azwacti='Y'

         INSERT INTO raf_temp SELECT raf_file.* FROM raf_file
                               WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
                                 AND rafplant = g_rae.raeplant
         UPDATE raf_temp SET rafplant=l_raq04,
                             raflegal = l_raelegal

         INSERT INTO rag_temp SELECT rag_file.* FROM rag_file
                               WHERE rag01 = g_rae.rae01 AND rag02 = g_rae.rae02
                                 AND ragplant = g_rae.raeplant
         UPDATE rag_temp SET ragplant=l_raq04,
                             raglegal = l_raelegal

         INSERT INTO rap_temp SELECT rap_file.* FROM rap_file
                               WHERE rap01 = g_rae.rae01 AND rap02 = g_rae.rae02
                                 AND rapplant = g_rae.raeplant
         UPDATE rap_temp SET rapplant=l_raq04,
                             raplegal = l_raelegal
#add by lixia----start----
         INSERT INTO rar_temp SELECT rar_file.* FROM rar_file
                               WHERE rar01 = g_rae.rae01 AND rar02 = g_rae.rae02
                                 AND rarplant = g_rae.raeplant AND rar03 = '2'
         UPDATE rar_temp SET rarplant=l_raq04,
                             rarlegal = l_raelegal

         INSERT INTO ras_temp SELECT ras_file.* FROM ras_file
                               WHERE ras01 = g_rae.rae01 AND ras02 = g_rae.rae02
                                 AND rasplant = g_rae.raeplant AND ras03 = '2'
         UPDATE ras_temp SET rasplant=l_raq04,
                             raslegal = l_raelegal
#add by lixia----end----   
                             
         INSERT INTO rae_temp SELECT * FROM rae_file
                               WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
                                 AND raeplant = g_rae.raeplant
         IF l_rtz11='Y' THEN
            UPDATE rae_temp SET raeplant = l_raq04,
                                raelegal = l_raelegal,
                                raeconf = 'N',
                                raecond = NULL,
                                raecont = NULL,
                                raeconu = NULL
                                #rae901  = NUll,                           #FUN-AB0093  #TQC-AC0326 mark
                                #rae902  = NULL                            #FUN-AB0093  #TQC-AC0326 mark
         ELSE
            UPDATE rae_temp SET raeplant = l_raq04,
                                raelegal = l_raelegal,
                                raeconf = 'Y',
                                raecond = g_today,
                                raecont = g_time,
                                raeconu = g_user
                                #rae901  = l_today,                        #FUN-AB0093  #TQC-AC0326 mark
                                #rae902  = l_time                          #FUN-AB0093  #TQC-AC0326 mark
         END IF

         INSERT INTO raq_temp SELECT * FROM raq_file
                               WHERE raq01=g_rae.rae01 AND raq02 = g_rae.rae02
                                 AND raq03 ='2' AND raqplant = g_rae.raeplant
        #IF l_rtz11='Y' THEN
        #   UPDATE raq_temp SET raqplant = l_raq04,
        #                       raq05    = 'N',
        #                       raqlegal = l_raelegal
        #ELSE
         UPDATE raq_temp SET raqplant = l_raq04,
                             raq05    = 'Y',
                             raq06=l_today,  #FUN-BB0058 add
                             raq07 = l_time,  #FUN-BB0058 add
                             raqlegal = l_raelegal
        #END IF

      #FUN-BB0058 add START
         INSERT INTO rak_temp SELECT rak_file.* FROM rak_file
                               WHERE rak01 = g_rae.rae01 AND rak02 = g_rae.rae02
                                 AND rakplant = g_rae.raeplant AND rak03 = '2'
         UPDATE rak_temp SET rakplant=l_raq04,
                             raklegal = l_raelegal
      #FUN-BB0058 add END

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rae_file'),
                     " SELECT * FROM rae_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rae FROM l_sql
         EXECUTE trans_ins_rae
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rae_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raf_file'), 
                     " SELECT * FROM raf_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_raf FROM l_sql
         EXECUTE trans_ins_raf
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raf_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rag_file'), 
                     " SELECT * FROM rag_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rag FROM l_sql
         EXECUTE trans_ins_rag
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rag_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rap_file'), 
                     " SELECT * FROM rap_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rap FROM l_sql
         EXECUTE trans_ins_rap
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raq_file'), 
                     " SELECT * FROM raq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_raq FROM l_sql
         EXECUTE trans_ins_raq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
#add by lixia----start----
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rar_file'), 
                     " SELECT * FROM rar_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_rar FROM l_sql
         EXECUTE trans_ins_rar
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rar_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'ras_file'), 
                     " SELECT * FROM ras_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_ras FROM l_sql
         EXECUTE trans_ins_ras
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO ras_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
#add by lixia----end---- 

#FUN-BB0058 add START
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rak_file'),
                     " SELECT * FROM rak_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rak FROM l_sql
         EXECUTE trans_ins_rak
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
           CONTINUE FOREACH
         END IF
#FUN-BB0058 add END

      END IF       
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success = 'Y' THEN #拋磚成功
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF

   DROP TABLE rae_temp
   DROP TABLE raf_temp
   DROP TABLE rag_temp
   DROP TABLE raq_temp
   DROP TABLE rap_temp
#add by lixia----start---- 
   DROP TABLE rar_temp
   DROP TABLE ras_temp 
#add by lixia----end----  
   DROP TABLE rak_temp  #FUN-BB0058 add
#FUN-BB0058 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file
      WHERE raq01 = g_rae.rae01 AND raq02 = g_rae.rae02
        AND raq03 = '2' AND raqplant = g_rae.raeplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
#FUN-BB0058 add END
END FUNCTION

#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
FUNCTION t303_repeat(p_group)     
DEFINE p_group    LIKE raf_file.raf03
DEFINE l_n        LIKE type_file.num5
DEFINE l_rag05    LIKE rag_file.rag05
DEFINE l_rag06    LIKE rag_file.rag06
DEFINE l_rae04    LIKE rae_file.rae04
DEFINE l_rae05    LIKE rae_file.rae05
DEFINE l_rae06    LIKE rae_file.rae06
DEFINE l_rae07    LIKE rae_file.rae07

   LET l_n=0
   LET g_errno =' '

   SELECT COUNT(rag04) INTO l_n FROM rag_file
    WHERE rag01=g_rae.rae01 AND rag02=g_rae.rae02
      AND ragplant=g_rae.raeplant AND rag03=p_group
      AND ragacti='Y'

   IF l_n<1 THEN RETURN END IF
 
#   CALL t303sub_chk('2',g_rae.raeplant,g_rae.rae01,g_rae.rae02,p_group,g_rae.rae04,g_rae.rae05,g_rae.rae06,g_rae.rae07)  #FUN-BB0058 mark

END FUNCTION

FUNCTION t303_total_check()
DEFINE l_sql  STRING
DEFINE l_n        LIKE type_file.num5
DEFINE p_bdate    LIKE rae_file.rae04
DEFINE p_edate    LIKE rae_file.rae05
DEFINE p_btime    LIKE rae_file.rae06
DEFINE p_etime    LIKE rae_file.rae07
DEFINE p_snum     LIKE type_file.num5
DEFINE p_enum     LIKE type_file.num5

DEFINE l_rae01     LIKE rae_file.rae01
DEFINE l_rae02     LIKE rae_file.rae02
DEFINE l_rae04     LIKE rae_file.rae04
DEFINE l_rae05     LIKE rae_file.rae05
DEFINE l_rae06     LIKE rae_file.rae06
DEFINE l_rae07     LIKE rae_file.rae07
DEFINE l_raeplant  LIKE rae_file.raeplant
DEFINE l_raf03     LIKE raf_file.raf03

   LET g_errno= '  '
   LET p_bdate = g_rae.rae04
   LET p_edate = g_rae.rae05
   LET p_btime = g_rae.rae06
   LET p_etime = g_rae.rae07
   LET p_snum = p_btime[1,2]*60 + p_btime[4,5]
   LET p_enum = p_etime[1,2]*60 + p_etime[4,5]

   CALL s_showmsg_init()
   SELECT rae01,rae02,rae04,rae05,rae06,rae07,raeplant FROM rae_file where 1=0 INTO TEMP rae_temp

   DELETE FROM rae_temp
   LET l_sql ="INSERT INTO rae_temp ",
              "SELECT rae01,rae02,rae04,rae05,rae06,rae07,raeplant FROM ",cl_get_target_table(g_plant,"rae_file"),
              " WHERE  raeacti='Y' ",    
              "   AND (rae04 BETWEEN '",g_rae.rae04,"' AND '",g_rae.rae05,"' ",
              "    OR rae05 BETWEEN '",g_rae.rae04,"' AND '",g_rae.rae05,"' ",
              "    OR '",g_rae.rae04,"' BETWEEN rae04 AND rae05 ",
              "    OR '",g_rae.rae05,"' BETWEEN rae04 AND rae05 )"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE rae_temp_cs FROM l_sql
   EXECUTE rae_temp_cs
   IF SQLCA.sqlcode THEN
     #LET g_success='N'
      CALL s_errmsg('ins','','rae_temp',SQLCA.sqlcode,1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM rae_temp
   IF l_n > 0 THEN
      UPDATE rae_temp SET rae06=rae06[1,2]*60+rae06[4,5],
                          rae07=rae07[1,2]*60+rae07[4,5]
      DELETE FROM rae_temp
        WHERE (rae05 = p_bdate AND rae07 < p_snum) OR (rae04 = p_edate AND rae06 > p_enum)
   END IF
   SELECT COUNT(*) INTO l_n FROM rae_temp
   IF l_n = 0 THEN
     #LET g_success = 'Y'
      RETURN
   END IF

   LET l_sql="SELECT DISTINCT raf03 FROM ",cl_get_target_table(g_rae.raeplant,'raf_file')," ",
             " WHERE rafacti='Y'",
             "   AND raf01='",g_rae.rae01,"' AND raf02='",g_rae.rae02,"' AND rafplant='",g_rae.raeplant,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_rae.raeplant) RETURNING l_sql
   DECLARE raf_temp_cs CURSOR FROM l_sql
   FOREACH raf_temp_cs INTO l_raf03
     IF SQLCA.sqlcode=100 THEN
        EXIT FOREACH
     END IF
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('sel','','raf_file',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
    #CALL t303sub_chk('2',g_rae.raeplant,g_rae.rae01,g_rae.rae02,l_raf03,g_rae.rae04,g_rae.rae05,g_rae.rae06,g_rae.rae07)
    #CALL t303_repeat(l_raf03)  #FUN-AB0033 mark
   END FOREACH
  
   CALL s_showmsg()
 
   DROP TABLE rae_temp
END FUNCTION

FUNCTION t303_temptable(p_type)     #FUN-A80104
   DEFINE p_type     LIKE type_file.num5
   IF p_type = '1' THEN
      SELECT rae01,rae02,rae03,rae04,rae05,rae06,rae07,raeplant FROM rae_file WHERE 1=0 INTO TEMP cx001_temp  #FUN-BB0058 mark
   #   SELECT rae01,rae02,rae03,raeplant FROM rae_file WHERE 1=0 INTO TEMP cx001_temp                           #FUN-BB0058 add
      SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp
      SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp1
   ELSE
      DROP TABLE cx001_temp
      DROP TABLE cx002_temp
      DROP TABLE cx002_temp1
   END IF
END FUNCTION

#TQC-AC0326 add --------------------begin----------------------
FUNCTION t303_w() 			# when g_rae.raeconf='Y' (Turn to 'N')
DEFINE l_cnt       LIKE type_file.num10
DEFINE l_raecont   LIKE rae_file.raecont   #CHI-D20015 Add
DEFINE l_gen02     LIKE gen_file.gen02     #CHI-D20015 Add
 
   SELECT COUNT(*) INTO l_cnt FROM raq_file 
    WHERE raq01=g_rae.rae01 AND raq02=g_rae.rae02 AND raqplant=g_rae.raeplant 
      AND raq03='2' AND raqacti='Y' AND raq05='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','art-888',0)
      RETURN
   END IF     

   LET g_success = 'Y'
   BEGIN WORK
 
   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF 
  #CHI-D20015 Mark&Add Str
   LET l_raecont = TIME
  #UPDATE rae_file SET raeconf = 'N',raeconu='',raecond='',
  #                    raecont=''  #Add No:TQC-B10129
   UPDATE rae_file SET raeconf='N',raeconu=g_user,
                       raecond=g_today,raecont=l_raecont
  #CHI-D20015 Mark&Add End
    WHERE rae01 = g_rae.rae01 
      AND rae02 = g_rae.rae02   #Add No:TQC-B10131
      AND raeplant = g_rae.raeplant  #Add No:TQC-B10131

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rae_file",g_rae.rae01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rae_file OK'
   END IF
  
   IF g_success = 'Y' THEN
      LET g_rae.raeconf='N' 
      COMMIT WORK
     #CHI-D20015 Mark&Add Str
     #LET g_rae.raeconu=NULL
     #LET g_rae.raecond=NULL
     #DISPLAY BY NAME g_rae.raeconf
     ##Add No:TQC-B10129
     #LET g_rae.raecont=NULL
      LET g_rae.raeconu=g_user
      LET g_rae.raecond=g_today
      DISPLAY BY NAME g_rae.raeconf
      LET g_rae.raecont=l_raecont
     #CHI-D20015 Mark&Add End
      DISPLAY BY NAME g_rae.raecond
      DISPLAY BY NAME g_rae.raecont
      DISPLAY BY NAME g_rae.raeconu
     #DISPLAY '' TO FORMONLY.raeconu_desc                                 #CHI-D20015 Mark
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rae.raeconu   #CHI-D20015 Add
      DISPLAY l_gen02 TO FORMONLY.raeconu_desc                            #CHI-D20015 Add
      IF g_rae.raeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      CALL cl_set_field_pic(g_rae.raeconf,"","","",g_chr,"")
      #End Add No:TQC-B10129
   ELSE
      LET g_rae.raeconu=g_user                                                                                           
      LET g_rae.raecond=g_today  
      LET g_rae.raeconf='Y' 
      LET g_rae.raeconu=l_raecont    #CHI-D20015 Add
      ROLLBACK WORK
   END IF
END FUNCTION
#TQC-AC0326 add --------------------end-----------------------

#TQC-B60071 ADD - BEGIN --------------------------
FUNCTION t303_upd_rae21()
DEFINE l_raf04_n      LIKE type_file.num5
DEFINE l_raf05_n      LIKE type_file.num5

   IF NOT cl_null(g_rae.rae01) AND NOT cl_null(g_rae.rae02) THEN
      LET l_raf04_n = 0
      #--- << 找出 raf_file 中參與方式不為'1.必選'的筆數 >> ---#
      SELECT COUNT(*) INTO l_raf04_n FROM raf_file WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02 AND raf04 <> '1'
      #--- << 如果資料中只存在必選的資料,則將單身中所有必選項目的數量匯總更新到單頭的組合總量 >> ---#
      IF l_raf04_n = 0 THEN
         #--- << 匯總 >> ---#
         LET l_raf05_n = 0
         SELECT SUM(raf05) INTO l_raf05_n FROM raf_file 
          WHERE raf01 = g_rae.rae01 AND raf02 = g_rae.rae02
            AND rafplant = g_rae.raeplant AND rafacti = 'Y'
         IF NOT cl_null(l_raf05_n) THEN
            #--- << 更新單頭的組合總量 >> ---#
            UPDATE rae_file SET rae21 = l_raf05_n 
             WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
               AND raeplant = g_rae.raeplant
            SELECT rae21 INTO g_rae.rae21 FROM rae_file
             WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
               AND raeplant = g_rae.raeplant
            DISPLAY BY NAME g_rae.rae21
         END IF
      END IF
   END IF
END FUNCTION
#FUN-BB0058 add START
FUNCTION t303_b3_fill(p_wc3)
DEFINE p_wc3   STRING

   LET g_sql = "SELECT rak05, rak06, rak07, rak08, rak09, rak10, rak11, rakacti ",
               "  FROM rak_file",
               " WHERE rak02 = '",g_rae.rae02,"' AND rak01 ='",g_rae.rae01,"' ",
               "   AND rakplant = '",g_rae.raeplant,"'",
               "   AND rak03 = '2'"

   IF NOT cl_null(p_wc3) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rak05 "

   DISPLAY g_sql

   PREPARE t303_pb2 FROM g_sql
   DECLARE rak_cs CURSOR FOR t303_pb2

   CALL g_rak.clear()
   LET g_cnt = 1

   FOREACH rak_cs INTO g_rak[g_cnt].*
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
   CALL g_rak.deleteElement(g_cnt)

   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t303_set_entry_rak(p_ac)
DEFINE p_ac         LIKE type_file.num5

   IF cl_null(g_rak[p_ac].rak10) AND cl_null(g_rak[p_ac].rak11) THEN
      CALL cl_set_comp_entry("rak11",TRUE)
      CALL cl_set_comp_entry("rak10",TRUE)
   END IF 
   IF NOT cl_null(g_rak[p_ac].rak10) THEN
      CALL cl_set_comp_entry("rak11",FALSE) 
   ELSE
      CALL cl_set_comp_entry("rak11",TRUE) 
   END IF
   IF NOT cl_null(g_rak[p_ac].rak11) THEN
      CALL cl_set_comp_entry("rak10",FALSE)
   ELSE
      CALL cl_set_comp_entry("rak10",TRUE)
   END IF
END FUNCTION

FUNCTION t303_update_pos()
DEFINE l_raepos       LIKE rae_file.raepos

   SELECT raepos INTO l_raepos FROM rae_file
      WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
        AND raeplant = g_rae.raeplant
   IF l_raepos <> '1' THEN
      LET l_raepos = '2'
   ELSE
      LET l_raepos = '1'
   END IF
   UPDATE rae_file SET raepos = l_raepos
      WHERE rae01 = g_rae.rae01 AND rae02 = g_rae.rae02
        AND raeplant = g_rae.raeplant
   LET g_rae.raepos = l_raepos
   DISPLAY BY NAME g_rae.raepos
END FUNCTION
#FUN-BB0058 add START

#TQC-B60071 ADD -  END  --------------------------

#FUN-A60044 
#FUN-C10008 add START
FUNCTION t303_chkrap()
   DEFINE l_n      LIKE type_file.num5

   IF g_rae.rae12 = 0 THEN RETURN END IF
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM rap_file
     WHERE rap01 =g_rae.rae01 AND rap02 = g_rae.rae02
       AND rap03 = 2 
       AND rap09 = g_rae_o.rae12  
       AND rapplant = g_rae.raeplant
   IF l_n > 0 THEN
     IF NOT cl_confirm('art-797') THEN
        RETURN
     END IF
     IF g_rae_o.rae10 = 1 THEN  #特價
        UPDATE rap_file SET rap06 = 0
           WHERE rap01 =g_rae.rae01 AND rap02 = g_rae.rae02
             AND rap03 = 2 
             AND rap09 = g_rae_o.rae12 
             AND rapplant = g_rae.raeplant
     END IF
     IF g_rae_o.rae10 = 2 THEN  #折扣
        UPDATE rap_file SET rap07 = 0
           WHERE rap01 =g_rae.rae01 AND rap02 = g_rae.rae02
             AND rap03 = 2 
             AND rap09 = g_rae_o.rae12
             AND rapplant = g_rae.raeplant 
     END IF
     IF g_rae_o.rae10 = 3 THEN  #折讓
        UPDATE rap_file SET rap08 = 0
           WHERE rap01 =g_rae.rae01 AND rap02 = g_rae.rae02
             AND rap03 = 2 
             AND rap09 = g_rae_o.rae12
             AND raplant = g_rae.raeplant 
     END IF
   END IF
END FUNCTION
#FUN-C10008 add END


# MOD-CC0219------------ add ----------- begin
FUNCTION t303_multi_ima01()
DEFINE  l_rag       RECORD LIKE rag_file.*
DEFINE  tok         base.StringTokenizer
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
   WHILE tok.hasMoreTokens()
      LET l_rag.rag05 = tok.nextToken()
      LET l_rag.rag01 = g_rae.rae01
      LET l_rag.rag02 = g_rae.rae02
      LET l_rag.rag03 = g_rag[l_ac1].rag03
      LET l_rag.rag04 = g_rag[l_ac1].rag04

      IF cl_null(g_rtz04) THEN
         SELECT DISTINCT ima25
           INTO l_rag.rag06
           FROM ima_file
          WHERE ima01=l_rag.rag05
            AND imaacti = 'Y'
      ELSE
         SELECT DISTINCT ima25
           INTO l_rag.rag06
           FROM ima_file,rte_file
          WHERE ima01 = rte03 AND ima01=l_rag.rag05
            AND rte01 = g_rtz04
            AND rte07 = 'Y'
      END IF
      LET l_rag.ragplant = g_rae.raeplant
      LET l_rag.raglegal = g_rae.raelegal
      LET l_rag.ragacti  = 'Y'
      INSERT INTO rag_file VALUES(l_rag.*)
      IF STATUS THEN
         CALL s_errmsg('rag01',l_rag.rag05,'INS rag_file',STATUS,1)
         CONTINUE WHILE
      END IF
   END WHILE
   CALL s_showmsg()
END FUNCTION
# MOD-CC0219------------ add ----------- end

#FUN-CC0129 add begin-------------------------------
FUNCTION t303_copy()
   DEFINE l_newno     LIKE rae_file.rae02,
          l_oldno     LIKE rae_file.rae02,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5,
          new_date    LIKE type_file.dat,
          l_rae03     LIKE rae_file.rae03,
          i           LIKE type_file.num5
          
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rae.rae02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET new_date = g_today
   LET l_oldno  = g_rae.rae02
   LET g_success = 'Y' 

   DROP TABLE v
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP v
   DROP TABLE w
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP w
   DROP TABLE x
   SELECT * FROM raf_file WHERE 1 = 0 INTO TEMP x
   DROP TABLE y
   SELECT * FROM rae_file WHERE 1 = 0 INTO TEMP y
   DROP TABLE z
   SELECT * FROM rag_file WHERE 1 = 0 INTO TEMP z
      
   BEGIN WORK   
   
   LET g_before_input_done = FALSE
   CALL t303_set_entry('a')
   LET g_before_input_done = TRUE
WHILE TRUE
   CALL cl_set_head_visible("","YES")   
   INPUT l_newno FROM rae02
   
      BEFORE INPUT
      CALL cl_set_docno_format("rae02")
      
      AFTER FIELD rae02
      IF l_newno IS NULL THEN
         NEXT FIELD rae02 
      ELSE 
         SELECT COUNT(*) INTO i FROM rae_file 
          WHERE rae02    = l_newno
            AND raeplant = g_plant
            AND rae01    = g_rae.rae01
         IF i>0 THEN
            CALL cl_err('sel rae02:','-239',0)
            NEXT FIELD rae02
         END IF     
         CALL s_check_no("art",l_newno,g_rae_t.rae02,"A8","rae_file","rae01,rae02,raeplant","") 
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN                                                            
            LET g_rae.rae02=g_rae_t.rae02                                                                 
            NEXT FIELD rae02                                                                                     
         END IF            
      END IF                  

      ON ACTION controlp
         CASE 
            WHEN INFIELD(rae02)                                                                                                      
              LET g_t1=s_get_doc_no(l_newno)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A8','art') RETURNING g_t1           #FUN-A70130                                                         
              LET l_newno = g_t1                                                                                                
              DISPLAY  l_newno TO rae02                                                                                           
              NEXT FIELD rae02
         END CASE         
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rae.rae02
      RETURN
   END IF   
   CALL s_auto_assign_no("art",l_newno,g_today,"A8","rae_file","rae02","","","") 
      RETURNING li_result,l_newno 
   IF (NOT li_result) THEN  
      CONTINUE WHILE  
   END IF 
   DISPLAY l_newno TO rae02 
   EXIT WHILE
END WHILE        
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rae.rae02
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
     
   #组合促销单头档 
   SELECT * FROM rae_file
       WHERE rae02 = l_oldno AND rae01=g_rae.rae01
         AND raeplant = g_rae.raeplant
       INTO TEMP  y 
   UPDATE y
       SET rae02=l_newno,
           raeplant=g_plant, 
           raelegal=g_legal,
           raeconf = 'N',
           raecond = NULL,
           raeconu = NULL,
           raeuser=g_user,
           raegrup=g_grup,
           raemodu=NULL,
           raedate=g_today,
           raeacti='Y',
           raecrat=g_today ,
           raeoriu = g_user,
           raeorig = g_grup
           
   INSERT INTO rae_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rae_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF    

   #组别设定 
   SELECT * FROM raf_file
       WHERE raf02 = l_oldno AND raf01=g_rae.rae01 
         AND rafplant = g_rae.raeplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE x SET raf02=l_newno,
                rafplant = g_plant,
                raflegal = g_legal 
 
   INSERT INTO raf_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","raf_file","","",SQLCA.sqlcode,"","",1) 
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
   
   #促销单生失效时段设定档 
   SELECT * FROM rak_file
       WHERE rak02 = l_oldno AND rak01=g_rae.rae01 
         AND rakplant = g_rae.raeplant
       INTO TEMP  w
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","w","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE w SET rak06=g_today,
                rak07=g_today, 
                rak02=l_newno,
                rakplant = g_plant,
                raklegal = g_legal 
 
   INSERT INTO rak_file
       SELECT * FROM w
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rak_file","","",SQLCA.sqlcode,"","",1) 
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
   
   #生效营运中心 
   SELECT * FROM raq_file
       WHERE raq02 = l_oldno AND raq01=g_rae.rae01 
         AND raqplant = g_rae.raeplant
       INTO TEMP  v
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","v","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF

   UPDATE v SET raq05='N',
                raq07=NULL, 
                raq06=NULL,
                raq02=l_newno,
                raqplant = g_plant,
                raqlegal = g_legal 
 
   INSERT INTO raq_file
       SELECT * FROM v
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","raq_file","","",SQLCA.sqlcode,"","",1) 
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
    
  #范围设定单身 
   SELECT * FROM rag_file
       WHERE rag02 = l_oldno AND rag01=g_rae.rae01 
         AND ragplant = g_rae.raeplant
       INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE z SET rag02=l_newno,
                ragplant = g_plant,
                raglegal = g_legal 
 
   INSERT INTO rag_file
       SELECT * FROM z   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rag_file","","",SQLCA.sqlcode,"","",1)  
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF    
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
   IF g_success ='Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
      RETURN     
   END IF
   DROP TABLE v
   DROP TABLE w
   DROP TABLE x
   DROP TABLE y
   DROP TABLE z
   SELECT rae_file.* INTO g_rae.* FROM rae_file 
      WHERE rae02=l_newno AND rae01 = g_rae.rae01
        AND raeplant = g_rae.raeplant
   CALL t303_u()
   CALL t303_b()
   SELECT rae_file.* INTO g_rae.* FROM rae_file 
       WHERE rae02=g_rae.rae02 AND rae01 = g_rae.rae01 
         AND raeplant = g_rae.raeplant
   CALL t303_show()        
END FUNCTION 
#FUN-CC0129 add end---------------------------------
