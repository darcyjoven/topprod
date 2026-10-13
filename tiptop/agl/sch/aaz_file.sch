/*
================================================================================
檔案代號:aaz_file
檔案名稱:总账会计系统参数档(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table aaz_file
(
aaz00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
aaz01       varchar2(1),             /*No Use                                 */
aaz02       varchar2(1),             /*No Use                                 */
aaz03       varchar2(1),             /*No Use                                 */
aaz04       varchar2(1),             /*No Use                                 */
aaz05       varchar2(1),             /*No Use                                 */
aaz06       varchar2(1),             /*No Use                                 */
aaz07       varchar2(1),             /*No Use                                 */
aaz08       varchar2(1),             /*No Use                                 */
aaz09       varchar2(1),             /*No Use                                 */
aaz21       number(5),               /*No Use                                 */
aaz211      varchar2(4),             /*No Use                                 */
aaz212      varchar2(8),             /*No Use                                 */
aaz22       number(5),               /*No Use                                 */
aaz221      varchar2(4),             /*No Use                                 */
aaz222      varchar2(8),             /*No Use                                 */
aaz23       number(5),               /*No Use                                 */
aaz231      varchar2(4),             /*No Use                                 */
aaz232      varchar2(8),             /*No Use                                 */
aaz24       number(5),               /*No Use                                 */
aaz241      varchar2(4),             /*No Use                                 */
aaz242      varchar2(8),             /*No Use                                 */
aaz25       number(5),               /*No Use                                 */
aaz251      varchar2(4),             /*No Use                                 */
aaz252      varchar2(8),             /*No Use                                 */
aaz26       number(5),               /*No Use                                 */
aaz31       varchar2(24),            /*损益表本期损益会计科目编号             */
aaz32       varchar2(24),            /*资产负债表本期损益类会计科             */
aaz33       varchar2(24),            /*资产负债表累计盈亏会计科目             */
aaz41       number(5),               /*No Use                                 */
aaz42       number(5),               /*No Use                                 */
aaz431      varchar2(1),             /*No Use                                 */
aaz432      varchar2(1),             /*No Use                                 */
aaz441      varchar2(1),             /*No Use                                 */
aaz442      varchar2(1),             /*No Use                                 */
aaz51       varchar2(1),             /*凭证过帐时是否生成每日余额             */
aaz61       number(5),               /*季预算的第一期分配权数                 */
aaz62       number(5),               /*季预算的第二期分配权数                 */
aaz63       number(5),               /*季预算的第三期分配权数                 */
aaz64       varchar2(5),             /*缺省帐套                               */
aaz65       varchar2(5),             /*结转用单别                             */
aaz66       varchar2(2),             /*No Use                                 */
aaz67       varchar2(6),             /*No Use                                 */
aaz68       varchar2(5),             /*应计调整用单别                         */
aaz69       varchar2(1),             /*是否将账套显示於萤幕                   */
                                     /*是否将帐套显示於萤幕(Y/N)              */
aaz70       varchar2(5),             /*凭证单别是否做用户权限控制             */
aaz71       varchar2(1),             /*凭证录入时，若借贷方不平衡             */
aaz72       varchar2(1),             /*科目部门录入控管方式                   */
aaz73       varchar2(1),             /*No Use                                 */
aaz74       varchar2(20),            /*No Use                                 */
aaz75       varchar2(1),             /*No Use                                 */
aaz76       varchar2(1),             /*No Use                                 */
aaz77       varchar2(1),             /*报表名称是否以报表结构名称             */
aaz78       varchar2(1),             /*一般凭证是否可查询已过帐凭             */
aaz79       varchar2(1),             /*No Use                                 */
aaz80       varchar2(1),             /*未打印凭证者可否过账                   */
                                     /*未打印凭证凭证者可否过帐(Y/N)          */
aaz81       varchar2(1),             /*凭证录入时是否录入总号                 */
aaz82       varchar2(1),             /*凭证打印时是否依借贷排列               */
aaz83       varchar2(1),             /*凭证过帐时是否生成外币余额             */
aaz84       varchar2(1),             /*凭证抛转还原时，还原方式               */
aaz85       varchar2(1),             /*各系统抛转凭证时是否自动审             */
aaz86       varchar2(24),            /*兑换损益科目                           */
aaz87       varchar2(24),            /*换算调整数科目                         */
aaz88       number(5),               /*科目使用异动位数(1-4)                  */
                                     /*#FUN-5C0015                            */
aaz89       varchar2(1),             /*No Use                                 */
aaz90       varchar2(1),             /*是否使用利润中心功能(Y/N)              */
aaz91       varchar2(24),            /*利润中心内部成本科目                   */
aaz92       varchar2(24),            /*利润中心内部收入科目                   */
aaz93       varchar2(1),             /*No Use                                 */
aaz94       varchar2(1),             /*No Use                                 */
aaz95       varchar2(1),             /*No Use                                 */
aaz96       varchar2(1),             /*No Use                                 */
aaz97       varchar2(1),             /*No Use                                 */
aaz98       varchar2(1),             /*No Use                                 */
aaz99       varchar2(1),             /*No Use                                 */
aaz100      varchar2(24),            /*合并销货收入科目      (关系人          */
aaz101      varchar2(24),            /*合并资产交易损益科目  (关系            */
aaz102      varchar2(24),            /*合并本期损益科目      (长期投          */
aaz103      varchar2(24),            /*合并投资收益科目      (长期投          */
aaz104      varchar2(24),            /*No Use                                 */
aaz105      varchar2(24),            /*no use                                 */
aaz106      varchar2(24),            /*no ues                                 */
aaz107      varchar2(2),             /*科目编号首段码长                       */
aaz108      varchar2(2),             /*科目编号其他段码长                     */
aaz109      varchar2(24),            /*未实现销货利益(关系人交易)             */
aaz110      varchar2(24),            /*递延贷项(关系人交易)                   */
aaz641      varchar2(5),             /*合并报表账别                           */
aaz111      varchar2(24),            /*未实现销货损失                         */
aaz112      varchar2(24),            /*递延贷项                               */
aaz113      varchar2(24),            /*本期损益（IS）                         */
aaz114      varchar2(24),            /*本期损益（BS）                         */
aaz119      varchar2(1) DEFAULT 'Y' NOT NULL, /*显示核算项名称*/
aaz115      varchar2(1) DEFAULT ' ' NOT NULL, /*凭证录入时自动按缺号产生*/
aaz120      varchar2(24),            /*再衡量兌換損失科目                     */
aaz121      varchar2(10),            /*核算项-5类型编号                       */
aaz122      varchar2(10),            /*核算项-6类型编号                       */
aaz123      varchar2(10),            /*核算项-7类型编号                       */
aaz124      varchar2(10),            /*核算项-8类型编号                       */
aaz1211     varchar2(1) DEFAULT ' ' NOT NULL, /*核算项-5录入控制*/
aaz1221     varchar2(1) DEFAULT ' ' NOT NULL, /*核算项-6录入控制*/
aaz1231     varchar2(1) DEFAULT ' ' NOT NULL, /*核算项-7录入控制*/
aaz1241     varchar2(1) DEFAULT ' ' NOT NULL, /*核算项-8录入控制*/
aaz125      number(5),               /*营运部门资讯揭露使用异动码             */
aaz126      varchar2(5),             /*表达差异调整单别(IFRS)                 */
aaz127      varchar2(5),             /*认列及衡量差异调整单别(IFRS)           */
aazud01     varchar2(255),           /*自订字段                               */
aazud02     varchar2(40),            /*自订字段                               */
aazud03     varchar2(40),            /*自订字段                               */
aazud04     varchar2(40),            /*自订字段                               */
aazud05     varchar2(40),            /*自订字段                               */
aazud06     varchar2(255),           /*自订字段                               */
aazud07     number(15,3),            /*自订字段                               */
aazud08     number(15,3),            /*自订字段                               */
aazud09     number(15,3),            /*自订字段                               */
aazud10     number(10),              /*自订字段                               */
aazud11     number(10),              /*自订字段                               */
aazud12     number(10),              /*自订字段                               */
aazud13     date,                    /*自订字段                               */
aazud14     date,                    /*自订字段                               */
aazud15     date,                    /*自订字段                               */
aaz116      varchar2(1) DEFAULT 'N' NOT NULL, /*憑證錄入時必輸欄位自動彈窗*/
aaz128      varchar2(24),            /*少数股权科目                           */
aaz129      varchar2(24),            /*少数股权净利科目                       */
aaz130      varchar2(1) DEFAULT '1' NOT NULL, /*非TIPTOP公司汇入余额类型*/
aaz131      varchar2(24),            /*累计盈亏会计科目编号                   */
aaz132      varchar2(1) DEFAULT ' ' NOT NULL, /*凭证审核是否权限控管*/
aaz642      date,                    /*合并报表关帐日                         */
aaz643      varchar2(1) DEFAULT 'Y' NOT NULL /*合并报表关帐时是否一并将个 */
);

alter table aaz_file add  constraint aaz_pk primary key  (aaz00) enable validate;
grant select on aaz_file to tiptopgp;
grant update on aaz_file to tiptopgp;
grant delete on aaz_file to tiptopgp;
grant insert on aaz_file to tiptopgp;
grant index on aaz_file to public;
grant select on aaz_file to ods;
