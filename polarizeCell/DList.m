function listObject = DList()

  data = cell(0);
  listObject = struct('display',@display_list,'length',@listlength,'push_front',@add_firstelement,'add_firstelements',@add_firstelements,'push_back',@add_lasttelement,...
                        'add_lasttelements',@add_lasttelements,'add_element',@add_element,'add_elements',@add_elements,'set_element',@set_element,'pop',@delete_element,'pop_front',@delete_first,...
                        'pop_back',@delete_last,'front',@GET_first,'back',@GET_last,'GET',@GET);

  function display_list
    %# Displays the data in the list
    disp(data);
  end

  function N = listlength
    %# Numbers of elements in list
    N = length(data);
  end

  function add_firstelement(datain)
    %# Add an element first
    data = [datain;data];
  end

  function add_firstelements(datain)
    %# Add many element first
    data = [datain(:);data];
  end

  function add_lasttelement(datain)
    %# Add element last
    data = [data;datain];
  end

  function add_lasttelements(datain)
    %# Add many elements last
    data = [data;datain(:)];
  end


  function add_element(datain,index)
    %# Adds a set of data values after an index in the list, or at the end
    %#   of the list if the index is larger than the number of list elements
    index = min(index,numel(data));
    data = [data(1:index) datain data(index+1:end)];
  end

  function add_elements(datain,index)
    %# Adds a set of data values after an index in the list, or at the end
    %#   of the list if the index is larger than the number of list elements
    index = min(index,numel(data));
    data = [data(1:index) datain(:) data(index+1:end)];
  end

  function set_element(datain,index)
    %# function to just change element at position index
    data{index} = datain;
  end

  function delete_element(index)
    %# Deletes an element at an index in the list
    if (index<=length(data) && index>0)
        data(index) = [];
    end
  end

  function delete_first()
    %# Deletes fisrt element
    data = data(2:end);
  end

  function delete_last()
    %# Deletes fisrt element
    data = data(1:end-1);
  end

  function dataout = GET_first()
    %# get first element
    dataout = data{1};
  end    

  function dataout = GET_last()
    %# get last element
    dataout = data{end};
  end    

  function dataout = GET(index)
    %# get element at index here the cell can be transformed to standard arrays
    dataout = cell2mat(data(index));
  end

end