
DATABASE ds
 
GLOBALS "../../config/top.global"

type type_oebs record
  chk            varchar(1),
  oeb01s         like oeb_file.oeb01,
  oeb03s         like oeb_file.oeb03,
  oeb04s         like oeb_file.oeb04,
  oeb05s         like oeb_file.oeb05,
  oeb06s         like oeb_file.oeb06,
  ima021s        like ima_file.ima021,
  oeb12s         like oeb_file.oeb12,
  oeb15s         like oeb_file.oeb15,
  str01          varchar(1000),
  str02          varchar(1000),
  str03          varchar(1000),
  str04          varchar(1000),
  num01          like type_file.num15_3,
  num02          like type_file.num15_3,
  num03          like type_file.num15_3,
  num04          like type_file.num15_3,
  num05          like type_file.num15_3,
  num06          like type_file.num15_3,
  num07          like type_file.num15_3,
  num08          like type_file.num15_3,
  dat01          like type_file.dat,
  dat02          like type_file.dat,
  dat03          like type_file.dat,
  dat04          like type_file.dat,
  chk01          varchar(1),
  chk02          varchar(1),
  chk03          varchar(1),
  comb01         varchar(10),
  comb02         varchar(10)
end record

#darcy:2025/04/24 add s---
define g_oebs dynamic array of type_oebs
define g_oebs_t type_oebs
#darcy:2025/04/24 add e---
# darcy:2025/08/13 add s---
define g_oeb_batch dynamic array of type_oebs
define g_oeb_batch_t type_oebs
# darcy:2025/08/13 add e---
define g_imp_result dynamic array of record
    sheet   string,
    row integer,
    col integer,
    value   string,
    style   string -- warn info mark
end record



# darcy:2025/10/23 add s---
# 导出一个料号的所有拆单明细
function t400sub_export_batch(p_wc)
   define p_wc       string
   define l_item     varchar(40)
   define l_begin    date
   define l_oeb_xlsx dynamic array of type_oebs
   define i,j integer 

   let int_flag = false
   
   open window t400_export_w at 1,1 with form "axm/42f/axmt400s"
         attribute (style = g_win_style clipped)
   
   call cl_ui_init()
   call t400sub_export_batch_init()

   # 导出
   call t400sub_export_batch_fill(p_wc)
   
   if t400sub_export_batch_bp() then
      # 导出
      let j =1
      call l_oeb_xlsx.clear()
      for i = 1 to g_oeb_batch.getlength()
         if g_oeb_batch[i].chk = 'Y' then
            let l_oeb_xlsx[j].* = g_oeb_batch[i].*
            let j = j + 1
         end if
      end for
      if l_oeb_xlsx.getlength() > 0 then 
         call cl_download_by_explorer(cl_expexcel(
            "s_oebs",base.typeinfo.create(l_oeb_xlsx),
            "",null,
            "",null
            ))
      end if
   end if

   close window t400_export_w

end function

function t400sub_export_batch_bp()
   define i,l_ac integer

   input array g_oeb_batch without defaults from s_oebs.* 
         attribute(count=g_oeb_batch.getlength(),maxcount=g_max_rec,unbuffered,
                   insert row=false,delete row=false,append row=false)
      
      before row 
         let l_ac = arr_curr() 

      after field chk
         if g_oeb_batch[l_ac].num04 <= 0 and g_oeb_batch[l_ac].chk = 'Y' then
            call cl_err('该订单无可修改数量','!',1)
            next field chk
         end if
      on change chk
         # darcy:2025/08/27 add s---
         # 将整个订单项次一起勾选
         for i = 1 to g_oeb_batch.getlength()
            if g_oeb_batch[i].oeb01s = g_oeb_batch[l_ac].oeb01s then
               let g_oeb_batch[i].chk = g_oeb_batch[l_ac].chk
            end if
         end for
         # darcy:2025/08/27 add e---
      on action accept
         exit input
      on action cancel
         exit input
      on action exit
         exit input
   end input

   if int_flag then
      let int_flag = false
      return false
   else
      return true
   end if
end function
function t400sub_export_batch_init()
   call cl_set_comp_att_text("oeb01s","订单编号")
   call cl_set_comp_att_text("oeb03s","项次")
   call cl_set_comp_att_text("num01","项序")
   call cl_set_comp_att_text("oeb04s","料号")
   call cl_set_comp_att_text("oeb12s","拆分数量")
   call cl_set_comp_att_text("oeb15s","拆分日期")
   call cl_set_comp_att_text("num02","订单总数量")
   call cl_set_comp_att_text("num03","已出货数量")
--    call cl_set_comp_att_text("num04","订单允许修改数量")
   call cl_set_comp_att_text("str01","能否修改")
   call cl_set_comp_visible("chk,oeb01s,oeb03s,num01,oeb04s,oeb12s,str01,oeb12s,oeb15s,num02,num02,num03",true)
   call cl_set_comp_entry("chk",true)
   call cl_set_comp_required("chk",true)
end function
# 查询资料
function t400sub_export_batch_fill(p_wc)
   define p_wc     string
   define l_sql    string
   define i,j      integer
   define l_oea01  varchar(40)
   define l_oeb04  varchar(40)
   define l_ship   decimal(15,3)

   let l_sql = "select 'N', oea01, oeb03, tc_oeb031, oeb04, tc_oeb12, tc_oeb16,",
               "            oeb12, nvl(oeb24_1, 0) oeb24_1",
               " from oea_file, oeb_file, tc_oeb_file",
               " left join (select oebud02 oea01_1, oeb04 oeb04_1, sum(oeb24) oeb24_1",
               "              from oea_file, oeb_file ",
               "             where oea01 = oeb01 and oea00 = '1' and oeaconf = 'Y'",
               "             group by oebud02, oeb04)",
               "   on tc_oeb01 = oea01_1 and oeb04_1 = tc_oeb04",
               " where oea01 = oeb01 and oeb03 = tc_oeb03 and oeb01 = tc_oeb01",
               "   and oea00 = '0' and oeaconf != 'X' and ", p_wc clipped ,
               "   and oeb04 not like '%.%' and oeb12 > nvl(oeb24_1, 0)",
               "   order by oeb04, tc_oeb16, oea01, oeb03, tc_oeb031"

   prepare t400sub_split_p from l_sql
   declare t400sub_split_cur cursor for t400sub_split_p

   call g_oeb_batch.clear()
   let i = 1
   foreach t400sub_split_cur
      into g_oeb_batch[i].chk,g_oeb_batch[i].oeb01s,g_oeb_batch[i].oeb03s,
           g_oeb_batch[i].num01,g_oeb_batch[i].oeb04s,g_oeb_batch[i].oeb12s,
           g_oeb_batch[i].oeb15s,g_oeb_batch[i].num02,g_oeb_batch[i].num03
      if sqlca.sqlcode then
         call cl_err("t400sub_split_cur",sqlca.sqlcode,1)
         exit foreach
      end if
      -- if l_oea01 <> g_oeb_batch[i].oeb01s or l_oeb04 <> g_oeb_batch[i].oeb04s then
      --    -- 不同订单，或者料号，重新计算已出货数量
      --    let l_ship = g_oeb_batch[i].num03
      --    let l_oea01 = g_oeb_batch[i].oeb01s
      --    let l_oeb04 = g_oeb_batch[i].oeb04s
      -- end if
      -- if l_ship > 0 then
      --    if l_ship > g_oeb_batch[i].oeb12s then
      --       let g_oeb_batch[i].num03 = g_oeb_batch[i].oeb12s
      --    else
      --       let g_oeb_batch[i].num03 = l_ship
      --    end if
      --    let l_ship = l_ship - g_oeb_batch[i].num03
      -- end if
    --   let g_oeb_batch[i].num04 = 
      if g_oeb_batch[i].num02 <= g_oeb_batch[i].num03 then
        let g_oeb_batch[i].chk = 'N'
      else 
        let g_oeb_batch[i].chk = 'Y'
      end if
      # TODO
      # 这里要新增能否修改
      let i = i + 1
   end foreach
   call g_oeb_batch.deleteElement(i)
end function
# 导入一个料号的拆单明细
function t400sub_import_split()
   define l_file        string
   define i,j,l_cnt          integer
   define l_data dynamic array with dimension 2 of string
   define l_row  record
      oeb01    like oeb_file.oeb01,
      oeb03    like oeb_file.oeb03,
      oeb031   like oeb_file.oeb03,
      oeb12    like oeb_file.oeb12,
      oeb16    date,
      rowr      integer
      end record
   define l_order  record
      oeb01    integer,
      oeb03    integer,
      oeb031   integer,
      oeb12    integer,
      oeb16    integer
      end record
   define l_sheet string

   whenever error continue

   -- 选择文件
   let l_file = cl_import_open_file()
   if cl_null(l_file) then
      return false
   end if

   -- 解析
   if not cl_import_xlsx(l_file) then
      message '解析文件失败'
      return false
   end if

   call s_showmsg_init()
   let g_success = 'Y'
   call g_imp_result.clear()

   for i = 1 to cl_import_get_sheet_count()
      -- sheet cl_import_get_sheet_name(i)
      call cl_import_get_data_by_sheet_index(i) returning l_data
      call cl_import_get_sheet_name(i) returning l_sheet
      if l_data.getlength() <= 0 then
         message '解析文件失败'
         return false
      end if
      -- 开始解析
      initialize l_order.* to null
      -- 识别列名
      for j = 1 to l_data[1].getlength()
         case l_data[1][j]
            when '订单编号'
               let l_order.oeb01 = j
            when '项次'
               let l_order.oeb03 = j
            when '项序'
               let l_order.oeb031 = j 
            when '拆分数量'
               let l_order.oeb12 = j
            when '拆分日期'
               let l_order.oeb16 = j
         end case
      end for
      -- 插入临时表
      call t400sub_import_crt_tmp()
      for j = 2 to l_data.getlength()
         let l_row.oeb01 = l_data[j][l_order.oeb01]
         let l_row.oeb03 = l_data[j][l_order.oeb03]
         let l_row.oeb031 = l_data[j][l_order.oeb031]
         let l_row.oeb12 = l_data[j][l_order.oeb12]
         let l_row.oeb16 = l_data[j][l_order.oeb16]
         let l_row.rowr = j
         let l_cnt = 0
         select count(*) into l_cnt from axmt400_imp
          where oeb01 = l_row.oeb01 and oeb03 = l_row.oeb03
            and oeb031 = l_row.oeb031
         if l_cnt > 0 then
            call t400sub_imp_result(l_sheet,j,sfmt("含有重复资料，订单：%1项次：%2项序：%3",l_row.oeb01,l_row.oeb03,l_row.oeb031))
            let g_success='N'
         end if
         insert into axmt400_imp values(
            l_row.oeb01,l_row.oeb03,l_row.oeb031,
            l_row.oeb12,l_row.oeb16,l_row.rowr)
      end for
   end for

   if g_success = 'Y' then 
      -- 更新订单明细
      call t400sub_import_upd(l_sheet)
   end if
   if g_success = 'N' then
      if g_imp_result.getLength() > 0 then
         if  cl_write(l_file,g_imp_result) then
            if cl_confirm('cxm-060') then
               call cl_download_by_explorer(l_file)
            end if
         else
            message "导出文件失败"
         end if
      end if
   end if
end function

-- 更新订单明细
function t400sub_import_upd(p_sheet)
   define p_sheet    string
   define l_sql      string
   define l_oeb   record
         oeb01    like oeb_file.oeb01,
         oeb03    like oeb_file.oeb03,
         oeb031   like oeb_file.oeb03,
         oeb12    like oeb_file.oeb12,
         oeb16    date,
         rowr      integer
      end record
   define l_oeb01    like oeb_file.oeb01
   define l_oeb03    like oeb_file.oeb03
   define l_sfbud08  like oeb_file.oeb12 
   define l_oeb12    like oeb_file.oeb12
   define l_oeb031   like oeb_file.oeb03
   define l_max_oeb031   like oeb_file.oeb03
   define l_min_oeb031   like oeb_file.oeb03
   define l_remaining_qty  like oeb_file.oeb12
   define l_msg      string`
   define l_oea02    date
   define l_tc_oeb12 like oeb_file.oeb12
   define l_tc_oeb12_1 like oeb_file.oeb12
   define l_num_chk  boolean
   define l_cnt      integer
   define l_tc_oeb record
      tc_oeb04    like tc_oeb_file.tc_oeb04,
      tc_oeb05    like tc_oeb_file.tc_oeb05,
      tc_oeb06    like tc_oeb_file.tc_oeb06,
      tc_oeb22    like tc_oeb_file.tc_oeb22,
      tc_oeb23    like tc_oeb_file.tc_oeb23,
      tc_oeb24    like tc_oeb_file.tc_oeb24,
      tc_oeb25    like tc_oeb_file.tc_oeb25,
      tc_oeb26    like tc_oeb_file.tc_oeb26,
      tc_oeb70    like tc_oeb_file.tc_oeb70,
      tc_oeb70d   like tc_oeb_file.tc_oeb70d
   end record

   let l_sql = "select unique oeb01,oeb03 from axmt400_imp",
               " order by oeb01,oeb03"
   prepare t400sub_imp_oeb from l_sql
   declare t400sub_imp_oeb_p cursor for t400sub_imp_oeb

   -- 查询工单开立数量
   let l_sql = "select oeb12, nvl(oeb24_1, 0)
                  from oea_file, oeb_file
                  left join (select oebud02 oea01_1, oeb04 oeb04_1, sum(oeb24) oeb24_1
                               from oea_file, oeb_file
                              where oea01 = oeb01 and oea00 = '1'
                                and oeaconf = 'Y' group by oebud02, oeb04)
                    on oeb01 = oea01_1 and oeb04_1 = oeb04
                where oea01 = oeb01 and oea00 = '0'"
   prepare t400sub_split_sfb from l_sql

   -- 查询订单允许修改的开始项次
   let l_sql = "select tc_oeb031,remaining_qty from (select tc_oeb01,
                  tc_oeb03, tc_oeb031, tc_oeb12, remaining_qty,
                  -- 标记第一个满足条件的行
                  ROW_NUMBER() OVER (order by tc_oeb031) as rn
                 from (select tc_oeb01, tc_oeb03, tc_oeb031, tc_oeb12, 
                              sum(tc_oeb12) OVER (order by tc_oeb031) as accum_qty,
                              -- 计算满足条件时的剩余数量
                              sum(tc_oeb12) OVER (order by tc_oeb031) - ? as remaining_qty
                         from tc_oeb_file
                        where tc_oeb01 = ? and tc_oeb03 = ? ) t
                where accum_qty >= ?)  where rn = 1 "
   prepare t400sub_split_begin from l_sql

   -- 不能修改项次遍历
   let l_sql = "select oeb01,oeb03,oeb031,oeb12,oeb16,rowr from axmt400_imp ",
               " where oeb01 = ? and oeb03 = ? and oeb031 <= ? order by oeb01,oeb03,oeb031"
   prepare t400sub_split_nook from l_sql
   declare t400sub_split_nook_p cursor for t400sub_split_nook

   -- 日期错误的明细
   let l_sql = "select oeb01,oeb03,oeb031,oeb12,oeb16,rowr from axmt400_imp ",
               " where oeb01 = ? and oeb03 = ? and oeb16 < ? order by oeb01,oeb03,oeb031"
   prepare t400sub_split_oea02 from l_sql
   declare t400sub_split_oea02_p cursor for t400sub_split_oea02

   -- 项次重复的明细资料
   let l_sql = " select oeb01,oeb03,oeb031,oeb12,oeb16,rowr from axmt400_imp ",
               " where (oeb01,oeb03,oeb031) in ( select oeb01,oeb03,oeb031 from axmt400_imp ",
               "  where oeb01 = ? and oeb03 = ?",
               " group by oeb01,oeb03,oeb031 having count(*) > 1) "
   prepare t400sub_split_repeat from l_sql
   declare t400sub_split_repeat_p cursor for t400sub_split_repeat

   foreach t400sub_imp_oeb_p into l_oeb01,l_oeb03
      if sqlca.sqlcode then
         call cl_err('t400sub_imp_oeb_p',sqlca.sqlcode,1)
         exit foreach
      end if
      -- 需要排除最大项序之后的资料
      select max(oeb031),min(oeb031) into l_max_oeb031,l_min_oeb031 from axmt400_imp
         where oeb01 = l_oeb01 and oeb03 = l_oeb03
      if cl_null(l_max_oeb031) then
         let l_max_oeb031 = 0
      end if
      if cl_null(l_min_oeb031) then
         let l_min_oeb031 = 0
      end if

      -- 1. 订单状态检查
      select count(*) into l_cnt from oea_file 
       where oeaconf <> 'X' and oea49 <> '2' and oea01 = l_oeb.oeb01
      if l_cnt > 0 then
         let l_msg = sfmt("订单：%1 已作废或者结案",l_oeb.oeb01)
         -- call t400sub_imp_result(l_sheet,l_oeb.row,sfmt("订单：%1 已作废或者结案",l_oeb.oeb01))
         let g_success= 'N'
      end if
      if g_success = 'N' then
         continue foreach
      end if
      -- 2. 检查数量是否能修改，和能修改的项次
      execute t400sub_split_sfb using l_oeb01,l_oeb03 into l_oeb12,l_sfbud08
      if l_sfbud08 >= l_oeb12 then
         let l_msg = sfmt("订单：%1 项次：%2 该项次全部转工单，不可修改",l_oeb01,l_oeb03)
         -- call t400sub_imp_result(l_sheet,l_oeb.row,
         --       sfmt("订单：%1 项次：%2 该项次全部转工单，不可修改",l_oeb01,l_oeb03))
         let g_success= 'N'
      end if
      -- 如果报错就全部写入报错信息
      if g_success = 'N' then
         foreach t400sub_split_nook_p using l_oeb01,l_oeb03,'1'
            into l_oeb.*
            if sqlca.sqlcode then
               call cl_err('t400sub_split_nook_p',sqlca.sqlcode,1)
               exit foreach
            end if
            let g_success = 'N'
            call t400sub_imp_result(p_sheet,l_oeb.rowr,l_msg)
         end foreach
      else
         -- 检查不允许修改的项次
         execute t400sub_split_begin using l_sfbud08,l_oeb01,l_oeb03,l_sfbud08
            into l_oeb031,l_remaining_qty
      
         foreach t400sub_split_nook_p using l_oeb01,l_oeb03,l_oeb031
            into l_oeb.*
            if sqlca.sqlcode then
               call cl_err('t400sub_split_nook_p',sqlca.sqlcode,1)
               exit foreach
            end if
            let g_success = 'N'
            call t400sub_imp_result(p_sheet,l_oeb.rowr,
                 sfmt("订单：%1 项次：%2 项序：%3 不能修改，项序：%4 之后才可修改",
                      l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb031,l_oeb031))
         end foreach
      end if
      if g_success = 'N' then
         continue foreach
      end if
      -- 3. 检查拆分的日期是否正确，需晚于工单日期
      select oea02 into l_oea02 from oea_file where oea01 = l_oeb01
      foreach t400sub_split_oea02_p using l_oeb01,l_oeb03,l_oea02
         into l_oeb.*
         if sqlca.sqlcode then
            call cl_err('t400sub_split_oea02_p',sqlca.sqlcode,1)
            exit foreach
         end if
         let g_success = 'N'
         call t400sub_imp_result(p_sheet,l_oeb.rowr,
               sfmt("订单：%1 项次：%2 项序：%3 日期：%4  不得早于订单日期：%5 ",
                     l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb031,l_oeb.oeb16,l_oea02))
      end foreach
      if g_success = 'N' then
         continue foreach
      end if
      -- 4. 检查拆分后的总数量是否等于订单数量
      let l_num_chk = true
      -- 导入的拆分的数量
      select sum(oeb12) into l_tc_oeb12 from axmt400_imp
       where oeb01 = l_oeb01 and oeb03 = l_oeb03 
      if l_tc_oeb12 > l_oeb12 then
         let l_num_chk = false
         let l_msg = sfmt("订单：%1 项次：%2 数量：%3 拆分后数量为：%4" ,l_oeb01,l_oeb03,l_oeb12,l_tc_oeb12)
      else
         -- 不在拆分中，但是在原订单中的数量
         -- 之后的项序不计算
         select sum(tc_oeb12) into l_tc_oeb12_1 from tc_oeb_file
          where tc_oeb01 = l_oeb01 and tc_oeb03 = l_oeb03
            and tc_oeb031 < l_min_oeb031
         if cl_null(l_tc_oeb12_1) then
            let l_tc_oeb12_1 = 0
         end if
         if l_tc_oeb12_1 + l_tc_oeb12 <> l_oeb12 then
            let l_msg = sfmt("订单：%1 项次：%2 导入的数量：%3 + 未修改数量：%4 不等于原订单数量：%5 ",
                              l_oeb01,l_oeb03,l_tc_oeb12,l_tc_oeb12_1,l_oeb12)
            let l_num_chk = false
         end if         
      end if
      -- 全部订单写上错误信息
      if not l_num_chk then
         foreach t400sub_split_nook_p using l_oeb01,l_oeb03,'1'
            into l_oeb.*
            if sqlca.sqlcode then
               call cl_err('t400sub_split_nook_p',sqlca.sqlcode,1)
               exit foreach
            end if
            let g_success = 'N'
            call t400sub_imp_result(p_sheet,l_oeb.rowr,l_msg)
         end foreach
      end if
      if g_success = 'N' then
         continue foreach
      end if
      -- 5. 检查项序，项次是否重复
      foreach t400sub_split_repeat_p using l_oeb01,l_oeb03
            into l_oeb.*
            if sqlca.sqlcode then
               call cl_err('t400sub_split_repeat_p',sqlca.sqlcode,1)
               exit foreach
            end if
            let g_success = 'N'
            call t400sub_imp_result(p_sheet,l_oeb.rowr,
                        sfmt("订单：%1 项次：%2 项序：%3 重复",l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb031))
         end foreach
   end foreach 
   -- 检查成功开始更新
   if g_success = 'N' then
      return
   end if
   -- 遍历订单
   let l_sql = "select oeb01,oeb03,oeb031,oeb12,oeb16,rowr from axmt400_imp "
   prepare t400sub_imp_axmt400 from l_sql
   declare t400sub_imp_axmt400_p cursor for t400sub_imp_axmt400

   begin work -- 开启事务
   let l_oeb01 = ""
   let l_oeb03 = 0
   foreach t400sub_imp_axmt400_p into l_oeb.*
      if sqlca.sqlcode then
         call cl_err('t400sub_imp_axmt400_p',sqlca.sqlcode,1)
         exit foreach
      end if
      -- 1. 删除项次大于本次最大项次的记录
      --    删除在本次拆分中的
      if l_oeb01 <> l_oeb.oeb01 or l_oeb03 <> l_oeb.oeb03 then
         delete from tc_oeb_file where tc_oeb01 = l_oeb.oeb01 and tc_oeb03 = l_oeb.oeb03
            and tc_oeb031 >= l_min_oeb031
         let l_oeb01 = l_oeb.oeb01
         let l_oeb03 = l_oeb.oeb03
      end if
      -- 2. 更新订单明细(应该是插入insert)
      initialize l_tc_oeb.* to null
      select oeb04,oeb05,oeb06,oeb22,oeb23,oeb24,oeb25,oeb26,oeb70,oeb70d into l_tc_oeb.*
        from oeb_file where oeb01 = l_oeb.oeb01 and oeb03 = l_oeb.oeb03
      insert into tc_oeb_file (tc_oeb01,tc_oeb03,tc_oeb031,tc_oeb04,tc_oeb05,tc_oeb06,tc_oeb12,
                               tc_oeb16,tc_oeb22,tc_oeb23,tc_oeb24,tc_oeb25,tc_oeb26,tc_oeb70,
                               tc_oeb70d,tc_oebplant,tc_oeblegal)
      values(l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb031,l_tc_oeb.tc_oeb04,l_tc_oeb.tc_oeb05,l_tc_oeb.tc_oeb06,l_oeb.oeb12,
             l_oeb.oeb16,l_tc_oeb.tc_oeb22,l_tc_oeb.tc_oeb23,l_tc_oeb.tc_oeb24,l_tc_oeb.tc_oeb25,l_tc_oeb.tc_oeb26,
             l_tc_oeb.tc_oeb70,l_tc_oeb.tc_oeb70d,g_plant,g_legal)
      if sqlca.sqlcode then
         let g_success = 'N'
         let l_msg = "ins tc_oeb_file 失败"
         exit foreach
      end if
   end foreach

   if g_success = 'Y' then
      message "批量处理完成"
      commit work
   else
      message "批量处理失败"
      call cl_err(l_msg,"!",1)
      rollback work
   end if

end function

function t400sub_import_crt_tmp()
   drop table axmt400_imp
   create temp table axmt400_imp(
      oeb01    varchar(20),
      oeb03    decimal(5),
      oeb031   decimal(5),
      oeb12    decimal(15,3),
      oeb16    date,
      rowr      decimal(5))
end function

function t400sub_imp_result(p_sheet, p_row,p_value)
    define p_sheet,p_value string
    define p_row integer
    define idx integer

    let idx = g_imp_result.getlength() + 1
    let g_imp_result[idx].sheet = p_sheet
    let g_imp_result[idx].row = p_row
    let g_imp_result[idx].col = 12
    let g_imp_result[idx].value = p_value
    let g_imp_result[idx].style = 'warn'
end function
# darcy:2025/10/23 add e---
