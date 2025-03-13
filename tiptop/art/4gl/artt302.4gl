# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt302.4gl
# Descriptions...: 一般促銷單
# Date & Author..: NO.FUN-A60044 10/06/17 By Cockroach 
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-A80104 10/08/19 By lixia資料類型改為varchar2(2)
# Modify.........: No.TQC-A80165 10/08/27 By houlia 將l_time1、l_time2的類型調整為number
# Modify.........: No.TQC-A80167 10/08/30 By houlia 取消作廢功能
# Modify.........: No.TQC-A90026 10/10/13 By houlia 修改特賣價報錯信息
# Modify.........: No:TQC-AA0109 10/10/20 By lixia sql修正
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0033 10/11/08 By wangxin 促銷BUG調整
# Modify.........: No.FUN-AB0093 10/11/24 By huangtao 增加發佈日期和發佈時間
# Modify.........: No.TQC-AB0161 10/11/28 By Cockroach 系统联测BUG修改
# Modify.........: No.FUN-AB0101 10/12/06 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號，否則抓ima_file
# Modify.........: No.TQC-AB0196 10/12/15 By wangxin 查詢所有資料后清空單身數組中的值
# Modify.........: No.TQC-AC0193 10/12/15 By wangxin 根據促銷方式，控管相應欄位的值
# Modify.........: No.MOD-AC0172 10/12/18 By suncx 會員等級促銷BUG調整
# Modify.........: No.MOD-AC0174 10/12/18 By suncx 上級下發後，下級營運中心[會員等級促銷] rap_file 資料未帶入 
# Modify.........: No:TQC-AC0326 10/12/22 By wangxin 促銷302/303/304規格調整，發布時間調整，
#                                                    畫面原來的發布時間mark掉，新增欄位在生效營運中心按鈕中顯示，
#                                                    并添加取消確認按鈕(未發布可取消審核)
# Modify.........: No:TQC-B10078 11/01/11 By zhangll 取消審核後未立即清空審核日期，審核人員，簡稱，審核圖標的欄位
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No.TQC-B50153 11/05/30 By lixia 錄入單頭時，點退出，未把單頭畫面清空
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60071 11/06/22 By baogc 增加確認時對組別的控管
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.TQC-BA0173 11/10/28 By destiny 发布时间更新错误
# Modify.........: No.FUN-BB0056 11/11/10 By pauline GP5.3 artt302 一般促銷單促銷功能優化
# Modify.........: No.FUN-C10008 12/01/04 By pauline GP5.3 artt302 一般促銷單促銷功能優化調整
# Modify.........: No.TQC-C20106 12/02/10 By pauline GP5.3 刪除錯誤處理 
# Modify.........: No.TQC-C20336 12/02/21 By pauline 刪除錯誤處理
# Modify.........: No.MOD-C20226 12/02/28 By suncx 錄入產品分類時管控只能錄入末级產品分類
# Modify.........: No:FUN-C30154 12/03/14 By pauline 一般促銷增加價格區間
# Modify.........: No:FUN-C30151 12/03/20 By pauline 促銷時段增加CONTROLO 功能
# Modify.........: No:TQC-C40093 12/04/13 By pauline 當點選特賣價時,點選其他列的資料,且促銷方式不同時,會導致程式卡死 
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80117 12/08/22 By yangxf 在時間段下條件會抓出所有的資料
# Modify.........: No.MOD-CC0143 12/12/17 By Carrier rac03字段误用
# Modify.........: No.MOD-CC0219 13/01/05 By SunLM artt302,artt303,artt304範圍設置單身，編碼類型為產品時，錄入時代碼可以開窗多選形式進行錄入
# Modify.........: No.FUN-CC0129 13/01/07 By SunLM artt302,artt303,artt304新增複製功能
# Modify.........: No.MOD-CA0204 13/01/11 By jt_chen 修正:FUN-B80085導致非此營運中心資料時，進單身會發生錯誤
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rab         RECORD LIKE rab_file.*,
       g_rab_t       RECORD LIKE rab_file.*,
       g_rab_o       RECORD LIKE rab_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_rac         DYNAMIC ARRAY OF RECORD
     #     rac02          LIKE rac_file.rac02,
           rac03          LIKE rac_file.rac03,
           rac04          LIKE rac_file.rac04,
           rac05          LIKE rac_file.rac05,
           rac06          LIKE rac_file.rac06,
           rac07          LIKE rac_file.rac07,
           rac08          LIKE rac_file.rac08,
           rac09          LIKE rac_file.rac09,
           rac10          LIKE rac_file.rac10,
           rac11          LIKE rac_file.rac11,
     #      rac12          LIKE rac_file.rac12,  #FUN-BB0056 mark
     #      rac14          LIKE rac_file.rac14,  #FUN-BB0056 mark
     #      rac13          LIKE rac_file.rac13,  #FUN-BB0056 mark
     #      rac15          LIKE rac_file.rac15,  #FUN-BB0056 mark
           racacti        LIKE rac_file.racacti,
           racpos         LIKE rac_file.racpos
                     END RECORD,
       g_rac_t       RECORD
     #     rac02          LIKE rac_file.rac02,
           rac03          LIKE rac_file.rac03,
           rac04          LIKE rac_file.rac04,
           rac05          LIKE rac_file.rac05,
           rac06          LIKE rac_file.rac06,
           rac07          LIKE rac_file.rac07,
           rac08          LIKE rac_file.rac08,
           rac09          LIKE rac_file.rac09,
           rac10          LIKE rac_file.rac10,
           rac11          LIKE rac_file.rac11,
     #      rac12          LIKE rac_file.rac12,  #FUN-BB0056 mark
     #      rac14          LIKE rac_file.rac14,  #FUN-BB0056 mark
     #      rac13          LIKE rac_file.rac13,  #FUN-BB0056 mark
     #      rac15          LIKE rac_file.rac15,  #FUN-BB0056 mark
           racacti        LIKE rac_file.racacti,
           racpos         LIKE rac_file.racpos
                     END RECORD,
       g_rac_o       RECORD 
     #     rac02          LIKE rac_file.rac02,
           rac03          LIKE rac_file.rac03,
           rac04          LIKE rac_file.rac04,
           rac05          LIKE rac_file.rac05,
           rac06          LIKE rac_file.rac06,
           rac07          LIKE rac_file.rac07,
           rac08          LIKE rac_file.rac08,
           rac09          LIKE rac_file.rac09,
           rac10          LIKE rac_file.rac10,
           rac11          LIKE rac_file.rac11,
     #      rac12          LIKE rac_file.rac12,  #FUN-BB0056 mark
     #      rac14          LIKE rac_file.rac14,  #FUN-BB0056 mark
     #      rac13          LIKE rac_file.rac13,  #FUN-BB0056 mark
     #      rac15          LIKE rac_file.rac15,  #FUN-BB0056 mark
           racacti        LIKE rac_file.racacti,
           racpos         LIKE rac_file.racpos
                     END RECORD,
       g_rad         DYNAMIC ARRAY OF RECORD
           rad03          LIKE rad_file.rad03,
           rad04          LIKE rad_file.rad04,
           rad05          LIKE rad_file.rad05,
           rad05_desc     LIKE type_file.chr100,
           rad06          LIKE rad_file.rad06,
           rad06_desc     LIKE gfe_file.gfe02,
           radacti        LIKE rad_file.radacti
                     END RECORD,
       g_rad_t       RECORD
           rad03          LIKE rad_file.rad03,
           rad04          LIKE rad_file.rad04,
           rad05          LIKE rad_file.rad05,
           rad05_desc     LIKE type_file.chr100,
           rad06          LIKE rad_file.rad06,
           rad06_desc     LIKE gfe_file.gfe02,
           radacti        LIKE rad_file.radacti
                     END RECORD,
       g_rad_o       RECORD
           rad03          LIKE rad_file.rad03,
           rad04          LIKE rad_file.rad04,
           rad05          LIKE rad_file.rad05,
           rad05_desc     LIKE type_file.chr100,
           rad06          LIKE rad_file.rad06,
           rad06_desc     LIKE gfe_file.gfe02,
           radacti        LIKE rad_file.radacti
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_wc3         STRING, #FUN-BB0056 add
       g_rec_b       LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac3         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
#FUN-BB0056 add START
DEFINE
       g_rak         DYNAMIC ARRAY OF RECORD
           rak04          LIKE rak_file.rak04,
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
           rak04          LIKE rak_file.rak04,
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
           rak04          LIKE rak_file.rak04,
           rak05          LIKE rak_file.rak05,
           rak06          LIKE rak_file.rak06,
           rak07          LIKE rak_file.rak07,
           rak08          LIKE rak_file.rak08,
           rak09          LIKE rak_file.rak09,
           rak10          LIKE rak_file.rak10,
           rak11          LIKE rak_file.rak11,
           rakacti        LIKE rak_file.rakacti
                     END RECORD

#FUN-BB0056 add END 
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
DEFINE g_argv1             LIKE rab_file.rab01
DEFINE g_argv2             LIKE rab_file.rab02
DEFINE g_argv3             LIKE rab_file.rabplant
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b2            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_b_flag            LIKE type_file.chr1      #FUN-D30033 add
DEFINE g_member            LIKE type_file.chr1

DEFINE l_azp02             LIKE azp_file.azp02 
DEFINE g_rtz05             LIKE rtz_file.rtz05  #價格策略
DEFINE g_rtz04             LIKE rtz_file.rtz04  #FUN-AB0101 產品策略
#FUN-C10008 add START
DEFINE g_raq         RECORD
           raq05          LIKE raq_file.raq05,
           raq06          LIKE raq_file.raq06,
           raq07          LIKE raq_file.raq07
                     END RECORD
#FUN-C10008 add END
DEFINE g_multi_ima01       STRING    #MOD-CC0219 add

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
  #SELECT * FROM rus_file INTO TEMP rus_tmp 
  #SELECT * FROM rus_file INTO TEMP rus_tmp1 
  #LET g_sql = "INSERT INTO dsv11.rus_file SELECT * FROM rus_tmp"
  #PREPARE pre_sel_rus FROM g_sql
  #EXECUTE pre_sel_rus

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM rab_file WHERE rab01 = ? AND rab02 = ? AND rabplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t302_w AT p_row,p_col WITH FORM "art/42f/artt302"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET g_rab.rab01=g_plant
   DISPLAY BY NAME g_rab.rab01 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_plant
   DISPLAY l_azp02 TO rab01_desc
   SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant

   IF NOT cl_null(g_argv1) THEN
      CALL t302_q()
   END IF

   CALL cl_set_comp_visible("rab05,rab06,rab08,rab09",FALSE)  #FUN-BB0056 add
   CALL cl_set_comp_required("rak11",FALSE)   #FUN-BB0056 add
   
   CALL t302_menu()
   CLOSE WINDOW t302_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t302_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rac.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rab01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED," rab02 = '",g_argv2,"'"
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc CLIPPED," rabplant = '",g_argv3,"'"
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rab.* TO NULL
      CONSTRUCT BY NAME g_wc ON rab01,rab02,rab03,rabplant,rab11,
                                #rab04,rab05,rab06,rabmksg,               #TQC-AB0161 mark
                                rab04,rab05,rab06,                        #TQC-AB0161 add
                                #rab900,rabconf,rabcond,rabcont,rabconu,  #TQC-AB0161 mark
                                rabconf,rabcond,rabcont,rabconu,          #TQC-AB0161 add
                                #rab901,rab902,                           #FUN-AB0093 add #TQC-AC0326 mark
                                rab07,rab08,rab09,rab10,
                                rabuser,rabgrup,raboriu,rabmodu,rabdate,raborig,rabacti,rabcrat,
                                raq05, raq06, raq07  #FUN-C10008 add
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rab01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rab01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rab01
                  NEXT FIELD rab01
      
               WHEN INFIELD(rab02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rab02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rab02
                  NEXT FIELD rab02
      
               WHEN INFIELD(rab03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rab03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rab03
                  NEXT FIELD rab03
      
               WHEN INFIELD(rabconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rabconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rabconu                                                                              
                  NEXT FIELD rabconu
               WHEN INFIELD(rabplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rabplant"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rabplant                                                                              
                  NEXT FIELD rabplant
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rabuser', 'rabgrup')
      
      DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-BB0056 add 
         CONSTRUCT g_wc1 ON rac03,rac04,rac05,rac06,rac07,rac08,   
                    #        rac09,rac10,rac11,rac12,rac14,rac13,rac15,racacti,racpos     #FUN-BB0056 mark
                            rac09,rac10,rac11,racacti,racpos   #FUN-BB0056 add
                 FROM s_rac[1].rac03,s_rac[1].rac04,
                      s_rac[1].rac05,s_rac[1].rac06,s_rac[1].rac07,
                      s_rac[1].rac08,s_rac[1].rac09,s_rac[1].rac10,
#                      s_rac[1].rac11,s_rac[1].rac12,s_rac[1].rac14,    #FUN-BB0056 mark
#                      s_rac[1].rac13,s_rac[1].rac15,s_rac[1].racacti,  #FUN-BB0056 mark
                      s_rac[1].rac11,s_rac[1].racacti,                  #FUN-BB0056 add
                      s_rac[1].racpos 
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
      #  ON ACTION CONTROLP
      #     CASE
      #        WHEN INFIELD(rac04)
      #        WHEN INFIELD(rac05)
      #        WHEN INFIELD(rac06)
      #     END CASE

   #FUN-BB0056 mark START 
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
   #         CONTINUE CONSTRUCT
   # 
   #      ON ACTION about
   #         CALL cl_about()
   # 
   #      ON ACTION HELP
   #         CALL cl_show_help()
   # 
   #      ON ACTION controlg
   #         CALL cl_cmdask()
   # 
   #      ON ACTION qbe_save
   #         CALL cl_qbe_save()
   #FUN-BB0056 mark END
          END CONSTRUCT

   #FUN-BB0056 START
   #       IF INT_FLAG THEN
   #          RETURN
   #       END IF 
   #FUN-BB0056 END

     #FUN-BB0056 add START
          CONSTRUCT g_wc3 ON rak04,rak05,rak06,rak07,rak08,rak09,rak10,rak11,rakacti
                 FROM s_rak[1].rak04,s_rak[1].rak05,s_rak[1].rak06,s_rak[1].rak07,s_rak[1].rak08, 
                      s_rak[1].rak09, s_rak[1].rak10, s_rak[1].rak11, s_rak[1].rakacti  

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
          END CONSTRUCT
     #FUN-BB0056 add END

          CONSTRUCT g_wc2 ON rad03,rad04,rad05,rad06,radacti
                 FROM s_rad[1].rad03,s_rad[1].rad04,
                      s_rad[1].rad05,s_rad[1].rad06, s_rad[1].radacti
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(rad05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_rad05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rad05
                     NEXT FIELD rad05
                  WHEN INFIELD(rad06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_rad06"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rad06
                     NEXT FIELD rad06 
               END CASE
   #FUN-BB0056 mark START 
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
   #         CONTINUE CONSTRUCT
   # 
   #      ON ACTION about
   #         CALL cl_about()
   # 
   #      ON ACTION HELP
   #         CALL cl_show_help()
   # 
   #      ON ACTION controlg
   #         CALL cl_cmdask()
   # 
   #      ON ACTION qbe_save
   #         CALL cl_qbe_save()
   #FUN-BB0056 mark END
       END CONSTRUCT   
    #FUN-BB0056 add START 
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
    #FUN-BB0056 add END
       IF INT_FLAG THEN 
          RETURN
       END IF

    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc  = g_wc  CLIPPED

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF
   #TQC-C80117 add begin ---
    IF cl_null(g_wc3) THEN
       LET g_wc3=" 1=1"
    END IF
   #TQC-C80117 add end -----
    
#modify by TQC-AA0109----STR---- 
#    LET g_sql = "SELECT DISTINCT rab01,rab02,rabplant ",
#                "  FROM (rab_file LEFT OUTER JOIN rac_file ",
#                "       ON (rab01=rac01 AND rab02=rac02 AND rabplant=racplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN rad_file ON ( rab01=rad01 AND rab02=rad02 ",
#                "     AND rabplant=radplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rab01,rab02,rabplant"
    LET g_sql = "SELECT DISTINCT rab01,rab02,rabplant ",
                "  FROM rab_file LEFT OUTER JOIN rac_file ",
                "       ON (rab01=rac01 AND rab02=rac02 AND rabplant=racplant) ",
                "    LEFT OUTER JOIN rad_file ON ( rab01=rad01 AND rab02=rad02 ",
                "     AND rabplant=radplant ) ",
                "    LEFT OUTER JOIN raq_file ON ( rab01=raq01 AND rab02=raq02 ", #FUN-C10008 add 
                "     AND rabplant=raqplant )  ",   #FUN-C10008 add
                #TQC-C80117 add begin ---
                "    LEFT OUTER JOIN rak_file ON ( rab01=rak01 AND rab02=rak02 ",
                "     AND rabplant=rakplant ) ",
                #TQC-C80117 add end -----
                "  WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED,
                "    AND ", g_wc3 CLIPPED,     #TQC-C80117 add 
                " ORDER BY rab01,rab02,rabplant"
#modify by TQC-AA0109----END---- 
   PREPARE t302_prepare FROM g_sql
   DECLARE t302_cs
       SCROLL CURSOR WITH HOLD FOR t302_prepare
#modify by TQC-AA0109----STR---- 
#   LET g_sql = "SELECT COUNT(DISTINCT rab01||rab02||rabplant) ",
#                "  FROM (rab_file LEFT OUTER JOIN rac_file ",
#                "       ON (rab01=rac01 AND rab02=rac02 AND rabplant=racplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN rad_file ON ( rab01=rad01 AND rab02=rad02 ",
#                "     AND rabplant=radplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rab01"
    LET g_sql = "SELECT COUNT(DISTINCT rab01||rab02||rabplant) ",
                "  FROM rab_file LEFT OUTER JOIN rac_file ",
                "       ON (rab01=rac01 AND rab02=rac02 AND rabplant=racplant ) ",
                "    LEFT OUTER JOIN rad_file ON ( rab01=rad01 AND rab02=rad02 ",
                "     AND rabplant=radplant ) ",
                "    LEFT OUTER JOIN raq_file ON ( rab01=raq01 AND rab02=raq02 ", #FUN-C10008 add
                "     AND rabplant=raqplant )  ",   #FUN-C10008 add
                #TQC-C80117 add begin ---
                "    LEFT OUTER JOIN rak_file ON ( rab01=rak01 AND rab02=rak02 ",
                "     AND rabplant=rakplant ) ",
                #TQC-C80117 add end -----
                "  WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED,
                "    AND ", g_wc3 CLIPPED,    #TQC-C80117 add 
                " ORDER BY rab01"

#modify by TQC-AA0109----END----
   PREPARE t302_precount FROM g_sql
   DECLARE t302_count CURSOR FOR t302_precount
 
END FUNCTION
 
FUNCTION t302_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t302_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t302_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t302_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t302_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t302_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t302_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t302_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL t302_b()   #FUN-B80085 add 
        #FUN-B80085 mark START
        #       IF g_flag_b = '1' THEN
        #          CALL t302_b1()
        #       ELSE
        #          CALL t302_b2()
        #       END IF
        #MOD-CA0204 -- remark start --
             ELSE
                LET g_action_choice = NULL
        #MOD-CA0204 -- remark end --
        #FUN-B80085 mark END  
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t302_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "organization" #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rab.rab02) THEN
                  CALl t302_1(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t302_yes()
            END IF
         
         #TQC-AC0326 add ----------begin-----------
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t302_w()
            END IF
         #TQC-AC0326 add -----------end------------
         
         WHEN "Memberlevel"    #會員促銷方式
            IF cl_chk_act_auth() THEN
           #FUN-BB0056 mark START
           #   IF NOT cl_null(g_rab.rab02)THEN
           #      CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,'')
           #   ELSE
           #      CALL cl_err('',-400,0)
           #   END IF              
           #FUN-BB0056 mark END  
           #FUN-BB0056 add START
              IF NOT cl_null(l_ac) AND  l_ac > 0 THEN 
                 IF NOT cl_null(g_rab.rab02) AND g_rac[l_ac].rac08 <> '0' THEN
                   #CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,'',g_rac[l_ac].rac08)  #FUN-C10008 mark
                    CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,g_rac[l_ac].rac04,g_rac[l_ac].rac08)  #FUN-C10008 add 
                 END IF
              END IF
           #FUN-BB0056 add END
              #CALL t302_sales()
            END IF

#TQC-A80167 ---begin
#       WHEN "void"
#           IF cl_chk_act_auth() THEN
#              CALL t302_void()
#           END IF
#TQC-A80167 ---end

        WHEN "issuance"              #發布
           IF cl_chk_act_auth() THEN
              CALL t302_iss()
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rac),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rab.rab02 IS NOT NULL THEN
                 LET g_doc.column1 = "rab02"
                 LET g_doc.value1 = g_rab.rab02
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rac TO s_rac.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '1'      #FUN-D30033 add
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0056 mark START 
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
#           CALL t302_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t302_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t302_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t302_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t302_fetch('L')
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

#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG
#        
#        #TQC-AC0326 add ----------begin-----------
#        ON ACTION undo_confirm
#           LET g_action_choice="undo_confirm"
#           EXIT DIALOG
#        #TQC-AC0326 add -----------end------------ 
#        
#TQC-A80167 ---begin
#        ON ACTION void
#           LET g_action_choice="void"
#           EXIT DIALOG
#TQC-A80167 --end

#        ON ACTION issuance                    #發布      
#           LET g_action_choice = "issuance"  
#           EXIT DIALOG
#                                                                                                                                   
#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

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
#FUN-BB0056 mark END
      END DISPLAY

#FUN-BB0056 add START
      DISPLAY ARRAY g_rak TO s_rak.* ATTRIBUTE(COUNT=g_rec_b1)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'     #FUN-D30033 add      
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY
#FUN-BB0056 add END 
    
      DISPLAY ARRAY g_rad TO s_rad.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '3'     #FUN-D30033 add
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0056 mark START 
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
#           CALL t302_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t302_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t302_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t302_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t302_fetch('L')
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
#TQC-A80167 ---begin
#        ON ACTION void
#           LET g_action_choice="void"
#           EXIT DIALOG
#TQC-A80167 --end
#
#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

#        ON ACTION issuance                    #發布      
#           LET g_action_choice = "issuance"  
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
      END DISPLAY 

#FUN-BB0056 add START
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
            CALL t302_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION previous
            CALL t302_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION jump
            CALL t302_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION next
            CALL t302_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION last
            CALL t302_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         ON ACTION reproduce  #FUN-CC0129 add
            LET g_action_choice="reproduce"
            EXIT DIALOG
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG

         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG

         ON ACTION Memberlevel                 #會員促銷
            LET g_action_choice="Memberlevel"
            EXIT DIALOG

         ON ACTION issuance                    #發布
            LET g_action_choice = "issuance"
            EXIT DIALOG

         ON ACTION organization                #生效機構
            LET g_action_choice =  "organization"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
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
#FUN-BB0056 add END
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t302_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rac.clear()
   CALL g_rad.clear() #TQC-AC0193 add
   CALL g_rak.clear()   #FUN-BB0056 add
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL cl_set_comp_visible("rac05,rac06,rac07",TRUE)
   CALL t302_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rab.* TO NULL
      RETURN
   END IF
 
   OPEN t302_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rab.* TO NULL
   ELSE
      OPEN t302_count
      FETCH t302_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t302_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t302_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t302_cs INTO g_rab.rab01,g_rab.rab02,g_rab.rabplant
      WHEN 'P' FETCH PREVIOUS t302_cs INTO g_rab.rab01,g_rab.rab02,g_rab.rabplant
      WHEN 'F' FETCH FIRST    t302_cs INTO g_rab.rab01,g_rab.rab02,g_rab.rabplant
      WHEN 'L' FETCH LAST     t302_cs INTO g_rab.rab01,g_rab.rab02,g_rab.rabplant
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
        FETCH ABSOLUTE g_jump t302_cs INTO g_rab.rab01,g_rab.rab02,g_rab.rabplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
      INITIALIZE g_rab.* TO NULL
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
 
   SELECT * INTO g_rab.* FROM rab_file 
       WHERE rab02 = g_rab.rab02 AND rab01 = g_rab.rab01
         AND rabplant = g_rab.rabplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rab_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rab.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rab.rabuser
   LET g_data_group = g_rab.rabgrup
   LET g_data_plant = g_rab.rabplant #TQC-A10128 ADD
 
   CALL t302_show()
 
END FUNCTION
 
FUNCTION t302_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE l_raa03   LIKE raa_file.raa03 
 
   LET g_rab_t.* = g_rab.*
   LET g_rab_o.* = g_rab.*
   DISPLAY BY NAME g_rab.rab01,g_rab.rab02,g_rab.rab03,  
                   g_rab.rab04,g_rab.rab05,g_rab.rab06,g_rab.rab07,
                   g_rab.rab08,g_rab.rab09,g_rab.rab10,g_rab.rab11,
                   g_rab.rabplant,g_rab.rabconf,g_rab.rabcond,g_rab.rabcont,
              #    g_rab.rabconu,g_rab.rab900,g_rab.rabmksg,           #FUN-AB0093  mark
                   #g_rab.rabconu,g_rab.rab901,g_rab.rab902,g_rab.rab900,g_rab.rabmksg,           #FUN-AB0093  add  #TQC-AB0161 mark     
                   g_rab.rabconu,#g_rab.rab901,g_rab.rab902,           #TQC-AB0161 add  #TQC-AC0326 mark  
                   g_rab.raboriu,g_rab.raborig,g_rab.rabuser,
                   g_rab.rabmodu,g_rab.rabacti,g_rab.rabgrup,
                   g_rab.rabdate,g_rab.rabcrat
 
   IF g_rab.rabconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rab.rabconf,"","","",g_chr,"")                                                                           
  #CALL cl_flow_notify(g_rab.rab01,'V') 

#FUN-C10008 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file
      WHERE raq01 = g_rab.rab01 AND raq02 = g_rab.rab02
        AND raq03 = '1' AND raqplant = g_rab.rabplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
#FUN-C10008 add END

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rab.rab01
   DISPLAY l_azp02 TO FORMONLY.rab01_desc
   SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rab.rab01 AND raa02 = g_rab.rab03
   DISPLAY l_raa03 TO FORMONLY.rab03_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rab.rabconu
   DISPLAY l_gen02 TO FORMONLY.rabconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rab.rabplant
   DISPLAY l_azp02 TO FORMONLY.rabplant_desc

   CALL cl_set_comp_visible("rac05,rac06,rac07",g_rab.rab04='N')
   CALL t302_b1_fill(g_wc1)
   CALL t302_b2_fill(g_wc2)
   CALL t302_b3_fill(g_wc3) #FUN-BB0056 add
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t302_b1_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT rac03,rac04,rac05,rac06,rac07,rac08,rac09, ",
       #        "       rac10,rac11,rac12,rac14,rac13,rac15,racacti,racpos ",   #FUN-BB0056 mark
               "        rac10,rac11,racacti,racpos ",        #FUN-BB0056 add
               "  FROM rac_file",
               " WHERE rac02 = '",g_rab.rab02,"' AND rac01 ='",g_rab.rab01,"' ",
               "   AND racplant = '",g_rab.rabplant,"'"
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rac03 "
 
   DISPLAY g_sql
 
   PREPARE t302_pb FROM g_sql
   DECLARE rac_cs CURSOR FOR t302_pb
 
   CALL g_rac.clear()
   LET g_cnt = 1
 
   FOREACH rac_cs INTO g_rac[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       CASE g_rac[g_cnt].rac04
          WHEN '1'
             LET g_rac[g_cnt].rac07=NULL
             LET g_rac[g_cnt].rac11=NULL
             IF g_rac[g_cnt].rac08='Y' THEN
                LET g_rac[g_cnt].rac09=NULL
             END IF
          WHEN '2'
             LET g_rac[g_cnt].rac05=NULL
             LET g_rac[g_cnt].rac07=NULL
             LET g_rac[g_cnt].rac09=NULL
             LET g_rac[g_cnt].rac11=NULL
          WHEN '3'
             LET g_rac[g_cnt].rac05=NULL
             LET g_rac[g_cnt].rac09=NULL
             IF g_rac[g_cnt].rac08='Y' THEN
                LET g_rac[g_cnt].rac11=NULL
             END IF
       END CASE   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL cl_set_comp_visible("rac05,rac06,rac07",g_rab.rab04='N')
   CALL g_rac.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t302_b2_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rad03,rad04,rad05,'',rad06,'',radacti",
               "  FROM rad_file",
               " WHERE rad02 = '",g_rab.rab02,"' AND rad01 ='",g_rab.rab01,"' ",
               "   AND radplant = '",g_rab.rabplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rad03 "
 
   DISPLAY g_sql
 
   PREPARE t302_pb1 FROM g_sql
   DECLARE rad_cs CURSOR FOR t302_pb1
 
   CALL g_rad.clear()
   LET g_cnt = 1
 
   FOREACH rad_cs INTO g_rad[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gfe02 INTO g_rad[g_cnt].rad06_desc FROM gfe_file
           WHERE gfe01 = g_rad[g_cnt].rad06

       CALL t302_rad05('d',g_cnt)
      #CALL t302_rad06('d')

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rad.deleteElement(g_cnt)
 
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
#FUN-BB0056 add START
FUNCTION t302_b3_fill(p_wc3) 
DEFINE p_wc3   STRING

   CALL t302_rad04_combo()  #FUN-C30154 add  #顯示之前先將下拉選項重新產生一遍,避免名稱不顯示的問題

   LET g_sql = "SELECT rak04,rak05, rak06, rak07, rak08, rak09, rak10, rak11, rakacti ",
               "  FROM rak_file",
               " WHERE rak02 = '",g_rab.rab02,"' AND rak01 ='",g_rab.rab01,"' ",
               "   AND rakplant = '",g_rab.rabplant,"'",
               "   AND rak03 = '1'"

   IF NOT cl_null(p_wc3) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rak04 "

   DISPLAY g_sql

   PREPARE t302_pb2 FROM g_sql
   DECLARE rak_cs CURSOR FOR t302_pb2

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

FUNCTION t302_set_entry_rak(p_ac)
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
FUNCTION t302_chk_rad_repeat(p_ac)
DEFINE p_ac          LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
   LET g_errno = ' '
   IF g_rad[p_ac].rad03 = g_rad_t.rad03  AND
      g_rad[p_ac].rad04 = g_rad_t.rad04  AND
      g_rad[p_ac].rad05 = g_rad_t.rad05  THEN
      RETURN
   END IF
   IF (NOT cl_null(g_rad[p_ac].rad03)) AND
      (NOT cl_null(g_rad[p_ac].rad04)) AND 
      (NOT cl_null(g_rad[p_ac].rad05)) THEN     
      SELECT COUNT(*) INTO l_n FROM rad_file     
        WHERE rad01 =g_rab.rab01 AND rad02 = g_rab.rab02
          AND rad03 = g_rad[p_ac].rad03              
          AND rad04 = g_rad[p_ac].rad04
          AND rad05 = g_rad[p_ac].rad05
          AND radplant = g_rab.rabplant           
      IF l_n > 0 THEN                                                                       
          LET g_errno = '-239' 
      END IF               
   END IF  
END FUNCTION
#FUN-BB0056 add END
FUNCTION t302_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_rac.clear() 
   CALL g_rad.clear()
   CALL g_rak.clear()  #FUN-BB0056 add
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rab.* LIKE rab_file.*
   LET g_rab_t.* = g_rab.*
   LET g_rab_o.* = g_rab.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rab.rab01 = g_plant
      LET g_rab.rab04 = 'N'
      LET g_rab.rab05 = 'N'
      LET g_rab.rab06 = 'Y'
      LET g_rab.rab07 = 'N'
      LET g_rab.rab08 = 'N'
      LET g_rab.rab09 = 'N'
      LET g_rab.rab10 = 'N'
      LET g_rab.rab900   = '0'
      LET g_rab.rabacti  ='Y'
      LET g_rab.rabconf  = 'N'
      LET g_rab.rabmksg  = 'N'
      LET g_rab.rabuser  = g_user
      LET g_rab.raboriu  = g_user  
      LET g_rab.raborig  = g_grup  
      LET g_rab.rabgrup  = g_grup
      LET g_rab.rabcrat  = g_today
      LET g_rab.rabplant = g_plant
      LET g_rab.rablegal = g_legal
      LET g_data_plant   = g_plant #TQC-A10128 ADD

      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rab.rab01
      DISPLAY l_azp02 TO rab01_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rab.rabplant
      DISPLAY l_azp02 TO rabplant_desc
     #SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rab.rab06
     #DISPLAY l_gen02 TO rab06_desc

      CALL t302_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rab.* TO NULL
         LET INT_FLAG = 0
         CLEAR FORM        #TQC-B50153  
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rab.rab02) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rab.rab02,g_today,"A7","rab_file","rab02","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rab.rab02,g_today,"A7","rab_file","rab02","","","") #FUN-A70130 mod
         RETURNING li_result,g_rab.rab02 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rab.rab02
      INSERT INTO rab_file VALUES (g_rab.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rab_file",g_rab.rab02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK           #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
                      VALUES (g_rab.rab01,g_rab.rab02,'1',g_rab.rab01,'N','Y',g_rab.rabplant,g_legal)
         # FUN-B80085增加空白行



         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #   ROLLBACK WORK          #FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","raq_file",g_rab.rab01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK           #FUN-B80085--add--
            CONTINUE WHILE
         ELSE 
            COMMIT WORK
            CALL cl_flow_notify(g_rab.rab02,'I')
         END IF
      END IF


 
      SELECT * INTO g_rab.* FROM rab_file
       WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
         AND rabplant = g_rab.rabplant  
      LET g_rab_t.* = g_rab.*
      LET g_rab_o.* = g_rab.*     
      CALl t302_1(g_rab.rab01,g_rab.rab02,'1',
                  g_rab.rabplant,g_rab.rabconf) 
      CALL g_rac.clear()
      CALL g_rad.clear()
      CALL g_rak.clear()  #FUN-BB0056 add
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0  #FUN-BB0056 add
  #    CALL t302_b1()  #FUN-B80085 mark
    # IF g_rab.rab03 = '1' THEN CALL t302_sales() END IF 
  #    CALL t302_b2()  #FUN-B80085 mark
      CALL t302_b() 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t302_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
DEFINE l_docno     LIKE rab_file.rab02  #FUN-BB0056 add

   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rab.rab01,g_rab.rab02,g_rab.rab03,g_rab.rab04,g_rab.rab05,
                   g_rab.rab06,g_rab.rab07,g_rab.rab08,g_rab.rab09,g_rab.rab10,
                   g_rab.rab11,
                   #g_rab.rabplant,g_rab.rabconf,g_rab.rabmksg,g_rab.rab900,   #TQC-AB0161 mark
                   g_rab.rabplant,g_rab.rabconf,               #TQC-AB0161 add
                   g_rab.rabuser,g_rab.rabmodu,g_rab.rabgrup,g_rab.rabdate,
                   g_rab.rabacti,g_rab.rabcrat,g_rab.raboriu,g_rab.raborig
 
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME g_rab.rab02,g_rab.rab03,g_rab.rab11,g_rab.rab04,g_rab.rab05,
                #g_rab.rab06,g_rab.rabmksg,g_rab.rab07,g_rab.rab08,g_rab.rab09,  #TQC-AB0161 MARK
                 g_rab.rab06,g_rab.rab07,g_rab.rab08,g_rab.rab09,  #TQC-AB0161 add
                 g_rab.rab10
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t302_set_entry(p_cmd)
         CALL t302_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rab02")
          
      AFTER FIELD rab02  #促銷單號
         IF NOT cl_null(g_rab.rab02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rab.rab02 <> g_rab_t.rab02) THEN     
#              CALL s_check_no("axm",g_rab.rab02,g_rab_t.rab02,"A7","rab_file","rab01,rab02,rabplant","")  #FUN-A70130 mark
               CALL s_check_no("art",g_rab.rab02,g_rab_t.rab02,"A7","rab_file","rab01,rab02,rabplant","")  #FUN-A70130 mod
                    RETURNING li_result,g_rab.rab02
               IF (NOT li_result) THEN                                                            
                  LET g_rab.rab02=g_rab_t.rab02                                                                 
                  NEXT FIELD rab02                                                                                     
               END IF
              #TQC-AB0161 ADD------- 抓取單據是否做簽核，因g_rab.rab02會多"_"所以用substr取前三碼----------------
               LET l_docno = g_rab.rab02
               LET l_docno = l_docno[1,3]
               #SELECT oayapr INTO g_rab.rabmksg FROM oay_file   #TQC-AB0161 mark
               # WHERE oayslip = l_docno
               #DISPLAY BY NAME g_rab.rabmksg
              #TQC-AB0161 ADD-------------------------
            END IF
         END IF

      AFTER FIELD rab03  #活動代碼
         IF NOT cl_null(g_rab.rab03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                   
               g_rab.rab03 != g_rab_o.rab03 OR cl_null(g_rab_o.rab03)) THEN               
               CALL t302_rab03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rab03:',g_errno,0)
                  LET g_rab.rab03 = g_rab_t.rab03
                  DISPLAY BY NAME g_rab.rab03
                  NEXT FIELD rab03
               ELSE
                  LET g_rab_o.rab03 = g_rab.rab03
               END IF
            END IF
         ELSE
            LET g_rab_o.rab03 = ''
            CLEAR rab03_desc           
         END IF
 
     ON CHANGE rab04 
        IF NOT cl_null(g_rab.rab04) THEN
           CALL cl_set_comp_visible("rac05,rac06,rac07",g_rab.rab04='N')
        END IF
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rab02)                                                                                                      
              LET g_t1=s_get_doc_no(g_rab.rab02)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A7','art') RETURNING g_t1           #FUN-A70130                                                      
              LET g_rab.rab02 = g_t1                                                                                                
              DISPLAY BY NAME g_rab.rab02                                                                                           
              NEXT FIELD rab02
            WHEN INFIELD(rab03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_raa02"
               LET g_qryparam.arg1 =g_plant
               LET g_qryparam.default1 = g_rab.rab03
               CALL cl_create_qry() RETURNING g_rab.rab03
               DISPLAY BY NAME g_rab.rab03
               CALL t302_rab03('d')
               NEXT FIELD rab03
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t302_rab03(p_cmd)
DEFINE l_raa03        LIKE raa_file.raa03 
DEFINE l_raaacti      LIKE raa_file.raaacti
DEFINE l_raaconf      LIKE raa_file.raaconf 
DEFINE p_cmd          LIKE type_file.chr1

   SELECT raa03,raaacti,raaconf INTO l_raa03,l_raaacti,l_raaconf FROM raa_file
    WHERE raa01 = g_rab.rab01 AND raa02 = g_rab.rab03

  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196' 
                              LET l_raa03=NULL 
     WHEN l_raaacti='N'       LET g_errno='9028'    
     WHEN l_raaconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_raa03 TO FORMONLY.rab03_desc
  END IF
 
END FUNCTION

FUNCTION t302_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rab.rab02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rab.* FROM rab_file 
      WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
        AND rabplant = g_rab.rabplant
   IF g_rab.rabacti ='N' THEN
      CALL cl_err(g_rab.rab02,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rab.rabconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
   #TQC-AC0326 add ---------begin----------
   IF g_rab.rab01 <> g_rab.rabplant THEN 
      CALL cl_err('','art-977',0) 
      RETURN 
   END IF
   #TQC-AC0326 add ----------end-----------
   IF g_rab.rabconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
      
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t302_cl INTO g_rab.*
   IF SQLCA.sqlcode THEN 
       CALL cl_err(g_rab.rab02,SQLCA.sqlcode,0)
       CLOSE t302_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t302_show()
 
   WHILE TRUE
      LET g_rab_o.* = g_rab.*
      LET g_rab.rabmodu=g_user
      LET g_rab.rabdate=g_today
 
      CALL t302_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rab.*=g_rab_t.*
         CALL t302_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE rab_file SET rab_file.* = g_rab.*
         WHERE rab02 = g_rab.rab02 AND rab01 = g_rab.rab01  
           AND rabplant = g_rab.rabplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rab_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t302_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rab.rab02,'U')
 
   CALL t302_b1_fill("1=1")
   CALL t302_b2_fill("1=1")
   CALL t302_b3_fill(" 1=1")  #FUN-BB0056 add

END FUNCTION
 

FUNCTION t302_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_rac08    LIKE rac_file.rac08    #FUN-BB0056 add
DEFINE l_sql      STRING                 #FUN-BB0056 add
DEFINE l_rac03    LIKE rac_file.rac03    #FUN-BB0056 add
   IF g_rab.rab02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ---------------- add ----------------- begin
   IF g_rab.rabconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rab.rabconf = 'X' THEN CALL cl_err(g_rab.rab01,'9024',0) RETURN END IF
   IF g_rab.rabacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF 
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ---------------- add ----------------- end
   SELECT * INTO g_rab.* FROM rab_file 
      WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
        AND rabplant = g_rab.rabplant
   IF g_rab.rabconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rab.rabconf = 'X' THEN CALL cl_err(g_rab.rab01,'9024',0) RETURN END IF 
   IF g_rab.rabacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
#單身一未維護資料,不允許確認 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rac_file
    WHERE rac02 = g_rab.rab02 AND rac01=g_rab.rab01
      AND racplant = g_rab.rabplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

#-TQC-B60071 ADD - BEGIN ----------------------------------
  #單身一中存在未維護資料範圍的組別，不允許確認！
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM rac_file
    WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
      AND racacti = 'Y' AND racplant = g_rab.rabplant
      AND rac03 NOT IN (SELECT rad03 FROM rad_file 
                         WHERE rad01 = g_rab.rab01 AND rad02 = g_rab.rab02
                           AND radacti = 'Y' AND radplant = g_rab.rabplant)
   IF l_cnt > 0 THEN
      CALL cl_err('','art-730',0)
      RETURN
   END IF 
#-TQC-B60071 ADD -  END  ----------------------------------

#FUN-BB0056 add START
  #促銷時段未維護資料 不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rak_file 
       WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02
         AND rakacti = 'Y' AND rakplant = g_rab.rabplant
         AND rak04 IN (SELECT rac03 FROM rac_file
                           WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                           AND racacti = 'Y' AND racplant = g_rab.rabplant)
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      CALL cl_err('','art-751',0)
      RETURN
   END IF
  #範圍未維護資料 不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rad_file
       WHERE rad01 = g_rab.rab01 AND rad02 = g_rab.rab02
         AND radacti = 'Y' AND radplant = g_rab.rabplant
         AND rad03 IN (SELECT rac03 FROM rac_file
                           WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                           AND racacti = 'Y' AND racplant = g_rab.rabplant)
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      CALL cl_err('','art-752',0)
      RETURN
   END IF
  #單身一中存在未維護促銷時段圍的組別，不允許確認！
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM rac_file
    WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
      AND racacti = 'Y' AND racplant = g_rab.rabplant
      AND rac03 NOT IN (SELECT rak04 FROM rak_file
                         WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02
                           AND rakacti = 'Y' AND rakplant = g_rab.rabplant)
   IF l_cnt > 0 THEN
      CALL cl_err('','art-753',0)
      RETURN
   END IF
  #組別設定有促銷方式,但該組別未設定會員促銷方式,不允許確認  
   LET l_sql = " SELECT rac03,rac08 FROM rac_file ",
               " WHERE rac01 = '",g_rab.rab01,"' AND rac02 = '",g_rab.rab02,"' ",
               " AND racacti = 'Y' AND racplant = '",g_rab.rabplant,"' ",
               " AND rac08 <> '0' "
   PREPARE t302_rac08 FROM l_sql
   DECLARE rac08_cs CURSOR FOR t302_rac08   
   FOREACH rac08_cs INTO l_rac03,l_rac08
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rap_file
         WHERE rap01  = g_rab.rab01 AND rap02 = g_rab.rab02
           AND rap03 = '1' 
           AND rap04 = l_rac03 AND rap09 = l_rac08   #FUN-BB0056 add
      IF l_cnt < 1 THEN
         CALL cl_err_msg('','art-754',l_rac03 CLIPPED,0)
         RETURN
      END IF 
   END FOREACH 
  #未維護生效營運中心  不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM raq_file 
       WHERE raq01 = g_rab.rab01 AND raq02 = g_rab.rab02
       AND raq03 = '1' AND raqplant = g_rab.rabplant 
       AND raqacti = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','art-755',0)
      RETURN
   END IF  
#FUN-BB0056 add END

#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t302_cl INTO g_rab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rab.rab02,SQLCA.sqlcode,0)
      CLOSE t302_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rab_file SET rabconf='Y',
                       rabcond=g_today, 
                       rabcont=g_time, 
                       rabconu=g_user
     WHERE  rab02 = g_rab.rab02 AND rab01=g_rab.rab01
       AND rabplant = g_rab.rabplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rab.rabconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rab.rab02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rab.* FROM rab_file 
      WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01 
        AND rabplant = g_rab.rabplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rab.rabconu
   DISPLAY BY NAME g_rab.rabconf                                                                                         
   DISPLAY BY NAME g_rab.rabcond                                                                                         
   DISPLAY BY NAME g_rab.rabcont                                                                                         
   DISPLAY BY NAME g_rab.rabconu
   DISPLAY l_gen02 TO FORMONLY.rabconu_desc
    #CKP
   IF g_rab.rabconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rab.rabconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rab.rab02,'V')
END FUNCTION
 
#TQC-A80167 ---mark
#FUNCTION t302_void()
#DEFINE l_n LIKE type_file.num5
 
#   IF s_shut(0) THEN RETURN END IF
#   SELECT * INTO g_rab.* FROM rab_file 
#      WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
#        AND rabplant = g_rab.rabplant
#   IF g_rab.rab02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   IF g_rab.rabconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#   IF g_rab.rabacti = 'N' THEN CALL cl_err(g_rab.rab02,'art-142',0) RETURN END IF
#   IF g_rab.rabconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF
#   BEGIN WORK
 
#   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t302_cl:", STATUS, 1)
#      CLOSE t302_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
 
#   FETCH t302_cl INTO g_rab.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rab.rab02,SQLCA.sqlcode,0)
#      CLOSE t302_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   IF cl_void(0,0,g_rab.rabconf) THEN
#      LET g_chr = g_rab.rabconf
#      IF g_rab.rabconf = 'N' THEN
#         LET g_rab.rabconf = 'X'
#      ELSE
#         LET g_rab.rabconf = 'N'
#      END IF
 
#      UPDATE rab_file SET rabconf=g_rab.rabconf,
#                          rabmodu=g_user,
#                          rabdate=g_today
#       WHERE rab01 = g_rab.rab01  AND rab02 = g_rab.rab02
#         AND rabplant = g_rab.rabplant  
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","rab_file",g_rab.rab01,"",SQLCA.sqlcode,"","up rabconf",1)
#          LET g_rab.rabconf = g_chr
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END IF
 
#   CLOSE t302_cl
#   COMMIT WORK
 
#   SELECT * INTO g_rab.* FROM rab_file WHERE rab01=g_rab.rab01 AND rab02 = g_rab.rab02 AND rabplant = g_rab.rabplant 
#   DISPLAY BY NAME g_rab.rabconf                                                                                        
 #  DISPLAY BY NAME g_rab.rabmodu                                                                                        
#   DISPLAY BY NAME g_rab.rabdate
#    #CKP
#   IF g_rab.rabconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   CALL cl_set_field_pic(g_rab.rabconf,"","","",g_chr,"")
 
#   CALL cl_flow_notify(g_rab.rab01,'V')
#END FUNCTION
#TQC-A80167 ---end

FUNCTION t302_bp_refresh()
#  DISPLAY ARRAY g_rac TO s_rac.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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

FUNCTION t302_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rab.rab02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rab.rabconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rab.rabconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      RETURN
   END IF
 
   FETCH t302_cl INTO g_rab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t302_show()
 
   IF cl_exp(0,0,g_rab.rabacti) THEN
      LET g_chr=g_rab.rabacti
      IF g_rab.rabacti='Y' THEN
         LET g_rab.rabacti='N'
      ELSE
         LET g_rab.rabacti='Y'
      END IF
 
      UPDATE rab_file SET rabacti=g_rab.rabacti,
                          rabmodu=g_user,
                          rabdate=g_today
       WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
         AND rabplant = g_rab.rabplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rab_file",g_rab.rab01,"",SQLCA.sqlcode,"","",1) 
         LET g_rab.rabacti=g_chr
      END IF
   END IF
 
   CLOSE t302_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rab.rab01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rabacti,rabmodu,rabdate
     INTO g_rab.rabacti,g_rab.rabmodu,g_rab.rabdate FROM rab_file
    WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
      AND rabplant = g_rab.rabplant

   DISPLAY BY NAME g_rab.rabacti,g_rab.rabmodu,g_rab.rabdate
 
END FUNCTION
 
FUNCTION t302_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rab.rab02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rab.* FROM rab_file
     WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
      AND rabplant = g_rab.rabplant
 
   IF g_rab.rabconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rab.rabconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rab.rabacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
  
   BEGIN WORK
 
   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t302_cl INTO g_rab.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t302_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rab01"      
       LET g_doc.value1 = g_rab.rab01    
       CALL cl_del_doc()              
      DELETE FROM rab_file WHERE rab02 = g_rab.rab02 AND rab01 = g_rab.rab01
                             AND rabplant = g_rab.rabplant
      DELETE FROM rac_file WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
                             AND racplant = g_rab.rabplant 
      DELETE FROM rad_file WHERE rad02 = g_rab.rab02 AND rad01 = g_rab.rab01
                             AND radplant = g_rab.rabplant
      DELETE FROM raq_file WHERE raq02 = g_rab.rab02 AND raq01 = g_rab.rab01
                             AND raqplant = g_rab.rabplant AND raq03='1'
      DELETE FROM rap_file WHERE rap02 = g_rab.rab02 AND rap01 = g_rab.rab01
                             AND rapplant = g_rab.rabplant AND rap03='1'
      DELETE FROM rak_file WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02    #FUN-BB0056 add
                             AND rakplant = g_rab.rabplant  AND rak03 = '1'     #FUN-BB0056 add
      CLEAR FORM
      CALL g_rac.clear() 
      CALL g_rad.clear()
      CALL g_rak.clear()  #FUN-BB0056 add
      OPEN t302_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t302_cs
         CLOSE t302_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t302_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t302_cs
         CLOSE t302_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t302_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t302_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t302_fetch('/')
      END IF
   END IF
 
   CLOSE t302_cl
   COMMIT WORK
   LET g_rec_b = 0 
   LET g_rec_b1 = 0
   LET g_rec_b2 = 0 
   CALL cl_flow_notify(g_rab.rab01,'D')
END FUNCTION

#FUN-BB0056 add START
FUNCTION t302_b()
DEFINE
    l_ac_t            LIKE type_file.num5,
    l_ac2_t           LIKE type_file.num5,
    l_n               LIKE type_file.num5,
    l_n1              LIKE type_file.num5,
    l_n2              LIKE type_file.num5,
    l_n3              LIKE type_file.num5,
    l_cnt             LIKE type_file.num5,
    l_lock_sw         LIKE type_file.chr1,
    p_cmd             LIKE type_file.chr1,
    l_misc            LIKE gef_file.gef01,
    l_allow_insert    LIKE type_file.num5,
    l_allow_delete    LIKE type_file.num5,
    l_pmc05           LIKE pmc_file.pmc05,
    l_pmc30           LIKE pmc_file.pmc30
DEFINE l_ima02        LIKE ima_file.ima02,
       l_ima44        LIKE ima_file.ima44,
       l_ima021       LIKE ima_file.ima021,
       l_imaacti      LIKE ima_file.imaacti
DEFINE  l_s           LIKE type_file.chr1000 
DEFINE  l_m           LIKE type_file.chr1000 
DEFINE  i             LIKE type_file.num5
DEFINE  l_s1          LIKE type_file.chr1000 
DEFINE  l_m1          LIKE type_file.chr1000 
DEFINE l_rtz04        LIKE rtz_file.rtz04
DEFINE l_azp03        LIKE azp_file.azp03
DEFINE l_line         LIKE type_file.num5
DEFINE l_sql1         STRING
DEFINE l_bamt         LIKE type_file.num5
DEFINE l_rxx04        LIKE rxx_file.rxx04 
DEFINE l_price        LIKE rac_file.rac05
DEFINE l_discount     LIKE rac_file.rac06
DEFINE l_date         LIKE rac_file.rac12
DEFINE l_time1        LIKE type_file.num5   
DEFINE l_time2        LIKE type_file.num5  
DEFINE l_ima25        LIKE ima_file.ima25
DEFINE l_ac1_t        LIKE type_file.num5
DEFINE l_rak05        LIKE rak_file.rak05
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_ac2          LIKE type_file.num5
DEFINE l_racpos       LIKE rac_file.racpos
   LET g_action_choice=""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_rab.rab02) THEN
      RETURN
   END IF

   SELECT * INTO g_rab.* FROM rab_file
    WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
      AND rabplant = g_rab.rabplant

   IF g_rab.rabacti ='N' THEN
      CALL cl_err(g_rab.rab01||g_rab.rab02,'mfg1000',0)
      RETURN
   END IF
    
   IF g_rab.rabconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF

   IF g_rab.rab01 <> g_rab.rabplant THEN 
      CALL cl_err('','art-977',0) 
      RETURN 
   END IF

   IF g_rab.rabconf = 'X' THEN                                                                                             
      CALL cl_err('','art-025',0)                                                                                          
      RETURN                                                                                                               
   END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT rac03,rac04,rac05,rac06,rac07,rac08,", 
                      "        rac09,rac10,rac11,racacti,racpos ",  
                      "  FROM rac_file ",
                      " WHERE rac01 = ? AND rac02=? AND rac03=? AND racplant = ? ",
                      " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_bcl CURSOR FROM g_forupd_sql  

   LET g_forupd_sql = "SELECT rad03,rad04,rad05,'',rad06,'',radacti", 
                      "  FROM rad_file ",
                      " WHERE rad01=? AND rad02=? AND rad03=? AND rad04=? AND rad05 = ? AND radplant = ? ",
                      " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3021_bcl CURSOR FROM g_forupd_sql  


   LET g_forupd_sql = "SELECT rak04,rak05, rak06,rak07,rak08,rak09, ",
                      " rak10,rak11,rakacti",
                      "  FROM rak_file ",
                      " WHERE rak01=? AND rak02=? AND rak03='1' AND rak04=? AND rakplant = ? AND rak05 = ? ",
                      " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3022_bcl CURSOR FROM g_forupd_sql

   LET l_line = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 #FUN-D30033---add---str---
   IF g_rec_b>0  THEN LET l_ac  = 1 END IF
   IF g_rec_b1>0 THEN LET l_ac1 = 1 END IF
   IF g_rec_b2>0 THEN LET l_ac2 = 1 END IF
 #FUN-D30033---add---end---
   DIALOG ATTRIBUTES(UNBUFFERED)

   INPUT ARRAY g_rac FROM s_rac.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          LET g_b_flag = '1'    #FUN-D30033 add

       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET p_cmd = ''
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          CALL t302_rac_entry(g_rac[l_ac].rac04)
          CALL cl_set_comp_visible("rac05,rac06,rac07",g_rab.rab04='N')

          BEGIN WORK
 
          OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
          IF STATUS THEN
             CALL cl_err("OPEN t302_cl:", STATUS, 1)
             CLOSE t302_cl
             ROLLBACK WORK
             RETURN
          END IF

          FETCH t302_cl INTO g_rab.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
             CLOSE t302_cl
             ROLLBACK WORK
             RETURN
          END IF

          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_rac_t.* = g_rac[l_ac].*  #BACKUP
             LET g_rac_o.* = g_rac[l_ac].*  #BACKUP
             IF p_cmd='u' THEN
                CALL cl_set_comp_entry("rac03",FALSE)
             ELSE
                CALL cl_set_comp_entry("rac03",TRUE)
             END IF   
             OPEN t302_bcl USING g_rab.rab01,g_rab.rab02,g_rac_t.rac03,g_rab.rabplant
             IF STATUS THEN
                CALL cl_err("OPEN t302_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t302_bcl INTO g_rac[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rac_t.rac03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
          END IF 

       BEFORE INSERT
          DISPLAY "BEFORE INSERT!"
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_rac[l_ac].* TO NULL
          LET g_rac[l_ac].rac04 = '1'      #促銷方式 1:特價 2:折扣 3:折價   
          LET g_rac[l_ac].rac05 = 0        #特賣價   
          LET g_rac[l_ac].rac07 = 0        #折讓額 
          LET g_rac[l_ac].rac08 = '0'      #會員促銷方式 
          LET g_rac[l_ac].rac09 = 0        #會員特賣價    
          LET g_rac[l_ac].rac11 = 0        #會員折讓額 
          LET g_rac[l_ac].racacti = 'Y'    
          LET g_rac[l_ac].racpos = '1'     

          IF p_cmd='u' THEN
             CALL cl_set_comp_entry("rac03",FALSE)
          ELSE
             CALL cl_set_comp_entry("rac03",TRUE)
          END IF   
          CALL cl_set_comp_entry('rac05',TRUE)    
          LET g_rac_t.* = g_rac[l_ac].*
          LET g_rac_o.* = g_rac[l_ac].*
          CALL cl_show_fld_cont()
          NEXT FIELD rac03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
           
          INSERT INTO rac_file(rac01,rac02,rac03,rac04,rac05,rac06,
                               rac07,rac08,rac09,rac10,rac11,rac16,rac17,racacti,  
                               racpos,racplant,raclegal)   
          VALUES(g_rab.rab01,g_rab.rab02,
                 g_rac[l_ac].rac03,g_rac[l_ac].rac04,
                 g_rac[l_ac].rac05,g_rac[l_ac].rac06,
                 g_rac[l_ac].rac07,g_rac[l_ac].rac08,
                 g_rac[l_ac].rac09,g_rac[l_ac].rac10,
                 g_rac[l_ac].rac11,'N','N',g_rac[l_ac].racacti,  
                 g_rac[l_ac].racpos,g_rab.rabplant,g_rab.rablegal)   
                
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("ins","rac_file",g_rab.rab01,g_rac[l_ac].rac03,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             IF p_cmd='u' THEN
                CALL t302_upd_log()
             END IF
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
          END IF

       BEFORE FIELD rac03
          IF g_rac[l_ac].rac03 IS NULL OR g_rac[l_ac].rac03 = 0 THEN
             SELECT max(rac03)+1
               INTO g_rac[l_ac].rac03
               FROM rac_file
              WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
                AND racplant = g_rab.rabplant
             IF g_rac[l_ac].rac03 IS NULL THEN
                LET g_rac[l_ac].rac03 = 1
             END IF
          END IF

       AFTER FIELD rac03
           IF NOT cl_null(g_rac[l_ac].rac03) THEN
             IF g_rac[l_ac].rac03 != g_rac_t.rac03
                OR g_rac_t.rac03 IS NULL THEN
                SELECT count(*)
                  INTO l_n
                  FROM rac_file
                 WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
                   AND rac03 = g_rac[l_ac].rac03 AND racplant = g_rab.rabplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rac[l_ac].rac03 = g_rac_t.rac03
                   NEXT FIELD rac02
                END IF
             END IF
          END IF

     AFTER FIELD rac04
        IF NOT cl_null(g_rac[l_ac].rac04) THEN
           IF g_rac_o.rac04 IS NULL OR
              (g_rac[l_ac].rac04 != g_rac_o.rac04 ) THEN
              IF g_rac[l_ac].rac04 NOT MATCHES '[123]' THEN
                 LET g_rac[l_ac].rac04= g_rac_o.rac04
                 NEXT FIELD rac04
              ELSE
                 IF g_rac[l_ac].rac04='1' THEN 
                    CALL t302_rac04_check()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,1)
                       NEXT FIELD rac04
                    END IF 
                 END IF
                 CALL t302_rac_entry(g_rac[l_ac].rac04)
              END IF
           END IF
        END IF

     ON CHANGE rac04
        IF NOT cl_null(g_rac[l_ac].rac04) THEN
           CALL t302_chkrap()  #FUN-C10008 add
           CALL t302_rac_entry(g_rac[l_ac].rac04)
        END IF 

     AFTER FIELD rac08
        CALL t302_rac_entry(g_rac[l_ac].rac04) 
         

     ON CHANGE rac08
        IF NOT cl_null(g_rac[l_ac].rac08) THEN
           CALL t302_rac_entry(g_rac[l_ac].rac04)
           LET l_cnt =  0 
           SELECT COUNT(*) INTO l_cnt FROM rap_file 
              WHERE rap01 = g_rab.rab01 
                AND rap02 = g_rab.rab02
                AND rap03 = '1'
                AND rap04 = g_rac[l_ac].rac03
                AND rapplant = g_rab.rabplant
          #FUN-BB0056 add START
          #此會員促銷方式已經有設定資料,是否將設定資料刪除
           IF l_cnt > 0 THEN
              IF NOT cl_confirm('art-756') THEN 
                 LET g_rac[l_ac].rac08 = g_rac_t.rac08 
              ELSE
                 DELETE FROM rap_file 
                   WHERE rap01 = g_rab.rab01
                     AND rap02 = g_rab.rab02
                     AND rap03 = '1'
                     AND rap04 = g_rac[l_ac].rac03 
                     AND rapplant = g_rab.rabplant 
              END IF
           END IF
         #FUN-BB0056 add END
        END IF         

     BEFORE FIELD rac05,rac06,rac07,rac09,rac10,rac11
        IF NOT cl_null(g_rac[l_ac].rac04) THEN
           CALL t302_rac_entry(g_rac[l_ac].rac04)
        END IF

     AFTER FIELD rac05,rac09    #特賣價
        #No.MOD-CC0143  --Begin
        #IF g_rac[l_ac].rac03 = '1' THEN  #TQC-C40093 add
        IF g_rac[l_ac].rac04 = '1' THEN 
        #No.MOD-CC0143  --End  
           LET l_price = FGL_DIALOG_GETBUFFER()
           IF l_price <= 0 THEN
              CALL cl_err('','art-683',0)    
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rac[l_ac].rac05,g_rac[l_ac].rac09
           END IF
        END IF  #TQC-C40093 add

     AFTER FIELD rac06,rac10   #折扣率
          #No.MOD-CC0143  --Begin
          #IF g_rac[l_ac].rac03 = '2' THEN  #TQC-C40093 add
          IF g_rac[l_ac].rac04 = '2' THEN
          #No.MOD-CC0143  --End  
             LET l_discount = FGL_DIALOG_GETBUFFER()
             IF l_discount < 0 OR l_discount > 100 THEN
                CALL cl_err('','atm-384',0)
                NEXT FIELD CURRENT
             ELSE
                DISPLAY BY NAME g_rac[l_ac].rac06,g_rac[l_ac].rac10
             END IF
          END IF  #TQC-C40093 add

     AFTER FIELD rac07,rac11    #折讓額
        #No.MOD-CC0143  --Begin
        #IF g_rac[l_ac].rac03 = '3' THEN  #TQC-C40093 add
        IF g_rac[l_ac].rac04 = '3' THEN
        #No.MOD-CC0143  --End  
           LET l_price = FGL_DIALOG_GETBUFFER()
           IF l_price <= 0 THEN
              CALL cl_err('','art-653',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rac[l_ac].rac07,g_rac[l_ac].rac11           
           END IF
        END IF  #TQC-C40093 add
 
       BEFORE DELETE
          DISPLAY "BEFORE DELETE"
          IF g_rac_t.rac03 > 0 AND g_rac_t.rac03 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             SELECT COUNT(*) INTO l_n FROM rad_file
              WHERE rad01=g_rab.rab01 AND rad02=g_rab.rab02
                AND rad03=g_rac_t.rac03 AND radplant=g_rab.rabplant
             IF l_n>0 THEN
                CALL cl_err(g_rac_t.rac03,'art-664',0)
                CANCEL DELETE
             ELSE 
                SELECT COUNT(*) INTO l_n FROM rap_file
                 WHERE rap01=g_rab.rab01 AND rap02=g_rab.rab02 AND rap03='1'
                   AND rap04=g_rac_t.rac03 AND rapplant=g_rab.rabplant
                IF l_n>0 THEN
                   CALL cl_err(g_rac_t.rac03,'art-665',0)
                   CANCEL DELETE 
                END IF
             END IF
             IF g_aza.aza88='Y' THEN
               IF NOT ((g_rac[l_ac].racpos='3' AND g_rac[l_ac].racacti='N') 
                            OR (g_rac[l_ac].racpos='1'))  THEN                  
                    CALL cl_err('','apc-139',0)  
                    CANCEL DELETE
                    RETURN
                END IF     
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
            DELETE FROM rac_file
              WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
                AND rac03 = g_rac_t.rac03  AND racplant = g_rab.rabplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rac_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
             ELSE 
              	 DELETE FROM rad_file 
              	  WHERE rad01 = g_rab.rab01   AND rad02 = g_rab.rab02
                   AND rad03 = g_rac_t.rac03 AND radplant = g_rab.rabplant
                # FUN-B80085增加空白行                 

                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rad_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF 
             END IF
            CALL t302_upd_log() 
             LET g_rec_b=g_rec_b-1
          END IF
          COMMIT WORK

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rac[l_ac].* = g_rac_t.*
             CLOSE t302_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          IF cl_null(g_rac[l_ac].rac04) THEN
             NEXT FIELD rac04
          END IF
            
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_rac[l_ac].rac03,-263,1)
             LET g_rac[l_ac].* = g_rac_t.*
          ELSE
             IF g_aza.aza88='Y' THEN           
                IF g_rac[l_ac].racpos <> '1' THEN
                   LET g_rac[l_ac].racpos='2'
                END IF 
                DISPLAY BY NAME g_rac[l_ac].racpos
             END IF
             UPDATE rac_file SET rac04  =g_rac[l_ac].rac04,
                                 rac05  =g_rac[l_ac].rac05,
                                 rac06  =g_rac[l_ac].rac06,
                                 rac07  =g_rac[l_ac].rac07,
                                 rac08  =g_rac[l_ac].rac08,
                                 rac09  =g_rac[l_ac].rac09,
                                 rac10  =g_rac[l_ac].rac10,
                                 rac11  =g_rac[l_ac].rac11,
                                 racacti=g_rac[l_ac].racacti,
                                 racpos =g_rac[l_ac].racpos 
              WHERE rac02 = g_rab.rab02 AND rac01=g_rab.rab01
                AND rac03=g_rac_t.rac03 AND racplant = g_rab.rabplant
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rac_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
                LET g_rac[l_ac].* = g_rac_t.*
             ELSE
                MESSAGE 'UPDATE rac_file O.K'
                CALL t302_upd_log() 
                COMMIT WORK
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_rac[l_ac].* = g_rac_t.*
             END IF
             CLOSE t302_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          IF NOT cl_null(g_rab.rab02) THEN
             IF g_rac[l_ac].rac08 <> 0 THEN
                IF p_cmd = 'a' OR 
                   (p_cmd = 'u' AND g_rac[l_ac].rac08 <> g_rac_t.rac08 ) OR
                   (p_cmd = 'u' AND g_rac[l_ac].rac04 <> g_rac_t.rac04 )THEN  #FUN-BB0056 add
                  #CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,'',g_rac[l_ac].rac08)  #FUN-C10008 mark 
                   CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,g_rac[l_ac].rac04,g_rac[l_ac].rac08)  #FUN-C10008 add
                END IF
             END IF
          ELSE
             CALL cl_err('',-400,0)
          END IF
          CLOSE t302_bcl
          COMMIT WORK
          IF cl_null(g_rac[l_ac].rac05) THEN
             CALL g_rac.deleteelement(l_ac)
          END IF
   END INPUT

    INPUT ARRAY g_rak FROM s_rak.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_b_flag = '2'      #FUN-D30033 add
 
        BEFORE ROW
           LET l_ac2 = ARR_CURR()
           LET p_cmd = ''
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           CALL t302_set_entry_rak(l_ac2) 
 
           BEGIN WORK
 
           OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
           IF STATUS THEN
              CALL cl_err("OPEN t302_cl:", STATUS, 1)
              CLOSE t302_cl
              ROLLBACK WORK
              RETURN
           END IF

          #TQC-C20106 add START
           FETCH t302_cl INTO g_rab.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
              CLOSE t302_cl
              ROLLBACK WORK
              RETURN
           END IF
          #TQC-C20106 add END

           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_rak_t.* = g_rak[l_ac2].*  #BACKUP
              LET g_rak_o.* = g_rak[l_ac2].*  #BACKUP
              OPEN t3022_bcl USING g_rab.rab01,g_rab.rab02,g_rak_t.rak04,g_rab.rabplant,g_rak[l_ac2].rak05
              IF STATUS THEN
                 CALL cl_err("OPEN t3022_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t3022_bcl INTO g_rak[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rak_t.rak04,SQLCA.sqlcode,1)
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
           IF NOT cl_null(g_rab.rab03) THEN
              SELECT raa05,raa06 INTO g_rak[l_ac2].rak06,g_rak[l_ac2].rak07
                FROM raa_file
              WHERE raa01=g_rab.rab01 AND raa02=g_rab.rab03
           END IF
           IF cl_null(g_rak[l_ac2].rak06) THEN
              LET g_rak[l_ac2].rak06 = g_today        #促銷開始日期
           END IF
           IF cl_null(g_rak[l_ac2].rak07) THEN
              LET g_rak[l_ac2].rak07 = g_today        #促銷結束日期
           END IF
           IF l_ac2 = 1 THEN 
              SELECT MIN(rac03) INTO g_rak[l_ac2].rak04 FROM rac_file
                 WHERE rac01=g_rab.rab01 AND rac02=g_rab.rab02 AND racplant=g_rab.rabplant
           ELSE
              LET g_rak[l_ac2].rak04 = g_rak[l_ac2-1].rak04
           END IF
              DISPLAY BY NAME g_rak[l_ac2].rak04
           SELECT MAX(rak05) INTO g_rak[l_ac2].rak05 FROM rak_file
              WHERE rak01 = g_rab.rab01
                AND rak02 = g_rab.rab02
                AND rak04 = g_rak[l_ac2].rak04
                AND rak03 = '1'
           IF cl_null(g_rak[l_ac2].rak05) OR g_rak[l_ac2].rak05 = 0 THEN
              LET g_rak[l_ac2].rak05 = 1
           ELSE
              LET g_rak[l_ac2].rak05 = g_rak[l_ac2].rak05 + 1
           END IF
           DISPLAY BY NAME g_rak[l_ac2].rak05
           LET g_rak_t.* = g_rak[l_ac2].*
           LET g_rak_o.* = g_rak[l_ac2].*
           NEXT FIELD rak04
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF cl_null(g_rak[l_ac2].rak11) THEN
              LET g_rak[l_ac2].rak11 = ' '
           END IF    
           INSERT INTO rak_file(rak01,rak02,rak03,rak04,rak05,rak06,
                                rak07,rak08,rak09,rak10,rak11,rakacti,
                                rakcrdate,raklegal,rakplant,
                                rakpos)
           VALUES(g_rab.rab01,g_rab.rab02,
                  '1',g_rak[l_ac2].rak04,
                  g_rak[l_ac2].rak05,g_rak[l_ac2].rak06,
                  g_rak[l_ac2].rak07,g_rak[l_ac2].rak08,
                  g_rak[l_ac2].rak09,g_rak[l_ac2].rak10,
                  g_rak[l_ac2].rak11,g_rak[l_ac2].rakacti,
                  g_today,g_rab.rablegal,g_rab.rabplant,'1')
 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rak_file",g_rab.rab01,g_rak_t.rak04,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              SELECT racpos INTO l_racpos FROM rac_file
                  WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                    AND rac03 = g_rak[l_ac2].rak04 
             IF l_racpos <> '1' THEN
                LET l_racpos = '2'
             ELSE
                LET l_racpos = '1'
             END IF
             UPDATE rac_file SET racpos = l_racpos
                  WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                    AND rac03 = g_rak[l_ac2].rak04 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("ins","rak_file",g_rab.rab01,g_rak[l_ac2].rak04,SQLCA.sqlcode,"","",1)
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                LET g_rec_b2=g_rec_b2+1
             END IF
           END IF
            
       AFTER FIELD rak04
          IF NOT cl_null(g_rak[l_ac2].rak04) THEN
             SELECT COUNT(*) INTO l_cnt2 FROM rac_file
                       WHERE rac01 = g_rab.rab01
                         AND rac02 = g_rab.rab02
                         AND rac03 = g_rak[l_ac2].rak04     
             IF l_cnt2 < 1 THEN     
                CALL cl_err('','art-654',0)
                NEXT FIELD rak04
             END IF
             IF p_cmd = 'a' OR
                g_rak[l_ac2].rak04 <> g_rak_t.rak04 THEN
                SELECT MAX(rak05) INTO g_rak[l_ac2].rak05 FROM rak_file
                   WHERE rak01 = g_rab.rab01
                     AND rak02 = g_rab.rab02
                     AND rak04 = g_rak[l_ac2].rak04
                     AND rak03 = '1'
                IF cl_null(g_rak[l_ac2].rak05) OR g_rak[l_ac2].rak05 = 0 THEN
                   LET g_rak[l_ac2].rak05 = 1
                ELSE
                   LET g_rak[l_ac2].rak05 = g_rak[l_ac2].rak05 + 1
                END IF
             END IF
          END IF

        AFTER FIELD rak05
           IF NOT cl_null(g_rak[l_ac2].rak05) THEN
              LET l_cnt2 = 0
              IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_rak[l_ac2].rak05 <> g_rak_t.rak05 ) THEN
                 SELECT COUNT(*) INTO l_cnt2 FROM rak_file
                    WHERE rak01 = g_rab.rab01
                      AND rak02 = g_rab.rab02
                      AND rak03 = '1'
                      AND rak04 = g_rak[l_ac2].rak04
                      AND rak05 = g_rak[l_ac2].rak05
                 IF l_cnt2 > 0 THEN
                    CALL cl_err('','-239',0)
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
               CALL t302_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rak08
               ELSE
                 IF NOT cl_null(g_rak[l_ac2].rak09) THEN
                    CALL t302_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
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
                CALL t302_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                   NEXT FIELD rac15
                ELSE
                  IF NOT cl_null(g_rak[l_ac2].rak08) THEN
                      CALL t302_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
                     IF l_time1>=l_time2 THEN
                         CALL cl_err('','art-207',0)
                         NEXT FIELD rak08
                      END IF
                   END IF
                END IF
            END IF
         END IF
 
        ON CHANGE rak10 
           CALL t302_set_entry_rak(l_ac2)
 
        ON CHANGE rak11
           CALL t302_set_entry_rak(l_ac2)
 
        AFTER ROW
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rak[l_ac2].* = g_rak_t.*
              END IF
              CLOSE t3022_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
 
           IF NOT cl_null(g_rak[l_ac2].rak06) AND NOT cl_null(g_rak[l_ac2].rak07) THEN
              IF g_rak[l_ac2].rak07<g_rak[l_ac2].rak06 THEN
                 CALL cl_err('','art-201',0)
                 NEXT FIELD rak07
              END IF
           END IF
           CLOSE t3022_bcl
           COMMIT WORK
 
       BEFORE DELETE 
          IF g_rak_t.rak04 > 0 AND NOT cl_null(g_rak_t.rak04) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM rak_file
              WHERE rak02 = g_rab.rab02 AND rak01 = g_rab.rab01
                AND rak03 = '1' AND rak04 = g_rak_t.rak04
                AND rak05 = g_rak[l_ac2].rak05
                AND rakplant = g_rab.rabplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rak_file",g_rab.rab01,g_rak_t.rak04,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             CALL t302_upd_log() 
             IF p_cmd = 'u' THEN  #TQC-C20336 add
                LET g_rec_b2 = g_rec_b2 - 1
             END IF  #TQC-C20336 add
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
             CLOSE t3022_bcl       
             ROLLBACK WORK   
             EXIT DIALOG  
          END IF
          IF cl_null(g_rak[l_ac2].rak11) THEN 
             LET g_rak[l_ac2].rak11 = ' '
          END IF
          IF l_lock_sw = 'Y' THEN                  
             CALL cl_err(g_rak[l_ac2].rak04,-263,1)
             LET g_rak[l_ac2].* = g_rak_t.*                   
          ELSE                                
             UPDATE rak_file SET rak04 = g_rak[l_ac2].rak04,
                                 rak06 = g_rak[l_ac2].rak06,
                                 rak07 = g_rak[l_ac2].rak07,
                                 rak08 = g_rak[l_ac2].rak08,
                                 rak09 = g_rak[l_ac2].rak09,
                                 rak10 = g_rak[l_ac2].rak10,
                                 rak11 = g_rak[l_ac2].rak11,
                                 rakacti = g_rak[l_ac2].rakacti
              WHERE rak02 = g_rab.rab02 AND rak01 = g_rab.rab01
                AND rak03 = '1' AND rak04=g_rak_t.rak04 
                AND rak05 = g_rak[l_ac2].rak05  AND rakplant = g_rab.rabplant
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rak_file",g_rab.rab01,g_rak_t.rak04,SQLCA.sqlcode,"","",1)
                LET g_rak[l_ac2].* = g_rak_t.*
             ELSE
                SELECT racpos INTO l_racpos FROM rac_file
                  WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                    AND rac03 = g_rak[l_ac2].rak04 
                IF l_racpos <> '1' THEN
                   LET l_racpos = '2'
                ELSE
                   LET l_racpos = '1'
                END IF
               UPDATE rac_file SET racpos = l_racpos
                  WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                    AND rac03 = g_rak[l_ac2].rak04 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rak_file",g_rab.rab01,g_rak_t.rak04,SQLCA.sqlcode,"","",1)
                  LET g_rak[l_ac2].* = g_rak_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
             END IF
          END IF
    END INPUT


   INPUT ARRAY g_rad FROM s_rad.*                                                                                                                                   
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,       
                   APPEND ROW=l_allow_insert) 
           
      BEFORE INPUT     
         DISPLAY "BEFORE INPUT!"                                                                                                                                                    
         IF g_rec_b1 != 0 THEN                                                                                                                                                      
            CALL fgl_set_arr_curr(l_ac1)                                                                                                                                            
         END IF 
         LET g_b_flag = '3'       #FUN-D30033 add                                                                                                                                                                    
                                                                                                                                                                                       
      BEFORE ROW                                                                                                                                                                    
         LET l_ac1 = ARR_CURR()     
         LET p_cmd = ''
         LET l_lock_sw = 'N'            #DEFAUL
         LET l_n  = ARR_COUNT()                                                                                                                                                     
         LET p_cmd = ''
        #CALL t302_rad04_chk() #FUN-BB0056 mark 
                                                                                                                                                                            
         BEGIN WORK                                                                                                                                                                 
                                                                                                                                                                                    
         OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant                                                                                                                  
         IF STATUS THEN                                                                                                                                                             
            CALL cl_err("OPEN t302_cl:", STATUS, 1)                                                                                                                                 
            CLOSE t302_cl                                                                                                                                                           
            ROLLBACK WORK                                                                                                                                                           
            RETURN                                                                                                                                                                  
         END IF                                                                                                                                                                     
                                                                                                                                                                                       
         FETCH t302_cl INTO g_rab.*                                                                                                                                                 
         IF SQLCA.sqlcode THEN                                                                                                                                                      
            CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)                                                                                                                                
            CLOSE t302_cl                                                                                                                                                           
            ROLLBACK WORK                                                                                                                                                           
            RETURN                                                                                                                                                                  
         END IF                                                                                                                                                                     
                                                                                                                                                                                       
         IF g_rec_b1 >= l_ac1 THEN                                                                                                                                                  
            LET p_cmd='u'                                                                                                                                                           
            LET g_rad_t.* = g_rad[l_ac1].*  #BACKUP                                                                                                                                 
            LET g_rad_o.* = g_rad[l_ac1].*  #BACKUP                                                                                                                                 
            CALL t302_rad04()                                                                                                                                                       
            OPEN t3021_bcl USING g_rab.rab01,g_rab.rab02,g_rad_t.rad03,
                                 g_rad_t.rad04,g_rad_t.rad05,g_rab.rabplant   
            IF STATUS THEN                                                                                                                                                          
               CALL cl_err("OPEN t3021_bcl:", STATUS, 1)                                                                                                                            
               LET l_lock_sw = "Y"                                                                                                                                                  
            ELSE                                                                                                                                                                    
               FETCH t3021_bcl INTO g_rad[l_ac1].*                                                                                                                                  
               IF SQLCA.sqlcode THEN                                                                                                                                                
                  CALL cl_err(g_rad_t.rad03,SQLCA.sqlcode,1)                                                                                                                        
                  LET l_lock_sw = "Y"                                                                                                                                               
               END IF                                                                                                                                                               
               CALL t302_rad05('d',l_ac1)                                                                                                                                           
               CALL t302_rad06('d')                                                                                                                                                 
            END IF                                                                                                                                                                  
         END IF                                                                                                                                                                      
                                                                                                                                                                                       
      BEFORE INSERT                                                                                                                                                                 
         DISPLAY "BEFORE INSERT!"                                                                                                                                                   
         LET l_n = ARR_COUNT()                                                                                                                                                      
         LET p_cmd='a'                                                                                                                                                              
         INITIALIZE g_rad[l_ac1].* TO NULL  
        #FUN-C30154 add START
         LET g_rad[l_ac1].rad04   = '01'
         LET g_rad[l_ac1].radacti = 'Y'
         LET g_rad_t.* = g_rad[l_ac1].*
         LET g_rad_o.* = g_rad[l_ac1].*
        #iFUN-C30154 add END

         IF l_ac1 = 1 THEN
            SELECT MIN(rac03) INTO g_rad[l_ac1].rad03 FROM rac_file                                                                                                                    
               WHERE rac01=g_rab.rab01 AND rac02=g_rab.rab02 AND racplant=g_rab.rabplant 
         ELSE
            LET g_rad[l_ac1].rad03 = g_rad[l_ac1-1].rad03
         END IF 
        #FUN-C30154 mark                                                                                                                                                                                                                                                                                               
        #LET g_rad[l_ac1].rad04   = '01'                                                                                                                                
        #LET g_rad[l_ac1].radacti = 'Y'                                                                                                                                                                                                                                                                        
        #LET g_rad_t.* = g_rad[l_ac1].*                                                                                                                                             
        #LET g_rad_o.* = g_rad[l_ac1].*                                                                                                                                             
        #FUN-C30154 mark
         CALL cl_show_fld_cont()                                                                                                                                                    
         NEXT FIELD rad03                                                                                                                                                           
                                                                                                                                                                                       
      AFTER INSERT                                                                                                                                                                  
         DISPLAY "AFTER INSERT!"                                                                                                                                                    
         IF INT_FLAG THEN                                                                                                                                                           
            CALL cl_err('',9001,0)                                                                                                                                                  
            LET INT_FLAG = 0                                                                                                                                                        
            CANCEL INSERT                                                                                                                                                           
         END IF                                                                                                                                                                     
         INSERT INTO rad_file(rad01,rad02,rad03,rad04,rad05,rad06,                                                                                                                  
                              radacti,radplant,radlegal)                                                                                                                            
         VALUES(g_rab.rab01,g_rab.rab02,                                                                                                                                            
                g_rad[l_ac1].rad03,g_rad[l_ac1].rad04,                                                                                                                              
                g_rad[l_ac1].rad05,g_rad[l_ac1].rad06,                                                                                                                              
                g_rad[l_ac1].radacti,                                                                                                                                               
                g_rab.rabplant,g_rab.rablegal)                                                                                                                                      
                                                                                                                                                                                     
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                                                              
               CALL cl_err3("ins","rad_file",g_rab.rab01,g_rad[l_ac1].rad03,SQLCA.sqlcode,"","",1)                                                                                     
               CANCEL INSERT                                                                                                                                                           
            ELSE
               SELECT racpos INTO l_racpos FROM rac_file
                    WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                      AND rac03 = g_rad[l_ac1].rad03 AND rac04 = '1'
               IF l_racpos <> '1' THEN
                  LET l_racpos = '2'
               ELSE
                  LET l_racpos = '1'
               END IF
               UPDATE rac_file SET racpos = l_racpos
                    WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                      AND rac03 = g_rad[l_ac1].rad03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rad_file",g_rab.rab01,g_rad[l_ac1].rad03,SQLCA.sqlcode,"","",1)
                  LET g_rad[l_ac1].* = g_rad_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  LET g_rec_b1=g_rec_b1+1
               END IF                                                                                                                                                                       
            END IF                                                                                                                                                                     
                                                                                                                                                                                       
      AFTER FIELD rad03                                                                                                                                                               
         IF NOT cl_null(g_rad[l_ac1].rad03) THEN                                                                                                                                      
            IF g_rad_o.rad03 IS NULL OR                                                                                                                                               
               (g_rad[l_ac1].rad03 != g_rad_o.rad03 ) THEN                                                                                                                            
               CALL t302_rad03()    #檢查其有效性                                                                                                                                     
               IF NOT cl_null(g_errno) THEN                                                                                                                                           
                  CALL cl_err(g_rad[l_ac1].rad03,g_errno,0)                                                                                                                           
                  LET g_rad[l_ac1].rad03 = g_rad_o.rad03                                                                                                                              
                  NEXT FIELD rad03                                                                                                                                                    
               END IF                                                                                                                                                                 
               CALL t302_rad04_chk() 
            END IF 
            CALL t302_chk_rad_repeat(l_ac1) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rad03
            END IF 
         END IF             

      #FUN-C10008 add START
      ON CHANGE rad03
         CALL t302_rad04_chk() 
      #FUN-C10008 add END
                                                                                                                                                                                       
      BEFORE FIELD rad04                                                                                                                                                              
         IF NOT cl_null(g_rad[l_ac1].rad03) THEN                                                                                                                                      
            IF g_rad_o.rad03 IS NULL OR  #FUN-C30154 add
               (g_rad[l_ac1].rad03 != g_rad_o.rad03 ) THEN  #FUN-C30154 add
               CALL t302_rad04_chk() 
            END IF  #FUN-C30154 add
         END IF                                                                                                                                                                       
                                                                                                                                                                                       
      AFTER FIELD rad04                                                                                                                                                               
         IF NOT cl_null(g_rad[l_ac1].rad04) THEN                                                                                                                                      
            IF g_rad_o.rad04 IS NULL OR                                                                                                                                               
               (g_rad[l_ac1].rad04 != g_rad_o.rad04 ) THEN                                                                                                                            
               CALL t302_rad04()                                                                                                                    
            END IF
            CALL t302_chk_rad_repeat(l_ac1)            
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rad04
            END IF                                                                                                                                                        
         END IF                                                                                                                                                                       
                                                                                                                                                                                      
      ON CHANGE rad04                                                                                                                                                                 
         IF NOT cl_null(g_rad[l_ac1].rad04) THEN                                                                                                                                      
            LET g_rad[l_ac1].rad05=NULL                                                                                                                                               
            LET g_rad[l_ac1].rad05_desc=NULL                                                                                                                                          
            LET g_rad[l_ac1].rad06=NULL                                                                                                                                               
            LET g_rad[l_ac1].rad06_desc=NULL                                                                                                                                          
            DISPLAY BY NAME g_rad[l_ac1].rad05,g_rad[l_ac1].rad05_desc                                                                                                                
            DISPLAY BY NAME g_rad[l_ac1].rad06,g_rad[l_ac1].rad06_desc                                                                                                                
                                                                                                                                                                                       
            CALL t302_rad04()    
            CALL t302_chk_rad_repeat(l_ac1) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rad04
            END IF                                                                                                                                                    
         END IF                                                                                                                                                                       
                                                                                                                                                                                       
      BEFORE FIELD rad05,rad06                                                                                                                                                        
         IF NOT cl_null(g_rad[l_ac1].rad04) THEN                                                                                                                                      
            CALL t302_rad04()                                                                                                                                                              
         END IF                                                                                                                                                                       
                                                                                                                                                                                       
      AFTER FIELD rad05                                                                                                                                                               
         IF NOT cl_null(g_rad[l_ac1].rad05) THEN                                                                                                                                      
            IF g_rad[l_ac1].rad04 = '01' THEN #FUN-AB0033 add                                                                                                                            
               IF NOT s_chk_item_no(g_rad[l_ac1].rad05,"") THEN                                                                                                                          
                  CALL cl_err('',g_errno,1)                                                                                                                                              
                  LET g_rad[l_ac1].rad05= g_rad_t.rad05                                                                                                                                  
                  NEXT FIELD rad05                                                                                                                                                       
               END IF                                                                                                                                                                    
            END IF                                                                                                                                          
            IF g_rad_o.rad05 IS NULL OR                                                                                                                                               
               (g_rad[l_ac1].rad05 != g_rad_o.rad05 ) THEN                                                                                                                            
               CALL t302_rad05('a',l_ac1)                                                                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                                                                           
                  CALL cl_err(g_rad[l_ac1].rad05,g_errno,0)                                                                                                                           
                  LET g_rad[l_ac1].rad05 = g_rad_o.rad05                                                                                                                              
                  NEXT FIELD rad05                                                                                                                                                    
               END IF                                                                                                                                                                 
            END IF 
            CALL t302_chk_rad_repeat(l_ac1)    
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rad05
            END IF                                                                                                                                                               
         END IF                                                                                                                                                                       
                                                                                                                                                                                       
      AFTER FIELD rad06                                                                                                                                                               
         IF NOT cl_null(g_rad[l_ac1].rad06) THEN                                                                                                                                      
            IF g_rad_o.rad06 IS NULL OR                                                                                                                                               
               (g_rad[l_ac1].rad06 != g_rad_o.rad06 ) THEN                                                                                                                            
               CALL t302_rad06('a')                                                                                                                                                   
               IF NOT cl_null(g_errno) THEN                                                                                                                                           
                  CALL cl_err(g_rad[l_ac1].rad06,g_errno,0)                                                                                                                           
                  LET g_rad[l_ac1].rad06 = g_rad_o.rad06                                                                                                                              
                  NEXT FIELD rad06                                                                                                                                                    
               END IF                                                                                                                                                                 
            END IF                                                                                                                                                                    
         END IF                                                                                                                                                                       
                                                                                                                                                                                      
                                                                                                                                                                                       
      BEFORE DELETE                                                                                                                                                                 
         IF g_rad_t.rad03 > 0 AND g_rad_t.rad03 IS NOT NULL THEN                                                                                                                    
            IF NOT cl_delb(0,0) THEN                                                                                                                                                
               CANCEL DELETE                                                                                                                                                        
            END IF                                                                                                                                                                  
            IF l_lock_sw = "Y" THEN                                                                                                                                                 
               CALL cl_err("", -263, 1)                                                                                                                                             
               CANCEL DELETE                                                                                                                                                        
            END IF                                                                                                                                                                  
            DELETE FROM rad_file                                                                                                                                                    
             WHERE rad02 = g_rab.rab02 AND rad01 = g_rab.rab01                                                                                                                      
               AND rad03 = g_rad_t.rad03 AND rad04 = g_rad_t.rad04     
               AND rad05 = g_rad_t.rad05                                                                                                             
               AND radplant = g_rab.rabplant                                                                                                                                        
            IF SQLCA.sqlcode THEN                                                                                                                                                   
               CALL cl_err3("del","rad_file",g_rab.rab01,g_rad_t.rad03,SQLCA.sqlcode,"","",1)                                                                                       
               ROLLBACK WORK                                                                                                                                                        
               CANCEL DELETE                                                                                                                                                        
            END IF                                                                                                                                                                  
            LET g_rec_b1 = g_rec_b1 - 1                                                                                                                                                 
         END IF                                                                                                                                                                     
         COMMIT WORK                                                                                                                                                                
                                                                                                                                                                                     
      ON ROW CHANGE                                                                                                                                                                 
         IF INT_FLAG THEN                                                                                                                                                           
            CALL cl_err('',9001,0)                                                                                                                                                  
            LET INT_FLAG = 0                                                                                                                                                        
            LET g_rad[l_ac1].* = g_rad_t.*                                                                                                                                          
            CLOSE t3021_bcl                                                                                                                                                         
            ROLLBACK WORK                                                                                                                                                           
            EXIT DIALOG                                                                                                                                                              
         END IF                                                                                                                                                                     
                                                                                                                                                                                     
         IF l_lock_sw = 'Y' THEN                                                                                                                                                    
            CALL cl_err(g_rad[l_ac1].rad03,-263,1)                                                                                                                                  
            LET g_rad[l_ac1].* = g_rad_t.*                                                                                                                                          
         ELSE
            CALL t302_chk_rad_repeat(l_ac1)                                                                                                                                                                         
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rad05
            END IF
            IF g_rad[l_ac1].rad03 <> g_rad_t.rad03 OR
               g_rad[l_ac1].rad04 <> g_rad_t.rad04 OR 
               g_rad[l_ac1].rad05 <> g_rad_t.rad05 OR
               g_rad[l_ac1].rad06 <> g_rad_t.rad06 OR
               g_rad[l_ac1].radacti <> g_rad_t.radacti THEN 
               UPDATE rad_file SET rad03=g_rad[l_ac1].rad03,                                                                                                                           
                                   rad04=g_rad[l_ac1].rad04,                                                                                                                           
                                   rad05=g_rad[l_ac1].rad05,                                                                                                                           
                                   rad06=g_rad[l_ac1].rad06,                                                                                                                           
                                   radacti=g_rad[l_ac1].radacti                                                                                                                        
                WHERE rad02 = g_rab.rab02 AND rad01=g_rab.rab01                                                                                                                        
                  AND rad03 = g_rad_t.rad03 AND rad04=g_rad_t.rad04 
                  AND rad05 = g_rad_t.rad05
                  AND radplant = g_rab.rabplant                                                                                        
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                                                           
                  CALL cl_err3("upd","rad_file",g_rab.rab01,g_rad_t.rad03,SQLCA.sqlcode,"","",1)                                                                                       
                  LET g_rad[l_ac1].* = g_rad_t.*                                                                                                                                       
               ELSE 
                  SELECT racpos INTO l_racpos FROM rac_file
                       WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                         AND rac03 = g_rad[l_ac1].rad03 
                  IF l_racpos <> '1' THEN 
                     LET l_racpos = '2'
                  ELSE
                     LET l_racpos = '1'
                  END IF      
                  UPDATE rac_file SET racpos = l_racpos 
                       WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                         AND rac03 = g_rad[l_ac1].rad03 
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rad_file",g_rab.rab01,g_rad_t.rad03,SQLCA.sqlcode,"","",1)
                     LET g_rad[l_ac1].* = g_rad_t.*
                  ELSE                                                                                                                                                               
                     MESSAGE 'UPDATE O.K'                                                                                                                                                 
                     COMMIT WORK    
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
               LET g_rad[l_ac1].* = g_rad_t.*                                                                                                                                       
            END IF                                                                                                                                                                  
            CLOSE t3021_bcl                                                                                                                                                         
            ROLLBACK WORK                                                                                                                                                           
            EXIT DIALOG                                                                                                                                                              
         END IF                                                                                                                              
         CLOSE t3021_bcl                                                                                                                                                            
         COMMIT WORK                                                                                                                                                                
      END INPUT

      #FUN-D30033---add---str---
      BEFORE DIALOG
         CASE g_b_flag 
            WHEN '1'  NEXT FIELD rac04
            WHEN '2'  NEXT FIELD rak04
            WHEN '3'  NEXT FIELD rad03
         END CASE
            
      #FUN-D30033---add---end---     
 
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
         #FUN-D30033---add---str---
         IF g_b_flag = '1' THEN
            IF p_cmd = 'u' THEN
               LET g_rac[l_ac].* = g_rac_t.*
            ELSE
               CALL g_rac.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
         END IF
         IF g_b_flag = '2' THEN
            IF p_cmd = 'u' THEN
               LET g_rak[l_ac2].* = g_rak_t.*
            ELSE
               CALL g_rak.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac2 = l_ac2_t
               END IF
            END IF
         END IF
         IF g_b_flag = '3' THEN
            IF p_cmd = 'u' THEN
               LET g_rad[l_ac1].* = g_rad_t.*
            ELSE
               CALL g_rad.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac1 = l_ac1_t
               END IF
            END IF
         END IF
         #FUN-D30033---add---end---
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

      ON ACTION CONTROLO
         IF INFIELD(rac03) AND l_ac > 1 THEN
            LET g_rac[l_ac].* = g_rac[l_ac-1].*
            LET g_rac[l_ac].rac03 = g_rec_b + 1
            NEXT FIELD rac04
         END IF

        #FUN-C30151 add START
         IF INFIELD(rak04) AND l_ac2 > 1 THEN
            LET g_rak[l_ac2].* = g_rak[l_ac2-1].*
            NEXT FIELD rak04
         END IF
        #FUN-C30151 add END

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            WHEN INFIELD(rad05)
               CALL cl_init_qry_var()
               CASE g_rad[l_ac1].rad04
                  WHEN '01'
                 # ------------------ add -------------------- begin #add by MOD-CC0219
                      IF p_cmd = 'a' AND NOT cl_null(g_rad[l_ac1].rad03)      
                                     AND NOT cl_null(g_rad[l_ac1].rad04) THEN 
                         CALL q_sel_ima(TRUE, "q_ima_1","",g_rad[l_ac1].rad05,"","","","","",'' )
                         RETURNING g_multi_ima01
                         IF NOT cl_null(g_multi_ima01) THEN
                            CALL t302_multi_ima01()
                            IF g_success = 'N' THEN
                               NEXT FIELD rad05
                            END IF
                            CALL t302_b2_fill(' 1=1')
                            CALL t302_b()
                            EXIT DIALOG
                         END IF
                      ELSE
                 # ------------------ add -------------------- end by MOD-CC0219
                         CALL q_sel_ima(FALSE, "q_ima_1","",g_rad[l_ac1].rad05,"","","","","",'' )
                          RETURNING g_rad[l_ac1].rad05
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
               IF g_rad[l_ac1].rad04 != '01'  THEN
                  LET g_qryparam.default1 = g_rad[l_ac1].rad05
                  CALL cl_create_qry() RETURNING g_rad[l_ac1].rad05
               END IF
               CALL t302_rad05('d',l_ac1)
               NEXT FIELD rad05
            WHEN INFIELD(rad06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe02"
               SELECT DISTINCT ima25
                 INTO l_ima25
                 FROM ima_file
                WHERE ima01=g_rad[l_ac1].rad05
               LET g_qryparam.arg1 = l_ima25
               LET g_qryparam.default1 = g_rad[l_ac1].rad06
               CALL cl_create_qry() RETURNING g_rad[l_ac1].rad06
               CALL t302_rad06('d')
               NEXT FIELD rad06
            OTHERWISE EXIT CASE
          END CASE
   END DIALOG   
                  
   CLOSE t302_cl
   CLOSE t302_bcl
   CLOSE t3021_bcl
   CLOSE t3022_bcl
   CALL t302_delall() 
   CALL t302_b1_fill( " 1=1 ")
   CALL t302_b2_fill( " 1=1 ")
   CALL t302_b3_fill( " 1=1 ") 
END FUNCTION
#FUN-BB0056 add END
 
#FUN-BB0056 mark START
#FUNCTION t302_b1()
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
#
#DEFINE l_price    LIKE rac_file.rac05
#DEFINE l_discount LIKE rac_file.rac06
#DEFINE l_date     LIKE rac_file.rac12
#DEFINE l_time1    LIKE rac_file.rac14  #TQC-A80165
#DEFINE l_time2    LIKE rac_file.rac14  #TQC-A80165
#DEFINE l_time1    LIKE type_file.num5   #TQC-A80165  
#DEFINE l_time2    LIKE type_file.num5   #TQC-A80165

#   LET g_action_choice = ""
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_rab.rab02 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * INTO g_rab.* FROM rab_file
#    WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
#      AND rabplant = g_rab.rabplant
#
#   IF g_rab.rabacti ='N' THEN
#      CALL cl_err(g_rab.rab01||g_rab.rab02,'mfg1000',0)
#      RETURN
#   END IF
#   
#   IF g_rab.rabconf = 'Y' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rab.rab01 <> g_rab.rabplant THEN 
#      CALL cl_err('','art-977',0) 
#      RETURN 
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   IF g_rab.rabconf = 'X' THEN                                                                                             
#      CALL cl_err('','art-025',0)                                                                                          
#      RETURN                                                                                                               
#   END IF
#   CALL cl_opmsg('b')
#  #CALL s_showmsg_init()
#
#   LET g_forupd_sql = "SELECT rac03,rac04,rac05,rac06,rac07,rac08,", 
#                      "       rac09,rac10,rac11,rac12,rac14,rac13,rac15,racacti,racpos", 
#                      "  FROM rac_file ",
#                      " WHERE rac01 = ? AND rac02=? AND rac03=? AND racplant = ? ",
#                      " FOR UPDATE   "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t302_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#   LET l_line = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#
#   INPUT ARRAY g_rac WITHOUT DEFAULTS FROM s_rac.*
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
#          CALL t302_rac_entry(g_rac[l_ac].rac04)
#          CALL cl_set_comp_visible("rac05,rac06,rac07",g_rab.rab04='N')

#          BEGIN WORK
#
#          OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t302_cl:", STATUS, 1)
#             CLOSE t302_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          FETCH t302_cl INTO g_rab.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
#             CLOSE t302_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b >= l_ac THEN
#             LET p_cmd='u'
#             LET g_rac_t.* = g_rac[l_ac].*  #BACKUP
#             LET g_rac_o.* = g_rac[l_ac].*  #BACKUP
#             IF p_cmd='u' THEN
#                CALL cl_set_comp_entry("rac03",FALSE)
#             ELSE
#                CALL cl_set_comp_entry("rac03",TRUE)
#             END IF   
#             OPEN t302_bcl USING g_rab.rab01,g_rab.rab02,g_rac_t.rac03,g_rab.rabplant
#             IF STATUS THEN
#                CALL cl_err("OPEN t302_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#                FETCH t302_bcl INTO g_rac[l_ac].*
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rac_t.rac03,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#             END IF
#          END IF 

#       BEFORE INSERT
#          DISPLAY "BEFORE INSERT!"
#          LET l_n = ARR_COUNT()
#          LET p_cmd='a'
#          INITIALIZE g_rac[l_ac].* TO NULL
#          LET g_rac[l_ac].rac04 = '1'      #促銷方式 1:特價 2:折扣 3:折價   
#          LET g_rac[l_ac].rac05 = 0        #特賣價 
#         #LET g_rac[l_ac].rac06 = 100      #折扣率%        
#          LET g_rac[l_ac].rac07 = 0        #折讓額 
#          LET g_rac[l_ac].rac08 = 'N'      #會員等級促銷否 
#          LET g_rac[l_ac].rac09 = 0        #會員特賣價 
#         #LET g_rac[l_ac].rac10 = 100      #會員折扣率%        
#          LET g_rac[l_ac].rac11 = 0        #會員折讓額 
#          LET g_rac[l_ac].racacti = 'Y'    
#          LET g_rac[l_ac].racpos = '1' #NO.FUN-B40071    
#         #LET g_rac[l_ac].rac12 = g_today        #促銷開始日期 
#          LET g_rac[l_ac].rac14 = '00:00:00'     #促銷開始時間
#         #LET g_rac[l_ac].rac13 = g_today        #促銷結束日期 
#          LET g_rac[l_ac].rac15 = '23:59:59'     #促銷結束時間
#          IF NOT cl_null(g_rab.rab03) THEN
#             SELECT raa05,raa06 INTO g_rac[l_ac].rac12,g_rac[l_ac].rac13
#               FROM raa_file
#             WHERE raa01=g_rab.rab01 AND raa02=g_rab.rab03
#          END IF
#          IF cl_null(g_rac[l_ac].rac12) THEN
#             LET g_rac[l_ac].rac12 = g_today        #促銷開始日期
#          END IF   
#          IF cl_null(g_rac[l_ac].rac13) THEN
#             LET g_rac[l_ac].rac13 = g_today        #促銷結束日期
#          END IF

#          IF p_cmd='u' THEN
#             CALL cl_set_comp_entry("rac03",FALSE)
#          ELSE
#             CALL cl_set_comp_entry("rac03",TRUE)
#          END IF   
#          CALL cl_set_comp_entry('rac05',TRUE)    
#          LET g_rac_t.* = g_rac[l_ac].*
#          LET g_rac_o.* = g_rac[l_ac].*
#          CALL cl_show_fld_cont()
#          NEXT FIELD rac03
#
#       AFTER INSERT
#          DISPLAY "AFTER INSERT!"
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             CANCEL INSERT
#          END IF
#          
#          INSERT INTO rac_file(rac01,rac02,rac03,rac04,rac05,rac06,
#                               rac07,rac08,rac09,rac10,rac11,rac12,
#                               rac13,rac14,rac15,rac16,rac17,racacti,
#                               racpos,racplant,raclegal)   
#          VALUES(g_rab.rab01,g_rab.rab02,
#                 g_rac[l_ac].rac03,g_rac[l_ac].rac04,
#                 g_rac[l_ac].rac05,g_rac[l_ac].rac06,
#                 g_rac[l_ac].rac07,g_rac[l_ac].rac08,
#                 g_rac[l_ac].rac09,g_rac[l_ac].rac10,
#                 g_rac[l_ac].rac11,g_rac[l_ac].rac12,
#                 g_rac[l_ac].rac13,g_rac[l_ac].rac14,
#                 g_rac[l_ac].rac15,'N','N',g_rac[l_ac].racacti,
#                 g_rac[l_ac].racpos,g_rab.rabplant,g_rab.rablegal)   
#                
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err3("ins","rac_file",g_rab.rab01,g_rac[l_ac].rac03,SQLCA.sqlcode,"","",1)
#             CANCEL INSERT
#          ELSE
#             MESSAGE 'INSERT O.K'
#             IF p_cmd='u' THEN
#                CALL t302_upd_log()
#             END IF
#             COMMIT WORK
#             LET g_rec_b=g_rec_b+1
#          END IF
#
#       BEFORE FIELD rac03
#          IF g_rac[l_ac].rac03 IS NULL OR g_rac[l_ac].rac03 = 0 THEN
#             SELECT max(rac03)+1
#               INTO g_rac[l_ac].rac03
#               FROM rac_file
#              WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
#                AND racplant = g_rab.rabplant
#             IF g_rac[l_ac].rac03 IS NULL THEN
#                LET g_rac[l_ac].rac03 = 1
#             END IF
#          END IF
#
#       AFTER FIELD rac03
#          IF NOT cl_null(g_rac[l_ac].rac03) THEN
#             IF g_rac[l_ac].rac03 != g_rac_t.rac03
#                OR g_rac_t.rac03 IS NULL THEN
#                SELECT count(*)
#                  INTO l_n
#                  FROM rac_file
#                 WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
#                   AND rac03 = g_rac[l_ac].rac03 AND racplant = g_rab.rabplant
#                IF l_n > 0 THEN
#                   CALL cl_err('',-239,0)
#                   LET g_rac[l_ac].rac03 = g_rac_t.rac03
#                   NEXT FIELD rac02
#                END IF
#             END IF
#          END IF
#
#     AFTER FIELD rac04
#        IF NOT cl_null(g_rac[l_ac].rac04) THEN
#           IF g_rac_o.rac04 IS NULL OR
#              (g_rac[l_ac].rac04 != g_rac_o.rac04 ) THEN
#              IF g_rac[l_ac].rac04 NOT MATCHES '[123]' THEN
#                 LET g_rac[l_ac].rac04= g_rac_o.rac04
#                 NEXT FIELD rac04
#              ELSE
#                 IF g_rac[l_ac].rac04='1' THEN 
#                    CALL t302_rac04_check()
#                    IF NOT cl_null(g_errno) THEN
#                       CALL cl_err('',g_errno,1)
#                       NEXT FIELD rac04
#                    END IF 
#                 END IF
#                 CALL t302_rac_entry(g_rac[l_ac].rac04)
#              END IF
#           END IF
#        END IF

#     ON CHANGE rac04
#        IF NOT cl_null(g_rac[l_ac].rac04) THEN
#           CALL t302_rac_entry(g_rac[l_ac].rac04)
#        END IF         

#     ON CHANGE rac08
#        IF NOT cl_null(g_rac[l_ac].rac08) THEN
#           CALL t302_rac_entry(g_rac[l_ac].rac04)
#        END IF         

#     BEFORE FIELD rac05,rac06,rac07,rac09,rac10,rac11
#        IF NOT cl_null(g_rac[l_ac].rac04) THEN
#           CALL t302_rac_entry(g_rac[l_ac].rac04)
#        END IF

#     AFTER FIELD rac05,rac09    #特賣價
#        LET l_price = FGL_DIALOG_GETBUFFER()
#        IF l_price <= 0 THEN
#        #   CALL cl_err('','art-180',0)   #TQC-A90026 mark
#           CALL cl_err('','art-683',0)    #TQC-A90026 add
#           NEXT FIELD CURRENT
#        ELSE
#           DISPLAY BY NAME g_rac[l_ac].rac05,g_rac[l_ac].rac09
#          #DISPLAY BY NAME CURRENT
#        END IF

#     AFTER FIELD rac06,rac10   #折扣率
#          LET l_discount = FGL_DIALOG_GETBUFFER()
#          IF l_discount < 0 OR l_discount > 100 THEN
#             CALL cl_err('','atm-384',0)
#             NEXT FIELD CURRENT
#          ELSE
#             DISPLAY BY NAME g_rac[l_ac].rac06,g_rac[l_ac].rac10
#          END IF

#     AFTER FIELD rac07,rac11    #折讓額
#        LET l_price = FGL_DIALOG_GETBUFFER()
#        IF l_price <= 0 THEN
#           CALL cl_err('','art-653',0)
#           NEXT FIELD CURRENT
#        ELSE
#           DISPLAY BY NAME g_rac[l_ac].rac07,g_rac[l_ac].rac11
#          #DISPLAY BY NAME CURRENT
#        END IF
#     
#      #FUN-AB0033 mark ------------start----------------- 
#      #AFTER FIELD rac12,rac13  #開始,結束日期
#      #LET l_date = FGL_DIALOG_GETBUFFER()
#      #IF p_cmd='a' OR (p_cmd='u' AND 
#      #         (DATE(l_date)<>g_rac_t.rac12 OR DATE(l_date)<>g_rac_t.rac13)) THEN       
#      #        #(DATE(l_date)<>g_rac_t.rac12 AND DATE(l_date)<>g_rac_t.rac13)) THEN       
#      #      IF INFIELD(rac12) THEN
#      #         IF NOT cl_null(g_rac[l_ac].rac13) THEN
#      #            IF DATE(l_date)>g_rac[l_ac].rac13 THEN
#      #               CALL cl_err('','art-201',0)
#      #               NEXT FIELD rac12
#      #            END IF
#      #         END IF
#      #      END IF
#      #      IF INFIELD(rac13) THEN
#      #         IF NOT cl_null(g_rac[l_ac].rac12) THEN
#      #            IF DATE(l_date)<g_rac[l_ac].rac12 THEN
#      #               CALL cl_err('','art-201',0)
#      #               NEXT FIELD rac13
#      #            END IF
#      #         END IF
#      #      END IF 
#      #END IF    
#      #FUN-AB0033 mark -------------end------------------
#         
#      AFTER FIELD rac14  #開始時間
#        IF NOT cl_null(g_rac[l_ac].rac14) THEN
#           IF p_cmd = "a" OR                    
#                  (p_cmd = "u" AND g_rac[l_ac].rac14<>g_rac_t.rac14) THEN 
#              CALL t302_chktime(g_rac[l_ac].rac14) RETURNING l_time1
#              IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  NEXT FIELD rac14
#              ELSE
#                IF NOT cl_null(g_rac[l_ac].rac15) THEN
#                   CALL t302_chktime(g_rac[l_ac].rac15) RETURNING l_time2
#                   IF l_time1>=l_time2 THEN
#                      CALL cl_err('','art-207',0)
#                      NEXT FIELD rac14   
#                   END IF
#                END IF
#              END IF
#            END IF
#        END IF
#        
#      AFTER FIELD rac15  #結束時間
#        IF NOT cl_null(g_rac[l_ac].rac15) THEN
#           IF p_cmd = "a" OR                    
#                  (p_cmd = "u" AND g_rac[l_ac].rac15<>g_rac_t.rac15) THEN 
#               CALL t302_chktime(g_rac[l_ac].rac15) RETURNING l_time2
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  NEXT FIELD rac15
#               ELSE
#                  IF NOT cl_null(g_rac[l_ac].rac14) THEN
#                     CALL t302_chktime(g_rac[l_ac].rac14) RETURNING l_time1
#                     IF l_time1>=l_time2 THEN
#                        CALL cl_err('','art-207',0)
#                        NEXT FIELD rac15
#                     END IF
#                  END IF
#               END IF
#           END IF
#        END IF

#
#       BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_rac_t.rac03 > 0 AND g_rac_t.rac03 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             SELECT COUNT(*) INTO l_n FROM rad_file
#              WHERE rad01=g_rab.rab01 AND rad02=g_rab.rab02
#                AND rad03=g_rac_t.rac03 AND radplant=g_rab.rabplant
#             IF l_n>0 THEN
#                CALL cl_err(g_rac_t.rac03,'art-664',0)
#                CANCEL DELETE
#             ELSE 
#                SELECT COUNT(*) INTO l_n FROM rap_file
#                 WHERE rap01=g_rab.rab01 AND rap02=g_rab.rab02 AND rap03='1'
#                   AND rap04=g_rac_t.rac03 AND rapplant=g_rab.rabplant
#                IF l_n>0 THEN
#                   CALL cl_err(g_rac_t.rac03,'art-665',0)
#                   CANCEL DELETE 
#                END IF
#             END IF
#             IF g_aza.aza88='Y' THEN
#               #FUN-B40071 --START--
#                #IF NOT (g_rac[l_ac].racacti='N' AND g_rac[l_ac].racpos='Y') THEN
#                #   CALL cl_err('', 'art-648', 1)
#                #   CANCEL DELETE
#                #END IF
#                IF NOT ((g_rac[l_ac].racpos='3' AND g_rac[l_ac].racacti='N') 
#                            OR (g_rac[l_ac].racpos='1'))  THEN                  
#                    CALL cl_err('','apc-139',0)  
#                    CANCEL DELETE
#                    RETURN
#                END IF     
#               #FUN-B40071 --END--
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rac_file
#              WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
#                AND rac03 = g_rac_t.rac03  AND racplant = g_rab.rabplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rac_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
#                ROLLBACK WORK
#                CANCEL DELETE
#             ELSE 
#              	 DELETE FROM rad_file 
#              	  WHERE rad01 = g_rab.rab01   AND rad02 = g_rab.rab02
#                   AND rad03 = g_rac_t.rac03 AND radplant = g_rab.rabplant
#                 # FUN-B80085增加空白行                 

#                IF SQLCA.sqlcode THEN
#                   CALL cl_err3("del","rad_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
#                   ROLLBACK WORK
#                   CANCEL DELETE
#                END IF 
#             END IF
#             CALL t302_upd_log() 
#             LET g_rec_b=g_rec_b-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rac[l_ac].* = g_rac_t.*
#             CLOSE t302_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_rac[l_ac].rac04) THEN
#             NEXT FIELD rac04
#          END IF
#         #IF NOT cl_null(g_rac[l_ac].rac04) THEN
#             
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rac[l_ac].rac03,-263,1)
#             LET g_rac[l_ac].* = g_rac_t.*
#          ELSE
#             IF g_aza.aza88='Y' THEN
#               #FUN-B40071 --START--
#                #LET g_rac[l_ac].racpos='N'
#                IF g_rac[l_ac].racpos <> '1' THEN
#                   LET g_rac[l_ac].racpos='2'
#                END IF
#               #FUN-B40071 --END-- 
#                DISPLAY BY NAME g_rac[l_ac].racpos
#             END IF
#             UPDATE rac_file SET rac04  =g_rac[l_ac].rac04,
#                                 rac05  =g_rac[l_ac].rac05,
#                                 rac06  =g_rac[l_ac].rac06,
#                                 rac07  =g_rac[l_ac].rac07,
#                                 rac08  =g_rac[l_ac].rac08,
#                                 rac09  =g_rac[l_ac].rac09,
#                                 rac10  =g_rac[l_ac].rac10,
#                                 rac11  =g_rac[l_ac].rac11,
#                                 rac12  =g_rac[l_ac].rac12,
#                                 rac13  =g_rac[l_ac].rac13,
#                                 rac14  =g_rac[l_ac].rac14,
#                                 rac15  =g_rac[l_ac].rac15,
#                                 racacti=g_rac[l_ac].racacti,
#                                 racpos =g_rac[l_ac].racpos 
#              WHERE rac02 = g_rab.rab02 AND rac01=g_rab.rab01
#                AND rac03=g_rac_t.rac03 AND racplant = g_rab.rabplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rac_file",g_rab.rab01,g_rac_t.rac03,SQLCA.sqlcode,"","",1) 
#                LET g_rac[l_ac].* = g_rac_t.*
#             ELSE
#                IF g_rac[l_ac].rac12<>g_rac_t.rac12 OR
#                   g_rac[l_ac].rac13<>g_rac_t.rac13 OR
#                   g_rac[l_ac].rac14<>g_rac_t.rac14 OR
#                   g_rac[l_ac].rac15<>g_rac_t.rac15 THEN
#                   CALL t302_repeat(g_rac[l_ac].rac03)  #check
#                END IF 
#                MESSAGE 'UPDATE rac_file O.K'
#                CALL t302_upd_log() 
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
#                LET g_rac[l_ac].* = g_rac_t.*
#             END IF
#             CLOSE t302_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          
#          #FUN-AB0033 add ----------------start-------------------
#          IF NOT cl_null(g_rac[l_ac].rac12) AND NOT cl_null(g_rac[l_ac].rac12) THEN
#             IF g_rac[l_ac].rac13<g_rac[l_ac].rac12 THEN
#                CALL cl_err('','art-201',0)
#                NEXT FIELD rac12
#             END IF
#          END IF
#          #FUN-AB0033 add -----------------end--------------------
#          #MOD-AC0172 add --begin---------------------------
#          IF NOT cl_null(g_rab.rab02) THEN
#             IF g_rac[l_ac].rac08 = 'Y' THEN
#                CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,'')
#             END IF
#          ELSE
#             CALL cl_err('',-400,0)
#          END IF
#          #MOD-AC0172 add ---end---------------------------- 
#          CLOSE t302_bcl
#          COMMIT WORK
#
#       #MOD-AC0172 mark ----begin-------------------------------
#       #ON ACTION Memberlevel    #會員等級促銷
#       #   IF NOT cl_null(g_rab.rab02) THEN
#       #      CALl t302_2(g_rab.rab01,g_rab.rab02,'1',g_rab.rabplant,g_rab.rabconf,'')
#       #   ELSE
#       #      CALL cl_err('',-400,0)
#       #   END IF
#       #MOD-AC0172 mark -----end--------------------------------

#       ON ACTION CONTROLO
#          IF INFIELD(rac03) AND l_ac > 1 THEN
#             LET g_rac[l_ac].* = g_rac[l_ac-1].*
#             LET g_rac[l_ac].rac03 = g_rec_b + 1
#             NEXT FIELD rac04
#          END IF
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#
#      #ON ACTION controlp
#      #   CASE
#      #      WHEN INFIELD(rac04)
#      #      WHEN INFIELD(rac05)
#      #      WHEN INFIELD(rac06)
#      #      OTHERWISE EXIT CASE
#      #    END CASE
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
#   CLOSE t302_bcl
#   COMMIT WORK
#  #CALL s_showmsg()
#   CALL t302_delall()
#
#END FUNCTION
#FUN-BB0056 mark END
FUNCTION t302_upd_log()
   LET g_rab.rabmodu = g_user
   LET g_rab.rabdate = g_today
   UPDATE rab_file SET rabmodu = g_rab.rabmodu,
                       rabdate = g_rab.rabdate
    WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
      AND rabplant = g_rab.rabplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rab_file",g_rab.rabmodu,g_rab.rabdate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rab.rabmodu,g_rab.rabdate
   MESSAGE 'UPDATE rab_file O.K.'
END FUNCTION

FUNCTION t302_chktime(p_time)  #check 時間格式
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


FUNCTION t302_rac04_check()
DEFINE l_n   LIKE type_file.num5

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM rad_file
    WHERE rad01=g_rab.rab01
      AND rad02=g_rab.rab02
      AND radplant=g_rab.rabplant
      AND rad03=g_rac[l_ac].rac03
   #   AND rad04<>'1'
      AND rad04<>'01'     #FUN-A80104
   IF l_n>0 THEN
      LET g_errno ='art-670'  #促銷方式為特價時第二單身資料類型只能為產品，當前對應組別中有其他資料類型，請檢查！
   END IF   

END FUNCTION

FUNCTION t302_rac_entry(p_rac04)
DEFINE p_rac04    LIKE rac_file.rac04   

          CASE p_rac04
             WHEN '1'
                CALL cl_set_comp_entry("rac05",TRUE)
                CALL cl_set_comp_entry("rac06",FALSE)
                CALL cl_set_comp_entry("rac07",FALSE)
                LET g_rac[l_ac].rac06=''
                LET g_rac[l_ac].rac07=0
             WHEN '2'
                CALL cl_set_comp_entry("rac05",FALSE)
                CALL cl_set_comp_entry("rac06",TRUE)
                CALL cl_set_comp_entry("rac07",FALSE)
                LET g_rac[l_ac].rac05=0
                LET g_rac[l_ac].rac07=0
             WHEN '3'
                CALL cl_set_comp_entry("rac05",FALSE)
                CALL cl_set_comp_entry("rac06",FALSE)
                CALL cl_set_comp_entry("rac07",TRUE)
                LET g_rac[l_ac].rac05=0
                LET g_rac[l_ac].rac06=''
             OTHERWISE
                CALL cl_set_comp_entry("rac05",TRUE)
                CALL cl_set_comp_entry("rac06",TRUE)
                CALL cl_set_comp_entry("rac07",TRUE)
          END CASE
           
         #IF g_rac[l_ac].rac08='Y' THEN  #FUN-BB0056  mark 
          IF g_rac[l_ac].rac08 <> '0' THEN  #FUN-BB0056  add
             CALL cl_set_comp_entry("rac09,rac10,rac11",FALSE)
             LET g_rac[l_ac].rac09=0
             LET g_rac[l_ac].rac10=''
             LET g_rac[l_ac].rac11=0
          ELSE
             CASE p_rac04
                WHEN '1'
                   CALL cl_set_comp_entry("rac09",TRUE)
                   CALL cl_set_comp_entry("rac10",FALSE)
                   CALL cl_set_comp_entry("rac11",FALSE)
                   LET g_rac[l_ac].rac10=''
                   LET g_rac[l_ac].rac11=0
                WHEN '2'
                   CALL cl_set_comp_entry("rac09",FALSE)
                   CALL cl_set_comp_entry("rac10",TRUE)
                   CALL cl_set_comp_entry("rac11",FALSE)
                   LET g_rac[l_ac].rac09=0
                   LET g_rac[l_ac].rac11=0
                WHEN '3'
                   CALL cl_set_comp_entry("rac09",FALSE)
                   CALL cl_set_comp_entry("rac10",FALSE)
                   CALL cl_set_comp_entry("rac11",TRUE)
                   LET g_rac[l_ac].rac09=0
                   LET g_rac[l_ac].rac10=''
                OTHERWISE
                   CALL cl_set_comp_entry("rac09",TRUE)
                   CALL cl_set_comp_entry("rac10",TRUE)
                   CALL cl_set_comp_entry("rac11",TRUE)
             END CASE
          END IF
       
       CASE p_rac04
          WHEN '1'
             DISPLAY '' TO g_rac[l_ac].rac07
             DISPLAY '' TO g_rac[l_ac].rac11
             IF g_rac[l_ac].rac08='Y' THEN
                DISPLAY '' TO g_rac[l_ac].rac09  
             END IF
          WHEN '2'
             DISPLAY '' TO g_rac[l_ac].rac05
             DISPLAY '' TO g_rac[l_ac].rac07
             DISPLAY '' TO g_rac[l_ac].rac09
             DISPLAY '' TO g_rac[l_ac].rac11
          WHEN '3'
             DISPLAY '' TO g_rac[l_ac].rac05
             DISPLAY '' TO g_rac[l_ac].rac09
             IF g_rac[l_ac].rac08='Y' THEN
                DISPLAY '' TO g_rac[l_ac].rac11
             END IF
       END CASE   

           
END FUNCTION
#組別無資料時刪除全部資料
FUNCTION t302_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rac_file
    WHERE rac02 = g_rab.rab02 AND rac01 = g_rab.rab01
      AND racplant = g_rab.rabplant
   #FUN-C10008 add START
   IF g_cnt > 0 THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM rak_file
    WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02
      AND rakplant = g_rab.rabplant
      AND rak03 = '1'
   IF g_cnt > 0 THEN RETURN END IF 
   SELECT COUNT(*) INTO g_cnt FROM rad_file
    WHERE rad01 = g_rab.rab01 AND rad02 = g_rab.rab02
      AND radplant = g_rab.rabplant
   IF g_cnt > 0 THEN RETURN END IF
   #FUN-C10008 add END
 
  #IF g_cnt = 0 THEN  #FUN-C10008 mark
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rab_file WHERE rab01 = g_rab.rab01 AND rab02=g_rab.rab02 AND rabplant=g_rab.rabplant
      DELETE FROM raq_file WHERE raq01 = g_rab.rab01 AND raq02=g_rab.rab02 
                             AND raq03='1' AND raqplant=g_rab.rabplant
      DELETE FROM rak_file WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02    #FUN-BB0056 add 
                             AND rakplant = g_rab.rabplant  AND rak03 = '1'     #FUN-BB0056 add
      CALL g_rac.clear()
      INITIALIZE g_rab.* TO NULL #TQC-B50153
      CLEAR FORM                 #TQC-B50153
  #END IF  #FUN-C10008 mark 
END FUNCTION

#FUN-BB0056 mark START
#FUNCTION t302_b2()
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
#   IF g_rab.rab02 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * INTO g_rab.* FROM rab_file
#    WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
#      AND rabplant = g_rab.rabplant
#
#   IF g_rab.rabacti ='N' THEN
#      CALL cl_err(g_rab.rab01,'mfg1000',0)
#      RETURN
#   END IF
#   
#   IF g_rab.rabconf = 'Y' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   IF g_rab.rabconf = 'X' THEN                                                                                             
#      CALL cl_err('','art-025',0)                                                                                          
#      RETURN                                                                                                               
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rab.rab01 <> g_rab.rabplant THEN 
#      CALL cl_err('','art-977',0) 
#      RETURN 
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   CALL cl_opmsg('b')
#  #CALL s_showmsg_init()

#   LET g_forupd_sql = "SELECT rad03,rad04,rad05,'',rad06,'',radacti", 
#                      "  FROM rad_file ",
#                      " WHERE rad01=? AND rad02=? AND rad03=? AND rad04=? AND radplant = ? ",
#                      " FOR UPDATE   "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t3021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#
#   INPUT ARRAY g_rad WITHOUT DEFAULTS FROM s_rad.*
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
#          CALL t302_rad04_chk() 
#
#          BEGIN WORK
#
#          OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t302_cl:", STATUS, 1)
#             CLOSE t302_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          FETCH t302_cl INTO g_rab.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rab.rab01,SQLCA.sqlcode,0)
#             CLOSE t302_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b1 >= l_ac1 THEN
#             LET p_cmd='u'
#             LET g_rad_t.* = g_rad[l_ac1].*  #BACKUP
#             LET g_rad_o.* = g_rad[l_ac1].*  #BACKUP
#             CALL t302_rad04()   
#             OPEN t3021_bcl USING g_rab.rab01,g_rab.rab02,g_rad_t.rad03,g_rad_t.rad04,g_rab.rabplant
#             IF STATUS THEN
#                CALL cl_err("OPEN t3021_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#                FETCH t3021_bcl INTO g_rad[l_ac1].*
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rad_t.rad03,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#                CALL t302_rad05('d',l_ac1)
#                CALL t302_rad06('d')
#             END IF
#         END IF 
#          
#       BEFORE INSERT
#          DISPLAY "BEFORE INSERT!"
#          LET l_n = ARR_COUNT()
#          LET p_cmd='a'
#          INITIALIZE g_rad[l_ac1].* TO NULL
#          SELECT MIN(rac03) INTO g_rad[l_ac1].rad03 FROM rac_file
#           WHERE rac01=g_rab.rab01 AND rac02=g_rab.rab02 AND racplant=g_rab.rabplant

#         # LET g_rad[l_ac1].rad04   = '1'             #Body default
#          LET g_rad[l_ac1].rad04   = '01'            #FUN-A80104
#          LET g_rad[l_ac1].radacti = 'Y'             #Body default   
#         #LET g_rad[l_ac1].rad =  0
#         #LET g_rad[l_ac1].rad =  0 
#         #LET g_rad[l_ac1].rad = 1
#          LET g_rad_t.* = g_rad[l_ac1].*
#          LET g_rad_o.* = g_rad[l_ac1].*
#          CALL cl_show_fld_cont()
#          NEXT FIELD rad03
#
#       AFTER INSERT
#          DISPLAY "AFTER INSERT!"
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             CANCEL INSERT
#          END IF
#          IF (NOT cl_null(g_rad[l_ac1].rad03)) AND 
#             (NOT cl_null(g_rad[l_ac1].rad04)) THEN
#             SELECT COUNT(*) INTO l_n FROM rad_file
#              WHERE rad01 =g_rab.rab01 AND rad02 = g_rab.rab02
#                AND rad03 = g_rad[l_ac1].rad03 
#                AND rad04 = g_rad[l_ac1].rad04
#                AND radplant = g_rab.rabplant
#             IF l_n>0 THEN 
#                CALL cl_err('',-239,0)
#                NEXT FIELD rad03
#             END IF
#          END IF
#          INSERT INTO rad_file(rad01,rad02,rad03,rad04,rad05,rad06,
#                               radacti,radplant,radlegal)   
#          VALUES(g_rab.rab01,g_rab.rab02,
#                 g_rad[l_ac1].rad03,g_rad[l_ac1].rad04,
#                 g_rad[l_ac1].rad05,g_rad[l_ac1].rad06,
#                 g_rad[l_ac1].radacti,
#                 g_rab.rabplant,g_rab.rablegal)   
#                
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err3("ins","rad_file",g_rab.rab01,g_rad[l_ac1].rad03,SQLCA.sqlcode,"","",1)
#             CANCEL INSERT
#          ELSE
#             CALL t302_repeat(g_rad[l_ac1].rad03)  #check
#             MESSAGE 'INSERT O.K'
#            #IF p_cmd='u' THEN
#            #   CALL t302_upd_log()
#            #END IF
#             COMMIT WORK
#             LET g_rec_b1=g_rec_b1+1
#          END IF
#
#     AFTER FIELD rad03
#        IF NOT cl_null(g_rad[l_ac1].rad03) THEN
#           IF g_rad_o.rad03 IS NULL OR
#              (g_rad[l_ac1].rad03 != g_rad_o.rad03 ) THEN
#              CALL t302_rad03()    #檢查其有效性          
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rad[l_ac1].rad03,g_errno,0)
#                 LET g_rad[l_ac1].rad03 = g_rad_o.rad03
#                 NEXT FIELD rad03
#              END IF
#              CALL t302_rad04_chk()
#           END IF  
#        END IF 

#     BEFORE FIELD rad04 
#        IF NOT cl_null(g_rad[l_ac1].rad03) THEN
#           CALL t302_rad04_chk()
#        END IF

#     AFTER FIELD rad04
#        IF NOT cl_null(g_rad[l_ac1].rad04) THEN
#           IF g_rad_o.rad04 IS NULL OR
#              (g_rad[l_ac1].rad04 != g_rad_o.rad04 ) THEN
#              CALL t302_rad04() 
#            #FUN-AB0033 mark --------------start-----------------  
#            #  IF NOT cl_null(g_errno) THEN
#            #    CALL cl_err(g_rad[l_ac1].rad04,g_errno,0)
#            #    LET g_rad[l_ac1].rad04 = g_rad_o.rad04
#            #    NEXT FIELD rad04
#            # END IF
#            #FUN-AB0033 mark ---------------end------------------
#           END IF  
#        END IF  

#     ON CHANGE rad04
#        IF NOT cl_null(g_rad[l_ac1].rad04) THEN
#           LET g_rad[l_ac1].rad05=NULL
#           LET g_rad[l_ac1].rad05_desc=NULL
#           LET g_rad[l_ac1].rad06=NULL
#           LET g_rad[l_ac1].rad06_desc=NULL
#           DISPLAY BY NAME g_rad[l_ac1].rad05,g_rad[l_ac1].rad05_desc
#           DISPLAY BY NAME g_rad[l_ac1].rad06,g_rad[l_ac1].rad06_desc

#           CALL t302_rad04()   
#        END IF
# 
#     BEFORE FIELD rad05,rad06
#        IF NOT cl_null(g_rad[l_ac1].rad04) THEN
#           CALL t302_rad04()   
#           #F g_rad[l_ac1].rad04='1' THEN
#           #  CALL cl_set_comp_entry("rad06",TRUE)
#           #  CALL cl_set_comp_required("rad06",TRUE)
#           #LSE
#           #  CALL cl_set_comp_entry("rad06",FALSE)
#           #ND IF
#        END IF

#     AFTER FIELD rad05
#        IF NOT cl_null(g_rad[l_ac1].rad05) THEN
#        IF g_rad[l_ac1].rad04 = '01' THEN #FUN-AB0033 add
#FUN-AA0059 ---------------------start----------------------------         
#           IF NOT s_chk_item_no(g_rad[l_ac1].rad05,"") THEN
#              CALL cl_err('',g_errno,1)
#              LET g_rad[l_ac1].rad05= g_rad_t.rad05
#              NEXT FIELD rad05
#           END IF         
#FUN-AA0059 ---------------------end-------------------------------
#        END IF #FUN-AB0033 add
#           IF g_rad_o.rad05 IS NULL OR
#              (g_rad[l_ac1].rad05 != g_rad_o.rad05 ) THEN
#              CALL t302_rad05('a',l_ac1) 
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rad[l_ac1].rad05,g_errno,0)
#                 LET g_rad[l_ac1].rad05 = g_rad_o.rad05
#                 NEXT FIELD rad05
#              END IF
#           END IF  
#        END IF  

#     AFTER FIELD rad06
#        IF NOT cl_null(g_rad[l_ac1].rad06) THEN
#           IF g_rad_o.rad06 IS NULL OR
#              (g_rad[l_ac1].rad06 != g_rad_o.rad06 ) THEN
#              CALL t302_rad06('a')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rad[l_ac1].rad06,g_errno,0)
#                 LET g_rad[l_ac1].rad06 = g_rad_o.rad06
#                 NEXT FIELD rad06
#              END IF
#           END IF  
#        END IF
#       
#       
#       BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_rad_t.rad03 > 0 AND g_rad_t.rad03 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rad_file
#              WHERE rad02 = g_rab.rab02 AND rad01 = g_rab.rab01
#                AND rad03 = g_rad_t.rad03 AND rad04 = g_rad_t.rad04 
#                AND radplant = g_rab.rabplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rad_file",g_rab.rab01,g_rad_t.rad03,SQLCA.sqlcode,"","",1)
#                ROLLBACK WORK
#                CANCEL DELETE
#             END IF
#             LET g_rec_b1=g_rec_b1-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rad[l_ac1].* = g_rad_t.*
#             CLOSE t3021_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF

#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rad[l_ac1].rad03,-263,1)
#             LET g_rad[l_ac1].* = g_rad_t.*
#          ELSE
#             IF g_rad[l_ac1].rad03<>g_rad_t.rad03 OR
#                g_rad[l_ac1].rad04<>g_rad_t.rad04 THEN
#                SELECT COUNT(*) INTO l_n FROM rad_file
#                 WHERE rad01 =g_rab.rab01 AND rad02 = g_rab.rab02
#                   AND rad03 = g_rad[l_ac1].rad03 
#                   AND rad04 = g_rad[l_ac1].rad04
#                   AND radplant = g_rab.rabplant
#                IF l_n>0 THEN 
#                   CALL cl_err('',-239,0)
#                  #LET g_rad[l_ac1].* = g_rad_t.*
#                   NEXT FIELD rad03
#                END IF
#             END IF
#             UPDATE rad_file SET rad03=g_rad[l_ac1].rad03,
#                                 rad04=g_rad[l_ac1].rad04,
#                                 rad05=g_rad[l_ac1].rad05,
#                                 rad06=g_rad[l_ac1].rad06,
#                                 radacti=g_rad[l_ac1].radacti
#              WHERE rad02 = g_rab.rab02 AND rad01=g_rab.rab01
#                AND rad03=g_rad_t.rad03 AND rad04=g_rad_t.rad04 AND radplant = g_rab.rabplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rad_file",g_rab.rab01,g_rad_t.rad03,SQLCA.sqlcode,"","",1) 
#                LET g_rad[l_ac1].* = g_rad_t.*
#             ELSE
#                CALL t302_repeat(g_rad[l_ac1].rad03)  #check
#               #IF NOT cl_null(g_errno) THEN
#               #   LET g_rad[l_ac1].* = g_rad_t.*
#               #   NEXT FIELD CURRENT
#               #ELSE
#                MESSAGE 'UPDATE O.K'
#                COMMIT WORK
#               #END IF
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
#                LET g_rad[l_ac1].* = g_rad_t.*
#             END IF
#             CLOSE t3021_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#         #CALL t302_repeat(g_rad[l_ac1].rad03)  #check
#          CLOSE t3021_bcl
#          COMMIT WORK
#
#       ON ACTION CONTROLO
#          IF INFIELD(rad03) AND l_ac1 > 1 THEN
#             LET g_rad[l_ac1].* = g_rad[l_ac1-1].*
#             NEXT FIELD rad03
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
#            #WHEN INFIELD(rad03)
#            #WHEN INFIELD(rad04)
#             WHEN INFIELD(rad05)
#                CALL cl_init_qry_var()
#                CASE g_rad[l_ac1].rad04
#                   #WHEN '1'
#                   WHEN '01'      #FUN-A80104
#                    # IF cl_null(g_rtz05) THEN             #FUN-AB0101 mark
#                         #LET g_qryparam.form="q_ima"
#FUN-AA0059---------mod------------str-----------------
#                         #LET g_qryparam.form="q_ima_1"     #TQC-AA0109 
#                          CALL q_sel_ima(FALSE, "q_ima_1","",g_rad[l_ac1].rad05,"","","","","",'' ) 
#                           RETURNING g_rad[l_ac1].rad05  
#FUN-AA0059---------mod------------end----------------- 
#                    # ELSE                                  #FUN-AB0101 mark
#                    #    LET g_qryparam.form = "q_rtg03_1"  #FUN-AB0101 mark
#                    #    LET g_qryparam.arg1 = g_rtz05      #FUN-AB0101 mark
#                    # END IF                                #FUN-AB0101 mark 
#                   #WHEN '2'
#                   WHEN '02'      #FUN-A80104
#                      LET g_qryparam.form ="q_oba01"
#                   #WHEN '3'
#                   WHEN '03'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '1'
#                   #WHEN '4'
#                   WHEN '04'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '2'
#                   #WHEN '5'
#                   WHEN '05'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '3'
#                   #WHEN '6'
#                   WHEN '06'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '4'
#                   #WHEN '7'
#                   WHEN '07'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '5'
#                   #WHEN '8'
#                   WHEN '08'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '6'
#                   #WHEN '9'
#                   WHEN '09'      #FUN-A80104
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '27'
#                END CASE
#              # IF g_rad[l_ac1].rad04 != '01' OR (g_rad[l_ac1].rad04 = '01' AND NOT cl_null(g_rtz05) ) THEN  #FUN-AA0059 add   #FUN-AB0101 mark
#                IF g_rad[l_ac1].rad04 != '01'  THEN                                                                            #FUN-AB0101                                           
#                   LET g_qryparam.default1 = g_rad[l_ac1].rad05
#                   CALL cl_create_qry() RETURNING g_rad[l_ac1].rad05
#                END IF                                                                 #FUN-AA0059 add
#                CALL t302_rad05('d',l_ac1)
#                NEXT FIELD rad05
#             WHEN INFIELD(rad06)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_gfe02"
#                SELECT DISTINCT ima25
#                  INTO l_ima25
#                  FROM ima_file
#                 WHERE ima01=g_rad[l_ac1].rad05  
#                LET g_qryparam.arg1 = l_ima25
#                LET g_qryparam.default1 = g_rad[l_ac1].rad06
#                CALL cl_create_qry() RETURNING g_rad[l_ac1].rad06
#                CALL t302_rad06('d')
#                NEXT FIELD rad06
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
#   CALL t302_upd_log() 
#   
#   CLOSE t3021_bcl
#   COMMIT WORK
#  #CALL s_showmsg()
#
#END FUNCTION
#FUN-BB0056 mark END
FUNCTION t302_rad04_chk() 
DEFINE l_rac04   LIKE rac_file.rac04
DEFINE comb_value STRING   #FUN-BB0056 add
#DEFINE comb_item  STRING   #FUN-BB0056 add
DEFINE comb_item LIKE ze_file.ze03  #FUN-C30154 add 

   SELECT rac04 INTO l_rac04 FROM rac_file
    WHERE rac01=g_rab.rab01 AND rac02=g_rab.rab02
      AND racplant=g_rab.rabplant
      AND rac03=g_rad[l_ac1].rad03

   IF l_rac04 = '1' THEN
     #LET g_rad[l_ac1].rad04='1'  
     #CALL cl_set_comp_entry("rad04",FALSE)  #FUN-C30154 mark  
    #FUN-C30154  add START
     LET comb_value = '01,09'
     SELECT ze03 INTO comb_item FROM ze_file
       WHERE ze01 = 'art-787' AND ze02 = g_lang
     CALL cl_set_combo_items('rad04', comb_value, comb_item)  #FUN-C30154 add
    #FUN-C30154 add END
   ELSE 
     #CALL cl_set_comp_entry("rad04",TRUE)   #FUN-C30154 mark
    #FUN-C30154 add START
     LET comb_value = '01,02,03,04,05,06,07,08,09'
     SELECT ze03 INTO comb_item FROM ze_file
       WHERE ze01 = 'art-788' AND ze02 = g_lang
     CALL cl_set_combo_items('rad04', comb_value, comb_item)  #FUN-C30154 add
    #FUN-C30154 add END
   END IF
END FUNCTION

#FUN-C30154 add START
#顯示之前先將下拉選項重新產生一遍,避免名稱不顯示的問題
FUNCTION t302_rad04_combo()
DEFINE comb_value STRING   
DEFINE comb_item LIKE ze_file.ze03  

   LET comb_value = '01,02,03,04,05,06,07,08,09'
   SELECT ze03 INTO comb_item FROM ze_file
     WHERE ze01 = 'art-788' AND ze02 = g_lang
   CALL cl_set_combo_items('rad04', comb_value, comb_item)  

END FUNCTION
#FUN-C30154 add END

FUNCTION t302_rad03() 
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti

   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM rac_file
    WHERE rac03 = g_rad[l_ac1].rad03 AND rac01=g_rab.rab01
      AND rac02 = g_rab.rab02  AND racplant=g_rab.rabplant
      AND racacti='Y'

   IF l_n<1 THEN  
      LET g_errno = 'art-654'     #當前組別不在第一單身中
   END IF
END FUNCTION


FUNCTION t302_rad04()

   #IF g_rad[l_ac1].rad04='1' THEN
   IF g_rad[l_ac1].rad04='01' THEN  #FUN-A80104
      CALL cl_set_comp_entry("rad06",TRUE)
      CALL cl_set_comp_required("rad06",TRUE)
   ELSE
      CALL cl_set_comp_entry("rad06",FALSE)
   END IF
END FUNCTION


FUNCTION t302_rad05(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 
DEFINE p_cnt       LIKE type_file.num5 

DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02,
          l_oba14    LIKE oba_file.oba14    #MOD-C20226

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '
    
   
   CASE g_rad[p_cnt].rad04
      #WHEN '1'
      WHEN '01'     #FUN-A80104
      # IF cl_null(g_rtz05) THEN    #FUN-AB0101 mark
        IF cl_null(g_rtz04) THEN    #FUN-AB0101 add
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rad[p_cnt].rad05  
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
            WHERE ima01 = rte03 AND ima01=g_rad[p_cnt].rad05
              AND rte01 = g_rtz04           #FUN-AB0101 add
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF
      #WHEN '2'
       WHEN '02'      #FUN-A80104
        #MOD-C20226 modify start----------------
        #SELECT DISTINCT oba02,obaacti 
        #  INTO l_oba02,l_obaacti
         SELECT DISTINCT oba02,obaacti,oba14
           INTO l_oba02,l_obaacti,l_oba14
        #MOD-C20226 modify end------------------
           FROM oba_file
          WHERE oba01=g_rad[p_cnt].rad05 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            WHEN l_oba14>0           LET g_errno='art-904'     #MOD-C20226
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'     #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '4'
      WHEN '04'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='3' AND tqaacti='Y'
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
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'     #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '8'
      WHEN '08'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'     #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rad[p_cnt].rad05 AND tqa03='27' AND tqaacti='Y'
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
      CASE g_rad[p_cnt].rad04
         #WHEN '1'
         WHEN '01'    #FUN-A80104
            LET g_rad[p_cnt].rad05_desc = l_ima02
            IF cl_null(g_rad[p_cnt].rad06) THEN
               LET g_rad[p_cnt].rad06      = l_ima25
            END IF
            SELECT gfe02 INTO g_rad[p_cnt].rad06_desc FROM gfe_file
             WHERE gfe01=g_rad[p_cnt].rad06 AND gfeacti='Y'
         #WHEN '2'
         WHEN '02'    #FUN-A80104
            LET g_rad[p_cnt].rad06 = ''
            LET g_rad[p_cnt].rad06_desc = ''
            LET g_rad[p_cnt].rad05_desc = l_oba02
         #WHEN '9'
         WHEN '09'    #FUN-A80104
            LET g_rad[p_cnt].rad06 = ''
            LET g_rad[p_cnt].rad06_desc = ''
            LET g_rad[p_cnt].rad05_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rad[p_cnt].rad05_desc = g_rad[p_cnt].rad05_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rad[p_cnt].rad05_desc = g_rad[p_cnt].rad05_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rad[p_cnt].rad06 = ''
            LET g_rad[p_cnt].rad06_desc = ''
            LET g_rad[p_cnt].rad05_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rad[p_cnt].rad05_desc,g_rad[p_cnt].rad06,g_rad[p_cnt].rad06_desc
   END IF

END FUNCTION

FUNCTION t302_rad06(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac    

   LET g_errno = ' '
   #IF g_rad[l_ac1].rad04<>'1' THEN
   IF g_rad[l_ac1].rad04<>'01' THEN      #FUN-A80104
      RETURN
   END IF
   IF NOT cl_null(g_rad[l_ac1].rad05) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rad[l_ac1].rad05  

      CALL s_umfchk(g_rad[l_ac1].rad05,l_ima25,g_rad[l_ac1].rad06)
         RETURNING l_flag,l_fac   
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_rad[l_ac1].rad06 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rad[l_ac1].rad06_desc=l_gfe02
      DISPLAY BY NAME g_rad[l_ac1].rad06_desc
   END IF    
END FUNCTION 
 

#FUNCTION t302_copy()
#   DEFINE l_newno     LIKE rab_file.rab01,
#          l_oldno     LIKE rab_file.rab01,
#          li_result   LIKE type_file.num5,
#          l_n         LIKE type_file.num5
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   IF g_rab.rab02 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   LET g_before_input_done = FALSE
#   CALL t302_set_entry('a')
# 
#   CALL cl_set_head_visible("","YES")
#   INPUT l_newno FROM rab01
#       BEFORE INPUT
#         CALL cl_set_docno_format("rab01")
#         
#       AFTER FIELD rab01
#          IF l_newno IS NULL THEN
#             NEXT FIELD rab01
#          ELSE 
#      	     CALL s_check_no("art",l_newno,"","9","rab_file","rab01","")                                                           
#                RETURNING li_result,l_newno                                                                                        
#             IF (NOT li_result) THEN                                                                                               
#                NEXT FIELD rab01                                                                                                   
#             END IF                                                                                                                
#             BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("axm",l_newno,g_today,"","rab_file","rab01",g_plant,"","")                                           
#                RETURNING li_result,l_newno  
#             IF (NOT li_result) THEN                                                                                               
#                ROLLBACK WORK                                                                                                      
#                NEXT FIELD rab01                                                                                                   
#             ELSE                                                                                                                  
#                COMMIT WORK                                                                                                        
#             END IF
#          END IF
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(rab01)                                                                                                      
#              LET g_t1=s_get_doc_no(g_rab.rab01)                                                                                    
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1                                                                 
#              LET l_newno = g_t1                                                                                                
#              DISPLAY l_newno TO rab01                                                                                           
#              NEXT FIELD rab01
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
#      DISPLAY BY NAME g_rab.rab01
#      ROLLBACK WORK
#      RETURN
#   END IF
#   BEGIN WORK
# 
#   DROP TABLE y
# 
#   SELECT * FROM rab_file
#       WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
#         AND rabplant = g_rab.rabplant
#       INTO TEMP y
# 
#   UPDATE y
#       SET rab01=l_newno,
#           rabplant=g_plant, 
#           rablegal=g_legal,
#           rabconf = 'N',
#           rabcond = NULL,
#           rabconu = NULL,
#           rabuser=g_user,
#           rabgrup=g_grup,
#           rabmodu=NULL,
#           rabdate=g_today,
#           rabacti='Y',
#           rabcrat=g_today ,
#           raboriu = g_user,
#           raborig = g_grup
#           
#   INSERT INTO rab_file SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rab_file","","",SQLCA.sqlcode,"","",1)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   DROP TABLE x
# 
#   SELECT * FROM rac_file
#       WHERE rac02 = g_rab.rab02 AND rac01=g_rab.rab01 
#         AND racplant = g_rab.rabplant
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE x SET rac01=l_newno,
#                racplant = g_plant,
#                raclegal = g_legal 
# 
#   INSERT INTO rac_file
#       SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","rac_file","","",SQLCA.sqlcode,"","",1) 
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF 
#    
#   DROP TABLE z
# 
#   SELECT * FROM rad_file
#       WHERE rad02 = g_rab.rab02 AND rad01=g_rab.rab01 
#         AND radplant = g_rab.rabplant
#       INTO TEMP z
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE z SET rad01=l_newno,
#                radplant = g_plant,
#                radlegal = g_legal 
# 
#   INSERT INTO rad_file
#       SELECT * FROM z   
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","rad_file","","",SQLCA.sqlcode,"","",1)  
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF    
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#   LET l_oldno = g_rab.rab01
#   SELECT rab_file.* INTO g_rab.* FROM rab_file 
#      WHERE rab02=g_rab.rab02 AND rab01 = l_newno
#        AND rabplant = g_rab.rabplant
#   CALL t302_u()
#   CALL t302_b1()
#   SELECT rab_file.* INTO g_rab.* FROM rab_file 
#       WHERE rab02=g_rab.rab02 AND rab01 = l_oldno 
#         AND rabplant = g_rab.rabplant
#
#   CALL t302_show()
# 
#END FUNCTION
 
FUNCTION t302_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
#    IF g_wc IS NULL AND g_rab.rab01 IS NOT NULL THEN
#       LET g_wc = "rab01='",g_rab.rab01,"'"
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
#    LET l_cmd='p_query "artt302" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t302_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rab02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t302_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rab02",FALSE)
   END IF
 
END FUNCTION

FUNCTION t302_iss() 
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_dbs   LIKE azp_file.azp03   
DEFINE l_sql   STRING
DEFINE l_raq04 LIKE raq_file.raq04
DEFINE l_rtz11 LIKE rtz_file.rtz11
DEFINE l_rablegal LIKE rab_file.rablegal
DEFINE l_today  LIKE type_file.dat         #FUN-AB0093 
DEFINE l_time   LIKE type_file.chr8        #FUN-AB0093

  
   IF s_shut(0) THEN
      RETURN
   END IF

  #IF g_rab.rab02 IS NULL THEN  #mark
   IF cl_null(g_rab.rab02) THEN  #FUN-BB0056 add
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rab.* FROM rab_file 
      WHERE rab02 = g_rab.rab02 AND rab01=g_rab.rab01
        AND rabplant = g_rab.rabplant

   IF g_rab.rab01<>g_rab.rabplant THEN
      CALL cl_err('','art-663',0)
      RETURN
   END IF

   IF g_rab.rabacti ='N' THEN
      CALL cl_err(g_rab.rab01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rab.rabconf = 'N' THEN
      CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
      RETURN
   END IF

   IF g_rab.rabconf = 'X' THEN
      CALL cl_err('','art-661',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file 
    WHERE raq01=g_rab.rab01 AND raq02=g_rab.rab02 AND raqplant=g_rab.rabplant 
      AND raq03='1' AND raqacti='Y' AND raq05='N'
   IF l_cnt=0 THEN
      CALL cl_err('','art-662',0)
      RETURN
   END IF
  
   DROP TABLE rab_temp
   SELECT * FROM rab_file WHERE 1 = 0 INTO TEMP rab_temp
   DROP TABLE rac_temp
   SELECT * FROM rac_file WHERE 1 = 0 INTO TEMP rac_temp
   DROP TABLE rad_temp
   SELECT * FROM rad_file WHERE 1 = 0 INTO TEMP rad_temp  
   DROP TABLE rap_temp
   SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp  
   DROP TABLE raq_temp
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp  
   DROP TABLE rak_temp                                     #FUN-BB0056 add 
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp   #FUN-BB0056 add
 
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t302_cl USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file
    WHERE raq01 = g_rab.rab01 AND raq02 = g_rab.rab02
      AND raq03 = '1' AND raqplant = g_rab.rabplant
   IF l_cnt = 0 THEN
      CALL cl_err('','art-545',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM rac_file
    WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
      AND racplant = g_rab.rabplant 
   IF l_cnt = 0 THEN
      CALL cl_err('','art-548',0)
      RETURN
   END IF
   IF NOT cl_confirm('art-660') THEN 
       RETURN
   END IF     
   
   CALL s_showmsg_init()
 
   

  #LET l_sql="SELECT raq04 FROM raq_file ",  #FUN-BB0056 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",  #FUN-BB0056 mark
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='1' AND raqacti='Y' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rab.rab01,g_rab.rab02,g_rab.rabplant
                  INTO l_raq04  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach raq_cs:',SQLCA.sqlcode,1)                         
      END IF   
      IF g_rab.rabplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rab.rabplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
      LET g_plant_new = l_raq04
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04
      
      DELETE FROM rab_temp
      DELETE FROM rac_temp
      DELETE FROM rad_temp  
      DELETE FROM raq_temp
      DELETE FROM rap_temp
      DELETE FROM rak_temp   #FUN-BB0056 add
      LET l_today =  g_today         #FUN-AB0093
     #LET l_time  =  g_time          #FUN-AB0093 #TQC-BA0173
      LET l_time  =  TIME            #TQC-BA0173
      IF g_rab.rabplant = l_raq04 THEN #與當前機構相同則不拋
#TQC-AC0326 mark ------------------------begin------------------------      
##FUN-AB0093 ------------------STA
#         UPDATE rab_file SET rab901 = l_today,
#                             rab902 = l_time
#          WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
#            AND rabplant = g_rab.rabplant
#         IF SQLCA.sqlcode THEN
#             CALL cl_err3("upd","rab_file",g_rab.rab02,"",STATUS,"","",1)
#             CONTINUE FOREACH 
#         ELSE
#            SELECT rab901,rab902 INTO g_rab.rab901,g_rab.rab902
#              FROM rab_file 
#             WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
#               AND rabplant = g_rab.rabplant
#         END IF
##FUN-AB0093 ------------------END
#TQC-AC0326 mark -------------------------end-------------------------  
         UPDATE raq_file SET raq05='Y',raq06=l_today,raq07 = l_time   #TQC-AC0326 add raq06,raq07
          WHERE raq01=g_rab.rab01 AND raq02=g_rab.rab02
            AND raq03='1' AND raq04=l_raq04 AND raqplant=g_rab.rabplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rab.rab02,"",STATUS,"","",1) 
            #LET g_success = 'N' #FUN-AB0033 mark 
            CONTINUE FOREACH     #FUN-AB0033 add
         END IF
         #DISPLAY BY NAME g_rab.rab901               #FUN-AB0093  #TQC-AC0326 mark
         #DISPLAY BY NAME g_rab.rab902               #FUN-AB0093  #TQC-AC0326 mark
      ELSE
        #IF l_rtz11='N' THEN
            UPDATE raq_file SET raq05='Y',raq06=l_today,raq07 = l_time   #TQC-AC0326 add raq06,raq07 
             WHERE raq01=g_rab.rab01 AND raq02=g_rab.rab02
               AND raq03='1' AND raq04=l_raq04 AND raqplant=g_rab.rabplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","raq_file",g_rab.rab02,"",STATUS,"","",1) 
               #LET g_success = 'N' #FUN-AB0033 mark 
               CONTINUE FOREACH     #FUN-AB0033 add
            END IF
        #END IF
      #將數據放入臨時表中處理
         SELECT azw02 INTO l_rablegal FROM azw_file
          WHERE azw01 = l_raq04 AND azwacti='Y'

         INSERT INTO rac_temp SELECT rac_file.* FROM rac_file
                               WHERE rac01 = g_rab.rab01 AND rac02 = g_rab.rab02
                                 AND racplant = g_rab.rabplant
         UPDATE rac_temp SET racplant=l_raq04,
                             raclegal = l_rablegal

         INSERT INTO rad_temp SELECT rad_file.* FROM rad_file
                               WHERE rad01 = g_rab.rab01 AND rad02 = g_rab.rab02
                                 AND radplant = g_rab.rabplant
         UPDATE rad_temp SET radplant=l_raq04,
                             radlegal = l_rablegal

         #INSERT INTO rap_temp SELECT rap_file.* FROM radpfile     #MOD-AC0174 mark
         INSERT INTO rap_temp SELECT rap_file.* FROM rap_file      #MOD-AC0174 add
                               WHERE rap01 = g_rab.rab01 AND rap02 = g_rab.rab02
                                 AND rapplant = g_rab.rabplant
         UPDATE rap_temp SET rapplant=l_raq04,
                             raplegal = l_rablegal

         INSERT INTO rab_temp SELECT * FROM rab_file
          WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
            AND rabplant = g_rab.rabplant
         IF l_rtz11='Y' THEN
            UPDATE rab_temp SET rabplant = l_raq04,
                                rablegal = l_rablegal,
                                rabconf = 'N',
                                rabcond = NULL,
                                rabcont = NULL,
                                rabconu = NULL
                                #rab901  = NULL,                         #FUN-AB0093 add #TQC-AC0326 mark
                                #rab902  = NULL                          #FUN-AB0093 add #TQC-AC0326 mark
         ELSE
            UPDATE rab_temp SET rabplant = l_raq04,
                                rablegal = l_rablegal,
                                rabconf = 'Y',
                                rabcond = g_today,
                                rabcont = g_time,
                                rabconu = g_user
                                #rab901  = l_today,                      #FUN-AB0093 add #TQC-AC0326 mark
                                #rab902  = l_time                        #FUN-AB0093 add #TQC-AC0326 mark
         END IF

         INSERT INTO raq_temp SELECT * FROM raq_file
          WHERE raq01=g_rab.rab01 AND raq02 = g_rab.rab02
            AND raq03 ='1' AND raqplant = g_rab.rabplant
      #  IF l_rtz11='Y' THEN
      #     UPDATE raq_temp SET raqplant = l_raq04,
      #                         raq05    = 'N',
      #                         raqlegal = l_rablegal
      #  ELSE
         UPDATE raq_temp SET raqplant = l_raq04,
                             raq05    = 'Y',
                             raq06=l_today,  #FUN-C10008 add
                             raq07 = l_time,  #FUN-C10008 add
                             raqlegal = l_rablegal
      #  END IF
    #FUN-BB0056 add START
         INSERT INTO rak_temp SELECT rak_file.* FROM rak_file
                               WHERE rak01 = g_rab.rab01 AND rak02 = g_rab.rab02
                                 AND rakplant = g_rab.rabplant AND rak03 = '1'
         UPDATE rak_temp SET rakplant=l_raq04,
                             raklegal = l_rablegal
    #FUN-BB0056 add END



         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rab_file'),
                     " SELECT * FROM rab_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rab FROM l_sql
         EXECUTE trans_ins_rab
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rab_file:',SQLCA.sqlcode,1)
           #LET g_success = 'N' #FUN-AB0033 mark 
           CONTINUE FOREACH     #FUN-AB0033 add
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rac_file'), 
                     " SELECT * FROM rac_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rac FROM l_sql
         EXECUTE trans_ins_rac
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rac_file:',SQLCA.sqlcode,1)
           #LET g_success = 'N' #FUN-AB0033 mark 
           CONTINUE FOREACH     #FUN-AB0033 add
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rad_file'), 
                     " SELECT * FROM rad_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rad FROM l_sql
         EXECUTE trans_ins_rad
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rad_file:',SQLCA.sqlcode,1)
           #LET g_success = 'N' #FUN-AB0033 mark 
           CONTINUE FOREACH     #FUN-AB0033 add
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rap_file'), 
                     " SELECT * FROM rap_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rap FROM l_sql
         EXECUTE trans_ins_rap
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
           #LET g_success = 'N' #FUN-AB0033 mark 
           CONTINUE FOREACH     #FUN-AB0033 add
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raq_file'), 
                     " SELECT * FROM raq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_raq FROM l_sql
         EXECUTE trans_ins_raq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
           #LET g_success = 'N' #FUN-AB0033 mark 
           CONTINUE FOREACH     #FUN-AB0033 add 
         END IF

      #FUN-BB0056 add START
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
      #FUN-BB0056 add END  
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

   DROP TABLE rab_temp
   DROP TABLE rac_temp
   DROP TABLE rad_temp
   DROP TABLE rap_temp
   DROP TABLE raq_temp
   DROP TABLE rak_temp
#FUN-C10008 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file
      WHERE raq01 = g_rab.rab01 AND raq02 = g_rab.rab02
        AND raq03 = '1' AND raqplant = g_rab.rabplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
#FUN-C10008 add END

END FUNCTION

#FUN-BB0056 mark START
#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
#FUNCTION t302_repeat(p_group)     
#DEFINE p_group    LIKE rac_file.rac03
#DEFINE l_n        LIKE type_file.num5
#DEFINE l_rac12    LIKE rac_file.rac12
#DEFINE l_rac13    LIKE rac_file.rac13
#DEFINE l_rac14    LIKE rac_file.rac14
#DEFINE l_rac15    LIKE rac_file.rac15

#  LET l_n=0
#  LET g_errno =' '

#  SELECT COUNT(rad04) INTO l_n FROM rad_file
#   WHERE rad01=g_rab.rab01 AND rad02=g_rab.rab02
#     AND radplant=g_rab.rabplant AND rad03=p_group
#     AND radacti='Y'

#  IF l_n<1 THEN RETURN END IF
#

#  SELECT rac12,rac13,rac14,rac15
#    INTO l_rac12,l_rac13,l_rac14,l_rac15 
#    FROM rac_file
#   WHERE rac01=g_rab.rab01 AND rac02=g_rab.rab02
#     AND racplant=g_rab.rabplant AND rac03=p_group
#     AND racacti='Y'
#  IF cl_null(l_rac12) OR cl_null(l_rac13) OR cl_null(l_rac14) OR cl_null(l_rac15) THEN
#     RETURN
#  END IF
#  
#  CALL t302sub_chk('1',g_plant,g_rab.rab01,g_rab.rab02,p_group,l_rac12,l_rac13,l_rac14,l_rac15)
#
#END FUNCTION
##FUN-BB0056 mark END
#TQC-AC0326 add --------------------begin----------------------
FUNCTION t302_w() 			# when g_rab.rabconf='Y' (Turn to 'N')
DEFINE l_cnt       LIKE type_file.num10
DEFINE l_conf      LIKE rab_file.rabconf
DEFINE l_rabcont   LIKE rab_file.rabcont   #CHI-D20015 Add
DEFINE l_gen02     LIKE gen_file.gen02     #CHI-D20015 Add
 
   SELECT COUNT(*) INTO l_cnt FROM raq_file 
    WHERE raq01=g_rab.rab01 AND raq02=g_rab.rab02 AND raqplant=g_rab.rabplant 
      AND raq03='1' AND raqacti='Y' AND raq05='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','art-888',0)
      RETURN
   END IF     
#FUN-BB0056 add START
  #未確認單據不允許取消確認
  SELECT rabconf INTO l_conf FROM rab_file
    WHERE rab01 = g_rab.rab01 AND rab02 = g_rab.rab02
      AND rabplant = g_rab.rabplant
  IF l_conf <> 'Y' THEN
     CALL cl_err('','aim1129',0) 
     RETURN
  END IF
#FUN-BB0056 add END

   LET g_success = 'Y'
   BEGIN WORK
 
   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF 
   #FUN-B80085增加空白行

  #CHI-D20015 Mark&Add Str
   LET l_rabcont = TIME
  #UPDATE rab_file SET rabconf = 'N',rabconu='',rabcond='',
  #                    rabcont = ''  #Add No:TQC-B10078
   UPDATE rab_file SET rabconf = 'N',rabconu=g_user,
                       rabcond = g_today,rabcont=l_rabcont
  #CHI-D20015 Mark&Add End
    WHERE rab01 = g_rab.rab01 

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rab_file",g_rab.rab01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rab_file OK'
   END IF
  
   IF g_success = 'Y' THEN
      LET g_rab.rabconf='N' 
      COMMIT WORK
     #CHI-D20015 Mark&Add Str
     #LET g_rab.rabconu=NULL
     #LET g_rab.rabcond=NULL
     #DISPLAY BY NAME g_rab.rabconf
     ##Add No:TQC-B10078
     #LET g_rab.rabcont=NULL
      LET g_rab.rabconu=g_user
      LET g_rab.rabcond=g_today
      DISPLAY BY NAME g_rab.rabconf
      LET g_rab.rabcont=l_rabcont
     #CHI-D20015 Mark&Add End
      DISPLAY BY NAME g_rab.rabcond                                                                                         
      DISPLAY BY NAME g_rab.rabcont                                                                                         
      DISPLAY BY NAME g_rab.rabconu
     #DISPLAY '' TO FORMONLY.rabconu_desc
     #DISPLAY '' TO FORMONLY.rabconu_desc                                 #CHI-D20015 Mark
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rab.rabconu   #CHI-D20015 Add
      DISPLAY l_gen02 TO FORMONLY.rabconu_desc                            #CHI-D20015 Add
      IF g_rab.rabconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      CALL cl_set_field_pic(g_rab.rabconf,"","","",g_chr,"")
      #End Add No:TQC-B10078
   ELSE
      LET g_rab.rabconu=g_user                                                                                           
      LET g_rab.rabcond=g_today  
      LET g_rab.rabconf='Y' 
      LET g_rab.rabcont=l_rabcont   #CHI-D20015 Add
      ROLLBACK WORK
   END IF
END FUNCTION
#TQC-AC0326 add --------------------end-----------------------

#FUN-A60044 
#FUN-C10008 add START
FUNCTION t302_chkrap()
   DEFINE l_n      LIKE type_file.num5
 
   IF g_rac[l_ac].rac08 = 0 THEN RETURN END IF
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM rap_file
     WHERE rap01 =g_rab.rab01 AND rap02 = g_rab.rab02
       AND rap03 = 1 AND rap04 = g_rac[l_ac].rac03
       AND rap09 = g_rac[l_ac].rac08
       AND rapplant = g_rab.rabplant
   IF l_n > 0 THEN
     IF NOT cl_confirm('art-797') THEN
        RETURN
     END IF
     IF g_rac_t.rac04 = 1 THEN  #特價
        UPDATE rap_file SET rap06 = 0 
           WHERE rap01 =g_rab.rab01 AND rap02 = g_rab.rab02
             AND rap03 = 1 AND rap04 = g_rac[l_ac].rac03
             AND rap09 = g_rac[l_ac].rac08 
             AND rapplant = g_rab.rabplant 
     END IF
     IF g_rac_t.rac04 = 2 THEN  #折扣
        UPDATE rap_file SET rap07 = 0
           WHERE rap01 =g_rab.rab01 AND rap02 = g_rab.rab02
             AND rap03 = 1 AND rap04 = g_rac[l_ac].rac03
             AND rap09 = g_rac[l_ac].rac08         
             AND rapplant = g_rab.rabplant
     END IF
     IF g_rac_t.rac04 = 3 THEN  #折讓
        UPDATE rap_file SET rap08 = 0
           WHERE rap01 =g_rab.rab01 AND rap02 = g_rab.rab02
             AND rap03 = 1 AND rap04 = g_rac[l_ac].rac03
             AND rap09 = g_rac[l_ac].rac08 
             AND rapplant = g_rab.rabplant
     END IF  
   END IF
END FUNCTION
#FUN-C10008 add END

# MOD-CC0219------------ add ----------- begin
FUNCTION t302_multi_ima01()
DEFINE  l_rad       RECORD LIKE rad_file.*
DEFINE  tok         base.StringTokenizer
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
   WHILE tok.hasMoreTokens()
      LET l_rad.rad05 = tok.nextToken()
      LET l_rad.rad01 = g_rab.rab01
      LET l_rad.rad02 = g_rab.rab02
      LET l_rad.rad03 = g_rad[l_ac1].rad03
      LET l_rad.rad04 = g_rad[l_ac1].rad04
        
      IF cl_null(g_rtz04) THEN
         SELECT DISTINCT ima25
           INTO l_rad.rad06
           FROM ima_file
          WHERE ima01=l_rad.rad05
            AND imaacti = 'Y'
      ELSE
         SELECT DISTINCT ima25
           INTO l_rad.rad06
           FROM ima_file,rte_file
          WHERE ima01 = rte03 AND ima01=l_rad.rad05
            AND rte01 = g_rtz04
            AND rte07 = 'Y'
      END IF
      LET l_rad.radplant = g_rab.rabplant
      LET l_rad.radlegal = g_rab.rablegal
      LET l_rad.radacti  = 'Y'
      INSERT INTO rad_file VALUES(l_rad.*)
      IF STATUS THEN
         CALL s_errmsg('rad01',l_rad.rad05,'INS rad_file',STATUS,1)
         CONTINUE WHILE
      END IF
   END WHILE
   CALL s_showmsg()
END FUNCTION
# MOD-CC0219------------ add ----------- end


#FUN-CC0129 add begin-------------------------------
FUNCTION t302_copy()
   DEFINE l_newno     LIKE rab_file.rab02,
          l_oldno     LIKE rab_file.rab02,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5,
          i           LIKE type_file.num5
          
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rab.rab02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_oldno  = g_rab.rab02
   LET g_success = 'Y' 

   DROP TABLE v
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP v
   DROP TABLE w
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP w
   DROP TABLE x
   SELECT * FROM rac_file WHERE 1 = 0 INTO TEMP x
   DROP TABLE y
   SELECT * FROM rab_file WHERE 1 = 0 INTO TEMP y
   DROP TABLE z
   SELECT * FROM rad_file WHERE 1 = 0 INTO TEMP z
      
   BEGIN WORK   
   
   LET g_before_input_done = FALSE
   CALL t302_set_entry('a')
   LET g_before_input_done = TRUE
WHILE TRUE
   CALL cl_set_head_visible("","YES")   
   INPUT l_newno FROM rab02
   
      BEFORE INPUT
      CALL cl_set_docno_format("rab02")
      
      AFTER FIELD rab02
      IF l_newno IS NULL THEN
         NEXT FIELD rab02 
      ELSE 
         SELECT COUNT(*) INTO i FROM rab_file 
          WHERE rab02    = l_newno
            AND rabplant = g_plant
            AND rab01    = g_rab.rab01
         IF i>0 THEN
            CALL cl_err('sel rab02:','-239',0)
            NEXT FIELD rab02
         END IF     
         CALL s_check_no("art",l_newno,g_rab_t.rab02,"A7","rab_file","rab01,rab02,rabplant","") 
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN                                                            
            LET g_rab.rab02=g_rab_t.rab02                                                                 
            NEXT FIELD rab02                                                                                     
         END IF            
      END IF                  

      ON ACTION controlp
         CASE 
            WHEN INFIELD(rab02)                                                                                                      
              LET g_t1=s_get_doc_no(l_newno)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A7','art') RETURNING g_t1                                                                  
              LET l_newno = g_t1                                                                                                
              DISPLAY  l_newno TO rab02                                                                                           
              NEXT FIELD rab02
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
      DISPLAY BY NAME g_rab.rab02
      RETURN
   END IF   
   CALL s_auto_assign_no("art",l_newno,g_today,"A7","rab_file","rab02","","","") 
      RETURNING li_result,l_newno 
   IF (NOT li_result) THEN  
      CONTINUE WHILE  
   END IF 
   DISPLAY l_newno TO rab02 
   EXIT WHILE
END WHILE        
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rab.rab02
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
     
   #一般促销单头维护
   SELECT * FROM rab_file
       WHERE rab02 = l_oldno AND rab01=g_rab.rab01
         AND rabplant = g_rab.rabplant
       INTO TEMP y 
   UPDATE y
       SET rab02=l_newno,
           rabplant=g_plant, 
           rablegal=g_legal,
           rabconf = 'N',
           rabcond = NULL,
           rabconu = NULL,
           rabuser=g_user,
           rabgrup=g_grup,
           rabmodu=NULL,
           rabdate=g_today,
           rabacti='Y',
           rabcrat=g_today ,
           raboriu = g_user,
           raborig = g_grup
           
   INSERT INTO rab_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rab_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF    
   
   #条件设定
   SELECT * FROM rac_file
       WHERE rac02 = l_oldno AND rac01=g_rab.rab01 
         AND racplant = g_rab.rabplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE x SET rac02=l_newno,
                racplant = g_plant,
                raclegal = g_legal 
 
   INSERT INTO rac_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rac_file","","",SQLCA.sqlcode,"","",1) 
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
   
   #时段设定
   SELECT * FROM rak_file
       WHERE rak02 = l_oldno AND rak01=g_rab.rab01 
         AND rakplant = g_rab.rabplant
       INTO TEMP w
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
       WHERE raq02 = l_oldno AND raq01=g_rab.rab01 
         AND raqplant = g_rab.rabplant
       INTO TEMP v
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
   SELECT * FROM rad_file
       WHERE rad02 = l_oldno AND rad01=g_rab.rab01 
         AND radplant = g_rab.rabplant
       INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE z SET rad02=l_newno,
                radplant = g_plant,
                radlegal = g_legal 
 
   INSERT INTO rad_file
       SELECT * FROM z   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rad_file","","",SQLCA.sqlcode,"","",1)
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
   SELECT rab_file.* INTO g_rab.* FROM rab_file 
      WHERE rab02=l_newno AND rab01 = g_rab.rab01
        AND rabplant = g_rab.rabplant
   CALL t302_u()
   CALL t302_b()
   SELECT rab_file.* INTO g_rab.* FROM rab_file 
       WHERE rab02=g_rab.rab02 AND rab01 = g_rab.rab01 
         AND rabplant = g_rab.rabplant
   CALL t302_show()        
END FUNCTION 
#FUN-CC0129 add end---------------------------------
