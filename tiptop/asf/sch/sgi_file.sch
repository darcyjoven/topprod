/*
================================================================================
檔案代號:sgi_file
檔案名稱:工单工艺批次变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgi_file
(
sgi01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
sgi02       number(5) DEFAULT '0' NOT NULL, /*变更项次*/
sgi03       varchar2(1),             /*变更别                                 */
sgi04a      number(5),               /*工艺序号变更前                         */
sgi04b      number(5),               /*工艺序号变更后                         */
sgi05a      varchar2(6),             /*作业编号变更前                         */
sgi05b      varchar2(6),             /*作业编号变更后                         */
sgi06a      varchar2(10),            /*工作站变更前                           */
sgi06b      varchar2(10),            /*工作站变更后                           */
sgi07a      number(15,3),            /*标准工时变更前                         */
sgi07b      number(15,3),            /*标准工时变更后                         */
sgi08a      date,                    /*开工日期变更前                         */
sgi08b      date,                    /*开工日期变更后                         */
sgi09a      number(15,3),            /*固定工时变更前                         */
sgi09b      number(15,3),            /*固定工时变更后                         */
sgi10a      date,                    /*完工日期变更前                         */
sgi10b      date,                    /*完工日期变更前                         */
sgi11a      number(15,3),            /*标准机时变更前                         */
sgi11b      number(15,3),            /*标准机时变更后                         */
sgi12a      number(15,3),            /*固定机时变更前                         */
sgi12b      number(15,3),            /*固定机时变更后                         */
sgi13a      varchar2(1),
sgi13b      varchar2(1),
sgi14a      varchar2(1),             /*PQC否变更前                            */
sgi14b      varchar2(1),             /*PQC否变更后                            */
sgiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgilegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgi012a     varchar2(10),            /*变更前工艺段号                         */
sgi012b     varchar2(10)             /*变更后工艺段号                         */
);

grant select on sgi_file to tiptopgp;
grant update on sgi_file to tiptopgp;
grant delete on sgi_file to tiptopgp;
grant insert on sgi_file to tiptopgp;
grant index on sgi_file to public;
grant select on sgi_file to ods;
