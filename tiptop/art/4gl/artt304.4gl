# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt304.4gl
# Descriptions...: 滿額促銷單
# Date & Author..: NO.FUN-A60044 10/06/24 By Cockroach
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-A80104 10/08/19 By lixia資料類型改為varchar2(2)
# Modify.........: No.TQC-A80151 10/09/03 By houlia 設定rah21，raa22，rah23是否可以輸入
# Modify.........: No.TQC-A80156 10/09/03 By houlia rai09增加控管
# Modify.........: No.TQC-A80157 10/09/06 By houlia rai05跟rai06的管控錯誤
# Modify.........: No.FUN-A80104 10/09/27 By lixia 第二單身組別增加控管
# Modify.........: No.FUN-A80104 10/10/08 By lixia 發佈時增加對換贈資料的處理
# Modify.........: No.TQC-A90027 10/10/13 By houlia 促銷方式選3折讓，單身折讓額欄位不可管控只能介于0-99之間，  只需【價格不能小于或等于0】即可
# Modify.........: No.TQC-A90013 10/10/15 By houlia 修改rah19時，立刻調整右側功能鈕“換贈資料”的狀態
# Modify.........: No:TQC-AA0109 10/10/20 By lixia sql修正
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0033 10/11/08 By wangxin 促銷BUG調整
# Modify.........: No.FUN-AB0093 10/11/24 By huangtao 增加發佈日期和發佈時間
# Modify.........: No.TQC-AB0205 10/11/28 By Cockroach 系统联测bug修改
# Modify.........: No.FUN-AB0101 10/12/06 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號，否則抓ima_file
# Modify.........: No.FUN-AA0065 10/12/09 BY shenyang 去掉單身一和單身二的項次和組別關係 
# Modify.........: No.TQC-AC0196 10/12/15 By wangxin 修改折讓金額控管 
# Modify.........: No.TQC-AC0193 10/12/15 By wangxin 查詢所有資料后清空單身數組中的值 
# Modify.........: No.MOD-AC0172 10/12/18 By suncx 會員等級促銷BUG調整
# Modify.........: No:TQC-AC0326 10/12/22 By wangxin 促銷302/303/304規格調整，發布時間調整，
#                                                    畫面原來的發布時間mark掉，新增欄位在生效營運中心按鈕中顯示，
#                                                    并添加取消確認按鈕(未發布可取消審核)
# Modify.........: No:TQC-B10132 11/01/13 By zhangll 更新取消审核显示问题
# Modify.........: No:TQC-B10133 11/01/13 By zhangll 取消审核where条件修正
# Modify.........: No:TQC-B30050 11/03/04 By lilingyu 當促銷方式為3.折讓,條件規則為2.滿量時,單身折讓額欄位不需要卡折讓金額是否大於滿額金額
# Modify.........: No:FUN-B30012 11/03/08 By baogc 1.換贈信息修改2.刪除滿額單身一的時候同時刪除會員等級和換贈單身的資料
# Modify.........: No:MOD-B30045 11/03/30 By baogc 满量逻辑修改
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60071 11/06/22 By baogc 添加確認的控管
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B80095 11/08/25 By baogc 滿量邏輯修改
# Modify.........: No.TQC-BA0173 11/10/28 By destiny 发布时间更新错误
# Modify.........: No.FUN-BB0059 11/12/15 By pauline GP5.3 artt304 滿額促銷單促銷功能優化
# Modify.........: No.FUN-C10008 12/01/04 By pauline GP5.3 artt302 一般促銷單促銷功能優化調整
# Modify.........: No.TQC-C20002 12/02/01 By pauline 折讓基數可輸入0,且折讓基數不可大於滿額金額或滿量數量
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20106 12/02/10 By pauline GP5.3 刪除錯誤處理
# Modify.........: No.TQC-C20336 12/02/21 By pauline 刪除錯誤處理
# Modify.........: No.FUN-C30151 12/03/20 By pauline 當促銷為折扣時且條件為滿量,增加折扣基數
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60041 12/06/18 By huangtao 最多可選品種個數給默認值
# Modify.........: No.CHI-C80035 12/08/14 By pauline 當促銷方式為折讓時,而條件規則不為滿額時,不應判斷art-850錯誤
# Modify.........: No.TQC-C80118 12/08/22 By yangxf 在時段設定中下條件，會查詢出所有的資料，且時段設定單身為空
# Modify.........: No.MOD-CC0219 13/01/05 By SunLM artt302,artt303,artt304範圍設置單身，編碼類型為產品時，錄入時代碼可以開窗多選形式進行錄入
# Modify.........: No.FUN-CC0129 13/01/07 By SunLM artt302,artt303,artt304新增複製功能
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/18 by chenjing 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rah         RECORD LIKE rah_file.*,
       g_rah_t       RECORD LIKE rah_file.*,
       g_rah_o       RECORD LIKE rah_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_rai         DYNAMIC ARRAY OF RECORD
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai10          LIKE rai_file.rai10,  #FUN-BB0059 add  #FUN-C30151 
           rai05          LIKE rai_file.rai05,
          #rai10          LIKE rai_file.rai10,  #FUN-BB0059 add
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_rai_t       RECORD
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai10          LIKE rai_file.rai10,  #FUN-BB0059 add  #FUN-C30151    
           rai05          LIKE rai_file.rai05,
          #rai10          LIKE rai_file.rai10,  #FUN-BB0059 add
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_rai_o       RECORD 
           rai03          LIKE rai_file.rai03,
           rai04          LIKE rai_file.rai04,
           rai10          LIKE rai_file.rai10,  #FUN-BB0059 add  #FUN-C30151
           rai05          LIKE rai_file.rai05,
          #rai10          LIKE rai_file.rai10,  #FUN-BB0059 add
           rai06          LIKE rai_file.rai06,
           rai07          LIKE rai_file.rai07,
           rai08          LIKE rai_file.rai08,
           rai09          LIKE rai_file.rai09,
           raiacti        LIKE rai_file.raiacti
                     END RECORD,
       g_raj         DYNAMIC ARRAY OF RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_raj_t       RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_raj_o       RECORD
           raj03          LIKE raj_file.raj03,
           raj04          LIKE raj_file.raj04,
           raj05          LIKE raj_file.raj05,
           raj05_desc     LIKE type_file.chr100,
           raj06          LIKE raj_file.raj06,
           raj06_desc     LIKE gfe_file.gfe02,
           rajacti        LIKE raj_file.rajacti
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
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
DEFINE g_argv1             LIKE rah_file.rah01
DEFINE g_argv2             LIKE rah_file.rah02
DEFINE g_argv3             LIKE rah_file.rahplant
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b3            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_member            LIKE type_file.chr1

DEFINE l_azp02             LIKE azp_file.azp02 
DEFINE g_rtz05             LIKE rtz_file.rtz05  #價格策略
DEFINE g_rtz04             LIKE rtz_file.rtz04  #FUN-AB0101
#FUN-BB0059 add START
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
DEFINE g_wc3              STRING,
       g_rec_b2           LIKE type_file.num5
DEFINE g_raq         RECORD
           raq05          LIKE raq_file.raq05,
           raq06          LIKE raq_file.raq06,
           raq07          LIKE raq_file.raq07 
                     END RECORD
#FUN-BB0059 add END
DEFINE g_multi_ima01       STRING    #add MOD-CC0219
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

   LET g_forupd_sql = "SELECT * FROM rah_file WHERE rah01 = ? AND rah02 = ? AND rahplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t304_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t304_w AT p_row,p_col WITH FORM "art/42f/artt304"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant
   SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01=g_plant     #FUN-AB0101

#  CALL cl_set_comp_visible("rah20",FALSE)    #FUN-B30012 MARK
#  CALL cl_set_comp_visible("rah22",FALSE)    #FUN-B30012 ADD  #FUN-BB0059 mark 
#  CALL cl_set_comp_visible("s_raj",FALSE)    #FUN-B80095 MARK
#  CALL cl_set_comp_visible("Page6",FALSE)    #FUN-B80095 ADD  #FUN-BB0059 mark
#FUN-BB0059 add START
   CALL cl_set_comp_visible("rah14",FALSE)
   CALL cl_set_comp_visible("rah15",FALSE) 
   CALL cl_set_comp_visible("rah16",FALSE) 
   CALL cl_set_comp_visible("rah17",FALSE) 
  #IF g_rah.rah10 = 2 THEN   #FUN-C30151 mark
   IF g_rah.rah10 = 2 AND g_rah.rah25 = '1' THEN   #FUN-C30151 add
      CALL cl_set_comp_visible('rai10',FALSE)  
   ELSE
      CALL cl_set_comp_visible('rai10',TRUE)
   END IF
#FUN-BB0059 add END
   IF NOT cl_null(g_argv1) THEN
      CALL t304_q()
   END IF
   
   CALL cl_set_comp_required("rak11",FALSE)   #FUN-BB0059 add
   CALL t304_menu()
   CLOSE WINDOW t304_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t304_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rai.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rah01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED," rah02 = '",g_argv2,"'"
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc CLIPPED," rahplant = '",g_argv3,"'"
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rah.* TO NULL
#FUN-BB0059 mark START
#     CONSTRUCT BY NAME g_wc ON rah01,rah02,rah03,rahplant,
#                               rah04,rah05,rah06,rah07,   
#                               rah10,rah11,rah25,rah12,rah13,rah14,rah15,
#                           #   rahmksg,rah900,rahconf,rahcond,rahcont,rahconu,rahpos,rah24,    #FUN-AB0093 mark
#                               #rahmksg,rah900,rahconf,rahcond,rahcont,rahconu,rah901,rah902,rahpos,rah24,    #FUN-AB0093  add #TQC-AB0205 mark 
#                               rahconf,rahcond,rahcont,rahconu,#rah901,rah902, #TQC-AC0326 mark
#                               rahpos,rah24,    #TQC-AB0205 add
#                               rah16,rah17,rah18,
#                               rah19,
#                               rah20,rah21,rah22,rah23,         
#                               rahuser,rahgrup,rahoriu,rahmodu,rahdate,rahorig,rahacti,rahcrat
#FUN-BB0059 mark END
#FUN-BB0059 add START
      CONSTRUCT BY NAME g_wc ON rah01,rah02,rah03,rahplant,
                                rah10,rah11,rah25,
                                rah12,rah13,rah14,rah15,
                                rah16,rah17,rah18,rah19,
                                rahconf,rahcond,rahcont,rahconu,
                                rahpos,rah24,    
                                rahuser,rahgrup,rahoriu,rahmodu,rahdate,rahorig,rahacti,rahcrat,
                                raq05,raq06,raq07
#FUN-BB0059 add END

 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            CALL t304_rah25()    #TQC-AB0205
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rah01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah01
                  NEXT FIELD rah01
      
               WHEN INFIELD(rah02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah02
                  NEXT FIELD rah02
      
               WHEN INFIELD(rah03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rah03
                  NEXT FIELD rah03
      
               WHEN INFIELD(rahconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rahconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rahconu                                                                              
                  NEXT FIELD rahconu
               WHEN INFIELD(rahplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rahplant"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rahplant                                                                              
                  NEXT FIELD rahplant
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rahuser', 'rahgrup')
#FUN-BB0059 add START
      DIALOG ATTRIBUTES(UNBUFFERED)

      CONSTRUCT g_wc3 ON rak05,rak06,rak07,rak08,rak09,rak10,rak11,rakacti
              FROM s_rak[1].rak05,s_rak[1].rak06,s_rak[1].rak07,s_rak[1].rak08,
                   s_rak[1].rak09, s_rak[1].rak10, s_rak[1].rak11, s_rak[1].rakacti

        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
#FUN-BB0059 add END 
      CONSTRUCT g_wc1 ON rai03,rai04,rai05,rai06,rai10,rai07,rai08,     #FUN-BB0059 add rai10
                         rai09,raiacti          
              FROM s_rai[1].rai03,s_rai[1].rai04,
                   s_rai[1].rai05,s_rai[1].rai10,s_rai[1].rai06,s_rai[1].rai07,  #FUN-BB0059 add rai10
                   s_rai[1].rai08,s_rai[1].rai09,s_rai[1].raiacti  
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

    #FUN-BB0059 mark START   
    #    ON IDLE g_idle_seconds
    #       CALL cl_on_idle()
    #       CONTINUE CONSTRUCT
    
    #    ON ACTION about
    #       CALL cl_about()
    
    #    ON ACTION HELP
    #       CALL cl_show_help()
    
    #    ON ACTION controlg
    #       CALL cl_cmdask()
    
    #    ON ACTION qbe_save
    #       CALL cl_qbe_save()
    #FUN-BB0059 mark END
       END CONSTRUCT
    #FUN-BB0059 mark START 
    #  IF INT_FLAG THEN
    #     RETURN
    #  END IF 
    #FUN-BB0059 mark END

       CONSTRUCT g_wc2 ON raj03,raj04,raj05,raj06,rajacti
              FROM s_raj[1].raj03,s_raj[1].raj04,
                   s_raj[1].raj05,s_raj[1].raj06, s_raj[1].rajacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(raj05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_raj05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO raj05
                  NEXT FIELD raj05
               WHEN INFIELD(raj06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_raj06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO raj06
                  NEXT FIELD raj06 
            END CASE
     
     #FUN-BB0059 mark START     
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE CONSTRUCT
    
     #   ON ACTION about
     #      CALL cl_about()
    
     #   ON ACTION HELP
     #      CALL cl_show_help()
    
     #   ON ACTION controlg
     #      CALL cl_cmdask()
    
     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
     #FUN-BB0059 mark END
       END CONSTRUCT     

#FUN-BB0059 add START
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
#FUN-BB0059 add END

       IF INT_FLAG THEN 
          RETURN
       END IF

    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc  = g_wc  CLIPPED
    LET g_wc3 = g_wc3 CLIPPED  #FUN-BB0059 add

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF

   #FUN-BB0059 add START
    IF cl_null(g_wc3) THEN
       LET g_wc3=" 1=1"
    END IF
   #FUN-BB0059 add END        
#modify by TQC-AA0109----str----   
#    LET g_sql = "SELECT DISTINCT rah01,rah02,rahplant ",
#                "  FROM (rah_file LEFT OUTER JOIN rai_file ",
#                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
#                "     AND rahplant=rajplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rah01,rah02,rahplant"
     LET g_sql = "SELECT DISTINCT rah01,rah02,rahplant ",
                "  FROM rah_file LEFT OUTER JOIN rai_file ",
                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant ) ",
                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
                "     AND rahplant=rajplant ) ",
                "    LEFT OUTER JOIN raq_file ON ( rah01=raq01 AND rah02=raq02 ",  #FUN-BB0059 add
                "     AND rahplant=raqplant )  ",  #FUN-BB0059 add
                #TQC-C80118 add begin ---
                "    LEFT OUTER JOIN rak_file ON ( rah01=rak01 AND rah02=rak02 ",
                "     AND rahplant=rakplant ) ",
                #TQC-C80118 add end -----
                "  WHERE ", g_wc CLIPPED," AND ",g_wc1," AND ",g_wc2,
                "    AND ", g_wc3 CLIPPED,        #TQC-C80118 add
                " ORDER BY rah01,rah02,rahplant"

#modify by TQC-AA0109----end----   
   PREPARE t304_prepare FROM g_sql
   DECLARE t304_cs
       SCROLL CURSOR WITH HOLD FOR t304_prepare
 
   #IF g_wc2 = " 1=1" THEN
   #   LET g_sql="SELECT COUNT(*) FROM rah_file WHERE ",g_wc CLIPPED
   #ELSE
   #   LET g_sql="SELECT COUNT(*) FROM rah_file,rai_file WHERE ",
   #             "rai01=rah01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   #END IF
#modify by TQC-AA0109----str----     
#   LET g_sql = "SELECT COUNT(DISTINCT rah01||rah02||rahplant) ",
#                "  FROM (rah_file LEFT OUTER JOIN rai_file ",
#                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant AND ",g_wc1,")) ",
#                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
#                "     AND rahplant=rajplant AND ",g_wc2,") ",
#                "  WHERE ", g_wc CLIPPED,  
#                " ORDER BY rah01"
   LET g_sql = "SELECT COUNT(DISTINCT rah01||rah02||rahplant) ",
                "  FROM rah_file LEFT OUTER JOIN rai_file ",
                "       ON (rah01=rai01 AND rah02=rai02 AND rahplant=raiplant ) ",
                "    LEFT OUTER JOIN raj_file ON ( rah01=raj01 AND rah02=raj02 ",
                "     AND rahplant=rajplant ) ",
                "    LEFT OUTER JOIN raq_file ON ( rah01=raq01 AND rah02=raq02 ",  #FUN-BB0059 add
                "     AND rahplant=raqplant )  ",  #FUN-BB0059 add
                #TQC-C80118 add begin ---
                "    LEFT OUTER JOIN rak_file ON ( rah01=rak01 AND rah02=rak02 ",
                "     AND rahplant=rakplant ) ",
                #TQC-C80118 add end -----
                "  WHERE ", g_wc CLIPPED," AND ",g_wc1," AND ",g_wc2,
                "    AND ", g_wc3 CLIPPED,        #TQC-C80118 add
                " ORDER BY rah01"

#modify by TQC-AA0109----end----  
   PREPARE t304_precount FROM g_sql
   DECLARE t304_count CURSOR FOR t304_precount
 
END FUNCTION
 
FUNCTION t304_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t304_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t304_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t304_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t304_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t304_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t304_x()
            END IF
 
         WHEN "reproduce"  ##FUN-CC0129
            IF cl_chk_act_auth() THEN
               CALL t304_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
             #FUN-BB0059 mark START
             # IF g_flag_b = '1' THEN
             #    CALL t304_b()
             # ELSE
             #    CALL t304_b1()
             # END IF
             #FUN-BB0059 mark END
               CALL t304_all_b()  #FUN-BB0059 add
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t304_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "organization" #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rah.rah02) THEN
                  CALl t302_1(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t304_yes()
            END IF
 
         #TQC-AC0326 add ----------begin-----------
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t304_w()
            END IF
         #TQC-AC0326 add -----------end------------

         WHEN "Memberlevel"    #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rah.rah02) THEN
                 IF g_rai[l_ac].rai07 <> '0' THEN   #FUN-BB0059 add
                   #CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10)  #FUN-BB0059 mark
                    CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10,g_rai[l_ac].rai07)   #FUN-BB0059 add 
                 END IF
              ELSE
                 CALL cl_err('',-400,0)
              END IF
            END IF

        WHEN "gift"         #換贈資料
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rah.rah02) THEN
                 CALL t303_gift(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10)
              ELSE
                 CALL cl_err('',-400,0)
              END IF
           END IF
           
        #FUN-AB0033 mark -----------start---------------
        #WHEN "void"
        #    IF cl_chk_act_auth() THEN
        #       CALL t304_void()
        #    END IF
        #FUN-AB0033 mark------------end------------------
        
        WHEN "issuance"              #發布
           IF cl_chk_act_auth() THEN
              CALL t304_iss()
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rai),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rah.rah02 IS NOT NULL THEN
                 LET g_doc.column1 = "rah02"
                 LET g_doc.value1 = g_rah.rah02
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t304_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_rai TO s_rai.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '3'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0059 mark START 
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
#           CALL t304_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t304_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t304_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t304_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t304_fetch('L')
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

#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG
#           
#        #TQC-AC0326 add ----------begin-----------
#        ON ACTION undo_confirm
#           LET g_action_choice="undo_confirm"
#           EXIT DIALOG
#        #TQC-AC0326 add -----------end------------

#        #FUN-AB0033 mark -----------start---------------   
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG
#        #FUN-AB0033 mark ------------end----------------
#        
#        ON ACTION issuance                    #發布      
#           LET g_action_choice = "issuance"  
#           EXIT DIALOG
#                                                                                                                                   
#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

#        ON ACTION gift
#           LET g_action_choice="gift"
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
#FUN-BB0059 mark END
      END DISPLAY 

#FUN-BB0059 add START
      DISPLAY ARRAY g_rak TO s_rak.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'   #FUN-D30033 add

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY
#FUN-BB0059 add END

      DISPLAY ARRAY g_raj TO s_raj.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '1'   #FUN-D30033 add

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BB0059 mark START 
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
#           CALL t304_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t304_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t304_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t304_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t304_fetch('L')
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
#        #FUN-AB0033 mark -----------start---------------
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG
#        #FUN-AB0033 mark ------------end----------------
#
#        ON ACTION Memberlevel                 #會員促銷
#           LET g_action_choice="Memberlevel"
#           EXIT DIALOG

#        ON ACTION gift
#           LET g_action_choice="gift"
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
#FUN-BB0059 mark END
      END DISPLAY
#FUN-BB0059 add START
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
            CALL t304_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t304_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t304_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t304_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t304_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
          ON ACTION reproduce  #FUN-CC0129
             LET g_action_choice="reproduce"
             EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice="output"
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

         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
 
         #TQC-AC0326 add ----------begin-----------
         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG
         #TQC-AC0326 add -----------end------------

         #FUN-AB0033 mark -----------start---------------
         #ON ACTION void
         #   LET g_action_choice="void"
         #   EXIT DIALOG
         #FUN-AB0033 mark ------------end----------------
 
         ON ACTION issuance                    #發布
            LET g_action_choice = "issuance"
            EXIT DIALOG
 
         ON ACTION Memberlevel                 #會員促銷
            LET g_action_choice="Memberlevel"
            EXIT DIALOG

         ON ACTION gift
            LET g_action_choice="gift"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
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
#FUN-BB0059 add END
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t304_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rai.clear()
   CALL g_raj.clear()   #TQC-AC0193 add
   CALL g_rak.clear()   #FUN-BB0059 add
   DISPLAY ' ' TO FORMONLY.cnt
  #CALL cl_set_comp_visible("rai05,rai06,rai08,rai09,Page6",TRUE)   #FUN-BB0059 mark
   CALL cl_set_comp_visible("rai05,rai06,rai08,rai09,pc3",TRUE)   #FUN-BB0059 add
   CALL t304_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rah.* TO NULL
      RETURN
   END IF
 
   OPEN t304_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rah.* TO NULL
   ELSE
      OPEN t304_count
      FETCH t304_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t304_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t304_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t304_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'P' FETCH PREVIOUS t304_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'F' FETCH FIRST    t304_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
      WHEN 'L' FETCH LAST     t304_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
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
        FETCH ABSOLUTE g_jump t304_cs INTO g_rah.rah01,g_rah.rah02,g_rah.rahplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      INITIALIZE g_rah.* TO NULL
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
 
   SELECT * INTO g_rah.* FROM rah_file 
       WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01
         AND rahplant = g_rah.rahplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rah_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rah.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rah.rahuser
   LET g_data_group = g_rah.rahgrup
   LET g_data_plant = g_rah.rahplant #TQC-A10128 ADD
   
   CALL t304_rah25()    #TQC-AB0205
 
   CALL t304_show()
 
END FUNCTION
 
FUNCTION t304_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE l_raa03   LIKE raa_file.raa03 
 
   LET g_rah_t.* = g_rah.*
   LET g_rah_o.* = g_rah.*
   DISPLAY BY NAME g_rah.rah01,g_rah.rah02,g_rah.rah03,  
                  #g_rah.rah04,g_rah.rah05,g_rah.rah06,g_rah.rah07,  #FUN-BB0059 mark
                   g_rah.rah10,g_rah.rah11,g_rah.rah25,
                   g_rah.rah12,g_rah.rah13,g_rah.rah14,g_rah.rah15,
                   g_rah.rah16,g_rah.rah17,g_rah.rah18,
                   g_rah.rah19,
                  #g_rah.rah20,g_rah.rah21,g_rah.rah22,g_rah.rah23  #FUN-BB0059 mark 
                   g_rah.rah24,
                   g_rah.rahplant,g_rah.rahconf,g_rah.rahcond,g_rah.rahcont,
             #     g_rah.rahconu,g_rah.rah900,g_rah.rahmksg,        #FUN-AB0093  mark
                   #g_rah.rahconu,g_rah.rah901,g_rah.rah902,g_rah.rah900,g_rah.rahmksg,    #FUN-AB0093  add  #TQC-AB0205 mark
                   g_rah.rahconu,#g_rah.rah901,g_rah.rah902,     #TQC-AB0205 add  #TQC-AC0326 mark
                   g_rah.rahoriu,g_rah.rahorig,g_rah.rahuser,
                   g_rah.rahmodu,g_rah.rahacti,g_rah.rahgrup,
                   g_rah.rahdate,g_rah.rahcrat,g_rah.rahpos
 
   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")                                                                           
  #CALL cl_flow_notify(g_rah.rah01,'V') 

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rah01
   DISPLAY l_azp02 TO FORMONLY.rah01_desc
   SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rah.rah01 AND raa02 = g_rah.rah03
   DISPLAY l_raa03 TO FORMONLY.rah03_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rah.rahconu
   DISPLAY l_gen02 TO FORMONLY.rahconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rahplant
   DISPLAY l_azp02 TO FORMONLY.rahplant_desc
   CALL cl_set_act_visible("gift",g_rah.rah19='Y')
#FUN-BB0059 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file
      WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
        AND raq03 = '3' AND raqplant = g_rah.rahplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
#FUN-BB0059 add END
   CALL t304_rah10()
   CALL t304_rah11()
   CALL t304_b_fill(g_wc1)
   CALL t304_b1_fill(g_wc2)
   CALL t304_b3_fill(g_wc3)  #FUN-BB0059 add
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t304_b_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT rai03,rai04,rai10,rai05, rai06,rai07,rai08,rai09, ",  #FUN-BB0059 add rai10  #FUN-C30151 將rai10搬移至rai05前
               "       raiacti ",   #FUN-BB0059 mark
               "  FROM rai_file",
               " WHERE rai02 = '",g_rah.rah02,"' AND rai01 ='",g_rah.rah01,"' ",
               "   AND raiplant = '",g_rah.rahplant,"'"
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rai03 "
 
   DISPLAY g_sql

   CALL t304_rai10_text()   #FUN-C30151 add
 
   PREPARE t304_pb FROM g_sql
   DECLARE rai_cs CURSOR FOR t304_pb
 
   CALL g_rai.clear()
   LET g_cnt = 1
 
   FOREACH rai_cs INTO g_rai[g_cnt].*
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
   CALL g_rai.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
  #DISPLAY g_rec_b TO FORMONLY.cn1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t304_b1_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT raj03,raj04,raj05,'',raj06,'',rajacti",
               "  FROM raj_file",
               " WHERE raj02 = '",g_rah.rah02,"' AND raj01 ='",g_rah.rah01,"' ",
               "   AND rajplant = '",g_rah.rahplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY raj03 "
 
   DISPLAY g_sql
 
   PREPARE t304_pb1 FROM g_sql
   DECLARE raj_cs CURSOR FOR t304_pb1
 
   CALL g_raj.clear()
   LET g_cnt = 1
 
   FOREACH raj_cs INTO g_raj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_ac1 = g_cnt
       CALL t304_raj05('d',g_cnt)
       SELECT gfe02 INTO g_raj[g_cnt].raj06_desc FROM gfe_file
           WHERE gfe01 = g_raj[g_cnt].raj06
      #CALL t304_raj06('d')

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_raj.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
  #DISPLAY g_rec_b1 TO FORMONLY.cn2
   DISPLAY g_rec_b1 TO FORMONLY.cn3  #FUN-BB0059 add
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t304_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_rai.clear() 
   CALL g_raj.clear()
   CALL g_rak.clear()  #FUN-BB0059 add
   LET g_wc = NULL
   LET g_wc2= NULL
   LEt g_wc3= NULL   #FUN-BB0059 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rah.* LIKE rah_file.*
   LET g_rah_t.* = g_rah.*
   LET g_rah_o.* = g_rah.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rah.rah01 = g_plant
     #LET g_rah.rah06 = '00:00:00'  #FUN-BB0059 mark
     #LET g_rah.rah07 = '23:59:59'  #FUN-BB0059 mark 
      LET g_rah.rah08 = 'N'  #预留
      LET g_rah.rah09 = 'N'  #预留
      LET g_rah.rah10 = '2'
      LET g_rah.rah11 = '1'
      LET g_rah.rah25 = '1'  #add on 0720
      LET g_rah.rah12 = 'N'
      LET g_rah.rah13 = 'N'
      LET g_rah.rah14 = 'N'
     #LET g_rah.rah15 = 'Y'  #FUN-BB0059 mark 
      LET g_rah.rah15 = 'N'  #FUN-BB0059 add 
      LET g_rah.rah16 = 'N'
      LET g_rah.rah17 = 'N'
      LET g_rah.rah18 = 'N'
      LET g_rah.rah19 = 'N'
     #FUN-BB0059 mark START
     #LET g_rah.rah20 = '1'
     #LET g_rah.rah21 = '1'
     #LET g_rah.rah22 = '1'
     #FUN-BB0059 mark END
      LET g_rah.rah23 = 1     #FUN-C60041
      LET g_rah.rah900   = '0'
      LET g_rah.rahacti  ='Y'
      LET g_rah.rahconf  = 'N'
      LET g_rah.rahpos  = '1' #NO.FUN-B40071
      LET g_rah.rahmksg  = 'N'
      LET g_rah.rahuser  = g_user
      LET g_rah.rahoriu  = g_user  
      LET g_rah.rahorig  = g_grup  
      LET g_rah.rahgrup  = g_grup
      LET g_rah.rahcrat  = g_today
      LET g_rah.rahplant = g_plant
      LET g_rah.rahlegal = g_legal
      LET g_data_plant   = g_plant 

      DISPLAY BY NAME g_rah.rah01,
                     #g_rah.rah04,g_rah.rah05,g_rah.rah06,  #FUN-BB0059 mark
                     #g_rah.rah07,                          #FUN-BB0059 mark
                      g_rah.rah10,
                      g_rah.rah11,g_rah.rah25,g_rah.rah12,g_rah.rah13,g_rah.rah14,
                      g_rah.rah15,g_rah.rah16,g_rah.rah17,g_rah.rah18,
                      g_rah.rah19,
                     #g_rah.rah20,g_rah.rah21,g_rah.rah22,             #FUN-BB0059 mark
                      #g_rah.rah900,g_rah.rahacti,g_rah.rahconf,g_rah.rahpos,      #TQC-AB0205 mark
                      g_rah.rahacti,g_rah.rahconf,g_rah.rahpos,                    #TQC-AB0205 add
                      #g_rah.rahmksg,g_rah.rahuser,g_rah.rahoriu,g_rah.rahorig,    #TQC-AB0205 mark
                      g_rah.rahuser,g_rah.rahoriu,g_rah.rahorig,                   #TQC-AB0205 add
                      g_rah.rahgrup,g_rah.rahcrat,g_rah.rahplant
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rah01
      DISPLAY l_azp02 TO rah01_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rah.rahplant
      DISPLAY l_azp02 TO rahplant_desc

      CALL t304_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rah.* TO NULL
         CALL t304_rah25()    #TQC-AB0205
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rah.rah02) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rah.rah02,g_today,"A9","rah_file","rah01,rah02,rahplant","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rah.rah02,g_today,"A9","rah_file","rah01,rah02,rahplant","","","") #FUN-A70130 mod
         RETURNING li_result,g_rah.rah02 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rah.rah02

#FUN-BB0059 add START
      IF cl_null(g_rah.rah20) THEN LET g_rah.rah20 = ' ' END IF
      IF cl_null(g_rah.rah21) THEN LET g_rah.rah21 = ' ' END IF
      IF cl_null(g_rah.rah22) THEN LET g_rah.rah22 = ' ' END IF
      IF cl_null(g_rah.rah23) THEN LET g_rah.rah23 = ' ' END IF
#FUN-BB0059 add END
      INSERT INTO rah_file VALUES (g_rah.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rah_file",g_rah.rah02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK          #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         # #FUN-B80085增加空白行

         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
                      VALUES (g_rah.rah01,g_rah.rah02,'3',g_rah.rah01,'N','Y',g_rah.rahplant,g_legal)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","raq_file",g_rah.rah02,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK          #FUN-B80085--add--
            CONTINUE WHILE
         ELSE 
            IF g_rah.rah11='1' THEN 
               CALL t304_total_check()  #head_check
            END IF
            COMMIT WORK
            CALL cl_flow_notify(g_rah.rah02,'I')
         END IF
      END IF
 
      SELECT * INTO g_rah.* FROM rah_file
       WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
         AND rahplant = g_rah.rahplant  
      LET g_rah_t.* = g_rah.*
      LET g_rah_o.* = g_rah.*     
      CALL cl_set_act_visible("gift",g_rah.rah19='Y')
      CALL t302_1(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf) 
      CALL g_rai.clear()
      CALL g_raj.clear()
      CALL t304_rah10()
      CALL t304_rah11()
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0  #FUN-BB0059 add
     #CALL t304_b()  mark
      CALL t304_all_b()
      IF g_rah.rah11 = '2' THEN
        #CALL t304_b1()  #FUN-BB0059 mark 
         CALL t304_all_b()  #FUN-BB0059 add
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t304_i(p_cmd)
DEFINE     l_pmc05   LIKE pmc_file.pmc05,
           l_pmc30   LIKE pmc_file.pmc30,
           l_n       LIKE type_file.num5,
           p_cmd     LIKE type_file.chr1,
           li_result LIKE type_file.num5
DEFINE     l_date    LIKE rwf_file.rwf06
DEFINE     l_time1   LIKE type_file.num5
DEFINE     l_time2   LIKE type_file.num5
DEFINE l_docno     LIKE rah_file.rah02  #FUN-BB0059 add

   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES") 
#FUN-BB0059 mark START   
#  INPUT BY NAME g_rah.rah02,g_rah.rah03,
#                g_rah.rah04,g_rah.rah05,  
#                g_rah.rah06,g_rah.rah07,   
#                g_rah.rah10,g_rah.rah11,g_rah.rah25,g_rah.rah12,g_rah.rah13,
#                #g_rah.rah14,g_rah.rah15,g_rah.rahmksg,g_rah.rah24,   #TQC-AB0205 mark
#                g_rah.rah14,g_rah.rah15,g_rah.rah24,    #TQC-AB0205 add
#                g_rah.rah16,g_rah.rah17,g_rah.rah18,
#                g_rah.rah19
#                g_rah.rah20,g_rah.rah21,g_rah.rah22,g_rah.rah23  #
#FUN-BB0059 mark END
#FUN-BB0059 add START
   INPUT BY NAME g_rah.rah02,g_rah.rah03,
                 g_rah.rah10,g_rah.rah11,g_rah.rah25,g_rah.rah12,g_rah.rah13,
                 g_rah.rah14,g_rah.rah15,g_rah.rah24,    
                 g_rah.rah16,g_rah.rah17,g_rah.rah18,
                 g_rah.rah19
#FUN-BB0059 add END
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t304_set_entry(p_cmd)
         CALL t304_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rah02")
         CALL t304_rah25()     #TQC-AB0205
###-MOD-B30045- ADD - BEGIN -------------------------------
#FUN-BB0059 mark START
#        IF g_rah.rah19 = 'Y' THEN
#           CALL cl_set_comp_entry("rah20,rah21,rah22,rah23",TRUE)
#        ELSE
#           CALL cl_set_comp_entry("rah20,rah21,rah22,rah23",FALSE)
#        END IF
#FUN-BB0059 mark END
###-MOD-B30045- ADD -  end  -------------------------------
          
      AFTER FIELD rah02  #促銷單號
         IF NOT cl_null(g_rah.rah02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rah.rah02 <> g_rah_t.rah02) THEN     
#              CALL s_check_no("axm",g_rah.rah02,g_rah_t.rah02,"A9","rah_file","rah01,rah02,rahplant","") #FUN-A70130 mark
               CALL s_check_no("art",g_rah.rah02,g_rah_t.rah02,"A9","rah_file","rah01,rah02,rahplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rah.rah02
               IF (NOT li_result) THEN                                                            
                  LET g_rah.rah02=g_rah_t.rah02                                                                 
                  NEXT FIELD rah02                                                                                     
               END IF
              #TQC-AB0205 ADD---------抓取單據是否做簽核，因g_rah.rhb02會多"_"所以用substr取前三碼------
               LET l_docno = g_rah.rah02
               LET l_docno = l_docno[1,3]
               #SELECT oayapr INTO g_rah.rahmksg FROM oay_file   #TQC-AB0205 mark
               # WHERE oayslip = l_docno
               #DISPLAY BY NAME g_rah.rahmksg
              #TQC-AB0205 ADD-------------------------
            END IF
         END IF

      AFTER FIELD rah03  #活動代碼
         IF NOT cl_null(g_rah.rah03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                   
               g_rah.rah03 != g_rah_o.rah03 OR cl_null(g_rah_o.rah03)) THEN               
               CALL t304_rah03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rah03:',g_errno,0)
                  LET g_rah.rah03 = g_rah_t.rah03
                  DISPLAY BY NAME g_rah.rah03
                  NEXT FIELD rah03
               ELSE
                  LET g_rah_o.rah03 = g_rah.rah03
               END IF
            END IF
         ELSE
            LET g_rah_o.rah03 = ''
            CLEAR rah03_desc           
         END IF
      
    #FUN-BB0059 mark START
    # AFTER FIELD rah04,rah05 #開始,結束日期
    # #FUN-AB0033 mark ------------start-----------------
    # #     LET l_date = FGL_DIALOG_GETBUFFER()
    # #           IF INFIELD(rah04) THEN
    # #              IF NOT cl_null(g_rah.rah05) THEN
    # #                 IF DATE(l_date)>g_rah.rah05 THEN
    # #                    CALL cl_err('','art-201',0)
    # #                    NEXT FIELD rah04
    # #                 END IF
    # #              END IF
    # #           END IF
    # #           IF INFIELD(rah05) THEN
    # #              IF NOT cl_null(g_rah.rah04) THEN
    # #                 IF DATE(l_date)<g_rah.rah04 THEN
    # #                    CALL cl_err('','art-201',0)
    # #                    NEXT FIELD rah05
    # #                 END IF
    # #              END IF
    # #           END IF   
    # #FUN-AB0033 mark -------------end------------------
    #            CALL t304_check()
    #            IF NOT cl_null(g_errno) THEN
    #               CALL cl_err('',g_errno,0)
    #               NEXT FIELD CURRENT
    #            END IF
    # 
    #     
    #  AFTER FIELD rah06 #開始時間
    #        IF NOT cl_null(g_rah.rah06) THEN
    #           IF p_cmd = "a" OR                    
    #              (p_cmd = "u" AND g_rah.rah06<>g_rah_t.rah06) THEN 
    #              CALL t304_chktime(g_rah.rah06) RETURNING l_time1
    #              IF NOT cl_null(g_errno) THEN
    #                 CALL cl_err('',g_errno,0)
    #                 NEXT FIELD rah06
    #              ELSE
    #                IF NOT cl_null(g_rah.rah07) THEN
    #                     CALL t304_chktime(g_rah.rah07) RETURNING l_time2
    #                     IF l_time1>=l_time2 THEN
    #                        CALL cl_err('','art-207',0)
    #                        NEXT FIELD rah06
    #                     END IF
    #                     CALL t304_check()
    #                     IF NOT cl_null(g_errno) THEN
    #                        CALL cl_err('',g_errno,0)
    #                        NEXT FIELD CURRENT
    #                     END IF
    #                 END IF
    #               END IF
    #            END IF
    #         END IF
    #    
    #  AFTER FIELD rah07 #結束時間
    #        IF NOT cl_null(g_rah.rah07) THEN
    #           IF p_cmd = "a" OR                    
    #              (p_cmd = "u" AND g_rah.rah07<>g_rah_t.rah07) THEN 
    #              CALL t304_chktime(g_rah.rah07) RETURNING l_time2
    #              IF NOT cl_null(g_errno) THEN
    #                 CALL cl_err('',g_errno,0)
    #                 NEXT FIELD rah07
    #              ELSE
    #                IF NOT cl_null(g_rah.rah06) THEN
    #                      CALL t304_chktime(g_rah.rah06) RETURNING l_time1
    #                      IF l_time1>=l_time2 THEN
    #                         CALL cl_err('','art-207',0)
    #                         NEXT FIELD rah07
    #                      END IF
    #                      CALL t304_check()
    #                      IF NOT cl_null(g_errno) THEN
    #                         CALL cl_err('',g_errno,0)
    #                         NEXT FIELD CURRENT
    #                      END IF
    #                 END IF
    #               END IF
    #           END IF
    #        END IF
    #FUN-BB0059 mark END
    
      ON CHANGE rah10 #促銷方式
         CALL t304_chkrap()  #FUN-C10008 add
         CALL t304_rah10()
      AFTER FIELD rah10
#FUN-B80095 Mark Begin ---
#去除滿額促銷作業中的邏輯判斷：條件規則為2:滿量時促銷方式只能選2:折扣且不可設置分段計算!
####-MOD-B30045- ADD - BEGIN ----------------------------------
#         IF g_rah.rah25 = '2' AND (g_rah.rah10 = '3' OR g_rah.rah12 = 'Y') THEN
#            CALL cl_err('','art-133',0)
#            NEXT FIELD rah10
#         END IF
####-MOD-B30045- ADD -  END  ----------------------------------
#FUN-B80095 Mark End -----
         CALL t304_rah10()
         
#FUN-B80095 Mark Begin ---
#去除滿額促銷作業中的邏輯判斷：條件規則為2:滿量時促銷方式只能選2:折扣且不可設置分段計算!
####-MOD-B30045- ADD - BEGIN ----------------------------------
#      AFTER FIELD rah12 #分段計算否
#         IF g_rah.rah25 = '2' AND (g_rah.rah10 = '3' OR g_rah.rah12 = 'Y') THEN
#            CALL cl_err('','art-133',0)
#            NEXT FIELD rah12
#         END IF
####-MOD-B30045- ADD -  END  ----------------------------------
#FUN-B80095 Mark End -----

      ON CHANGE rah11 #參與方式
         IF NOT cl_null(g_rah.rah11) THEN
            IF g_rah.rah11='1' THEN
               SELECT COUNT(*) INTO l_n 
                 FROM raj_file
                WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
                  AND rajplant=g_rah.rahplant
               IF l_n>0 THEN
                  CALL cl_err(g_rah.rah02,'art-668',0) 
                  LET g_rah.rah11=g_rah_t.rah11
               END IF
                 #IF cl_confirm('art-668') THEN
                 #   IF cl_confirm('art-669') THEN
                 #      DELETE FROM raj_file
                 #       WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
                 #         AND rajplant=g_rah.rahplant 
                 #      CALL g_raj.clear()
                 #   ELSE
                 #      LET g_rah.rah11=g_rah_t.rah11
                 #   END IF
                 #ELSE
                 #   LET g_rah.rah11=g_rah_t.rah11
                 #END IF
            END IF
         END IF 
         CALL t304_rah11()
      AFTER FIELD rah11 #參與方式
         CALL t304_rah11()
#TQC-A80151 --add
#FUN-BB0059 mark START
#     ON CHANGE rah19 #
#        IF g_rah.rah19 = 'Y' THEN
#     #     CALL cl_set_comp_entry("rah21,rah22,rah23",TRUE)          #MOD-B30045 MARK
#           CALL cl_set_comp_entry("rah20,rah21,rah22,rah23",TRUE)    #MOD-B30045 ADD
#        ELSE
#     #     CALL cl_set_comp_entry("rah21,rah22,rah23",FALSE)         #MOD-B30045 MARK
#           CALL cl_set_comp_entry("rah20,rah21,rah22,rah23",FALSE)   #MOD-B30045 ADD
#        END IF
#FUN-BB0059 mark END
#TQC-A80151 --end

#FUN-B30012 MARK-BEGIN--
#     ON CHANGE rah22 #換贈類型
#        CALL t304_rah22()
#     AFTER FIELD rah22 #換贈類型
#        CALL t304_rah22()
#FUN-B30012 MARK-END----
#FUN-BB0059 mark START
#     AFTER FIELD rah23 #
##        IF g_rah.rah22 = '2' THEN               #FUN-B30012 MARK
#        IF NOT cl_null(g_rah.rah23) THEN        #FUN-B30012 ADD
##           IF g_rah.rah23 <= 1 THEN             #FUN-B30012 MARK
#           IF g_rah.rah23 < 1 THEN              #FUN-B30012 ADD
##              CALL cl_err(g_rah.rah23,'art-659',0)  #FUN-B30012 MARK
#              CALL cl_err(g_rah.rah23,'alm-808',0)  #FUN-B30012 ADD
#              NEXT FIELD rah23
#           END IF
#        END IF
#FUN-BB0059 mark END      
      #TQC-AB0205 add-begin-----
      ON CHANGE rah25
         CALL t304_rah25()
      #TQC-AB0205 add--end------

#FUN-B80095 Mark Begin ---
#去除滿額促銷作業中的邏輯判斷：條件規則為2:滿量時促銷方式只能選2:折扣且不可設置分段計算!
####-MOD-B30045- ADD - BEGIN ----------------------------------
#    AFTER FIELD rah25
#         IF g_rah.rah25 = '2' AND (g_rah.rah10 = '3' OR g_rah.rah12 = 'Y') THEN
#            CALL cl_err('','art-133',0)
#            NEXT FIELD rah25
#         END IF
####-MOD-B30045- ADD -  END  ----------------------------------
#FUN-B80095 Mark End -----
  
      AFTER INPUT 
         LET g_rah.rahuser = s_get_data_owner("rah_file") #FUN-C10039
         LET g_rah.rahgrup = s_get_data_group("rah_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
      #FUN-BB0059 mark START   
      #  #FUN-AB0033 add ----------------start-------------------
      #  IF NOT cl_null(g_rah.rah04) AND NOT cl_null(g_rah.rah05) THEN
      #     IF g_rah.rah04 > g_rah.rah05 THEN
      #        CALL cl_err('','art-201',0)
      #        NEXT FIELD rah04
      #     END IF
      #  END IF
      #  #FUN-AB0033 add -----------------end--------------------
      #FUN-BB0059 mark END     
 
        #IF g_rah.rah04<>g_rah_t.rah04 OR
        #   g_rah.rah05<>g_rah_t.rah05 OR
        #   g_rah.rah06<>g_rah_t.rah06 OR
        #   g_rah.rah07<>g_rah_t.rah07 OR
        #   g_rah.rah11<>g_rah_t.rah11 THEN
        #   CALL t304_total_check()
        #END IF



      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rah02)                                                                                                      
              LET g_t1=s_get_doc_no(g_rah.rah02)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A9','art') RETURNING g_t1        #FUN-A70130                                                         
              LET g_rah.rah02 = g_t1                                                                                                
              DISPLAY BY NAME g_rah.rah02                                                                                           
              NEXT FIELD rah02
            WHEN INFIELD(rah03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_raa02"
               LET g_qryparam.arg1 =g_plant
               LET g_qryparam.default1 = g_rah.rah03
               CALL cl_create_qry() RETURNING g_rah.rah03
               DISPLAY BY NAME g_rah.rah03
               CALL t304_rah03('d')
               NEXT FIELD rah03
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

FUNCTION t304_rah03(p_cmd)
DEFINE l_raa03        LIKE raa_file.raa03 
DEFINE l_raa05        LIKE raa_file.raa05 
DEFINE l_raa06        LIKE raa_file.raa06 
DEFINE l_raaacti      LIKE raa_file.raaacti
DEFINE l_raaconf      LIKE raa_file.raaconf 
DEFINE p_cmd          LIKE type_file.chr1

   SELECT raa03,raaacti,raaconf,raa05,raa06 
    INTO l_raa03,l_raaacti,l_raaconf,l_raa05,l_raa06 FROM raa_file
    WHERE raa01 = g_rah.rah01 AND raa02 = g_rah.rah03

  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196' 
                              LET l_raa03=NULL 
     WHEN l_raaacti='N'       LET g_errno='9028'    
     WHEN l_raaconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
 #FUN-BB0059 mark START 
 #IF p_cmd = 'a' THEN
 #   LET g_rah.rah04 = l_raa05 
 #   LET g_rah.rah05 = l_raa06 
 #   DISPLAY BY NAME g_rah.rah04,g_rah.rah05
 #END IF
 #FUN-BB0059 mark END
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_raa03 TO FORMONLY.rah03_desc
  END IF
 #FUN-BB0059 mark START 
 #IF p_cmd='a' THEN
 #   SELECT raa05,raa06 INTO g_rah.rah04,g_rah.rah05
 #     FROM raa_file
 #    WHERE raa01=g_rah.rah01 AND raa02=g_rah.rah03
 #   DISPLAY BY NAME g_rah.rah04,g_rah.rah05
 #END IF 
 #FUN-BB0059 mark END

END FUNCTION

FUNCTION t304_rah10()
   IF NOT cl_null(g_rah.rah10) THEN
      CASE g_rah.rah10
       WHEN '2' 
                CALL cl_set_comp_visible("rai06,rai09",FALSE)
               #CALL cl_set_comp_visible("rai10",FALSE)  #FUN-BB0059 add   #FUN-C30151 mark
                CALL cl_set_comp_visible("rai05,rai08",TRUE)
               #FUN-C30151 add START
                IF g_rah.rah25 = '1' THEN  
                   CALL cl_set_comp_visible("rai10",FALSE)
                ELSE
                   CALL cl_set_comp_visible("rai10",TRUE)
                END IF
               #FUN-C30151 add END
       WHEN '3' 
                CALL cl_set_comp_visible("rai06,rai09",TRUE)
               #CALL cl_set_comp_visible("rai10",TRUE)  #FUN-BB0059 add   #FUN-C30151 mark
                CALL cl_set_comp_visible("rai05,rai08",FALSE)
#FUN-BB0059 add START
       WHEN '4' 
               #CALL cl_set_comp_visible("rai06,rai09,rai10",TRUE)  #FUN-C30151 mark
                CALL cl_set_comp_visible("rai05,rai08",FALSE)
#FUN-BB0059 add END
      END CASE
   END IF
END FUNCTION

FUNCTION t304_rah11()
   IF NOT cl_null(g_rah.rah11) THEN
      IF g_rah.rah11 = '1' THEN
        #CALL cl_set_comp_entry("raj03,raj04,raj05,raj06,rajacti",FALSE) #FUN-B80095 MARK
        #CALL cl_set_comp_visible("Page6",FALSE)                         #FUN-B80095 REMARK  #FUN-BB0059 mark
         CALL cl_set_comp_visible('pc3',FALSE)          #FUN-BB0059 add  
      ELSE
        #CALL cl_set_comp_entry("raj03,raj04,raj05,raj06,rajacti",TRUE)  #FUN-B80095 MARK
        #CALL cl_set_comp_visible("Page6",TRUE)                          #FUN-B80095 REMARK  #FUN-BB0059 mark
         CALL cl_set_comp_visible('pc3',TRUE)          #FUN-BB0059 add
      END IF
   END IF
END FUNCTION
#FUN-BB0059 mark START
#FUNCTION t304_rah22()
#  IF NOT cl_null(g_rah.rah11) THEN
#     IF g_rah.rah22 = '1' THEN
#        LET g_rah.rah23 = 1 
#        CALL cl_set_comp_entry("rah23",FALSE)
#     ELSE
#        IF NOT cl_null(g_rah.rah23) AND g_rah.rah23 =1 THEN 
#           LET g_rah.rah23 = 2
#        END IF
#        CALL cl_set_comp_entry("rah23",TRUE)
#        CALL cl_set_comp_required("rah23",TRUE)
#     END IF
#     DISPLAY BY NAME g_rah.rah23
#  END IF
#END FUNCTION
#FUN-BB0059 mark END
FUNCTION t304_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahacti ='N' THEN
      CALL cl_err(g_rah.rah02,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rah.rahconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rah.rahconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   #TQC-AC0326 add ---------begin----------
   IF g_rah.rah01 <> g_rah.rahplant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
   #TQC-AC0326 add ----------end-----------   
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t304_cl:", STATUS, 1)
      CLOSE t304_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t304_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
       CLOSE t304_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t304_show()
 
   WHILE TRUE
      LET g_rah_o.* = g_rah.*
      LET g_rah.rahmodu=g_user
      LET g_rah.rahdate=g_today
 
      CALL t304_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rah.*=g_rah_o.*
         CALL t304_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
     #IF g_rah.rah01 != g_rah_t.rah01 THEN
     #   UPDATE rai_file SET rai01 = g_rah.rah01
     #     WHERE rai02 = g_rah_t.rah02 AND rai01 = g_rah_t.rah01
     #       AND raiplant = g_rah_t.rahplant
     #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #      CALL cl_err3("upd","rai_file",g_rah_t.rah01,"",SQLCA.sqlcode,"","rai",1)
     #      CONTINUE WHILE
     #   END IF
     #END IF
 
      UPDATE rah_file SET rah_file.* = g_rah.*
         WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01  
           AND rahplant = g_rah.rahplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rah_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
  #FUN-BB0059 mark START
  #IF g_rah.rah04<>g_rah_o.rah04 OR
  #   g_rah.rah05<>g_rah_o.rah05 OR
  #   g_rah.rah06<>g_rah_o.rah06 OR
  #   g_rah.rah07<>g_rah_o.rah07 OR
  #   g_rah.rah11<>g_rah_o.rah11 THEN
  #   CALL t304_total_check()  #head_check
  #END IF
  #FUN-BB0059 mark END
#FUN-BB0059 add START
  #IF g_rah.rah10 = 2 THEN  #FUN-C30151 mark
   IF g_rah.rah10 = 2 AND g_rah.rah25 = '1' THEN  #FUN-C30151 add 
      CALL cl_set_comp_visible('rai10',FALSE) 
      UPDATE rai_file SET rai10 = 0
          WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
            AND rai03=g_rai_t.rai03 AND raiplant = g_rah.rahplant     
   ELSE
      CALL cl_set_comp_visible('rai10',TRUE)
   END IF
#FUN-BB0059 add END
   CLOSE t304_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rah.rah02,'U')
 
#TQC-A90013 --add
   CALL cl_set_act_visible("gift",g_rah.rah19='Y') 
#TQC-A90013 --end
   CALL t304_b_fill("1=1")
   CALL t304_b1_fill("1=1")

END FUNCTION
 



FUNCTION t304_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
#FUN-BB0059 add START
DEFINE l_rai03    LIKE rai_file.rai03
DEFINE l_rai07    LIKE rai_file.rai07
DEFINE l_sql      STRING
#FUN-BB0059 add END
#FUN-C10008 add START
DEFINE l_n        LIKE type_file.num5
DEFINE l_rar04    LIKE rar_file.rar04
DEFINE l_rar05    LIKE rar_file.rar05
#FUN-C10008 add END
   IF g_rah.rah02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 -------------------- add ------------------ begin
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err(g_rah.rah01,'9024',0) RETURN END IF
   IF g_rah.rahacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 -------------------- add ------------------ end 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err(g_rah.rah01,'9024',0) RETURN END IF 
   IF g_rah.rahacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
#條件設定尚未維護資料,不允許確認 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rai_file
    WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
      AND raiplant = g_rah.rahplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  SELECT SUM(raj10) INTO l_raj10 FROM raj_file
#      WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01
#        AND rajplant = g_rah.rahplant
#  IF l_raj10 IS NULL THEN LET l_raj10 = 0 END IF
#  SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '09'
#      AND rxx01 = g_rah.rah01 AND rxxplant = g_rah.rahplant 
#  IF l_rxx04 IS NULL THEN LET l_rxx04 = 0 END IF
#  IF l_rxx04 < l_raj10 THEN
#     CALL cl_err('','art-919',0)
#     RETURN
#  END IF

#-TQC-B60071 - ADD - BEGIN ---------------------------------
#參與方式為2.範圍促銷時,尚未維護範圍設定不可確認
   IF g_rah.rah11 = '2' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM raj_file 
       WHERE raj01 = g_rah.rah01 AND raj02 = g_rah.rah02 AND rajacti = 'Y'
      IF l_cnt = 0 THEN
         CALL cl_err('','art-731',0)
         RETURN
      END IF
   END IF
#-TQC-B60071 - ADD -  END  ---------------------------------
#FUN-BB0059 add START
  #促銷時段未維護資料 不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rak_file
       WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02
         AND rakacti = 'Y' AND rakplant = g_rah.rahplant
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      CALL cl_err('','art-751',0)
      RETURN
   END IF

  #組別設定有促銷方式,但該組別未設定會員促銷方式,不允許確認
   LET l_sql = " SELECT rai03,rai07 FROM rai_file ",
               " WHERE rai01 = '",g_rah.rah01,"' AND rai02 = '",g_rah.rah02,"' ",
               " AND raiacti = 'Y' AND raiplant = '",g_rah.rahplant,"' ",
               " AND rai07 <> '0' "
   PREPARE t304_rai07 FROM l_sql
   DECLARE rai07_cs CURSOR FOR t304_rai07
   FOREACH rai07_cs INTO l_rai03,l_rai07
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rap_file
         WHERE rap01  = g_rah.rah01 AND rap02 = g_rah.rah02
           AND rap03 = '3'
           AND rap04 = l_rai03 AND rap09 = l_rai07 
      IF l_cnt < 1 THEN
         CALL cl_err_msg('','art-785',l_rai03 CLIPPED,0)
         RETURN
      END IF
   END FOREACH

  #未維護生效營運中心  不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM raq_file
       WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
       AND raq03 = '3' AND raqplant = g_rah.rahplant
       AND raqacti = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','art-755',0)
      RETURN
   END IF

  #勾選參予換贈,但未維護換贈資料,不允許確認
   LET l_cnt = 0
   IF g_rah.rah19 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM rar_file
         WHERE rar01 = g_rah.rah01 AND rar02 = g_rah.rah02
           AND rar03 = '3' AND rarplant = g_rah.rahplant
      IF l_cnt < 1 THEN
         CALL cl_err('','art-783',0)
         RETURN
      END IF
   END IF
#FUN-BB0059 add END
#FUN-C10008 add START
  #換贈存在未維護換贈代碼的換贈項次,不允許確認
   LET l_cnt = 0
   IF g_rah.rah19 = 'Y' THEN
      LET l_sql = " SELECT DISTINCT rar04,rar05 FROM rar_file ",
                  "   WHERE rar01 = '",g_rah.rah01,"'",
                  "     AND rar02 = '",g_rah.rah02,"'",
                  "     AND rar03 = 3",
                  "     AND rarplant = '",g_rah.rahplant,"'"
      PREPARE t304_rar FROM l_sql
      DECLARE rar_cs CURSOR FOR t304_rar
      FOREACH rar_cs INTO l_rar04, l_rar05
         SELECT COUNT(*) INTO l_n FROM ras_file
           WHERE ras01 = g_rah.rah01 AND ras02 = g_rah.rah02
             AND ras03 = 3 AND rasplant = g_rah.rahplant
             AND ras04 = l_rar04 AND ras05 = l_rar05
         IF l_n < 1 THEN
            CALL cl_err('','art-799',0)
            RETURN
         END IF
      END FOREACH
   END IF
#FUN-C10008 add END

#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t304_cl:", STATUS, 1)
      CLOSE t304_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t304_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
      CLOSE t304_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rah_file SET rahconf='Y',
                       rahcond=g_today, 
                       rahcont=g_time, 
                       rahconu=g_user
     WHERE  rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rah.rahconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rah.rah02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01 
        AND rahplant = g_rah.rahplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rah.rahconu
   DISPLAY BY NAME g_rah.rahconf                                                                                         
   DISPLAY BY NAME g_rah.rahcond                                                                                         
   DISPLAY BY NAME g_rah.rahcont                                                                                         
   DISPLAY BY NAME g_rah.rahconu
   DISPLAY l_gen02 TO FORMONLY.rahconu_desc
    #CKP
   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rah.rah02,'V')
END FUNCTION
 
#FUN-AB0033 mark -----------start--------------- 
#FUNCTION t304_void()
#DEFINE l_n LIKE type_file.num5
# 
#   IF s_shut(0) THEN RETURN END IF
#   SELECT * INTO g_rah.* FROM rah_file 
#      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
#        AND rahplant = g_rah.rahplant
#   IF g_rah.rah02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#   IF g_rah.rahacti = 'N' THEN CALL cl_err(g_rah.rah02,'art-142',0) RETURN END IF
#   IF g_rah.rahconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF
#   BEGIN WORK
# 
#   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t304_cl:", STATUS, 1)
#      CLOSE t304_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t304_cl INTO g_rah.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rah.rah02,SQLCA.sqlcode,0)
#      CLOSE t304_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   IF cl_void(0,0,g_rah.rahconf) THEN
#      LET g_chr = g_rah.rahconf
#      IF g_rah.rahconf = 'N' THEN
#         LET g_rah.rahconf = 'X'
#      ELSE
#         LET g_rah.rahconf = 'N'
#      END IF
# 
#      UPDATE rah_file SET rahconf=g_rah.rahconf,
#                          rahmodu=g_user,
#                          rahdate=g_today
#       WHERE rah01 = g_rah.rah01  AND rah02 = g_rah.rah02
#         AND rahplant = g_rah.rahplant  
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","rah_file",g_rah.rah01,"",SQLCA.sqlcode,"","up rahconf",1)
#          LET g_rah.rahconf = g_chr
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END IF
# 
#   CLOSE t304_cl
#   COMMIT WORK
# 
#   SELECT * INTO g_rah.* FROM rah_file WHERE rah01=g_rah.rah01 AND rah02 = g_rah.rah02 AND rahplant = g_rah.rahplant 
#   DISPLAY BY NAME g_rah.rahconf                                                                                        
#   DISPLAY BY NAME g_rah.rahmodu                                                                                        
#   DISPLAY BY NAME g_rah.rahdate
#    #CKP
#   IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")
# 
#   CALL cl_flow_notify(g_rah.rah01,'V')
#END FUNCTION
#FUN-AB0033 mark ------------end---------------

FUNCTION t304_bp_refresh()
#  DISPLAY ARRAY g_rai TO s_rai.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 

FUNCTION t304_rah06()
DEFINE l_gen02    LIKE gen_file.gen02

#   LET g_errno = ' '
#   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rah.rah06 AND genacti = 'Y'
#
#   CASE
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'proj-15'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#   DISPLAY l_gen02 TO rah06_desc
END FUNCTION
  
FUNCTION t304_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rah.rahconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rah.rahconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t304_cl:", STATUS, 1)
      CLOSE t304_cl
      RETURN
   END IF
 
   FETCH t304_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t304_show()
 
  #IF g_rah.rahconf = 'Y' THEN
  #   CALL cl_err('','art-022',0)
  #   RETURN
  #END IF 
   
   IF cl_exp(0,0,g_rah.rahacti) THEN
      LET g_chr=g_rah.rahacti
      IF g_rah.rahacti='Y' THEN
         LET g_rah.rahacti='N'
      ELSE
         LET g_rah.rahacti='Y'
      END IF
 
      UPDATE rah_file SET rahacti=g_rah.rahacti,
                          rahmodu=g_user,
                          rahdate=g_today
       WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
         AND rahplant = g_rah.rahplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rah_file",g_rah.rah01,"",SQLCA.sqlcode,"","",1) 
         LET g_rah.rahacti=g_chr
      END IF
   END IF
 
   CLOSE t304_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rah.rah01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rahacti,rahmodu,rahdate
     INTO g_rah.rahacti,g_rah.rahmodu,g_rah.rahdate FROM rah_file
    WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
      AND rahplant = g_rah.rahplant

   DISPLAY BY NAME g_rah.rahacti,g_rah.rahmodu,g_rah.rahdate
 
END FUNCTION
 
FUNCTION t304_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
      AND rahplant = g_rah.rahplant
 
   IF g_rah.rahconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rah.rahconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rah.rahacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
   
   IF g_aza.aza88='Y' AND g_rah.rahpos='3' THEN #NO.FUN-B40071   
         #CALL cl_err('', 'art-648', 1)         #NO.FUN-B40071
         CALL cl_err('', 'apc-139', 1)          #NO.FUN-B40071
         RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t304_cl:", STATUS, 1)
      CLOSE t304_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t304_cl INTO g_rah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t304_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rah01"      
       LET g_doc.value1 = g_rah.rah01    
       CALL cl_del_doc()              
      DELETE FROM rah_file WHERE rah02 = g_rah.rah02 AND rah01 = g_rah.rah01
                             AND rahplant = g_rah.rahplant
      DELETE FROM rai_file WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                             AND raiplant = g_rah.rahplant 
      DELETE FROM raj_file WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                             AND rajplant = g_rah.rahplant
      DELETE FROM raq_file WHERE raq02 = g_rah.rah02 AND raq01 = g_rah.rah01
                             AND raqplant = g_rah.rahplant AND raq03 = '3'
      DELETE FROM rap_file WHERE rap02 = g_rah.rah02 AND rap01 = g_rah.rah01
                             AND rapplant = g_rah.rahplant AND rap03 = '3'
      DELETE FROM rar_file WHERE rar02 = g_rah.rah02 AND rar01 = g_rah.rah01
                             AND rarplant = g_rah.rahplant AND rar03 = '3'
      DELETE FROM ras_file WHERE ras02 = g_rah.rah02 AND ras01 = g_rah.rah01
                             AND rasplant = g_rah.rahplant AND ras03 = '3'
      DELETE FROM rak_file WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02  #FUN-C10008 add 
                             AND rakplant = g_rah.rahplant  AND rak03 = '3'   #FUN-C10008 add   

      CLEAR FORM
      CALL g_rai.clear() 
      CALL g_raj.clear()
      CALL g_rak.clear()

      OPEN t304_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t304_cs
         CLOSE t304_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t304_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t304_cs
         CLOSE t304_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t304_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t304_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t304_fetch('/')
      END IF
   END IF
 
   CLOSE t304_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rah.rah01,'D')
END FUNCTION
 
{FUNCTION t304_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_ac_o          LIKE type_file.num5, #FUN-AB0033 add
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
DEFINE l_s        LIKE type_file.chr1000 
DEFINE l_m        LIKE type_file.chr1000 
DEFINE i          LIKE type_file.num5
DEFINE l_s1       LIKE type_file.chr1000 
DEFINE l_m1       LIKE type_file.chr1000 
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_azp03    LIKE azp_file.azp03
DEFINE l_line     LIKE type_file.num5
DEFINE l_sql1     STRING
DEFINE l_bamt     LIKE type_file.num5
DEFINE l_rxx04    LIKE rxx_file.rxx04
 
DEFINE l_price    LIKE type_file.num20   #TQC-AC0196 mod num20
DEFINE l_discount LIKE rai_file.rai06
DEFINE l_success  LIKE type_file.chr1    #FUN-B30012 ADD 
DEFINE l_flag           LIKE type_file.chr1    #FUN-D30033

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rah.rah02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
 
    IF g_rah.rahacti ='N' THEN
       CALL cl_err(g_rah.rah01||g_rah.rah02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rah.rahconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rah.rahconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    
    #TQC-AC0326 add ---------begin----------
    IF g_rah.rah01 <> g_rah.rahplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #TQC-AC0326 add ----------end-----------
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rai03,rai04,rai05,rai06,rai07,rai08,", 
                       "       rai09,raiacti", 
                       "  FROM rai_file ",
                       " WHERE rai01 = ? AND rai02=? AND rai03=? AND raiplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t304_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rai WITHOUT DEFAULTS FROM s_rai.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t304_cl:", STATUS, 1)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t304_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rai_t.* = g_rai[l_ac].*  #BACKUP
              LET g_rai_o.* = g_rai[l_ac].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("rai03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rai03",TRUE)
              END IF   
              OPEN t304_bcl USING g_rah.rah01,g_rah.rah02,g_rai_t.rai03,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t304_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t304_bcl INTO g_rai[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rai_t.rai03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
          END IF 
          CALL t304_rai_entry()

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rai[l_ac].* TO NULL
           LET g_rai[l_ac].raiacti = 'Y'    
           LET g_rai[l_ac].rai07 = 'N'
           IF g_rah.rah10 = '2' THEN
              LET g_rai[l_ac].rai06 = 0 
              LET g_rai[l_ac].rai09 = 0 
           END IF
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("rai03",FALSE)
           ELSE
              CALL cl_set_comp_entry("rai03",TRUE)
           END IF   
           LET g_rai_t.* = g_rai[l_ac].*
           LET g_rai_o.* = g_rai[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rai03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
          #IF cl_null(g_rai[l_ac].rai04) AND cl_null(g_rai[l_ac].rai05)
          #   AND cl_null(g_rai[l_ac].rai06) THEN
          #   CALL cl_err('','art-629',0)
          #   DISPLAY BY NAME g_rai[l_ac].rai07
          #   NEXT FIELD rai04
          #END IF
          #IF g_rai[l_ac].rai07 IS NULL THEN LET g_rai[l_ac].rai07 = 0 END IF
           IF cl_null(g_rai[l_ac].rai06) THEN LET g_rai[l_ac].rai06 = 0  END IF
           IF cl_null(g_rai[l_ac].rai09) THEN LET g_rai[l_ac].rai09 = 0  END IF
           INSERT INTO rai_file(rai01,rai02,rai03,rai04,rai05,rai06,
                                rai07,rai08,rai09,raiacti,raiplant,railegal)      
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_rai[l_ac].rai03,g_rai[l_ac].rai04,
                  g_rai[l_ac].rai05,g_rai[l_ac].rai06,
                  g_rai[l_ac].rai07,g_rai[l_ac].rai08,
                  g_rai[l_ac].rai09,g_rai[l_ac].raiacti,                    
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rai_file",g_rah.rah01,g_rai[l_ac].rai03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF p_cmd='u' THEN
                 CALL t304_upd_log()
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rai03
           IF g_rai[l_ac].rai03 IS NULL OR g_rai[l_ac].rai03 = 0 THEN
              SELECT max(rai03)+1
                INTO g_rai[l_ac].rai03
                FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND raiplant = g_rah.rahplant
              IF g_rai[l_ac].rai03 IS NULL THEN
                 LET g_rai[l_ac].rai03 = 1
              END IF
           END IF
 
        AFTER FIELD rai03
           IF NOT cl_null(g_rai[l_ac].rai03) THEN
              IF g_rai[l_ac].rai03 != g_rai_t.rai03
                 OR g_rai_t.rai03 IS NULL THEN
                 SELECT COUNT(*)
                   INTO l_n
                   FROM rai_file
                  WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                    AND rai03 = g_rai[l_ac].rai03 AND raiplant = g_rah.rahplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rai[l_ac].rai03 = g_rai_t.rai03
                    NEXT FIELD rai02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rai04
         IF NOT cl_null(g_rai[l_ac].rai04) THEN
            IF g_rai_o.rai04 IS NULL OR
               (g_rai[l_ac].rai04 != g_rai_o.rai04 ) THEN
               IF g_rai[l_ac].rai04 < 0 THEN
                  CALL cl_err(g_rai[l_ac].rai04,'aec-020',0)
                  LET g_rai[l_ac].rai04= g_rai_o.rai04
                  NEXT FIELD rai04
               END IF
            END IF
            #FUN-AB0033 add ------------start-------------
            IF l_ac = 1 THEN
               LET l_ac_o = 1
            ELSE 
            	 LET l_ac_o = l_ac - 1   
            END IF   
            IF g_rai[l_ac].rai04 < g_rai[l_ac_o].rai04  THEN
               CALL cl_err(g_rai[l_ac].rai04,'aec-030',0)
               NEXT FIELD rai04
            END IF   
            #FUN-AB0033 add -------------end--------------
         END IF

      ON CHANGE rai07
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t304_rai_entry()
         END IF         

      AFTER FIELD rai07
         IF g_rai[l_ac].rai07 = 'Y' THEN
            LET g_rai[l_ac].rai08 = ''
            LET g_rai[l_ac].rai09 = 0
            DISPLAY BY NAME g_rai[l_ac].rai08,g_rai[l_ac].rai09
         ELSE 
   #        IF g_rah.rah10 = '3' AND g_rai[l_ac].rai09 <= 0 THEN    #TQC-A80156
      #      IF g_rah.rah10 = '3' AND (g_rai[l_ac].rai09 <= 0 OR g_rai[l_ac].rai09 >=100) THEN   #TQC-A80156  #TQC-AC0196 mark
      #        CALL cl_err('','art-180',0)                                                       #TQC-AC0196 mark
      #        NEXT FIELD rai09                                                                  #TQC-AC0196 mark
      #      END IF                                                                              #TQC-AC0196 mark
            IF g_rah.rah10 = '2' AND g_rai[l_ac].rai08 IS NULL THEN
              NEXT FIELD rai08
            END IF
         END IF
      BEFORE FIELD rai05,rai06,rai08,rai09
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t304_rai_entry()
         END IF

#     AFTER FIELD rai05,rai09    #特賣價      #TQC-A80157
      AFTER FIELD rai06,rai09    #折讓額      #TQC-A80157
         LET l_price = FGL_DIALOG_GETBUFFER()
         #TQC-AC0196 add begin--------------------
         IF l_price > g_rai[l_ac].rai04 THEN
#TQC-B30050 --begin--
           #IF g_rah.rah10 = '3' AND g_rah.rah25 = '2' THEN   #CHI-C80035 mark
            IF (g_rah.rah10 = '3' OR g_rah.rah10 = '4') AND g_rah.rah25 = '2' THEN   #CHI-C80035 add
            ELSE  
#TQC-B30050 --end--         
               CALL cl_err('','art-850',0)
               NEXT FIELD CURRENT
            END IF                     #TQC-B30050    
         END IF
         #TQC-AC0196 add end----------------------
         IF l_price <= 0 THEN      # TQC-A80156     #TQC-A90027 
#        IF l_price <= 0 OR l_price >= 100 THEN    #TQC-A80156     #TQC-A90027
#           CALL cl_err('','art-180',0)      #TQC-A90027   mark
            CALL cl_err('','art-653',0)      #TQC-A90027    add
            NEXT FIELD CURRENT
         ELSE
           #CASE 
           #  WHEN INFIELD(rai05)
           #       LET g_rai[l_ac].rai06 = l_price/l_stdprice*100
           #  WHEN INFIELD(rai09)
           #       LET g_rai[l_ac].rai10 = l_price/l_memprice*100
           #END CASE
            DISPLAY BY NAME g_rai[l_ac].rai05,g_rai[l_ac].rai09
           #DISPLAY BY NAME CURRENT
         END IF

#     AFTER FIELD rai06   #折扣率      #TQC-A80157
      AFTER FIELD rai05,rai08   #折扣率      #TQC-A80157  #TQC-AC0196 add rai08
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
             #CASE 
             #  WHEN INFIELD(rai06)
             #       LET g_rai[l_ac].rai07 = l_stdprice*l_discount/100
             #  WHEN INFIELD(rai10)
             #       LET g_rai[l_ac].rai11 = l_memprice*l_discount/100
             #END CASE
              DISPLAY BY NAME g_rai[l_ac].rai06
           END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rai_t.rai03 > 0 AND g_rai_t.rai03 IS NOT NULL THEN
             #LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rah.rah01,"' AND rxx03='1'"
             #PREPARE t304_prxx04 FROM l_sql1
             #DECLARE t304_crxx04 CURSOR FOR t304_prxx04
             #LET l_bamt=0
             #FOREACH t304_crxx04 INTO l_rxx04
             #    LET l_bamt=l_rxx04+l_bamt
             #END FOREACH 
             #IF l_bamt>0 THEN
             #   CALL cl_err('','art-634',1) 
             #   CANCEL DELETE
             #END IF 
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              LET l_success = 'Y'          ##FUN-B30012 ADD
              CALL s_showmsg_init()        ##FUN-B30012 ADD
              DELETE FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND rai03 = g_rai_t.rai03  AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
         #       CALL cl_err3("del","rai_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1)    #FUN-B30012 MARK 
         #       ROLLBACK WORK             #FUN-B30012 MARK
         #       CANCEL DELETE             #FUN-B30012 MARK
                 CALL s_errmsg('del','','rai_file',SQLCA.sqlcode,1)  #FUN-B30012 ADD
                 LET l_success = 'N'                                 #FUN-B30012 ADD
              ELSE 
               	 DELETE FROM raj_file 
               	  WHERE raj01 = g_rah.rah01   AND raj02 = g_rah.rah02
                    AND raj03 = g_rai_t.rai03 AND rajplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
         #          CALL cl_err3("del","raj_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) #FUN-B30012 MARK 
         #          ROLLBACK WORK         #FUN-B30012 MARK
         #          CANCEL DELETE         #FUN-B30012 MARK
                    CALL s_errmsg('del','','raj_file',SQLCA.sqlcode,1)    #FUN-B30012 ADD
                    LET l_success = 'N'                                   #FUN-B30012 ADD
                 END IF 
         ##FUN-B30012 ADD  ----BEGIN----
                 DELETE FROM rap_file
                  WHERE rap01 = g_rah.rah01 AND rap02 = g_rah.rah02
                    AND rap03 = '3'
                    AND rap04 = g_rai_t.rai03
                    AND rapplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','rap_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF
                 DELETE FROM rar_file
                  WHERE rar01 = g_rah.rah01 AND rar02 = g_rah.rah02
                    AND rar03 = '3'
                    AND rar04 = g_rai_t.rai03
                    AND rarplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','rar_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF
                 DELETE FROM ras_file
                  WHERE ras01 = g_rah.rah01 AND ras02 = g_rah.rah02
                    AND ras03 = '3'
                    AND ras04 = g_rai_t.rai03
                    AND rasplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','ras_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF
         ##FUN-B30012 ADD  -----END-----
              END IF
         ##FUN-B30012 ADD  ----BEGIN----
              IF l_success = 'N' THEN
                 CALL s_showmsg()
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
         ##FUN-B30012 ADD  -----END-----
              CALL t304_upd_log() 
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rai[l_ac].* = g_rai_t.*
              CLOSE t304_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rai[l_ac].rai04) THEN
              NEXT FIELD rai04
           END IF
          #IF NOT cl_null(g_rai[l_ac].rai04) THEN
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rai[l_ac].rai03,-263,1)
              LET g_rai[l_ac].* = g_rai_t.*
           ELSE
              UPDATE rai_file SET rai04  =g_rai[l_ac].rai04,
                                  rai05  =g_rai[l_ac].rai05,
                                  rai06  =g_rai[l_ac].rai06,
                                  rai07  =g_rai[l_ac].rai07,
                                  rai08  =g_rai[l_ac].rai08,
                                  rai09  =g_rai[l_ac].rai09,
                                  raiacti=g_rai[l_ac].raiacti
               WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
                 AND rai03=g_rai_t.rai03 AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rai_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) 
                 LET g_rai[l_ac].* = g_rai_t.*
              ELSE
                 MESSAGE 'UPDATE rai_file O.K'
                 CALL t304_upd_log() 
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
                 LET g_rai[l_ac].* = g_rai_t.*
              END IF
              CLOSE t304_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #MOD-AC0172 add begin-----------------------------
           IF NOT cl_null(g_rah.rah02) THEN
              IF g_rai[l_ac].rai07 = 'Y' THEN
                 #CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10) #FUN-BB0059 mark 
                  CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10,g_rai[l_ac].rai07) #FUN-BB0059 add
              END IF
           ELSE
              CALL cl_err('',-400,0)
           END IF
           #MOD-AC0172 add end-------------------------------
           CLOSE t304_bcl
           COMMIT WORK
        
        #MOD-AC0172 mark --begin---------------------------
        #ON ACTION Memberlevel    #會員等級促銷
        #   IF NOT cl_null(g_rah.rah02) THEN
        #      CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10)
        #   ELSE
        #      CALL cl_err('',-400,0)
        #   END IF
        #MOD-AC0172 mark ---end----------------------------

        ON ACTION CONTROLO
           IF INFIELD(rai03) AND l_ac > 1 THEN
              LET g_rai[l_ac].* = g_rai[l_ac-1].*
              LET g_rai[l_ac].rai03 = g_rec_b + 1
              NEXT FIELD rai04
           END IF
 
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
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
    UPDATE rah_file SET rahmodu = g_rah.rahmodu,rahdate = g_rah.rahdate
      WHERE rah01 = g_rah.rah01
        AND rah02 = g_rah.rah02
        AND rahplant = g_rah.rahplant 
    DISPLAY BY NAME g_rah.rahmodu,g_rah.rahdate
    CLOSE t304_bcl
    COMMIT WORK
    CALL t304_delall()
 
END FUNCTION
}
FUNCTION t304_upd_log()
   LET g_rah.rahmodu = g_user
   LET g_rah.rahdate = g_today
   UPDATE rah_file SET rahmodu = g_rah.rahmodu,
                       rahdate = g_rah.rahdate
    WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
      AND rahplant = g_rah.rahplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rah_file",g_rah.rahmodu,g_rah.rahdate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rah.rahmodu,g_rah.rahdate
   MESSAGE 'UPDATE rah_file O.K.'
END FUNCTION

FUNCTION t304_chktime(p_time)  #check 時間格式
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


FUNCTION t304_rai_entry()
DEFINE p_rai04    LIKE rai_file.rai04   

          CASE g_rah.rah10
             WHEN '2'
                CALL cl_set_comp_entry("rai05",TRUE)
                CALL cl_set_comp_entry("rai06",FALSE)
                CALL cl_set_comp_required("rai05",TRUE)
             WHEN '3'
                CALL cl_set_comp_entry("rai05",FALSE)
                CALL cl_set_comp_entry("rai06",TRUE)
                CALL cl_set_comp_required("rai06",TRUE)
            #FUN-BB0059 add START
             WHEN '4'
                CALL cl_set_comp_entry("rai05",FALSE)
                CALL cl_set_comp_entry("rai06",TRUE)
                CALL cl_set_comp_required("rai06",TRUE)
            #FUN-BB0059 add END
             OTHERWISE
                CALL cl_set_comp_entry("rai05",TRUE)
                CALL cl_set_comp_entry("rai06",TRUE)
                CALL cl_set_comp_required("rai05",TRUE)
                CALL cl_set_comp_required("rai06",TRUE)
          END CASE
           
         #IF g_rai[l_ac].rai07='Y' THEN  #FUN-BB0059 mark
          IF g_rai[l_ac].rai07 <> '0' THEN  #FUN-BB0059 add
             CALL cl_set_comp_entry("rai08,rai09",FALSE)
          ELSE
             CASE g_rah.rah10
                WHEN '2'
                   CALL cl_set_comp_entry("rai08",TRUE)
                   CALL cl_set_comp_entry("rai09",FALSE)
                   CALL cl_set_comp_required("rai08",TRUE)
                WHEN '3'
                   CALL cl_set_comp_entry("rai08",FALSE)
                   CALL cl_set_comp_entry("rai09",TRUE)
                   CALL cl_set_comp_required("rai09",TRUE)
             #FUN-BB0059 add START
                WHEN '4'
                   CALL cl_set_comp_entry("rai08",FALSE)
                   CALL cl_set_comp_entry("rai09",TRUE)
                   CALL cl_set_comp_required("rai09",TRUE)
             #FUN-BB0059 add END
                OTHERWISE
                   CALL cl_set_comp_entry("rai08",TRUE)
                   CALL cl_set_comp_entry("rai09",TRUE)
                   CALL cl_set_comp_required("rai08",TRUE)
                   CALL cl_set_comp_required("rai09",TRUE)
             END CASE
          END IF

END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t304_delHeader()

   SELECT COUNT(*) INTO g_cnt FROM rai_file
    WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
      AND raiplant = g_rah.rahplant
   IF g_cnt > 0 THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM rak_file
    WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02
      AND rak03 = 3 AND rakplant = g_rah.rahplant
   IF g_cnt > 0 THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM raj_file
    WHERE raj01 = g_rah.rah01 AND raj02 = g_rah.rah02
      AND rajplant = g_rah.rahplant
   IF g_cnt > 0 THEN RETURN END IF
   IF cl_confirm("9042") THEN
      DELETE FROM rah_file WHERE rah01 = g_rah.rah01 AND rah02=g_rah.rah02 AND rahplant=g_rah.rahplant
      DELETE FROM raq_file WHERE raq01 = g_rah.rah01 AND raq02=g_rah.rah02
                             AND raq03='3' AND raqplant=g_rah.rahplant
      DELETE FROM rak_file WHERE rak01 = g_rah.rah01 AND rak02=g_rah.rah02
                             AND rak03='3' AND rakplant=g_rah.rahplant
      INITIALIZE g_rah.* TO NULL
      CLEAR FORM
      CALL g_rai.clear()
   END IF 
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t304_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rai_file
#   WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
#     AND raiplant = g_rah.rahplant
# #FUN-C10008 add START
#  IF g_cnt > 0 THEN RETURN END IF
#  SELECT COUNT(*) INTO g_cnt FROM rak_file
#   WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02
#     AND rak03 = 3 AND rakplant = g_rah.rahplant
#  IF g_cnt > 0 THEN RETURN END IF
#  SELECT COUNT(*) INTO g_cnt FROM raj_file
#   WHERE raj01 = g_rah.rah01 AND raj02 = g_rah.rah02
#     AND rajplant = g_rah.rahplant
#  IF g_cnt > 0 THEN RETURN END IF
# #FUN-C10008 add END 
#
# #IF g_cnt = 0 THEN  #FUN-C10008 mark
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rah_file WHERE rah01 = g_rah.rah01 AND rah02=g_rah.rah02 AND rahplant=g_rah.rahplant
#     DELETE FROM raq_file WHERE raq01 = g_rah.rah01 AND raq02=g_rah.rah02 
#                            AND raq03='3' AND raqplant=g_rah.rahplant
#     #FUN-BB0059 add START
#     DELETE FROM rak_file WHERE rak01 = g_rah.rah01 AND rak02=g_rah.rah02
#                            AND rak03='3' AND rakplant=g_rah.rahplant
#     #FUN-BB0059 add END
#     CALL g_rai.clear()
# #END IF  #FUN-C10008 mark
#END FUNCTION
#CHI-C30002 -------- mark -------- end

{FUNCTION t304_b1()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rah.rah02 IS NULL THEN
       CALL cl_err(g_rah.rah02,'art-667',0)
       RETURN
    END IF
 
    SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
 
    IF g_rah.rahacti ='N' THEN
       CALL cl_err(g_rah.rah02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rah.rahconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF

    IF g_rah.rahconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    
    #TQC-AC0326 add ---------begin----------
    IF g_rah.rah01 <> g_rah.rahplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #TQC-AC0326 add ----------end-----------
    
    IF g_rah.rah11 = '1' THEN
       CALL cl_err(g_rah.rah02,'art-667',0)
       RETURN
    END IF

    CALL cl_opmsg('b')

  
    LET g_forupd_sql = "SELECT raj03,raj04,raj05,'',raj06,'',rajacti", 
                       "  FROM raj_file ",
                       " WHERE raj01=? AND raj02=? AND raj03=? AND raj04=? AND rajplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t3041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_raj WITHOUT DEFAULTS FROM s_raj.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t304_cl:", STATUS, 1)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t304_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_raj_t.* = g_raj[l_ac1].*  #BACKUP
              LET g_raj_o.* = g_raj[l_ac1].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("raj03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("raj03",TRUE)
              END IF 
              OPEN t3041_bcl USING g_rah.rah01,g_rah.rah02,g_raj_t.raj03,g_raj_t.raj04,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t3041_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t3041_bcl INTO g_raj[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_raj_t.raj03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t304_raj04()
                 CALL t304_raj05('d',l_ac1)
                 CALL t304_raj06('d')
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_raj[l_ac1].* TO NULL

           LET g_raj[l_ac1].rajacti = 'Y'            #Body default
           LET g_raj_t.* = g_raj[l_ac1].*
           LET g_raj_o.* = g_raj[l_ac1].*
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("raj03",FALSE)
           ELSE
              CALL cl_set_comp_entry("raj03",TRUE)
           END IF 
           CALL cl_show_fld_cont()
           NEXT FIELD raj03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF (NOT cl_null(g_raj[l_ac1].raj03)) AND
              (NOT cl_null(g_raj[l_ac1].raj04)) THEN
              SELECT COUNT(*) INTO l_n FROM raj_file
               WHERE raj01 =g_rah.rah01 AND raj02 = g_rah.rah02
                 AND raj03 = g_raj[l_ac1].raj03
                 AND raj04 = g_raj[l_ac1].raj04
                 AND rajplant = g_rah.rahplant
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD raj03
              END IF
           END IF

           INSERT INTO raj_file(raj01,raj02,raj03,raj04,raj05,raj06,
                                rajacti,rajplant,rajlegal)   
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_raj[l_ac1].raj03,g_raj[l_ac1].raj04,
                  g_raj[l_ac1].raj05,g_raj[l_ac1].raj06,
                  g_raj[l_ac1].rajacti,
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","raj_file",g_rah.rah01,g_raj[l_ac1].raj03,SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              CALL s_showmsg_init() 
              CALL t304_repeat(g_raj[l_ac1].raj03)  #check
              CALL s_showmsg() 
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF
 
       BEFORE FIELD raj03
          IF g_raj[l_ac1].raj03 IS NULL OR g_raj[l_ac1].raj03 = 0 THEN
             SELECT MAX(raj03)
               INTO g_raj[l_ac1].raj03
               FROM raj_file
              WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                AND rajplant = g_rah.rahplant
             IF g_raj[l_ac1].raj03 IS NULL THEN
                LET g_raj[l_ac1].raj03 = 1
             END IF
          END IF
 
       AFTER FIELD raj03
          IF NOT cl_null(g_raj[l_ac1].raj03) THEN
             IF g_raj[l_ac1].raj03 != g_raj_t.raj03
                OR g_raj_t.raj03 IS NULL THEN
#FUN-A80104 ADd BY LIXIA ----START---
             #  CALL t303_raj03()    #檢查其有效性     #FUN-AA0065     
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_raj[l_ac1].raj03,g_errno,0)
                   LET g_raj[l_ac1].raj03 = g_raj_o.raj03
                   NEXT FIELD raj03
                END IF
#FUN-A80104 ADD BY LIXIA ----END----                
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj03 = g_raj_t.raj03
                   NEXT FIELD raj03
                END IF
             END IF
          END IF
 
      AFTER FIELD raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            IF g_raj_o.raj04 IS NULL OR
               (g_raj[l_ac1].raj04 != g_raj_o.raj04 ) THEN
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj04 = g_raj_t.raj04
                   NEXT FIELD raj04
                END IF
               CALL t304_raj04()
               #FUN-AB0033 mark --------------start----------------- 
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(g_raj[l_ac1].raj04,g_errno,0)
               #   LET g_raj[l_ac1].raj04 = g_raj_o.raj04
               #   NEXT FIELD raj04
               #END IF
               #FUN-AB0033 mark --------------start-----------------
            END IF  
         END IF  

      ON CHANGE raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            CALL t304_raj04()   
            LET g_raj[l_ac1].raj05=NULL
            LET g_raj[l_ac1].raj05_desc=NULL
            LET g_raj[l_ac1].raj06=NULL
            LET g_raj[l_ac1].raj06_desc=NULL
            DISPLAY BY NAME g_raj[l_ac1].raj05,g_raj[l_ac1].raj05_desc
            DISPLAY BY NAME g_raj[l_ac1].raj06,g_raj[l_ac1].raj06_desc
         END IF
  
      BEFORE FIELD raj05,raj06
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            CALL t304_raj04()   
           #IF g_raj[l_ac1].raj04='1' THEN
           #   CALL cl_set_comp_entry("raj06",TRUE)
           #   CALL cl_set_comp_required("raj06",TRUE)
           #ELSE
           #   CALL cl_set_comp_entry("raj06",FALSE)
           #END IF
         END IF

      AFTER FIELD raj05
         IF NOT cl_null(g_raj[l_ac1].raj05) THEN
            IF g_raj[l_ac1].raj04 = '01' THEN #FUN-AB0033 add
               #FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_raj[l_ac1].raj05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_raj[l_ac1].raj05= g_raj_t.raj05
                  NEXT FIELD raj05
               END IF
               #FUN-AA0059 ---------------------end-------------------------------
            END IF #FUN-AB0033 add   
            IF g_raj_o.raj05 IS NULL OR
               (g_raj[l_ac1].raj05 != g_raj_o.raj05 ) THEN
               CALL t304_raj05('a',l_ac1) 
             # CALL t304sub_chk('3',g_rah.rahplant,g_rah.rah01,g_rah.rah02,p_group,g_rah.rah04,g_rah.rah05,g_rah.rah06,g_rah.rah07)
             # CALL t304sub_chk('3',g_rah.rahplant,g_raj[l_ac1].raj04,g_raj[l_ac1].raj05,g_raj[l_ac1].raj06,g_rah.rah04,
             #             g_rah.rah05,g_rah.rah06,g_rah.rah07)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj05,g_errno,0)
                  LET g_raj[l_ac1].raj05 = g_raj_o.raj05
                  NEXT FIELD raj05
               END IF
            END IF  
         END IF  

      AFTER FIELD raj06
         IF NOT cl_null(g_raj[l_ac1].raj06) THEN
            IF g_raj_o.raj06 IS NULL OR
               (g_raj[l_ac1].raj06 != g_raj_o.raj06 ) THEN
               CALL t304_raj06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj06,g_errno,0)
                  LET g_raj[l_ac1].raj06 = g_raj_o.raj06
                  NEXT FIELD raj06
               END IF
            END IF  
         END IF
        
        
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_raj_t.raj03 > 0 AND g_raj_t.raj03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM raj_file
               WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                 AND raj03 = g_raj_t.raj03 AND raj04 = g_raj_t.raj04 
                 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_raj[l_ac1].* = g_raj_t.*
              CLOSE t3041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raj[l_ac1].raj03,-263,1)
              LET g_raj[l_ac1].* = g_raj_t.*
           ELSE
              IF g_raj[l_ac1].raj03<>g_raj_t.raj03 OR
                 g_raj[l_ac1].raj04<>g_raj_t.raj04 THEN
                 SELECT COUNT(*) INTO l_n FROM raj_file
                  WHERE raj01 =g_rah.rah01 AND raj02 = g_rah.rah02
                    AND raj03 = g_raj[l_ac1].raj03
                    AND raj04 = g_raj[l_ac1].raj04
                    AND rajplant = g_rah.rahplant
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                   #LET g_raj[l_ac1].* = g_raj_t.*
                    NEXT FIELD raj03
                 END IF
              END IF
              UPDATE raj_file SET raj03=g_raj[l_ac1].raj03,
                                  raj04=g_raj[l_ac1].raj04,
                                  raj05=g_raj[l_ac1].raj05,
                                  raj06=g_raj[l_ac1].raj06,
                                  rajacti=g_raj[l_ac1].rajacti
               WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01
                 AND raj03=g_raj_t.raj03 AND raj04=g_raj_t.raj04 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1) 
                 LET g_raj[l_ac1].* = g_raj_t.*
                 ROLLBACK WORK
              ELSE
                 CALL s_showmsg_init() 
                 CALL t304_repeat(g_raj[l_ac1].raj03)  #check
                 CALL s_showmsg() 
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
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
                 LET g_raj[l_ac1].* = g_raj_t.*
              END IF
              CLOSE t3041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t3041_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(raj03) AND l_ac1 > 1 THEN
              LET g_raj[l_ac1].* = g_raj[l_ac1-1].*
              NEXT FIELD raj03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(raj05)
                 CALL cl_init_qry_var()
                 CASE g_raj[l_ac1].raj04
                    #WHEN '1'
                    WHEN '01'    #FUN-A80104
                     # IF cl_null(g_rtz05) THEN             #FUN-AB0101 mark
                          #LET g_qryparam.form="q_ima"
#                         LET g_qryparam.form="q_ima_1"     #TQC-AA0109           #FUN-AA0059 mark
                          CALL q_sel_ima(FALSE, "q_ima_1","",g_raj[l_ac1].raj05,"","","","","",'' )   #FUN-AA0059 add
                            RETURNING g_raj[l_ac1].raj05                                            #FUN-AA0059 
                     # ELSE                                    #FUN-AB0101 mark
                     #    LET g_qryparam.form = "q_rtg03_1"    #FUN-AB0101 mark
                     #    LET g_qryparam.arg1 = g_rtz05        #FUN-AB0101 mark
                     # END IF                                  #FUN-AB0101 mark
                    #WHEN '2'
                    WHEN '02'   #FUN-A80104
                       LET g_qryparam.form ="q_oba01"
                    #WHEN '3'
                    WHEN '03'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                    #WHEN '4'
                    WHEN '04'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                    #WHEN '5'
                    WHEN '05'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                    #WHEN '6'
                    WHEN '06'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                    #WHEN '7'
                    WHEN '07'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                    #WHEN '8'
                    WHEN '08'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                    #WHEN '9'
                    WHEN '09'   #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                 END CASE
               # IF g_raj[l_ac1].raj04 != '01' OR (g_raj[l_ac1].raj04 = '01' AND NOT cl_null(g_rtz05)) THEN #FUN-AA0059 ADD    #FUN-AB0101 mark
                 IF g_raj[l_ac1].raj04 != '01' THEN                            #FUN-AB0101 
                    LET g_qryparam.default1 = g_raj[l_ac1].raj05
                    CALL cl_create_qry() RETURNING g_raj[l_ac1].raj05
                 END IF                                  #FUN-AA0059 ADD 
                 CALL t304_raj05('d',l_ac1)
                 NEXT FIELD raj05
              WHEN INFIELD(raj06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe02"
                 LET g_qryparam.arg1 = g_raj[l_ac1].raj05
                 LET g_qryparam.default1 = g_raj[l_ac1].raj06
                 CALL cl_create_qry() RETURNING g_raj[l_ac1].raj06
                 CALL t304_raj06('d')
                 NEXT FIELD raj06
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
     
    CALL t304_upd_log() 
    
    CLOSE t3041_bcl
    COMMIT WORK
 
END FUNCTION
}

#No.TQC-A20011--begin
FUNCTION t304_check_rai04()
DEFINE l_n          LIKE type_file.num5
   
#   LET g_errno=''
#   SELECT COUNT(*) INTO l_n FROM rai_file 
#    WHERE rai01=g_rah.rah01 
#      AND raiplant=g_rah.rahplant
#      AND rai04=g_rai[l_ac].rai04
#   IF l_n>0 THEN 
#      LET g_errno='art-642'
#   END IF 
END FUNCTION 

FUNCTION t304_check_rai05()
DEFINE l_n          LIKE type_file.num5
   
#   LET g_errno=''
#   SELECT COUNT(*) INTO l_n FROM rai_file 
#    WHERE rai01=g_rah.rah01 
#      AND raiplant=g_rah.rahplant 
#      AND rai05=g_rai[l_ac].rai05
#   IF l_n>0 THEN 
#      LET g_errno='art-642'
#   END IF 
END FUNCTION  
#No.TQC-A20011--end

FUNCTION t304_rai04()
DEFINE l_oga51      LIKE oga_file.oga51
DEFINE l_oga02      LIKE oga_file.oga02

#   LET g_errno = ' '
#   SELECT oga16 INTO g_rai[l_ac].rai05 FROM oga_file
#      WHERE oga01 = g_rai[l_ac].rai04
#        AND ogaconf = 'Y'
#   CASE 
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'abx-002'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
#   END CASE
#   IF NOT cl_null(g_errno) THEN RETURN END IF
#   SELECT SUM(rxx04) INTO g_rai[l_ac].rai07 FROM rxx_file
#        WHERE rxx00 = '02' AND rxx01 = g_rai[l_ac].rai04
#   IF g_rai[l_ac].rai05 IS NOT NULL THEN
#      CALL cl_set_comp_entry("rai05",FALSE)
#   END IF
END FUNCTION

FUNCTION t304_rai04_3()
DEFINE l_oga02      LIKE oga_file.oga02

#   LET g_errno = ' '
#   IF  g_rai[l_ac].rai03 IS NULL OR  g_rai[l_ac].rai04 IS NULL THEN RETURN END IF
#   SELECT oga02 INTO l_oga02 FROM oga_file
#      WHERE oga01 = g_rai[l_ac].rai04
#        AND ogaconf = 'Y'
#   IF l_oga02 != g_rai[l_ac].rai03 THEN LET g_errno = 'art-914' END IF
END FUNCTION

FUNCTION t304_kehu(p_flag)
DEFINE p_flag        LIKE type_file.chr1
DEFINE l_rai04       LIKE rai_file.rai04
DEFINE l_rai05       LIKE rai_file.rai05
DEFINE l_oga87       LIKE oga_file.oga87
DEFINE l_old_oga87   LIKE oga_file.oga87

   LET g_errno = ' '

#   IF p_flag = '1' THEN
#      SELECT oga87 INTO l_oga87 FROM oga_file   
#         WHERE oga01 = g_rai[l_ac].rai04
#   END IF
#   IF p_flag = '2' THEN
#      SELECT oea87 INTO l_oga87 FROM oea_file   
#         WHERE oea01 = g_rai[l_ac].rai05
#   END IF
#
#   LET g_sql = "SELECT rai04,rai05 FROM rai_file ",
#               "  WHERE rai02 = '",g_rah.rah02,"' ",
#               "    AND rai01 = '",g_rah.rah01,"' ",
#               "    AND raiplant = '",g_rah.rahplant,"'"
#   PREPARE pre_sel_rai04 FROM g_sql
#   DECLARE cur_rai04 CURSOR FOR pre_sel_rai04
#   FOREACH cur_rai04 INTO l_rai04,l_rai05
#      IF l_rai04 IS NOT NULL THEN 
#         SELECT oga87 INTO l_old_oga87 FROM oga_file   
#            WHERE oga01 = l_rai04
#      ELSE
#         IF l_rai05 IS NOT NULL THEN 
#            SELECT oea87 INTO l_old_oga87 FROM oea_file   
#               WHERE oea01 = l_rai05
#         END IF
#      END IF
#      IF NOT cl_null(l_oga87) AND NOT cl_null(l_old_oga87) THEN
#         IF l_oga87 != l_old_oga87 THEN
#            LET g_errno = 'art-913'
#            EXIT FOREACH
#         END IF
#      END IF
#   END FOREACH
END FUNCTION

FUNCTION t304_check()
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_rwj05 LIKE rwj_file.rwj05
DEFINE l_rwj06 LIKE rwj_file.rwj06
 
    LET g_errno =''
  #FUN-BB0059 mark START
  #IF NOT cl_null(g_rah.rah04) AND NOT cl_null(g_rah.rah05) AND
  #   NOT cl_null(g_rah.rah06) AND NOT cl_null(g_rah.rah07) THEN
  #   SELECT COUNT(*) INTO l_n FROM raq_file
  #    WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
  #      AND raq03 = '3'
  #      AND raqplant = g_rah.rahplant AND raq04 = g_rah.rahplant
  #   IF l_n >0  THEN
  #    LET l_sql = "SELECT ima01 FROM rwj_file ",
  #                " WHERE rwj01 = ? AND rwj02 = ? ",
  #                "   AND rwjplant = ? "
  #    PREPARE rwj_chk_pre1 FROM l_sql
  #    DECLARE rwj_chk1 CURSOR FOR rwj_chk_pre1
  #    FOREACH rwj_chk1 USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
  #                     INTO l_rwj05,l_rwj06
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err('Foreach rwj_chk1:',SQLCA.sqlcode,0)    
  #         EXIT FOREACH                     
  #      END IF
  #      #CALL t304sub_chk('1',g_rah.rahplant,l_rwj05,l_rwj06,g_rah.rah04,
  #      #                  g_rah.rah05,g_rah.rah06,g_rah.rah07)
  #      IF NOT cl_null(g_errno) THEN
  #         #LET g_errno = 'art-218'  #TQC-AC0196 mark
  #         EXIT FOREACH
  #      END IF
  #     END FOREACH
  #   END IF
  #END IF    
  #FUN-BB0059 mark END 
END FUNCTION

FUNCTION t304_rai05()
DEFINE l_oea62      LIKE oea_file.oea62

#   LET g_errno = ' '
#   SELECT oea62 INTO l_oea62 FROM oea_file
#      WHERE oea01 = g_rai[l_ac].rai05
#        AND oeaconf = 'Y'
#   CASE 
#      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'asf-500'
#      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
#   END CASE
#   IF g_rai[l_ac].rai07 IS NULL THEN
#      SELECT SUM(rxx04) INTO g_rai[l_ac].rai07 FROM rxx_file
#          WHERE rxx00 = '01' AND rxx01 = g_rai[l_ac].rai05
#   END IF  
END FUNCTION

FUNCTION t304_raj04()
   LET g_errno = ''     #add TQC-AA0109
   #IF g_raj[l_ac1].raj04='1' THEN
   IF g_raj[l_ac1].raj04='01' THEN   #FUN-A80104
      CALL cl_set_comp_entry("raj06",TRUE)
      CALL cl_set_comp_required("raj06",TRUE)
   ELSE
      CALL cl_set_comp_entry("raj06",FALSE)
      CALL cl_set_comp_required("raj06",FALSE)
   END IF

END FUNCTION

FUNCTION t304_raj05(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 
DEFINE p_cnt       LIKE type_file.num5

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
   
   CASE g_raj[p_cnt].raj04
      #WHEN '1'
      WHEN '01'   #FUN-A80104
       # IF cl_null(g_rtz05) THEN            #FUN-AB0101
         IF cl_null(g_rtz04) THEN            #FUN-AB0101  
            SELECT DISTINCT ima02,ima25,imaacti
              INTO l_ima02,l_ima25,l_imaacti
              FROM ima_file
             WHERE ima01=g_raj[p_cnt].raj05  
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
             WHERE ima01 = rte03 AND ima01=g_raj[p_cnt].raj05  
               AND rte01 = g_rtz04              #FUN-AB0101
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                        LET l_ima02=NULL
               WHEN l_imaacti='N'       LET g_errno='9028'
               OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
            END CASE
         END IF
      #WHEN '2'
      WHEN '02'   #FUN-A80104
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_raj[p_cnt].raj05 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'   #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='1' AND tqaacti='Y' 
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
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'    #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '6'
      WHEN '06'     #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'   #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='5' AND tqaacti='Y'
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
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'   #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_raj[p_cnt].raj05 AND tqa03='27' AND tqaacti='Y'
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
      CASE g_raj[p_cnt].raj04
         #WHEN '1'
         WHEN '01'    #FUN-A80104
            LET g_raj[p_cnt].raj05_desc = l_ima02
            IF cl_null(g_raj[p_cnt].raj06) THEN
               LET g_raj[p_cnt].raj06   = l_ima25
            END IF
            SELECT gfe02 INTO g_raj[p_cnt].raj06_desc FROM gfe_file
             WHERE gfe01=g_raj[p_cnt].raj06 AND gfeacti='Y'
         #WHEN '2'
         WHEN '02'   #FUN-A80104
            LET g_raj[p_cnt].raj06 = ''
            LET g_raj[p_cnt].raj06_desc = ''
            LET g_raj[p_cnt].raj05_desc = l_oba02
         #WHEN '9'
         WHEN '09'   #FUN-A80104
            LET g_raj[p_cnt].raj06 = ''
            LET g_raj[p_cnt].raj06_desc = ''
            LET g_raj[p_cnt].raj05_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_raj[p_cnt].raj05_desc = g_raj[p_cnt].raj05_desc,"BETWEEN ",l_tqa02 CLIPPED," AND "
            LET l_tqa02 = l_tqa06                  
            LET g_raj[p_cnt].raj05_desc = g_raj[p_cnt].raj05_desc,l_tqa02 CLIPPED
         OTHERWISE
            LET g_raj[p_cnt].raj06 = ''
            LET g_raj[p_cnt].raj06_desc = ''
            LET g_raj[p_cnt].raj05_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_raj[p_cnt].raj05_desc,g_raj[p_cnt].raj06,g_raj[p_cnt].raj06_desc
   END IF

END FUNCTION

FUNCTION t304_raj06(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   #IF g_raj[l_ac1].raj04<>'1' THEN
   IF g_raj[l_ac1].raj04<>'01' THEN    #FUN-A80104
      RETURN
   END IF
   IF NOT cl_null(g_raj[l_ac1].raj05) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_raj[l_ac1].raj05

      CALL s_umfchk(g_raj[l_ac1].raj05,l_ima25,g_raj[l_ac1].raj06)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_raj[l_ac1].raj06 AND gfeacti = 'Y'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_raj[l_ac1].raj06_desc=l_gfe02
      DISPLAY BY NAME g_raj[l_ac1].raj06_desc
   END IF

END FUNCTION 
 

#FUNCTION t304_copy()
#   DEFINE l_newno     LIKE rah_file.rah01,
#          l_oldno     LIKE rah_file.rah01,
#          li_result   LIKE type_file.num5,
#          l_n         LIKE type_file.num5
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   IF g_rah.rah02 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   LET g_before_input_done = FALSE
#   CALL t304_set_entry('a')
# 
#   CALL cl_set_head_visible("","YES")
#   INPUT l_newno FROM rah01
#       BEFORE INPUT
#         CALL cl_set_docno_format("rah01")
#         
#       AFTER FIELD rah01
#          IF l_newno IS NULL THEN
#             NEXT FIELD rah01
#          ELSE 
#      	     CALL s_check_no("art",l_newno,"","9","rah_file","rah01","")                                                           
#                RETURNING li_result,l_newno                                                                                        
#             IF (NOT li_result) THEN                                                                                               
#                NEXT FIELD rah01                                                                                                   
#             END IF                                                                                                                
#             BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("axm",l_newno,g_today,"","rah_file","rah01",g_plant,"","")                                           
#                RETURNING li_result,l_newno  
#             IF (NOT li_result) THEN                                                                                               
#                ROLLBACK WORK                                                                                                      
#                NEXT FIELD rah01                                                                                                   
#             ELSE                                                                                                                  
#                COMMIT WORK                                                                                                        
#             END IF
#          END IF
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(rah01)                                                                                                      
#              LET g_t1=s_get_doc_no(g_rah.rah01)                                                                                    
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1                                                                 
#              LET l_newno = g_t1                                                                                                
#              DISPLAY l_newno TO rah01                                                                                           
#              NEXT FIELD rah01
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
#      DISPLAY BY NAME g_rah.rah01
#      ROLLBACK WORK
#      RETURN
#   END IF
#   BEGIN WORK
# 
#   DROP TABLE y
# 
#   SELECT * FROM rah_file
#       WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
#         AND rahplant = g_rah.rahplant
#       INTO TEMP y
# 
#   UPDATE y
#       SET rah01=l_newno,
#           rahplant=g_plant, 
#           rahlegal=g_legal,
#           rahconf = 'N',
#           rahcond = NULL,
#           rahconu = NULL,
#           rahuser=g_user,
#           rahgrup=g_grup,
#           rahmodu=NULL,
#           rahdate=g_today,
#           rahacti='Y',
#           rahcrat=g_today ,
#           rahoriu = g_user,
#           rahorig = g_grup
#           
#   INSERT INTO rah_file SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rah_file","","",SQLCA.sqlcode,"","",1)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   DROP TABLE x
# 
#   SELECT * FROM rai_file
#       WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01 
#         AND raiplant = g_rah.rahplant
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE x SET rai01=l_newno,
#                raiplant = g_plant,
#                railegal = g_legal 
# 
#   INSERT INTO rai_file
#       SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","rai_file","","",SQLCA.sqlcode,"","",1) 
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF 
#    
#   DROP TABLE z
# 
#   SELECT * FROM raj_file
#       WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01 
#         AND rajplant = g_rah.rahplant
#       INTO TEMP z
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
# 
#   UPDATE z SET raj01=l_newno,
#                rajplant = g_plant,
#                rajlegal = g_legal 
# 
#   INSERT INTO raj_file
#       SELECT * FROM z   
#   IF SQLCA.sqlcode THEN
#      ROLLBACK WORK 
#      CALL cl_err3("ins","raj_file","","",SQLCA.sqlcode,"","",1)  
#      RETURN
#   ELSE
#      COMMIT WORK
#   END IF    
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#   LET l_oldno = g_rah.rah01
#   SELECT rah_file.* INTO g_rah.* FROM rah_file 
#      WHERE rah02=g_rah.rah02 AND rah01 = l_newno
#        AND rahplant = g_rah.rahplant
#   CALL t304_u()
#   CALL t304_b()
#   SELECT rah_file.* INTO g_rah.* FROM rah_file 
#       WHERE rah02=g_rah.rah02 AND rah01 = l_oldno 
#         AND rahplant = g_rah.rahplant
#
#   CALL t304_show()
# 
#END FUNCTION
 
FUNCTION t304_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
#    IF g_wc IS NULL AND g_rah.rah01 IS NOT NULL THEN
#       LET g_wc = "rah01='",g_rah.rah01,"'"
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
#    LET l_cmd='p_query "artt304" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t304_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rah02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t304_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rah02",FALSE)
   END IF
 
END FUNCTION

FUNCTION t304_iss() 
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_dbs   LIKE azp_file.azp03   
DEFINE l_sql   STRING
DEFINE l_raq04 LIKE raq_file.raq04
DEFINE l_rtz11 LIKE rtz_file.rtz11
DEFINE l_rahlegal LIKE rah_file.rahlegal
DEFINE l_raq05    LIKE raq_file.raq05
DEFINE l_today  LIKE type_file.dat         #FUN-AB0093 
DEFINE l_time   LIKE type_file.chr8        #FUN-AB0093

  
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rah.* FROM rah_file 
      WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
        AND rahplant = g_rah.rahplant
   IF g_rah.rahacti ='N' THEN
      CALL cl_err(g_rah.rah01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rah.rahconf = 'N' THEN
      CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
      RETURN
   END IF

   IF g_rah.rahconf = 'X' THEN
      CALL cl_err('','art-661',0)
      RETURN
   END IF

   IF g_rah.rah01 <> g_plant THEN
      CALL cl_err('','art-663',1)
      RETURN
   END IF

   SELECT DISTINCT raq05 INTO l_raq05 FROM raq_file
    WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02 
      AND raq03 = '3' AND raqplant = g_rah.rahplant
   IF l_raq05 = 'Y' THEN
      CALL cl_err('','art-662',1)
      RETURN
   END IF
  
  DROP TABLE rah_temp
  DROP TABLE raq_temp
  DROP TABLE rai_temp
  DROP TABLE raj_temp
  DROP TABLE rap_temp
  DROP TABLE rar_temp
  DROP TABLE ras_temp
  DROP TABLE rak_temp  #FUN-BB0059 add

  SELECT * FROM rah_file WHERE 1 = 0 INTO TEMP rah_temp
  SELECT * FROM raj_file WHERE 1 = 0 INTO TEMP raj_temp
  SELECT * FROM rai_file WHERE 1 = 0 INTO TEMP rai_temp
  SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp  
  SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp  
  SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp  
  SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp  
  SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp   #FUN-BB0059 add
 
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
   IF STATUS THEN
      CALL cl_err("OPEN t304_cl:", STATUS, 1)
      CLOSE t304_cl
      ROLLBACK WORK
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM raq_file
    WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
      AND raq03 = '3' AND raqplant = g_rah.rahplant
   IF l_cnt = 0 THEN
      CALL cl_err('','art-545',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM rai_file
    WHERE rai01 = g_rah.rah01 AND rai02 = g_rah.rah02
      AND raiplant = g_rah.rahplant 
   IF l_cnt = 0 THEN
      CALL cl_err('','art-548',0)
      RETURN
   END IF
   IF NOT cl_confirm('art-660') THEN 
       RETURN
   END IF     
   
   CALL s_showmsg_init()
 

   
  #LET l_sql="SELECT raq04 FROM raq_file ",  #FUN-BB0059 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",  #FUN-BB0059 add
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='3' AND raqacti='Y' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
                  INTO l_raq04  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach raq_cs:',SQLCA.sqlcode,1)                         
      END IF   
      IF g_rah.rahplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rah.rahplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
      LET g_plant_new = l_raq04
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04
      
      DELETE FROM rah_temp
      DELETE FROM rai_temp
      DELETE FROM raj_temp  
      DELETE FROM raq_temp
      DELETE FROM rap_temp
      DELETE FROM rar_temp
      DELETE FROM ras_temp
      DELETE FROM rak_temp   #FUN-BB0059 add
      LET l_today =  g_today         #FUN-AB0093
     #LET l_time  =  g_time          #FUN-AB0093 #TQC-BA0173
      LET l_time  =  TIME            #TQC-BA0173
#TQC-AC0326 mark -----------------begin-------------------
##FUN-AB0093 ------------------STA
#     UPDATE rah_file SET rah901 = l_today,
#                         rah902 = l_time
#     WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
#       AND rahplant = g_rah.rahplant
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("upd","rah_file",g_rah.rah02,"",STATUS,"","",1)
#        LET g_success = 'N'
#     ELSE
#       SELECT rah901,rah902 INTO g_rah.rah901,g_rah.rah902
#         FROM rah_file 
#        WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
#          AND rahplant = g_rah.rahplant
#     END IF
##FUN-AB0093 ------------------END
#TQC-AC0326 mark ------------------end--------------------
      UPDATE raq_file SET raq05='Y',raq06=l_today,raq07 = l_time   #TQC-AC0326 add raq06,raq07  
       WHERE raq01=g_rah.rah01 AND raq02=g_rah.rah02
         AND raq03='3' AND raq04=l_raq04 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","raq_file",g_rah.rah01,"",STATUS,"","",1) 
         LET g_success = 'N'
      END IF
      #DISPLAY BY NAME g_rah.rah901               #FUN-AB0093  #TQC-AC0326 mark 
      #DISPLAY BY NAME g_rah.rah902               #FUN-AB0093  #TQC-AC0326 mark
      IF g_rah.rahplant = l_raq04 THEN #與當前機構相同則不拋
         CONTINUE FOREACH
      ELSE
      #將數據放入臨時表中處理
         SELECT azw02 INTO l_rahlegal FROM azw_file
          WHERE azw01 = l_raq04 AND azwacti='Y'

         INSERT INTO rai_temp SELECT rai_file.* FROM rai_file
                               WHERE rai01 = g_rah.rah01 AND rai02 = g_rah.rah02
                                 AND raiplant = g_rah.rahplant
         UPDATE rai_temp SET raiplant=l_raq04,
                             railegal = l_rahlegal

         INSERT INTO raj_temp SELECT raj_file.* FROM raj_file
                               WHERE raj01 = g_rah.rah01 AND raj02 = g_rah.rah02
                                 AND rajplant = g_rah.rahplant
         UPDATE raj_temp SET rajplant=l_raq04,
                             rajlegal = l_rahlegal

         INSERT INTO rap_temp SELECT rap_file.* FROM rap_file
                               WHERE rap01 = g_rah.rah01 AND rap02 = g_rah.rah02
                                 AND rapplant = g_rah.rahplant
         UPDATE rap_temp SET rapplant=l_raq04,
                             raplegal = l_rahlegal

         INSERT INTO rar_temp SELECT rar_file.* FROM rar_file
                               WHERE rar01 = g_rah.rah01 AND rar02 = g_rah.rah02
                                 AND rarplant = g_rah.rahplant AND rar03 = '3'
         UPDATE rar_temp SET rarplant=l_raq04,
                             rarlegal = l_rahlegal

         INSERT INTO ras_temp SELECT ras_file.* FROM ras_file
                               WHERE ras01 = g_rah.rah01 AND ras02 = g_rah.rah02
                                 AND rasplant = g_rah.rahplant AND ras03 = '3'
         UPDATE ras_temp SET rasplant=l_raq04,
                             raslegal = l_rahlegal

         INSERT INTO rah_temp SELECT * FROM rah_file
          WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
            AND rahplant = g_rah.rahplant
         IF l_rtz11='Y' THEN
            UPDATE rah_temp SET rahplant = l_raq04,
                                rahlegal = l_rahlegal,
                                rahconf = 'N',
                                rahcond = NULL,
                                rahcont = NULL,
                                rahconu = NULL
                                #rah901  = NULL,                        #FUN-AB0093    #TQC-AC0326 mark 
                                #rah902  = NULL                         #FUN-AB0093    #TQC-AC0326 mark
         ELSE
            UPDATE rah_temp SET rahplant = l_raq04,
                                rahlegal = l_rahlegal,
                                rahconf = 'Y',
                                rahcond = g_today,
                                rahcont = g_time,
                                rahconu = g_user
                                #rah901  = l_today,                     #FUN-AB0093    #TQC-AC0326 mark
                                #rah902  = l_time                       #FUN-AB0093    #TQC-AC0326 mark
         END IF

         INSERT INTO raq_temp SELECT * FROM raq_file
          WHERE raq01=g_rah.rah01 AND raq02 = g_rah.rah02
            AND raq03 ='3' AND raqplant = g_rah.rahplant
          UPDATE raq_temp SET raqplant = l_raq04,
                              raq05    = 'Y', #FUN-BB0059 add 
                              raq06=l_today,  #FUN-BB0059 add
                              raq07 = l_time,  #FUN-BB0059 add
                                raqlegal = l_rahlegal

    #FUN-BB0059 add START
         INSERT INTO rak_temp SELECT rak_file.* FROM rak_file
                               WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02
                                 AND rakplant = g_rah.rahplant AND rak03 = '3'
         UPDATE rak_temp SET rakplant=l_raq04,
                             raklegal = l_rahlegal
    #FUN-BB0059 add END

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rah_file'),
                     " SELECT * FROM rah_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rah FROM l_sql
         EXECUTE trans_ins_rah
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rah_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rai_file'), 
                     " SELECT * FROM rai_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rai FROM l_sql
         EXECUTE trans_ins_rai
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rai_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raj_file'), 
                     " SELECT * FROM raj_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_raj FROM l_sql
         EXECUTE trans_ins_raj
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO raj_file:',SQLCA.sqlcode,1)
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
   #FUN-BB0059 add START
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
   #FUN-BB0059 add END
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
  #add by TQC-AA0109--str--
  DROP TABLE rah_temp
  DROP TABLE raq_temp
  DROP TABLE rai_temp
  DROP TABLE raj_temp
  DROP TABLE rap_temp
  DROP TABLE rar_temp
  DROP TABLE ras_temp
  DROP TABLE rak_temp  #FUN-BB0059 add
  #add by TQC-AA0109--end--
#FUN-BB0059 add START
   SELECT DISTINCT raq05, raq06, raq07
      INTO g_raq.*
      FROM raq_file
      WHERE raq01 = g_rah.rah01 AND raq02 = g_rah.rah02
        AND raq03 = '3' AND raqplant = g_rah.rahplant
   DISPLAY BY NAME g_raq.raq05, g_raq.raq06, g_raq.raq07
   CALL t304_rah10()
#FUN-BB0059 add END

END FUNCTION

#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
FUNCTION t304_repeat(p_group)     
DEFINE p_group    LIKE rai_file.rai03
DEFINE l_n        LIKE type_file.num5
DEFINE l_raj05    LIKE raj_file.raj05
DEFINE l_raj06    LIKE raj_file.raj06
DEFINE l_rah04    LIKE rah_file.rah04
DEFINE l_rah05    LIKE rah_file.rah05
DEFINE l_rah06    LIKE rah_file.rah06
DEFINE l_rah07    LIKE rah_file.rah07

   LET l_n=0
   LET g_errno =' '

   SELECT COUNT(raj04) INTO l_n FROM raj_file
    WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
      AND rajplant=g_rah.rahplant AND raj03=p_group
      AND rajacti='Y'

   IF l_n<1 THEN RETURN END IF
  #CALL s_showmsg_init() 
  #CALL t304sub_chk('3',g_rah.rahplant,g_rah.rah01,g_rah.rah02,p_group,g_rah.rah04,g_rah.rah05,g_rah.rah06,g_rah.rah07)  #FUN-BB0059 mark

  #CALL s_showmsg()
END FUNCTION

FUNCTION t304_total_check()
DEFINE l_sql  STRING
DEFINE l_n        LIKE type_file.num5
DEFINE p_bdate    LIKE rah_file.rah04
DEFINE p_edate    LIKE rah_file.rah05
DEFINE p_btime    LIKE rah_file.rah06
DEFINE p_etime    LIKE rah_file.rah07
DEFINE p_snum     LIKE type_file.num5
DEFINE p_enum     LIKE type_file.num5

DEFINE l_rah01     LIKE rah_file.rah01
DEFINE l_rah02     LIKE rah_file.rah02
DEFINE l_rah04     LIKE rah_file.rah04
DEFINE l_rah05     LIKE rah_file.rah05
DEFINE l_rah06     LIKE rah_file.rah06
DEFINE l_rah07     LIKE rah_file.rah07
DEFINE l_rah11     LIKE rah_file.rah11
DEFINE l_rahplant  LIKE rah_file.rahplant
DEFINE l_rai03     LIKE rai_file.rai03

   LET g_errno= '  '
   LET p_bdate = g_rah.rah04 
   LET p_edate = g_rah.rah05
   LET p_btime = g_rah.rah06
   LET p_etime = g_rah.rah07
   LET p_snum = p_btime[1,2]*60 + p_btime[4,5]
   LET p_enum = p_etime[1,2]*60 + p_etime[4,5]

   CALL s_showmsg_init()
   SELECT rah01,rah02,rah04,rah05,rah06,rah07,rah11,rahplant FROM rah_file where 1=0 INTO TEMP rah_temp

  #IF g_rah.rah11='1' THEN
      DELETE FROM rah_temp 
      LET l_sql ="INSERT INTO rah_temp ",
                 "SELECT rah01,rah02,rah04,rah05,rah06,rah07,rah11,rahplant FROM ",cl_get_target_table(g_plant,"rah_file"),
                 " WHERE  rahacti='Y' ",    # AND rah11='1' ",
                 "   AND (rah04 BETWEEN '",g_rah.rah04,"' AND '",g_rah.rah05,"' ",
                 "    OR rah05 BETWEEN '",g_rah.rah04,"' AND '",g_rah.rah05,"' ",
                 "    OR '",g_rah.rah04,"' BETWEEN rah04 AND rah05 ",
                 "    OR '",g_rah.rah05,"' BETWEEN rah04 AND rah05 )"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
     PREPARE rah_temp_cs FROM l_sql
     EXECUTE rah_temp_cs 
     IF SQLCA.sqlcode THEN
       #LET g_success='N'
        CALL s_errmsg('ins','','rah_temp',SQLCA.sqlcode,1)
        RETURN
     END IF
     SELECT COUNT(*) INTO l_n FROM rah_temp
     IF l_n > 0 THEN
        UPDATE rah_temp SET rah06=rah06[1,2]*60+rah06[4,5],
                            rah07=rah07[1,2]*60+rah07[4,5]
        DELETE FROM rah_temp
          WHERE (rah05 = p_bdate AND rah07 < p_snum) OR (rah04 = p_edate AND rah06 > p_enum)
     END IF
     SELECT COUNT(*) INTO l_n FROM rah_temp 
     IF l_n = 0 THEN
       #LET g_success = 'Y'
        RETURN
     END IF
     
     IF l_n > 0 THEN
        IF g_rah.rah11='1' THEN
           LET l_sql="SELECT DISTINCT rah01,rah02,rah04,rah05,rah06,rah07,rah11,rahplant FROM rah_temp ",
                     " WHERE 1=1 "  #rah11='1' "
        ELSE
          LET l_sql="SELECT DISTINCT rah01,rah02,rah04,rah05,rah06,rah07,rah11,rahplant FROM rah_temp ",
                    " WHERE rah11='1' "
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
        DECLARE rah_temp_cs1 CURSOR FROM l_sql
        FOREACH rah_temp_cs1 INTO l_rah01,l_rah02,l_rah04,l_rah05,l_rah06,l_rah07,l_rah11,l_rahplant
          IF SQLCA.sqlcode THEN
            #LET g_success='N'
             CALL s_errmsg('sel','','rah_temp',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #TQC-AC0196 add --------------begin-----------------
          LET l_n = 0 
          SELECT COUNT(*) INTO l_n FROM rah_file WHERE (l_rah04<rah04 AND l_rah05<rah05) OR (l_rah04<rah04 AND l_rah05>rah05)
          IF l_n > 0 THEN   
          #TQC-AC0196 add ---------------end------------------
             #LET g_showmsg = l_rah01,"/",l_rah02,"/",l_rah04,"/",l_rah05,"/",l_rah11,"/",l_rahplant  #TQC-AC0196 mark 
             LET g_showmsg = l_rah01,"/",l_rah02,"/",l_rah04,"/",l_rah05  #TQC-AC0196 add
             LET g_errno='art-798'
             CALL s_errmsg('rah01,rah02,rah04,rah05',g_showmsg,'',g_errno,2)
             #LET g_success = 'N'
             EXIT FOREACH   #TQC-AC0196 add
          END IF            #TQC-AC0196 add
          END FOREACH  
     END IF
     
     IF g_rah.rah11='2' THEN
        SELECT COUNT(*) INTO l_n FROM rah_temp WHERE rah11='2'
        IF l_n > 0 THEN
           LET l_sql="SELECT DISTINCT rai03 FROM ",cl_get_target_table(g_rah.rahplant,'rai_file')," ",
                     " WHERE raiacti='Y'",
                     "   AND rai01='",g_rah.rah01,"' AND rai02='",g_rah.rah02,"' AND raiplant='",g_rah.rahplant,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql, g_rah.rahplant) RETURNING l_sql
           DECLARE rai_temp_cs CURSOR FROM l_sql
           FOREACH rai_temp_cs INTO l_rai03
             IF SQLCA.sqlcode=100 THEN 
                EXIT FOREACH 
             END IF
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('sel','','rai_file',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
            #CALL t304sub_chk('3',g_rah.rahplant,g_rah.rah01,g_rah.rah02,l_rai03,g_rah.rah04,g_rah.rah05,g_rah.rah06,g_rah.rah07)
             CALL t304_repeat(l_rai03)
           END FOREACH
        END IF
     END IF

   CALL s_showmsg()
   DROP TABLE rah_temp
END FUNCTION

#No.FUN-A60044
#FUN-A80104  add by lixia ----start----
#控管第二單身的組別須在第一單身中存在
FUNCTION t303_raj03() 
DEFINE l_n           LIKE type_file.num5

   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM rai_file
    WHERE rai03 = g_raj[l_ac1].raj03 AND rai01=g_rah.rah01
      AND rai02 = g_rah.rah02  AND raiplant=g_rah.rahplant
      AND raiacti='Y'

   IF l_n<1 THEN  
      LET g_errno = 'art-654'     #當前組別不在第一單身中
   END IF
END FUNCTION
#FUN-A80104  add by lixia ----end----

#TQC-AB0205 add by suncx -----begin------
#第一單身滿量/滿額的動態顯示
FUNCTION t304_rah25()
DEFINE l_rai04   LIKE gae_file.gae04
DEFINE l_index   LIKE type_file.num5
DEFINE l_str     STRING

   SELECT gae04 INTO l_rai04 FROM gae_file
    WHERE gae01 = 'artt304'
      AND gae12 = 'std'
      AND gae02 = 'rai04'
      AND gae03 = g_lang 
   
   LET l_str = l_rai04
   LET l_index = l_str.getIndexOf("/",1)
   CASE g_rah.rah25
      WHEN '1'
         CALL cl_set_comp_att_text("rai04",l_str.subString(1,l_index-1))
      WHEN '2'
         CALL cl_set_comp_att_text("rai04",l_str.subString(l_index+1,l_str.getLength()))   
      OTHERWISE
         CALL cl_set_comp_att_text("rai04",l_str)
   END CASE
END FUNCTION
 
#TQC-AC0326 add --------------------begin----------------------
FUNCTION t304_w() 			# when g_rah.rahconf='Y' (Turn to 'N')
DEFINE l_cnt       LIKE type_file.num10
DEFINE l_rahcont   LIKE rah_file.rahcont   #CHI-D20015 Add
DEFINE l_gen02     LIKE gen_file.gen02     #CHI-D20015 Add
 
   SELECT COUNT(*) INTO l_cnt FROM raq_file 
    WHERE raq01=g_rah.rah01 AND raq02=g_rah.rah02 AND raqplant=g_rah.rahplant 
      AND raq03='3' AND raqacti='Y' AND raq05='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','art-888',0)
      RETURN
   END IF     

   LET g_success = 'Y'
   BEGIN WORK
 
   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF 
  #CHI-D20015 Mark&Add Str
   LET l_rahcont = TIME
  #UPDATE rah_file SET rahconf = 'N',rahconu='',rahcond='',
  #                    rahcont =''   #Add No:TQC-B10132
   UPDATE rah_file SET rahconf='N',rahconu=g_user,
                       rahcond=g_today,rahcont=l_rahcont
  #CHI-D20015 Mark&Add End
    WHERE rah01 = g_rah.rah01 
      AND rah02 = g_rah.rah02         #Add No:TQC-B10133
      AND rahplant = g_rah.rahplant   #Add No:TQC-B10133

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rah_file",g_rah.rah01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rah_file OK'
   END IF
  
   IF g_success = 'Y' THEN
      LET g_rah.rahconf='N' 
      COMMIT WORK
     #CHI-D20015 Mark&Add Str
     #LET g_rah.rahconu=NULL
     #LET g_rah.rahcond=NULL
     #DISPLAY BY NAME g_rah.rahconf
     ##Add No:TQC-B10132
     #LET g_rah.rahcont=NULL
      LET g_rah.rahconu=g_user
      LET g_rah.rahcond=g_today
      DISPLAY BY NAME g_rah.rahconf
      LET g_rah.rahcont=l_rahcont
     #CHI-D20015 Mark&Add End
      DISPLAY BY NAME g_rah.rahcond
      DISPLAY BY NAME g_rah.rahcont
      DISPLAY BY NAME g_rah.rahconu
     #DISPLAY '' TO FORMONLY.rahconu_desc                                #CHI-D20015 Mark
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rah.rahconu  #CHI-D20015 Add
      DISPLAY l_gen02 TO FORMONLY.rahconu_desc                           #CHI-D20015 Add
      IF g_rah.rahconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      CALL cl_set_field_pic(g_rah.rahconf,"","","",g_chr,"")
      #End Add No:TQC-B10132
   ELSE
      LET g_rah.rahconu=g_user                                                                                           
      LET g_rah.rahcond=g_today  
      LET g_rah.rahconf='Y' 
      LET g_rah.rahcont=l_rahcont   #CHI-D20015 Add
      ROLLBACK WORK
   END IF
END FUNCTION
#TQC-AC0326 add --------------------end-----------------------
#TQC-AB0205 add by suncx ------end-------
#FUN-BB0059 add START
FUNCTION t304_b3_fill(p_wc3)  
DEFINE p_wc3          STRING
   
   LET g_sql = "SELECT rak05, rak06, rak07, rak08, rak09, rak10, rak11, rakacti ",
               "  FROM rak_file",
               " WHERE rak02 = '",g_rah.rah02,"' AND rak01 ='",g_rah.rah01,"' ",
               "   AND rakplant = '",g_rah.rahplant,"'",
               "   AND rak03 = '3'"

   IF NOT cl_null(p_wc3) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rak05 "

   DISPLAY g_sql

   PREPARE t304_pb2 FROM g_sql
   DECLARE rak_cs CURSOR FOR t304_pb2

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
   DISPLAY g_rec_b2 TO FORMONLY.cn1
   LET g_cnt = 0
END FUNCTION

FUNCTION t304_all_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_ac_o          LIKE type_file.num5, #FUN-AB0033 add
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
DEFINE l_s        LIKE type_file.chr1000 
DEFINE l_m        LIKE type_file.chr1000 
DEFINE i          LIKE type_file.num5
DEFINE l_s1       LIKE type_file.chr1000 
DEFINE l_m1       LIKE type_file.chr1000 
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_azp03    LIKE azp_file.azp03
DEFINE l_line     LIKE type_file.num5
DEFINE l_sql1     STRING
DEFINE l_bamt     LIKE type_file.num5
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_price    LIKE type_file.num20  
DEFINE l_discount LIKE rai_file.rai06
DEFINE l_success  LIKE type_file.chr1   
DEFINE l_ac2     LIKE type_file.num5
DEFINE l_time1    LIKE type_file.num5
DEFINE l_time2    LIKE type_file.num5
DEFINE l_rahpos  LIKE rah_file.rahpos
DEFINE l_ac1_t   LIKE type_file.num5
DEFINE l_rak05   LIKE rak_file.rak05
DEFINE l_ac2_t   LIKE type_file.num5
DEFINE l_flag           LIKE type_file.chr1    #FUN-D30033

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF

    CALL t304_rai10_text()   #FUN-C30151 add
 
    IF g_rah.rah02 IS NULL THEN
       RETURN
    END IF

   #IF g_rah.rah10 = 2 THEN  #FUN-C30151 mark
    IF g_rah.rah10 = 2 AND g_rah.rah25 = '1' THEN  #FUN-C30151 add
       CALL cl_set_comp_visible('rai10',FALSE) 
    ELSE 
       CALL cl_set_comp_visible('rai10',TRUE)
    END IF
 
    SELECT * INTO g_rah.* FROM rah_file
     WHERE rah02 = g_rah.rah02 AND rah01=g_rah.rah01
       AND rahplant = g_rah.rahplant
 
    IF g_rah.rahacti ='N' THEN
       CALL cl_err(g_rah.rah01||g_rah.rah02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rah.rahconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rah.rahconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF

    IF g_rah.rah01 <> g_rah.rahplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rai03,rai04,rai10,rai05,rai06,rai07,rai08,",  #FUN-C30151 將rai10搬移至rai05前 
                       "       rai09,raiacti",  
                       "  FROM rai_file ",
                       " WHERE rai01 = ? AND rai02=? AND rai03=? AND raiplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t304_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR 

    LET g_forupd_sql = "SELECT raj03,raj04,raj05,'',raj06,'',rajacti", 
                       "  FROM raj_file ",
                       " WHERE raj01=? AND raj02=? AND raj03=? AND raj04=? AND rajplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t3041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_forupd_sql = "SELECT rak05,rak06,rak07,rak08,rak09, ",
                       " rak10,rak11,rakacti ",
                       "  FROM rak_file ",
                       " WHERE rak01=? AND rak02=? AND rak03='3' AND rakplant = ? AND rak05 = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t3042_bcl CURSOR FROM g_forupd_sql

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
              LET l_flag = '2'               #FUN-D30033
              CALL t304_set_entry_rak(l_ac2)

              BEGIN WORK

              OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t304_cl:", STATUS, 1)
                 CLOSE t304_cl
                 ROLLBACK WORK
                 RETURN
              END IF
             #TQC-C20106 add START
              FETCH t304_cl INTO g_rah.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
                 CLOSE t304_cl
                 ROLLBACK WORK
                 RETURN
              END IF
             #TQC-C20106 add END
              IF g_rec_b2 >= l_ac2 THEN
                 LET p_cmd='u'
                 LET g_rak_t.* = g_rak[l_ac2].*  #BACKUP
                 LET g_rak_o.* = g_rak[l_ac2].*  #BACKUP
                 OPEN t3042_bcl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant,g_rak[l_ac2].rak05
                 IF STATUS THEN
                    CALL cl_err("OPEN t3042_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t3042_bcl INTO g_rak[l_ac2].*
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
              IF NOT cl_null(g_rah.rah03) THEN
                 SELECT raa05,raa06 INTO g_rak[l_ac2].rak06,g_rak[l_ac2].rak07
                   FROM raa_file
                 WHERE raa01=g_rah.rah01 AND raa02=g_rah.rah03
              END IF
              IF cl_null(g_rak[l_ac2].rak06) THEN
                 LET g_rak[l_ac2].rak06 = g_today        #促銷開始日期
              END IF
              IF cl_null(g_rak[l_ac2].rak07) THEN
                 LET g_rak[l_ac2].rak07 = g_today        #促銷結束日期
              END IF
              SELECT MAX(rak05) INTO g_rak[l_ac2].rak05 FROM rak_file
                   WHERE rak01 = g_rah.rah01
                     AND rak02 = g_rah.rah02
                     AND rak03 = '3'
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
                   WHERE rak01 = g_rah.rah01
                     AND rak02 = g_rah.rah02
                     AND rak03 = '3'
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
              VALUES(g_rah.rah01,g_rah.rah02,
                     '3',0,
                     g_rak[l_ac2].rak05,g_rak[l_ac2].rak06,
                     g_rak[l_ac2].rak07,g_rak[l_ac2].rak08,
                     g_rak[l_ac2].rak09,g_rak[l_ac2].rak10,
                     g_rak[l_ac2].rak11,g_rak[l_ac2].rakacti,
                     g_today,g_rah.rahlegal,g_rah.rahplant,'1')

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rak_file",g_rah.rah01,g_rak[l_ac2].rak05,SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 CALL r304_update_pos()
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
                       WHERE rak01 = g_rah.rah01 AND rak02 = g_rah.rah02
                         AND rak03 = '3' AND rak05 = g_rak[l_ac2].rak05
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
                  CALL t304_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rak08
                  ELSE
                    IF NOT cl_null(g_rak[l_ac2].rak09) THEN
                       CALL t304_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
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
                   CALL t304_chktime(g_rak[l_ac2].rak09) RETURNING l_time2
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                      NEXT FIELD rac15
                   ELSE
                     IF NOT cl_null(g_rak[l_ac2].rak08) THEN
                         CALL t304_chktime(g_rak[l_ac2].rak08) RETURNING l_time1
                        IF l_time1>=l_time2 THEN
                            CALL cl_err('','art-207',0)
                            NEXT FIELD rak08
                         END IF
                      END IF
                   END IF
               END IF
            END IF

           ON CHANGE rak10
              CALL t304_set_entry_rak(l_ac2)

           ON CHANGE rak11
              CALL t304_set_entry_rak(l_ac2)

           AFTER ROW
              LET l_ac2 = ARR_CURR()
              LET l_ac2_t = l_ac2
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_rak[l_ac2].* = g_rak_t.*
                 END IF
                 CLOSE t3042_bcl
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF

              IF NOT cl_null(g_rak[l_ac2].rak06) AND NOT cl_null(g_rak[l_ac2].rak07) THEN
                 IF g_rak[l_ac2].rak07<g_rak[l_ac2].rak06 THEN
                    CALL cl_err('','art-201',0)
                    NEXT FIELD rak07
                 END IF
              END IF
              CLOSE t3042_bcl
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
                 WHERE rak02 = g_rah.rah02 AND rak01 = g_rah.rah01
                   AND rak03 = '3'
                   AND rak05 = g_rak[l_ac2].rak05
                   AND rakplant = g_rah.rahplant
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rak_file",g_rah.rah01,g_rak_t.rak05,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF p_cmd = 'u' THEN  #TQC-C20336 add
                   LET g_rec_b2 = g_rec_b2 - 1
                END IF  #TQC-C20336  add
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
                CLOSE t3042_bcl
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
                 WHERE rak02 = g_rah.rah02 AND rak01 = g_rah.rah01
                   AND rak03 = '3'
                   AND rak05 = g_rak_t.rak05  AND rakplant = g_rah.rahplant
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","rak_file",g_rah.rah01,g_rak_t.rak05,SQLCA.sqlcode,"","",1)
                   LET g_rak[l_ac2].* = g_rak_t.*
                ELSE
                   CALL r304_update_pos()
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
       
       END INPUT

    INPUT ARRAY g_rai  FROM s_rai.*
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
 
           OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t304_cl:", STATUS, 1)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t304_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rai_t.* = g_rai[l_ac].*  #BACKUP
              LET g_rai_o.* = g_rai[l_ac].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("rai03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rai03",TRUE)
              END IF   
              OPEN t304_bcl USING g_rah.rah01,g_rah.rah02,g_rai_t.rai03,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t304_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t304_bcl INTO g_rai[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rai_t.rai03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
          END IF 
          CALL t304_rai_entry()

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rai[l_ac].* TO NULL
           LET g_rai[l_ac].raiacti = 'Y'    
           LET g_rai[l_ac].rai07 = '0'
           IF g_rah.rah10 = '2' THEN
              LET g_rai[l_ac].rai06 = 0 
              LET g_rai[l_ac].rai09 = 0 
           END IF
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("rai03",FALSE)
           ELSE
              CALL cl_set_comp_entry("rai03",TRUE)
           END IF   
           LET g_rai_t.* = g_rai[l_ac].*
           LET g_rai_o.* = g_rai[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rai03

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           IF cl_null(g_rai[l_ac].rai06) THEN LET g_rai[l_ac].rai06 = 0  END IF
           IF cl_null(g_rai[l_ac].rai09) THEN LET g_rai[l_ac].rai09 = 0  END IF
           IF cl_null(g_rai[l_ac].rai10) THEN LET g_rai[l_ac].rai10 = 0  END IF   
           INSERT INTO rai_file(rai01,rai02,rai03,rai04,rai05,rai06,
                                rai07,rai08,rai09,rai10,raiacti,raiplant,railegal)   
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_rai[l_ac].rai03,g_rai[l_ac].rai04,
                  g_rai[l_ac].rai05,g_rai[l_ac].rai06,
                  g_rai[l_ac].rai07,g_rai[l_ac].rai08,
                  g_rai[l_ac].rai09,g_rai[l_ac].rai10,g_rai[l_ac].raiacti,
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rai_file",g_rah.rah01,g_rai[l_ac].rai03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF p_cmd='u' THEN
                 CALL t304_upd_log()
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF

        BEFORE FIELD rai03
           IF g_rai[l_ac].rai03 IS NULL OR g_rai[l_ac].rai03 = 0 THEN
              SELECT max(rai03)+1
                INTO g_rai[l_ac].rai03
                FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND raiplant = g_rah.rahplant
              IF g_rai[l_ac].rai03 IS NULL THEN
                 LET g_rai[l_ac].rai03 = 1
              END IF
           END IF
 
        AFTER FIELD rai03
           IF NOT cl_null(g_rai[l_ac].rai03) THEN
              IF g_rai[l_ac].rai03 != g_rai_t.rai03
                 OR g_rai_t.rai03 IS NULL THEN
                 SELECT COUNT(*)
                   INTO l_n
                   FROM rai_file
                  WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                    AND rai03 = g_rai[l_ac].rai03 AND raiplant = g_rah.rahplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rai[l_ac].rai03 = g_rai_t.rai03
                    NEXT FIELD rai02
                 END IF
              END IF
           END IF

      AFTER FIELD rai04
         IF NOT cl_null(g_rai[l_ac].rai04) THEN
            IF g_rai_o.rai04 IS NULL OR
               (g_rai[l_ac].rai04 != g_rai_o.rai04 ) THEN
               IF g_rai[l_ac].rai04 < 0 THEN
                  CALL cl_err(g_rai[l_ac].rai04,'aec-020',0)
                  LET g_rai[l_ac].rai04= g_rai_o.rai04
                  NEXT FIELD rai04
               END IF
            END IF
            IF l_ac = 1 THEN
               LET l_ac_o = 1
            ELSE 
            	 LET l_ac_o = l_ac - 1   
            END IF   
            IF g_rai[l_ac].rai04 < g_rai[l_ac_o].rai04  THEN
               CALL cl_err(g_rai[l_ac].rai04,'aec-030',0)
               NEXT FIELD rai04
            END IF   
         END IF

      ON CHANGE rai07
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t304_rai_entry()
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM rap_file
              WHERE rap01 = g_rah.rah01
                AND rap02 = g_rah.rah02
                AND rap03 = '3'
                AND rap04 = g_rai[l_ac].rai03
                AND rap09 = g_rai_t.rai07
                AND rapplant = g_rah.rahplant             
          #此會員促銷方式已經有設定資料,是否將設定資料刪除
            IF l_cnt > 0 THEN
               IF NOT cl_confirm('art-756') THEN
                  LET g_rai[l_ac].rai07 = g_rai_t.rai07
               ELSE
                  DELETE FROM rap_file
                    WHERE rap01 = g_rah.rah01
                      AND rap02 = g_rah.rah02
                      AND rap03 = '3'
                      AND rap04 = g_rai[l_ac].rai03
                      AND rap09 = g_rai_t.rai07
                      AND rapplant = g_rah.rahplant
               END IF
            END IF
         END IF 

      AFTER FIELD rai07
         IF g_rai[l_ac].rai07 <> '0' THEN
            LET g_rai[l_ac].rai08 = ''
            LET g_rai[l_ac].rai09 = 0
            DISPLAY BY NAME g_rai[l_ac].rai08,g_rai[l_ac].rai09
         ELSE 
            IF g_rah.rah10 = '2' AND g_rai[l_ac].rai08 IS NULL THEN
              NEXT FIELD rai08
            END IF
         END IF

      BEFORE FIELD rai05,rai06,rai08,rai09
         IF NOT cl_null(g_rai[l_ac].rai07) THEN
            CALL t304_rai_entry()
         END IF

      AFTER FIELD rai10   #折讓基數
         IF NOT cl_null(g_rai[l_ac].rai10) THEN
            IF g_rah.rah10 = '3' OR g_rah.rah10 = '4' THEN
              #IF g_rai[l_ac].rai10 <= 0 THEN  #mark
               IF g_rai[l_ac].rai10 < 0 THEN   #TQC-C20002 add
                  CALL cl_err('','art-784',0)
                  NEXT FIELD rai10
               END IF
               #TQC-C20002 add START
               IF g_rai[l_ac].rai10 = 0 THEN  #當折讓基數為0時顯示訊息提示user 
                  IF g_rah.rah25 = 1 THEN
                     CALL cl_msgany(p_row,p_col,'art-879') 
                  ELSE
                     CALL cl_msgany(p_row,p_col,'art-881')
                  END IF
               END IF
               IF g_rai[l_ac].rai10 > g_rai[l_ac].rai04 THEN  #折讓基數不可大於滿額金額或滿量數量
                  CALL cl_err('','art-880',0)
                  NEXT FIELD rai10
               END IF
               #TQC-C20002 add END
            END IF
         END IF

      AFTER FIELD rai06,rai09    #折讓額    
         LET l_price = FGL_DIALOG_GETBUFFER()        
         IF l_price > g_rai[l_ac].rai04 THEN
           #IF g_rah.rah10 = '3' AND g_rah.rah25 = '2' THEN   #CHI-C80035 mark
            IF (g_rah.rah10 = '3' OR g_rah.rah10 = '4') AND g_rah.rah25 = '2' THEN   #CHI-C80035 add
            ELSE          
               CALL cl_err('','art-850',0)
               NEXT FIELD CURRENT
            END IF                     
         END IF
         IF l_price <= 0 THEN    
            CALL cl_err('','art-653',0)      
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rai[l_ac].rai05,g_rai[l_ac].rai09
         END IF

      AFTER FIELD rai05,rai08   
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rai[l_ac].rai06
           END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rai_t.rai03 > 0 AND g_rai_t.rai03 IS NOT NULL THEN 
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              LET l_success = 'Y'         
              CALL s_showmsg_init()        
              DELETE FROM rai_file
               WHERE rai02 = g_rah.rah02 AND rai01 = g_rah.rah01
                 AND rai03 = g_rai_t.rai03  AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
                 CALL s_errmsg('del','','rai_file',SQLCA.sqlcode,1)  
                 LET l_success = 'N'                                
              ELSE 
               	 DELETE FROM raj_file 
               	  WHERE raj01 = g_rah.rah01   AND raj02 = g_rah.rah02
                    AND raj03 = g_rai_t.rai03 AND rajplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','raj_file',SQLCA.sqlcode,1)    
                    LET l_success = 'N'                                   
                 END IF 
                 DELETE FROM rap_file
                  WHERE rap01 = g_rah.rah01 AND rap02 = g_rah.rah02
                    AND rap03 = '3'
                    AND rap04 = g_rai_t.rai03
                    AND rapplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','rap_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF
                 DELETE FROM rar_file
                  WHERE rar01 = g_rah.rah01 AND rar02 = g_rah.rah02
                    AND rar03 = '3'
                    AND rar04 = g_rai_t.rai03
                    AND rarplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','rar_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF
                 DELETE FROM ras_file
                  WHERE ras01 = g_rah.rah01 AND ras02 = g_rah.rah02
                    AND ras03 = '3'
                    AND ras04 = g_rai_t.rai03
                    AND rasplant = g_rah.rahplant
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('del','','ras_file',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                 END IF        
              END IF
              IF l_success = 'N' THEN
                 CALL s_showmsg()
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              CALL t304_upd_log() 
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rai[l_ac].* = g_rai_t.*
              CLOSE t304_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           IF cl_null(g_rai[l_ac].rai04) THEN
              NEXT FIELD rai04
           END IF              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rai[l_ac].rai03,-263,1)
              LET g_rai[l_ac].* = g_rai_t.*
           ELSE
              UPDATE rai_file SET rai04  =g_rai[l_ac].rai04,
                                  rai05  =g_rai[l_ac].rai05,
                                  rai06  =g_rai[l_ac].rai06,
                                  rai07  =g_rai[l_ac].rai07,
                                  rai08  =g_rai[l_ac].rai08,
                                  rai09  =g_rai[l_ac].rai09,
                                  rai10  =g_rai[l_ac].rai10,  
                                  raiacti=g_rai[l_ac].raiacti
               WHERE rai02 = g_rah.rah02 AND rai01=g_rah.rah01
                 AND rai03=g_rai_t.rai03 AND raiplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rai_file",g_rah.rah01,g_rai_t.rai03,SQLCA.sqlcode,"","",1) 
                 LET g_rai[l_ac].* = g_rai_t.*
              ELSE
                 MESSAGE 'UPDATE rai_file O.K'
                 CALL t304_upd_log() 
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
                 LET g_rai[l_ac].* = g_rai_t.*
              END IF
              CLOSE t304_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF NOT cl_null(g_rah.rah02) THEN
              IF g_rai[l_ac].rai07 <> '0' THEN
                 IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND g_rai[l_ac].rai07 <> g_rai_t.rai07 ) THEN
                    CALl t302_2(g_rah.rah01,g_rah.rah02,'3',g_rah.rahplant,g_rah.rahconf,g_rah.rah10,g_rai[l_ac].rai07)
                 END IF
              END IF
           ELSE
              CALL cl_err('',-400,0)
           END IF
           CLOSE t304_bcl
           COMMIT WORK
           IF cl_null(g_rai[l_ac].rai03) THEN
              CALL g_rai.deleteelement(l_ac)
           END IF
    END INPUT

    INPUT ARRAY g_raj FROM s_raj.*
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
 
           OPEN t304_cl USING g_rah.rah01,g_rah.rah02,g_rah.rahplant
           IF STATUS THEN
              CALL cl_err("OPEN t304_cl:", STATUS, 1)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t304_cl INTO g_rah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rah.rah01,SQLCA.sqlcode,0)
              CLOSE t304_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_raj_t.* = g_raj[l_ac1].*  #BACKUP
              LET g_raj_o.* = g_raj[l_ac1].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("raj03",FALSE)
              ELSE
                 CALL cl_set_comp_entry("raj03",TRUE)
              END IF 
              OPEN t3041_bcl USING g_rah.rah01,g_rah.rah02,g_raj_t.raj03,g_raj_t.raj04,g_rah.rahplant
              IF STATUS THEN
                 CALL cl_err("OPEN t3041_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t3041_bcl INTO g_raj[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_raj_t.raj03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t304_raj04()
                 CALL t304_raj05('d',l_ac1)
                 CALL t304_raj06('d')
              END IF
          END IF 

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_raj[l_ac1].* TO NULL

           LET g_raj[l_ac1].rajacti = 'Y'            #Body default
           LET g_raj_t.* = g_raj[l_ac1].*
           LET g_raj_o.* = g_raj[l_ac1].*
           IF p_cmd='u' THEN
              CALL cl_set_comp_entry("raj03",FALSE)
           ELSE
              CALL cl_set_comp_entry("raj03",TRUE)
           END IF 
           CALL cl_show_fld_cont()
           NEXT FIELD raj03

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF (NOT cl_null(g_raj[l_ac1].raj03)) AND
              (NOT cl_null(g_raj[l_ac1].raj04)) THEN
              SELECT COUNT(*) INTO l_n FROM raj_file
               WHERE raj01 =g_rah.rah01 AND raj02 = g_rah.rah02
                 AND raj03 = g_raj[l_ac1].raj03
                 AND raj04 = g_raj[l_ac1].raj04
                 AND rajplant = g_rah.rahplant
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD raj03
              END IF
           END IF

           INSERT INTO raj_file(raj01,raj02,raj03,raj04,raj05,raj06,
                                rajacti,rajplant,rajlegal)   
           VALUES(g_rah.rah01,g_rah.rah02,
                  g_raj[l_ac1].raj03,g_raj[l_ac1].raj04,
                  g_raj[l_ac1].raj05,g_raj[l_ac1].raj06,
                  g_raj[l_ac1].rajacti,
                  g_rah.rahplant,g_rah.rahlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","raj_file",g_rah.rah01,g_raj[l_ac1].raj03,SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              CALL s_showmsg_init() 
              CALL t304_repeat(g_raj[l_ac1].raj03)  #check
              CALL s_showmsg() 
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF

       BEFORE FIELD raj03
          IF g_raj[l_ac1].raj03 IS NULL OR g_raj[l_ac1].raj03 = 0 THEN
             SELECT MAX(raj03)
               INTO g_raj[l_ac1].raj03
               FROM raj_file
              WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                AND rajplant = g_rah.rahplant
             IF g_raj[l_ac1].raj03 IS NULL THEN
                LET g_raj[l_ac1].raj03 = 1
             END IF
          END IF
 
       AFTER FIELD raj03
          IF NOT cl_null(g_raj[l_ac1].raj03) THEN
             IF g_raj[l_ac1].raj03 != g_raj_t.raj03
                OR g_raj_t.raj03 IS NULL THEN  
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_raj[l_ac1].raj03,g_errno,0)
                   LET g_raj[l_ac1].raj03 = g_raj_o.raj03
                   NEXT FIELD raj03
                END IF                
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj03 = g_raj_t.raj03
                   NEXT FIELD raj03
                END IF
             END IF
          END IF

      AFTER FIELD raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            IF g_raj_o.raj04 IS NULL OR
               (g_raj[l_ac1].raj04 != g_raj_o.raj04 ) THEN
                SELECT COUNT(*)
                  INTO l_n
                  FROM raj_file
                 WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                   AND raj03 = g_raj[l_ac1].raj03 AND raj04 = g_raj[l_ac1].raj04 AND rajplant = g_rah.rahplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_raj[l_ac1].raj04 = g_raj_t.raj04
                   NEXT FIELD raj04
                END IF
               CALL t304_raj04()
            END IF  
         END IF  

      ON CHANGE raj04
         IF NOT cl_null(g_raj[l_ac1].raj04) THEN
            CALL t304_raj04()   
            LET g_raj[l_ac1].raj05=NULL
            LET g_raj[l_ac1].raj05_desc=NULL
            LET g_raj[l_ac1].raj06=NULL
            LET g_raj[l_ac1].raj06_desc=NULL
            DISPLAY BY NAME g_raj[l_ac1].raj05,g_raj[l_ac1].raj05_desc
            DISPLAY BY NAME g_raj[l_ac1].raj06,g_raj[l_ac1].raj06_desc
         END IF

      AFTER FIELD raj05
         IF NOT cl_null(g_raj[l_ac1].raj05) THEN
            IF g_raj[l_ac1].raj04 = '01' THEN 
               IF NOT s_chk_item_no(g_raj[l_ac1].raj05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_raj[l_ac1].raj05= g_raj_t.raj05
                  NEXT FIELD raj05
               END IF
            END IF 
            IF g_raj_o.raj05 IS NULL OR
               (g_raj[l_ac1].raj05 != g_raj_o.raj05 ) THEN
               CALL t304_raj05('a',l_ac1) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj05,g_errno,0)
                  LET g_raj[l_ac1].raj05 = g_raj_o.raj05
                  NEXT FIELD raj05
               END IF
            END IF  
         END IF  

      AFTER FIELD raj06
         IF NOT cl_null(g_raj[l_ac1].raj06) THEN
            IF g_raj_o.raj06 IS NULL OR
               (g_raj[l_ac1].raj06 != g_raj_o.raj06 ) THEN
               CALL t304_raj06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_raj[l_ac1].raj06,g_errno,0)
                  LET g_raj[l_ac1].raj06 = g_raj_o.raj06
                  NEXT FIELD raj06
               END IF
            END IF  
         END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_raj_t.raj03 > 0 AND g_raj_t.raj03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM raj_file
               WHERE raj02 = g_rah.rah02 AND raj01 = g_rah.rah01
                 AND raj03 = g_raj_t.raj03 AND raj04 = g_raj_t.raj04 
                 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_raj[l_ac1].* = g_raj_t.*
              CLOSE t3041_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raj[l_ac1].raj03,-263,1)
              LET g_raj[l_ac1].* = g_raj_t.*
           ELSE
              IF g_raj[l_ac1].raj03<>g_raj_t.raj03 OR
                 g_raj[l_ac1].raj04<>g_raj_t.raj04 THEN
                 SELECT COUNT(*) INTO l_n FROM raj_file
                  WHERE raj01 =g_rah.rah01 AND raj02 = g_rah.rah02
                    AND raj03 = g_raj[l_ac1].raj03
                    AND raj04 = g_raj[l_ac1].raj04
                    AND rajplant = g_rah.rahplant
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD raj03
                 END IF
              END IF
              UPDATE raj_file SET raj03=g_raj[l_ac1].raj03,
                                  raj04=g_raj[l_ac1].raj04,
                                  raj05=g_raj[l_ac1].raj05,
                                  raj06=g_raj[l_ac1].raj06,
                                  rajacti=g_raj[l_ac1].rajacti
               WHERE raj02 = g_rah.rah02 AND raj01=g_rah.rah01
                 AND raj03=g_raj_t.raj03 AND raj04=g_raj_t.raj04 AND rajplant = g_rah.rahplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","raj_file",g_rah.rah01,g_raj_t.raj03,SQLCA.sqlcode,"","",1) 
                 LET g_raj[l_ac1].* = g_raj_t.*
                 ROLLBACK WORK
              ELSE
                 CALL s_showmsg_init() 
                 CALL t304_repeat(g_raj[l_ac1].raj03)  #check
                 CALL s_showmsg() 
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
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
                 LET g_raj[l_ac1].* = g_raj_t.*
              END IF
              CLOSE t3041_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           CLOSE t3041_bcl
           COMMIT WORK
    END INPUT
      #FUN-D30033--add---begin---
      BEFORE DIALOG
         CASE g_b_flag
            WHEN '1' NEXT FIELD raj03
            WHEN '2' NEXT FIELD rak05
            WHEN '3' NEXT FIELD rai03
         END CASE
      #FUN-D30033--add---end---
 
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
      #FUN-D30033--add--str--
         IF l_flag = '1' THEN
            IF p_cmd = 'a' THEN
               CALL g_raj.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac1 = l_ac1_t
               END IF
            END IF
            CLOSE t3041_bcl
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
            CLOSE t3042_bcl
            ROLLBACK WORK
         END IF
         IF l_flag = '3' THEN
            IF p_cmd = 'a' THEN
               CALL g_rai.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t304_bcl
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
         IF INFIELD(rai03) AND l_ac > 1 THEN
            LET g_rai[l_ac].* = g_rai[l_ac-1].*
            LET g_rai[l_ac].rai03 = g_rec_b + 1
            NEXT FIELD rai04
         END IF

        #FUN-C30151 add START
         IF INFIELD(rak05) AND l_ac2 > 1 THEN
            LET g_rak[l_ac2].* = g_rak[l_ac2-1].*
            NEXT FIELD rak05
         END IF
        #FUN-C30151 add END

       ON ACTION controlp
          CASE
             WHEN INFIELD(raj05)
                CALL cl_init_qry_var()
                CASE g_raj[l_ac1].raj04
                   WHEN '01'
                 # ------------------ add -------------------- begin #add by MOD-CC0219 
                      IF p_cmd = 'a' AND NOT cl_null(g_raj[l_ac1].raj03)      
                                     AND NOT cl_null(g_raj[l_ac1].raj04) THEN 
                         CALL q_sel_ima(TRUE, "q_ima_1","",g_raj[l_ac1].raj05,"","","","","",'' )
                         RETURNING g_multi_ima01
                         IF NOT cl_null(g_multi_ima01) THEN
                            CALL t304_multi_ima01()
                            IF g_success = 'N' THEN
                               NEXT FIELD raj05
                            END IF
                            CALL t304_b1_fill(' 1=1')
                            CALL t304_all_b()
                            EXIT DIALOG
                         END IF
                      ELSE
                 # ------------------ add -------------------- end by MOD-CC0219
                         CALL q_sel_ima(FALSE, "q_ima_1","",g_raj[l_ac1].raj05,"","","","","",'' )                       
                           RETURNING g_raj[l_ac1].raj05
                      END IF #MOD-CC0219 add     
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
                IF g_raj[l_ac1].raj04 != '01' THEN
                   LET g_qryparam.default1 = g_raj[l_ac1].raj05
                   CALL cl_create_qry() RETURNING g_raj[l_ac1].raj05
                END IF
                CALL t304_raj05('d',l_ac1)
                NEXT FIELD raj05
             WHEN INFIELD(raj06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe02"
                LET g_qryparam.arg1 = g_raj[l_ac1].raj05
                LET g_qryparam.default1 = g_raj[l_ac1].raj06
                CALL cl_create_qry() RETURNING g_raj[l_ac1].raj06
                CALL t304_raj06('d')
                NEXT FIELD raj06
             OTHERWISE EXIT CASE
           END CASE
    END DIALOG

    CLOSE t304_bcl
    CLOSE t3041_bcl
    CLOSE t3042_bcl
    COMMIT WORK
#   CALL t304_delall() #CHI-C30002 mark
    CALL t304_delHeader()     #CHI-C30002 add
    CALL t304_b_fill(g_wc1)
    CALL t304_b1_fill(g_wc2)
    CALL t304_b3_fill(g_wc3)
END FUNCTION

FUNCTION t304_set_entry_rak(p_ac)
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

FUNCTION r304_update_pos()
DEFINE l_rahpos       LIKE rah_file.rahpos

   SELECT rahpos INTO l_rahpos FROM rah_file
      WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
        AND rahplant = g_rah.rahplant
   IF l_rahpos <> '1' THEN
      LET l_rahpos = '2'
   ELSE
      LET l_rahpos = '1'
   END IF
   UPDATE rah_file SET rahpos = l_rahpos
      WHERE rah01 = g_rah.rah01 AND rah02 = g_rah.rah02
        AND rahplant = g_rah.rahplant

   LET g_rah.rahpos = l_rahpos
   DISPLAY BY NAME g_rah.rahpos

END FUNCTION
#FUN-BB0059 add END
#FUN-C10008 add START
FUNCTION t304_chkrap()
   DEFINE l_n      LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM rap_file
     WHERE rap01 =g_rah.rah01 AND rap02 = g_rah.rah02
       AND rap03 = 3
       AND rapplant = g_rah.rahplant
   IF l_n > 0 THEN
     IF NOT cl_confirm('art-797') THEN
        RETURN
     END IF
     UPDATE rap_file SET rap06 = 0,
                         rap07 = 0,
                         rap08 = 0
           WHERE rap01 =g_rah.rah01 AND rap02 = g_rah.rah02
             AND rap03 = 3
             AND rapplant = g_rah.rahplant
     CALL cl_err('','art-891',1)
   END IF
END FUNCTION
#FUN-C10008 add END
#FUN-C30151 add START
FUNCTION t304_rai10_text()
DEFINE l_text    LIKE ze_file.ze03

   IF g_rah.rah10 = '2' THEN
      CALL cl_getmsg('art1059',g_lang) RETURNING l_text
      CALL cl_set_comp_att_text('rai10',l_text)
   ELSE
      CALL cl_getmsg('art1060',g_lang) RETURNING l_text
      CALL cl_set_comp_att_text('rai10',l_text)      
   END IF
END FUNCTION
#FUN-C30151 add END

# MOD-CC0219------------ add ----------- begin
FUNCTION t304_multi_ima01()
DEFINE  l_raj       RECORD LIKE raj_file.*
DEFINE  tok         base.StringTokenizer
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
   WHILE tok.hasMoreTokens()
      LET l_raj.raj05 = tok.nextToken()
      LET l_raj.raj01 = g_rah.rah01
      LET l_raj.raj02 = g_rah.rah02
      SELECT MAX(raj03)+1 INTO l_raj.raj03
        FROM raj_file
       WHERE raj01 = l_raj.raj01
         AND raj02 = l_raj.raj02
         AND raj04 = g_raj[l_ac1].raj04
         AND rajplant = g_rah.rahplant
      IF cl_null(l_raj.raj03) OR l_raj.raj03=0 THEN
         LET l_raj.raj03 = 1
      END IF
      LET l_raj.raj04 = g_raj[l_ac1].raj04

      IF cl_null(g_rtz04) THEN
         SELECT DISTINCT ima25
           INTO l_raj.raj06
           FROM ima_file
          WHERE ima01=l_raj.raj05
            AND imaacti = 'Y'
      ELSE
         SELECT DISTINCT ima25
           INTO l_raj.raj06
           FROM ima_file,rte_file
          WHERE ima01 = rte03 AND ima01=l_raj.raj05
            AND rte01 = g_rtz04
            AND rte07 = 'Y'
      END IF
      LET l_raj.rajplant = g_rah.rahplant
      LET l_raj.rajlegal = g_rah.rahlegal
      LET l_raj.rajacti  = 'Y'
      INSERT INTO raj_file VALUES(l_raj.*)
      IF STATUS THEN
         CALL s_errmsg('raj01',l_raj.raj05,'INS raj_file',STATUS,1)
         CONTINUE WHILE
      END IF
   END WHILE
   CALL s_showmsg()
END FUNCTION
# MOD-CC0219------------ add ----------- end

#FUN-CC0129 add begin-------------------------------
FUNCTION t304_copy()
   DEFINE l_newno     LIKE rah_file.rah02,
          l_oldno     LIKE rah_file.rah02,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5,
          i           LIKE type_file.num5          
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rah.rah02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_oldno  = g_rah.rah02
   LET g_success = 'Y' 

   DROP TABLE v
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP v
   DROP TABLE w
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP w
   DROP TABLE x
   SELECT * FROM rai_file WHERE 1 = 0 INTO TEMP x
   DROP TABLE y
   SELECT * FROM rah_file WHERE 1 = 0 INTO TEMP y
   DROP TABLE z
   SELECT * FROM raj_file WHERE 1 = 0 INTO TEMP z
      
   BEGIN WORK   
   
   LET g_before_input_done = FALSE
   CALL t304_set_entry('a')
   LET g_before_input_done = TRUE
WHILE TRUE
   CALL cl_set_head_visible("","YES")   
   INPUT l_newno FROM rah02
   
      BEFORE INPUT
      CALL cl_set_docno_format("rah02")
      
      AFTER FIELD rah02
      IF l_newno IS NULL THEN
         NEXT FIELD rah02 
      ELSE 
         SELECT COUNT(*) INTO i FROM rah_file 
          WHERE rah02    = l_newno
            AND rahplant = g_plant
            AND rah01    = g_rah.rah01
         IF i>0 THEN
            CALL cl_err('sel rah02:','-239',0)
            NEXT FIELD rah02
         END IF     
         CALL s_check_no("art",l_newno,g_rah_t.rah02,"A9","rah_file","rah01,rah02,rahplant","") 
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN                                                            
            LET g_rah.rah02=g_rah_t.rah02                                                                 
            NEXT FIELD rah02                                                                                     
         END IF            
      END IF                  

      ON ACTION controlp
         CASE 
            WHEN INFIELD(rah02)                                                                                                      
              LET g_t1=s_get_doc_no(l_newno)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'A9','art') RETURNING g_t1                                                                  
              LET l_newno = g_t1                                                                                                
              DISPLAY  l_newno TO rah02                                                                                           
              NEXT FIELD rah02
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
      DISPLAY BY NAME g_rah.rah02
      RETURN
   END IF   
   CALL s_auto_assign_no("art",l_newno,g_today,"A9","rah_file","rah01,rah02,rahplant","","","") 
      RETURNING li_result,l_newno 
   IF (NOT li_result) THEN  
      CONTINUE WHILE  
   END IF 
   DISPLAY l_newno TO rah02 
   EXIT WHILE
END WHILE        
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rah.rah02
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
     
   #满额促销单头维护
   SELECT * FROM rah_file
       WHERE rah02 = l_oldno AND rah01=g_rah.rah01
         AND rahplant = g_rah.rahplant
       INTO TEMP y 
   UPDATE y
       SET rah02=l_newno,
           rahplant=g_plant, 
           rahlegal=g_legal,
           rahconf = 'N',
           rahcond = NULL,
           rahconu = NULL,
           rahuser=g_user,
           rahgrup=g_grup,
           rahmodu=NULL,
           rahdate=g_today,
           rahacti='Y',
           rahcrat=g_today ,
           rahoriu = g_user,
           rahorig = g_grup
           
   INSERT INTO rah_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rah_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF    
   
   #条件设定
   SELECT * FROM rai_file
       WHERE rai02 = l_oldno AND rai01=g_rah.rah01 
         AND raiplant = g_rah.rahplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE x SET rai02=l_newno,
                raiplant = g_plant,
                railegal = g_legal 
 
   INSERT INTO rai_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rai_file","","",SQLCA.sqlcode,"","",1) 
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF 
   
   #时段设定
   SELECT * FROM rak_file
       WHERE rak02 = l_oldno AND rak01=g_rah.rah01 
         AND rakplant = g_rah.rahplant
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
       WHERE raq02 = l_oldno AND raq01=g_rah.rah01 
         AND raqplant = g_rah.rahplant
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
   SELECT * FROM raj_file
       WHERE raj02 = l_oldno AND raj01=g_rah.rah01 
         AND rajplant = g_rah.rahplant
       INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE z SET raj02=l_newno,
                rajplant = g_plant,
                rajlegal = g_legal 
 
   INSERT INTO raj_file
       SELECT * FROM z   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","raj_file","","",SQLCA.sqlcode,"","",1)
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
   SELECT rah_file.* INTO g_rah.* FROM rah_file 
      WHERE rah02=l_newno AND rah01 = g_rah.rah01
        AND rahplant = g_rah.rahplant
   CALL t304_u()
   CALL t304_all_b()
   SELECT rah_file.* INTO g_rah.* FROM rah_file 
       WHERE rah02=g_rah.rah02 AND rah01 = g_rah.rah01 
         AND rahplant = g_rah.rahplant
   CALL t304_show()        
END FUNCTION 
#FUN-CC0129 add end---------------------------------
