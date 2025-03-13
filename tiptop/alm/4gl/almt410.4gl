# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt410.4gl
# Descriptions...: 合同變更維護作業
# Date & Author..: No:FUN-BA0118 11/10/31 By fanbj
# Modify.........: No.FUN-BC0082 12/02/06 By chenwei  讲clm-332 改为 alm1580
# Modify.........: No:TQC-C20395 12/02/23 By shiwuying 延期时未产生日核算不允许初审
# Modify.........: No:FUN-C20078 12/02/14 By shiwuying 比例日核算调整
# Modify.........: No:TQC-C20505 12/02/27 By shiwuying SQL调整
# Modify.........: No:TQC-C20528 12/02/29 By baogc 初審拒絕與終審拒絕BUG修改
# Modify.........: No:MOD-C30450 12/03/13 By shiwuying 优变更日核算bug修改
# Modify.........: No:TQC-C40061 12/04/12 By fanbj 面積變更是判斷面積變更申請單中的新的面積應該和almi141中的面積進行比較，不是和almt140中的新的面積比較
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50036 12/05/22 By fanbj 延期和終止時更新pos
# Modify.........: No.FUN-C80006 12/08/02 By xumm 優惠金額調整，正的金額表示優惠
# Modify.........: No.FUN-C80072 12/08/22 By xumm 增加發出還原功能
# Modify.........: No.FUN-CA0148 12/10/31 By pauline 修改情況時變更申請單號開窗應該要顯示自己原本的單號
# Modify.........: No:CHI-C80041 13/01/04 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No.CHI-D20015 13/04/02 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds  
 
GLOBALS "../../config/top.global"

#合同变更单头档
DEFINE g_lji           RECORD LIKE lji_file.*,
       g_lji_t         RECORD LIKE lji_file.*,
       g_lji_o         RECORD LIKE lji_file.*,
      #g_ljq2          RECORD LIKE ljq_file.*,
       g_lji01_t              LIKE lji_file.lji01

#合同变更费用标准单身       
DEFINE g_ljj               DYNAMIC ARRAY OF RECORD 
          ljj03               LIKE ljj_file.ljj03,  # 项次
          ljj04               LIKE ljj_file.ljj04,  # 费用编号 
          oaj02               LIKE oaj_file.oaj02,  # 费用名称
          oaj05               LIKE oaj_file.oaj05,  # 费用性质
          ljj05               LIKE ljj_file.ljj05,  # 费用方案
          ljj051              LIKE ljj_file.ljj051, # 费用方案版本号
          ljj06               LIKE ljj_file.ljj06,  # 开始日期
          ljj07               LIKE ljj_file.ljj07,  # 结束日期
          ljj08               LIKE ljj_file.ljj08,  # 费用标准
          ljj02               LIKE ljj_file.ljj02   #合同版本号
                           END RECORD,
#合同变更优惠标准单身
       g_ljk               DYNAMIC ARRAY OF RECORD
          ljk03               LIKE ljk_file.ljk03,  # 项次
          ljk04               LIKE ljk_file.ljk04,  # 费用编号  
          oaj02_1             LIKE oaj_file.oaj02,  # 费用名称 
          oaj05_1             LIKE oaj_file.oaj05,  # 费用性质
          ljk05               LIKE ljk_file.ljk05,  # 优惠单号
          ljk06               LIKE ljk_file.ljk06,  # 优惠开始日期
          ljk07               LIKE ljk_file.ljk07,  # 优惠结束日期
          ljk08               LIKE ljk_file.ljk08,  # 优惠金额
          ljk02               LIKE ljk_file.ljk02   # 合同版本号
                           END RECORD ,
#合同变更其他费用单身                           
       g_ljl               DYNAMIC ARRAY OF RECORD
          ljl03               LIKE ljl_file.ljl03,  # 项次 
          ljl04               LIKE ljl_file.ljl04,  # 费用编号 
          oaj02_2             LIKE oaj_file.oaj02,  # 费用名称
          oaj05_2             LIKE oaj_file.oaj05,  # 费用性质
          ljl05               LIKE ljl_file.ljl05,  # 开始日期
          ljl06               LIKE ljl_file.ljl06,  # 结束日期 
          ljl07               LIKE ljl_file.ljl07,  # 费用金额
          ljl02               LIKE ljl_file.ljl02   # 合同版本
                           END RECORD, 
#合同变更定义付款单身                           
       g_ljm               DYNAMIC ARRAY OF RECORD
          ljm03               LIKE ljm_file.ljm03,  # 项次
          ljm04               LIKE ljm_file.ljm04,  # 费用编号
          oaj02_3             LIKE oaj_file.oaj02,  # 费用名称
          oaj05_3             LIKE oaj_file.oaj05,  # 费用性质
          ljm05               LIKE ljm_file.ljm05,  # 付款方式
          lnr02               LIKE lnr_file.lnr02,  # 付款方式名称
          ljm06               LIKE ljm_file.ljm06,  # 出帐期
          ljm07               LIKE ljm_file.ljm07,  # 出帐日
          ljm08               LIKE ljm_file.ljm08   # 核算制度
                           END RECORD ,
#合同变更场地单身                           
       g_ljn               DYNAMIC ARRAY OF RECORD
          ljn03               LIKE ljn_file.ljn03,  # 项次
          ljn04               LIKE ljn_file.ljn04,  # 场地编号
          ljn08               LIKE ljn_file.ljn08,  # 建筑面积
          ljn09               LIKE ljn_file.ljn09,  # 测量面积 
          ljn10               LIKE ljn_file.ljn10,  # 经营面积
          ljn05               LIKE ljn_file.ljn05,  # 楼栋编号
          lmb03               LIKE lmb_file.lmb03,  # 楼栋名称
          ljn06               LIKE ljn_file.ljn06,  # 楼层编号
          lmc04               LIKE lmc_file.lmc04,  # 楼层名称
          ljn07               LIKE ljn_file.ljn07,  # 区域编号
          lmy04               LIKE lmy_file.lmy04,  # 区域名称
          ljn02               LIKE ljn_file.ljn02   # 合同版本     
                           END RECORD,
#合同变更其他品牌单身                           
       g_ljo               DYNAMIC ARRAY OF RECORD
          ljo03               LIKE ljo_file.ljo03,  # 项次
          ljo04               LIKE ljo_file.ljo04,  # 品牌编号
          tqa02               LIKE tqa_file.tqa02,  # 品牌名称
          ljo02               LIKE ljo_file.ljo02   # 合同版本
                           END RECORD,  

       g_ljo_t             RECORD
          ljo03               LIKE ljo_file.ljo03,
          ljo04               LIKE ljo_file.ljo04,
          tqa02               LIKE tqa_file.tqa02,
          ljo02               LIKE ljo_file.ljo02
                           END RECORD,
#合同变更账单查询单身                           
       g_ljq               DYNAMIC ARRAY OF RECORD
          ljq03               LIKE ljq_file.ljq03,
          ljq04               LIKE ljq_file.ljq04,
          oaj02               LIKE oaj_file.oaj02,
          ljq05_desc          LIKE type_file.chr100,
          ljq06               LIKE ljq_file.ljq06,
          ljq07               LIKE ljq_file.ljq07,
          ljq08               LIKE ljq_file.ljq08,
          ljq09               LIKE ljq_file.ljq09,
          ljq10               LIKE ljq_file.ljq10,
          ljq11               LIKE ljq_file.ljq11,
          ljq12               LIKE ljq_file.ljq12,
          ljq13               LIKE ljq_file.ljq13,
          ljq14               LIKE ljq_file.ljq14,
          ljq14_desc          LIKE ljq_file.ljq14,
          ljq15               LIKE ljq_file.ljq15,
          ljq16               LIKE ljq_file.ljq16,
          ljq18               LIKE ljq_file.ljq18,
          ljq17               LIKE ljq_file.ljq17,
          ljq02               LIKE ljq_file.ljq02
                           END RECORD,
#合同变更日核算查询单身
       g_ljp               DYNAMIC ARRAY OF RECORD
          ljp03               LIKE ljp_file.ljp03,
          ljp04               LIKE ljp_file.ljp04,
          ljp05               LIKE ljp_file.ljp05,
          oaj02               LIKE oaj_file.oaj02,
          ljp06               LIKE ljp_file.ljp06,
          ljp07               LIKE ljp_file.ljp07,
          ljp071              LIKE ljp_file.ljp071,
          ljp08               LIKE ljp_file.ljp08,
          ljp09               LIKE ljp_file.ljp09,
          ljp02               LIKE ljp_file.ljp02
                           END RECORD 
DEFINE g_sql               STRING
DEFINE g_wc                STRING
DEFINE g_wc2,g_wc3,g_wc4   STRING
DEFINE g_wc5,g_wc6,g_wc7   STRING
DEFINE g_rec_b1,g_rec_b2   LIKE type_file.num5
DEFINE g_rec_b3,g_rec_b4   LIKE type_file.num5
DEFINE g_rec_b5,g_rec_b6   LIKE type_file.num5
DEFINE g_rec_b7,g_rec_b8   LIKE type_file.num5
DEFINE l_ac1,l_ac2,l_ac3   LIKE type_file.num5
DEFINE l_ac4,l_ac5,l_ac6   LIKE type_file.num5
DEFINE l_ac7,l_ac8         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE l_table             STRING
DEFINE g_str               STRING  
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_date              LIKE lji_file.ljidate
DEFINE g_modu              LIKE lji_file.ljimodu
DEFINE g_kindslip          LIKE oay_file.oayslip
DEFINE g_action_choice_t   STRING 
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_azi04             LIKE azi_file.azi04
DEFINE g_lla04             LIKE lla_file.lla04 
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

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
 
   LET g_forupd_sql = "SELECT * FROM lji_file WHERE lji01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t410_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t410_w WITH FORM "alm/42f/almt410"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t410_menu()
   CLOSE WINDOW t410_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t410_cs()
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01,
          l_table         LIKE type_file.chr1000,
          l_where         LIKE type_file.chr1000
 
   CLEAR FORM
   CALL g_ljj.clear()
   CALL g_ljk.clear()
   CALL g_ljl.clear()
   CALL g_ljm.clear()
   CALL g_ljn.clear()
   CALL g_ljo.clear()
   
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lji.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON lji01,lji02,ljiplant,ljilegal,lji03,lji04,lji05,
                                lji17,lji07,lji08,lji10,lji09,lji48,lji18,lji19,
                                lji20,lji21,lji11,lji12,lji13,lji14,lji141,lji15,
                                lji151,lji16,lji161,lji06,lji22,lji23,lji24,lji25,
                                lji26,lji27,lji28,lji29,lji32,lji33,lji34,lji35,
                                lji36,lji37,lji43,ljiconf,lji44,lji45,lji46,lji47,
                                lji30,lji31,lji42,lji38,lji381,lji49,lji50,lji51,
                                lji52,lji53,lji54,lji39,lji40,lji41,ljiuser,ljigrup,
                                ljioriu,ljimodu,ljidate,ljiorig,ljiacti,ljicrat
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               #门店编号
               WHEN INFIELD(ljiplant)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ljiplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljiplant
                  NEXT FIELD ljiplant

               #法人
               WHEN INFIELD(ljilegal)     
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ljilegal"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljilegal
                  NEXT FIELD ljilegal

               #合同变更单号
               WHEN INFIELD(lji01)     
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji01
                  NEXT FIELD lji01

               #变更申请单号 
               WHEN INFIELD(lji03)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji03
                  NEXT FIELD lji03

               #合同编号
               WHEN INFIELD(lji04)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji04
                  NEXT FIELD lji04

               #商户编号
               WHEN INFIELD(lji07)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji07"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji07
                  NEXT FIELD lji07

               #摊位编号
               WHEN INFIELD(lji08)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji08
                  NEXT FIELD lji08

               #摊位用途
               WHEN INFIELD(lji09)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji09"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji09
                  NEXT FIELD lji09

               #楼栋编号
               WHEN INFIELD (lji11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji11
                  NEXT FIELD lji11
               
               #楼层编号
               WHEN INFIELD (lji12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji12
                  NEXT FIELD lji12   
             
               #区域编号
               WHEN INFIELD (lji13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji13
                  NEXT FIELD lji13
           
               #业务人员
               WHEN INFIELD(lji30)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji30"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji30
                  NEXT FIELD lji30

               #部门
               WHEN INFIELD(lji31)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji31"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji31
                  NEXT FIELD lji31

               #初审人
               WHEN INFIELD(lji44)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji44"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji44
                  NEXT FIELD lji44

               #终审人
               WHEN INFIELD(lji46)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji46"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji46
                  NEXT FIELD lji46

               #主品牌
               WHEN INFIELD(lji38)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji38"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji38
                  NEXT FIELD lji38

               #新主品牌
               WHEN INFIELD(lji381)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji381"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji381
                  NEXT FIELD lji381

               #经营大类
               WHEN INFIELD(lji49)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji49"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji49
                  NEXT FIELD lji49

               #经营中类
               WHEN INFIELD(lji50)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji50"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji50
                  NEXT FIELD lji50   

               #经营小类
               WHEN INFIELD(lji51)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji51"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji51
                  NEXT FIELD lji51

               #税别
               WHEN INFIELD(lji52)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji52"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji52
                  NEXT FIELD lji52 

               #预租协议
               WHEN INFIELD(lji39)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji39"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji39
                  NEXT FIELD lji39

               #合同费用项方案
               WHEN INFIELD(lji40)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lji40"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lji40
                  NEXT FIELD lji40  
               OTHERWISE EXIT CASE
            END CASE
 
      END CONSTRUCT

      CONSTRUCT g_wc2 ON ljj03,ljj04,ljj05,ljj051,ljj06,ljj07,ljj08,ljj02
           FROM s_ljj[1].ljj03,s_ljj[1].ljj04,s_ljj[1].ljj05,s_ljj[1].ljj051,
                s_ljj[1].ljj06,s_ljj[1].ljj07,s_ljj[1].ljj08,s_ljj[1].ljj02
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE 
               #标准费用单身费用编号
               WHEN INFIELD(ljj04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ljj04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ljj04
                 NEXT FIELD ljj04

              #标准费用单身费用方案   
              WHEN INFIELD(ljj05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ljj05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ljj05
                 NEXT FIELD ljj05
               OTHERWISE EXIT CASE   
           END CASE     
      END CONSTRUCT  

      CONSTRUCT g_wc3 ON ljk03,ljk04,ljk05,ljk06,ljk07,ljk08,ljk02
           FROM s_ljk[1].ljk03,s_ljk[1].ljk04,s_ljk[1].ljk05,s_ljk[1].ljk06,
                s_ljk[1].ljk07,s_ljk[1].ljk08,s_ljk[1].ljk02
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #优惠单身费用编号
               WHEN INFIELD(ljk04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljk04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljk04
                  NEXT FIELD ljk04

               #优惠单身优惠单号   
               WHEN INFIELD(ljk05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljk05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljk05
                  NEXT FIELD ljk05
                OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT

      CONSTRUCT g_wc4 ON ljl03,ljl04,ljl05,ljl06,ljl07,ljl02
           FROM s_ljl[1].ljl03,s_ljl[1].ljl04,s_ljl[1].ljl05,s_ljl[1].ljl06,
                s_ljl[1].ljl07,s_ljl[1].ljl02
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #其他费用单身费用单号
               WHEN INFIELD(ljl04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljl04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljl04
                  NEXT FIELD ljl04
               OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT  

      CONSTRUCT g_wc5 ON ljm03,ljm04,ljm05,ljm06,ljm07,ljm08
           FROM s_ljm[1].ljm03,s_ljm[1].ljm04,s_ljm[1].ljm05,s_ljm[1].ljm06,
                s_ljm[1].ljm07,s_ljm[1].ljm08
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #定义付款单身费用编号
               WHEN INFIELD(ljm04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljm04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljm04
                  NEXT FIELD ljm04

               #定义付款单身付款方式编号 
               WHEN INFIELD(ljm05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljm05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljm05
                  NEXT FIELD ljm05   
               OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT

      CONSTRUCT g_wc6 ON ljn03,ljn04,ljn08,ljn09,ljn10,ljn05,ljn06,ljn07,ljn02
           FROM s_ljn[1].ljn03,s_ljn[1].ljn04,s_ljn[1].ljn08,s_ljn[1].ljn09,
                s_ljn[1].ljn10,s_ljn[1].ljn05,s_ljn[1].ljn06,s_ljn[1].ljn07,
                s_ljn[1].ljn02
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #场地编号
               WHEN INFIELD(ljn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljn04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljn04
                  NEXT FIELD ljn04

               #楼栋编号
               WHEN INFIELD(ljn05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljn05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljn05
                  NEXT FIELD ljn05

               #楼层编号
               WHEN INFIELD(ljn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljn06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljn06
                  NEXT FIELD ljn06

               #区域编号
               WHEN INFIELD(ljn07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljn07"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljn07
                  NEXT FIELD ljn07   
               OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT

      CONSTRUCT g_wc7 ON ljo03,ljo04,ljo02 
           FROM s_ljo[1].ljo03,s_ljo[1].ljo04,s_ljo[1].ljo02

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #品牌编号
               WHEN INFIELD(ljo04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljo04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljo04
                  NEXT FIELD ljo04
               OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT

      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG
                 
      ON ACTION about 
         CALL cl_about()
                      
      ON ACTION HELP  
         CALL cl_show_help()
             
      ON ACTION controlg
         CALL cl_cmdask()
                
      ON ACTION qbe_save
         CALL cl_qbe_save() 

      ON ACTION ACCEPT
         ACCEPT DIALOG
 
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG

   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT lji01 "
   LET l_table = " FROM lji_file "
   LET l_where = " WHERE ",g_wc

   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table," ,ljj_file"
      LET l_where = l_where, " AND ljj01 = lji01 AND ",g_wc2
   END IF

   IF g_wc3 <> " 1=1" THEN
      LET l_table = l_table ," ,ljk_file"
      LET l_where = l_where ," AND ljk01 = lji01 AND ",g_wc3
   END IF 

   IF g_wc4 <> " 1=1" THEN
      LET l_table = l_table,",ljl_file"
      LET l_where = l_where ," AND ljl01 = lji01 AND ",g_wc4
   END IF

   IF g_wc5 <> " 1=1" THEN
      LET l_table = l_table,",ljm_file"
      LET l_where = l_where ," AND ljm01 = lji01 AND ",g_wc5
   END IF 

   IF g_wc6 <> " 1=1" THEN
      LET l_table = l_table ,",ljn_file"
      LET l_where = l_where ," AND ljn01 = lji01 AND ",g_wc6
   END IF

   IF g_wc7 <> " 1=1" THEN
      LET l_table = l_table,",ljo_file"
      LET l_where = l_where ," AND ljo01 = lji01 AND ",g_wc7
   END IF 

   LET g_sql = g_sql,l_table,l_where," ORDER BY lji01"
 
   PREPARE t410_prepare FROM g_sql
   DECLARE t410_cs SCROLL CURSOR WITH HOLD FOR t410_prepare
 
   LET g_sql = "SELECT DISTINCT COUNT(lji01) ",l_table,l_where
   PREPARE t410_precount FROM g_sql
   DECLARE t410_count CURSOR FOR t410_precount
 
END FUNCTION
 
FUNCTION t410_menu()
   WHILE TRUE

      CALL t410_bp("G")

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t410_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t410_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t410_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t410_u()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '6' THEN
                  CALL t410_b6()
               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF
           
         #合同变更--初审拒绝  
         WHEN "first_deny"
            IF cl_chk_act_auth() THEN
               CALL t410_deny1()
            END IF
            
         #合同变更--初审通过
         WHEN "first_confirm"
            IF cl_chk_act_auth() THEN
               CALL t410_confirm()
            END IF

         #合同变更--取消审核    
         WHEN "undo_confirm1"
            IF cl_chk_act_auth() THEN
               CALL t410_unconfirm1()
            END IF 

         #合同变更--终审拒绝   
         WHEN "final_deny"
            IF cl_chk_act_auth() THEN
               CALL t410_deny2()
            END IF

         #合同变更--终审通过
         WHEN "final_confirm"
            IF cl_chk_act_auth() THEN
               CALL t410_confirm2()
            END IF

         #合同变更--取消终审    
         WHEN "undo_confirm2"
            IF cl_chk_act_auth() THEN
               CALL t410_unconfirm2()
            END IF 
            
         #合同变更--变更发出   
         WHEN "change_post"
            IF cl_chk_act_auth() THEN
               CALL t410_post()
            END IF  

         #FUN-C80072----add----str
         #合同变更--發出還原
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t410_undo_post()
            END IF
         #FUN-C80072----add----end

         #合同变更--账单查询   
         WHEN "bill"
            IF cl_chk_act_auth() THEN
               CALL t410_qry_bill()
            END IF   

         #合同变更--产生日核算
         WHEN "generate_account"
            IF cl_chk_act_auth() THEN
               CALL t410_generate_account()  #产生日核算
            END IF

         #合同变更--产生账单  
         WHEN "generate_bills"
            IF cl_chk_act_auth() THEN
               CALL t410_generate_bills()
            END IF    
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
#         WHEN "exporttoexcel"
#            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lob),'','')
#            END IF
 
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lji.lji01 IS NOT NULL THEN
                 LET g_doc.column1 = "lji01"
                 LET g_doc.value1  = g_lji.lji01
                 CALL cl_doc()
              END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t410_v()
               IF g_lji.ljiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_lji.ljiconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

#合同变更作业bp函数
FUNCTION t410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = NULL 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ljj TO s_ljj.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b1 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
            
      END DISPLAY  

      DISPLAY ARRAY g_ljk TO s_ljk.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY    

      DISPLAY ARRAY g_ljl TO s_ljl.* ATTRIBUTE(COUNT=g_rec_b3)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b3 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY

      DISPLAY ARRAY g_ljm TO s_ljm.* ATTRIBUTE(COUNT=g_rec_b4)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b4 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac4 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      DISPLAY ARRAY g_ljn TO s_ljn.* ATTRIBUTE(COUNT=g_rec_b5)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b5 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac5 = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY

      DISPLAY ARRAY g_ljo TO s_ljo.* ATTRIBUTE(COUNT=g_rec_b6)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b6 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac6 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '6'
            LET l_ac6 = 1
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '6'
            LET l_ac6 = ARR_CURR()
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
         CALL t410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION previous
         CALL t410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG
         
      ON ACTION jump
         CALL t410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION next
         CALL t410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      ON ACTION last
         CALL t410_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      #产生日核算
      ON ACTION generate_account
         LET g_action_choice="generate_account"
         EXIT DIALOG 

      #产生账单
      ON ACTION generate_bills   
         LET g_action_choice="generate_bills"
         EXIT DIALOG
        
      #初审拒绝   
      ON ACTION first_deny
         LET g_action_choice="first_deny"
         EXIT DIALOG

      #初审通过   
      ON ACTION first_confirm
         LET g_action_choice="first_confirm"
         EXIT DIALOG 

      #取消初审   
      ON ACTION undo_confirm1
         LET g_action_choice="undo_confirm1"
         EXIT DIALOG

      #终审拒绝   
      ON ACTION final_deny
         LET g_action_choice="final_deny"
         EXIT DIALOG

      #终审通过   
      ON ACTION final_confirm
         LET g_action_choice="final_confirm"
         EXIT DIALOG

      #取消终审   
      ON ACTION undo_confirm2
         LET g_action_choice="undo_confirm2"
         EXIT DIALOG
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      #CHI-C80041---end 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      #变更发出  
      ON ACTION change_post
         LET g_action_choice="change_post"
         EXIT DIALOG   
      
      #FUN-C80072-----add---str
      #發出還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
      #FUN-C80072-----add---end      

      #查询账单
      ON ACTION bill
         LET g_action_choice="bill"
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
 
      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG   
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()
 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
      
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t410_a()
   DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""

   #清空单头单身
   CLEAR FORM
   CALL g_ljj.clear()
   CALL g_ljk.clear()
   CALL g_ljl.clear()
   CALL g_ljm.clear()
   CALL g_ljn.clear()
   CALL g_ljo.clear()

   #初始化
   LET g_wc = NULL
   LET g_wc2= NULL
   LET g_wc3 = NULL
   LET g_wc4 = NULL
   LET g_wc5 = NULL
   LET g_wc6 = NULL
   LET g_wc7 = NULL

   INITIALIZE g_lji.* LIKE lji_file.*
   LET g_lji01_t = NULL
   LET g_lji_t.* = g_lji.*
   LET g_lji_o.* = g_lji.*
   CALL cl_opmsg('a')
  
   WHILE TRUE
      LET g_lji.ljiplant = g_plant
      LET g_lji.ljilegal = g_legal
      LET g_lji.lji18 = '1'
      LET g_lji.lji19 = 'Y'
      LET g_lji.lji20 = 'N'
      LET g_lji.lji21 = 'N'
      LET g_lji.ljiconf = 'N'
      LET g_lji.lji43 = '0'
      LET g_lji.ljiuser = g_user
      LET g_lji.ljigrup = g_grup
      LET g_lji.ljidate = g_today
      LET g_lji.ljiacti = 'Y'
      LET g_lji.ljicrat = g_today
      LET g_lji.ljioriu = g_user
      LET g_lji.ljiorig = g_grup
      LET g_lji.ljimksg = ' '
      LET g_lji.lji30 = g_user
      LET g_lji.lji31 = g_grup
         
      CALL t410_gen02(g_lji.lji30,'d')
      CALL t410_gem02('d')
      CALL t410_i("a")
      
      IF INT_FLAG THEN
         INITIALIZE g_lji.* TO NULL
         CALL g_ljj.clear()
         CALL g_ljk.clear()
         CALL g_ljl.clear()
         CALL g_ljm.clear()
         CALL g_ljn.clear()
         CALL g_ljo.clear()
         LET INT_FLAG = 0
         LET g_lji01_t = NULL  
         CALL cl_err('',9001,0)
         CLEAR FORM     
         RETURN      
      END IF
 
      IF cl_null(g_lji.lji01) OR cl_null(g_lji.ljiplant) THEN
         CONTINUE WHILE
      END IF

      #####自動編號########################
      CALL s_auto_assign_no("alm",g_lji.lji01,g_today,'P9',"lji_file",
                            "lji01","","","") RETURNING li_result,g_lji.lji01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lji.lji01
      ###################################
 
      BEGIN WORK
      LET g_success = 'Y'
      INSERT INTO lji_file VALUES (g_lji.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK 
         CONTINUE WHILE
      END IF

      #alms101中金额保留小数点位数 
      SELECT lla04 INTO g_lla04
        FROM lla_file
       WHERE llastore = g_lji.ljiplant

      #通过比别抓取aooi050比别基本资料中的azi04金额小数位数
      SELECT azi04 INTO g_azi04 
        FROM azi_file 
       WHERE azi01 = g_aza.aza17 

      CALL g_ljj.clear()
      CALL g_ljk.clear()
      CALL g_ljl.clear()
      CALL g_ljm.clear()
      CALL g_ljn.clear()
      CALL g_ljo.clear()
      
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
      LET g_rec_b4 = 0
      LET g_rec_b5 = 0
      LET g_rec_b6 = 0 
           
      CALL t410_site()              #带出场地单身
      CALL t410_fs()                #带出费用标准单身
      CALL t410_other_fare()        #带出其他费用单身
      CALL t410_pre()               #带出优惠方式单身
      CALL t410_other_brand()       #带出其他品牌单身
      CALL t410_define_pay()        #带出定义付款单身
      CALL t410_daccount()          #带出合同原始日核算
      CALL t410_bill()              #带出合同原始账单

      IF g_success = 'N' THEN
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lji.lji01,'I')
      END IF 
      EXIT WHILE
   END WHILE
   CALL t410_generate_account()  #产生日核算   
   CALL t410_generate_bills()    #产生账单
#  CALL t410_upd()
   CALL t410_b1_fill(" 1=1")
   CALL t410_b2_fill(" 1=1")
   CALL t410_b3_fill(" 1=1")
   CALL t410_b4_fill(" 1=1")
   CALL t410_b5_fill(" 1=1")
   CALL t410_b6_fill(" 1=1")
END FUNCTION
 
FUNCTION t410_u()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01
 
   #不可異動其他門店資料
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF

   #合同变更单的审核码为未审核才可以修改
   IF NOT cl_null(g_lji.ljiconf) AND g_lji.ljiconf !='N' THEN
      CALL cl_err('','alm1365',0)
      RETURN
   END IF

   #合同变更单变更发出不可异动   
   IF g_lji.lji43 = '2' THEN 
      CALL cl_err('','alm-941',0)
      RETURN
   END IF 
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lji01_t = g_lji.lji01
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_date = g_lji.ljidate
   LET g_modu = g_lji.ljimodu
 
   CALL t410_show()
   WHILE TRUE
      LET g_lji01_t = g_lji.lji01
      LET g_lji_o.* = g_lji.*
      LET g_lji.ljimodu=g_user
      LET g_lji.ljidate=g_today
 
      CALL t410_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lji.*=g_lji_t.*
         LET g_lji_t.ljidate = g_date
         LET g_lji_t.ljimodu = g_modu
         CALL t410_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lji.lji01 != g_lji01_t THEN
         #更新单头主键及单身中的该字段
         UPDATE ljj_file 
            SET ljj01 = g_lji.lji01
          WHERE ljj01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljj_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF

         UPDATE ljk_file 
            SET ljk01 = g_lji.lji01
          WHERE ljk01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljk_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF

         UPDATE ljl_file 
            SET ljl01 = g_lji.lji01
          WHERE ljl01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljl_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF

         UPDATE ljm_file 
            SET ljm01 = g_lji.lji01
          WHERE ljm01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljm_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF

         UPDATE ljn_file 
            SET ljn01 = g_lji.lji01
          WHERE ljn01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljn_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF

         UPDATE ljo_file 
            SET ljo01 = g_lji.lji01
          WHERE ljo01 = g_lji01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ljo_file",g_lji01_t,"",SQLCA.sqlcode,"","ljj",1)
            CONTINUE WHILE
         END IF
      END IF
 
      #更新修改的单头资料到基本资料档中
      UPDATE lji_file SET lji_file.* = g_lji.*
       WHERE lji01 = g_lji01_t

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","lji_file",g_lji01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF 
      EXIT WHILE
   END WHILE
 
   CLOSE t410_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF

   SELECT * INTO g_lji.*
     FROM lin_file
    WHERE lji01 = g_lji.lji01
    CALL t410_show()
 
   CALL t410_b1_fill(" 1=1")
   CALL t410_b2_fill(" 1=1")
   CALL t410_b3_fill(" 1=1")
   CALL t410_b4_fill(" 1=1")
   CALL t410_b5_fill(" 1=1")
   CALL t410_b6_fill(" 1=1")
END FUNCTION
 
FUNCTION t410_i(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,
          li_result   LIKE type_file.num5,
          l_date      LIKE type_file.dat,
          l_n         LIKE type_file.num5,
          l_gen03     LIKE gen_File.gen03   
 
   DISPLAY BY NAME g_lji.ljiplant,g_lji.ljilegal,g_lji.lji18,g_lji.lji19,
                   g_lji.lji20,g_lji.lji21,g_lji.ljiconf,g_lji.lji43,
                   g_lji.ljiuser,g_lji.ljigrup,g_lji.ljimodu,g_lji.ljidate,
                   g_lji.ljiacti,g_lji.ljicrat,g_lji.ljioriu,g_lji.ljiorig

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_lji.lji01,g_lji.lji02,g_lji.ljiplant,g_lji.ljilegal,
                 g_lji.lji03,g_lji.lji04,g_lji.lji05,g_lji.lji17,g_lji.lji08,
                 g_lji.lji10,g_lji.lji09,g_lji.lji48,g_lji.lji18,g_lji.lji19,
                 g_lji.lji20,g_lji.lji21,g_lji.lji11,g_lji.lji12,g_lji.lji13,
                 g_lji.lji14,g_lji.lji15,g_lji.lji16,g_lji.lji06,g_lji.lji22,
                 g_lji.lji23,g_lji.lji24,g_lji.lji25,g_lji.lji26,g_lji.lji27,
                 g_lji.lji28,g_lji.lji29,g_lji.lji32,g_lji.lji33,g_lji.lji34,
                 g_lji.lji35,g_lji.lji36,g_lji.lji37,g_lji.lji43,g_lji.ljiconf,
                 g_lji.lji44,g_lji.lji45,g_lji.lji46,g_lji.lji47,g_lji.lji30,
                 g_lji.lji31,g_lji.lji42,g_lji.lji38,g_lji.lji381,g_lji.lji49,
                 g_lji.lji50,g_lji.lji51,g_lji.lji52,g_lji.lji53,g_lji.lji54,
                 g_lji.lji39,g_lji.lji40,g_lji.lji41,g_lji.ljiuser,g_lji.ljigrup,
                 g_lji.ljioriu,g_lji.ljimodu,g_lji.ljidate,g_lji.ljiorig,
                 g_lji.ljiacti,g_lji.ljicrat
                 WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t410_set_entry(p_cmd)
         CALL t410_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      #合同变更单号
      AFTER FIELD lji01
         IF NOT cl_null(g_lji.lji01) THEN
            IF (p_cmd = 'a' ) OR
               (p_cmd = 'u' AND g_lji.lji01 != g_lji_t.lji01) THEN
               CALL s_check_no("alm",g_lji.lji01,g_lji01_t,"P9","lji_file",
                         "lji01","") RETURNING li_result,g_lji.lji01
               IF ( NOT li_result) THEN
                  LET g_lji.lji01 = g_lji_t.lji01
                  NEXT FIELD lji01
               END IF
            END IF 
         END IF

      #合同变更类型
      AFTER FIELD lji02 
         IF NOT cl_null(g_lji.lji02) THEN
            IF p_cmd = 'u' AND g_lji.lji02 <> g_lji_t.lji02 THEN
               CALL t410_check_for_upd()
               IF NOT cl_null(g_errno) THEN   
                  CALL cl_err('','alm1180',0)
                  LET g_lji.lji02 = g_lji_t.lji02
                  DISPLAY BY NAME g_lji.lji02
                END IF   
            END IF  
         END IF 

      ON CHANGE lji02
         #IF p_cmd = 'a' AND g_lji.lji03 <> '' THEN         #TQC-C40061 mark
         IF p_cmd = 'a' AND NOT cl_null(g_lji.lji03) THEN   #TQC-C40061 add
            LET g_lji.lji03 = NULL                  
            LET g_lji.lji04 = NULL                          #TQC-C40061 add
            DISPLAY BY NAME g_lji.lji03,g_lji.lji04         #TQC-C40061 add 
            CALL t410_lji03(p_cmd)      #根据类型带出合同编号
            CALL t410_lji04('d','2')
            CALL t410_desc()
         END IF    

      BEFORE FIELD lji03
         IF cl_null(g_lji.lji02) THEN
            CALL cl_err('','alm1223',0)
            NEXT FIELD lji02
         END IF 

      #变更申请单号
      AFTER FIELD lji03
         IF NOT cl_null(g_lji.lji03) THEN
            IF p_cmd = 'u' THEN
               IF g_lji.lji03 <> g_lji_t.lji03 THEN 
                  CALL t410_check_for_upd()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('','alm1181',0)
                     LET g_lji.lji03 = g_lji_t.lji03
                     DISPLAY BY NAME g_lji.lji03 
                  END IF 
               END IF 
            ELSE  
               CALL t410_lji03(p_cmd)      #根据类型带出合同编号
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lji.lji03 = g_lji_t.lji03
                  DISPLAY BY NAME g_lji.lji03
                  NEXT FIELD lji03
               END IF
               CALL t410_lji02()           #根据变更类别不同带出相关的变更信息

               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lji.lji03 = g_lji_t.lji03
                  DISPLAY BY NAME g_lji.lji03
                  NEXT FIELD lji03                    
               END IF 

               CALL t410_lji04(p_cmd,'1')  #联动带出合同相关信息以及check合同这个栏位
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lji.lji03 = g_lji_t.lji03
                  NEXT FIELD lji03
               END IF 
               CALL t410_lji05()           #版本号加1
               CALL t410_desc()
            END IF 
         END IF  

      #业务人员编号
      AFTER FIELD lji30
         IF NOT cl_null(g_lji.lji30) THEN
            CALL t410_gen02(g_lji.lji30,p_cmd)  #带出业务人员姓名，以及check栏位
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lji.lji30 = g_lji_t.lji30
               NEXT FIELD lji30
            END IF           
         END IF

      #业务人员所属部门
      AFTER FIELD lji31
         IF NOT cl_null(g_lji.lji31) THEN
            CALL t410_gem02(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lji.lji31 = g_lji_t.lji31
               NEXT FIELD lji31
            END IF 
         END IF    
                  
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                               RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            #合同变更单号，开窗q_oay
            WHEN INFIELD(lji01)
               LET g_kindslip = s_get_doc_no(g_lji.lji01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'P9','ALM') RETURNING g_kindslip
               LET g_lji.lji01 = g_kindslip
               DISPLAY BY NAME g_lji.lji01
               NEXT FIELD lji01

            #根据变更类型不同，变更单号新增开不同的窗   
            WHEN INFIELD(lji03)
               CALL cl_init_qry_var()
               IF g_lji.lji02 = '1' THEN
                  LET g_qryparam.form ="q_lja_1"
                 #LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file)"  #FUN-CA0148 mark
                  LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file WHERE lji01 NOT IN ('",g_lji.lji01,"') )"  #FUN-CA0148 add
               END IF 

               IF g_lji.lji02 = '2' THEN
                  LET g_qryparam.form ="q_lja_2"
                 #LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file)"  #FUN-CA0148 mark
                  LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file WHERE lji01 NOT IN ('",g_lji.lji01,"') )"  #FUN-CA0148 add
               END IF 

               IF g_lji.lji02 = '3' THEN
                  LET g_qryparam.form ="q_lja_3"
                 #LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file)"  #FUN-CA0148 mark 
                  LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file WHERE lji01 NOT IN ('",g_lji.lji01,"') )"  #FUN-CA0148 add
               END IF 

               IF g_lji.lji02 = '4' THEN
                  LET g_qryparam.form ="q_lja_4"
                 #LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file)"  #FUN-CA0148 mark
                  LET g_qryparam.where=" lja01 NOT IN (SELECT lji03 FROM lji_file WHERE lji01 NOT IN ('",g_lji.lji01,"') )"  #FUN-CA0148 add
               END IF 

               IF g_lji.lji02 = '5' THEN
                  LET g_qryparam.form ="q_lje"
                 #LET g_qryparam.where=" lje01 NOT IN (SELECT lji03 FROM lji_file)"  #FUN-CA0148 mark
                  LET g_qryparam.where=" lje01 NOT IN (SELECT lji03 FROM lji_file WHERE lji01 NOT IN ('",g_lji.lji01,"') )"  #FUN-CA0148 add
               END IF 
               LET g_qryparam.default1 = g_lji.lji03
               CALL cl_create_qry() RETURNING g_lji.lji03
               DISPLAY BY NAME g_lji.lji03
               NEXT FIELD lji03
              
            #业务人员 
            WHEN INFIELD(lji30)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen02"
               LET g_qryparam.default1 = g_lji.lji30
               IF NOT cl_null(g_lji.lji31) THEN
                   LET g_qryparam.where = " gen03 = '", g_lji.lji31 ,"' "
                END IF
               CALL cl_create_qry() RETURNING g_lji.lji30
               DISPLAY BY NAME g_lji.lji30
               NEXT FIELD lji30
               
            #所属部门
            WHEN INFIELD(lji31)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_lji.lji31
               IF NOT cl_null(g_lji.lji30) THEN
                   SELECT gen03 INTO l_gen03 FROM  gen_file
                    WHERE gen01 = g_lji.lji30
                   LET g_qryparam.where = " gem01 = '", l_gen03 ,"' "
                END IF
               CALL cl_create_qry() RETURNING g_lji.lji31
               DISPLAY BY NAME g_lji.lji31
               NEXT FIELD lji31   
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT 
END FUNCTION
 
FUNCTION t410_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )

   INITIALIZE g_lji.* TO NULL
   INITIALIZE g_lji_t.* TO NULL
   INITIALIZE g_lji_o.* TO NULL
   LET g_lji01_t =NULL
   LET g_wc = NULL
   
   MESSAGE " "
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t410_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lji.* TO NULL
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
      LET g_rec_b4 = 0
      LET g_rec_b5 = 0 
      LET g_rec_b6 = 0
      LET g_wc = NULL
      LET g_wc2 = NULL
      LET g_wc3 = NULL
      LET g_wc4 = NULL
      LET g_wc5 = NULL
      LET g_wc6 = NULL
      LET g_wc7 = NULL
      LET g_lji01_t = NULL
      RETURN
   END IF
 
   OPEN t410_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lji.* TO NULL
      LET g_wc = NULL
      LET g_lji01_t = NULL
   ELSE
      OPEN t410_count
      FETCH t410_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt 
      CALL t410_fetch('F')
   END IF 
END FUNCTION
 
FUNCTION t410_fetch(p_flag)
   DEFINE    p_flag  LIKE type_file.chr1 
   MESSAGE ''   

   CASE p_flag
      WHEN 'N' FETCH NEXT     t410_cs INTO g_lji.lji01
      WHEN 'P' FETCH PREVIOUS t410_cs INTO g_lji.lji01
      WHEN 'F' FETCH FIRST    t410_cs INTO g_lji.lji01
      WHEN 'L' FETCH LAST     t410_cs INTO g_lji.lji01
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
            FETCH ABSOLUTE g_jump t410_cs INTO g_lji.lji01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      INITIALIZE g_lji.* TO NULL
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
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01 = g_lji.lji01
    
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lji.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lji.ljiuser
   LET g_data_group = g_lji.ljigrup
   LET g_data_plant = g_lji.ljiplant    
   CALL t410_show()
END FUNCTION
 
FUNCTION t410_show()
   LET g_lji_t.* = g_lji.*
   LET g_lji_o.* = g_lji.*
   DISPLAY BY NAME g_lji.lji01,g_lji.lji02,g_lji.ljiplant,g_lji.ljilegal,
                   g_lji.lji03,g_lji.lji04,g_lji.lji05,g_lji.lji17,g_lji.lji07,
                   g_lji.lji08,g_lji.lji10,g_lji.lji09,g_lji.lji48,g_lji.lji18,
                   g_lji.lji19,g_lji.lji20,g_lji.lji21,g_lji.lji11,g_lji.lji12,
                   g_lji.lji13,g_lji.lji14,g_lji.lji141,g_lji.lji15,g_lji.lji151,
                   g_lji.lji16,g_lji.lji161,g_lji.lji06,g_lji.lji22,g_lji.lji23,
                   g_lji.lji24,g_lji.lji25,g_lji.lji26,g_lji.lji27,g_lji.lji28,
                   g_lji.lji29,g_lji.lji30,g_lji.lji31,g_lji.lji32,g_lji.lji33,
                   g_lji.lji34,g_lji.lji35,g_lji.lji36,g_lji.lji37,g_lji.lji43,
                   g_lji.ljiconf,g_lji.lji44,g_lji.lji45,g_lji.lji46,g_lji.lji47,
                   g_lji.lji42,g_lji.lji38,g_lji.lji381,g_lji.lji49,g_lji.lji50,
                   g_lji.lji51,g_lji.lji52,g_lji.lji53,g_lji.lji54,g_lji.lji39,
                   g_lji.lji40,g_lji.lji41,g_lji.ljiuser,g_lji.ljigrup,g_lji.ljioriu,
                   g_lji.ljimodu,g_lji.ljidate,g_lji.ljiorig,g_lji.ljiacti,
                   g_lji.ljicrat


   CALL t410_gen02(g_lji.lji44,'d')           #带出初审人名称
   CALL t410_gen02(g_lji.lji46,'d')           #带出终审人姓名
   CALL t410_gen02(g_lji.lji30,'d')           #带出业务人员姓名
   CALL t410_gem02('d')                       #带出部门及名称
   CALL t410_desc() 
   CALL t410_b1_fill(g_wc2)
   CALL t410_b2_fill(g_wc3)
   CALL t410_b3_fill(g_wc4)
   CALL t410_b4_fill(g_wc5)
   CALL t410_b5_fill(g_wc6)
   CALL t410_b6_fill(g_wc7)
   CALL cl_show_fld_cont()
   #CALL cl_set_field_pic(g_lji.ljiconf,"","","","","")  #CHI-C80041
   IF g_lji.ljiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lji.ljiconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION

FUNCTION t410_desc()
   CALL t410_lji07()
   CALL t410_ljiplant('d')                    #显示法人及名称 
   CALL t410_lji09_tqa02()                    #带出摊位用途名称
   CALL t410_oba02()                          #带出经营大、中、小类
   CALL t410_lji_tqa02(g_lji.lji38)           #主品牌
   CALL t410_lji_tqa02(g_lji.lji381)          #新主品牌
   CALL t410_bfa(g_lji.lji11,g_lji.lji12,g_lji.lji13,'1') #显示楼栋、楼层、区域名称
END FUNCTION 
  
FUNCTION t410_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lji.lji01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01
 
   #不可異動其他門店資料
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF
 
   IF NOT cl_null(g_lji.ljiconf) AND g_lji.ljiconf !='N' THEN
      CALL cl_err('','alm1366',0)
      RETURN
   END IF
   
   #合同變更單已變更發出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err(g_lji.lji01,'alm-328',0)
      RETURN
   END IF

   MESSAGE ''
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t410_show()
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL           
       LET g_doc.column1 = "lji01"          
       LET g_doc.value1  = g_lji.lji01           
       CALL cl_del_doc()  
       
      DELETE FROM lji_file WHERE lji01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lji_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete lji)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM ljj_file WHERE ljj01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljj_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljj)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM ljk_file WHERE ljk01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljk_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljk)",1)
         LET g_success='N'
      END IF 
      
      DELETE FROM ljl_file WHERE ljl01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljl_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljl)",1)
         LET g_success='N'
      END IF 
      
      DELETE FROM ljm_file WHERE ljm01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljm_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljm)",1)
         LET g_success='N'
      END IF  
      DELETE FROM ljn_file WHERE ljn01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljn_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljn)",1)
         LET g_success='N'
      END IF 
      
      DELETE FROM ljo_file WHERE ljo01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljo_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljo)",1)
         LET g_success='N'
      END IF   

      DELETE FROM ljp_file WHERE ljp01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljp_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljp)",1)
         LET g_success='N'
      END IF

      DELETE FROM ljq_file WHERE ljq01 = g_lji_t.lji01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljq_file",g_lji.lji01,"",SQLCA.SQLCODE,
                       "","(t410_r:delete ljq)",1)
         LET g_success='N'
      END IF

      INITIALIZE g_lji.* TO NULL
  
      IF g_success = 'Y' THEN    
         COMMIT WORK
         CLEAR FORM
         
         LET g_rec_b1 = NULL
         LET g_rec_b2 = NULL
         LET g_rec_b3 = NULL
         LET g_rec_b4 = NULL
         LET g_rec_b5 = NULL
         LET g_rec_b6 = NULL              
 
         CALL g_ljj.clear()
         CALL g_ljk.clear()
         CALL g_ljl.clear()
         CALL g_ljm.clear()
         CALL g_ljn.clear()
         CALL g_ljo.clear()
          
         OPEN t410_count
         IF STATUS THEN
            CLOSE t410_cs
            CLOSE t410_count
            COMMIT WORK
            RETURN
         END IF
      
         FETCH t410_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t410_cs
            CLOSE t410_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         
         OPEN t410_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t410_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t410_fetch('/')
         END IF
      ELSE  
         ROLLBACK WORK
         LET g_lji.* = g_lji_t.*
      END IF   
   END IF
 
   CLOSE t410_cl
   COMMIT WORK
   CALL t410_show()
END FUNCTION

#抓取费用标准单身的数据 
FUNCTION t410_b1_fill(p_wc2)
   DEFINE p_wc2,l_sql   STRING
   
   IF cl_null(p_wc2) THEN 
      LET p_wc2 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljj03,ljj04,'','',ljj05,ljj051,ljj06,ljj07,ljj08,ljj02",
               "  FROM ljj_file ", 
               " WHERE ljj01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY ljj03 "
 
   PREPARE t410_pb1 FROM l_sql
   DECLARE t410_cr1 CURSOR FOR t410_pb1
 
   CALL g_ljj.clear()
   LET g_cnt = 1
   LET g_flag ='1' 

   FOREACH t410_cr1 INTO g_ljj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       #带出标准费用单身费用名称和费用类型
       CALL t410_oaj(g_ljj[g_cnt].ljj04)
      
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljj.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp1_refresh()
END FUNCTION

#显示费用标准单身
FUNCTION t410_bp1_refresh()
   DISPLAY ARRAY g_ljj TO s_ljj.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b2_fill(p_wc3)
   DEFINE p_wc3,l_sql   STRING
   
   IF cl_null(p_wc3) THEN 
      LET p_wc3 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljk03,ljk04,'','',ljk05,ljk06,ljk07,ljk08,ljk02",
               "  FROM ljk_file ", 
               " WHERE ljk01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc3 CLIPPED,
               " ORDER BY ljk03 "
 
   PREPARE t410_pb2 FROM l_sql
   DECLARE t410_cr2 CURSOR FOR t410_pb2
 
   CALL g_ljk.clear()
   LET g_cnt = 1
   LET g_flag = '2'  

   FOREACH t410_cr2 INTO g_ljk[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #带出优惠费用单身费用名称和费用类型
       CALL t410_oaj(g_ljk[g_cnt].ljk04)    

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljk.deleteElement(g_cnt)
 
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp2_refresh()
END FUNCTION

FUNCTION t410_bp2_refresh()
   DISPLAY ARRAY g_ljk TO s_ljk.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b3_fill(p_wc4)
   DEFINE p_wc4,l_sql   STRING
   
   IF cl_null(p_wc4) THEN 
      LET p_wc4 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljl03,ljl04,'','',ljl05,ljl06,ljl07,ljl02",
               "  FROM ljl_file ", 
               " WHERE ljl01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc4 CLIPPED,
               " ORDER BY ljl03 "
 
   PREPARE t410_pb3 FROM l_sql
   DECLARE t410_cr3 CURSOR FOR t410_pb3
 
   CALL g_ljl.clear()
   LET g_cnt = 1
   LET g_flag = '3' 

   FOREACH t410_cr3 INTO g_ljl[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       #其他费用单身的费用名称和费用类型 
       CALL t410_oaj(g_ljl[g_cnt].ljl04)

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljl.deleteElement(g_cnt)
 
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp3_refresh()
END FUNCTION

FUNCTION t410_bp3_refresh()
   DISPLAY ARRAY g_ljl TO s_ljl.* ATTRIBUTE(COUNT = g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b4_fill(p_wc5)
   DEFINE p_wc5,l_sql   STRING
   
   IF cl_null(p_wc5) THEN 
      LET p_wc5 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljm03,ljm04,'','',ljm05,'',ljm06,ljm07,ljm08",
               "  FROM ljm_file ", 
               " WHERE ljm01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc5 CLIPPED,
               " ORDER BY ljm03 "
 
   PREPARE t410_pb4 FROM l_sql
   DECLARE t410_cr4 CURSOR FOR t410_pb4
 
   CALL g_ljm.clear()
   LET g_cnt = 1
   LET g_flag = '4'  

   FOREACH t410_cr4 INTO g_ljm[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       CALL t410_oaj(g_ljm[g_cnt].ljm04) #定义付款单身费用名称和费用类型       
       CALL t410_lnr()                   #带出付款方式名称
   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljm.deleteElement(g_cnt)
 
   LET g_rec_b4=g_cnt-1
   DISPLAY g_rec_b4 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp4_refresh()
END FUNCTION

FUNCTION t410_bp4_refresh()
   DISPLAY ARRAY g_ljm TO s_ljm.* ATTRIBUTE(COUNT = g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b5_fill(p_wc6)
   DEFINE p_wc6,l_sql   STRING
   
   IF cl_null(p_wc6) THEN 
      LET p_wc6 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljn03,ljn04,ljn08,ljn09,ljn10,ljn05,'',",
               "       ljn06,'',ljn07,'',ljn02",
               "  FROM ljn_file ", 
               " WHERE ljn01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc6 CLIPPED,
               " ORDER BY ljn03 "
 
   PREPARE t410_pb5 FROM l_sql
   DECLARE t410_cr5 CURSOR FOR t410_pb5
 
   CALL g_ljn.clear()
   LET g_cnt = 1
 
   FOREACH t410_cr5 INTO g_ljn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       #带出楼栋、楼层、区域名称
       CALL t410_bfa(g_ljn[g_cnt].ljn05,g_ljn[g_cnt].ljn06,
                     g_ljn[g_cnt].ljn07,'2')           

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljn.deleteElement(g_cnt)
 
   LET g_rec_b5=g_cnt-1
   DISPLAY g_rec_b5 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp5_refresh()
END FUNCTION

FUNCTION t410_bp5_refresh()
   DISPLAY ARRAY g_ljn TO s_ljn.* ATTRIBUTE(COUNT = g_rec_b5,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b6_fill(p_wc7)
   DEFINE p_wc7,l_sql   STRING
   
   IF cl_null(p_wc7) THEN 
      LET p_wc7 = ' 1=1' 
   END IF
   
   LET l_sql = "SELECT ljo03,ljo04,'',ljo02",
               "  FROM ljo_file ", 
               " WHERE ljo01 ='",g_lji.lji01,"' ",
               "   AND ",p_wc7 CLIPPED,
               " ORDER BY ljo03 "
 
   PREPARE t410_pb6 FROM l_sql
   DECLARE t410_cr6 CURSOR FOR t410_pb6
 
   CALL g_ljo.clear()
   LET g_cnt = 1
 
   FOREACH t410_cr6 INTO g_ljo[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        
       #带出其他品牌单身的品牌名称
       CALL t410_tqa02(g_ljo[g_cnt].ljo04)
                       RETURNING g_ljo[g_cnt].tqa02    

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ljo.deleteElement(g_cnt)
 
   LET g_rec_b6=g_cnt-1
   DISPLAY g_rec_b6 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t410_bp6_refresh()
END FUNCTION

FUNCTION t410_bp6_refresh()
   DISPLAY ARRAY g_ljo TO s_ljo.* ATTRIBUTE(COUNT = g_rec_b6,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t410_b6()
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_lock_sw       LIKE type_file.chr1
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE p_cmd           LIKE type_file.chr1,
          l_ac6_t         LIKE type_file.num5

   LET g_action_choice = ""

   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_lji.lji01) THEN 
      RETURN 
   END IF

   #合同变更单审核码为未审核才可以进入单身
   IF NOT cl_null(g_lji.ljiconf) AND g_lji.ljiconf !='N' THEN
      CALL cl_err('合同变更已有审批状态，不可异动','!',0)
      RETURN
   END IF

   #变更发出不可以进入单身
   IF g_lji.lji43 = '2' THEN 
      CALL cl_err('','alm-941',0)
      RETURN   
   END IF 
  
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01 = g_lji.lji01

   LET g_forupd_sql = " SELECT ljo03,ljo04,'',ljo02 ",
                       "  FROM ljo_file",
                       " WHERE ljo01 = '",g_lji.lji01,"'",
                       "   AND ljo03 = ? ",
                       "  FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t410_bc6 CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
  
   INPUT ARRAY g_ljo WITHOUT DEFAULTS FROM s_ljo.*
         ATTRIBUTE(COUNT=g_rec_b6,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
        BEFORE INPUT
           IF g_cnt != 0 THEN
              CALL fgl_set_arr_curr(l_ac6)
              LET l_ac6 = 1   
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac6 = ARR_CURR()
           LET g_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
           OPEN t410_cl USING g_lji.lji01
           IF STATUS THEN
              CALL cl_err("OPEN t410_cl:", STATUS, 1)
              CLOSE t410_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           FETCH t410_cl INTO g_lji.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
              CLOSE t410_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF g_rec_b6 >= l_ac6 THEN
              LET p_cmd='u'
              LET g_ljo_t.* = g_ljo[l_ac6].*
              
              OPEN t410_bc6 USING g_ljo_t.ljo03
              IF STATUS THEN
                 CALL cl_err("OPEN t410_bc6:", STATUS, 1)
                 LET g_lock_sw = "Y"
              END IF
              
              FETCH t410_bc6 INTO g_ljo[l_ac6].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ljo_t.ljo03,SQLCA.sqlcode,1)
                 LET g_lock_sw = "Y"
              END IF                            
               CALL t410_tqa02(g_ljo[l_ac6].ljo04)    #其他品牌单身的品牌名称
                      RETURNING g_ljo[l_ac6].tqa02
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ljo[l_ac6].* TO NULL
           LET g_ljo_t.* = g_ljo[l_ac6].*
           LET g_ljo[l_ac6].ljo02 = g_lji.lji05
           CALL cl_show_fld_cont()
           NEXT FIELD ljo03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              CANCEL INSERT
           END IF
           INSERT INTO ljo_file(ljo01,ljo02,ljo03,ljo04,ljolegal,ljoplant)
           VALUES(g_lji.lji01,g_ljo[l_ac6].ljo02,g_ljo[l_ac6].ljo03,
                  g_ljo[l_ac6].ljo04,g_lji.ljilegal,g_lji.ljiplant)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ljo_file",g_lji.lji01,g_ljo[l_ac6].ljo03,
                             SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b6 = g_rec_b6 + 1
              DISPLAY g_rec_b6 TO FORMONLY.cn2
           END IF

        BEFORE FIELD ljo03
           IF g_ljo[l_ac6].ljo03 IS NULL OR g_ljo[l_ac6].ljo03 = 0 THEN
              SELECT max(ljo03)
                INTO g_ljo[l_ac6].ljo03
                FROM ljo_file
               WHERE ljo01 = g_lji.lji01
              IF g_ljo[l_ac6].ljo03 IS NULL THEN
                 LET g_ljo[l_ac6].ljo03 = 1
              ELSE
                 LET g_ljo[l_ac6].ljo03 = g_ljo[l_ac6].ljo03+1
              END IF
           END IF 
 
        AFTER FIELD ljo03
           IF NOT cl_null(g_ljo[l_ac6].ljo03) THEN
              IF g_ljo[l_ac6].ljo03 < 1 THEN
                 CALL cl_err('','alm1127',0)
                 LET g_ljo[l_ac6].ljo03 = g_ljo_t.ljo03
                 NEXT FIELD ljo03 
              END IF
              IF (p_cmd='a') OR (p_cmd='u' AND
                  g_ljo[l_ac6].ljo03!=g_ljo_t.ljo03) THEN
                 SELECT count(*) INTO l_n
                   FROM ljo_file
                  WHERE ljo01 = g_lji.lji01
                    AND ljo03 = g_ljo[l_ac6].ljo03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ljo[l_ac6].ljo03 = g_ljo_t.ljo03
                    NEXT FIELD ljo03
                 END IF
              END IF
           END IF   

        AFTER FIELD ljo04
           IF NOT cl_null(g_ljo[l_ac6].ljo04) THEN
              IF g_ljo_t.ljo04 IS NULL OR 
                 (g_ljo_t.ljo04 != g_ljo[l_ac6].ljo04) THEN
                 CALL t410_tqa02(g_ljo[l_ac6].ljo04)          
                      RETURNING g_ljo[l_ac6].tqa02                

                 IF cl_null(g_ljo[l_ac6].tqa02) THEN
                    SELECT tqa02 INTO g_ljo[l_ac6].tqa02
                       FROM tqa_file 
                       WHERE tqa01 = g_ljo_t.ljo04
                 END IF       
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ljo[l_ac6].ljo04,g_errno,0)
                    LET g_ljo[l_ac6].ljo04 = g_ljo_t.ljo04
                    NEXT FIELD ljo04
                 END IF
                 SELECT COUNT(*) INTO l_n
                   FROM ljo_file
                  WHERE ljo01 = g_lji.lji01
                    AND ljo04 = g_ljo[l_ac6].ljo04
                 IF l_n > 0 THEN
                    CALL cl_err(g_ljo[l_ac6].ljo04,-239,0)
                    LET g_ljo[l_ac6].ljo04 = g_ljo_t.ljo04
                    NEXT FIELD ljo04
                 END IF
              END IF
           ELSE
              LET g_ljo[l_ac6].tqa02   = NULL                     
           END IF
        
        BEFORE DELETE         
           IF g_ljo_t.ljo04 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF g_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ljo_file
               WHERE ljo01 = g_lji.lji01
                 AND ljo03 = g_ljo_t.ljo03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ljo_file",g_lji.lji01,g_ljo_t.ljo03,
                               SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b6= g_rec_b6 - 1
              DISPLAY g_rec_b6 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              LET INT_FLAG = 0  
              CALL cl_err('',9001,0)
              LET g_ljo[l_ac6].* = g_ljo_t.*
              CLOSE t410_bc6
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_lock_sw = 'Y' THEN
              CALL cl_err(g_ljo[l_ac6].ljo03,-263,1)
              LET g_ljo[l_ac6].* = g_ljo_t.*
           ELSE
              UPDATE ljo_file 
                 SET ljo04 = g_ljo[l_ac6].ljo04,
                     ljo03 = g_ljo[l_ac6].ljo03,
                     ljo02 = g_ljo[l_ac6].ljo02
               WHERE ljo01 = g_lji.lji01
                 AND ljo03 = g_ljo_t.ljo03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ljo_file",g_lji.lji01,g_ljo_t.ljo03,
                              SQLCA.sqlcode,'','',1)
                 LET g_ljo[l_ac6].* = g_ljo_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac6 = ARR_CURR()
          #LET l_ac6_t = l_ac6     #FUN-D30033 Mark
           IF p_cmd = 'u' THEN 
              IF g_ljo[l_ac6].ljo04 <> g_ljo_t.ljo04 THEN 
                 LET g_ljo[l_ac6].ljo02 = g_lji.lji05
                 UPDATE ljo_file 
                    SET ljo02 = g_lji.lji05
                  WHERE ljo01 = g_lji.lji01
                    AND ljo03 = g_ljo[l_ac6].ljo03
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","ljo_file",g_lji.lji01,g_ljo_t.ljo03,
                                 SQLCA.sqlcode,'','',1)
                    LET g_ljo[l_ac6].ljo02 = g_ljo_t.ljo02
                    ROLLBACK WORK
                 END IF      
              END IF 
           END IF 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'a' THEN
                 CALL g_ljo.deleteElement(l_ac6)
                 #FUN-D30033--add--str--
                 IF g_rec_b6 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac6 = l_ac6_t
                 END IF
                 #FUN-D30033--add--end--
              END IF

              IF p_cmd = 'u' THEN
                 LET g_ljo[l_ac6].* = g_ljo_t.*
              END IF
              CLOSE t410_bc6
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac6_t = l_ac6     #FUN-D30033 Add
           CLOSE t410_bc6
           COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ljo04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa_2"               
                 LET g_qryparam.default1 = g_ljo[l_ac6].ljo04
                 CALL cl_create_qry() RETURNING g_ljo[l_ac6].ljo04
                 CALL t410_tqa02(g_ljo[l_ac6].ljo04)          
                      RETURNING g_ljo[l_ac6].tqa02               
                 DISPLAY BY NAME g_ljo[l_ac6].ljo04
                 DISPLAY BY NAME g_ljo[l_ac6].tqa02              
                 NEXT FIELD ljo04
           END CASE

        ON ACTION accept
         ACCEPT INPUT

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
   
   IF p_cmd = 'u' THEN
      LET g_lji.ljimodu = g_user
      LET g_lji.ljidate = g_today
      UPDATE lji_file SET ljimodu = g_lji.ljimodu,
                          ljidate = g_lji.ljidate
         WHERE lji01 = g_lji.lji01

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.SQLCODE,"","upd lji",1)
      END IF

      DISPLAY BY NAME g_lji.ljimodu,g_lji.ljidate
   END IF

   CLOSE t410_bc6
   CALL t410_delHeader()     #CHI-C30002 add
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t410_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b6 = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lji.lji01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lji_file ",
                  "  WHERE lji01 LIKE '",l_slip,"%' ",
                  "    AND lji01 > '",g_lji.lji01,"'"
      PREPARE t410_pb7 FROM l_sql 
      EXECUTE t410_pb7 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t410_v()
         IF g_lji.ljiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_lji.ljiconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM ljj_file WHERE ljj01 = g_lji_t.lji01
         DELETE FROM ljk_file WHERE ljk01 = g_lji_t.lji01
         DELETE FROM ljl_file WHERE ljl01 = g_lji_t.lji01
         DELETE FROM ljm_file WHERE ljm01 = g_lji_t.lji01
         DELETE FROM ljn_file WHERE ljn01 = g_lji_t.lji01
         DELETE FROM ljp_file WHERE ljp01 = g_lji_t.lji01
         DELETE FROM ljq_file WHERE ljq01 = g_lji_t.lji01
      #CHI-C80041---end  #CHI-C80041
      #IF cl_confirm("9042") THEN
         DELETE FROM lji_file WHERE lji01 = g_lji.lji01
         INITIALIZE g_lji.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#其他品牌单身的品牌名称
#p_ljo04品牌编号
FUNCTION t410_tqa02(p_ljo04)
   DEFINE p_ljo04   LIKE ljo_file.ljo04,
          l_tqa02   LIKE tqa_file.tqa02,
          l_tqa03   LIKE tqa_file.tqa03,
          l_tqaacti LIKE tqa_file.tqaacti,
          l_count   LIKE type_file.num5
 
   LET g_errno = ''

   SELECT COUNT(*) INTO l_count FROM tqa_file
    WHERE tqa01 =  p_ljo04
      AND tqa03 = '2'

   IF l_count < 1 THEN
       LET g_errno = 'alm1002'
       RETURN NULL
   ELSE
      SELECT tqa03,tqa02,tqaacti
        INTO l_tqa03,l_tqa02,l_tqaacti
        FROM tqa_file
       WHERE tqa01 = p_ljo04
         AND tqa03 = '2'
         AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file 
                     WHERE tqa03 = '2' AND tqa01 <> tqa07))
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 
                          FROM tqa_file WHERE tqa03 = '2')))

      CASE WHEN SQLCA.SQLCODE = 100  
              LET g_errno = 'alm1004'    
              LET l_tqa02= NULL
           WHEN l_tqaacti='N'        
              LET g_errno = '9028'
              LET l_tqa02= NULL          
           OTHERWISE                 
              LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      RETURN l_tqa02
   END IF
END FUNCTION
      
FUNCTION t410_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lji01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t410_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lji01",FALSE)
   END IF
END FUNCTION

#帶出場地單身 
FUNCTION t410_site()   
   DEFINE l_ljn         DYNAMIC ARRAY OF RECORD
             ljn01         LIKE ljn_file.ljn01,
             ljn02         LIKE ljn_file.ljn02,    # 合同版本
             ljn03         LIKE ljn_file.ljn03,    # 项次
             ljn04         LIKE ljn_file.ljn04,    # 场地编号
             ljn05         LIKE ljn_file.ljn05,    # 楼栋编号
             ljn06         LIKE ljn_file.ljn06,    # 楼层编号
             ljn07         LIKE ljn_file.ljn07,    # 区域编号
             ljn08         LIKE ljn_file.ljn08,    # 建筑面积
             ljn09         LIKE ljn_file.ljn09,    # 测量面积
             ljn10         LIKE ljn_file.ljn10,    # 经营面积
             ljnlegal      LIKE ljn_file.ljnlegal,
             ljnplant      LIKE ljn_file.ljnplant 

                        END RECORD

   DEFINE l_n,count1       LIKE type_file.num5
   DEFINE l_sql            STRING

   LET l_sql = "SELECT '',lnu02,lnu06,lnu03,lnu08,lnu09,lnu10,lnu05,",
               "       lnu07,lnu04,lnulegal,lnuplant",
               "  FROM lnu_file ",
               " WHERE lnu01 = '",g_lji.lji04,"'",
               "   AND lnuplant = '",g_lji.ljiplant,"'"

   PREPARE t410_ins_pre5 FROM l_sql
   DECLARE t410_ins_cs5 CURSOR FOR t410_ins_pre5 

   LET l_n = 1

   FOREACH t410_ins_cs5 INTO l_ljn[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljn[l_n].ljn01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljn.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljn_file
          VALUES l_ljn[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljn_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR  
   MESSAGE 'INSERT O.K'
END FUNCTION
 
#帶出費用標准單身
FUNCTION t410_fs()
   DEFINE l_ljj     DYNAMIC ARRAY OF RECORD
             ljj01     LIKE ljj_file.ljj01, 
             ljj02     LIKE ljj_file.ljj02,    # 合同版本
             ljj03     LIKE ljj_file.ljj03,    # 项次
             ljj04     LIKE ljj_file.ljj04,    # 费用编号
             ljj05     LIKE ljj_file.ljj05,    # 费用方案
             ljj051    LIKE ljj_file.ljj051,   # 费用方案版本号
             ljj06     LIKE ljj_file.ljj06,    # 开始日期
             ljj07     LIKE ljj_file.ljj07,    # 结束日期
             ljj08     LIKE ljj_file.ljj08,    # 费用标准
             ljjlegal  LIKE ljj_file.ljjlegal,
             ljjplant  LIKE ljj_file.ljjplant
                    END RECORD   

   DEFINE l_sql        STRING
   DEFINE l_n,count1  LIKE type_file.num5

   LET l_sql = "SELECT '',lnv02,lnv03,lnv04,lnv18,lnv181,lnv16,lnv17,lnv07,",
               "       lnvlegal,lnvplant ",
               "  FROM lnv_file ",
               " WHERE lnv01 = '",g_lji.lji04,"'",
               "   AND lnvplant = '",g_lji.ljiplant,"'"
               
   PREPARE t410_ins_pre1 FROM l_sql
   DECLARE t410_ins_cs1 CURSOR FOR t410_ins_pre1 

   LET l_n = 1

   FOREACH t410_ins_cs1 INTO l_ljj[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljj[l_n].ljj01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljj.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljj_file 
          VALUES l_ljj[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljj_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR 
   MESSAGE 'INSERT O.K'
END FUNCTION
 
#带出其他费用
FUNCTION t410_other_fare()
   DEFINE l_ljl         DYNAMIC ARRAY OF RECORD
             ljl01         LIKE ljl_file.ljl01,
             ljl02         LIKE ljl_file.ljl02,      # 合同版本
             ljl03         LIKE ljl_file.ljl03,      # 项次
             ljl04         LIKE ljl_file.ljl04,      # 费用编号 
             ljl05         LIKE ljl_file.ljl05,      # 开始日期   
             ljl06         LIKE ljl_file.ljl06,      # 结束日期
             ljl07         LIKE ljl_file.ljl07,      # 费用金额
             ljllegal      LIKE ljl_file.ljllegal,
             ljlplant      LIKE ljl_file.ljlplant
                        END RECORD

   DEFINE l_n,count1       LIKE type_file.num5
   DEFINE l_sql            STRING

   LET l_sql = "SELECT '',lnw02,lnw11,lnw03,lnw08,lnw09,lnw06,lnwlegal,lnwplant",
               "  FROM lnw_file ",
               " WHERE lnw01 = '",g_lji.lji04,"'",
               "   AND lnwplant = '",g_lji.ljiplant,"'"

   PREPARE t410_ins_pre3 FROM l_sql
   DECLARE t410_ins_cs3 CURSOR FOR t410_ins_pre3 

   LET l_n = 1

   FOREACH t410_ins_cs3 INTO l_ljl[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljl[l_n].ljl01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljl.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljl_file 
          VALUES l_ljl[count1].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljl_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR                 
   MESSAGE 'INSERT O.K'
END FUNCTION
 
#帶出優惠標準
FUNCTION t410_pre()
   DEFINE l_ljk         DYNAMIC ARRAY OF RECORD         
             ljk01         LIKE ljk_file.ljk01,
             ljk02         LIKE ljk_file.ljk02,     # 合同版本
             ljk03         LIKE ljk_file.ljk03,     # 项次 
             ljk04         LIKE ljk_file.ljk04,     # 费用编号  
             ljk05         LIKE ljk_file.ljk05,     # 优惠单号
             ljk06         LIKE ljk_file.ljk06,     # 优惠开始日期
             ljk07         LIKE ljk_file.ljk07,     # 优惠结束日期 
             ljk08         LIKE ljk_file.ljk08,     # 优惠金额 
             ljkplant      LIKE ljk_file.ljkplant,
             ljklegal      LIKE ljk_file.ljklegal
                        END RECORD

   DEFINE l_n,count1       LIKE type_file.num5
   DEFINE l_sql            STRING

   LET l_sql = "SELECT '',lit02,lit03,lit04,lit05,lit06,lit07,lit08,",
               "       litlegal,litplant",
               "  FROM lit_file ",
               " WHERE lit01 = '",g_lji.lji04,"'",
               "   AND litplant = '",g_lji.ljiplant,"'"

   PREPARE t410_ins_pre2 FROM l_sql
   DECLARE t410_ins_cs2 CURSOR FOR t410_ins_pre2 

   LET l_n = 1

   FOREACH t410_ins_cs2 INTO l_ljk[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljk[l_n].ljk01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljk.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljk_file
          VALUES l_ljk[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljk_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR             
   MESSAGE 'INSERT O.K'
END FUNCTION

#帶出定義付款單身
FUNCTION t410_define_pay()
   DEFINE l_ljm         DYNAMIC ARRAY OF RECORD
             ljm01         LIKE ljm_file.ljm01,
             ljm02         LIKE ljm_file.ljm02,     # 合同版本
             ljm03         LIKE ljm_file.ljm03,     # 项次
             ljm04         LIKE ljm_file.ljm04,     # 费用编号
             ljm05         LIKE ljm_file.ljm05,     # 付款方式
             ljm06         LIKE ljm_file.ljm06,     # 出帐期 
             ljm07         LIKE ljm_file.ljm07,     # 出帐日
             ljm08         LIKE ljm_file.ljm08,     # 核算制度
             ljmlegal      LIKE ljm_file.ljmlegal,
             ljmplant      LIKE ljm_file.ljmplant
                        END RECORD

   DEFINE l_n,count1       LIKE type_file.num5
   DEFINE l_sql            STRING

   LET l_sql = "SELECT '',liu02,liu03,liu04,liu05,liu06,liu07,liu08,",
               "       liulegal,liuplant",
               "  FROM liu_file ",
               " WHERE liu01 = '",g_lji.lji04,"'",
               "   AND liuplant = '",g_lji.ljiplant,"'"

   PREPARE t410_ins_pre4 FROM l_sql
   DECLARE t410_ins_cs4 CURSOR FOR t410_ins_pre4 

   LET l_n = 1

   FOREACH t410_ins_cs4 INTO l_ljm[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljm[l_n].ljm01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljm.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljm_file 
          VALUES l_ljm[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljm_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR   
   MESSAGE 'INSERT O.K'
END FUNCTION
 
FUNCTION t410_other_brand()  #其他品牌
   DEFINE l_ljo         DYNAMIC ARRAY OF RECORD
             ljo01           LIKE ljo_file.ljo01,
             ljo02         LIKE ljo_file.ljo02,     # 合同版本
             ljo03         LIKE ljo_file.ljo03,     # 项次    
             ljo04         LIKE ljo_file.ljo04,     # 品牌编号 
             ljolegal      LIKE ljo_file.ljolegal,
             ljoplant      LIKE ljo_file.ljoplant
                        END RECORD

   DEFINE l_n,count1       LIKE type_file.num5
   DEFINE l_sql            STRING

   LET l_sql = "SELECT '',lny02,lny04,lny03,lnylegal,lnyplant",
               "  FROM lny_file ",
               " WHERE lny01 = '",g_lji.lji04,"'",
               "   AND lnyplant = '",g_lji.ljiplant,"'"

   PREPARE t410_ins_pre6 FROM l_sql
   DECLARE t410_ins_cs6 CURSOR FOR t410_ins_pre6 

   LET l_n = 1

   FOREACH t410_ins_cs6 INTO l_ljo[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljo[l_n].ljo01 = g_lji.lji01
      LET l_n = l_n + 1
   END FOREACH   

    CALL l_ljo.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljo_file 
          VALUES l_ljo[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljo_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR
   MESSAGE 'INSERT O.K'
END FUNCTION

#带出合同原始日核算
FUNCTION t410_daccount()
   DEFINE l_liv       DYNAMIC ARRAY OF RECORD
             liv01       LIKE liv_file.liv01,
             liv02       LIKE liv_file.liv02,      # 合同版本号
             liv03       LIKE liv_file.liv03,      # 项次 
             liv04       LIKE liv_file.liv04,      # 分摊日期 
             liv05       LIKE liv_file.liv05,      # 费用编号
             liv06       LIKE liv_file.liv06,      # 费用金额
             liv07       LIKE liv_file.liv07,      # 参考单号
             liv071      LIKE liv_file.liv071,     # 参考单号版本号
             liv08       LIKE liv_file.liv08,      # 数据类型 1-标准，2-优惠，3-终止，4-抹零
             liv09       LIKE liv_file.liv09,      # 优惠类型 0-无，1-租金优惠，2-面积优惠，3-租期优惠，4-单价优惠
             livlegal    LIKE liv_file.livlegal,
             livplant    LIKE liv_file.livplant  

                      END RECORD
   DEFINE l_sql          STRING,
          l_n,count1     LIKE type_file.num5

   LET l_sql = " SELECT '',liv02,liv03,liv04,liv05,liv06,liv07,liv071,",
               "        liv08,liv09,livlegal,livplant ",
               "   FROM liv_file ",
               "  WHERE liv01 = '",g_lji.lji04,"'",
               "    AND livplant = '",g_lji.ljiplant,"'" 
   PREPARE t410_ins_pre7 FROM l_sql
   DECLARE t410_ins_cs7 CURSOR FOR t410_ins_pre7

   LET l_n = 1

   FOREACH t410_ins_cs7 INTO l_liv[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_liv[l_n].liv01 = g_lji.lji01
    
      LET l_n = l_n + 1
   END FOREACH    

   CALL l_liv.deleteElement(l_n)

    FOR count1= 1 TO l_n-1
       INSERT INTO ljp_file 
          VALUES l_liv[count1].* 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljp_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF            
   END FOR 
   MESSAGE 'INSERT O.K'
END FUNCTION

#带出原始账单
FUNCTION t410_bill()
   DEFINE l_ljq     RECORD LIKE ljq_file.*,
          l_sql            STRING 

   LET l_sql = " SELECT *",
               "   FROM liw_file ",
               "  WHERE liw01 = '",g_lji.lji04,"'"
   
   PREPARE t410_ins_pre8 FROM l_sql
   DECLARE t410_ins_cs8 CURSOR FOR t410_ins_pre8

   FOREACH t410_ins_cs8 INTO l_ljq.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_ljq.ljq01 = g_lji.lji01
      INSERT INTO ljq_file VALUES l_ljq.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ljq_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH 
END FUNCTION 

##带出原始账单
#FUNCTION t410_bill()
#   DEFINE l_liw       DYNAMIC ARRAY OF RECORD
#             liw01       LIKE liw_file.liw01,
#             liw02       LIKE liw_file.liw02, # 合同版本号
#             liw03       LIKE liw_file.liw03, # 项次
#             liw04       LIKE liw_file.liw04, # 费用编号
#             liw05       LIKE liw_file.liw05, # 帐期
#             liw06       LIKE liw_file.liw06, # 出帐日期
#             liw07       LIKE liw_file.liw07, # 账单起日
#             liw08       LIKE liw_file.liw08, # 帐单止日
#             liw09       LIKE liw_file.liw09, # 费用标准
#             liw10       LIKE liw_file.liw10, # 优惠金额
#             liw11       LIKE liw_file.liw11, # 终止结算额
#             liw12       LIKE liw_file.liw12, # 抹零金额
#             liw13       LIKE liw_file.liw13, # 实际应收
#             liw14       LIKE liw_file.liw14, # 已收金额
#             liw15       LIKE liw_file.liw15, # 清算金额
#             liw16       LIKE liw_file.liw16, # 费用单号
#             liw18       LIKE liw_file.liw18, # 费用单项次
#             liw17       LIKE liw_file.liw17, # 结案否
#             liwlegal    LIKE liw_file.liwlegal,
#             liwplant    LIKE liw_file.liwplant
#             
#                      END RECORD
#   DEFINE l_sql          STRING,
#          l_n,count1     LIKE type_file.num5
#
#   LET l_sql = " SELECT '',liw02,liw03,liw04,liw05,liw06,liw07,liw08,liw09,liw10,",
#               "        liw11,liw12,liw13,liw14,liw15,liw16,liw18,liw17,",
#               "        liwlegal,liwplant",
#               "   FROM liw_file ",
#               "  WHERE liw01 = '",g_lji.lji04,"'",
#               "    AND liwplant = '",g_lji.ljiplant,"'" 
#   PREPARE t410_ins_pre8 FROM l_sql
#   DECLARE t410_ins_cs8 CURSOR FOR t410_ins_pre8
#
#   LET l_n = 1
#
#   FOREACH t410_ins_cs8 INTO l_liw[l_n].*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#        
#      LET l_liw[l_n].liw01 = g_lji.lji01    
#
#      LET l_n = l_n + 1
#   END FOREACH    
#
#   CALL l_liw.deleteElement(l_n)
#
#    FOR count1= 1 TO l_n-1
#       INSERT INTO ljq_file 
#          VALUES l_liw[count1].* 
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","ljq_file",g_lji.lji01,"",SQLCA.SQLCODE,"","",1)
#         LET g_success = 'N'
#         RETURN 
#      END IF            
#   END FOR 
#   MESSAGE 'INSERT O.K'
#END FUNCTION

#初审拒绝 
FUNCTION t410_deny1()  
   DEFINE l_lnt26    LIKE lnt_file.lnt26
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01

   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #合同已初审
   IF g_lji.ljiconf = 'F' THEN
      CALL cl_err(g_lji.lji01,'alm1159',0) 
      RETURN
   END IF
 
   #合同变更已终审
   IF g_lji.ljiconf = 'Y' THEN
      CALL cl_err(g_lji.lji01,'alm1160',0)  
      RETURN
   END IF

   #合同变更初审拒绝
   IF g_lji.ljiconf = 'A' THEN
      CALL cl_err(g_lji.lji01,'alm1161',0)  
      RETURN
   END IF

   #合同变更终审拒绝
   IF g_lji.ljiconf = 'B' THEN
      CALL cl_err(g_lji.lji01,'alm1162',0) 
      RETURN
   END IF
   
   SELECT lnt26 INTO l_lnt26 
     FROM lnt_file
    WHERE lnt01 =g_lji.lji04

   #合同终止
   IF l_lnt26 = 'S' THEN
      CALL cl_err(g_lji.lji01,'alm-300',0)
      RETURN
   END IF
   
   #合同到期
   IF l_lnt26 = 'E' THEN
      CALL cl_err(g_lji.lji01,'alm-483',0)
      RETURN
   END IF
   
   #合同变更已变更发出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err(g_lji.lji01,'alm1163',0)
     RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t410_show()

   IF cl_confirm('alm-591') THEN  #是否确定初审拒绝 (Y/N)?
     #TQC-C20528 Mark&Add Begin ---
     #UPDATE lji_file 
     #   SET ljiconf = 'N',
     #       lji43   = '1',
     #       lji44   = NULL,
     #       lji45   = NULL
     # WHERE lji01=g_lji.lji01
      UPDATE lji_file 
         SET ljiconf = 'A',
             lji43   = '1',
             lji44   = g_user,
             lji45   = g_today
       WHERE lji01=g_lji.lji01
     #TQC-C20528 Mark&Add End -----
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF

   SELECT * INTO g_lji.* FROM lji_file WHERE lji01=g_lji.lji01 #TQC-C20528 Add
 
   CLOSE t410_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lji.lji01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   CALL t410_gen02(g_lji.lji44,'d') #TQC-C20528 Add
   CALL t410_status()
END FUNCTION

#初审通过 
FUNCTION t410_confirm()
   DEFINE l_lnt26     LIKE lnt_file.lnt26,
          l_lji44     LIKE lji_file.lji44,
          l_sum_ljq13 LIKE ljq_file.ljq13
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ''
   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01
 
   #不可异动其他门店资料
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #合同变更已初审
   IF g_lji.ljiconf = 'F' THEN
      CALL cl_err(g_lji.lji01,'alm1159',0)  
      RETURN
   END IF
   
   #合同变更已终审
   IF g_lji.ljiconf = 'Y' THEN
      CALL cl_err(g_lji.lji01,'alm1160',0)  #合同已終審,不可異動
      RETURN
   END IF

   #合同变更初审拒绝
  #IF g_lji.ljiconf = 'F' THEN #TQC-C20528 Mark
   IF g_lji.ljiconf = 'A' THEN #TQC-C20528 Add
      CALL cl_err(g_lji.lji01,'alm1161',0)  #合同已初审拒絕,不可異動
      RETURN
   END IF

   #合同变更终审拒绝
   IF g_lji.ljiconf = 'B' THEN
      CALL cl_err(g_lji.lji01,'alm1162',0)  #合同已終審拒絕,不可異動
      RETURN
   END IF
   
   SELECT lnt26 INTO l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04
    
   #合同终止
   IF l_lnt26 = 'S' THEN
      CALL cl_err(g_lji.lji01,'alm-300',0)
      RETURN
   END IF
   
   #合同到期
   IF l_lnt26 = 'E' THEN
      CALL cl_err(g_lji.lji01,'alm-483',0)
      RETURN
   END IF
   
   #合同变更已变更发出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err(g_lji.lji01,'alm1163',0)
      RETURN
   END IF

   SELECT SUM(ljq13) INTO l_sum_ljq13
     FROM ljq_file
    WHERE ljq01 = g_lji.lji01

   IF cl_null(l_sum_ljq13) THEN
      LET l_sum_ljq13 = 0
   END IF 

   IF l_sum_ljq13 <> g_lji.lji37 THEN 
      CALL cl_err('','alm1226',0)
      RETURN 
   END IF 

   IF NOT cl_confirm('alm-583') THEN
      RETURN
   END IF
   IF g_lji.lji02 <> '2' THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM ljq_file
       WHERE ljq01 = g_lji.lji01
         AND ljq02 = g_lji.lji05
      IF g_cnt = 0 THEN
         IF NOT cl_confirm('alm1381') THEN
            RETURN
         END IF
      END IF
   END IF

   BEGIN WORK
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t410_show()
 
   LET l_lji44 = g_lji.lji44
   UPDATE lji_file 
      SET ljiconf = 'F',
         #lji43   = '0', #TQC-C20528 Mark
          lji43   = '1', #TQC-C20528 Add
          lji44   = g_user,
          lji45   = g_today
    WHERE lji01=g_lji.lji01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
 
   CLOSE t410_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lji.lji44 = g_user
      CALL cl_flow_notify(g_lji.lji01,'V')
   ELSE
      LET g_lji.lji44 = l_lji44
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_lji.lji44
   CALL t410_gen02(g_lji.lji44,'d')
   CALL t410_status()
END FUNCTION

#终审拒绝 
FUNCTION t410_deny2()  
   DEFINE l_lnt26    LIKE lnt_file.lnt26
  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ''

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01
    
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #合同变更未初审，不可终审拒绝
   IF g_lji.ljiconf = 'N' THEN
      CALL cl_err(g_lji.lji01,'alm1164',0)  
      RETURN
   END IF
   
   #合同变更已终审，不可终审拒绝
   IF g_lji.ljiconf = 'Y' THEN
      CALL cl_err(g_lji.lji01,'alm1160',0)
      RETURN
   END IF

   #合同变更已终审拒绝，不可再终审拒绝
   IF g_lji.ljiconf = 'B' THEN
      CALL cl_err(g_lji.lji01,'alm1162',0)  
      RETURN
   END IF

   #合同变更出生拒绝，不可终审拒绝
   IF g_lji.ljiconf = 'A' THEN
      CALL cl_err(g_lji.lji01,'alm1161',0)  
      RETURN
   END IF
   
   SELECT lnt26  INTO l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04
    
   #合同终止
   IF l_lnt26 = 'S' THEN
      CALL cl_err(g_lji.lji01,'alm-300',0)
      RETURN
   END IF
   
   #合同到期
   IF l_lnt26 = 'E' THEN
      CALL cl_err(g_lji.lji01,'alm-483',0)
      RETURN
   END IF
   
   #合同变更已变更发出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err(g_lji.lji01,'alm1163',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t410_show()
 
   IF cl_confirm('alm-592') THEN   #是否确定终审拒绝 (Y/N)?
     #TQC-C20528 Mark&Add Begin ---
     #UPDATE lji_file 
     #   SET ljiconf = 'N',
     #       lji43   = '3',
     #       lji44   = '',
     #       lji45   = '',
     #       lji46   = '',
     #       lji47   = ''
     # WHERE lji01=g_lji.lji01

      UPDATE lji_file 
         SET ljiconf = 'B',
             lji46   = g_user,
             lji47   = g_today
       WHERE lji01=g_lji.lji01
     #TQC-C20528 Mark&Add End -----
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file WHERE lji01=g_lji.lji01 #TQC-C20528 Add

   CLOSE t410_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lji.lji01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   CALL t410_gen02(g_lji.lji46,'d') #TQC-C20528 Add
   CALL t410_status()
END FUNCTION
 
#终审通过
FUNCTION t410_confirm2()
   DEFINE l_lji46    LIKE lji_file.lji46
   DEFINE l_lnt26    LIKE lnt_file.lnt26
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ''

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file
    WHERE lji01=g_lji.lji01

   #不可异动其他门店资料
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err(g_lji.ljiplant,'alm-399',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #合同变更未初审，不可终审
   IF g_lji.ljiconf = 'N' THEN
      CALL cl_err(g_lji.lji01,'alm1165',0)  
      RETURN
   END IF
   
   #合同变更已终审，不可再终审
   IF g_lji.ljiconf = 'Y' THEN
      CALL cl_err(g_lji.lji01,'alm1160',0)
      RETURN
   END IF

   #合同变更已初审拒绝，不可终审
   IF g_lji.ljiconf = 'A' THEN
      CALL cl_err(g_lji.lji01,'alm1161',0)
      RETURN
   END IF

   #合同变更已终审拒绝，不可终审
   IF g_lji.ljiconf = 'B' THEN
      CALL cl_err(g_lji.lji01,'alm1162',0)
      RETURN
   END IF
   
   SELECT lnt26 INTO l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04
    
   #合同终止
   IF l_lnt26 = 'S' THEN
      CALL cl_err(g_lji.lji01,'alm-300',0)
      RETURN
   END IF

   #合同到期
   IF l_lnt26 = 'E' THEN
      CALL cl_err(g_lji.lji01,'alm-483',0)
      RETURN
   END IF
   
   #合同变更已变更发出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err(g_lji.lji01,'alm1163',0)
      RETURN
   END IF

   BEGIN WORK
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t410_show()
 
   LET l_lji46 = g_lji.lji46

   IF cl_confirm('alm-587') THEN
      UPDATE lji_file 
         SET ljiconf = 'Y',
             lji43   = '1',
             lji46   = g_user,   
             lji47   = g_today  
       WHERE lji01=g_lji.lji01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   CLOSE t410_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lji.lji46 = g_user
      CALL cl_flow_notify(g_lji.lji01,'V')
   ELSE
      LET g_lji.lji46 = l_lji46
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_lji.lji46
   CALL t410_gen02(g_lji.lji46,'d')
   CALL t410_status()
END FUNCTION

#取消初审
FUNCTION t410_unconfirm1()
   DEFINE l_n        LIKE type_file.num5,
          l_ljiconf  LIKE lji_file.ljiconf,
          l_lji43    LIKE lji_file.lji43,
          l_lji44    LIKE lji_file.lji44,
          l_lji45    LIKE lji_file.lji45

   IF s_shut(0) THEN
      RETURN 
   END IF    

   MESSAGE ''
   IF g_lji.lji01 IS NULL OR g_lji.ljiplant IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF 

   SELECT * INTO g_lji.*
     FROM lji_file
    WHERE lji01 = g_lji.lji01

   LET l_ljiconf = g_lji.ljiconf 
   LET l_lji43   = g_lji.lji43
   LET l_lji44 = g_lji.lji44
   LET l_lji45 = g_lji.lji45
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #未审核不可以取消初审
   IF g_lji.ljiconf = 'N' THEN 
      CALL cl_err('','alm1168',0)
      RETURN
   END IF 

   #初审拒绝不可以取消初审
   IF g_lji.ljiconf = 'A' THEN
      CALL cl_err('','alm1161',0)
      RETURN 
   END IF 

   #终审拒绝不可以取消初审
   IF g_lji.ljiconf = 'B' THEN 
      CALL cl_err('','alm1162',0)
      RETURN
   END IF 

   #终审通过不可以取消初审
   IF g_lji.ljiconf = 'Y' THEN 
      CALL cl_err('','alm1311',0)
      RETURN
   END IF 
   

   #变更发出不可以取消审核
   IF g_lji.lji43 = '2' THEN
      CALL cl_err('','alm1163',0)
      RETURN 
   END IF 

   LET g_success = 'Y'

   BEGIN WORK 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("open t410_cl:",STATUS,1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm('alm-585') THEN
      RETURN
   ELSE
      LET g_lji.lji43 = '0'
      LET g_lji.ljiconf = 'N'
      LET g_lji.ljimodu = g_user
      LET g_lji.ljidate = g_today
  #   LET g_lji.lji44 = ''       #CHI-D20015 mark
  #   LET g_lji.lji45 = ''       #CHI-D20015 mark
      LET g_lji.lji44 = g_user   #CHI-D20015 add
      LET g_lji.lji45 = g_today  #CHI-D20015 add
 
      UPDATE lji_file
         SET ljiconf = g_lji.ljiconf,
             ljimodu = g_lji.ljimodu ,
             ljidate = g_lji.ljidate,
             lji43 = g_lji.lji43,
        #     lji44 = '',       #CHI-D20015 mark
        #     lji45 = ''        #CHI-D20015 mark
             lji44 = g_user,    #CHI-D20015 add
             lji45 = g_today    #CHI-D20015 add
       WHERE lji01 = g_lji.lji01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd lji:',SQLCA.sqlcode,0)
         LET g_lji.lji43   = l_lji43
         LET g_lji.ljiconf = l_ljiconf
         LET g_lji.lji44 = l_lji44
         LET g_lji.lji45 = l_lji45 
         DISPLAY BY NAME g_lji.ljiconf,g_lji.lji43,g_lji.lji44,g_lji.lji45
         CALL t410_gen02(g_lji.lji44,'d')     #CHI-D20015 add
         RETURN
      ELSE
         DISPLAY BY NAME g_lji.ljiconf ,g_lji.lji43,g_lji.ljimodu,
                         g_lji.ljidate,g_lji.lji44,g_lji.lji45
      #   DISPLAY '' TO FORMONLY.gen02      #CHI-D20015 mark
         CALL t410_gen02(g_lji.lji44,'d')     #CHI-D20015 add
         CALL cl_set_field_pic(g_lji.ljiconf,"","","","","")
      END IF   
   END IF 
   CLOSE t410_cl
   COMMIT WORK
END FUNCTION 

#取消终审
FUNCTION t410_unconfirm2()
   DEFINE l_n        LIKE type_file.num5,
          l_ljiconf  LIKE lji_file.ljiconf,
          l_lji43    LIKE lji_file.lji43,
          l_lji46    LIKE lji_file.lji46,
          l_lji47    LIKE lji_file.lji47

   IF s_shut(0) THEN
      RETURN 
   END IF    

   MESSAGE ''

   IF g_lji.lji01 IS NULL OR g_lji.ljiplant IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF 

   SELECT * INTO g_lji.*
     FROM lji_file
    WHERE lji01 = g_lji.lji01

   LET l_ljiconf = g_lji.ljiconf 
   LET l_lji43   = g_lji.lji43
   LET l_lji46 = g_lji.lji46
   LET l_lji47 = g_lji.lji47
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #未终审不可以取消终审
   IF g_lji.ljiconf <> 'Y' THEN
      CALL cl_err('','alm1312',0)
      RETURN 
   END IF
   
   #变更发出不可以取消审核
   IF g_lji.lji43 = '2' THEN
      CALL cl_err('','alm1163',0)
      RETURN 
   END IF 

   IF g_lji.lji05 = '0' THEN 
      CALL cl_err('','alm-743',0)
      RETURN
   END IF 

   LET g_success = 'Y'

   BEGIN WORK 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("open t410_cl:",STATUS,1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

 #  IF NOT cl_confirm('clm-323') THEN  #FUN-BC0082 mark
    IF NOT cl_confirm('alm1580') THEN  #FUN-BC0082 add
      RETURN
   ELSE
      LET g_lji.lji43 = '1'
      LET g_lji.ljiconf = 'F'
      LET g_lji.ljimodu = g_user
      LET g_lji.ljidate = g_today
  #   LET g_lji.lji46 = NULL     #CHI-D20015 mark
  #   LET g_lji.lji47 = NULL     #CHI-D20015 mark
      LET g_lji.lji46 = g_user   #CHI-D20015 add
      LET g_lji.lji47 = g_today  #CHI-D20015 add
 
      UPDATE lji_file
         SET ljiconf = g_lji.ljiconf,
             ljimodu = g_lji.ljimodu ,
             ljidate = g_lji.ljidate,
             lji43 = g_lji.lji43,
        #    lji46 = '',      #CHI-D20015 mark
        #    lji47 = ''       #CHI-D20015 mark
             lji46 = g_user,  #CHI-D20015 add
             lji47 = g_today  #CHI-D20015 add
       WHERE lji01 = g_lji.lji01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd lji:',SQLCA.sqlcode,0)
         LET g_lji.lji43   = l_lji43
         LET g_lji.ljiconf = l_ljiconf
         LET g_lji.lji46 = l_lji46
         LET g_lji.lji47 = l_lji47
         DISPLAY BY NAME g_lji.ljiconf,g_lji.lji43,g_lji.lji46,g_lji.lji47
         CALL t410_gen02(g_lji.lji46,'d')     #CHI-D20015 add
         RETURN
      ELSE
         DISPLAY BY NAME g_lji.ljiconf ,g_lji.lji43,g_lji.ljimodu,
                         g_lji.ljidate,g_lji.lji46,g_lji.lji47
      #  DISPLAY '' TO FORMONLY.gen02_1       #CHI-D20015 mark
         CALL t410_gen02(g_lji.lji46,'d')     #CHI-D20015 add
         CALL cl_set_field_pic(g_lji.ljiconf,"","","","","")
      END IF   
   END IF 
   CLOSE t410_cl
   COMMIT WORK
END FUNCTION 

#Modify By shi ------
#产生账单
FUNCTION t410_generate_bills()

   IF s_shut(0) THEN RETURN END IF

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_lji.* FROM lji_file WHERE lji01 = g_lji.lji01
   #如果变更类型是辅助变更申请，不用产生账单
   IF g_lji.lji02 = '2' THEN
      CALL cl_err(g_lji.lji01,'',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #如果初审或者终审不可产生账单
   IF g_lji.ljiconf <> 'N' THEN
      CALL cl_err(g_lji.lji01,'alm1198',0)
      RETURN
   END IF
   
   LET g_cnt = 0
   SELECT COUNT(*)  INTO g_cnt
     FROM ljq_file 
    WHERE ljq01 = g_lji.lji01
      AND ljq02 = g_lji.lji05

   IF g_cnt >0 THEN 
      IF NOT cl_confirm('alm1225') THEN
         RETURN 
      END IF 
   END IF 
   CALL i400sub_generate_bill(g_lji.lji01,'2')  #产生账单  
   CALL t410_upd()
END FUNCTION 
#Modify By shi ------

#账单查询
FUNCTION t410_qry_bill()
   DEFINE l_ljq09_c        LIKE ljq_file.ljq09,  #标准费用
          l_ljq10_c        LIKE ljq_file.ljq10,  #优惠费用
          l_ljq11_c        LIKE ljq_file.ljq11,  #终止费用
          l_ljq12_c        LIKE ljq_file.ljq12,  #抹零金额
          l_ljq13_c        LIKE ljq_file.ljq13,  #实际应收
          l_ljq14_c        LIKE ljq_file.ljq14,  #已收金额
          l_ljq14_desc_c   LIKE ljq_file.ljq14,  #未收金额
          l_ljq15_c        LIKE ljq_file.ljq15   #清算金额
          
   DEFINE l_cnt            LIKE type_file.num5,
          l_ljq05          LIKE ljq_file.ljq05,
          l_ljq05_s        STRING  
   DEFINE l_sql            STRING,
          l_msg            STRING,
          l_msg1           STRING 

   OPEN WINDOW t4101_w WITH FORM "alm/42f/almt4101"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almt4101")
   CALL cl_set_comp_visible("ljq18",FALSE)
   
   IF cl_null(g_lji.lji01) THEN 
      RETURN 
   END IF  

   LET l_sql = " SELECT ljq03,ljq04,'','',ljq06,ljq07,ljq08,ljq09,ljq10,ljq11,",
               "        ljq12,ljq13,ljq14,'',ljq15,ljq16,ljq18,ljq17,ljq02",
               "   FROM ljq_file",
               "  WHERE ljq01 = '",g_lji.lji01,"'",
               "   ORDER BY ljq04,ljq05,ljq06 "    
   DECLARE t410_ljq_curs CURSOR FROM l_sql 

   IF SQLCA.sqlcode THEN
      CALL cl_err('declare t410_ljq_curs',SQLCA.sqlcode,1)
      RETURN
   END IF  

   CALL g_ljq.clear()
   LET l_cnt = 1
   LET l_ljq09_c = 0 
   LET l_ljq10_c = 0 
   LET l_ljq11_c = 0 
   LET l_ljq12_c = 0 
   LET l_ljq13_c = 0 
   LET l_ljq14_c = 0 
   LET l_ljq15_c = 0 
   LET l_ljq14_desc_c = 0 
   
   FOREACH t410_ljq_curs INTO g_ljq[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t410_ljq_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT oaj02 INTO g_ljq[l_cnt].oaj02
        FROM oaj_file
       WHERE oaj01 = g_ljq[l_cnt].ljq04 

      SELECT ljq05 INTO l_ljq05 
        FROM ljq_file
       WHERE ljq01 = g_lji.lji01
         AND ljq03 = g_ljq[l_cnt].ljq03
      
      CALL cl_getmsg('alm1188',g_lang) RETURNING l_msg
      CALL cl_getmsg('alm1189',g_lang) RETURNING l_msg1         

      LET l_ljq05_s = l_ljq05 
      LET g_ljq[l_cnt].ljq05_desc = l_msg,l_ljq05_s.trim(),l_msg1 
      LET g_ljq[l_cnt].ljq14_desc = g_ljq[l_cnt].ljq13 - g_ljq[l_cnt].ljq14
      LET l_ljq09_c = l_ljq09_c + g_ljq[l_cnt].ljq09
      LET l_ljq10_c = l_ljq10_c + g_ljq[l_cnt].ljq10
      LET l_ljq11_c = l_ljq11_c + g_ljq[l_cnt].ljq11
      LET l_ljq12_c = l_ljq12_c + g_ljq[l_cnt].ljq12
      LET l_ljq13_c = l_ljq13_c + g_ljq[l_cnt].ljq13
      LET l_ljq14_c = l_ljq14_c + g_ljq[l_cnt].ljq14
      LET l_ljq15_c = l_ljq15_c + g_ljq[l_cnt].ljq15
      LET l_ljq14_desc_c = l_ljq14_desc_c + g_ljq[l_cnt].ljq14_desc
      LET l_cnt = l_cnt + 1

      IF l_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF

   END FOREACH 

   CALL g_ljq.deleteElement(l_cnt)
   LET g_rec_b7 = l_cnt - 1
 
   DISPLAY g_rec_b7 TO FORMONLY.cn2
   DISPLAY l_ljq09_c TO FORMONLY.ljq09_c
   DISPLAY l_ljq10_c TO FORMONLY.ljq10_c
   DISPLAY l_ljq11_c TO FORMONLY.ljq11_c
   DISPLAY l_ljq12_c TO FORMONLY.ljq12_c 
   DISPLAY l_ljq13_c TO FORMONLY.ljq13_c
   DISPLAY l_ljq14_c TO FORMONLY.ljq14_c
   DISPLAY l_ljq15_c TO FORMONLY.ljq15_c
   DISPLAY l_ljq14_desc_c TO FORMONLY.ljq14_desc_c

   CALL t4101_qry_menu() 
   
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t4101_w
      CALL cl_err('',9001,0)
      LET g_action_choice = NULL 
      RETURN
   END IF   
    
   CLOSE WINDOW t4101_w
END FUNCTION 

#账单查询FORM的menu
FUNCTION t4101_qry_menu()
   WHILE TRUE
      CALL t4101_bp("G")
      CASE g_action_choice
         #合同变更日核算
         WHEN "contract"
            IF l_ac7 > 0 THEN
               CALL t410_contract()
            ELSE
               CALL cl_err('',-400,1)
            END IF

         #费单查询
         WHEN "cost"
            IF l_ac7 > 0 THEN
               LET g_msg = " artt610 '1' '",g_ljq[l_ac7].ljq16,"' "
               CALL cl_cmdrun_wait(g_msg)
            ELSE
               CALL cl_err('',-400,1)
            END IF

         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

#账单查询FORM的bp
FUNCTION t4101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ljq TO s_ljq.* ATTRIBUTE(COUNT=g_rec_b7)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count)

      BEFORE ROW
        LET l_ac7 = ARR_CURR()
        CALL cl_show_fld_cont()

      #合同变更单日核算
      ON ACTION ontract
         LET g_action_choice="contract"
         EXIT DISPLAY

      #费用单查询
      ON ACTION cost
         LET g_action_choice="cost"
         EXIT DISPLAY

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         LET INT_FLAG = 0
         EXIT DISPLAY

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

#合同变更日核算查询
FUNCTION t410_contract()
   DEFINE l_ljp06_c        LIKE ljp_file.ljp06,
          l_cnt            LIKE type_file.num5
   DEFINE l_sql            STRING        

   OPEN WINDOW t4102_w WITH FORM "alm/42f/almt4102"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almt4102")

   LET l_sql = "SELECT ljp03,ljp04,ljp05,'',ljp06,ljp07,ljp071,ljp08,ljp09,ljp02",
               "  FROM ljp_file",
               " WHERE ljp01 = '",g_lji.lji01,"'",
               "   AND ljp05 = '",g_ljq[l_ac7].ljq04,"'",
               "   AND ljp02 = '",g_ljq[l_ac7].ljq02,"'",
               "   AND ljp04 BETWEEN '",g_ljq[l_ac7].ljq07,"'",
               "                 AND '",g_ljq[l_ac7].ljq08,"'"

   DECLARE t410_ljp_curs CURSOR FROM l_sql 

   LET l_cnt = 1
   LET l_ljp06_c = 0
   CALL g_ljp.clear()

   FOREACH t410_ljp_curs INTO g_ljp[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t410_ljp_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT oaj02 INTO g_ljp[l_cnt].oaj02
        FROM oaj_file
       WHERE oaj01 = g_ljp[l_cnt].ljp05 

      LET l_ljp06_c = l_ljp06_c + g_ljp[l_cnt].ljp06
      LET l_cnt = l_cnt + 1 
   END FOREACH 

   CALL g_ljp.deleteElement(l_cnt)
   LET g_rec_b8 = l_cnt - 1
   DISPLAY g_rec_b8 TO FORMONLY.cn2
   DISPLAY l_ljp06_c TO FORMONLY.ljp06_c
   CALL t4102_menu()
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t4102_w
      CALL cl_err('',9001,0)
      LET g_action_choice = NULL
      RETURN
   END IF  

   CLOSE WINDOW t4102_w   
END FUNCTION 

#日核算查询FORM的menu
FUNCTION t4102_menu()
   WHILE TRUE
      CALL t4102_bp("G")
      CASE g_action_choice
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE

END FUNCTION

#日和算查询的bp
FUNCTION t4102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ljp TO s_ljp.* ATTRIBUTE(COUNT=g_rec_b8)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count)

      BEFORE ROW
        LET l_ac8 = ARR_CURR()
        CALL cl_show_fld_cont()

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         LET INT_FLAG = 0
         EXIT DISPLAY

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#变更发出
FUNCTION t410_post()
 DEFINE l_n         LIKE type_file.num5
 DEFINE l_liw01     LIKE liw_file.liw01
 DEFINE l_liw05     LIKE liw_file.liw05
 DEFINE l_liw06     LIKE liw_file.liw06
 DEFINE l_lntpos    LIKE lnt_file.lntpos        #FUN-C50036 add 

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lji.*
     FROM lji_file
    WHERE lji01 = g_lji.lji01

   #当前营运中心不是对应的营运中心不可以变更发出
   IF g_lji.ljiplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #合同变更没有终审通过不可以变更发出
   IF g_lji.ljiconf <> 'Y' THEN
      CALL cl_err ('','alm1166',0)
      RETURN
   END IF 

   #变更发出过了不可以再次变更发出
   IF g_lji.lji43 = '2' THEN
      CALL cl_err ('','alm1163',0)
      RETURN
   END IF 

   IF g_lji.lji05 = '0' THEN
      CALL cl_err('','alm-956',0)
      RETURN 
   END IF  

   #检查合同是否到期，到期不可以变更发出
   CALL t410_lji04_check('2')

   IF g_lji.lji02 = '3' THEN
      SELECT count(lih01) INTO l_n
        FROM lih_file
       WHERE lih07 = g_lji.lji08
         AND lihconf = 'Y'
         AND ((lih14 BETWEEN g_lji.lji23+1 AND g_lji.lji27)
              OR (lih15 BETWEEN g_lji.lji23+1 AND g_lji.lji27)
              OR (lih14 <= g_lji.lji23+1 AND lih15 >= g_lji.lji27))


      IF l_n > 0 THEN
         CALL cl_err('','alm1036',0)
         RETURN
      ELSE
         SELECT COUNT(lnt01) INTO l_n
           FROM lnt_file
          WHERE lnt06 = g_lji.lji08 
            AND lnt26 = 'Y'
            AND ((lnt17 BETWEEN g_lji.lji23+1 AND g_lji.lji27)
                 OR (lnt18 BETWEEN g_lji.lji23+1 AND g_lji.lji27)
                 OR (lnt17 <= g_lji.lji23+1 AND lnt18 >= g_lji.lji27))

         IF l_n >0 THEN
            CALL cl_err('','alm-317',0)
            RETURN
         END IF   
      END IF
   END IF

   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF  

  #By shi 重新整理
   DROP TABLE ljj_temp
   DROP TABLE ljk_temp
   DROP TABLE ljl_temp
   DROP TABLE ljn_temp
   DROP TABLE liw_temp
   SELECT * FROM ljj_file WHERE 1=0 INTO TEMP ljj_temp
   SELECT * FROM ljk_file WHERE 1=0 INTO TEMP ljk_temp
   SELECT * FROM ljl_file WHERE 1=0 INTO TEMP ljl_temp
   SELECT * FROM ljn_file WHERE 1=0 INTO TEMP ljn_temp
   SELECT * FROM liw_file WHERE 1=0 INTO TEMP liw_temp

   IF NOT cl_confirm('art-859') THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()

   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   #修改状态码为 2:变更发出
   UPDATE lji_file
      SET lji43 = '2'
    WHERE lji01 = g_lji.lji01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('lji01',g_lji.lji01,'upd lji_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   #FUN-C50036--start add--------------------------------
   SELECT lntpos INTO l_lntpos
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04
  
   IF l_lntpos = '3' THEN
      LET l_lntpos = '2'
   END IF 
   
   #FUN-C50036--end add----------------------------------

   #根据变更类型不同，更新合同单头信息
   CASE g_lji.lji02
      WHEN '1'  #优惠申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05,
                lnt64 = g_lji.lji32,
                lnt65 = g_lji.lji33,
                lnt66 = g_lji.lji34,
                lnt67 = g_lji.lji35,
                lnt68 = g_lji.lji36,
                lnt69 = g_lji.lji37
          WHERE lnt01 = g_lji.lji04
      WHEN '2'  #辅助申请
         UPDATE lnt_file 
            SET lnt02 = g_lji.lji05,
                lnt30 = g_lji.lji381
          WHERE lnt01 = g_lji.lji04
      WHEN '3'  #延期申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05,
                lnt64 = g_lji.lji32,
                lnt65 = g_lji.lji33,
                lnt66 = g_lji.lji34,
                lnt67 = g_lji.lji35,
                lnt68 = g_lji.lji36,
                lnt69 = g_lji.lji37,
                lnt18 = g_lji.lji27,
                lntpos = l_lntpos,     #FUN-C50036 add
                lnt22 = g_lji.lji27
          WHERE lnt01 = g_lji.lji04
      WHEN '4'  #面积变更申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05,
                lnt11 = g_lji.lji141,
                lnt61 = g_lji.lji151,
                lnt10 = g_lji.lji161,
                lnt64 = g_lji.lji32,
                lnt65 = g_lji.lji33,
                lnt66 = g_lji.lji34,
                lnt67 = g_lji.lji35,
                lnt68 = g_lji.lji36,
                lnt69 = g_lji.lji37
          WHERE lnt01 = g_lji.lji04
      WHEN '5'  #终止申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05,
                lnt64 = g_lji.lji32,
                lnt65 = g_lji.lji33,
                lnt66 = g_lji.lji34,
                lnt67 = g_lji.lji35,
                lnt68 = g_lji.lji36,
                lnt69 = g_lji.lji37
          WHERE lnt01 = g_lji.lji04
   END CASE   
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('lnt01',g_lji.lji04,'upd lnt_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   IF g_lji.lji02 <> '2' THEN           #辅助变更不需要更新合同单身以及账单和日核算
      CALL t410_change_post_upd()       #更新合同单身：费用标准、优惠标准、其他费用/其他品牌
      CALL t614_change_account()        #更新合同日核算
      CALL t614_change_bill()           #更新合同账单
      CALL t410_update_liw_bill_order() #账单排序
   END IF

   #删除合同中的其它品牌单身，新增变更单中的其他品牌单身
   CALL t410_del_ins_lny()

   #如果变更日期=合同终止日期lji29，产生未产生的所有费用单，更新合同状态为终止，更新摊位状态为未出租    
   IF g_lji.lji02 = '5' AND g_lji.lji29 = g_today THEN
      #FUN-C50036--start add--------------------------------------
      UPDATE lnt_file
         SET lntpos = l_lntpos 
       WHERE lnt01 = g_lji.lji04
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lnt01',g_lji.lji04,'upd lnt_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      #FUN-C50036--end add----------------------------------------  

      CALL i400sub_upd_lnt('1',g_lji.lji01,g_today,g_lji.ljiplant)
   END IF

   #产生出账日小于等于今天的所有费用单
   IF g_lji.lji02 MATCHES '[134]' THEN
      DECLARE sel_liw_cs_1 CURSOR FOR
       SELECT DISTINCT liw01,liw05,liw06
         FROM liw_file
        WHERE liw01 = g_lji.lji04
          AND liw06 <= g_today
          AND liw17 = 'N'
          AND liw16 IS NULL
        ORDER BY liw06
      FOREACH sel_liw_cs_1 INTO l_liw01,l_liw05,l_liw06
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            EXIT FOREACH
         END IF
         CALL i400sub_gen_expense_bill(l_liw01,l_liw05,l_liw06,g_lji.ljiplant)
      END FOREACH
   END IF
   
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_lji.* FROM lji_file WHERE lji01 = g_lji.lji01
   DISPLAY BY NAME g_lji.lji43
   CLOSE t410_cl
END FUNCTION


#FUN-C80072-------add----str
#發出還原
FUNCTION t410_undo_post()
   DEFINE l_lji05       LIKE lji_file.lji05   
   DEFINE l_n           LIKE type_file.num10
   DEFINE l_lnt48       LIKE lnt_file.lnt48
   DEFINE l_lnt26       LIKE lnt_file.lnt26

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lji.*
     FROM lji_file
    WHERE lji01 = g_lji.lji01

   #不是变更发出状态不能发出还原
   IF g_lji.lji43 <> '2' THEN
      CALL cl_err(g_lji.lji04,'alm1634',0)
      RETURN
   END IF
   #有更高版本的变更单
   SELECT MAX(lji05) INTO l_lji05 
     FROM lji_file
    WHERE lji04 = g_lji.lji04   
   IF l_lji05 > g_lji.lji05 THEN
      CALL cl_err(g_lji.lji04,'alm1629',0)
      RETURN
   END IF
   #此版本變更單對應合約已結案
   SELECT lnt48,lnt26 INTO l_lnt48,l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04
      AND lnt02 = g_lji.lji05
   IF l_lnt48 = '2' THEN
      CALL cl_err(g_lji.lji04,'alm1631',0)
      RETURN
   END IF
   #此版本變更單對應合約已到期
   IF l_lnt26 = 'E' THEN
      CALL cl_err(g_lji.lji04,'alm1635',0)
      RETURN
   END IF
   #此版本變更單對應合約已终止
   IF l_lnt26 = 'S' THEN
      CALL cl_err(g_lji.lji04,'alm1637',0)
      RETURN
   END IF 
   #此版本變更單已產生費用資料
   SELECT COUNT(*) INTO l_n
     FROM lua_file
    WHERE lua04 = g_lji.lji04
      AND lua20 = g_lji.lji05
   IF l_n > 0 THEN
      CALL cl_err(g_lji.lji04,'alm1630',0)
      RETURN
   END IF

   #此版本變更單對應账单已结案
   SELECT COUNT(*) INTO l_n 
     FROM ljq_file
    WHERE ljq01 = g_lji.lji04
      AND ljq02 = g_lji.lji05
      AND ljq17 = 'Y'
   IF l_n > 0 THEN
      CALL cl_err(g_lji.lji04,'alm1636',0)
      RETURN
   END IF

   DROP TABLE liw_temp
   SELECT * FROM liw_file WHERE 1=0 INTO TEMP liw_temp

   IF NOT cl_confirm('alm1632') THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_lji.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_lji.lji02 <> '2' THEN
      #刪除對應版本合約帳單 
      DELETE FROM liw_file WHERE liw01 = g_lji.lji04 AND liw02 = g_lji.lji05
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('lnt01',g_lji.lji04,'del liw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      #刪除對應版本合約日核算
      DELETE FROM liv_file WHERE liv01 = g_lji.lji04 AND liv02 = g_lji.lji05
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('liv01',g_lji.lji04,'del liv_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF 
      #刪除對應版本合約單身標準費用
      DELETE FROM lnv_file WHERE lnv01 = g_lji.lji04 AND lnv02 = g_lji.lji05
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('lnv01',g_lji.lji04,'del lnv_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      #刪除對應版本合約單身其他費用
      DELETE FROM lnw_file WHERE lnw01 = g_lji.lji04 AND lnw02 = g_lji.lji05
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('lnw01',g_lji.lji04,'del lnw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF 
   IF g_lji.lji02 = '1' THEN
      #刪除對應版本合約單身優惠費用
      DELETE FROM lit_file WHERE lit01 = g_lji.lji04 AND lit02 = g_lji.lji05
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('lit01',g_lji.lji04,'del lit_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #根据变更类型不同，更新合同
   CASE g_lji.lji02
      WHEN '1'  #优惠申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05 - 1
          WHERE lnt01 = g_lji.lji04
      WHEN '2'  #辅助申请
         UPDATE lnt_file 
            SET lnt02 = g_lji.lji05 - 1,
                lnt30 = g_lji.lji38
          WHERE lnt01 = g_lji.lji04
      WHEN '3'  #延期申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05 - 1,
                lnt18 = g_lji.lji23,
                lnt22 = g_lji.lji26
          WHERE lnt01 = g_lji.lji04
      WHEN '4'  #面积变更申请
         UPDATE lnt_file
            SET lnt02 = g_lji.lji05 - 1,
                lnt11 = g_lji.lji14,
                lnt61 = g_lji.lji15,
                lnt10 = g_lji.lji16
          WHERE lnt01 = g_lji.lji04
         CALL t410_lnu_upd() #更新合同场地信息
   END CASE  
  
   IF g_lji.lji02 <> '2' THEN
      CALL i400sub_generate_bill(g_lji.lji04,'1')  #重新统计账单
      CALL t410_update_liw_bill_order()
      CALL t410_lnt_upd()                          #更新合约单头费用资料
   END IF
 
   IF g_success = 'Y' THEN
      UPDATE lji_file SET lji43 = '1'
       WHERE lji01 = g_lji.lji01 
      IF SQLCA.SQLCODE THEN
          CALL s_errmsg('lji01',g_lji.lji01,'upd lji_file',SQLCA.sqlcode,1)
          LET g_success = 'N'
          ROLLBACK WORK
      END IF
      CALL cl_err('','alm1633',0)
      COMMIT WORK
   ELSE
      CALL s_showmsg()
      CALL cl_err('','wag-101',0)
      ROLLBACK WORK
   END IF
  
   SELECT * INTO g_lji.* FROM lji_file WHERE lji01 = g_lji.lji01
   DISPLAY BY NAME g_lji.lji43 
   CLOSE t410_cl
END FUNCTION

FUNCTION t410_lnu_upd()
   DELETE FROM lnu_file WHERE lnu01 = g_lji.lji04
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lji01',g_lji.lji04,'del lnu_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   LET g_sql = "INSERT INTO lnu_file(lnu01,lnu02,lnu03,lnu04,lnu05,lnu06,lnu07,lnu08,lnu09,lnu10,lnulegal,lnuplant)",
               "     SELECT '",g_lji.lji04,"',ljn02,ljn04,ljn10,ljn08,ljn03,ljn09,ljn05,ljn06,ljn07,ljnlegal,ljnplant",
               "       FROM ljn_file,lji_file",
               "      WHERE ljn01 = lji01 ",
               "        AND lji04 = '",g_lji.lji04,"'",
               "        AND lji05 = ",g_lji.lji05," - 1 "
   PREPARE pre_inslnu FROM g_sql
   EXECUTE pre_inslnu
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji04,'ins lnu_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION


FUNCTION t410_lnt_upd()
DEFINE l_lnt         RECORD LIKE lnt_file.*
DEFINE l_sum_liv06   LIKE liv_file.liv06
DEFINE l_sum_liv06_1 LIKE liv_file.liv06
DEFINE l_sum_liv06_2 LIKE liv_file.liv06
DEFINE l_sum_liv06_3 LIKE liv_file.liv06
   SELECT SUM(liv06) INTO l_sum_liv06                       #抓取标准费用金额总和
     FROM liv_file
    WHERE liv01 = g_lji.lji04
      AND liv08 = '1'
   IF cl_null(l_sum_liv06) THEN
      LET l_sum_liv06 = 0
   END IF

   SELECT SUM(liv06) INTO l_sum_liv06_1                     #抓取优惠费用金额总和
     FROM liv_file
    WHERE liv01 = g_lji.lji04
      AND liv08 = '2'
   IF cl_null(l_sum_liv06_1) THEN
      LET l_sum_liv06_1 = 0
   END IF

   SELECT SUM(liv06) INTO l_sum_liv06_2                     #抓取终止费用金额总和
     FROM liv_file
    WHERE liv01 = g_lji.lji04
      AND liv08 = '3'
   IF cl_null(l_sum_liv06_2) THEN
      LET l_sum_liv06_2 = 0
   END IF

   SELECT SUM(liv06) INTO l_sum_liv06_3                     #抓取抹零费用金额总和
     FROM liv_file
    WHERE liv01 = g_lji.lji04
      AND liv08 = '4'
   IF cl_null(l_sum_liv06_3) THEN
      LET l_sum_liv06_3 = 0
   END IF

   SELECT SUM(liv06) INTO l_lnt.lnt66                        #抓取质保金费用总和
     FROM liv_file
    WHERE liv01 = g_lji.lji04
      AND liv08 = '1'
      AND (liv05 IN (SELECT lnv04 FROM lnv_file,oaj_file WHERE lnv01 = g_lji.lji04
                                                          AND lnv04 = oaj01
                                                          AND oaj05 = '01')
       OR liv05 IN (SELECT lnw03 FROM lnw_file,oaj_file WHERE lnw01 = g_lji.lji04
                                                          AND lnw03 = oaj01
                                                          AND oaj05 = '01')
       OR liv05 IN (SELECT lit04 FROM lit_file,oaj_file WHERE lit01 = g_lji.lji04
                                                          AND lit04 = oaj01
                                                          AND oaj05 = '01'))
   IF cl_null(l_lnt.lnt66) THEN
      LET l_lnt.lnt66 = 0
   END IF
   LET l_lnt.lnt64 = l_sum_liv06 - l_lnt.lnt66
   LET l_lnt.lnt65 = l_sum_liv06_1
   LET l_lnt.lnt67 = l_sum_liv06_2
   LET l_lnt.lnt68 = l_sum_liv06_3
   LET l_lnt.lnt69 = l_lnt.lnt64 - l_lnt.lnt65 + l_lnt.lnt66 + l_lnt.lnt67 + l_lnt.lnt68  
   UPDATE lnt_file SET lnt64 = l_lnt.lnt64,
                       lnt65 = l_lnt.lnt65,
                       lnt66 = l_lnt.lnt66,
                       lnt67 = l_lnt.lnt67,
                       lnt68 = l_lnt.lnt68,
                       lnt69 = l_lnt.lnt69
                 WHERE lnt01 = g_lji.lji04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lnt_file",g_lji.lji04,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-C80072-------add----end

FUNCTION t410_update_liw_bill_order()
   DEFINE l_order         LIKE type_file.num5,
          l_liw03         LIKE liw_file.liw03,
          l_liw           RECORD LIKE liw_file.*

    #复制账单资料到临时表

    INSERT INTO liw_temp
    SELECT * FROM liw_file
     WHERE liw01 = g_lji.lji04
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('lnt01',g_lji.lji04,'ins liw_file',SQLCA.sqlcode,1)
       LET g_success='N'
    END IF

   #删除liw_file资料
    DELETE FROM liw_file WHERE liw01=g_lji.lji04
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('lnt01',g_lji.lji04,'del liw_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

    #(目标：依次更新项次 | 条件：费用编号+账期编号+版本号)
    LET l_order = 1

    #(目标：费用编号+账期编号+版本号 |条件：按照账期编号 +费用编号 +版本号 排序)
    DECLARE liw_order_update CURSOR FROM "SELECT * FROM liw_temp WHERE 1=1 ORDER BY liw06,liw04,liw02,liw07 "
    FOREACH liw_order_update INTO l_liw.*
       UPDATE liw_temp SET liw03=l_order
        WHERE liw01 = l_liw.liw01
          AND liw06 = l_liw.liw06
          AND liw04 = l_liw.liw04
          AND liw07 = l_liw.liw07
          AND liw02 = l_liw.liw02
       IF SQLCA.sqlcode THEN
          LET g_msg=l_liw.liw04,"||",l_liw.liw06,"||",l_liw.liw07,"||",l_liw.liw02
          CALL s_errmsg("liw04,liw05,liw07,liw02",g_msg,'update liw_temp fail',SQLCA.sqlcode,1)
          LET g_success='N'
       END IF

       LET l_order=l_order+1
    END FOREACH
    IF STATUS THEN
       LET g_msg=l_liw.liw04,"||",l_liw.liw06,"||",l_liw.liw07,"||",l_liw.liw02
       CALL s_errmsg("liw04,liw05,liw07,liw02",g_msg,'sel liw_temp fail','',1)
       LET g_success='N'
    END IF

    #复制临时表资料到liw_file
    INSERT INTO liw_file SELECT * FROM liw_temp
    IF SQLCA.sqlcode THEN
       CALL s_errmsg("","",'ins liw_file fail',SQLCA.sqlcode,1)
       LET g_success='N'
    END IF
END FUNCTION 

FUNCTION t410_change_post_upd()

   #费用标准单身中有新版本的资料，把新版本的单身写到合同中
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ljj_file
    WHERE ljj01 = g_lji.lji01
      AND ljj02 = g_lji.lji05
   IF g_cnt > 0 THEN
      INSERT INTO ljj_temp SELECT * FROM ljj_file
                            WHERE ljj01 = g_lji.lji01
                              AND ljj02 = g_lji.lji05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins ljj_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      UPDATE ljj_temp SET ljj01 = g_lji.lji04
       WHERE ljj01 = g_lji.lji01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'upd ljj_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      INSERT INTO lnv_file (lnv01,lnv02,lnv03,lnv04,lnv18,lnv181,lnv16,lnv17,lnv07,lnvlegal,lnvplant)
                    SELECT  ljj01,ljj02,ljj03,ljj04,ljj05,ljj051,ljj06,ljj07,ljj08,ljjlegal,ljjplant FROM ljj_temp
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins lnv_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF

   #优惠单身中有新版本的资料，把新版本的单身写到合同中
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ljk_file
    WHERE ljk01 = g_lji.lji01
      AND ljk02 = g_lji.lji05
   IF g_cnt > 0 THEN
      INSERT INTO ljk_temp SELECT * FROM ljk_file
                            WHERE ljk01 = g_lji.lji01
                              AND ljk02 = g_lji.lji05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins ljk_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      UPDATE ljk_temp SET ljk01 = g_lji.lji04
       WHERE ljk01 = g_lji.lji01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'upd ljk_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
      
      INSERT INTO lit_file SELECT * FROM ljk_temp
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins lit_file',SQLCA.sqlcode,1)
         RETURN
      END IF 
   END IF

   #其他费用单身中有新版本的资料，把新版本的单身写到合同中
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ljl_file
    WHERE ljl01 = g_lji.lji01
      AND ljl02 = g_lji.lji05
   IF g_cnt > 0 THEN
      INSERT INTO ljl_temp SELECT * FROM ljl_file
                            WHERE ljl01 = g_lji.lji01
                              AND ljl02 = g_lji.lji05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins ljl_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      UPDATE ljl_temp SET ljl01 = g_lji.lji04
       WHERE ljl01 = g_lji.lji01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'upd ljl_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      INSERT INTO lnw_file (lnw01,lnw02,lnw11,lnw03,lnw08,lnw09,lnw06,lnwlegal,lnwplant,lnw07)
                    SELECT  ljl01,ljl02,ljl03,ljl04,ljl05,ljl06,ljl07,ljllegal,ljlplant,' ' FROM ljl_temp
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins lnw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF

   #面积变革，更新场地单身写到合同中
   IF g_lji.lji02 = '4' THEN
      INSERT INTO ljn_temp SELECT * FROM ljn_file
                            WHERE ljn01 = g_lji.lji01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins ljn_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      UPDATE ljn_temp SET ljn01 = g_lji.lji04
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'upd ljn_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      DELETE FROM lnu_file WHERE lnu01 = g_lji.lji04
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lji01',g_lji.lji01,'del lnu_file',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF

      INSERT INTO lnu_file (lnu01,lnu02,lnu06,lnu03,lnu08,lnu09,lnu10,lnu05,lnu07,lnu04,lnulegal,lnuplant)
                    SELECT  ljn01,ljn02,ljn03,ljn04,ljn05,ljn06,ljn07,ljn08,ljn09,ljn10,ljnlegal,ljnplant FROM ljn_temp
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins lnu_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION 

FUNCTION t614_change_bill()
   DEFINE l_liw    RECORD LIKE liw_file.*

   DEFINE l_sql           STRING,
          l_liw03         LIKE liw_file.liw03 

   LET l_sql = " SELECT *",
               "   FROM ljq_file",
               "  WHERE ljq01 = '",g_lji.lji01,"'",
               "    AND ljq02 = '",g_lji.lji05,"'"

   DECLARE t410_ins_liw CURSOR FROM l_sql

   FOREACH t410_ins_liw INTO l_liw.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 

      SELECT MAX(liw03) INTO l_liw03
        FROM liw_file
       WHERE liw01 = g_lji.lji04

      IF cl_null(l_liw03) THEN 
         LET l_liw03 = 1
      ELSE 
         LET l_liw03 = l_liw03 +1
      END IF 

      LET l_liw.liw01 = g_lji.lji04
      LET l_liw.liw02 = g_lji.lji05
      LET l_liw.liw03 = l_liw03
      
      INSERT INTO liw_file VALUES l_liw.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lnt01',g_lji.lji04,'ins liw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF   
   END FOREACH    
END FUNCTION 

FUNCTION t614_change_account()
   DEFINE l_liv    RECORD LIKE liv_file.*

   DEFINE l_sql           STRING,
          l_liv03         LIKE liw_file.liw03 

   LET l_sql = " SELECT *",
               "   FROM ljp_file",
               "  WHERE ljp01 = '",g_lji.lji01,"'",
               "    AND ljp02 = '",g_lji.lji05,"'"

   DECLARE t410_ins_liv CURSOR FROM l_sql

   FOREACH t410_ins_liv INTO l_liv.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 

      SELECT MAX(liv03) INTO l_liv03
        FROM liv_file
       WHERE liv01 = g_lji.lji04

      IF cl_null(l_liv03) THEN 
         LET l_liv03 = 1
      ELSE 
         LET l_liv03 = l_liv03 +1
      END IF 

      LET l_liv.liv01 = g_lji.lji04
      LET l_liv.liv02 = g_lji.lji05
      LET l_liv.liv03 = l_liv03
      
      INSERT INTO liv_file VALUES l_liv.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lnt01',g_lji.lji04,'ins liv_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF   
   END FOREACH    
END FUNCTION

#变更发出时，刪除原合同的其他品牌，新增變更單中的其它品牌到合同的其它品牌單身表中
FUNCTION t410_del_ins_lny()
   DEFINE l_lny        RECORD LIKE lny_file.*
   DEFINE l_ljo        RECORD LIKE ljo_file.*
   DEFINE l_sql        STRING 

   LET l_sql = "SELECT * FROM ljo_file WHERE ljo01 = '",g_lji.lji01,"'"
   DECLARE t410_lny_cs CURSOR FROM l_sql 
   
   DELETE FROM lny_file WHERE lny01 = g_lji.lji04
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del lny_file',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN         
   END IF

   FOREACH t410_lny_cs INTO l_ljo.*
      LET l_lny.lny01 = g_lji.lji04
      LET l_lny.lny02 = l_ljo.ljo02
      LET l_lny.lny03 = l_ljo.ljo04
      LET l_lny.lny04 = l_ljo.ljo03
      LET l_lny.lnylegal = l_ljo.ljolegal
      LET l_lny.lnyplant = l_ljo.ljoplant

      INSERT INTO lny_file VALUES l_lny.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('lji01',g_lji.lji01,'ins lny_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
       END IF
   END FOREACH 
END FUNCTION  

#Modify By shi ------
FUNCTION t410_generate_account()
   
   IF s_shut(0) THEN RETURN END IF

   IF g_lji.lji01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_lji.* FROM lji_file WHERE lji01 = g_lji.lji01
   #如果变更类型是辅助变更申请，不用产生日核算
   IF g_lji.lji02 = '2' THEN
      CALL cl_err(g_lji.lji01,'',0)
      RETURN
   END IF
   IF g_lji.ljiconf = 'X' THEN RETURN END IF  #CHI-C80041
   #如果初审或者终审不可产生日核算
   IF g_lji.ljiconf <> 'N' THEN
      CALL cl_err(g_lji.lji01,'',0)
      RETURN
   END IF

   LET g_cnt = 0
   SELECT COUNT(*)  INTO g_cnt
     FROM ljp_file 
    WHERE ljp01 = g_lji.lji01
      AND ljp02 = g_lji.lji05
   IF g_cnt > 0 THEN 
      IF NOT cl_confirm('alm1268') THEN
         RETURN 
      END IF 
   END IF 

   CASE g_lji.lji02
      WHEN '1'                     #优惠变更日核算
         CALL t410_preferential()
      WHEN '3'                     #延期日核算,调用almi400_sub中的FUNCTION
         CALL i400sub_standard('2',g_lji.lji01,g_lji.lji23+1,g_lji.lji27)
         CALL t410_b1_fill(g_wc2)
      WHEN '4'                     #面积变更日核算,调用almi400_sub中的FUNCTION
         CALL t410_add_area()
         CALL i400sub_standard('3',g_lji.lji01,g_lji.lji28,g_lji.lji26)
         CALL t410_b1_fill(g_wc2)
      WHEN '5'                     #终止变更日核算
         CALL t410_termination()
   END CASE

   IF g_success = 'Y' THEN
      CALL cl_err('','alm1363',0)
   ELSE 
      CALL cl_err('','alm1364',0)
     #TQC-C20395 Begin---
      IF g_lji.lji02 = '3' THEN
         CALL t410_dellji()
      END IF
     #TQC-C20395 End-----
   END IF
   CALL t410_upd()
END FUNCTION

#TQC-C20395 Begin---
FUNCTION t410_dellji()

   DELETE FROM ljq_file WHERE ljq01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljp_file WHERE ljp01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljp_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljo_file WHERE ljo01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljo_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljn_file WHERE ljn01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljn_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljm_file WHERE ljm01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljm_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljl_file WHERE ljl01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljl_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljk_file WHERE ljk01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljk_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljj_file WHERE ljj01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del ljj_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM lji_file WHERE lji01 = g_lji.lji01
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('lji01',g_lji.lji01,'del lji_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   INITIALIZE g_lji.* TO NULL
   CALL g_ljj.clear()
   CALL g_ljk.clear()
   CALL g_ljl.clear()
   CALL g_ljm.clear()
   CALL g_ljn.clear()
   CALL g_ljo.clear()
   LET g_lji01_t = NULL
   CLEAR FORM
END FUNCTION
#TQC-C20395 End-----

#FUN-C80072-------mark----str
##面积变更带出新增场地或去掉减少的场地
#FUNCTION t410_add_area()
#   DEFINE l_ljn        RECORD LIKE ljn_file.*,
#          l_lic        RECORD LIKE lic_file.*
#   DEFINE l_n                 LIKE type_file.num5,
#          l_n2                LIKE type_file.num5,
#          l_lib01             LIKE lib_file.lib01,
#          l_lib07             LIKE lib_file.lib07, 
#          l_ljn03             LIKE ljn_file.ljn03,
#          l_ljn08             LIKE ljn_file.ljn08,
#          l_ljn09             LIKE ljn_file.ljn09,
#          l_ljn10             LIKE ljn_file.ljn10
#   DEFINE l_sql               STRING
#
#   SELECT lib01,lib07 INTO l_lib01,l_lib07 
#     FROM lib_file
#    WHERE lib04 = g_lji.lji03
#
#   SELECT count(*) INTO l_n
#     FROM lic_file
#    WHERE lic01 = l_lib01
#
#   SELECT COUNT (ljn04) INTO l_n2 
#     FROM ljn_file
#    WHERE ljn04 IN ( SELECT lic03 FROM lic_file WHERE lic01 = l_lib01)
#      AND ljn01 = g_lji.lji01  
#
#   IF l_n <> l_n2 THEN 
#      LET l_sql = " SELECT * ",
#                  "   FROM lic_file",
#                  "  WHERE lic01 = '",l_lib01,"'"
#
#     
#      DECLARE t410_chk_lic03 CURSOR FROM l_sql
#
#      LET l_n = 0
#      FOREACH t410_chk_lic03 INTO l_lic.*
#         SELECT COUNT(*) INTO l_n
#           FROM ljn_file
#          WHERE ljn01 = g_lji.lji01
#            AND ljn04 = l_lic.lic03
#         IF l_n = 0 THEN    
#            SELECT MAX(ljn03) INTO l_ljn03
#              FROM ljn_file
#             WHERE ljn01 = g_lji.lji01
#
#            IF cl_null(l_ljn03) THEN 
#               LET l_ljn03 = 1
#            ELSE 
#               LET l_ljn03 = l_ljn03 + 1
#            END IF 
#            
#            LET l_ljn.ljn01 = g_lji.lji01
#            LET l_ljn.ljn02 = g_lji.lji05
#            LET l_ljn.ljn03 = l_ljn03
#            LET l_ljn.ljn04 = l_lic.lic03
#            LET l_ljn.ljn05 = l_lib07
#            LET l_ljn.ljn06 = l_lic.lic04
#            LET l_ljn.ljn07 = l_lic.lic05
#            LET l_ljn.ljn08 = l_lic.lic06
#            LET l_ljn.ljn09 = l_lic.lic07
#            LET l_ljn.ljn10 = l_lic.lic08
#            LET l_ljn.ljnplant = g_lji.ljiplant
#            LET l_ljn.ljnlegal = g_lji.ljilegal
#            
#            INSERT INTO ljn_file VALUES l_ljn.*
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err3("ins","ljn_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
#               RETURN
#            END IF
#         END IF 
#      END FOREACH
#   ELSE
#      LET l_sql = " SELECT *",
#                  "   FROM lic_file",
#                  "  WHERE lic01 = '",l_lib01,"'"
#
#      DECLARE t410_chk_lic03_2 CURSOR FROM l_sql
# 
#      FOREACH t410_chk_lic03_2 INTO l_lic.*
#         SELECT ljn08,ljn09,ljn10 
#           INTO l_ljn08,l_ljn09,l_ljn10
#           FROM ljn_file
#          WHERE ljn01 = g_lji.lji01
#            AND ljn04 = l_lic.lic03
#
#         IF l_ljn08 <> l_lic.lic06 OR l_ljn09 <> l_lic.lic07
#            OR l_ljn10 <> l_lic.lic08 THEN 
#            UPDATE ljn_file
#               SET ljn08 = l_lic.lic06,
#                   ljn09 = l_lic.lic07,
#                   ljn10 = l_lic.lic08,
#                   ljn02 = g_lji.lji05
#             WHERE ljn01 = g_lji.lji01
#               AND ljn04 = l_lic.lic03
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err3("upd","ljn_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
#               RETURN
#            END IF  
#         END IF
#      END FOREACH
#   END IF    
#END FUNCTION
#FUN-C80072-------mark----end

#FUN-C80072-------add-----str
FUNCTION t410_add_area()
   DEFINE l_lie               RECORD LIKE lie_file.*
   DEFINE l_ljn               RECORD LIKE ljn_file.*
   DEFINE l_ljn03             LIKE ljn_file.ljn03
   DEFINE l_n2                LIKE type_file.num5
   DEFINE l_sql               STRING
   DEFINE l_ljn04             LIKE ljn_file.ljn04
   DEFINE l_ljn08             LIKE ljn_file.ljn08
   DEFINE l_ljn09             LIKE ljn_file.ljn09
   DEFINE l_ljn10             LIKE ljn_file.ljn10

   LET l_ljn03 = 0
   SELECT MAX(ljn03) INTO l_ljn03
     FROM ljn_file
    WHERE ljn01 = g_lji.lji01
   LET l_sql = "SELECT *",
               "  FROM lie_file",
               " WHERE lie01 = '",g_lji.lji08,"'"
   PREPARE t410_lie_pb FROM l_sql
   DECLARE t410_lie_cs CURSOR FOR t410_lie_pb
   FOREACH t410_lie_cs INTO l_lie.*
      LET l_n2 = 0
      SELECT COUNT(*) INTO l_n2
        FROM ljn_file
       WHERE ljn04 = l_lie.lie02
      IF l_n2 = 0 THEN
         LET l_ljn.ljn01 = g_lji.lji01
         LET l_ljn.ljn02 = g_lji.lji05
         LET l_ljn.ljn03 = l_ljn03 + 1
         LET l_ljn.ljn04 = l_lie.lie02
         LET l_ljn.ljn05 = g_lji.lji11
         LET l_ljn.ljn06 = g_lji.lji12
         LET l_ljn.ljn07 = g_lji.lji13
         LET l_ljn.ljn08 = l_lie.lie05
         LET l_ljn.ljn09 = l_lie.lie06
         LET l_ljn.ljn10 = l_lie.lie07
         LET l_ljn.ljnplant = g_lji.ljiplant
         LET l_ljn.ljnlegal = g_lji.ljilegal
         INSERT INTO ljn_file VALUES l_ljn.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","ljn_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
            RETURN
         ELSE
            CONTINUE FOREACH
         END IF
      END IF
      SELECT ljn08,ljn09,ljn10 INTO l_ljn08,l_ljn09,l_ljn10
        FROM ljn_file 
       WHERE ljn04 = l_lie.lie02
      IF l_ljn08 <> l_lie.lie05 OR l_ljn09 <> l_lie.lie06
         OR l_ljn10 <> l_lie.lie07 THEN 
         UPDATE ljn_file
            SET ljn08 = l_lie.lie05, 
                ljn09 = l_lie.lie06,
                ljn10 = l_lie.lie07,
                ljn02 = g_lji.lji05
          WHERE ljn01 = g_lji.lji01
            AND ljn04 = l_lie.lie02
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("upd","ljn_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
            RETURN
         ELSE
            CONTINUE FOREACH
         END IF  
      END IF
   END FOREACH 
   DELETE FROM ljn_file
    WHERE ljn01 = g_lji.lji01
      AND ljn04 NOT IN(SELECT lie02 FROM lie_file
                        WHERE lie01 = g_lji.lji08)
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("del","ljn_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
       RETURN
    END IF 
  
END FUNCTION
#FUN-C80072-------add-----end

#Modify By shi ------
 
#新增合同变更单时产生优惠单身日核算
FUNCTION t410_preferential()
   DEFINE l_ljb       RECORD LIKE ljb_file.*
   DEFINE l_ljk       RECORD LIKE ljk_file.*
   DEFINE l_sql          STRING,
          l_lla01        LIKE lla_file.lla01,
          l_date         LIKE ljb_file.ljb05,
          l_day_amt      LIKE ljb_file.ljb07,
          l_diff_amt     LIKE ljb_file.ljb07,
          l_ljp03        LIKE ljp_file.ljp03,
          l_lla04        LIKE lla_file.lla04
   DEFINE l_lij05        LIKE lij_file.lij05
   DEFINE l_ljp       RECORD LIKE ljp_file.*
   
   SELECT lla01,lla04 INTO l_lla01,l_lla04 
     FROM lla_file
    WHERE llastore = g_lji.ljiplant

  #By shi Begin---
  #CALL t410_preferential_apply() #By shi Mark
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()

   DELETE FROM ljp_file WHERE ljp01 = g_lji.lji01
                          AND ljp02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljp_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
  #MOD-C30450 Begin---
  #DELETE FROM ljl_file WHERE ljl01 = g_lji.lji01
  #                       AND ljl02 = g_lji.lji05
  #IF SQLCA.sqlcode THEN
  #   CALL s_errmsg('','','del ljl_file',SQLCA.sqlcode,1)
   DELETE FROM ljk_file WHERE ljk01 = g_lji.lji01
                          AND ljk02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljk_file',SQLCA.sqlcode,1)
  #MOD-C30450 End-----
      LET g_success = 'N'
   END IF
  #By shi End-----
   
   LET l_sql = " SELECT * ",
                "  FROM ljb_file ",
                " WHERE ljb01 = '",g_lji.lji03 ,"'"
                
   DECLARE t410_pre_cs CURSOR FROM l_sql  

   FOREACH t410_pre_cs INTO l_ljb.*
     #By shi Begin---
      IF STATUS THEN
         CALL s_errmsg('','','t410_pre_cs',STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      SELECT lij05 INTO l_lij05 FROM lij_file
       WHERE lij01 = g_lji.lji40
         AND lij02 = l_ljb.ljb04
     #By shi End-----
      IF cl_null(l_ljp03) THEN
         LET l_ljp03 = 0
      END IF 

      LET l_date    = l_ljb.ljb05
      LET l_day_amt = l_ljb.ljb07 /(l_ljb.ljb06-l_ljb.ljb05+1)
      LET l_day_amt = cl_digcut(l_day_amt,l_lla04)
      LET l_diff_amt = l_ljb.ljb07-l_day_amt*(l_ljb.ljb06-l_ljb.ljb05+1)
      WHILE TRUE
         SELECT MAX(ljp03)+1 INTO l_ljp03
           FROM ljp_file
          WHERE ljp01 = g_lji.lji01
         LET l_ljp.ljp01 = g_lji.lji01
         LET l_ljp.ljp02 = g_lji.lji05
         LET l_ljp.ljp03 = l_ljp03
         LET l_ljp.ljp04 = l_date
         LET l_ljp.ljp05 = l_ljb.ljb04 
         LET l_ljp.ljp06 = l_day_amt
         
         IF l_date = l_ljb.ljb05 AND l_lla01 = '1' THEN
             LET l_ljp.ljp06 = l_ljp.ljp06 + l_diff_amt
         END IF 

         IF l_date = l_ljb.ljb06 AND l_lla01 = '2' THEN
             LET l_ljp.ljp06 = l_ljp.ljp06 + l_diff_amt
         END IF
         
         LET l_ljp.ljp07 = l_ljb.ljb01  
         LET l_ljp.ljp071 = ''
         LET l_ljp.ljp08 = '2'
         LET l_ljp.ljp09 = l_ljb.ljb03
         LET l_ljp.ljplegal = l_ljb.ljblegal
         LET l_ljp.ljpplant = l_ljb.ljbplant
         IF l_lij05 = '1' THEN
            LET l_ljp.ljp06 = l_ljb.ljb07
         END IF

         INSERT INTO ljp_file VALUES l_ljp.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           #CALL cl_err3("ins","ljp_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
            CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1) #By shi Add
            LET g_success = 'N'
           #RETURN
            CONTINUE WHILE #By shi Add
         END IF

         IF l_lij05 = '1' THEN EXIT WHILE END IF
         IF l_date = l_ljb.ljb06 THEN
            EXIT WHILE
         END IF 
         LET l_date = l_date +1
      END WHILE    

     #By shi Mod Begin---
      SELECT MAX(ljk03)+1 INTO l_ljk.ljk03
        FROM ljk_file
       WHERE ljk01 = g_lji.lji01

      IF cl_null(l_ljk.ljk03) THEN
         LET l_ljk.ljk03 = 1
      END IF
      LET l_ljk.ljk01 = g_lji.lji01
      LET l_ljk.ljk02 = g_lji.lji05
      LET l_ljk.ljk04 = l_ljb.ljb04
      LET l_ljk.ljk05 = l_ljb.ljb01
      LET l_ljk.ljk06 = l_ljb.ljb05
      LET l_ljk.ljk07 = l_ljb.ljb06
      LET l_ljk.ljk08 = l_ljb.ljb07
      LET l_ljk.ljkplant = l_ljb.ljbplant
      LET l_ljk.ljklegal = l_ljb.ljblegal

      INSERT INTO ljk_file VALUES l_ljk.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        #CALL cl_err3("ins","ljk_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         CALL s_errmsg('','','ins ljk_file',SQLCA.sqlcode,1) #By shi Add
         LET g_success = 'N'
        #RETURN
         CONTINUE FOREACH #By shi Add
      END IF
     #By shi Mod End-----

   END FOREACH 
  #By shi Begin---
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
  #By shi End-----
   #MESSAGE '优惠变更产生日核算成功' 
END FUNCTION

#带出优惠变更申请中的单身
FUNCTION t410_preferential_apply()
   DEFINE l_ljk     RECORD LIKE ljk_file.*,
          l_ljb     RECORD LIKE ljb_file.*, 
          l_ljk03          LIKE ljk_file.ljk03

   DEFINE l_sql1           STRING 

   LET l_sql1 = " SELECT * FROM ljb_file WHERE ljb01 = '",g_lji.lji03,"'"

   DECLARE t410_ljb_cs CURSOR FROM l_sql1

   FOREACH t410_ljb_cs INTO l_ljb.*
      
      SELECT MAX(ljk03) INTO l_ljk03
        FROM ljk_file 
       WHERE ljk01 = g_lji.lji01

      IF cl_null(l_ljk03) THEN
         LET l_ljk03 = 0 
      END IF 
      LET l_ljk03 = l_ljk03 + 1
      LET l_ljk.ljk01 = g_lji.lji01
      LET l_ljk.ljk02 = g_lji.lji05
      LET l_ljk.ljk03 = l_ljk03
      LET l_ljk.ljk04 = l_ljb.ljb04
      LET l_ljk.ljk05 = l_ljb.ljb01
      LET l_ljk.ljk06 = l_ljb.ljb05
      LET l_ljk.ljk07 = l_ljb.ljb06
      LET l_ljk.ljk08 = l_ljb.ljb07
      LET l_ljk.ljkplant = l_ljb.ljbplant
      LET l_ljk.ljklegal = l_ljb.ljblegal

      INSERT INTO ljk_file VALUES l_ljk.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljk_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH 
END FUNCTION 

#新增合同变更单时产生终止变更日核算,其中1为费用标准单身，2对应优惠标准单身
#By shi Begin---
FUNCTION t410_termination()
 DEFINE l_ljp03     LIKE ljp_file.ljp03

   #建临时表
   DROP TABLE ljp_temp
   SELECT * FROM ljp_file WHERE 1=0 INTO TEMP ljp_temp
   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK

   DELETE FROM ljp_file WHERE ljp01 = g_lji.lji01
                          AND ljp02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljp_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljj_file WHERE ljj01 = g_lji.lji01
                          AND ljj02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljj_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljl_file WHERE ljl01 = g_lji.lji01
                          AND ljl02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljl_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DELETE FROM ljk_file WHERE ljk01 = g_lji.lji01
                          AND ljk02 = g_lji.lji05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','del ljk_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   INSERT INTO ljp_temp
   SELECT ljp_file.* FROM ljp_file,ljf_file
    WHERE ljf01 = g_lji.lji03
      AND ljf03 = ljp05
      AND ljf05 = ljp08
     #AND ((((ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NOT NULL) OR (ljf05 = '2' AND ljf06 = 'N')) AND ljf04 = ljp07) OR
     #      (ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NULL AND ljp07 IS NULL))
     #AND ljp04 > g_lji.lji29
     #FUN-C20078 Begin---   #日核算为0，暂时只有比例的方案，后面都不产生为0的日核算
     #AND ((((ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NOT NULL AND ljf04 = ljp07) OR
     #AND ((((ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NOT NULL AND ljf04 = ljp07 AND ljp06 > 0) OR  #TQC-C20505
      AND ((((ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NOT NULL AND ljf04 = ljp07 AND ljp06 <> 0) OR #TQC-C20505
     #FUN-C20078 End-----
             (ljf05 = '1' AND ljf06 = 'Y' AND ljf04 IS NULL AND ljp07 IS NULL)) AND ljp04 > g_lji.lji29) OR
             (ljf05 = '2' AND ljf06 = 'N' AND ljf04 = ljp07)) #优惠的不用判断日期，都可以回收
      AND ljp01 = g_lji.lji01
  # ORDER BY ljp04,ljp05
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','ins ljp_temp',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   SELECT MAX(ljp03) INTO l_ljp03 FROM ljp_file WHERE ljp01=g_lji.lji01

   #UPDATE ljp_temp SET ljp06 = ljp06*(-1),ljp03 = ljp03+l_ljp03,    #FUN-C80006 mark
   UPDATE ljp_temp SET ljp06 = (CASE ljp08 WHEN '2' THEN ljp06 ELSE ljp06*(-1) END),ljp03 = ljp03+l_ljp03,    #FUN-C80006 add
                               ljp02 = g_lji.lji05,ljp08='3',ljp09='0'
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','upd ljp_temp',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   INSERT INTO ljp_file SELECT * FROM ljp_temp
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

  #DECLARE t410_termination_cs CURSOR FOR
  # SELECT * FROM ljf_file
  #  WHERE ljf01 = g_lji.lji03
  #    AND ((ljf05 = '1' AND ljf06 = 'Y') OR (ljf05 = '2' AND ljf06 = 'N'))
  #FOREACH t410_termination_cs INTO l_ljf.*
  #   IF STATUS THEN
  #      CALL s_errmsg('','','t410_termination_cs',STATUS,1)
  #      LET g_success = 'N'
  #      EXIT FOREACH
  #   END IF
  #   
  #  #按照每天汇总的方式做（不这样处理）
  #   LET g_sql = "SELECT ljp04,ljp05,SUM(ljp06) FROM ljp_file", #分摊日期，费用编号，金额汇总
  #               " WHERE ljp01 = '",g_lji.lji01,"'",
  #               "   AND ljp05 = '",l_ljf.ljf03,"'"
  #   #费用退（有方案），或者优惠回收
  #   IF (l_ljf.ljf05 = '1' AND l_ljf.ljf06 = 'Y' AND NOT cl_null(l_ljf.ljf04)) OR
  #      (l_ljf.ljf05 = '2' AND l_ljf.ljf06 = 'N') THEN
  #      LET g_sql = g_sql CLIPPED,"   AND ljp07 = '",l_ljf.ljf04,"'",
  #                                "   AND ljp08 = '",l_ljf.ljf05,"'"
  #   END IF
  #   #费用退（其他费用，无方案）
  #   IF l_ljf.ljf05 = '1' AND l_ljf.ljf06 = 'Y' AND cl_null(l_ljf.ljf04) THEN
  #      LET g_sql = g_sql CLIPPED,"   AND ljp07 IS NULL",
  #                                "   AND ljp08 = '",l_ljf.ljf05,"'"
  #   END IF
  #   LET g_sql = g_sql CLIPPED," GROUP BY ljp04,ljp05",
  #                             " ORDER BY ljp04,ljp05"
  #   PREPARE t410_termination_p1 FROM g_sql
  #   DECLARE t410_termination_cs1 CURSOR FOR t410_termination_p1
  #   FOREACH t410_termination_cs1 INTO l_ljp.ljp04,l_ljp.ljp05,l_ljp.ljp06
  #      IF STATUS THEN
  #         CALL s_errmsg('','','t410_termination_cs1',STATUS,1)
  #         LET g_success = 'N'
  #         EXIT FOREACH
  #      END IF
  #      
  #      LET l_ljp.ljp01 = g_lji.lji01    #变更单号
  #      LET l_ljp.ljp02 = g_lji.lji05    #版本号
  #     #ET l_ljp.ljp03 =                 #项次
  #      SELECT MAX(ljp03)+1 INTO l_ljp.ljp03 FROM ljp_file
  #       WHERE ljp01 = g_lji.lji01
  #      IF cl_null(l_ljp.ljp03) THEN
  #         LET l_ljp.ljp03 = 1
  #      END IF
  #     #LET l_ljp.ljp04 = l_ljp.ljp04    #分摊日期
  #     #LET l_ljp.ljp05 = l_ljp.ljp05    #费用编号
  #      LET l_ljp.ljp06 = -l_ljp.ljp06   #费用金额
  #      LET l_ljp.ljp07 = l_ljf.ljf04    #参考单号
  #      LET l_ljp.ljp071= NULL           #参考单号版本号
  #      LET l_ljp.ljp08 = '3'            #数据类型 3.终止
  #      LET l_ljp.ljp09 = '0'            #优惠类型
  #      LET l_ljp.ljpplant = g_lji.ljiplant
  #      LET l_ljp.ljplegal = g_lji.ljilegal
  #      INSERT INTO ljp_file VALUES l_ljp.*
  #      IF SQLCA.sqlcode THEN
  #         CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         CONTINUE FOREACH
  #      END IF
  #   END FOREACH
  #   
  #   IF l_ljf.ljf05 = '1' AND l_ljf.ljf06 = 'Y' AND NOT cl_null(l_ljf.ljf04) THEN
  #      LET l_ljj.ljj01 = g_lji.lji01   #合同变更单号
  #      LET l_ljj.ljj02 = g_lji.lji05   #合同版本
  #     #LET l_ljj.ljj03 =    #项次
  #      SELECT MAX(ljj03)+1 INTO l_ljj.ljj03 FROM ljj_file
  #       WHERE ljj01 = l_ljj.ljj01
  #      IF cl_null(l_ljj.ljj03) THEN
  #         LET l_ljj.ljj03 = 1
  #      END IF
  #      LET l_ljj.ljj04 = l_ljf.ljf03   #费用编号
  #      LET l_ljj.ljj05 = l_ljf.ljf04   #方案编号
  #      LET l_ljj.ljj051= NULL          #方案版本号
  #      LET l_ljj.ljj06 = g_lji.lji29+1 #开始日期
  #      LET l_ljj.ljj07 = g_lji.lji26   #结束日期
  #     #LET l_ljj.ljj08 =               #费用标准
  #      SELECT SUM(ljp06) INTO l_ljj.ljj08 FROM ljp_file
  #       WHERE ljp01 = g_lji.lji01
  #         AND ljp02 = g_lji.lji05
  #         AND ljp04 BETWEEN g_lji.lji29+1 AND g_lji.lji26
  #         AND ljp05 = l_ljf.ljf03
  #         AND ljp07 = l_ljf.ljf04
  #         AND ljp08 = '3'
  #      LET l_ljj.ljjplant = g_lji.ljiplant #门店编号
  #      LET l_ljj.ljjlegal = g_lji.ljilegal #法人
  #      INSERT INTO ljj_file VALUES l_ljj.*
  #      IF SQLCA.sqlcode THEN
  #         CALL s_errmsg('','','ins ljj_file',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         CONTINUE FOREACH
  #      END IF
  #   END IF
  #   IF l_ljf.ljf05 = '1' AND l_ljf.ljf06 = 'Y' AND cl_null(l_ljf.ljf04) THEN
  #      LET l_ljl.ljl01 = g_lji.lji01   #合同变更单号
  #      LET l_ljl.ljl02 = g_lji.lji05   #合同版本
  #     #LET l_ljl.ljl03 =    #项次
  #      SELECT MAX(ljl03)+1 INTO l_ljl.ljl03 FROM ljl_file
  #       WHERE ljl01 = l_ljl.ljl01
  #      IF cl_null(l_ljl.ljl03) THEN
  #         LET l_ljl.ljl03 = 1
  #      END IF
  #      LET l_ljl.ljl04 = l_ljf.ljf03   #费用编号
  #      LET l_ljl.ljl05 = g_lji.lji29+1 #开始日期
  #      LET l_ljl.ljl06 = g_lji.lji26   #结束日期
  #     #LET l_ljl.ljl07 =               #费用金额
  #      SELECT SUM(ljp06) INTO l_ljl.ljl07 FROM ljp_file
  #       WHERE ljp01 = g_lji.lji01
  #         AND ljp02 = g_lji.lji05
  #         AND ljp04 BETWEEN g_lji.lji29+1 AND g_lji.lji26
  #         AND ljp05 = l_ljf.ljf03
  #         AND ljp07 IS NULL
  #         AND ljp08 = '3'
  #      LET l_ljl.ljlplant = g_lji.ljiplant #门店编号
  #      LET l_ljl.ljllegal = g_lji.ljilegal #法人
  #      INSERT INTO ljl_file VALUES l_ljl.*
  #      IF SQLCA.sqlcode THEN
  #         CALL s_errmsg('','','ins ljl_file',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         CONTINUE FOREACH
  #      END IF
  #   END IF
  #   IF l_ljf.ljf05 = '2' AND l_ljf.ljf06 = 'N' THEN
  #      LET l_ljk.ljk01 = g_lji.lji01   #合同变更单号
  #      LET l_ljk.ljk02 = g_lji.lji05   #合同版本
  #     #LET l_ljk.ljk03 =    #项次
  #      SELECT MAX(ljk03)+1 INTO l_ljk.ljk03 FROM ljk_file
  #       WHERE ljk01 = l_ljk.ljk01
  #      IF cl_null(l_ljk.ljk03) THEN
  #         LET l_ljk.ljk03 = 1
  #      END IF
  #      LET l_ljk.ljk04 = l_ljf.ljf03   #费用编号
  #      LET l_ljk.ljk05 = l_ljf.ljf04   #优惠单号
  #      LET l_ljk.ljk06 = g_lji.lji29+1 #开始日期
  #      LET l_ljk.ljk07 = g_lji.lji26   #结束日期
  #     #LET l_ljk.ljk08 =               #优惠金额
  #      SELECT SUM(ljp06) INTO l_ljk.ljk08 FROM ljp_file
  #       WHERE ljp01 = g_lji.lji01
  #         AND ljp02 = g_lji.lji05
  #         AND ljp04 BETWEEN g_lji.lji29+1 AND g_lji.lji26
  #         AND ljp05 = l_ljf.ljf03
  #         AND ljp07 = l_ljf.ljf04
  #         AND ljp08 = '3'
  #      LET l_ljk.ljkplant = g_lji.ljiplant #门店编号
  #      LET l_ljk.ljklegal = g_lji.ljilegal #法人
  #      INSERT INTO ljk_file VALUES l_ljk.*
  #      IF SQLCA.sqlcode THEN
  #         CALL s_errmsg('','','ins ljk_file',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         CONTINUE FOREACH
  #      END IF
  #   END IF
  #END FOREACH
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#By shi End-----

FUNCTION t410_check_for_upd()
   DEFINE l_n1    LIKE type_file.num5,
          l_n2    LIKE type_file.num5,
          l_n3    LIKE type_file.num5,
          l_n4    LIKE type_file.num5,
          l_n5    LIKE type_file.num5,
          l_n6    LIKE type_file.num5

   LET g_errno = ''
   LET l_n1 = 0
   LET l_n2 = 0
   LET l_n3 = 0
   LET l_n4 = 0
   LET l_n5 = 0
   LET l_n6 = 0
   
   SELECT count(*) INTO l_n1 
     FROM ljj_file 
    WHERE ljj01 = g_lji.lji01

   SELECT count(*) INTO l_n2 FROM ljk_file WHERE ljk01 = g_lji.lji01
   SELECT count(*) INTO l_n3 FROM ljl_file WHERE ljl01 = g_lji.lji01
   SELECT count(*) INTO l_n4 FROM ljm_file WHERE ljm01 = g_lji.lji01
   SELECT count(*) INTO l_n5 FROM ljn_file WHERE ljn01 = g_lji.lji01
   SELECT count(*) INTO l_n6 FROM ljo_file WHERE ljo01 = g_lji.lji01

   IF l_n1 <> 0 OR l_n2 <> 0 OR l_n3 <> 0 OR l_n4 <> 0 
      OR l_n5 <> 0 OR l_n6 <> 0 THEN
      LET g_errno = 'alm1224' 
   END IF 
END FUNCTION 

#由门店编号带出门店名称及法人编号和法人名称
FUNCTION t410_ljiplant(p_cmd)  
    DEFINE l_rtz13      LIKE rtz_file.rtz13,
           l_rtz28      LIKE rtz_file.rtz28,
           l_azt02      LIKE azt_file.azt02,
           l_azw02      LIKE azw_file.azw02,
           p_cmd        LIKE type_file.chr1
 
   SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28 
     FROM rtz_file 
    WHERE rtz01 = g_lji.ljiplant

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'alm-001'
      WHEN l_rtz28 <> 'Y' 
         LET g_errno = 'lma-003'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT azw02 INTO l_azw02
        FROM azw_file
       WHERE azw01 = g_lji.ljiplant

      LET g_lji.ljilegal = l_azw02 
       
      SELECT azt02 INTO l_azt02 
        FROM azt_file 
       WHERE azt01 = g_lji.ljilegal

      DISPLAY BY NAME g_lji.ljilegal 
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF 
END FUNCTION

#check变更申请单号是否来自lja中有效的申请单号，带出合同编号
FUNCTION t410_lji03(p_cmd)
   DEFINE l_ljaacti        LIKE lja_file.ljaacti,
          l_ljaconf        LIKE lja_file.ljaconf,
          l_lnt26          LIKE lnt_file.lnt26
   DEFINE l_sql            STRING,
          p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   LET l_sql = "SELECT lja05,ljaacti,ljaconf",
               "  FROM lja_file",
               " WHERE lja01 = '",g_lji.lji03,"'"
   CASE g_lji.lji02
      WHEN '1'
         LET l_sql = l_sql ," AND lja02 = '1'"
      WHEN '2'
         LET l_sql = l_sql," AND lja02 = '2'"
      WHEN '3'   
         LET l_sql = l_sql," AND lja02 = '3'"
      WHEN '4'
         LET l_sql = l_sql," AND lja02 = '4'"
      WHEN '5'
         LET l_sql = " SELECT lje04,ljeacti,ljeconf",
                     "   FROM lje_file",
                     "  WHERE lje01 = '",g_lji.lji03,"'"

   END CASE

   PREPARE t410_check FROM l_sql
   EXECUTE t410_check INTO g_lji.lji04,l_ljaacti,l_ljaconf  

   CASE 
      WHEN SQLCA.SQLCODE = 100 
         LET g_errno = 'alm1131'
         LET g_lji.lji04 = ''
      WHEN l_ljaacti <> 'Y'
         LET g_errno = 'alm1132'
         LET g_lji.lji04 = ''
      WHEN l_ljaconf = 'N'
         LET g_errno = 'alm1184'
      WHEN cl_null(g_lji.lji04)
         LET g_errno = 'alm1200'
   END CASE

   IF NOT cl_null(g_lji.lji04) THEN 
      SELECT lnt26 INTO l_lnt26
        FROM lnt_file
       WHERE lnt01 = g_lji.lji04

      CASE
         WHEN l_lnt26 = 'S'
            LET g_errno = 'alm-484'
         WHEN l_lnt26 = 'E'
            LET g_errno = 'alm1250'
      END CASE 
   END IF    

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_lji.lji04
   END IF 
END FUNCTION

#根据不同类型的变更申请带出不同的变更栏位值
FUNCTION t410_lji02()
   DEFINE l_lib091        LIKE lib_file.lib091,
          l_lib101        LIKE lib_file.lib101,
          l_lib111        LIKE lib_file.lib111

   LET g_errno = ''

   #SELECT lja131,lja19,lja11,lja081,lja091,lja101                                    #TQC-C40061 mark
   SELECT lja06,lja131,lja19,lja11,lja081,lja091,lja101                               #TQC-C40061 add
    #INTO g_lji.lji381,g_lji.lji27,g_lji.lji28,g_lji.lji141,g_lji.lji151,             #TQC-C40061 mark
    INTO g_lji.lji08,g_lji.lji381,g_lji.lji27,g_lji.lji28,g_lji.lji141,g_lji.lji151,  #TQC-C40061 add
          g_lji.lji161
     FROM lja_file
    WHERE lja01 = g_lji.lji03
    
   CASE g_lji.lji02 
      WHEN '2'
         DISPLAY BY NAME g_lji.lji381  
      WHEN '3'
         DISPLAY BY NAME g_lji.lji27 
      WHEN '4'
         DISPLAY BY NAME g_lji.lji28,g_lji.lji141,g_lji.lji151,g_lji.lji161 
      WHEN '5'
         SELECT lje14 INTO g_lji.lji29
           FROM lje_file
          WHERE lje01 = g_lji.lji03 
        DISPLAY BY NAME g_lji.lji29 
   END CASE
   
   IF g_lji.lji02 = '4' THEN 
      #TQC-C40061--start mark-------------------------------------
      #SELECT lib091,lib101,lib111 INTO l_lib091,l_lib101,l_lib111   
      # FROM lib_file
      # WHERE lib04 = g_lji.lji03
      #TQC-C40061--end mark---------------------------------------
      
      #TQC-C40061--start add--------------------------------------
      SELECT lmf09,lmf10,lmf11 INTO l_lib091,l_lib101,l_lib111
        FROM lmf_file
       WHERE lmf01 = g_lji.lji08  
      #TQC-C40061--end add----------------------------------------

      IF l_lib091 <> g_lji.lji141 OR l_lib101 <> g_lji.lji151 
         OR l_lib111 <> g_lji.lji161 THEN 
         LET g_errno = 'alm1138'
      END IF 
   END IF 

    
END FUNCTION

#合同变更单中合同版本号加1
FUNCTION t410_lji05()
   SELECT lnt02 INTO g_lji.lji05
     FROM lnt_file
    WHERE lnt01 = g_lji.lji04

   IF cl_null(g_lji.lji05) THEN 
      LET g_lji.lji05 = 1
   ELSE 
      LET g_lji.lji05 = g_lji.lji05+1
   END IF 
   DISPLAY BY NAME g_lji.lji05 
END FUNCTION

#更新单头费用栏位的值
FUNCTION t410_upd()
   DEFINE l_sum_ljp06   LIKE ljp_file.ljp06,
          l_sum_ljp06_1 LIKE ljp_file.ljp06,
          l_sum_ljp06_2 LIKE ljp_file.ljp06,
          l_sum_ljp06_3 LIKE ljp_file.ljp06

   SELECT SUM(ljp06) INTO l_sum_ljp06                       #抓取标准费用金额总和 
     FROM ljp_file
    WHERE ljp01 = g_lji.lji01
      AND ljp08 = '1'

   IF cl_null(l_sum_ljp06) THEN
      LET l_sum_ljp06 = 0
   END IF 

   SELECT SUM(ljp06) INTO l_sum_ljp06_1                     #抓取优惠费用金额总和
     FROM ljp_file 
    WHERE ljp01 = g_lji.lji01
      AND ljp08 = '2'

   IF cl_null(l_sum_ljp06_1) THEN
      LET l_sum_ljp06_1 = 0
   END IF

   SELECT SUM(ljp06) INTO l_sum_ljp06_2                     #抓取终止费用金额总和
     FROM ljp_file
    WHERE ljp01 = g_lji.lji01
      AND ljp08 = '3'

   IF cl_null(l_sum_ljp06_2) THEN
      LET l_sum_ljp06_2 = 0
   END IF

   SELECT SUM(ljp06) INTO l_sum_ljp06_3                     #抓取抹零费用金额总和
     FROM ljp_file
    WHERE ljp01 = g_lji.lji01
      AND ljp08 = '4'

   IF cl_null(l_sum_ljp06_3) THEN
      LET l_sum_ljp06_3 = 0
   END IF
   
   SELECT SUM(ljp06) INTO g_lji.lji34                        #抓取质保金费用总和
     FROM ljp_file 
    WHERE ljp01 = g_lji.lji01
      AND ljp08 = '1'
      AND ljp05 IN (SELECT ljm04 FROM ljm_file,oaj_file 
                     WHERE ljm01 = g_lji.lji01
                       AND oaj01 = ljm04
                       AND oaj05 = '01')
                                                        
   IF cl_null(g_lji.lji34) THEN
      LET g_lji.lji34 = 0
   END IF

   LET g_lji.lji32 = l_sum_ljp06 - g_lji.lji34
   LET g_lji.lji33 = l_sum_ljp06_1
   LET g_lji.lji35 = l_sum_ljp06_2
   LET g_lji.lji36 = l_sum_ljp06_3
  #LET g_lji.lji37 = g_lji.lji32 + g_lji.lji33 + g_lji.lji34 +                             #FUN-C80006 mark
  #                  g_lji.lji35 + g_lji.lji36                                             #FUN-C80006 mark
   LET g_lji.lji37 = g_lji.lji32 - g_lji.lji33 + g_lji.lji34 + g_lji.lji35 + g_lji.lji36   #FUN-C80006 add
   UPDATE lji_file SET lji32 = g_lji.lji32,
                       lji33 = g_lji.lji33,
                       lji34 = g_lji.lji34,
                       lji35 = g_lji.lji35,
                       lji36 = g_lji.lji36,
                       lji37 = g_lji.lji37
                 WHERE lji01 = g_lji.lji01
   SELECT * INTO g_lji.* FROM lji_file WHERE lji01 = g_lji.lji01   
   DISPLAY BY NAME g_lji.lji32,g_lji.lji33,g_lji.lji34,g_lji.lji35,
                   g_lji.lji36,g_lji.lji37
END FUNCTION 

#檢查合同是否到期，如果到期不可以终止
FUNCTION t410_lji04_check(p_flagb)
   DEFINE l_n            LIKE type_file.num5,
          p_flagb        LIKE type_file.chr1

   LET g_errno = ''

   IF g_lji.lji02 = '3' THEN
      IF g_today > g_lji.lji27 THEN
         LET g_errno = 'alm1133'  
      END IF  
   ELSE
      IF g_today > g_lji.lji26 THEN
         CASE g_lji.lji02
            WHEN '1'
               LET g_errno = 'alm1134'
            WHEN '2'
               LET g_errno = 'alm1135'
            WHEN '4'
               LET g_errno = 'alm1136'
            WHEN '5'
               LET g_errno = 'alm1137'
         END CASE
      END IF   
   END IF

  # IF g_lji.lji02 = '4' THEN 
  #    SELECT lib091,lib101,lib111 
  #      INTO l_lib091,l_lib101,l_lib111
  #      FROM lib_file
  #     WHERE lib01 = g_lji.lji08

  #    IF g_lji.lji141 <> l_lib091 OR g_lji.lji151 <> l_lib101
  #       OR g_lji.lji161 <> l_lib111 THEN
  #       LET g_errno = 'alm1138'
  #    END IF       
  # END IF     

   IF p_flagb = '1' THEN 
      SELECT COUNT(*) INTO l_n
        FROM lji_file
       WHERE lji04 = g_lji.lji04
         AND lji43 <> '2'
         AND lji05 <> 0
         AND ljiconf <> 'A' AND ljiconf <> 'B' #TQC-C20528 Add
         AND ljiconf <> 'X' #CHI-C80041
      IF l_n >0 THEN 
         LET g_errno = 'alm1197'
         RETURN
      END IF  

      LET l_n = 0
      SELECT count(*) INTO l_n
        FROM lji_file
       WHERE lji03 = g_lji.lji03
         AND ljiconf <> 'A' AND ljiconf <> 'B' #TQC-C20528 Add
         AND ljiconf <> 'X' #CHI-C80041
      IF l_n > 0 THEN
         LET g_errno = 'alm1282'
         RETURN
      END IF

      LET l_n = 0
      IF g_lji.lji02 = '5' THEN 
         SELECT count(*) INTO l_n
           FROM lji_file
          WHERE lji04 = g_lji.lji04
            AND lji02 = '5'
            AND ljiconf <> 'X' #CHI-C80041

         IF l_n >0 THEN 
            LET g_errno = 'alm1283'
            RETURN
         END IF 
      END IF 

   END IF 
 
END FUNCTION

#由合同编号带出合同的相关栏位信息
FUNCTION t410_lji04(p_cmd,p_flag)
   DEFINE p_cmd        LIKE type_file.chr1,
          p_flag       LIKE type_file.chr1,   
          l_lntacti    LIKE lnt_file.lntacti
    
   LET g_errno = ''
   
   IF NOT cl_null(g_lji.lji04) THEN    #TQC-C40061 add
      SELECT lnt03,lnt04,lnt06,lnt56,lnt55,lnt16,lnt57,lnt54,lnt45,lnt58,lnt59,
             lnt08,lnt09,lnt60,lnt11,lnt61,lnt10,lnt17,lnt18,lnt51,lnt21,lnt22,
             lnt64,lnt65,lnt66,lnt67,lnt68,lnt69,lnt30,lnt31,lnt32,lnt33,lnt35,
             lnt36,lnt37,lnt70,lnt71,lnt72,lntacti
        INTO g_lji.lji06,g_lji.lji07,g_lji.lji08,g_lji.lji10,g_lji.lji09,
             g_lji.lji17,g_lji.lji48,g_lji.lji18,g_lji.lji19,g_lji.lji20,
             g_lji.lji21,g_lji.lji11,g_lji.lji12,g_lji.lji13,g_lji.lji14,
             g_lji.lji15,g_lji.lji16,g_lji.lji22,g_lji.lji23,g_lji.lji24,
             g_lji.lji25,g_lji.lji26,g_lji.lji32,g_lji.lji33,g_lji.lji34,
             g_lji.lji35,g_lji.lji36,g_lji.lji37,g_lji.lji38,g_lji.lji49,
             g_lji.lji50,g_lji.lji51,g_lji.lji52,g_lji.lji53,g_lji.lji54,
             g_lji.lji39,g_lji.lji40,g_lji.lji41,l_lntacti
        FROM lnt_file
       WHERE lnt01 = g_lji.lji04     
   #TQC-C40061--start add--------------------------
   ELSE
      LET g_lji.lji06 = null
      LET g_lji.lji07 = null
      LET g_lji.lji08 = null
      LET g_lji.lji09 = null
      LET g_lji.lji10 = null
      LET g_lji.lji17 = null
      LET g_lji.lji48 = null
      LET g_lji.lji18 = null
      LET g_lji.lji19 = null
      LET g_lji.lji20 = null
      LET g_lji.lji21 = null
      LET g_lji.lji11 = null
      LET g_lji.lji12 = null      
      LET g_lji.lji13 = null
      LET g_lji.lji14 = null
      LET g_lji.lji15 = null
      LET g_lji.lji16 = null
      LET g_lji.lji22 = null
      LET g_lji.lji23 = null
      LET g_lji.lji24 = null
      LET g_lji.lji25 = null
      LET g_lji.lji26 = null
      LET g_lji.lji32 = null
      LET g_lji.lji33 = null
      LET g_lji.lji34 = null
      LET g_lji.lji35 = null
      LET g_lji.lji36 = null
      LET g_lji.lji37 = null
      LET g_lji.lji38 = null
      LET g_lji.lji49 = null
      LET g_lji.lji50 = null
      LET g_lji.lji51 = null
      LET g_lji.lji52 = null
      LET g_lji.lji53 = null 
      LET g_lji.lji54 = null
      LET g_lji.lji39 = null
      LET g_lji.lji40 = null
      LET g_lji.lji41 = null
   END IF 
   #TQC-C40061--end add----------------------------

   CASE 
      WHEN SQLCA.SQLCODE = 100  
         LET g_errno = 'alm1124' 
      WHEN l_lntacti = 'N'
         LET g_errno = 'alm1125'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF p_flag = '1' THEN
         CALL t410_lji04_check('1')
      END IF 
 
      DISPLAY BY NAME g_lji.lji06,g_lji.lji07,g_lji.lji08,g_lji.lji10,
                      g_lji.lji09,g_lji.lji17,g_lji.lji48,g_lji.lji18,
                      g_lji.lji19,g_lji.lji20,g_lji.lji21,g_lji.lji11,
                      g_lji.lji12,g_lji.lji13,g_lji.lji14,g_lji.lji15,
                      g_lji.lji16,g_lji.lji22,g_lji.lji23,g_lji.lji24,
                      g_lji.lji25,g_lji.lji26,g_lji.lji32,g_lji.lji33,
                      g_lji.lji34,g_lji.lji35,g_lji.lji36,g_lji.lji37,
                      g_lji.lji38,g_lji.lji49,g_lji.lji50,g_lji.lji51,
                      g_lji.lji52,g_lji.lji53,g_lji.lji54,g_lji.lji39,
                      g_lji.lji39,g_lji.lji40,g_lji.lji41
   END IF 
END FUNCTION

#有商户编号带出商户相关信息
FUNCTION t410_lji07()
   DEFINE l_lne05     LIKE lne_file.lne05,
          l_lne14     LIKE lne_file.lne14,
          l_lne15     LIKE lne_file.lne15,
          l_lne43     LIKE lne_file.lne43,
          l_lne44     LIKE lne_file.lne44,
          l_lne22     LIKE lne_file.lne22,
          l_lne50     LIKE lne_file.lne50,
          l_lne51     LIKE lne_file.lne51,
          l_lne52     LIKE lne_file.lne52,
          l_lne53     LIKE lne_file.lne53
          
   SELECT lne05,lne14,lne15,lne43,lne44,lne22,lne50,lne51,lne52,lne53
     INTO l_lne05,l_lne14,l_lne15,l_lne43,l_lne44,l_lne22,l_lne50,l_lne51,
          l_lne52,l_lne53
     FROM lne_file
    WHERE lne01 = g_lji.lji07 

   DISPLAY l_lne05,l_lne14,l_lne15,l_lne43,l_lne44,l_lne22,l_lne50,l_lne51,
           l_lne52,l_lne53
        TO FORMONLY.lne05,FORMONLY.lne14,FORMONLY.lne15,FORMONLY.lne43,
           FORMONLY.lne44,FORMONLY.lne22,FORMONLY.lne50,FORMONLY.lne51,
           FORMONLY.lne52,FORMONLY.lne53     
END FUNCTION

#带出相关人员名称
FUNCTION t410_gen02(p_gen01,p_cmd)
   DEFINE l_gen02     LIKE gen_file.gen02,
          p_gen01     LIKE gen_file.gen01, 
          l_genacti   LIKE gen_file.genacti,
          p_cmd       LIKE type_file.chr1,
          l_gen03     LIKE gen_file.gen03,
          l_gem02     LIKE gem_file.gem02

   LET g_errno = ''

   SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
     FROM gen_file
    WHERE gen01 =p_gen01

   CASE 
      WHEN SQLCA.SQLCODE = 100 
         LET g_errno = 'apj-062' 
      WHEN l_genacti <> 'Y'
         LET g_errno = 'art-733'
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF p_gen01 = g_lji.lji30 THEN
         IF NOT cl_null(l_gen03) THEN
            SELECT gem02 INTO l_gem02
              FROM gem_file
             WHERE gem01 = l_gen03
            
            LET g_lji.lji31 = l_gen03         
            DISPLAY BY NAME g_lji.lji31
            DISPLAY l_gem02 TO FORMONLY.gem02
         END IF   
         DISPLAY l_gen02 TO FORMONLY.gen02_2
      END IF 
     
      IF p_gen01 = g_lji.lji44 THEN
         DISPLAY l_gen02 TO FORMONLY.gen02
      END IF

      IF p_gen01 = g_lji.lji46 THEN
         DISPLAY l_gen02 TO FORMONLY.gen02_1
      END IF  

      IF cl_null(g_lji.lji30) THEN 
         DISPLAY '' TO FORMONLY.gen02_2
      END IF 

      IF cl_null(g_lji.lji44) THEN
         DISPLAY '' TO FORMONLY.gen02
      END IF 

      IF cl_null(g_lji.lji46) THEN 
         DISPLAY '' TO FORMONLY.gen02_1
      END IF 
   END IF    
END FUNCTION

#带出部门名称
FUNCTION t410_gem02(p_cmd)
   DEFINE l_gem02     LIKE gem_file.gem02,
          l_gemacti   LIKE gem_file.gemacti,
          p_cmd       LIKE type_file.chr1,
          l_n         LIKE type_file.num5

   LET g_errno = ''
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 =g_lji.lji31

   CASE 
      WHEN SQLCA.SQLCODE = 100 
         LET g_errno = 'apy-070' 
      WHEN l_gemacti <> 'Y'
         LET g_errno = 'asf-472'
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF NOT cl_null(g_lji.lji30) THEN
      SELECT COUNT(*) INTO l_n
        FROM gen_file
       WHERE gen01 = g_lji.lji30
         AND gen03 = g_lji.lji31

      IF l_n = 0 THEN
         LET g_errno = 'mfg3202'
      END IF  
   END IF 

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION

#帶出品牌名稱
FUNCTION t410_lji_tqa02(p_tqa01)
   DEFINE l_tqa02       LIKE tqa_file.tqa02,
          p_tqa01       LIKE tqa_file.tqa01,
          l_tqaacti     LIKE tqa_file.tqaacti

   SELECT tqa02 INTO l_tqa02 
     FROM tqa_file
    WHERE tqa01 = p_tqa01
      AND tqa03 =  '2'
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-046'
                               LET l_tqa02 = ''
      WHEN l_tqaacti <> 'Y'    LET g_errno = 'alm-139'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  
   IF cl_null(g_errno) THEN
      IF p_tqa01 = g_lji.lji38 THEN
         DISPLAY l_tqa02 TO FORMONLY.tqa02_1
      END IF 

      IF p_tqa01 = g_lji.lji381 THEN
         DISPLAY l_tqa02 TO FORMONLY.tqa02_2
      END IF 
     
      IF cl_null(g_lji.lji38) THEN
         DISPLAY '' TO FORMONLY.tqa02_1 
      END IF   

      IF cl_null(g_lji.lji381) THEN
         DISPLAY '' TO FORMONLY.tqa02_2 
      END IF 
   END IF    
END FUNCTION

#帶出費用名稱和費用性質
FUNCTION t410_oaj(p_oaj01)
   DEFINE p_oaj01     LIKE oaj_file.oaj01,
          l_oaj02     LIKE oaj_file.oaj02,
          l_oaj05     LIKE oaj_file.oaj05

   SELECT oaj02,oaj05 INTO l_oaj02,l_oaj05
     FROM oaj_file
    WHERE oaj01 = p_oaj01

   CASE g_flag
      WHEN '1' 
         LET g_ljj[g_cnt].oaj02 = l_oaj02
         LET g_ljj[g_cnt].oaj05 = l_oaj05 

      WHEN '2' 
         LET g_ljk[g_cnt].oaj02_1 = l_oaj02
         LET g_ljk[g_cnt].oaj05_1 = l_oaj05

      WHEN '3' 
         LET g_ljl[g_cnt].oaj02_2 = l_oaj02
         LET g_ljl[g_cnt].oaj05_2 = l_oaj05

      WHEN '4' 
         LET g_ljm[g_cnt].oaj02_3 = l_oaj02
         LET g_ljm[g_cnt].oaj05_3 = l_oaj05
   END CASE
END FUNCTION

#帶出付款方式名稱
FUNCTION t410_lnr()
   DEFINE l_lnr02   LIKE lnr_file.lnr02

   SELECT lnr02 INTO l_lnr02 
     FROM lnr_file
    WHERE lnr01 = g_ljm[g_cnt].ljm05

   LET g_ljm[g_cnt].lnr02 = l_lnr02 
END FUNCTION

#帶出樓棟、樓層、區域名稱
FUNCTION t410_bfa(p_lmb02,p_lmc03,p_lmy03,p_cmd)
   DEFINE l_lmb03       LIKE lmb_file.lmb03,
          p_lmb02       LIKE lmb_file.lmb03,
          l_lmc04       LIKE lmc_file.lmc04,
          p_lmc03       LIKE lmc_file.lmc03,
          l_lmy04       LIKE lmy_file.lmy04,
          p_lmy03       LIKE lmy_file.lmy03,
          p_cmd         LIKE type_file.chr1

          
    SELECT lmb03 INTO l_lmb03 
      FROM lmb_file
     WHERE lmb02 = p_lmb02

    SELECT lmc04 INTO l_lmc04
      FROM lmc_file
     WHERE lmc02 = p_lmb02
       AND lmc03 = p_lmc03

    SELECT lmy04 INTO l_lmy04
      FROM lmy_file
     WHERE lmy01 = p_lmb02
       AND lmy02 = p_lmc03
       AND lmy03 = p_lmy03

   IF p_cmd = '2' THEN    
      LET g_ljn[g_cnt].lmb03 = l_lmb03
      LET g_ljn[g_cnt].lmc04 = l_lmc04
      LET g_ljn[g_cnt].lmy04 = l_lmy04
   ELSE
      DISPLAY l_lmb03 TO FORMONLY.lmb03_1
      DISPLAY l_lmc04 TO FORMONLY.lmc04_1
      DISPLAY l_lmy04 TO FORMONLY.lmy04_1   
   END IF
END FUNCTION


#帶出攤位用途名稱
FUNCTION t410_lji09_tqa02()
   DEFINE l_tqa02       LIKE tqa_file.tqa02
   
   SELECT tqa02 INTO l_tqa02
     FROM tqa_file 
    WHERE tqa01 = g_lji.lji09
      AND tqa03 = '30'

   DISPLAY l_tqa02 TO FORMONLY.tqa02_3  
END FUNCTION

#小类从摊位基本资料维护作业中抓取单身中对应的小类
FUNCTION t410_oba02()
   DEFINE l_lml02        LIKE lml_file.lml02,  # 摊位中小类
          l_oba02        LIKE oba_file.oba02,  # 分类名称 
          l_oba13        LIKE oba_file.oba13,  # 上级分类
          l_oba13_2      LIKE oba_file.oba13,       
          l_oba15        LIKE oba_file.oba15   # 所属一级分类

   SELECT lml02 INTO l_lml02 
     FROM lml_file
    WHERE lml01 = g_lji.lji08

   SELECT oba02,oba13,oba14,oba15 INTO l_oba02,l_oba13,l_oba15
     FROM oba_file
    WHERE oba01 = l_lml02

   IF cl_null(l_oba13) THEN
      DISPLAY l_oba02 TO FORMONLY.oba02_2
      DISPLAY l_oba02 TO FORMONLY.oba02_1
      DISPLAY l_oba02 TO FORMONLY.oba02
   ELSE
      DISPLAY l_oba02 TO FORMONLY.oba02_2
      
      SELECT oba02,oba13 INTO l_oba02,l_oba13_2
        FROM oba_file
       WHERE oba01 = l_oba13
      IF cl_null(l_oba13) THEN
         DISPLAY l_oba02 TO FORMONLY.oba02_1
         DISPLAY l_oba02 TO FORMONLY.oba02
      ELSE
         DISPLAY l_oba02 TO FORMONLY.oba02_1
         
         SELECT oba02 INTO l_oba02 
           FROM oba_file
          WHERE oba01 = l_oba15
         DISPLAY l_oba02 TO FORMONLY.oba02 
      END IF 
   END IF
END FUNCTION
 
FUNCTION t410_status()
   SELECT ljiconf,lji44,lji45,lji46,lji47,lji43 
     INTO g_lji.ljiconf,g_lji.lji44,g_lji.lji45,
          g_lji.lji46,g_lji.lji47,g_lji.lji43
     FROM lji_file
    WHERE lji01 = g_lji.lji01
   DISPLAY BY NAME g_lji.ljiconf,g_lji.lji44,g_lji.lji45,
                   g_lji.lji46,g_lji.lji47,g_lji.lji43
   #CALL cl_set_field_pic(g_lji.ljiconf,"","","","","") #CHI-C80041
   IF g_lji.ljiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lji.ljiconf,"","","",g_void,"")  #CHI-C80041   
END FUNCTION
#FUN-BA0118
#CHI-C80041---begin
FUNCTION t410_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lji.lji01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t410_cl USING g_lji.lji01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t410_cl INTO g_lji.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lji.lji01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t410_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lji.ljiconf <> 'N' AND g_lji.ljiconf <> 'X' THEN CALL cl_err('','alm1365',0) RETURN END IF 
   IF cl_void(0,0,g_lji.ljiconf)   THEN 
        LET l_chr=g_lji.ljiconf
        IF g_lji.ljiconf='N' THEN 
            LET g_lji.ljiconf='X' 
        ELSE
            LET g_lji.ljiconf='N'
        END IF
        UPDATE lji_file
            SET ljiconf=g_lji.ljiconf,  
                ljimodu=g_user,
                ljidate=g_today
            WHERE lji01=g_lji.lji01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lji_file",g_lji.lji01,"",SQLCA.sqlcode,"","",1)  
            LET g_lji.ljiconf=l_chr 
        END IF
        DISPLAY BY NAME g_lji.ljiconf
   END IF
 
   CLOSE t410_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lji.lji01,'V')
 
END FUNCTION
#CHI-C80041---end
