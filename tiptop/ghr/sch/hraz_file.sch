/*
================================================================================
檔案代號:hraz_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraz_file
(
hraz01      varchar2(20) NOT NULL,   /*单据编号                               */
hraz02      varchar2(20),            /*审核结果ID                             */
hraz03      varchar2(20) NOT NULL,   /*员工ID                                 */
hraz04      varchar2(20),            /*变动类型ID                             */
hraz05      date,                    /*生效日期                               */
hraz06      date,                    /*审核日期                               */
hraz07      varchar2(20),            /*原部门ID                               */
hraz08      varchar2(20),            /*新部门ID                               */
hraz09      varchar2(20),            /*原职位ID                               */
hraz10      varchar2(20),            /*新职位ID                               */
hraz11      varchar2(20),            /*原成本中心ID                           */
hraz12      varchar2(20),            /*新成本中心ID                           */
hraz13      varchar2(20),            /*原所属区域ID                           */
hraz14      varchar2(20),            /*新所属区域ID                           */
hraz15      varchar2(20),            /*原所属厂区ID                           */
hraz16      varchar2(20),            /*新所属厂区ID                           */
hraz17      varchar2(100),           /*备注                                   */
hraz18      varchar2(20),            /*状态ID                                 */
hraz19      date,                    /*申请操作日期                           */
hraz20      varchar2(20),            /*申请人ID                               */
hraz21      date,                    /*提交操作日期                           */
hraz22      varchar2(20),            /*提交人ID                               */
hraz23      date,                    /*审核操作日期                           */
hraz24      varchar2(20),            /*审核人ID                               */
hraz25      date,                    /*归档操作日期                           */
hraz26      varchar2(20),            /*归档人ID                               */
hraz27      date,                    /*撤销操作日期                           */
hraz28      varchar2(20),            /*撤销人ID                               */
hraz29      date,                    /*职位设立日期                           */
hraz30      varchar2(20),            /*原公司ID                               */
hraz31      varchar2(20),            /*新公司ID                               */
hraz32      varchar2(20),            /*新员工编号                             */
hraz33      varchar2(20),            /*原直接主管ID                           */
hraz34      varchar2(20),            /*现直接主管ID                           */
hraz35      varchar2(1),             /*是否ESS相关                            */
hraz36      varchar2(1),             /*是否EF相关                             */
hraz37      varchar2(50),            /*表单单号                               */
hraz38      varchar2(20),            /*原直/间接ID                            */
hraz39      varchar2(20),            /*新直/间接ID                            */
hraz40      varchar2(20),            /*原职位等级ID                           */
hraz41      varchar2(20),            /*新职位等级ID                           */
hraz42      varchar2(20),            /*更新标志                               */
hraz43      varchar2(20),            /*旧员工编号                             */
hrazacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrazuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrazgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrazmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrazdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrazoriu    varchar2(10),            /*资料建立者                             */
hrazorig    varchar2(10)             /*资料建立部门                           */
);

alter table hraz_file add  constraint tpc_hraz_pk primary key  (hraz01,hraz03) enable validate;
grant select on hraz_file to tiptopgp;
grant update on hraz_file to tiptopgp;
grant delete on hraz_file to tiptopgp;
grant insert on hraz_file to tiptopgp;
grant index on hraz_file to public;
grant select on hraz_file to ods;
