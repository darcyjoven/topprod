/*
================================================================================
檔案代號:hisa_file
檔案名稱:历史资料备份计划单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hisa_file
(
hisa01      varchar2(30) DEFAULT ' ' NOT NULL, /*备份方案*/
hisa02      varchar2(30) DEFAULT ' ' NOT NULL, /*数据库名*/
hisa03      varchar2(1),             /*是否强校验                             */
hisa04      varchar2(1),             /*发生错误是否继续                       */
hisa05      varchar2(1),             /*Tar存放否                              */
hisa06      varchar2(1),             /*备份View否                             */
hisa07      varchar2(1),             /*备份Stored Procedure否                 */
hisa08      varchar2(1),             /*备份Trigger否                          */
hisa09      varchar2(1),             /*备份完成后是否删除                     */
hisa10      varchar2(1),             /*重计数据库否                           */
hisa11      varchar2(1),             /*产生Tiptop格式资料否                   */
hisa12      varchar2(1),             /*产生Oracle Sql脚本否                   */
hisa13      varchar2(1),             /*产生Informix Sql脚本否                 */
hisa14      varchar2(1),             /*产生SQL Server Sql脚本否               */
hisa15      date,                    /*备份时间                               */
hisa16      date                     /*-                                      */
);

grant select on hisa_file to tiptopgp;
grant update on hisa_file to tiptopgp;
grant delete on hisa_file to tiptopgp;
grant insert on hisa_file to tiptopgp;
grant index on hisa_file to public;
grant select on hisa_file to ods;
