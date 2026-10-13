/*
================================================================================
檔案代號:gav_file
檔案名稱:画面输出字段格式设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gav_file
(
gav01       varchar2(20) NOT NULL,   /*画面档代码                             */
gav02       varchar2(20) NOT NULL,   /*字段名称                               */
gav03       varchar2(1),             /*是否显现                               */
gav04       varchar2(1),             /*是否可录入                             */
gav05       varchar2(1),             /*No Use                                 */
gav06       varchar2(500),           /*自由设置format选项                     */
gav07       varchar2(1),             /*是否为key值字段                        */
gav08       varchar2(1) NOT NULL,    /*客制字段                               */
gav09       varchar2(1),             /*必要字段允许隐藏否                     */
gav10       varchar2(1),             /*记录是否为必要字段                     */
gav11       varchar2(10) DEFAULT ' ' NOT NULL, /*行业别代码*/
gav12       number(5),               /*字段宽度                               */
gav13       varchar2(20),            /*字段存在位置                           */
gav14       number(5),               /*字段横向起点                           */
gav15       number(5),               /*字段直向列数                           */
gav16       number(5),               /*字段录入顺序                           */
gav17       varchar2(255),           /*字段缺省值                             */
gav18       varchar2(500),           /*字段限制值                             */
gav19       varchar2(20),            /*Input时的开窗设置                      */
gav20       varchar2(80),            /*基本档资料动态检查设置                 */
gav21       varchar2(2000),          /*基本档资料SQL或函式检查设置            */
gav22       varchar2(80),            /*关联值呈现动态设置                     */
gav23       varchar2(2000),          /*关联值呈现SQL或函式设置                */
gav24       varchar2(1),             /*是否依照限制值将字段改成COMB           */
gav25       varchar2(1000),          /*限制值选单多语言设置                   */
gav26       varchar2(80),            /*资料重复动态检查设置                   */
gav27       varchar2(2000),          /*资料重复SQL或函式检查设置              */
gav28       varchar2(1),             /*基本档资料检查方式 1.动态 2.S          */
gav29       varchar2(1),             /*关联字段设置方式 1.动态 2.SQL          */
gav30       varchar2(1),             /*检查重复方式 1.动态 2.SQL 3.函         */
gav31       varchar2(20),            /*关联字段                               */
gav32       varchar2(20),            /*串查程序                               */
gav33       varchar2(1),             /*是否将字段改成CheckBox                 */
gav34       number(5),               /*字段前的Label横向起点                  */
gav35       varchar2(10),            /*no use                                 */
gav36       varchar2(1),             /*自动增加关联字段                       */
gav37       number(5),               /*关联字段起点                           */
gav38       varchar2(1),             /*no use                                 */
gav39       varchar2(20),            /*Construct时的开窗设置                  */
gav40       varchar2(10)             /*no use                                 */
);

alter table gav_file add  constraint gav_pk primary key  (gav01,gav02,gav08,gav11) enable validate;
grant select on gav_file to tiptopgp;
grant update on gav_file to tiptopgp;
grant delete on gav_file to tiptopgp;
grant insert on gav_file to tiptopgp;
grant index on gav_file to public;
grant select on gav_file to ods;
