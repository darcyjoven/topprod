/*
================================================================================
檔案代號:hram_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hram_file
(
hram01      varchar2(20) NOT NULL,   /*编码项目ID                             */
hram02      varchar2(20) NOT NULL,   /*所属公司编码                           */
hram03      varchar2(20),            /*编码前缀                               */
hram04      number(5),               /*流水号位数                             */
hram05      varchar2(1),             /*年度                                   */
hram06      varchar2(20),            /*年度样式                               */
hram07      varchar2(1),             /*月份                                   */
hram08      varchar2(1),             /*日                                     */
hram09      varchar2(1),             /*分隔符                                 */
hram10      varchar2(20),            /*分隔符样式                             */
hram11      varchar2(1),             /*是否可以手动修改                       */
hram12      varchar2(1),             /*是否启用                               */
hram13      varchar2(255),           /*备注                                   */
hram14      varchar2(50),            /*样例                                   */
hram15      varchar2(20),            /*流水号起始值                           */
hramacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hramuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hramgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrammodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hramdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hramoriu    varchar2(10),            /*资料建立者                             */
hramorig    varchar2(10)             /*资料建立部门                           */
);

alter table hram_file add  constraint tpc_hram_pk primary key  (hram01,hram02) enable validate;
grant select on hram_file to tiptopgp;
grant update on hram_file to tiptopgp;
grant delete on hram_file to tiptopgp;
grant insert on hram_file to tiptopgp;
grant index on hram_file to public;
grant select on hram_file to ods;
