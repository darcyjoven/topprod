# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: cxcq900.4gl
# Descriptions...: 工费分配表
# Date & Author..: 17/07/18         By luoyb

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

TYPE t_ta_cck          RECORD                                    #记录集
       ta_cck03           LIKE ima_file.ima01,
       ima02              LIKE ima_file.ima02,
       ima021             LIKE ima_file.ima021,
       ta_cck11           LIKE ecu_file.ecu02,   #170723 luoyb
       ta_cck09           LIKE sfb_file.sfb09,
       ta_cck10_1        LIKE type_file.num20_6,
       ta_cck05_1        LIKE type_file.num20_6,
       ta_cck06a_1        LIKE type_file.num20_6,
       ta_cck07a_1        LIKE type_file.num20_6,
       ta_cck08a_1        LIKE type_file.num20_6,
       ta_cck10_2        LIKE type_file.num20_6,
       ta_cck05_2        LIKE type_file.num20_6,
       ta_cck06a_2        LIKE type_file.num20_6,
       ta_cck07a_2        LIKE type_file.num20_6,
       ta_cck08a_2        LIKE type_file.num20_6,
       ta_cck10_3        LIKE type_file.num20_6,
       ta_cck05_3        LIKE type_file.num20_6,
       ta_cck06a_3        LIKE type_file.num20_6,
       ta_cck07a_3        LIKE type_file.num20_6,
       ta_cck08a_3        LIKE type_file.num20_6,
       ta_cck10_4        LIKE type_file.num20_6,
       ta_cck05_4        LIKE type_file.num20_6,
       ta_cck06a_4        LIKE type_file.num20_6,
       ta_cck07a_4        LIKE type_file.num20_6,
       ta_cck08a_4        LIKE type_file.num20_6,
       ta_cck10_5        LIKE type_file.num20_6,
       ta_cck05_5        LIKE type_file.num20_6,
       ta_cck06a_5        LIKE type_file.num20_6,
       ta_cck07a_5        LIKE type_file.num20_6,
       ta_cck08a_5        LIKE type_file.num20_6,
       ta_cck10_6        LIKE type_file.num20_6,
       ta_cck05_6        LIKE type_file.num20_6,
       ta_cck06a_6        LIKE type_file.num20_6,
       ta_cck07a_6        LIKE type_file.num20_6,
       ta_cck08a_6        LIKE type_file.num20_6,
       ta_cck10_7        LIKE type_file.num20_6,
       ta_cck05_7        LIKE type_file.num20_6,
       ta_cck06a_7        LIKE type_file.num20_6,
       ta_cck07a_7        LIKE type_file.num20_6,
       ta_cck08a_7        LIKE type_file.num20_6,
       ta_cck10_8        LIKE type_file.num20_6,
       ta_cck05_8        LIKE type_file.num20_6,
       ta_cck06a_8        LIKE type_file.num20_6,
       ta_cck07a_8        LIKE type_file.num20_6,
       ta_cck08a_8        LIKE type_file.num20_6,
       ta_cck10_9        LIKE type_file.num20_6,
       ta_cck05_9        LIKE type_file.num20_6,
       ta_cck06a_9        LIKE type_file.num20_6,
       ta_cck07a_9        LIKE type_file.num20_6,
       ta_cck08a_9        LIKE type_file.num20_6,
       ta_cck10_10        LIKE type_file.num20_6,
       ta_cck05_10        LIKE type_file.num20_6,
       ta_cck06a_10        LIKE type_file.num20_6,
       ta_cck07a_10        LIKE type_file.num20_6,
       ta_cck08a_10        LIKE type_file.num20_6,
       ta_cck10_11        LIKE type_file.num20_6,
       ta_cck05_11        LIKE type_file.num20_6,
       ta_cck06a_11        LIKE type_file.num20_6,
       ta_cck07a_11        LIKE type_file.num20_6,
       ta_cck08a_11        LIKE type_file.num20_6,
       ta_cck10_12        LIKE type_file.num20_6,
       ta_cck05_12        LIKE type_file.num20_6,
       ta_cck06a_12        LIKE type_file.num20_6,
       ta_cck07a_12        LIKE type_file.num20_6,
       ta_cck08a_12        LIKE type_file.num20_6,
       ta_cck10_13        LIKE type_file.num20_6,
       ta_cck05_13        LIKE type_file.num20_6,
       ta_cck06a_13        LIKE type_file.num20_6,
       ta_cck07a_13        LIKE type_file.num20_6,
       ta_cck08a_13        LIKE type_file.num20_6,
       ta_cck10_14        LIKE type_file.num20_6,
       ta_cck05_14        LIKE type_file.num20_6,
       ta_cck06a_14        LIKE type_file.num20_6,
       ta_cck07a_14        LIKE type_file.num20_6,
       ta_cck08a_14        LIKE type_file.num20_6,
       ta_cck10_15        LIKE type_file.num20_6,
       ta_cck05_15        LIKE type_file.num20_6,
       ta_cck06a_15        LIKE type_file.num20_6,
       ta_cck07a_15        LIKE type_file.num20_6,
       ta_cck08a_15        LIKE type_file.num20_6,
       ta_cck10_16        LIKE type_file.num20_6,
       ta_cck05_16        LIKE type_file.num20_6,
       ta_cck06a_16        LIKE type_file.num20_6,
       ta_cck07a_16        LIKE type_file.num20_6,
       ta_cck08a_16        LIKE type_file.num20_6,
       ta_cck10_17        LIKE type_file.num20_6,
       ta_cck05_17        LIKE type_file.num20_6,
       ta_cck06a_17        LIKE type_file.num20_6,
       ta_cck07a_17        LIKE type_file.num20_6,
       ta_cck08a_17        LIKE type_file.num20_6,
       ta_cck10_18        LIKE type_file.num20_6,
       ta_cck05_18        LIKE type_file.num20_6,
       ta_cck06a_18        LIKE type_file.num20_6,
       ta_cck07a_18        LIKE type_file.num20_6,
       ta_cck08a_18        LIKE type_file.num20_6,
       ta_cck10_19        LIKE type_file.num20_6,
       ta_cck05_19        LIKE type_file.num20_6,
       ta_cck06a_19        LIKE type_file.num20_6,
       ta_cck07a_19        LIKE type_file.num20_6,
       ta_cck08a_19        LIKE type_file.num20_6,
       ta_cck10_20        LIKE type_file.num20_6,
       ta_cck05_20        LIKE type_file.num20_6,
       ta_cck06a_20        LIKE type_file.num20_6,
       ta_cck07a_20        LIKE type_file.num20_6,
       ta_cck08a_20        LIKE type_file.num20_6,
       ta_cck10_21        LIKE type_file.num20_6,
       ta_cck05_21        LIKE type_file.num20_6,
       ta_cck06a_21        LIKE type_file.num20_6,
       ta_cck07a_21        LIKE type_file.num20_6,
       ta_cck08a_21        LIKE type_file.num20_6,
       ta_cck10_22        LIKE type_file.num20_6,
       ta_cck05_22        LIKE type_file.num20_6,
       ta_cck06a_22        LIKE type_file.num20_6,
       ta_cck07a_22        LIKE type_file.num20_6,
       ta_cck08a_22        LIKE type_file.num20_6,
       ta_cck10_23        LIKE type_file.num20_6,
       ta_cck05_23        LIKE type_file.num20_6,
       ta_cck06a_23        LIKE type_file.num20_6,
       ta_cck07a_23        LIKE type_file.num20_6,
       ta_cck08a_23        LIKE type_file.num20_6,
       ta_cck10_24        LIKE type_file.num20_6,
       ta_cck05_24        LIKE type_file.num20_6,
       ta_cck06a_24        LIKE type_file.num20_6,
       ta_cck07a_24        LIKE type_file.num20_6,
       ta_cck08a_24        LIKE type_file.num20_6,
       ta_cck10_25        LIKE type_file.num20_6,
       ta_cck05_25        LIKE type_file.num20_6,
       ta_cck06a_25        LIKE type_file.num20_6,
       ta_cck07a_25        LIKE type_file.num20_6,
       ta_cck08a_25        LIKE type_file.num20_6,
       ta_cck10_26        LIKE type_file.num20_6,
       ta_cck05_26        LIKE type_file.num20_6,
       ta_cck06a_26        LIKE type_file.num20_6,
       ta_cck07a_26        LIKE type_file.num20_6,
       ta_cck08a_26        LIKE type_file.num20_6,
       ta_cck10_27        LIKE type_file.num20_6,
       ta_cck05_27        LIKE type_file.num20_6,
       ta_cck06a_27        LIKE type_file.num20_6,
       ta_cck07a_27        LIKE type_file.num20_6,
       ta_cck08a_27        LIKE type_file.num20_6,
       ta_cck10_28        LIKE type_file.num20_6,
       ta_cck05_28        LIKE type_file.num20_6,
       ta_cck06a_28        LIKE type_file.num20_6,
       ta_cck07a_28        LIKE type_file.num20_6,
       ta_cck08a_28        LIKE type_file.num20_6,
       ta_cck10_29        LIKE type_file.num20_6,
       ta_cck05_29        LIKE type_file.num20_6,
       ta_cck06a_29        LIKE type_file.num20_6,
       ta_cck07a_29        LIKE type_file.num20_6,
       ta_cck08a_29        LIKE type_file.num20_6,
       ta_cck10_30        LIKE type_file.num20_6,
       ta_cck05_30        LIKE type_file.num20_6,
       ta_cck06a_30        LIKE type_file.num20_6,
       ta_cck07a_30        LIKE type_file.num20_6,
       ta_cck08a_30        LIKE type_file.num20_6
       #darcy:2023/05/22 add s---
      ,ta_cck10_31         like type_file.num20_6,
      ta_cck05_31         like type_file.num20_6,
      ta_cck06a_31        like type_file.num20_6,
      ta_cck07a_31        like type_file.num20_6,
      ta_cck08a_31        like type_file.num20_6,
      ta_cck10_32         like type_file.num20_6,
      ta_cck05_32         like type_file.num20_6,
      ta_cck06a_32        like type_file.num20_6,
      ta_cck07a_32        like type_file.num20_6,
      ta_cck08a_32        like type_file.num20_6,
      ta_cck10_33         like type_file.num20_6,
      ta_cck05_33         like type_file.num20_6,
      ta_cck06a_33        like type_file.num20_6,
      ta_cck07a_33        like type_file.num20_6,
      ta_cck08a_33        like type_file.num20_6,
      ta_cck10_34         like type_file.num20_6,
      ta_cck05_34         like type_file.num20_6,
      ta_cck06a_34        like type_file.num20_6,
      ta_cck07a_34        like type_file.num20_6,
      ta_cck08a_34        like type_file.num20_6,
      ta_cck10_35         like type_file.num20_6,
      ta_cck05_35         like type_file.num20_6,
      ta_cck06a_35        like type_file.num20_6,
      ta_cck07a_35        like type_file.num20_6,
      ta_cck08a_35        like type_file.num20_6,
      ta_cck10_36         like type_file.num20_6,
      ta_cck05_36         like type_file.num20_6,
      ta_cck06a_36        like type_file.num20_6,
      ta_cck07a_36        like type_file.num20_6,
      ta_cck08a_36        like type_file.num20_6,
      ta_cck10_37         like type_file.num20_6,
      ta_cck05_37         like type_file.num20_6,
      ta_cck06a_37        like type_file.num20_6,
      ta_cck07a_37        like type_file.num20_6,
      ta_cck08a_37        like type_file.num20_6,
      ta_cck10_38         like type_file.num20_6,
      ta_cck05_38         like type_file.num20_6,
      ta_cck06a_38        like type_file.num20_6,
      ta_cck07a_38        like type_file.num20_6,
      ta_cck08a_38        like type_file.num20_6,
      ta_cck10_39         like type_file.num20_6,
      ta_cck05_39         like type_file.num20_6,
      ta_cck06a_39        like type_file.num20_6,
      ta_cck07a_39        like type_file.num20_6,
      ta_cck08a_39        like type_file.num20_6,
      ta_cck10_40         like type_file.num20_6,
      ta_cck05_40         like type_file.num20_6,
      ta_cck06a_40        like type_file.num20_6,
      ta_cck07a_40        like type_file.num20_6,
      ta_cck08a_40        like type_file.num20_6
       #darcy:2023/05/22 add e---
                         END RECORD
                         
DEFINE g_ta_cck            DYNAMIC ARRAY OF t_ta_cck               #单身全局
DEFINE tm                  RECORD
       wc                  STRING,
       yy                  LIKE type_file.num5,
       mm                  LIKE type_file.num5
                         END RECORD
DEFINE ta_cck_cnt          LIKE type_file.num10                       #单身总笔数
DEFINE ta_cck_ac           LIKE type_file.num10                       #光标所在NO.
DEFINE g_sql               STRING                                     #定义sql
DEFINE ta_cck_wc           STRING                                     #定义CONSTRUCT接受变量
DEFINE g_forupd_sql        STRING                                     #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done STRING                                     #判斷是否已執行 Before Input指令
DEFINE g_cnt               LIKE type_file.num10                       #定义ima_file笔数
DEFINE g_rec_b             LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10                       #获取Fetch当前笔index
DEFINE g_row_count         LIKE type_file.num10                       #获取Fetch总笔数
DEFINE g_jump              LIKE type_file.num10                       #跳转Fetch指定index
DEFINE g_no_ask            LIKE type_file.num10                       #是否开启指定笔視窗
DEFINE g_msg               LIKE type_file.chr1000                     #错误信息
DEFINE g_statebar          STRING                                     #笔数变量
DEFINE g_argv1	           LIKE type_file.num5          
DEFINE g_ta_cck_attr DYNAMIC ARRAY OF RECORD    #NO.160328 add 
       ta_cck03          STRING,
       ima02             STRING,
       ima021            STRING,
       ta_cck11          STRING,   #170723 luoyb
       ta_cck09          STRING,
       ta_cck10_1        STRING,
       ta_cck05_1        STRING,
       ta_cck06a_1        STRING,
       ta_cck07a_1        STRING,
       ta_cck08a_1        STRING,
       ta_cck10_2        STRING,
       ta_cck05_2        STRING,
       ta_cck06a_2        STRING,
       ta_cck07a_2        STRING,
       ta_cck08a_2        STRING,
       ta_cck10_3        STRING,
       ta_cck05_3        STRING,
       ta_cck06a_3        STRING,
       ta_cck07a_3        STRING,
       ta_cck08a_3        STRING,
       ta_cck10_4        STRING,
       ta_cck05_4        STRING,
       ta_cck06a_4        STRING,
       ta_cck07a_4        STRING,
       ta_cck08a_4        STRING,
       ta_cck10_5        STRING,
       ta_cck05_5        STRING,
       ta_cck06a_5        STRING,
       ta_cck07a_5        STRING,
       ta_cck08a_5        STRING,
       ta_cck10_6        STRING,
       ta_cck05_6        STRING,
       ta_cck06a_6        STRING,
       ta_cck07a_6        STRING,
       ta_cck08a_6        STRING,
       ta_cck10_7        STRING,
       ta_cck05_7        STRING,
       ta_cck06a_7        STRING,
       ta_cck07a_7        STRING,
       ta_cck08a_7        STRING,
       ta_cck10_8        STRING,
       ta_cck05_8        STRING,
       ta_cck06a_8        STRING,
       ta_cck07a_8        STRING,
       ta_cck08a_8        STRING,
       ta_cck10_9        STRING,
       ta_cck05_9        STRING,
       ta_cck06a_9        STRING,
       ta_cck07a_9        STRING,
       ta_cck08a_9        STRING,
       ta_cck10_10        STRING,
       ta_cck05_10        STRING,
       ta_cck06a_10        STRING,
       ta_cck07a_10        STRING,
       ta_cck08a_10        STRING,
       ta_cck10_11        STRING,
       ta_cck05_11        STRING,
       ta_cck06a_11        STRING,
       ta_cck07a_11        STRING,
       ta_cck08a_11        STRING,
       ta_cck10_12        STRING,
       ta_cck05_12        STRING,
       ta_cck06a_12        STRING,
       ta_cck07a_12        STRING,
       ta_cck08a_12        STRING,
       ta_cck10_13        STRING,
       ta_cck05_13        STRING,
       ta_cck06a_13        STRING,
       ta_cck07a_13        STRING,
       ta_cck08a_13        STRING,
       ta_cck10_14        STRING,
       ta_cck05_14        STRING,
       ta_cck06a_14        STRING,
       ta_cck07a_14        STRING,
       ta_cck08a_14        STRING,
       ta_cck10_15        STRING,
       ta_cck05_15        STRING,
       ta_cck06a_15        STRING,
       ta_cck07a_15        STRING,
       ta_cck08a_15        STRING,
       ta_cck10_16        STRING,
       ta_cck05_16        STRING,
       ta_cck06a_16        STRING,
       ta_cck07a_16        STRING,
       ta_cck08a_16        STRING,
       ta_cck10_17        STRING,
       ta_cck05_17        STRING,
       ta_cck06a_17        STRING,
       ta_cck07a_17        STRING,
       ta_cck08a_17        STRING,
       ta_cck10_18        STRING,
       ta_cck05_18        STRING,
       ta_cck06a_18        STRING,
       ta_cck07a_18        STRING,
       ta_cck08a_18        STRING,
       ta_cck10_19        STRING,
       ta_cck05_19        STRING,
       ta_cck06a_19        STRING,
       ta_cck07a_19        STRING,
       ta_cck08a_19        STRING,
       ta_cck10_20        STRING,
       ta_cck05_20        STRING,
       ta_cck06a_20        STRING,
       ta_cck07a_20        STRING,
       ta_cck08a_20        STRING,
       ta_cck10_21        STRING,
       ta_cck05_21        STRING,
       ta_cck06a_21        STRING,
       ta_cck07a_21        STRING,
       ta_cck08a_21        STRING,
       ta_cck10_22        STRING,
       ta_cck05_22        STRING,
       ta_cck06a_22        STRING,
       ta_cck07a_22        STRING,
       ta_cck08a_22        STRING,
       ta_cck10_23        STRING,
       ta_cck05_23        STRING,
       ta_cck06a_23        STRING,
       ta_cck07a_23        STRING,
       ta_cck08a_23        STRING,
       ta_cck10_24        STRING,
       ta_cck05_24        STRING,
       ta_cck06a_24        STRING,
       ta_cck07a_24        STRING,
       ta_cck08a_24        STRING,
       ta_cck10_25        STRING,
       ta_cck05_25        STRING,
       ta_cck06a_25        STRING,
       ta_cck07a_25        STRING,
       ta_cck08a_25        STRING,
       ta_cck10_26        STRING,
       ta_cck05_26        STRING,
       ta_cck06a_26        STRING,
       ta_cck07a_26        STRING,
       ta_cck08a_26        STRING,
       ta_cck10_27        STRING,
       ta_cck05_27        STRING,
       ta_cck06a_27        STRING,
       ta_cck07a_27        STRING,
       ta_cck08a_27        STRING,
       ta_cck10_28        STRING,
       ta_cck05_28        STRING,
       ta_cck06a_28        STRING,
       ta_cck07a_28        STRING,
       ta_cck08a_28        STRING,
       ta_cck10_29        STRING,
       ta_cck05_29        STRING,
       ta_cck06a_29        STRING,
       ta_cck07a_29        STRING,
       ta_cck08a_29        STRING,
       ta_cck10_30        STRING,
       ta_cck05_30        STRING,
       ta_cck06a_30        STRING,
       ta_cck07a_30        STRING,
       ta_cck08a_30        STRING
        #darcy:2023/05/22 add s---
        ,ta_cck10_31         string,
        ta_cck05_31         string,
        ta_cck06a_31        string,
        ta_cck07a_31        string,
        ta_cck08a_31        string,
        ta_cck10_32         string,
        ta_cck05_32         string,
        ta_cck06a_32        string,
        ta_cck07a_32        string,
        ta_cck08a_32        string,
        ta_cck10_33         string,
        ta_cck05_33         string,
        ta_cck06a_33        string,
        ta_cck07a_33        string,
        ta_cck08a_33        string,
        ta_cck10_34         string,
        ta_cck05_34         string,
        ta_cck06a_34        string,
        ta_cck07a_34        string,
        ta_cck08a_34        string,
        ta_cck10_35         string,
        ta_cck05_35         string,
        ta_cck06a_35        string,
        ta_cck07a_35        string,
        ta_cck08a_35        string,
        ta_cck10_36         string,
        ta_cck05_36         string,
        ta_cck06a_36        string,
        ta_cck07a_36       string,
        ta_cck08a_36       string,
        ta_cck10_37         string,
        ta_cck05_37         string,
        ta_cck06a_37        string,
        ta_cck07a_37        string,
        ta_cck08a_37        string,
        ta_cck10_38         string,
        ta_cck05_38         string,
        ta_cck06a_38        string,
        ta_cck07a_38        string,
        ta_cck08a_38        string,
        ta_cck10_39         string,
        ta_cck05_39         string,
        ta_cck06a_39        string,
        ta_cck07a_39        string,
        ta_cck08a_39        string,
        ta_cck10_40         string,
        ta_cck05_40         string,
        ta_cck06a_40        string,
        ta_cck07a_40        string,
        ta_cck08a_40        string
        
        #darcy:2023/05/22 add e---
                         END RECORD

MAIN
DEFINE p_row,p_col         LIKE type_file.num5

       OPTIONS
       #FIELD ORDER FORM,                                             #依照FORM上栏位顺序跳转(默认依照INPUT顺序栏位跳转)
       INPUT NO WRAP                                                  #输入方式:不打转
       DEFER INTERRUPT                                                #截取中断键

       IF (NOT cl_user()) THEN                                        #预设部分参数(g_prog,g_user),切换使用者预设营运中心
          EXIT PROGRAM                                                #退出程序
       END IF

       WHENEVER ERROR CALL cl_err_msg_log                             #遇错则记录到log档

       IF (NOT cl_setup("CXC")) THEN                                  #预设模组参数(g_aza.*,...)权限参数,判断使用者执行权限
          EXIT PROGRAM                                                #退出程序
       END IF

       CALL cl_used(g_prog,g_time,1) RETURNING g_time                 #程式进入时间

       LET g_statebar = "Total: %1 / %2"                              #笔数显示变量定义

       LET p_row = 2 LET p_col = 2
       OPEN WINDOW q900_w AT p_row,p_col WITH FORM "cxc/42f/cxcq900"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)                   #界面Style设置(p_zz设置)

       CALL cl_ui_init()                                              #加载ToolBar、栏位中文描述、p_per/p_perlang等系统设置

#初始化单身显示
  CALL cl_set_comp_visible("ta_cck10_1,ta_cck05_1,ta_cck06a_1,ta_cck07a_1,ta_cck08a_1",FALSE)
  CALL cl_set_comp_visible("ta_cck10_2,ta_cck05_2,ta_cck06a_2,ta_cck07a_2,ta_cck08a_2",FALSE)
  CALL cl_set_comp_visible("ta_cck10_3,ta_cck05_3,ta_cck06a_3,ta_cck07a_3,ta_cck08a_3",FALSE)
  CALL cl_set_comp_visible("ta_cck10_4,ta_cck05_4,ta_cck06a_4,ta_cck07a_4,ta_cck08a_4",FALSE)
  CALL cl_set_comp_visible("ta_cck10_5,ta_cck05_5,ta_cck06a_5,ta_cck07a_5,ta_cck08a_5",FALSE)
  CALL cl_set_comp_visible("ta_cck10_6,ta_cck05_6,ta_cck06a_6,ta_cck07a_6,ta_cck08a_6",FALSE)
  CALL cl_set_comp_visible("ta_cck10_7,ta_cck05_7,ta_cck06a_7,ta_cck07a_7,ta_cck08a_7",FALSE)
  CALL cl_set_comp_visible("ta_cck10_8,ta_cck05_8,ta_cck06a_8,ta_cck07a_8,ta_cck08a_8",FALSE)
  CALL cl_set_comp_visible("ta_cck10_9,ta_cck05_9,ta_cck06a_9,ta_cck07a_9,ta_cck08a_9",FALSE)
  CALL cl_set_comp_visible("ta_cck10_10,ta_cck05_10,ta_cck06a_10,ta_cck07a_10,ta_cck08a_10",FALSE)
  CALL cl_set_comp_visible("ta_cck10_11,ta_cck05_11,ta_cck06a_11,ta_cck07a_11,ta_cck08a_11",FALSE)
  CALL cl_set_comp_visible("ta_cck10_12,ta_cck05_12,ta_cck06a_12,ta_cck07a_12,ta_cck08a_12",FALSE)
  CALL cl_set_comp_visible("ta_cck10_13,ta_cck05_13,ta_cck06a_13,ta_cck07a_13,ta_cck08a_13",FALSE)
  CALL cl_set_comp_visible("ta_cck10_14,ta_cck05_14,ta_cck06a_14,ta_cck07a_14,ta_cck08a_14",FALSE)
  CALL cl_set_comp_visible("ta_cck10_15,ta_cck05_15,ta_cck06a_15,ta_cck07a_15,ta_cck08a_15",FALSE)
  CALL cl_set_comp_visible("ta_cck10_16,ta_cck05_16,ta_cck06a_16,ta_cck07a_16,ta_cck08a_16",FALSE)
  CALL cl_set_comp_visible("ta_cck10_17,ta_cck05_17,ta_cck06a_17,ta_cck07a_17,ta_cck08a_17",FALSE)
  CALL cl_set_comp_visible("ta_cck10_18,ta_cck05_18,ta_cck06a_18,ta_cck07a_18,ta_cck08a_18",FALSE)
  CALL cl_set_comp_visible("ta_cck10_19,ta_cck05_19,ta_cck06a_19,ta_cck07a_19,ta_cck08a_19",FALSE)
  CALL cl_set_comp_visible("ta_cck10_20,ta_cck05_20,ta_cck06a_20,ta_cck07a_20,ta_cck08a_20",FALSE)
  CALL cl_set_comp_visible("ta_cck10_21,ta_cck05_21,ta_cck06a_21,ta_cck07a_21,ta_cck08a_21",FALSE)
  CALL cl_set_comp_visible("ta_cck10_22,ta_cck05_22,ta_cck06a_22,ta_cck07a_22,ta_cck08a_22",FALSE)
  CALL cl_set_comp_visible("ta_cck10_23,ta_cck05_23,ta_cck06a_23,ta_cck07a_23,ta_cck08a_23",FALSE)
  CALL cl_set_comp_visible("ta_cck10_24,ta_cck05_24,ta_cck06a_24,ta_cck07a_24,ta_cck08a_24",FALSE)
  CALL cl_set_comp_visible("ta_cck10_25,ta_cck05_25,ta_cck06a_25,ta_cck07a_25,ta_cck08a_25",FALSE)
  CALL cl_set_comp_visible("ta_cck10_26,ta_cck05_26,ta_cck06a_26,ta_cck07a_26,ta_cck08a_26",FALSE)
  CALL cl_set_comp_visible("ta_cck10_27,ta_cck05_27,ta_cck06a_27,ta_cck07a_27,ta_cck08a_27",FALSE)
  CALL cl_set_comp_visible("ta_cck10_28,ta_cck05_28,ta_cck06a_28,ta_cck07a_28,ta_cck08a_28",FALSE)
  CALL cl_set_comp_visible("ta_cck10_29,ta_cck05_29,ta_cck06a_29,ta_cck07a_29,ta_cck08a_29",FALSE)
  CALL cl_set_comp_visible("ta_cck10_30,ta_cck05_30,ta_cck06a_30,ta_cck07a_30,ta_cck08a_30",FALSE)
    #darcy:2023/05/22 add s---
    CALL cl_set_comp_visible("ta_cck10_31,ta_cck05_31,ta_cck06a_31,ta_cck07a_31,ta_cck08a_31",FALSE)
    CALL cl_set_comp_visible("ta_cck10_32,ta_cck05_32,ta_cck06a_32,ta_cck07a_32,ta_cck08a_32",FALSE)
    CALL cl_set_comp_visible("ta_cck10_33,ta_cck05_33,ta_cck06a_33,ta_cck07a_33,ta_cck08a_33",FALSE)
    CALL cl_set_comp_visible("ta_cck10_34,ta_cck05_34,ta_cck06a_34,ta_cck07a_34,ta_cck08a_34",FALSE)
    CALL cl_set_comp_visible("ta_cck10_35,ta_cck05_35,ta_cck06a_35,ta_cck07a_35,ta_cck08a_35",FALSE)
    CALL cl_set_comp_visible("ta_cck10_36,ta_cck05_36,ta_cck06a_36,ta_cck07a_36,ta_cck08a_36",FALSE)
    CALL cl_set_comp_visible("ta_cck10_37,ta_cck05_37,ta_cck06a_37,ta_cck07a_37,ta_cck08a_37",FALSE)
    CALL cl_set_comp_visible("ta_cck10_38,ta_cck05_38,ta_cck06a_38,ta_cck07a_38,ta_cck08a_38",FALSE)
    CALL cl_set_comp_visible("ta_cck10_39,ta_cck05_39,ta_cck06a_39,ta_cck07a_39,ta_cck08a_39",FALSE)
    CALL cl_set_comp_visible("ta_cck10_40,ta_cck05_40,ta_cck06a_40,ta_cck07a_40,ta_cck08a_40",FALSE)
    #darcy:2023/05/22 add e---
       
       SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
       
       LET g_action_choice = ""                                       #初始化Action执行标示
       CALL q900_menu()                                               #进入菜单

       CLOSE WINDOW q900_w                                            #关闭WINDOW

       CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #程序退出时间
END MAIN

FUNCTION q900_menu()
DEFINE l_cmd               STRING

       WHILE TRUE
             CALL q900_bp("G",ta_cck_ac)
             CASE g_action_choice
                  WHEN "query"
                       IF cl_chk_act_auth() THEN                      #判断g_user是否有执行权限
                          CALL q900_q()                               #点击"查询"或按"Q"进入此函数
                       END IF
                  WHEN "help"
                       CALL cl_show_help()                            #点击"帮助"或按"Ctrl+H"进入此函数

                  WHEN "exit"
                       EXIT WHILE                                     #点击"离开"或按"Esc"进入此函数

                  WHEN "controlg"
                       CALL cl_cmdask()                               #运行Ctrl+G窗口

                  WHEN "locale"
                       CALL cl_dynamic_locale()                       #动态转换画面语言别
                       CALL cl_show_fld_cont()                        #根据p_per设置栏位格式

                  WHEN "about"
                       CALL cl_about()                                #程式信息

                  WHEN "exporttoexcel"
                       IF cl_chk_act_auth() THEN
                          CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ta_cck),'','')
                          #点击"导出Excel"或按"E"进入此函数
                       END IF
             END CASE
       END WHILE

END FUNCTION

FUNCTION q900_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01 

       CLEAR FORM
       CALL g_ta_cck.clear()                                             #数组变量清空 
       INITIALIZE tm.* TO NULL
       DIALOG ATTRIBUTES(UNBUFFERED)
           
           INPUT BY NAME tm.yy,tm.mm

               BEFORE INPUT 
                  LET tm.yy = g_ccz.ccz01
                  LET tm.mm = g_ccz.ccz02
                  DISPLAY BY NAME tm.yy,tm.mm

               AFTER FIELD yy
                 IF NOT cl_null(tm.yy) THEN

                 END IF
                 
              AFTER FIELD mm
                 IF NOT cl_null(tm.mm) THEN
                    SELECT azm02 INTO g_azm.azm02 FROM azm_file
                      WHERE azm01 = tm.yy
                    IF g_azm.azm02 = 1 THEN
                       IF tm.mm > 12 OR tm.mm < 1 THEN
                          CALL cl_err('','agl-020',0)
                          NEXT FIELD mm
                       END IF
                    ELSE
                       IF tm.mm > 13 OR tm.mm < 1 THEN
                          CALL cl_err('','agl-020',0)
                          NEXT FIELD mm
                       END IF
                    END IF
                 END IF
                 IF cl_null(tm.mm) THEN
                    NEXT FIELD mm
                 END IF
         
           END INPUT 

           CONSTRUCT tm.wc ON ta_cck03,ta_cck11
                FROM
                              s_ta_cck[1].ta_cck03,s_ta_cck[1].ta_cck11
             BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)
           END CONSTRUCT

        ON ACTION controlp
                CASE
                   WHEN INFIELD(ta_cck03) #产品编号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ima"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ta_cck03
                        NEXT FIELD ta_cck03
                END CASE
        
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

             ON ACTION about
                CALL cl_about()

             ON ACTION help
                CALL cl_show_help()

             ON ACTION controlg
                CALL cl_cmdask()

             ON ACTION qbe_select
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)

             ON ACTION qbe_save
                CALL cl_qbe_save()

             ON ACTION accept
                EXIT DIALOG

             ON ACTION EXIT
                LET INT_FLAG = TRUE
                EXIT DIALOG

             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG
            END DIALOG
            
           IF INT_FLAG THEN
               LET INT_FLAG = 0
               RETURN
           END IF

       CALL q900_b_fill()

END FUNCTION

FUNCTION q900_q()

       CALL q900_cs()                                                 #CONSTRUCT(输入查询条件)

END FUNCTION

FUNCTION q900_bp(p_ud,i)
DEFINE p_ud                LIKE type_file.chr1
DEFINE i   LIKE type_file.num5

       IF p_ud <> "G" OR g_action_choice = "detail" THEN
          RETURN
       END IF

       LET g_action_choice = " "

       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY g_ta_cck TO s_ta_cck.* ATTRIBUTE(COUNT=ta_cck_cnt,UNBUFFERED)

               BEFORE DISPLAY
                  CALL cl_navigator_setting(g_curs_index, g_row_count)#设置ToolBar 上下笔按钮状态
                  CALL DIALOG.setArrayAttributes("s_ta_cck",g_ta_cck_attr)    #参数：屏幕变量,属性数组
                  CALL ui.Interface.refresh()
                  IF i!=0 THEN CALL fgl_set_arr_curr(i) END IF

               BEFORE ROW
                  LET ta_cck_ac = ARR_CURR()                             #获取当前光标行NO.
                  CALL cl_show_fld_cont()                             #根据p_per设置栏位格式
                  MESSAGE SFMT(g_statebar,ta_cck_ac,ta_cck_cnt)

               ON ACTION query
                  LET g_action_choice="query"
                  EXIT DISPLAY

               ON ACTION HELP
                  LET g_action_choice="help"
                  EXIT DISPLAY

               ON ACTION locale
                  LET g_action_choice="locale"

               ON ACTION EXIT
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION CANCEL
                  LET INT_FLAG=FALSE
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION CLOSE
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION controlg
                  LET g_action_choice="controlg"
                  EXIT DISPLAY

               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE DISPLAY

               ON ACTION about
                  LET g_action_choice="about"

               ON ACTION related_document
                  LET g_action_choice="related_document"
                  EXIT DISPLAY

               ON ACTION exporttoexcel
                  LET g_action_choice="exporttoexcel"
                  EXIT DISPLAY

               ON ACTION controls
                  CALL cl_set_head_visible("","AUTO")                 #隐藏单头

               AFTER DISPLAY
                     CONTINUE DISPLAY

       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION q900_b_fill()
  DEFINE l_a1,l_a2,l_a3,l_a4,l_a5   STRING
  DEFINE l_b1,l_b2,l_b3,l_b4,l_b5   STRING
  DEFINE l_c1,l_c2,l_c3,l_c4,l_c5   STRING
  DEFINE l_str                      STRING
  DEFINE l_gem02      LIKE gem_file.gem02
  DEFINE l_ta_cck04   LIKE gem_file.gem01
  DEFINE l_cnt        LIKE type_file.num5
  DEFINE l_cnt1       LIKE type_file.num5
  DEFINE l_cnt2       LIKE type_file.num5
  DEFINE l_sql        STRING

#初始化单身显示
  CALL cl_set_comp_visible("ta_cck10_1,ta_cck05_1,ta_cck06a_1,ta_cck07a_1,ta_cck08a_1",FALSE)
  CALL cl_set_comp_visible("ta_cck10_2,ta_cck05_2,ta_cck06a_2,ta_cck07a_2,ta_cck08a_2",FALSE)
  CALL cl_set_comp_visible("ta_cck10_3,ta_cck05_3,ta_cck06a_3,ta_cck07a_3,ta_cck08a_3",FALSE)
  CALL cl_set_comp_visible("ta_cck10_4,ta_cck05_4,ta_cck06a_4,ta_cck07a_4,ta_cck08a_4",FALSE)
  CALL cl_set_comp_visible("ta_cck10_5,ta_cck05_5,ta_cck06a_5,ta_cck07a_5,ta_cck08a_5",FALSE)
  CALL cl_set_comp_visible("ta_cck10_6,ta_cck05_6,ta_cck06a_6,ta_cck07a_6,ta_cck08a_6",FALSE)
  CALL cl_set_comp_visible("ta_cck10_7,ta_cck05_7,ta_cck06a_7,ta_cck07a_7,ta_cck08a_7",FALSE)
  CALL cl_set_comp_visible("ta_cck10_8,ta_cck05_8,ta_cck06a_8,ta_cck07a_8,ta_cck08a_8",FALSE)
  CALL cl_set_comp_visible("ta_cck10_9,ta_cck05_9,ta_cck06a_9,ta_cck07a_9,ta_cck08a_9",FALSE)
  CALL cl_set_comp_visible("ta_cck10_10,ta_cck05_10,ta_cck06a_10,ta_cck07a_10,ta_cck08a_10",FALSE)
  CALL cl_set_comp_visible("ta_cck10_11,ta_cck05_11,ta_cck06a_11,ta_cck07a_11,ta_cck08a_11",FALSE)
  CALL cl_set_comp_visible("ta_cck10_12,ta_cck05_12,ta_cck06a_12,ta_cck07a_12,ta_cck08a_12",FALSE)
  CALL cl_set_comp_visible("ta_cck10_13,ta_cck05_13,ta_cck06a_13,ta_cck07a_13,ta_cck08a_13",FALSE)
  CALL cl_set_comp_visible("ta_cck10_14,ta_cck05_14,ta_cck06a_14,ta_cck07a_14,ta_cck08a_14",FALSE)
  CALL cl_set_comp_visible("ta_cck10_15,ta_cck05_15,ta_cck06a_15,ta_cck07a_15,ta_cck08a_15",FALSE)
  CALL cl_set_comp_visible("ta_cck10_16,ta_cck05_16,ta_cck06a_16,ta_cck07a_16,ta_cck08a_16",FALSE)
  CALL cl_set_comp_visible("ta_cck10_17,ta_cck05_17,ta_cck06a_17,ta_cck07a_17,ta_cck08a_17",FALSE)
  CALL cl_set_comp_visible("ta_cck10_18,ta_cck05_18,ta_cck06a_18,ta_cck07a_18,ta_cck08a_18",FALSE)
  CALL cl_set_comp_visible("ta_cck10_19,ta_cck05_19,ta_cck06a_19,ta_cck07a_19,ta_cck08a_19",FALSE)
  CALL cl_set_comp_visible("ta_cck10_20,ta_cck05_20,ta_cck06a_20,ta_cck07a_20,ta_cck08a_20",FALSE)
  CALL cl_set_comp_visible("ta_cck10_21,ta_cck05_21,ta_cck06a_21,ta_cck07a_21,ta_cck08a_21",FALSE)
  CALL cl_set_comp_visible("ta_cck10_22,ta_cck05_22,ta_cck06a_22,ta_cck07a_22,ta_cck08a_22",FALSE)
  CALL cl_set_comp_visible("ta_cck10_23,ta_cck05_23,ta_cck06a_23,ta_cck07a_23,ta_cck08a_23",FALSE)
  CALL cl_set_comp_visible("ta_cck10_24,ta_cck05_24,ta_cck06a_24,ta_cck07a_24,ta_cck08a_24",FALSE)
  CALL cl_set_comp_visible("ta_cck10_25,ta_cck05_25,ta_cck06a_25,ta_cck07a_25,ta_cck08a_25",FALSE)
  CALL cl_set_comp_visible("ta_cck10_26,ta_cck05_26,ta_cck06a_26,ta_cck07a_26,ta_cck08a_26",FALSE)
  CALL cl_set_comp_visible("ta_cck10_27,ta_cck05_27,ta_cck06a_27,ta_cck07a_27,ta_cck08a_27",FALSE)
  CALL cl_set_comp_visible("ta_cck10_28,ta_cck05_28,ta_cck06a_28,ta_cck07a_28,ta_cck08a_28",FALSE)
  CALL cl_set_comp_visible("ta_cck10_29,ta_cck05_29,ta_cck06a_29,ta_cck07a_29,ta_cck08a_29",FALSE)
  CALL cl_set_comp_visible("ta_cck10_30,ta_cck05_30,ta_cck06a_30,ta_cck07a_30,ta_cck08a_30",FALSE)
    #darcy:2023/05/22 add s---
    CALL cl_set_comp_visible("ta_cck10_31,ta_cck05_31,ta_cck06a_31,ta_cck07a_31,ta_cck08a_31",FALSE)
    CALL cl_set_comp_visible("ta_cck10_32,ta_cck05_32,ta_cck06a_32,ta_cck07a_32,ta_cck08a_32",FALSE)
    CALL cl_set_comp_visible("ta_cck10_33,ta_cck05_33,ta_cck06a_33,ta_cck07a_33,ta_cck08a_33",FALSE)
    CALL cl_set_comp_visible("ta_cck10_34,ta_cck05_34,ta_cck06a_34,ta_cck07a_34,ta_cck08a_34",FALSE)
    CALL cl_set_comp_visible("ta_cck10_35,ta_cck05_35,ta_cck06a_35,ta_cck07a_35,ta_cck08a_35",FALSE)
    CALL cl_set_comp_visible("ta_cck10_36,ta_cck05_36,ta_cck06a_36,ta_cck07a_36,ta_cck08a_36",FALSE)
    CALL cl_set_comp_visible("ta_cck10_37,ta_cck05_37,ta_cck06a_37,ta_cck07a_37,ta_cck08a_37",FALSE)
    CALL cl_set_comp_visible("ta_cck10_38,ta_cck05_38,ta_cck06a_38,ta_cck07a_38,ta_cck08a_38",FALSE)
    CALL cl_set_comp_visible("ta_cck10_39,ta_cck05_39,ta_cck06a_39,ta_cck07a_39,ta_cck08a_39",FALSE)
    CALL cl_set_comp_visible("ta_cck10_40,ta_cck05_40,ta_cck06a_40,ta_cck07a_40,ta_cck08a_40",FALSE)
    #darcy:2023/05/22 add e---
  
  LET l_cnt = 1
  LET l_sql = " SELECT ta_cck03,ima02,ima021,ta_cck11,ta_cck09 "
  
  DECLARE q900_c CURSOR FOR
   SELECT UNIQUE ta_cck04 FROM ta_cck_file
    WHERE ta_cck01 = tm.yy
      AND ta_cck02 = tm.mm
    ORDER BY ta_cck04
  FOREACH q900_c INTO l_ta_cck04

    LET l_sql = l_sql CLIPPED,
    ",SUM(CASE WHEN ta_cck04 = '",l_ta_cck04,"' THEN ta_cck10 ELSE 0 END) ",
    ",SUM(CASE WHEN ta_cck04 = '",l_ta_cck04,"' THEN ta_cck05 ELSE 0 END) ",
    ",SUM(CASE WHEN ta_cck04 = '",l_ta_cck04,"' THEN ta_cck06a ELSE 0 END) ",
    ",SUM(CASE WHEN ta_cck04 = '",l_ta_cck04,"' THEN ta_cck07a ELSE 0 END) ",
    ",SUM(CASE WHEN ta_cck04 = '",l_ta_cck04,"' THEN ta_cck08a ELSE 0 END) "

    LET l_gem02 = NULL
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_ta_cck04
    IF cl_null(l_gem02) THEN LET l_gem02 = l_ta_cck04 END IF 
    LET l_a1 = l_gem02 CLIPPED,"-","单位工时"
    LET l_a2 = l_gem02 CLIPPED,"-","总工时"
    LET l_a3 = l_gem02 CLIPPED,"-","人工"
    LET l_a4 = l_gem02 CLIPPED,"-","制费"
    LET l_a5 = l_gem02 CLIPPED,"-","其它"
    IF l_cnt < 10 THEN 
       LET l_b1 = "ta_cck10_",l_cnt USING '#'
       LET l_b2 = "ta_cck05_",l_cnt USING '#'
       LET l_b3 = "ta_cck06a_",l_cnt USING '#'
       LET l_b4 = "ta_cck07a_",l_cnt USING '#'
       LET l_b5 = "ta_cck08a_",l_cnt USING '#'
    ELSE 
       LET l_b1 = "ta_cck10_",l_cnt USING '##'
       LET l_b2 = "ta_cck05_",l_cnt USING '##'
       LET l_b3 = "ta_cck06a_",l_cnt USING '##'
       LET l_b4 = "ta_cck07a_",l_cnt USING '##'
       LET l_b5 = "ta_cck08a_",l_cnt USING '##'
    END IF 
    LET l_str = l_b1 CLIPPED,",",
                l_b2 CLIPPED,",",
                l_b3 CLIPPED,",",
                l_b4 CLIPPED,",",
                l_b5 CLIPPED
    CALL cl_set_comp_att_text(l_b1,l_a1)
    CALL cl_set_comp_att_text(l_b2,l_a2)
    CALL cl_set_comp_att_text(l_b3,l_a3)
    CALL cl_set_comp_att_text(l_b4,l_a4)
    CALL cl_set_comp_att_text(l_b5,l_a5)
    CALL cl_set_comp_visible(l_str,TRUE)

    LET l_cnt = l_cnt + 1
  END FOREACH

  #LET l_cnt1 = 29 - (l_cnt - 1)  #darcy:2023/05/22 mark
  LET l_cnt1 = 39 - (l_cnt - 1)  #darcy:2023/05/22 add
  FOR l_cnt2 = 1 TO l_cnt1
    LET l_sql = l_sql CLIPPED," ,0,0,0,0,0 "
  END FOR
  
  LET l_sql = l_sql CLIPPED," FROM ta_cck_file,ima_file ",
                            "WHERE ta_cck03=ima01 AND ta_cck01 = ",tm.yy," AND ta_cck02 = ",tm.mm,
                            "  AND ",tm.wc,
                            "GROUP BY ta_cck03,ima02,ima021,ta_cck11,ta_cck09 "

  CALL g_ta_cck.clear()
  LET g_cnt = 1
  LET g_rec_b = 0
  LET l_cnt=0

#合计
    LET l_a1 = "合计" CLIPPED,"-","单位工时"
    LET l_a2 = "合计" CLIPPED,"-","总工时"
    LET l_a3 = "合计" CLIPPED,"-","人工"
    LET l_a4 = "合计" CLIPPED,"-","制费"
    LET l_a5 = "合计" CLIPPED,"-","其它"
    #darcy:2023/05/22 mod s---
    # CALL cl_set_comp_att_text("ta_cck10_30",l_a1)
    # CALL cl_set_comp_att_text("ta_cck05_30",l_a2)
    # CALL cl_set_comp_att_text("ta_cck06a_30",l_a3)
    # CALL cl_set_comp_att_text("ta_cck07a_30",l_a4)
    # CALL cl_set_comp_att_text("ta_cck08a_30",l_a5)
    # CALL cl_set_comp_visible("ta_cck10_30,ta_cck05_30,ta_cck06a_30,ta_cck07a_30,ta_cck08a_30",TRUE)

    CALL cl_set_comp_att_text("ta_cck10_40",l_a1)
    CALL cl_set_comp_att_text("ta_cck05_40",l_a2)
    CALL cl_set_comp_att_text("ta_cck06a_40",l_a3)
    CALL cl_set_comp_att_text("ta_cck07a_40",l_a4)
    CALL cl_set_comp_att_text("ta_cck08a_40",l_a5)
    CALL cl_set_comp_visible("ta_cck10_40,ta_cck05_40,ta_cck06a_40,ta_cck07a_40,ta_cck08a_40",TRUE)
    #darcy:2023/05/22 mod e---
  
  PREPARE q900_p FROM l_sql
  DECLARE q900_c1 CURSOR FOR q900_p
  FOREACH q900_c1 INTO g_ta_cck[g_cnt].*
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF

#合计
    #darcy:2023/05/22 mod 30->40 s---
    LET g_ta_cck[g_cnt].ta_cck10_40 = g_ta_cck[g_cnt].ta_cck10_1 + g_ta_cck[g_cnt].ta_cck10_2 + g_ta_cck[g_cnt].ta_cck10_3 + g_ta_cck[g_cnt].ta_cck10_4 + g_ta_cck[g_cnt].ta_cck10_5 + g_ta_cck[g_cnt].ta_cck10_6 + g_ta_cck[g_cnt].ta_cck10_7 + g_ta_cck[g_cnt].ta_cck10_8 + g_ta_cck[g_cnt].ta_cck10_9 + g_ta_cck[g_cnt].ta_cck10_10 + 
                                      g_ta_cck[g_cnt].ta_cck10_11 + g_ta_cck[g_cnt].ta_cck10_12 + g_ta_cck[g_cnt].ta_cck10_13 + g_ta_cck[g_cnt].ta_cck10_14 + g_ta_cck[g_cnt].ta_cck10_15 + g_ta_cck[g_cnt].ta_cck10_16 + g_ta_cck[g_cnt].ta_cck10_17 + g_ta_cck[g_cnt].ta_cck10_18 + g_ta_cck[g_cnt].ta_cck10_19 + g_ta_cck[g_cnt].ta_cck10_20 + 
                                      g_ta_cck[g_cnt].ta_cck10_21 + g_ta_cck[g_cnt].ta_cck10_22 + g_ta_cck[g_cnt].ta_cck10_23 + g_ta_cck[g_cnt].ta_cck10_24 + g_ta_cck[g_cnt].ta_cck10_25 + g_ta_cck[g_cnt].ta_cck10_26 + g_ta_cck[g_cnt].ta_cck10_27 + g_ta_cck[g_cnt].ta_cck10_28 + g_ta_cck[g_cnt].ta_cck10_29 
                                      + g_ta_cck[g_cnt].ta_cck10_30 + g_ta_cck[g_cnt].ta_cck10_31 + g_ta_cck[g_cnt].ta_cck10_32 + g_ta_cck[g_cnt].ta_cck10_33 + g_ta_cck[g_cnt].ta_cck10_34 + g_ta_cck[g_cnt].ta_cck10_35 + g_ta_cck[g_cnt].ta_cck10_36 + g_ta_cck[g_cnt].ta_cck10_37 + g_ta_cck[g_cnt].ta_cck10_38 + g_ta_cck[g_cnt].ta_cck10_39  #darcy:2024/02/18 add
    LET g_ta_cck[g_cnt].ta_cck05_40 = g_ta_cck[g_cnt].ta_cck05_1 + g_ta_cck[g_cnt].ta_cck05_2 + g_ta_cck[g_cnt].ta_cck05_3 + g_ta_cck[g_cnt].ta_cck05_4 + g_ta_cck[g_cnt].ta_cck05_5 + g_ta_cck[g_cnt].ta_cck05_6 + g_ta_cck[g_cnt].ta_cck05_7 + g_ta_cck[g_cnt].ta_cck05_8 + g_ta_cck[g_cnt].ta_cck05_9 + g_ta_cck[g_cnt].ta_cck05_10 + 
                                      g_ta_cck[g_cnt].ta_cck05_11 + g_ta_cck[g_cnt].ta_cck05_12 + g_ta_cck[g_cnt].ta_cck05_13 + g_ta_cck[g_cnt].ta_cck05_14 + g_ta_cck[g_cnt].ta_cck05_15 + g_ta_cck[g_cnt].ta_cck05_16 + g_ta_cck[g_cnt].ta_cck05_17 + g_ta_cck[g_cnt].ta_cck05_18 + g_ta_cck[g_cnt].ta_cck05_19 + g_ta_cck[g_cnt].ta_cck05_20 + 
                                      g_ta_cck[g_cnt].ta_cck05_21 + g_ta_cck[g_cnt].ta_cck05_22 + g_ta_cck[g_cnt].ta_cck05_23 + g_ta_cck[g_cnt].ta_cck05_24 + g_ta_cck[g_cnt].ta_cck05_25 + g_ta_cck[g_cnt].ta_cck05_26 + g_ta_cck[g_cnt].ta_cck05_27 + g_ta_cck[g_cnt].ta_cck05_28 + g_ta_cck[g_cnt].ta_cck05_29
                                      + g_ta_cck[g_cnt].ta_cck05_30 + g_ta_cck[g_cnt].ta_cck05_31 + g_ta_cck[g_cnt].ta_cck05_32 + g_ta_cck[g_cnt].ta_cck05_33 + g_ta_cck[g_cnt].ta_cck05_34 + g_ta_cck[g_cnt].ta_cck05_35 + g_ta_cck[g_cnt].ta_cck05_36 + g_ta_cck[g_cnt].ta_cck05_37 + g_ta_cck[g_cnt].ta_cck05_38 + g_ta_cck[g_cnt].ta_cck05_39  #darcy:2024/02/18 add
    LET g_ta_cck[g_cnt].ta_cck06a_40 = g_ta_cck[g_cnt].ta_cck06a_1 + g_ta_cck[g_cnt].ta_cck06a_2 + g_ta_cck[g_cnt].ta_cck06a_3 + g_ta_cck[g_cnt].ta_cck06a_4 + g_ta_cck[g_cnt].ta_cck06a_5 + g_ta_cck[g_cnt].ta_cck06a_6 + g_ta_cck[g_cnt].ta_cck06a_7 + g_ta_cck[g_cnt].ta_cck06a_8 + g_ta_cck[g_cnt].ta_cck06a_9 + g_ta_cck[g_cnt].ta_cck06a_10 + 
                                      g_ta_cck[g_cnt].ta_cck06a_11 + g_ta_cck[g_cnt].ta_cck06a_12 + g_ta_cck[g_cnt].ta_cck06a_13 + g_ta_cck[g_cnt].ta_cck06a_14 + g_ta_cck[g_cnt].ta_cck06a_15 + g_ta_cck[g_cnt].ta_cck06a_16 + g_ta_cck[g_cnt].ta_cck06a_17 + g_ta_cck[g_cnt].ta_cck06a_18 + g_ta_cck[g_cnt].ta_cck06a_19 + g_ta_cck[g_cnt].ta_cck06a_20 + 
                                      g_ta_cck[g_cnt].ta_cck06a_21 + g_ta_cck[g_cnt].ta_cck06a_22 + g_ta_cck[g_cnt].ta_cck06a_23 + g_ta_cck[g_cnt].ta_cck06a_24 + g_ta_cck[g_cnt].ta_cck06a_25 + g_ta_cck[g_cnt].ta_cck06a_26 + g_ta_cck[g_cnt].ta_cck06a_27 + g_ta_cck[g_cnt].ta_cck06a_28 + g_ta_cck[g_cnt].ta_cck06a_29
                                      + g_ta_cck[g_cnt].ta_cck06a_30 + g_ta_cck[g_cnt].ta_cck06a_31 + g_ta_cck[g_cnt].ta_cck06a_32 + g_ta_cck[g_cnt].ta_cck06a_33 + g_ta_cck[g_cnt].ta_cck06a_34 + g_ta_cck[g_cnt].ta_cck06a_35 + g_ta_cck[g_cnt].ta_cck06a_36 + g_ta_cck[g_cnt].ta_cck06a_37 + g_ta_cck[g_cnt].ta_cck06a_38 + g_ta_cck[g_cnt].ta_cck06a_39  #darcy:2024/02/18 add
    LET g_ta_cck[g_cnt].ta_cck07a_40 = g_ta_cck[g_cnt].ta_cck07a_1 + g_ta_cck[g_cnt].ta_cck07a_2 + g_ta_cck[g_cnt].ta_cck07a_3 + g_ta_cck[g_cnt].ta_cck07a_4 + g_ta_cck[g_cnt].ta_cck07a_5 + g_ta_cck[g_cnt].ta_cck07a_6 + g_ta_cck[g_cnt].ta_cck07a_7 + g_ta_cck[g_cnt].ta_cck07a_8 + g_ta_cck[g_cnt].ta_cck07a_9 + g_ta_cck[g_cnt].ta_cck07a_10 + 
                                      g_ta_cck[g_cnt].ta_cck07a_11 + g_ta_cck[g_cnt].ta_cck07a_12 + g_ta_cck[g_cnt].ta_cck07a_13 + g_ta_cck[g_cnt].ta_cck07a_14 + g_ta_cck[g_cnt].ta_cck07a_15 + g_ta_cck[g_cnt].ta_cck07a_16 + g_ta_cck[g_cnt].ta_cck07a_17 + g_ta_cck[g_cnt].ta_cck07a_18 + g_ta_cck[g_cnt].ta_cck07a_19 + g_ta_cck[g_cnt].ta_cck07a_20 + 
                                      g_ta_cck[g_cnt].ta_cck07a_21 + g_ta_cck[g_cnt].ta_cck07a_22 + g_ta_cck[g_cnt].ta_cck07a_23 + g_ta_cck[g_cnt].ta_cck07a_24 + g_ta_cck[g_cnt].ta_cck07a_25 + g_ta_cck[g_cnt].ta_cck07a_26 + g_ta_cck[g_cnt].ta_cck07a_27 + g_ta_cck[g_cnt].ta_cck07a_28 + g_ta_cck[g_cnt].ta_cck07a_29 
                                      + g_ta_cck[g_cnt].ta_cck07a_30 + g_ta_cck[g_cnt].ta_cck07a_31 + g_ta_cck[g_cnt].ta_cck07a_32 + g_ta_cck[g_cnt].ta_cck07a_33 + g_ta_cck[g_cnt].ta_cck07a_34 + g_ta_cck[g_cnt].ta_cck07a_35 + g_ta_cck[g_cnt].ta_cck07a_36 + g_ta_cck[g_cnt].ta_cck07a_37 + g_ta_cck[g_cnt].ta_cck07a_38 + g_ta_cck[g_cnt].ta_cck07a_39  #darcy:2024/02/18 add
    LET g_ta_cck[g_cnt].ta_cck08a_40 = g_ta_cck[g_cnt].ta_cck08a_1 + g_ta_cck[g_cnt].ta_cck08a_2 + g_ta_cck[g_cnt].ta_cck08a_3 + g_ta_cck[g_cnt].ta_cck08a_4 + g_ta_cck[g_cnt].ta_cck08a_5 + g_ta_cck[g_cnt].ta_cck08a_6 + g_ta_cck[g_cnt].ta_cck08a_7 + g_ta_cck[g_cnt].ta_cck08a_8 + g_ta_cck[g_cnt].ta_cck08a_9 + g_ta_cck[g_cnt].ta_cck08a_10 + 
                                      g_ta_cck[g_cnt].ta_cck08a_11 + g_ta_cck[g_cnt].ta_cck08a_12 + g_ta_cck[g_cnt].ta_cck08a_13 + g_ta_cck[g_cnt].ta_cck08a_14 + g_ta_cck[g_cnt].ta_cck08a_15 + g_ta_cck[g_cnt].ta_cck08a_16 + g_ta_cck[g_cnt].ta_cck08a_17 + g_ta_cck[g_cnt].ta_cck08a_18 + g_ta_cck[g_cnt].ta_cck08a_19 + g_ta_cck[g_cnt].ta_cck08a_20 + 
                                      g_ta_cck[g_cnt].ta_cck08a_21 + g_ta_cck[g_cnt].ta_cck08a_22 + g_ta_cck[g_cnt].ta_cck08a_23 + g_ta_cck[g_cnt].ta_cck08a_24 + g_ta_cck[g_cnt].ta_cck08a_25 + g_ta_cck[g_cnt].ta_cck08a_26 + g_ta_cck[g_cnt].ta_cck08a_27 + g_ta_cck[g_cnt].ta_cck08a_28 + g_ta_cck[g_cnt].ta_cck08a_29
                                      + g_ta_cck[g_cnt].ta_cck08a_30 + g_ta_cck[g_cnt].ta_cck08a_31 + g_ta_cck[g_cnt].ta_cck08a_32 + g_ta_cck[g_cnt].ta_cck08a_33 + g_ta_cck[g_cnt].ta_cck08a_34 + g_ta_cck[g_cnt].ta_cck08a_35 + g_ta_cck[g_cnt].ta_cck08a_36 + g_ta_cck[g_cnt].ta_cck08a_37 + g_ta_cck[g_cnt].ta_cck08a_38 + g_ta_cck[g_cnt].ta_cck08a_39  #darcy:2024/02/18 add
                                      
    #darcy:2023/05/22 mod 30->50 e---
    LET g_cnt = g_cnt + 1
  END FOREACH
  CALL g_ta_cck.deleteElement(g_cnt)
  LET g_rec_b = g_cnt - 1
  DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

