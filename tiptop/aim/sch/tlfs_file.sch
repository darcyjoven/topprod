/*
================================================================================
檔案代號:tlfs_file
檔案名稱:批号异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tlfs_file
(
tlfs01      varchar2(40),            /*料件编号                               */
tlfs02      varchar2(10),            /*仓库                                   */
tlfs03      varchar2(10),            /*库位                                   */
tlfs04      varchar2(24),            /*批号                                   */
tlfs05      varchar2(30),            /*序号                                   */
tlfs06      varchar2(30),            /*制造批号                               */
tlfs07      varchar2(4),             /*单位                                   */
tlfs08      varchar2(10),            /*类型                                   */
tlfs09      number(5),               /*异动别                                 */
tlfs10      varchar2(20),            /*单据编号                               */
tlfs11      number(5),               /*单据项次                               */
tlfs12      date,                    /*异动日期                               */
tlfs13      number(15,3),            /*异动数量                               */
tlfs14      varchar2(1),             /*归属类型                               */
tlfs15      varchar2(20),            /*归属单号                               */
tlfs111     date,                    /*单据日期                               */
tlfsplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
tlfslegal   varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on tlfs_file to tiptopgp;
grant update on tlfs_file to tiptopgp;
grant delete on tlfs_file to tiptopgp;
grant insert on tlfs_file to tiptopgp;
grant index on tlfs_file to public;
grant select on tlfs_file to ods;
