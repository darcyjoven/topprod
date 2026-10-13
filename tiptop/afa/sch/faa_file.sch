/*
================================================================================
檔案代號:faa_file
檔案名稱:固定资产系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table faa_file
(
faa00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
faa01       varchar2(1),             /*当前固定资产系统是否可放用             */
faa02p      varchar2(10),            /*总帐管理系统所在营运中心编             */
faa02b      varchar2(5),             /*总帐管理系统使用帐套编号               */
faa03       varchar2(1),             /*资产序号是否自动编号                   */
faa031      varchar2(10),            /*已用编号                               */
faa04       varchar2(1),             /*录入时,资产序号是否可空白              */
faa05       varchar2(1),             /*录入时,财产编号是否可空白              */
faa06       varchar2(1),             /*财产编号是否缺省与序号一致             */
faa07       number(5),               /*固定资产系统现行年度                   */
faa08       number(5),               /*固定资产系统现行期别                   */
faa09       date,                    /*固定资产系统关帐日期                   */
faa10       number(5),               /*No Use                                 */
faa11       number(5),               /*固定资产税签现行年度                   */
faa12       number(5),               /*固定资产税签现行期别                   */
faa13       date,                    /*固定资产税签关帐日期                   */
faa14       number(5),               /*No Use                                 */
faa15       varchar2(1),             /*固定资产入帐开始计提方式               */
faa16       varchar2(1),             /*配件与费用是否混合编号                 */
faa17       varchar2(4),             /*附属配件起始编号                       */
faa18       varchar2(4),             /*附属费用起始编号                       */
faa19       varchar2(1),             /*底稿序号是否自动编号                   */
faa191      varchar2(10),            /*已用底稿序号编号                       */
faa20       varchar2(1),             /*折旧费用科目                           */
faa21       number(5),               /*财编后几码为流水号                     */
faa22       number(5),               /*附号后几码为流水号                     */
faa23       varchar2(1),             /*当月处置是否计提折旧                   */
faa24       varchar2(1),             /*存放营运中心是否检查                   */
faa25       number(5),               /*缺省残值年限(月)                       */
faa26       varchar2(1),             /*利息资本化利率                         */
faa27       number(9,4),             /*年利率                                 */
faa28       varchar2(1),             /*资产出售汇率采用方式                   */
faa29       varchar2(1),             /*资产处置时,是否转入清理科目            */
faa30       varchar2(1),             /*已停用资产是否计提折旧                 */
faa02c      varchar2(5),             /*总帐管理系统使用帐套二编号             */
faa31       varchar2(1) DEFAULT 'N' NOT NULL, /*使用财签二功能*/
faaud01     varchar2(255),           /*自订字段                               */
faaud02     varchar2(40),            /*自订字段                               */
faaud03     varchar2(40),            /*自订字段                               */
faaud04     varchar2(40),            /*自订字段                               */
faaud05     varchar2(40),            /*自订字段                               */
faaud06     varchar2(255),           /*自订字段                               */
faaud07     number(15,3),            /*自订字段                               */
faaud08     number(15,3),            /*自订字段                               */
faaud09     number(15,3),            /*自订字段                               */
faaud10     number(10),              /*自订字段                               */
faaud11     number(10),              /*自订字段                               */
faaud12     number(10),              /*自订字段                               */
faaud13     date,                    /*自订字段                               */
faaud14     date,                    /*自订字段                               */
faaud15     date,                    /*自订字段                               */
faa072      number(5),               /*现行年度(财签二)                       */
faa082      number(5),               /*现行期别(财签二)                       */
faa092      date,                    /*财签二关帐日期                         */
faa152      varchar2(1) DEFAULT '1' NOT NULL, /*入帐开始提列方式(财签二)*/
faa232      varchar2(1) DEFAULT ' ' NOT NULL /*当月处置应提列折旧(财签二)*/
);

alter table faa_file add  constraint faa_pk primary key  (faa00) enable validate;
grant select on faa_file to tiptopgp;
grant update on faa_file to tiptopgp;
grant delete on faa_file to tiptopgp;
grant insert on faa_file to tiptopgp;
grant index on faa_file to public;
grant select on faa_file to ods;
