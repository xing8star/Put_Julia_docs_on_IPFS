using IPFS
ENV["IPFS_PATH"]="$(ENV["HOME"])/.ipfs"
docsname="docs"
ipfs_docsname="julia_docs"
online_gateway=toUrl("47.121.193.1")

Base.nameof(x::AbstractIPFSObject)=(dirname ∘ name)(x)
if !isdir(docsname) mkdir(docsname) end

all_docs=readdir(docsname,join=true)

if length(all_docs)==0 exit() end



if !(ipfs_docsname in ipfs"ls")
    ipfs"mkdir julia_docs"
else
    IPFS.rm(ipfs_docsname,recursive=true)
    ipfs"mkdir julia_docs"
end
ipfs"cd julia_docs"

for i in all_docs
    IPFS.add(i,recursive=true)
end

result_link=ipfs"stat /julia_docs"
dir_links=ipfs"readdir /julia_docs"
open("index.html","a") do io
    write(io,"""<DT><a href="http://$(online_gateway(result_link))">$ipfs_docsname</a>\n""")
    for i in dir_links
        write(io,"""<DT><a href="http://$(online_gateway(i))">$(nameof(i))</a>\n""")
    end
end

open("README.md","a") do io
    write(io,"\n\n$(IPFS.cid(result_link)) - $ipfs_docsname")
    for i in dir_links
        write(io,"\n\n$(IPFS.cid(i)) - $(nameof(i))")
    end
end


