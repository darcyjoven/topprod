/*
================================================================================
檔案代號:zaa_file
檔案名稱:报表相关格式设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table zaa_file
(
zaa01       varchar2(20) NOT NULL,   /*程序编号                               */
zaa02       number(5) NOT NULL,      /*序号                                   */
zaa03       varchar2(1) NOT NULL,    /*语言别                                 */
zaa04       varchar2(10) NOT NULL,   /*用户                                   */
zaa05       number(5),               /*定位点                                 */
zaa06       varchar2(1),             /*隐藏是否                               */
zaa07       number(5),               /*字段顺序                               */
zaa08       varchar2(1500) DEFAULT ' ', /*字段内容*/
zaa09       varchar2(1),             /*类型                                   */
zaa10       varchar2(1) NOT NULL,    /*客制否                                 */
zaa11       varchar2(20) NOT NULL,   /*报表打印的样板                         */
zaa12       number(5),               /*报表打印的行数                         */
zaa13       varchar2(1),             /*字段调换否                             */
zaa14       varchar2(1),             /*字段属性                               */
zaa15       number(5),               /*行序                                   */
zaa16       varchar2(1),             /*打印备注(签核)否                       */
zaa17       varchar2(10) NOT NULL,   /*权限类型                               */
zaa18       number(5),               /*单行顺序                               */
zaa19       number(5),               /*报表左边界                             */
zaa20       number(5),               /*报表上边界                             */
zaa21       number(5),               /*报表下边界                             */
zaa22       varchar2(1)              /*No Use                                 */
);

alter table zaa_file add  constraint zaa_pk primary key  (zaa01,zaa02,zaa03,zaa04,zaa10,zaa11,zaa17) enable validate;
grant select on zaa_file to tiptopgp;
grant update on zaa_file to tiptopgp;
grant delete on zaa_file to tiptopgp;
grant insert on zaa_file to tiptopgp;
grant index on zaa_file to public;
grant select on zaa_file to ods;
