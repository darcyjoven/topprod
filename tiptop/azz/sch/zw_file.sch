/*
================================================================================
檔案代號:zw_file
檔案名稱:权限类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zw_file
(
zw01        varchar2(10) NOT NULL,   /*权限类型                               */
                                     /*權限類別                               */
zw02        varchar2(80),            /*权限说明                               */
                                     /*權限說明                               */
zw03        varchar2(10),            /*使用目录编号                           */
                                     /*使用目錄編號                           */
zw04        varchar2(1),             /*test                                   */
zw05        varchar2(1),             /*闲置处理                               */
zw06        number(5),               /*闲置时间(秒)                           */
zwacti      varchar2(1),             /*Active flag                            */
zwuser      varchar2(10),            /*OWNER                                  */
zwgrup      varchar2(10),            /*GROUP                                  */
zwmodu      varchar2(10),            /*MODIFY USER                            */
zwdate      date,                    /*MODIFY DATE                            */
zworig      varchar2(10),            /*资料建立部门                           */
zworiu      varchar2(10)             /*资料建立者                             */
);

alter table zw_file add  constraint zw_pk primary key  (zw01) enable validate;
grant select on zw_file to tiptopgp;
grant update on zw_file to tiptopgp;
grant delete on zw_file to tiptopgp;
grant insert on zw_file to tiptopgp;
grant index on zw_file to public;
grant select on zw_file to ods;
